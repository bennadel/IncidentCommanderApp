<cfscript>

	authWorkflow = request.ioc.get( "client.main.lib.workflow.AuthWorkflow" );
	rateLimiter = request.ioc.get( "core.lib.RateLimiter" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	xsrfService = request.ioc.get( "client.main.lib.XsrfService" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="form.password" type="string" default="";

	title = "Enter Password";
	errorMessage = "";

	request.template.title = title;

	if ( form.submitted ) {

		try {

			rateLimiter.testRequest(
				featureID = "auth-by-id",
				windowID = request.incident.id
			);

			authWorkflow.authorizeIncident(
				incident = request.incident,
				password = form.password.trim()
			);

			xsrfService.cycleCookie();

			requestHelper.goto([
				event: "incident.status.list",
				incidentToken: request.context.incidentToken
			]);

		} catch ( any error ) {

			errorMessage = requestHelper.processError( error );

		}

	}

	include "./form.view.cfm";

</cfscript>
