<cfscript>

	authWorkflow = request.ioc.get( "client.main.lib.workflow.AuthWorkflow" );
	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	passwordEncoder = request.ioc.get( "core.lib.PasswordEncoder" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="form.password" type="string" default="";

	title = "Incident Password";
	errorResponse = "";

	request.template.activeNavItem = "password";
	request.template.title = title;

	if ( form.submitted ) {

		try {

			incidentWorkflow.updatePassword(
				incidentToken = request.context.incidentToken,
				password = form.password.trim()
			);

			// If the user is setting a password, we have to add the current incident ID
			// to the access credentials so that we don't immediately turn around and send
			// this user to the authentication form.
			// --
			// Note to self: it may seem strange to spread the incident settings update
			// (above) and the access control update (below) across two different
			// workflows. But, it's important to remember that the core workflow doesn't
			// know anything about this web client. And, it shouldn't be concerned with
			// anything other than the ID-based access.
			authWorkflow.ensureAccess( request.incident );

			flashType = form.password.trim().len()
				? "incident.password.updated"
				: "incident.password.removed"
			;
			requestHelper.goto([
				event: "incident.status.list",
				incidentToken: request.context.incidentToken,
				flash: flashType
			]);

		} catch ( any error ) {

			errorResponse = requestHelper.processError( error );

		}

	} else {
		form.password = passwordEncoder.decode( request.incident.password );

	}

	include "./password.view.cfm";

</cfscript>
