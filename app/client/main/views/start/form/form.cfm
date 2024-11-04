<cfscript>

	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	ui = request.ioc.get( "client.main.lib.ViewHelper" );
	xsrfService = request.ioc.get( "client.main.lib.XsrfService" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="form.description" type="string" default="";
	param name="form.priorityID" type="numeric" default=0;

	placeholder = getPlaceholder();
	priorities = getPriorities();
	title = "Incident Commander";
	errorMessage = "";

	request.template.title = title;

	if ( form.submitted ) {

		try {

			if ( ! form.description.len() ) {

				form.description = getFallbackDescription();

			}

			incidentToken = incidentWorkflow.startIncident(
				description = form.description.trim(),
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

	private string function getFallbackDescription() {

		return "The application is behaving incorrectly.";

	}


	private string function getPlaceholder() {

		var options = [
			"Users can't log into the application..."
		];

		return options[ randRange( 1, options.len() ) ];

	}


	private array function getPriorities() {

		return priorityService.getPriorityByFilter();

	}

</cfscript>
