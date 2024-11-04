<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	ui = request.ioc.get( "client.main.lib.ViewHelper" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="form.description" type="string" default="";
	param name="form.ownership" type="string" default="";
	param name="form.priorityID" type="numeric" default=0;
	param name="form.ticketUrl" type="string" default="";
	param name="form.videoUrl" type="string" default="";

	priorities = getPriorities();
	title = "Incident Settings";
	errorMessage = "";

	request.template.activeNavItem = "settings";
	request.template.title = title;

	if ( form.submitted ) {

		try {

			incidentWorkflow.updateIncident(
				incidentToken = request.context.incidentToken,
				description = form.description.trim(),
				ownership = form.ownership.trim(),
				priorityID = val( form.priorityID ),
				ticketUrl = form.ticketUrl.trim(),
				videoUrl = form.videoUrl.trim()
			);

			requestHelper.goto([
				event: "incident.status.list",
				incidentToken: request.context.incidentToken,
				flash: "incident.updated"
			]);

		} catch ( any error ) {

			errorMessage = requestHelper.processError( error );

		}

	} else {

		form.description = request.incident.description;
		form.ownership = request.incident.ownership;
		form.priorityID = request.incident.priorityID;
		form.ticketUrl = request.incident.ticketUrl;
		form.videoUrl = request.incident.videoUrl;

	}

	include "./settings.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the list of incident priorities.
	*/
	private array function getPriorities() {

		return priorityService.getPriorityByFilter();

	}

</cfscript>
