<cfscript>

	clock = request.ioc.get( "core.lib.util.Clock" );
	incidentSerializer = request.ioc.get( "core.lib.serializer.IncidentSerializer" );
	incidentWorkflow = request.ioc.get( "core.lib.workflow.IncidentWorkflow" );
	requestHelper = request.ioc.get( "client.main.lib.RequestHelper" );
	screenshotService = request.ioc.get( "core.lib.model.ScreenshotService" );
	stageService = request.ioc.get( "core.lib.model.StageService" );
	statusService = request.ioc.get( "core.lib.model.StatusService" );
	ui = request.ioc.get( "client.main.lib.ViewHelper" );
	utilities = request.ioc.get( "core.lib.util.Utilities" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="form.stageID" type="numeric" default=0;
	param name="form.contentMarkdown" type="string" default="";
	param name="form.screenshotFile" type="string" default="";

	statuses = getStatuses( request.incident );
	stages = getStages();
	stagesIndex = getStagesIndex( stages );
	screenshots = getScreenshots( request.incident );
	screenshotsIndex = getScreenshotsIndex( screenshots );
	slackContent = getSlackContent( request.incident );
	title = "Status Updates";
	errorResponse = "";

	request.template.title = title;

	if ( form.submitted ) {

		try {

			incidentWorkflow.addStatus(
				incidentToken = request.context.incidentToken,
				stageID = val( form.stageID ),
				contentMarkdown = form.contentMarkdown.trim(),
				screenshotFormField = "screenshotFile"
			);

			requestHelper.goto([
				event: "incident.status.list",
				incidentToken: request.context.incidentToken,
				flash: "incident.status.created"
			]);

		} catch ( any error ) {

			errorResponse = requestHelper.processError( error );

		}

	} else {

		// Default to the most recently-used stage.
		form.stageID = statuses.len()
			? statuses.first().stageID
			: stages.first().id
		;

	}

	include "./list.view.cfm";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the screenshots for the given incident.
	*/
	private array function getScreenshots( required struct incident ) {

		return screenshotService
			.getScreenshotByFilter( incidentID = incident.id )
			.sort(
				( a, b ) => {

					return sgn( a.id - b.id ); // Oldest first.

				}
			)
		;

	}


	/**
	* I get the screenshots by status ID.
	*/
	private struct function getScreenshotsIndex( required array screenshots ) {

		return utilities.groupBy( screenshots, "statusID" );

	}


	/**
	* I get the Slack-compatible message for the given incident.
	*/
	private string function getSlackContent( required struct incident ) {

		return incidentSerializer.serializeForSlack( incident.id );

	}


	/**
	* I get the incident states.
	*/
	private array function getStages() {

		return stageService.getStageByFilter();

	}


	/**
	* I get the stages index by ID.
	*/
	private struct function getStagesIndex( required array stages ) {

		return utilities.indexBy( stages, "id" );

	}


	/**
	* I get the status updates for the given incident.
	*/
	private array function getStatuses( required struct incident ) {

		return statusService
			.getStatusByFilter( incidentID = incident.id )
			.sort(
				( a, b ) => {

					return sgn( b.id - a.id );

				}
			)
		;

	}

</cfscript>
