component
	output = false
	hint = "I provide workflow methods around incident management."
	{

	// Define properties for dependency-injection.
	property name="accessControl" ioc:type="core.lib.AccessControl";
	property name="clock" ioc:type="core.lib.util.Clock";
	property name="incidentService" ioc:type="core.lib.model.IncidentService";
	property name="priorityService" ioc:type="core.lib.model.PriorityService";
	property name="slugGenerator" ioc:type="core.lib.SlugGenerator";
	property name="stageService" ioc:type="core.lib.model.StageService";
	property name="markdownParser" ioc:type="core.lib.markdown.Parser";
	property name="statusService" ioc:type="core.lib.model.StatusService";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I add a status update to the given incident.
	*/
	public numeric function addStatus(
		required string incidentToken,
		required numeric stageID,
		required string contentMarkdown
		) {

		var incident = accessControl.getIncident( incidentToken );
		var stage = stageService.getStage( stageID );
		var contentHtml = markdownParser.toHtml( contentMarkdown );
		var createdAt = clock.utcNow();

		var statusID = statusService.createStatus(
			incidentID = incident.id,
			stageID = stage.id,
			contentMarkdown = contentMarkdown,
			contentHtml = contentHtml,
			createdAt = createdAt
		);

		return statusID;

	}


	/**
	* I delete the incident and all child status updates with the given id:slug token.
	*/
	public void function deleteIncident( required string incidentToken ) {

		var incident = accessControl.getIncident( incidentToken );

		transaction {

			statusService.deleteStatusByFilter( incidentID = incident.id );
			incidentService.deleteIncident( incident.id );

		}

	}


	/**
	* I delete the status with the given ID.
	*/
	public void function deleteStatus(
		required string incidentToken,
		required numeric statusID
		) {

		var incident = accessControl.getIncident( incidentToken );
		var status = accessControl.getStatus( incident, statusID );

		statusService.deleteStatus( status.id );

	}


	/**
	* I start a new incident with a randomly generated slug. For security purposes, an
	* incident can only be referenced using both the id and the slug. As such, both values
	* are being returned from this method as a compound token.
	*/
	public string function startIncident(
		required string description,
		required numeric priorityID
		) {

		var priority = priorityService.getPriority( priorityID );
		var slug = slugGenerator.nextSlug();
		var createdAt = clock.utcNow();

		var incidentID = incidentService.createIncident(
			slug = slug,
			description = description,
			ownership = "",
			priorityID = priority.id,
			ticketUrl = "",
			videoUrl = "",
			createdAt = clock.utcNow()
		);

		return "#incidentID#-#slug#";

	}


	/**
	* I update the incident with the given token.
	*/
	public void function updateIncident(
		required string incidentToken,
		required string description,
		required string ownership,
		required numeric priorityID,
		required string ticketUrl,
		required string videoUrl
		) {

		var incident = accessControl.getIncident( incidentToken );
		var priority = priorityService.getPriority( priorityID );

		incidentService.updateIncident(
			id = incident.id,
			description = description,
			ownership = ownership,
			priorityID = priority.id,
			ticketUrl = ticketUrl,
			videoUrl = videoUrl
		);

	}


	/**
	* I update the status with the given ID.
	*/
	public void function updateStatus(
		required string incidentToken,
		required numeric statusID,
		required numeric stageID,
		required string contentMarkdown
		) {

		var incident = accessControl.getIncident( incidentToken );
		var status = accessControl.getStatus( incident, statusID );
		var stage = stageService.getStage( stageID );
		var contentHtml = markdownParser.toHtml( contentMarkdown );

		statusService.updateStatus(
			id = status.id,
			stageID = stage.id,
			contentMarkdown = contentMarkdown,
			contentHtml = contentHtml
		);

	}

}
