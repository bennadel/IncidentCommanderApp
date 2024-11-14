<cfscript>

	accessControl = request.ioc.get( "core.lib.AccessControl" );
	rateLimiter = request.ioc.get( "core.lib.RateLimiter" );
	requestMetadata = request.ioc.get( "core.lib.RequestMetadata" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.event[ 2 ]" type="string" default="status";
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

	// This subsystem allows for multiple templates.
	request.template.layout = "default";

	switch ( request.event[ 2 ] ) {
		case "delete":
			cfmodule( template = "./delete/delete.cfm" );
		break;
		case "export":
			cfmodule( template = "./export/export.cfm" );
		break;
		case "screenshotImage":
			cfmodule( template = "./screenshotImage/screenshotImage.cfm" );
		break;
		case "settings":
			cfmodule( template = "./settings/settings.cfm" );
		break;
		case "share":
			cfmodule( template = "./share/share.cfm" );
		break;
		case "status":
			cfmodule( template = "./status/status.cfm" );
		break;
		default:
			throw(
				type = "App.Routing.Incident.InvalidEvent",
				message = "Unknown routing event."
			);
		break;
	}

	switch ( request.template.layout ) {
		case "binary":
			cfmodule( template = "./common/layout/binary/binary.cfm" );
		break;
		case "default":
			cfmodule( template = "./common/layout/default/default.cfm" );
		break;
		case "json":
			cfmodule( template = "./common/layout/json/json.cfm" );
		break;
		case "notModified":
			cfmodule( template = "./common/layout/notModified/notModified.cfm" );
		break;
		default:
			throw(
				type = "InvalidLayout",
				message = "Unknown layout type."
			);
		break;
	}

</cfscript>
