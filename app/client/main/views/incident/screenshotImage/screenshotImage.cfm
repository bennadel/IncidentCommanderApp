<cfscript>

	accessControl = request.ioc.get( "core.lib.AccessControl" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.screenshotID" type="numeric" default=0;

	screenshot = accessControl.getScreenshot(
		incident = request.incident,
		screenshotID = val( request.context.screenshotID )
	);

	binaryContent = fileReadBinary( expandPath( "/upload/storage/#screenshot.incidentID#/#screenshot.id#.upload" ) );
	fileExtension = screenshot.mimeType.listLast( "/" );
	filename = "screenshot-#screenshot.incidentID#-#screenshot.id#.#fileExtension#";

	// Override the response status code.
	cfheader(
		statusCode = 200,
		statusText = "OK"
	);
	cfheader(
		name = "Content-Disposition",
		value = "attachment; filename=#encodeForUrl( filename )#"
	);
	// Reset the output buffer.
	cfcontent(
		type = screenshot.mimeType,
		variable = binaryContent
	);

</cfscript>
