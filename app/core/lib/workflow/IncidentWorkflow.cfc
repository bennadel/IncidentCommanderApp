component
	output = false
	hint = "I provide workflow methods around incident management."
	{

	// Define properties for dependency-injection.
	property name="accessControl" ioc:type="core.lib.AccessControl";
	property name="clock" ioc:type="core.lib.util.Clock";
	property name="contentParser" ioc:type="core.lib.markdown.ContentParser";
	property name="incidentService" ioc:type="core.lib.model.IncidentService";
	property name="priorityService" ioc:type="core.lib.model.PriorityService";
	property name="screenshotService" ioc:type="core.lib.model.ScreenshotService";
	property name="screenshotValidation" ioc:type="core.lib.model.ScreenshotValidation";
	property name="slugGenerator" ioc:type="core.lib.SlugGenerator";
	property name="stageService" ioc:type="core.lib.model.StageService";
	property name="statusService" ioc:type="core.lib.model.StatusService";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I add a status update to the given incident.
	*/
	public numeric function addStatus(
		required string incidentToken,
		required numeric stageID,
		required string contentMarkdown,
		required string screenshotFormField
		) {

		var incident = accessControl.getIncident( incidentToken );
		var stage = stageService.getStage( stageID );
		var contentHtml = contentParser.toHtml( contentMarkdown );
		var createdAt = clock.utcNow();

		transaction {

			var statusID = statusService.createStatus(
				incidentID = incident.id,
				stageID = stage.id,
				contentMarkdown = contentMarkdown,
				contentHtml = contentHtml,
				createdAt = createdAt
			);

			if ( form[ screenshotFormField ].len() ) {

				uploadScreenshot(
					incidentID = incident.id,
					statusID = statusID,
					fileField = screenshotFormField
				);

			}

		}

		return statusID;

	}


	/**
	* I delete the incident and all child status updates with the given id:slug token.
	*/
	public void function deleteIncident( required string incidentToken ) {

		var incident = accessControl.getIncident( incidentToken );
		var screenshots = screenshotService.getScreenshotByFilter( incidentID = incident.id );

		transaction {

			// Todo: Right now, the files are all stored locally on the server, so
			// deleting them within the transaction boundary is fine. In the long-run,
			// however, if we move file storage to a remote system (like S3 or R2), we'll
			// need to use some sort of a queuing mechanism instead so that we don't have
			// to worry about API call latency and fragility.
			var screenshotsPath = expandPath( "/upload/storage/#incident.id#/" );

			if ( directoryExists( screenshotsPath ) ) {

				directoryDelete( screenshotsPath, true ); // True = recursive.

			}

			screenshotService.deleteScreenshotByFilter( incidentID = incident.id );
			statusService.deleteStatusByFilter( incidentID = incident.id );
			incidentService.deleteIncident( incident.id );

		}

	}


	/**
	* I delete the status with the given ID.
	*/
	public void function deleteStatus(
		required string incidentToken,
		required numeric statusID
		) {

		var incident = accessControl.getIncident( incidentToken );
		var status = accessControl.getStatus( incident, statusID );
		var screenshots = screenshotService.getScreenshotByFilter( statusID = status.id );

		transaction {

			// Todo: Right now, the files are all stored locally on the server, so
			// deleting them within the transaction boundary is fine. In the long-run,
			// however, if we move file storage to a remote system (like S3 or R2), we'll
			// need to use some sort of a queuing mechanism instead so that we don't have
			// to worry about API call latency and fragility.
			for ( var screenshot in screenshots ) {

				fileDelete( expandPath( "/upload/storage/#incident.id#/#screenshot.id#.upload" ) );

			}

			screenshotService.deleteScreenshotByFilter( statusID = status.id );
			statusService.deleteStatus( status.id );

		}

	}


	/**
	* I start a new incident with a randomly generated slug. For security purposes, an
	* incident can only be referenced using both the id and the slug. As such, both values
	* are being returned from this method as a compound token.
	*/
	public string function startIncident(
		required string descriptionMarkdown,
		required numeric priorityID
		) {

		var descriptionHtml = contentParser.toHtml( descriptionMarkdown );
		var priority = priorityService.getPriority( priorityID );
		var slug = slugGenerator.nextSlug();
		var createdAt = clock.utcNow();

		var incidentID = incidentService.createIncident(
			slug = slug,
			descriptionMarkdown = descriptionMarkdown,
			descriptionHtml = descriptionHtml,
			ownership = "",
			priorityID = priority.id,
			ticketUrl = "",
			videoUrl = "",
			createdAt = clock.utcNow()
		);

		return "#incidentID#-#slug#";

	}


	/**
	* I update the incident with the given token.
	*/
	public void function updateIncident(
		required string incidentToken,
		required string descriptionMarkdown,
		required string ownership,
		required numeric priorityID,
		required string ticketUrl,
		required string videoUrl
		) {

		var incident = accessControl.getIncident( incidentToken );
		var priority = priorityService.getPriority( priorityID );
		var descriptionHtml = contentParser.toHtml( descriptionMarkdown );

		incidentService.updateIncident(
			id = incident.id,
			descriptionMarkdown = descriptionMarkdown,
			descriptionHtml = descriptionHtml,
			ownership = ownership,
			priorityID = priority.id,
			ticketUrl = ticketUrl,
			videoUrl = videoUrl
		);

	}


	/**
	* I update the status with the given ID.
	*/
	public void function updateStatus(
		required string incidentToken,
		required numeric statusID,
		required numeric stageID,
		required string contentMarkdown,
		required string screenshotFormField
		) {

		var incident = accessControl.getIncident( incidentToken );
		var status = accessControl.getStatus( incident, statusID );
		var stage = stageService.getStage( stageID );
		var contentHtml = contentParser.toHtml( contentMarkdown );

		statusService.updateStatus(
			id = status.id,
			stageID = stage.id,
			contentMarkdown = contentMarkdown,
			contentHtml = contentHtml
		);

		if ( form[ screenshotFormField ].len() ) {

			uploadScreenshot(
				incidentID = incident.id,
				statusID = status.id,
				fileField = screenshotFormField
			);

		}

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I upload the screenshot in the given form field and associate with with the given
	* status update.
	* 
	* Todo: in the long-run, this should probably be in its own uploader service. But, I'm
	* keeping it here while I flesh-out the concept.
	*/
	private void function uploadScreenshot(
		required numeric incidentID,
		required numeric statusID,
		required string fileField
		) {

		var MB = ( 1024 * 1024 );
		var maxFilesize = ( MB * 3 ); // 3mb.
		// When the file is uploaded in the form POST, the file field contains the path to
		// the temporary file on the server, even before we've processed the upload. This
		// gives us a chance to validate the file-size.
		var transientFilePath = form[ fileField ];

		if ( getFileInfo( transientFilePath ).size > maxFilesize ) {

			fileDelete( transientFilePath );
			screenshotValidation.throwScreenshotTooLargeError();

		}

		// When we up load the file, were going to first upload it into a local temp
		// directory so that we can get the metadata. Then, we're going to copy it into an
		// incident-based directory.
		var tempDirectoryPath = expandPath( "/upload/temp" );
		var permDirectoryPath = expandPath( "/upload/storage/#incidentID#" );

		// Ensure that the incident-based directory exists.
		if ( ! directoryExists( permDirectoryPath ) ) {

			directoryCreate( permDirectoryPath );

		}

		// Note: This will throw an error if the file doesn't adhere to one of the given
		// mime types; but, in the UI, we're limiting the types that can be selected so
		// this check here shouldn't throw an error (and is here for security).
		var results = fileUpload(
			destination = tempDirectoryPath,
			fileField = fileField,
			mimeType = "image/png,image/jpg,image/jpeg",
			onConflict = "makeUnique"
		);

		try {

			var mimeType = lcase( "#results.contentType#/#results.contentSubtype#" );
			var createdAt = clock.utcNow();

			var screenshotID = screenshotService.createScreenshot(
				incidentID = incidentID,
				statusID = statusID,
				mimeType = mimeType,
				createdAt = createdAt
			);

			// Note: I'm saving the filename with a ".upload" extension as a security
			// measure to make sure that it can never accidentally be "executed" by
			// clicking on it. The storage directory isn't in a web-accessible location;
			// but, this I'm just being extra cautious with user-provided data.
			fileCopy(
				"#tempDirectoryPath#/#results.serverFile#",
				"#permDirectoryPath#/#screenshotID#.upload"
			);

		} finally {

			fileDelete( "#tempDirectoryPath#/#results.serverFile#" );

		}

	}

}
