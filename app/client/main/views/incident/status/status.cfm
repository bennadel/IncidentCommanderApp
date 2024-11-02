<cfscript>

	param name="request.event[ 3 ]" type="string" default="list";

	request.template.activeNavItem = "status";

	switch ( request.event[ 3 ] ) {
		case "delete":
			cfmodule( template = "./delete/delete.cfm" );
		break;
		case "edit":
			cfmodule( template = "./edit/edit.cfm" );
		break;
		case "list":
			cfmodule( template = "./list/list.cfm" );
		break;
		default:
			throw(
				type = "App.Routing.Incident.Status.InvalidEvent",
				message = "Unknown routing event."
			);
		break;
	}

</cfscript>
