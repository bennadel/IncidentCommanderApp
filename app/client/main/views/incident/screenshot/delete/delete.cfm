<cfscript>

	accessControl = request.ioc.get( "core.lib.AccessControl" );
	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	statusService = request.ioc.get( "core.lib.model.StatusService" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.screenshotID" type="numeric" default=0;

	screenshot = getScreenshot( request.incident, request.context.screenshotID );
	status = getStatus( screenshot );
	title = "Delete Screenshot";
	errorResponse = "";

	request.template.title = title;

	if ( form.submitted ) {

		try {

			incidentWorkflow.deleteScreenshot( request.context.incidentToken, screenshot.id );

			requestHelper.goto([
				event: "incident.status.list",
				incidentToken: request.context.incidentToken,
				flash: "incident.screenshot.deleted"
			]);

		} catch ( any error ) {

			errorResponse = requestHelper.processError( error );

		}

	}

	include "./delete.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the screenshot with the given ID.
	*/
	private struct function getScreenshot(
		required struct incident,
		required numeric screenshotID
		) {

		return accessControl.getScreenshot( incident, val( screenshotID ) );

	}


	/**
	* I get the status update for the given screenshot.
	*/
	private struct function getStatus( required struct screenshot ) {

		return statusService.getStatus( screenshot.statusID );

	}

</cfscript>
