<cfscript>

	accessControl = request.ioc.get( "core.lib.AccessControl" );
	requestMetadata = request.ioc.get( "core.lib.RequestMetadata" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="request.context.screenshotID" type="numeric" default=0;
	param name="request.context.disposition" type="string" default="attachment";

	eTag = getETag( request.context.screenshotID );

	// Regardless of whether or not we're going to read in the record and serve the image,
	// we always want to include these caching headers.
	request.template.etag = eTag;
	request.template.maxAgeInDays = 1;

	// Since serving the screenshot binaries puts a burden on both the server and the
	// browser, we want to allow for caching to short-circuit repeated requests for the
	// same image.
	if ( ! compare( requestMetadata.getETag(), eTag ) ) {

		request.template.layout = "notModified";
		exit;

	}

	screenshot = getScreenshot( request.incident, val( request.context.screenshotID ) );
	filename = getFilename( screenshot );
	contentDisposition = getContentDisposition( request.context.disposition );
	primaryContent = getImageBinary( screenshot );

	request.template.layout = "binary";
	request.template.mimeType = screenshot.mimeType;
	request.template.filename = filename;
	request.template.contentDisposition = contentDisposition;
	request.template.primaryContent = primaryContent;

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the content disposition for the image serving.
	*/
	private string function getContentDisposition( required string disposition ) {

		switch ( disposition ) {
			case "inline":
				return "inline";
			break
			default:
				return "attachment";
			break;
		}

	}


	/**
	* I get the ETag for the given screenshot.
	* 
	* Note: This is based only the inputs, not on the binary. At this time, a screenshot
	* cannot be updated (only created). As such, we don't have to worry about stale etags
	* for a specific screenshot, which gives us an optimization opportunity.
	*/
	private string function getETag( required numeric screenshotID ) {

		return hash( "screenshot:#screenshotID#", "md5" )
			.lcase()
		;

	}


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
