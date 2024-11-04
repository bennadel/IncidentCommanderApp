<cfscript>

	accessControl = request.ioc.get( "core.lib.AccessControl" );
	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	stageService = request.ioc.get( "core.lib.model.StageService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	utilities = request.ioc.get( "core.lib.util.Utilities" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.statusID" type="numeric" default=0;

	status = accessControl.getStatus( request.incident, val( request.context.statusID ) );
	stage = getStage( status );
	title = "Delete Status Update";
	errorMessage = "";

	request.template.title = title;

	if ( form.submitted ) {

		try {

			incidentWorkflow.deleteStatus(
				incidentToken = request.context.incidentToken,
				statusID = status.id
			);

			requestHelper.goto({
				event: "incident.status.list",
				incidentToken: request.context.incidentToken
			});

		} catch ( any error ) {

			errorMessage = requestHelper.processError( error );

		}

	}

	include "./delete.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the stage for the given status.
	*/
	private struct function getStage( required struct status ) {

		var stageIndex = utilities.indexBy( stageService.getStageByFilter(), "id" );

		return stageIndex[ status.stageID ];

	}

</cfscript>
