<cfscript>

	param name="request.event[ 3 ]" type="string" default="";

	request.template.activeNavItem = "status";

	switch ( request.event[ 3 ] ) {
		case "delete":
			cfmodule( template = "./delete/delete.cfm" );
		break;
		case "image":
			cfmodule( template = "./image/image.cfm" );
		break;
		default:
			throw(
				type = "App.Routing.Incident.Screenshot.InvalidEvent",
				message = "Unknown routing event."
			);
		break;
	}

</cfscript>
