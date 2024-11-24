<cfscript>

	authWorkflow = request.ioc.get( "client.main.lib.workflow.AuthWorkflow" );
	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	passwordEncoder = request.ioc.get( "core.lib.PasswordEncoder" );
	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	ui = request.ioc.get( "client.main.lib.ViewHelper" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="form.descriptionMarkdown" type="string" default="";
	param name="form.ownership" type="string" default="";
	param name="form.priorityID" type="numeric" default=0;
	param name="form.ticketUrl" type="string" default="";
	param name="form.videoUrl" type="string" default="";
	param name="form.password" type="string" default="";

	priorities = getPriorities();
	title = "Incident Settings";
	errorMessage = "";

	request.template.activeNavItem = "settings";
	request.template.title = title;

	if ( form.submitted ) {

		try {

			incidentWorkflow.updateIncident(
				incidentToken = request.context.incidentToken,
				descriptionMarkdown = form.descriptionMarkdown.trim(),
				ownership = form.ownership.trim(),
				priorityID = val( form.priorityID ),
				ticketUrl = form.ticketUrl.trim(),
				videoUrl = form.videoUrl.trim(),
				password = form.password.trim()
			);

			// If the user is setting a password, we have to add the current incident ID
			// to the access credentials so that we don't immediately turn around and send
			// this user to the authentication form.
			// --
			// Note to self: it may seem strange to spread the incident settings update
			// and the access control update across two different workflows. But, it's
			// important to remember that the core workflow doesn't know anything about
			// this web client. And, it shouldn't be concerned with anything other than
			// the ID-based access.
			authWorkflow.ensureAccess( request.incident );

			requestHelper.goto([
				event: "incident.status.list",
				incidentToken: request.context.incidentToken,
				flash: "incident.updated"
			]);

		} catch ( any error ) {

			errorMessage = requestHelper.processError( error );

		}

	} else {

		form.descriptionMarkdown = request.incident.descriptionMarkdown;
		form.ownership = request.incident.ownership;
		form.priorityID = request.incident.priorityID;
		form.ticketUrl = request.incident.ticketUrl;
		form.videoUrl = request.incident.videoUrl;
		form.password = passwordEncoder.decode( request.incident.password );

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
