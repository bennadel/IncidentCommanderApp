<cfscript>

	accessControl = request.ioc.get( "core.lib.AccessControl" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.event[ 2 ]" type="string" default="status";
	param name="request.context.incidentToken" type="string" default="";

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
		case "default":
			cfmodule( template = "./common/layout/default/default.cfm" );
		break;
		case "json":
			cfmodule( template = "./common/layout/json/json.cfm" );
		break;
		default:
			throw(
				type = "App.InvalidLayout",
				message = "Unknown layout type."
			);
		break;
	}

</cfscript>
