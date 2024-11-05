<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	stageService = request.ioc.get( "core.lib.model.StageService" );
	statusService = request.ioc.get( "core.lib.model.StatusService" );
	utilities = request.ioc.get( "core.lib.util.Utilities" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	request.template.layout = "json";
	request.template.filename = "incident.json";
	request.template.primaryContent = getPayload( request.incident );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I build the export payload for the JSON export.
	* 
	* Todo: Should this be moved to a workflow? Since this is a single file download, I'm
	* not sure it merits any additional effort?
	*/
	private struct function getPayload( required struct incident ) {

		var statuses = getStatuses( incident );
		var stages = getStages();
		var stagesIndex = getStagesIndex( stages );
		var priorities = getPriorities();
		var prioritiesIndex = getPrioritiesIndex( priorities );

		return [
			"token": "#incident.id#-#incident.slug#",
			"description": incident.description,
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
						"createdAt": dateTimeFormat( status.createdAt, "iso" )
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

</cfscript>
