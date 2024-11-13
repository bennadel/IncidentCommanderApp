<cfscript>

	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	screenshotService = request.ioc.get( "core.lib.model.ScreenshotService" );
	stageService = request.ioc.get( "core.lib.model.StageService" );
	statusService = request.ioc.get( "core.lib.model.StatusService" );
	utilities = request.ioc.get( "core.lib.util.Utilities" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	title = "Incident Timeline";
	statuses = getStatuses( request.incident );
	stages = getStages();
	stagesIndex = getStagesIndex( stages );
	priorities = getPriorities();
	prioritiesIndex = getPrioritiesIndex( priorities );
	screenshots = getScreenshots( request.incident );
	screenshotsIndex = getScreenshotsIndex( screenshots );

	request.template.activeNavItem = "share";
	request.template.title = title;

	include "./share.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

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
	* I get the screenshots for the given index.
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

</cfscript>
