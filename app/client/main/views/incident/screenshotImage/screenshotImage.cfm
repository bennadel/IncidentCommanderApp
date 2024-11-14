<cfscript>

	accessControl = request.ioc.get( "core.lib.AccessControl" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.screenshotID" type="numeric" default=0;

	screenshot = getScreenshot( request.incident, val( request.context.screenshotID ) );
	filename = getFilename( screenshot );
	primaryContent = getImageBinary( screenshot );

	request.template.layout = "binary";
	request.template.mimeType = screenshot.mimeType;
	request.template.filename = filename;
	request.template.primaryContent = primaryContent;

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the filename to use as the download attachment.
	*/
	private string function getFilename( required struct screenshot ) {

		var extension = screenshot.mimeType.listLast( "/" );

		return "screenshot-#screenshot.incidentID#-#screenshot.id#.#extension#";

	}


	/**
	* I get the image binary for the given screenshot.
	*/
	private binary function getImageBinary( required struct screenshot ) {

		return fileReadBinary( expandPath( "/upload/storage/#screenshot.incidentID#/#screenshot.id#.upload" ) );

	}


	/**
	* I get the screenshot with the given ID.
	*/
	private struct function getScreenshot(
		required struct incident,
		required numeric screenshotID
		) {

		return accessControl.getScreenshot( incident, screenshotID );

	}

</cfscript>
