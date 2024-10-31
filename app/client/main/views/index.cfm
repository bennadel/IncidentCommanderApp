<cfscript>

	workflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );

	incidentToken = workflow.startIncident(
		priorityID = 1,
		description = "No one can log into the system."
	);

	workflow.addStatus(
		incidentToken = incidentToken,
		stageID = 1,
		contentMarkdown = "We are looking through the logs trying to figure out what is going on."
	);

</cfscript>
