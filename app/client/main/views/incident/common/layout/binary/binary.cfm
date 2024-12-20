<cfscript>

	param name="request.template.statusCode" type="numeric" default=200;
	param name="request.template.statusText" type="string" default="OK";
	param name="request.template.contentDisposition" type="string" default="attachment";
	param name="request.template.etag" type="string" default="";
	param name="request.template.maxAgeInDays" type="numeric" default=0;
	param name="request.template.mimeType" type="string" default="application/octet-stream";
	param name="request.template.filename" type="string";
	param name="request.template.primaryContent" type="binary";

	// Override the response status code.
	cfheader(
		statusCode = request.template.statusCode,
		statusText = request.template.statusText
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

	cfheader(
		name = "Content-Length",
		value = arrayLen( request.template.primaryContent )
	);
	cfheader(
		name = "Content-Disposition",
		value = "#request.template.contentDisposition#; filename=#encodeForUrl( request.template.filename )#"
	);
	// Reset the output buffer.
	cfcontent(
		type = request.template.mimeType,
		variable = request.template.primaryContent
	);

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
