<cfscript>

	errorService = request.ioc.get( "core.lib.ErrorService" );
	logger = request.ioc.get( "core.lib.Logger" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	param name="attributes.error" type="any";

	logger.logException( attributes.error );
	errorResponse = errorService.getResponse( attributes.error );
	title = errorResponse.title;
	message = errorResponse.message;

	request.template.statusCode = errorResponse.statusCode;
	request.template.statusText = errorResponse.statusText;
	request.template.title = title;
	// Used to render the error in local development debugging.
	request.lastProcessedError = attributes.error;

	include "./error.view.cfm";

	cfmodule( template = "./common/layout.cfm" );

</cfscript>
