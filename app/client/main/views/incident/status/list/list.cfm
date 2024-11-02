<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	stageService = request.ioc.get( "core.lib.model.StageService" );
	statusService = request.ioc.get( "core.lib.model.StatusService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	ui = request.ioc.get( "client.main.lib.ViewHelper" );
	utilities = request.ioc.get( "core.lib.util.Utilities" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.sort" type="string" default="desc";
	param name="form.stageID" type="numeric" default=0;
	param name="form.contentMarkdown" type="string" default="";

	statuses = getStatuses( request.incident );
	sortedStatuses = getSortedStatuses( statuses, request.context.sort );
	stages = getStages();
	stagesIndex = getStagesIndex( stages );
	title = "Status Updates";
	pageUrl = "/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#";
	errorMessage = "";

	if ( form.submitted ) {

		try {

			incidentWorkflow.addStatus(
				incidentToken = request.context.incidentToken,
				stageID = val( form.stageID ),
				contentMarkdown = form.contentMarkdown.trim()
			);

			requestHelper.goto({
				event: "incident.status.list",
				incidentToken: request.context.incidentToken
			});

		} catch ( any error ) {

			errorMessage = requestHelper.processError( error );

		}

	} else {

		// Default to the most recently-used stage.
		form.stageID = statuses.len()
			? statuses.last().stageID
			: stages.first().id
		;

	}

	include "./list.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the statuses, sorted in the given direction.
	*/
	private array function getSortedStatuses(
		required array statuses,
		required string sort
		) {

		if ( ! statuses.len() ) {

			return [];

		}

		return statuses
			.slice( 1 )
			.sort(
				( a, b ) => {

					if ( sort == "desc" ) {

						return sgn( b.id - a.id );

					} else {

						return sgn( a.id - b.id );

					}

				}
			)
		;

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

		return statusService.getStatusByFilter( incidentID = incident.id );

	}

</cfscript>
