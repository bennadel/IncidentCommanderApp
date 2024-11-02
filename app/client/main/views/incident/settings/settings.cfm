<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	ui = request.ioc.get( "client.main.lib.ViewHelper" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.incidentToken" type="string";
	param name="form.description" type="string" default="";
	param name="form.ownership" type="string" default="";
	param name="form.priorityID" type="numeric" default=0;
	param name="form.ticketUrl" type="string" default="";
	param name="form.videoUrl" type="string" default="";

	incident = incidentWorkflow.getIncident( request.context.incidentToken );
	priorities = getPriorities();
	title = "Incident Settings";
	errorMessage = "";

	request.template.title = title;

	if ( form.submitted ) {

		try {

			incidentToken = incidentWorkflow.updateIncident(
				incidentToken = request.context.incidentToken,
				description = form.description.trim(),
				ownership = form.ownership.trim(),
				priorityID = val( form.priorityID ),
				ticketUrl = form.ticketUrl.trim(),
				videoUrl = form.videoUrl.trim()
			);

			// requestHelper.goto({
			// 	event: "incident.settings",
			// 	incidentToken: incidentToken
			// });

		} catch ( any error ) {

			errorMessage = requestHelper.processError( error );

		}

	} else {

		form.description = incident.description;
		form.ownership = incident.ownership;
		form.priorityID = incident.priorityID;
		form.ticketUrl = incident.ticketUrl;
		form.videoUrl = incident.videoUrl;

	}

	include "./settings.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	private array function getPriorities() {

		return priorityService.getPriorityByFilter();

	}

</cfscript>
