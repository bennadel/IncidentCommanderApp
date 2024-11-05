<cfscript>

	param name="request.event[ 3 ]" type="string" default="form";

	request.template.activeNavItem = "export";

	switch ( request.event[ 3 ] ) {
		case "form":
			cfmodule( template = "./form/form.cfm" );
		break;
		case "json":
			cfmodule( template = "./json/json.cfm" );
		break;
		default:
			throw(
				type = "App.Routing.Incident.Export.InvalidEvent",
				message = "Unknown routing event."
			);
		break;
	}

</cfscript>
