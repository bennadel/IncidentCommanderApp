component
	output = false
	hint = "I provide methods for serializing an incident as a shareable message."
	{

	// Define properties for dependency-injection.
	property name="config" ioc:get="config";
	property name="incidentService" ioc:type="core.lib.model.IncidentService";
	property name="passwordEncoder" ioc:type="core.lib.PasswordEncoder";
	property name="priorityService" ioc:type="core.lib.model.PriorityService";
	property name="slackSerializer" ioc:type="core.lib.serializer.slack.SlackSerializer";
	property name="stageService" ioc:type="core.lib.model.StageService";
	property name="statusService" ioc:type="core.lib.model.StatusService";
	property name="utilities" ioc:type="core.lib.util.Utilities";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I serialize the given incident for pasting into a Slack message.
	*/
	public string function serializeForSlack( required numeric incidentID ) {

		return slackSerializer.serializeIncident( buildSerializationInput( incidentID ) )

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I build the normalized input for serialization. All serialization pipelines will use
	* the same input data.
	*/
	private struct function buildSerializationInput( required numeric incidentID ) {

		var incident = incidentService.getIncident( incidentID );
		var incidentToken = "#incident.id#-#incident.slug#";
		var statuses = statusService.getStatusByFilter( incidentID = incident.id );
		var stages = stageService.getStageByFilter();
		var stagesIndex = utilities.indexBy( stages, "id" );
		var priorities = priorityService.getPriorityByFilter();
		var prioritiesIndex = utilities.indexBy( priorities, "id" );
		// The password is encrypted at rest. If one exists, we need to decrypt it so that
		// it can be shared internally with the team.
		var password = incident.password.len()
			? passwordEncoder.decode( incident.password )
			: ""
		;

		return {
			url: "#config.site.url#/index.cfm?event=incident.share&incidentToken=#encodeForUrl( incidentToken )#",
			descriptionHtml: incident.descriptionHtml,
			priority: prioritiesIndex[ incident.priorityID ].name,
			videoUrl: incident.videoUrl,
			password: password,
			statuses: statuses.map(
				( status ) => {

					// Note: No serialization pipeline should really need the ID. However,
					// I'm including it for any sorting requirements (since the ID is an
					// auto-incrementing field).
					return {
						id: status.id,
						stage: stagesIndex[ status.stageID ].name,
						contentHtml: status.contentHtml,
						createdAt: status.createdAt
					};

				}
			)
		};

	}

}
