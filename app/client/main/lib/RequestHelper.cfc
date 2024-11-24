component
	output = false
	hint = "I provide utility methods to make processing request data easier (or, at least, less repetitive)."
	{

	// Define properties for dependency-injection.
	property name="errorService" ioc:type="core.lib.ErrorService";
	property name="logger" ioc:type="core.lib.Logger";
	property name="requestMetadata" ioc:type="core.lib.RequestMetadata";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I forward the user an internal URL constructed with the given parts.
	*/
	public void function goto(
		any searchParams = [:],
		string fragment = ""
		) {

		if ( isSimpleValue( searchParams ) ) {

			gotoV2( { event: searchParams }, fragment );

		} else {

			gotoV2( searchParams, fragment );
		}

	}


	/**
	* I forward the user an internal URL constructed with the given parts.
	*/
	public void function gotoV2(
		required struct searchParams,
		required string fragment
		) {

		var nextUrl = "/index.cfm";

		if ( searchParams.count() ) {

			var pairs = searchParams.keyArray()
				.map(
					( key ) => {

						return "#encodeForUrl( key )#=#encodeForUrl( searchParams[ key ] )#";

					}
				)
				.toList( "&" )
			;

			nextUrl &= "?#pairs#";

		}

		if ( fragment.len() ) {

			nextUrl &= "###encodeForUrl( fragment )#";

		}

		location(
			url = nextUrl,
			addToken = false
		);

	}


	/**
	* I process the given error, applying the proper status code to the template, and
	* returning the associated user-friendly response message.
	*/
	public string function processError( required any error ) {

		logger.logException( error );

		var errorResponse = errorService.getResponse( error );

		request.template.statusCode = errorResponse.statusCode;
		request.template.statusText = errorResponse.statusText;
		// Used to render the error in local development debugging.
		request.lastProcessedError = error;

		return errorResponse.message;

	}

}
