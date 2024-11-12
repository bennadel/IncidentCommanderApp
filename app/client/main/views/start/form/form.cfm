<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	ui = request.ioc.get( "client.main.lib.ViewHelper" );
	xsrfService = request.ioc.get( "client.main.lib.XsrfService" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="form.descriptionMarkdown" type="string" default="";
	param name="form.priorityID" type="numeric" default=0;

	placeholder = getPlaceholder();
	priorities = getPriorities();
	title = "Incident Commander";
	errorMessage = "";

	request.template.title = title;

	if ( form.submitted ) {

		try {

			incidentToken = incidentWorkflow.startIncident(
				descriptionMarkdown = form.descriptionMarkdown.trim(),
				priorityID = val( form.priorityID )
			);

			xsrfService.cycleCookie();

			requestHelper.goto([
				event: "incident.status.list",
				incidentToken: incidentToken,
				flash: "incident.started"
			]);

		} catch ( any error ) {

			errorMessage = requestHelper.processError( error );

		}

	} else {

		form.priorityID = priorities[ 3 ].id;

	}

	include "./form.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the placeholder text to be used in the description input.
	*/
	private string function getPlaceholder() {

		var options = [
			"Ex, Users can't log into the application...",
			"Ex, Logs are no longer being emitted...",
			"Ex, The database is pegged at 100% CPU and is unresponsive...",
			"Ex, The file-system is full and uploads are failing...",
			"Ex, All API calls are being rejected..."
		];

		return options[ randRange( 1, options.len() ) ];

	}


	/**
	* I get the list of priorities.
	*/
	private array function getPriorities() {

		return priorityService.getPriorityByFilter();

	}

</cfscript>
