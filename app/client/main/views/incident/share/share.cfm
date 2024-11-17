<cfscript>

	clock = request.ioc.get( "core.lib.util.Clock" );
	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	relativeDateFormatter = request.ioc.get( "core.lib.RelativeDateFormatter" );
	screenshotService = request.ioc.get( "core.lib.model.ScreenshotService" );
	stageService = request.ioc.get( "core.lib.model.StageService" );
	statusService = request.ioc.get( "core.lib.model.StatusService" );
	utilities = request.ioc.get( "core.lib.util.Utilities" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.sort" type="string" default="desc";

	title = "Incident Timeline";
	statuses = getStatuses( request.incident );
	statusesSorted = getStatusesSorted( statuses, request.context.sort );
	stages = getStages();
	stagesIndex = getStagesIndex( stages );
	priorities = getPriorities();
	prioritiesIndex = getPrioritiesIndex( priorities );
	screenshots = getScreenshots( request.incident );
	screenshotsIndex = getScreenshotsIndex( screenshots );
	mostRecentStage = getMostRecentStage( statuses, stagesIndex );
	useRelativeDates = getUseRelativeDates( request.incident, statuses );

	request.template.activeNavItem = "share";
	request.template.title = title;

	include "./share.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the most recent stage recorded in the investigation.
	*/
	private string function getMostRecentStage(
		required array statuses,
		required struct stagesIndex
		) {

		if ( statuses.len() ) {

			return stagesIndex[ statuses.last().stageID ].name;

		}

		return stages.first().name;

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

		// Note: statuses are always returned in ASC order from database.
		return statusService.getStatusByFilter( incidentID = incident.id );

	}


	/**
	* I get the status updates sorted in the given directions.
	*/
	private array function getStatusesSorted(
		required array statuses,
		required string sort
		) {

		var sorted = utilities.arrayCopy( statuses );

		if ( sort == "asc" ) {

			return sorted;

		}

		return sorted.sort(
				( a, b ) => {

					return sgn( b.id - a.id );

				}
			)
		;

	}


	/**
	* I determine if relative dates should be used in the rendering of the timeline. While
	* in the midst of the fight, relative might be nice. However, if someone wants to
	* render this timeline at a much later time, the relativity loses its charm.
	*/
	private boolean function getUseRelativeDates(
		required struct incident,
		required array statuses
		) {

		var recentDate = statuses.len()
			? statuses.last().createdAt
			: incident.createdAt
		;

		return ( recentDate.diff( "h", clock.utcNow() ) <= 48 );

	}

</cfscript>
