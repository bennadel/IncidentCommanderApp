<cfscript>

	param name="request.template.etag" type="string" default="";
	param name="request.template.maxAgeInDays" type="numeric" default=0;

	// Override the response status code.
	cfheader(
		statusCode = 304,
		statusText = "Not Modified"
	);

	if ( request.template.etag.len() ) {

		cfheader(
			name = "ETag",
			value = request.template.etag
		);

	}

	if ( request.template.maxAgeInDays ) {

		cfheader(
			name = "Cache-Control",
			value = "max-age=#getMaxAge( request.template.maxAgeInDays )#"
		);

	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the number of seconds for the max-age of the given day-span.
	*/
	private numeric function getMaxAge( required numeric maxAgeInDays ) {

		var perMinute = 60;
		var perHour = ( 60 * perMinute );
		var perDay = ( 24 * perHour );

		return ( maxAgeInDays * perDay );

	}

</cfscript>
