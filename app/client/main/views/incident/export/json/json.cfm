<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	screenshotService = request.ioc.get( "core.lib.model.ScreenshotService" );
	stageService = request.ioc.get( "core.lib.model.StageService" );
	statusService = request.ioc.get( "core.lib.model.StatusService" );
	utilities = request.ioc.get( "core.lib.util.Utilities" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	request.template.layout = "json";
	request.template.filename = getFilename( request.incident );
	request.template.primaryContent = getPrimaryContent( request.incident );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I build the filename to be used as the JSON export.
	*/
	private string function getFilename( required struct incident ) {

		return "incident-#dateFormat( incident.createdAt, 'yyyy-mm-dd' )#.json";

	}


	/**
	* I build the export payload for the JSON export.
	* 
	* Todo: Should this be moved to a workflow? Since this is a single file download, I'm
	* not sure it merits any additional effort?
	*/
	private struct function getPrimaryContent( required struct incident ) {

		// Todo: All of this logic should be moved to an exporter class, especially now
		// that images are being serialized and embedded within the JSON. This is too much
		// logic for a controller to own.

		var statuses = getStatuses( incident );
		var stages = getStages();
		var stagesIndex = getStagesIndex( stages );
		var priorities = getPriorities();
		var prioritiesIndex = getPrioritiesIndex( priorities );
		var screenshots = getScreenshots( incident );
		var screenshotsIndex = getScreenshotsIndex( screenshots );

		return [
			"token": "#incident.id#-#incident.slug#",
			"descriptionMarkdown": incident.descriptionMarkdown,
			"descriptionHtml": incident.descriptionHtml,
			"ownership": incident.ownership,
			"priority": [
				"name": prioritiesIndex[ incident.priorityID ].name,
				"description": prioritiesIndex[ incident.priorityID ].description
			],
			"ticketUrl": incident.ticketUrl,
			"videoUrl": incident.videoUrl,
			"createdAt": dateTimeFormat( incident.createdAt, "iso" ),
			"statusUpdates": statuses.map(
				( status ) => {

					return [
						"stage": stagesIndex[ status.stageID ].name,
						"contentMarkdown": status.contentMarkdown,
						"contentHtml": status.contentHtml,
						"createdAt": dateTimeFormat( status.createdAt, "iso" ),
						"screenshots": serializeScreenshots( screenshotsIndex, status.id )
					];

				}
			)
		];

	}


	/**
	* I get the list of incident priorities.
	*/
	private array function getPriorities() {

		return priorityService.getPriorityByFilter();

	}


	/**
	* I get the priorities index by ID.
	*/
	private struct function getPrioritiesIndex( required array priorities ) {

		return utilities.indexBy( priorities, "id" );

	}


	/**
	* I get the screenshots for the given incident.
	*/
	private array function getScreenshots( required struct incident ) {

		return screenshotService
			.getScreenshotByFilter( incidentID = incident.id )
			.sort(
				( a, b ) => {

					return sgn( a.id - b.id ); // Oldest first.

				}
			)
		;

	}


	/**
	* I get the screenshots by status ID.
	*/
	private struct function getScreenshotsIndex( required array screenshots ) {

		return utilities.groupBy( screenshots, "statusID" );

	}


	/**
	* I get the incident states.
	*/
	private array function getStages() {

		return stageService.getStageByFilter();

	}


	/**
	* I get the stages index by ID.
	*/
	private struct function getStagesIndex( required array stages ) {

		return utilities.indexBy( stages, "id" );

	}


	/**
	* I get the status updates for the given incident.
	*/
	private array function getStatuses( required struct incident ) {

		return statusService
			.getStatusByFilter( incidentID = incident.id )
			.sort(
				( a, b ) => {

					return sgn( a.id - b.id ); // Oldest first.

				}
			)
		;

	}


	/**
	* I serialize the given screenshots for embedding with the JSON export.
	*/
	private array function serializeScreenshots(
		required struct screenshotsIndex,
		required numeric statusID
		) {

		if ( ! screenshotsIndex.keyExists( statusID ) ) {

			return [];

		}

		return screenshotsIndex[ statusID ].map(
			( screenshot ) => {

				var encodedBytes = binaryEncode(
					fileReadBinary( expandPath( "/upload/storage/#screenshot.incidentID#/#screenshot.id#.upload" ) ),
					"base64"
				);

				return {
					"mimeType": screenshot.mimeType,
					"dataUrl": "data:#screenshot.mimeType#;base64,#encodedBytes#"
				};

			}
		);

	}

</cfscript>
