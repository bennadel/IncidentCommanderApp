<cfscript>

	accessControl = request.ioc.get( "core.lib.AccessControl" );
	rateLimiter = request.ioc.get( "core.lib.RateLimiter" );
	requestMetadata = request.ioc.get( "core.lib.RequestMetadata" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.event[ 2 ]" type="string" default="form";
	param name="request.context.incidentToken" type="string" default="";

	rateLimiter.testRequest(
		featureID = "incident-by-all",
		windowID = "all"
	);
	rateLimiter.testRequest(
		featureID = "incident-by-ip",
		windowID = requestMetadata.getIpAddress()
	);

	// This entire subsystem requires an incident.
	request.incident = accessControl.getIncident( request.context.incidentToken );

	switch ( request.event[ 2 ] ) {
		case "form":
			cfmodule( template = "./form/form.cfm" );
		break;
		default:
			throw(
				type = "App.Routing.Auth.InvalidEvent",
				message = "Unknown routing event."
			);
		break;
	}

	cfmodule( template = "./common/layout.cfm" );

</cfscript>
