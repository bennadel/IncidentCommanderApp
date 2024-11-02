component
	output = false
	hint = "I provide workflow methods around incident management."
	{

	// Define properties for dependency-injection.
	property name="clock" ioc:type="core.lib.util.Clock";
	property name="incidentService" ioc:type="core.lib.model.IncidentService";
	property name="incidentValidation" ioc:type="core.lib.model.IncidentValidation";
	property name="priorityService" ioc:type="core.lib.model.PriorityService";
	property name="slugGenerator" ioc:type="core.lib.SlugGenerator";
	property name="stageService" ioc:type="core.lib.model.StageService";
	property name="markdownParser" ioc:type="core.lib.markdown.Parser";
	property name="statusService" ioc:type="core.lib.model.StatusService";
	property name="statusValidation" ioc:type="core.lib.model.StatusValidation";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I add a status update to the given incident.
	*/
	public numeric function addStatus(
		required string incidentToken,
		required numeric stageID,
		required string contentMarkdown
		) {

		var incident = getIncident( incidentToken );
		var stage = stageService.getStage( stageID );
		var contentHtml = markdownParser.toHtml( contentMarkdown );
		var createdAt = clock.utcNow();

		var statusID = statusService.createStatus(
			incidentID = incident.id,
			stageID = stage.id,
			contentMarkdown = contentMarkdown,
			contentHtml = contentHtml,
			createdAt = createdAt
		);

		return statusID;

	}


	/**
	* I delete the incident and all child status updates with the given id:slug token.
	*/
	public void function deleteIncident( required string incidentToken ) {

		var incident = getIncident( incidentToken );

		transaction {

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

		var status = getStatus( incidentToken, statusID );

		statusService.deleteStatus( status.id );

	}


	/**
	* I get the incident with the given id:slug token.
	*/
	public struct function getIncident( required string incidentToken ) {

		var incidentID = incidentToken.listFirst( "-" );
		var incidentSlug = incidentToken.listRest( "-" );
		var incident = incidentService.getIncident( incidentID );

		// Since we don't have an authentication system for users (anyone can jump in and
		// open an incident), we are using the case-sensitive slug to ensure that someone
		// isn't trying to randomly guess values.
		if ( compare( incident.slug, incidentSlug ) ) {

			incidentValidation.throwIncidentNotFoundError();

		}

		return incident;

	}


	/**
	* I get the status with the given ID and assert ownership under given incident.
	*/
	public struct function getStatus(
		required string incidentToken,
		required numeric statusID
		) {

		var incident = getIncident( incidentToken );
		var status = statusService.getStatus( statusID );

		// Ensure the status is associated with the given incident.
		if ( status.incidentID != incident.id ) {

			statusValidation.throwStatusNotFoundError();

		}

		return status;

	}


	/**
	* I start a new incident with a randomly generated slug. For security purposes, an
	* incident can only be referenced using both the id and the slug. As such, both values
	* are being returned from this method as a compound token.
	*/
	public string function startIncident(
		required string description,
		required numeric priorityID
		) {

		var priority = priorityService.getPriority( priorityID );
		var slug = slugGenerator.nextSlug();
		var createdAt = clock.utcNow();

		var incidentID = incidentService.createIncident(
			slug = slug,
			description = description,
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
		required string description,
		required string ownership,
		required numeric priorityID,
		required string ticketUrl,
		required string videoUrl
		) {

		var incident = getIncident( incidentToken );
		var priority = priorityService.getPriority( priorityID );

		incidentService.updateIncident(
			id = incident.id,
			description = description,
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
		required string contentMarkdown
		) {

		var status = getStatus( incidentToken, statusID );
		var stage = stageService.getStage( stageID );
		var contentHtml = markdownParser.toHtml( contentMarkdown );

		statusService.updateStatus(
			id = status.id,
			stageID = stage.id,
			contentMarkdown = contentMarkdown,
			contentHtml = contentHtml
		);

	}

}
