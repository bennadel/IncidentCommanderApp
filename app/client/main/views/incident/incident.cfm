<cfscript>

	param name="request.event[ 2 ]" type="string" default="settings";

	switch ( request.event[ 2 ] ) {
		case "settings":
			cfmodule( template = "./settings/settings.cfm" );
		break;
		default:
			throw(
				type = "App.Routing.Incident.InvalidEvent",
				message = "Unknown routing event."
			);
		break;
	}

	cfmodule( template = "./common/layout.cfm" );

</cfscript>
