component
	output = false
	hint = "I provide service methods for the status entity."
	{

	// Define properties for dependency-injection.
	property name="gateway" ioc:type="core.lib.model.StatusGateway";
	property name="validation" ioc:type="core.lib.model.StatusValidation";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I create a status entity with the following properties.
	*/
	public numeric function createStatus(
		required numeric incidentID,
		required numeric stageID,
		required string contentMarkdown,
		required string contentHtml,
		required date createdAt
		) {

		incidentID = validation.testIncidentID( incidentID );
		stageID = validation.testStageID( stageID );
		contentMarkdown = validation.testContentMarkdown( contentMarkdown );
		contentHtml = validation.testContentHtml( contentHtml );
		createdAt = validation.testCreatedAt( createdAt );

		var id = gateway.createStatus(
			incidentID = incidentID,
			stageID = stageID,
			contentMarkdown = contentMarkdown,
			contentHtml = contentHtml,
			createdAt = createdAt
		);

		return id;

	}


	/**
	* I delete the status with the given ID.
	*/
	public void function deleteStatus( required numeric id ) {

		var status = getStatus( id );

		gateway.deleteStatusByFilter( id = status.id );

	}


	/**
	* I get the status entity with the given ID.
	*/
	public struct function getStatus( required numeric id ) {

		var results = gateway.getStatusByFilter( id = id );

		if ( ! results.len() ) {

			validation.throwStatusNotFoundError();

		}

		return results.first();

	}


	/**
	* I get the status entities that match the given filters.
	*/
	public array function getStatusByFilter(
		numeric id,
		numeric incidentID
		) {

		return gateway.getStatusByFilter( argumentCollection = arguments );

	}



	/**
	* I update the status entity with the given ID.
	*/
	public void function updateStatus(
		required numeric id,
		numeric stageID,
		string contentMarkdown,
		string contentHtml
		) {

		var status = getStatus( id );

		if ( arguments.keyExists( "stageID" ) ) {

			status.stageID = validation.testStageID( stageID );

		}

		if ( arguments.keyExists( "contentMarkdown" ) ) {

			status.contentMarkdown = validation.testContentMarkdown( contentMarkdown );

		}

		if ( arguments.keyExists( "contentHtml" ) ) {

			status.contentHtml = validation.testContentHtml( contentHtml );

		}

		gateway.updateStatus(
			id = status.id,
			stageID = status.stageID,
			contentMarkdown = status.contentMarkdown,
			contentHtml = status.contentHtml
		);

	}

}
