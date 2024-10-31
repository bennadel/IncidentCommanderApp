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
		required string description,
		required string ownership,
		required numeric priorityID,
		required string ticketUrl,
		required string videoUrl,
		required date createdAt
		) {

		slug = validation.testSlug( slug );
		description = validation.testDescription( description );
		ownership = validation.testOwnership( ownership );
		priorityID = validation.testPriorityID( priorityID );
		ticketUrl = validation.testTicketUrl( ticketUrl );
		videoUrl = validation.testVideoUrl( videoUrl );
		createdAt = validation.testCreatedAt( createdAt );

		var id = gateway.createIncident(
			slug = slug,
			description = description,
			ownership = ownership,
			priorityID = priorityID,
			ticketUrl = ticketUrl,
			videoUrl = videoUrl,
			createdAt = createdAt
		);

		return id;

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
		string description,
		string ownership,
		numeric priorityID,
		string ticketUrl,
		string videoUrl
		) {

		var incident = getIncident( id );

		if ( arguments.keyExists( "description" ) ) {

			incident.description = validation.testDescription( description );

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

		gateway.updateIncident(
			id = incident.id,
			description = incident.description,
			ownership = incident.ownership,
			priorityID = incident.priorityID,
			ticketUrl = incident.ticketUrl,
			videoUrl = incident.videoUrl
		);

	}

}
