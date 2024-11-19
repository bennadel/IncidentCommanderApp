component
	output = false
	hint = "I provide service methods for the incident entity."
	{

	// Define properties for dependency-injection.
	property name="gateway" ioc:type="core.lib.model.IncidentGateway";
	property name="validation" ioc:type="core.lib.model.IncidentValidation";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I create an incident entity with the following properties.
	*/
	public numeric function createIncident(
		required string slug,
		required string descriptionMarkdown,
		required string descriptionHtml,
		required string ownership,
		required numeric priorityID,
		required string ticketUrl,
		required string videoUrl,
		required date createdAt
		) {

		slug = validation.testSlug( slug );
		descriptionMarkdown = validation.testDescriptionMarkdown( descriptionMarkdown );
		descriptionHtml = validation.testDescriptionHtml( descriptionHtml );
		ownership = validation.testOwnership( ownership );
		priorityID = validation.testPriorityID( priorityID );
		ticketUrl = validation.testTicketUrl( ticketUrl );
		videoUrl = validation.testVideoUrl( videoUrl );
		password = validation.testPassword( "" ); // Todo: add password feature.
		createdAt = validation.testCreatedAt( createdAt );

		var id = gateway.createIncident(
			slug = slug,
			descriptionMarkdown = descriptionMarkdown,
			descriptionHtml = descriptionHtml,
			ownership = ownership,
			priorityID = priorityID,
			ticketUrl = ticketUrl,
			videoUrl = videoUrl,
			password = password,
			createdAt = createdAt
		);

		return id;

	}


	/**
	* I delete the incident entity with the given ID.
	*/
	public void function deleteIncident( required numeric id ) {

		var incident = getIncident( id );

		gateway.deleteIncidentByFilter( id = incident.id );

	}


	/**
	* I get the incident entity with the given ID.
	*/
	public struct function getIncident( required numeric id ) {

		var results = gateway.getIncidentByFilter( id = id );

		if ( ! results.len() ) {

			validation.throwIncidentNotFoundError();

		}

		return results.first();

	}


	/**
	* I update the incident entity with the given ID.
	*/
	public void function updateIncident(
		required numeric id,
		string descriptionMarkdown,
		string descriptionHtml,
		string ownership,
		numeric priorityID,
		string ticketUrl,
		string videoUrl
		) {

		var incident = getIncident( id );

		if ( arguments.keyExists( "descriptionMarkdown" ) ) {

			incident.descriptionMarkdown = validation.testDescriptionMarkdown( descriptionMarkdown );

		}

		if ( arguments.keyExists( "descriptionHtml" ) ) {

			incident.descriptionHtml = validation.testDescriptionHtml( descriptionHtml );

		}

		if ( arguments.keyExists( "ownership" ) ) {

			incident.ownership = validation.testOwnership( ownership );

		}

		if ( arguments.keyExists( "priorityID" ) ) {

			incident.priorityID = validation.testPriorityID( priorityID );

		}

		if ( arguments.keyExists( "ticketUrl" ) ) {

			incident.ticketUrl = validation.testTicketUrl( ticketUrl );

		}

		if ( arguments.keyExists( "videoUrl" ) ) {

			incident.videoUrl = validation.testVideoUrl( videoUrl );

		}

		if ( arguments.keyExists( "password" ) ) {

			incident.password = validation.testPassword( password );

		}

		gateway.updateIncident(
			id = incident.id,
			descriptionMarkdown = incident.descriptionMarkdown,
			descriptionHtml = incident.descriptionHtml,
			ownership = incident.ownership,
			priorityID = incident.priorityID,
			ticketUrl = incident.ticketUrl,
			videoUrl = incident.videoUrl,
			password = incident.password
		);

	}

}
