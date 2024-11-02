<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	stageService = request.ioc.get( "core.lib.model.StageService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	utilities = request.ioc.get( "core.lib.util.Utilities" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.statusID" type="numeric" default=0;

	status = getStatus( request.context.incidentToken, val( request.context.statusID ) );
	stage = getStage( status );
	title = "Delete Status";
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


	/**
	* I get the status with the given ID.
	*/
	private struct function getStatus(
		required string incidentToken,
		required numeric statusID
		) {

		return incidentWorkflow.getStatus( incidentToken, statusID );

	}

</cfscript>
