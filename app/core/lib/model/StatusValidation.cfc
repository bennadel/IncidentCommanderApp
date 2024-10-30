component
	output = false
	hint = "I provide validation methods for the status entity."
	{

	/**
	* I validate and return the normalized value.
	*/
	public string function testContentHtml( required string contentHtml ) {

		contentHtml = toString( contentHtml ).trim();

		if ( ! contentHtml.len() ) {

			throw( type = "App.Model.Status.ContentHtml.Empty" );

		}

		if ( contentHtml.len() > 65535 ) {

			throw( type = "App.Model.Status.ContentHtml.TooLong" );

		}

		return contentHtml;

	}


	/**
	* I validate and return the normalized value.
	*/
	public string function testContentMarkdown( required string contentMarkdown ) {

		contentMarkdown = toString( contentMarkdown ).trim();

		if ( ! contentMarkdown.len() ) {

			throw( type = "App.Model.Status.ContentMarkdown.Empty" );

		}

		if ( contentMarkdown.len() > 65535 ) {

			throw( type = "App.Model.Status.ContentMarkdown.TooLong" );

		}

		return contentMarkdown;

	}


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

			throw( type = "App.Model.Status.IncidentID.Invalid" );

		}

		return incidentID;

	}


	/**
	* I validate and return the normalized value.
	*/
	public numeric function testStageID( required numeric stageID ) {

		stageID = fix( val( stageID ) );

		if ( stageID < 0 ) {

			throw( type = "App.Model.Status.StageID.Invalid" );

		}

		return stageID;

	}


	/**
	* I throw a status not found error.
	*/
	public void function throwStatusNotFoundError() {

		throw( type = "App.Model.Status.NotFound" );

	}

}
