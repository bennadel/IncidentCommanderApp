<cfscript>

	workflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );

	transaction {

		incidentToken = workflow.startIncident(
			priorityID = 1,
			description = "No one can log into the system."
		);

		workflow.updateIncident(
			incidentToken = incidentToken,
			description = "This was updated",
			ownership = "Rainbow",
			priorityID = 2,
			ticketUrl = "http://ticket",
			videoUrl = "http://video"
		);

	}

</cfscript>
