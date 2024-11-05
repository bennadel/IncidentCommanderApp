<cfscript>

	param name="request.template.statusCode" type="numeric" default=200;
	param name="request.template.statusText" type="string" default="OK";
	param name="request.template.filename" type="string" default="download.json";
	param name="request.template.primaryContent" type="any" default="";

	serializedContent = serializeJson( request.template.primaryContent );
	binaryContent = charsetDecode( serializedContent, "utf-8" );

	// Override the response status code.
	cfheader(
		statusCode = request.template.statusCode,
		statusText = request.template.statusText
	);
	cfheader(
		name = "Content-Disposition",
		value = "attachment; filename=#encodeForUrl( request.template.filename )#"
	);
	// Reset the output buffer.
	cfcontent(
		type = "application/x-json; charset=utf-8",
		variable = binaryContent
	);

</cfscript>
