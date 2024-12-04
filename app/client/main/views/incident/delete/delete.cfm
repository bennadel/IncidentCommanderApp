<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	ui = request.ioc.get( "client.main.lib.ViewHelper" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	title = "Delete Incident";
	errorResponse = "";

	request.template.activeNavItem = "delete";
	request.template.title = title;

	if ( form.submitted ) {

		try {

			incidentWorkflow.deleteIncident( request.context.incidentToken );

			requestHelper.goto([
				event: "start",
				flash: "incident.deleted"
			]);

		} catch ( any error ) {

			errorResponse = requestHelper.processError( error );

		}

	}

	include "./delete.view.cfm";

</cfscript>
