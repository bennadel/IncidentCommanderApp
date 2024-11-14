<cfscript>

	param name="request.template.etag" type="string" default="";

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
	// Reset the output buffer.
	cfcontent( type = "text/html; charset=utf-8" );

</cfscript>
