<cfscript>

	config = request.ioc.get( "config" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	clientConfig = config.bugsnag.client;
	startConfig = [
		apiKey: clientConfig.apiKey,
		releaseStage: clientConfig.releaseStage
	];

	include "./bugsnag.view.cfm";

</cfscript>
