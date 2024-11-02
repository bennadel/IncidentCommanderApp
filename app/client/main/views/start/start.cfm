<cfscript>

	param name="request.event[ 2 ]" type="string" default="form";

	switch ( request.event[ 2 ] ) {
		case "form":
			cfmodule( template = "./form/form.cfm" );
		break;
		default:
			throw(
				type = "App.Routing.Start.InvalidEvent",
				message = "Unknown routing event."
			);
		break;
	}

	cfmodule( template = "./common/layout.cfm" );

</cfscript>
