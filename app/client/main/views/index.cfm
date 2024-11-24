<cfscript>

	errorService = request.ioc.get( "core.lib.ErrorService" );
	xsrfService = request.ioc.get( "client.main.lib.XsrfService" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	request.template = {
		statusCode: 200,
		statusText: "OK"
	};

	try {

		param name="request.event[ 1 ]" type="string" default="start";
		param name="form.submitted" type="boolean" default=false;

		request.xsrfToken = xsrfService.ensureCookie();

		// All form submissions must include a valid XSRF token.
		if ( form.submitted ) {

			xsrfService.testRequest();

		}

		switch ( request.event[ 1 ] ) {
			case "auth":
				cfmodule( template = "./auth/auth.cfm" );
			break;
			case "incident":
				cfmodule( template = "./incident/incident.cfm" );
			break;
			case "start":
				cfmodule( template = "./start/start.cfm" );
			break;
			default:
				throw(
					type = "App.Routing.InvalidEvent",
					message = "Unknown routing event."
				);
			break;
		}

	// Note: Since this try/catch is happening in the index file, we know that the
	// application has, at the very least, successfully bootstrapped and that we have
	// access to all of the application-scoped services.
	} catch ( any error ) {

		cfmodule(
			template = "./error/error.cfm",
			error = error
		);

	}

</cfscript>
