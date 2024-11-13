component
	output = false
	hint = "I provide service methods for the screenshot entity."
	{

	// Define properties for dependency-injection.
	property name="gateway" ioc:type="core.lib.model.ScreenshotGateway";
	property name="validation" ioc:type="core.lib.model.ScreenshotValidation";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I create a screenshot entity with the following properties.
	*/
	public numeric function createScreenshot(
		required numeric incidentID,
		required numeric statusID,
		required string mimeType,
		required date createdAt
		) {

		incidentID = validation.testIncidentID( incidentID );
		statusID = validation.testStatusID( statusID );
		mimeType = validation.testMimeType( mimeType );
		createdAt = validation.testCreatedAt( createdAt );

		var id = gateway.createScreenshot(
			incidentID = incidentID,
			statusID = statusID,
			mimeType = mimeType,
			createdAt = createdAt
		);

		return id;

	}


	/**
	* I delete the screenshot entity with the given ID.
	*/
	public void function deleteScreenshot( required numeric id ) {

		var screenshot = getScreenshot( id );

		gateway.deleteScreenshotByFilter( id = screenshot.id );

	}


	/**
	* I delete the screenshot entities that match the given filtering.
	*/
	public void function deleteScreenshotByFilter(
		numeric id,
		numeric incidentID,
		numeric statusID
		) {

		gateway.deleteScreenshotByFilter( argumentCollection = arguments );

	}


	/**
	* I get the screenshot entity with the given ID.
	*/
	public struct function getScreenshot( required numeric id ) {

		var results = gateway.getScreenshotByFilter( id = id );

		if ( ! results.len() ) {

			validation.throwScreenshotNotFoundError();

		}

		return results.first();

	}


	/**
	* I get the screenshot entities that match the given filtering.
	*/
	public array function getScreenshotByFilter(
		numeric id,
		numeric incidentID,
		numeric statusID
		) {

		return gateway.getScreenshotByFilter( argumentCollection = arguments );

	}

}
