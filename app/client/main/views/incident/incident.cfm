<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.event[ 2 ]" type="string" default="settings";
	param name="request.context.incidentToken" type="string" default="";

	// This entire subsystem requires an incident.
	request.incident = getIncident( request.context.incidentToken );

	switch ( request.event[ 2 ] ) {
		case "settings":
			cfmodule( template = "./settings/settings.cfm" );
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

	cfmodule( template = "./common/layout.cfm" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the incident with the given token.
	*/
	private function getIncident( required string incidentToken ) {

		return incidentWorkflow.getIncident( incidentToken );

	}

</cfscript>
