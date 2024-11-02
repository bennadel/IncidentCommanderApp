<cfscript>

	config = request.ioc.get( "config" );

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	// Todo: Fill out open-graph information.
	title = config.site.name;
	description = "";
	siteUrl = config.site.url;
	imageUrl = "";

	include "./openGraph.view.cfm";

</cfscript>
