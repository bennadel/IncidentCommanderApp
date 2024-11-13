component
	output = false
	hint = "I provide validation methods for the screenshot entity."
	{

	/**
	* I validate and return the normalized value.
	*/
	public date function testCreatedAt( required date createdAt ) {

		return dateAdd( "d", 0, createdAt );

	}


	/**
	* I validate and return the normalized value.
	*/
	public numeric function testIncidentID( required numeric incidentID ) {

		incidentID = fix( val( incidentID ) );

		if ( incidentID < 0 ) {

			throw( type = "App.Model.Screenshot.IncidentID.Invalid" );

		}

		return incidentID;

	}


	/**
	* I validate and return the normalized value.
	*/
	public string function testMimeType( required string mimeType ) {

		mimeType = toString( mimeType ).trim();

		if ( ! mimeType.len() ) {

			throw( type = "App.Model.Screenshot.MimeType.Empty" );

		}

		if ( mimeType.len() > 50 ) {

			throw( type = "App.Model.Screenshot.MimeType.TooLong" );

		}

		return mimeType;

	}


	/**
	* I validate and return the normalized value.
	*/
	public numeric function testStatusID( required numeric statusID ) {

		statusID = fix( val( statusID ) );

		if ( statusID < 0 ) {

			throw( type = "App.Model.Screenshot.StatusID.Invalid" );

		}

		return statusID;

	}


	/**
	* I throw a screenshot not found error.
	*/
	public void function throwScreenshotNotFoundError() {

		throw( type = "App.Model.Screenshot.NotFound" );

	}


	/**
	* I throw a screenshot too large error.
	*/
	public void function throwScreenshotTooLargeError() {

		throw( type = "App.Model.Screenshot.TooLarge" );

	}

}
