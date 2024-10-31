component
	output = false
	hint = "I provide validation methods for the incident entity."
	{

	// Define properties for dependency-injection.
	property name="validationUtilities" ioc:type="core.lib.util.ValidationUtilities";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I validate and return the normalized value.
	*/
	public date function testCreatedAt( required date createdAt ) {

		return dateAdd( "d", 0, createdAt );

	}


	/**
	* I validate and return the normalized value.
	*/
	public string function testDescription( required string description ) {

		description = toString( description ).trim();

		if ( ! description.len() ) {

			throw( type = "App.Model.Incident.Description.Empty" );

		}

		if ( description.len() > 1000 ) {

			throw( type = "App.Model.Incident.Description.TooLong" );

		}

		return description;

	}


	/**
	* I validate and return the normalized value.
	*/
	public string function testOwnership( required string ownership ) {

		ownership = toString( ownership ).trim();

		if ( ownership.len() > 50 ) {

			throw( type = "App.Model.Incident.Ownership.TooLong" );

		}

		if ( ownership != validationUtilities.canonicalizeInput( ownership ) ) {

			throw( type = "App.Model.Incident.Ownership.SuspiciousEncoding" );

		}

		return ownership;

	}


	/**
	* I validate and return the normalized value.
	*/
	public numeric function testPriorityID( required numeric priorityID ) {

		priorityID = fix( val( priorityID ) );

		if ( priorityID < 0 ) {

			throw( type = "App.Model.Incident.PriorityID.Invalid" );

		}

		return priorityID;

	}


	/**
	* I validate and return the normalized value.
	*/
	public string function testSlug( required string slug ) {

		slug = toString( slug ).trim();

		if ( ! slug.len() ) {

			throw( type = "App.Model.Incident.Slug.Empty" );

		}

		if ( slug.len() > 255 ) {

			throw( type = "App.Model.Incident.Slug.TooLong" );

		}

		if ( slug.reFindNoCase( "[^a-z0-9-]" ) ) {

			throw( type = "App.Model.Incident.Slug.Invalid" );

		}

		return slug;

	}


	/**
	* I validate and return the normalized value.
	*/
	public string function testTicketUrl( required string ticketUrl ) {

		ticketUrl = toString( ticketUrl ).trim();

		if ( ticketUrl.len() > 300 ) {

			throw( type = "App.Model.Incident.TicketUrl.TooLong" );

		}

		return ticketUrl;

	}


	/**
	* I validate and return the normalized value.
	*/
	public string function testVideoUrl( required string videoUrl ) {

		videoUrl = toString( videoUrl ).trim();

		if ( videoUrl.len() > 300 ) {

			throw( type = "App.Model.Incident.VideoUrl.TooLong" );

		}

		return videoUrl;

	}


	/**
	* I throw an incident not found error.
	*/
	public void function throwIncidentNotFoundError() {

		throw( type = "App.Model.Incident.NotFound" );

	}

}
