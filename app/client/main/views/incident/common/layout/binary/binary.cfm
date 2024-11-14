<cfscript>

	param name="request.template.statusCode" type="numeric" default=200;
	param name="request.template.statusText" type="string" default="OK";
	param name="request.template.contentDisposition" type="string" default="attachment";
	param name="request.template.mimeType" type="string" default="application/octet-stream";
	param name="request.template.filename" type="string";
	param name="request.template.primaryContent" type="binary";

	// Override the response status code.
	cfheader(
		statusCode = request.template.statusCode,
		statusText = request.template.statusText
	);
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

</cfscript>
