<cfscript>

	accessControl = request.ioc.get( "core.lib.AccessControl" );
	authWorkflow = request.ioc.get( "client.main.lib.workflow.AuthWorkflow" );
	rateLimiter = request.ioc.get( "core.lib.RateLimiter" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
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

	// This entire subsystem MIGHT BE under password protection. If the incident has an
	// optional password attached to it, the request must authenticated.
	if ( request.incident.password.len() ) {

		if ( ! authWorkflow.canAccessIncident( request.incident ) ) {

			// Todo: in a perfect world, we'd include a redirect to get the user back to
			// the page they originally requested (after they authenticate). Since this is
			// such a tiny app, I'm going to forgo this nicety for the moment.
			requestHelper.goto([
				event: "auth",
				incidentToken: request.context.incidentToken
			]);

		}

	}

	// This subsystem allows for multiple templates.
	request.template.layout = "default";

	switch ( request.event[ 2 ] ) {
		case "delete":
			cfmodule( template = "./delete/delete.cfm" );
		break;
		case "export":
			cfmodule( template = "./export/export.cfm" );
		break;
		case "screenshot":
			cfmodule( template = "./screenshot/screenshot.cfm" );
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
