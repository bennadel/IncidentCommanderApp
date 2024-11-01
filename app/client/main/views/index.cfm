<cfscript>

	workflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );

	transaction {

		incidentToken = workflow.startIncident(
			priorityID = 1,
			description = "No one can log into the system."
		);

		workflow.addStatus(
			incidentToken = incidentToken,
			stageID = 1,
			contentMarkdown = "We are looking _through_ the <a href='javascript:void(0);'>logs</a> **trying** to figure out what is going on."
		);

	}

</cfscript>
