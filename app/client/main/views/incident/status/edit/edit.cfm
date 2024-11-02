<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	stageService = request.ioc.get( "core.lib.model.StageService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	ui = request.ioc.get( "client.main.lib.ViewHelper" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.statusID" type="numeric" default=0;
	param name="form.stageID" type="numeric" default=0;
	param name="form.contentMarkdown" type="string" default="";

	status = getStatus( request.context.incidentToken, val( request.context.statusID ) );
	stages = getStages();
	title = "Edit Status";
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

		form.stageID = status.stageID;
		form.contentMarkdown = status.contentMarkdown;

	}

	include "./edit.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the incident states.
	*/
	private array function getStages() {

		return stageService.getStageByFilter();

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
