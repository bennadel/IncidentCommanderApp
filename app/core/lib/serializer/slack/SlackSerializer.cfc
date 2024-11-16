component
	output = false
	hint = "I serialize incident for use in a Slack message."
	{

	// Define properties for dependency-injection.
	property name="clock" ioc:type="core.lib.util.Clock";
	property name="jsoup" ioc:skip;
	property name="jsoupClassLoader" ioc:type="core.lib.classLoader.JSoupClassLoader";
	property name="utilities" ioc:type="core.lib.util.Utilities";

	/**
	* I initialize the Slack serializer.
	*/
	public void function $init() {

		variables.jsoup = jsoupClassLoader.create( "org.jsoup.Jsoup" );

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I generate a Slack-compatible message for the given incident.
	*/
	public string function serializeIncident( required struct incident ) {

		var videoText = incident.videoUrl.len()
			? "`#incident.videoUrl#`"
			: "_None provided_"
		;
		var statusText = incident.statuses.len()
			? incident.statuses.last().stage
			: "Investigating"
		;
		var descriptionText = getInertText( incident.descriptionHtml, 500 );

		var lines = [
			"*Incident Description*: #descriptionText#",
			"*Priority*: #incident.priority#",
			"*Video URL*: #videoText#",
			"*Status*: #statusText#",
			"*Timeline*: `#incident.url#`"
		];

		var statusCount = incident.statuses.len();
		var renderCount = 3;

		if ( statusCount ) {

			if ( statusCount > renderCount ) {

				lines.append( "" );
				lines.append( "_...#( statusCount - renderCount )# update(s) not shown_" );

				var statuses = incident.statuses.slice( -renderCount );

			} else {

				var statuses = incident.statuses;

			}

			for ( var status in statuses ) {

				var statusHeader = getStatusHeader( status.stage, status.createdAt );
				var statusText = getInertText( status.contentHtml, 500 );

				lines.append( "" );
				lines.append( "*#statusHeader#:*" );
				lines.append( "> #statusText#" );

			}

		}

		return lines.toList( chr( 10 ) );

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I recreate a JSoup text node with the given content.
	*/
	private any function createTextNode( required string textContent ) {

		return jsoupClassLoader.create( "org.jsoup.nodes.TextNode" )
			.init( textContent )
		;

	}


	/**
	* I transform the given HTML into an inert snippet of text that can be safely dropped
	* into a Slack message.
	*/
	private string function getInertText(
		required string contentHtml,
		required numeric maxLength
		) {

		var dom = jsoup
			.parseBodyFragment( javaCast( "string", contentHtml ) )
			.body()
		;

		// Replace anchor links with escaped URLs (wrapped in ticks). Since Slack will
		// scan naked URLs and attach previews to the message (which is not appropriate in
		// this context), we want to make sure all URLs are wrapped.
		for ( var element in dom.select( "a[href]" ) ) {

			var text = element.attr( "href" );

			element.replaceWith( createTextNode( "`#text#`" ) );

		}

		// Todo: Slack will auto-link really minimal URLs. Basically and token followed by
		// a valid TLD (top level domain) will be picked up, even without a `www.` or an
		// explicit protocol. Flexmark will NOT do that. Which means, those minimal URLs
		// won't be in anchor tags. In the future, we want to escape those here. The good
		// news is that, for now, they don't seem to be triggering open-graph tags.

		// Replace all PRE blocks with redacted ticks.
		for ( var element in dom.select( "pre" ) ) {

			element.replaceWith( createTextNode( "`[truncated code]`" ) );

		}

		// Replace all CODE blocks with escaped ticks.
		for ( var element in dom.select( "code" ) ) {

			var text = element.text();

			element.replaceWith( createTextNode( "`#text#`" ) );

		}

		var inertText = dom.text();

		// If no truncation needs to take place, we're done.
		if ( inertText.len() <= maxLength ) {

			return inertText;

		}

		// We need to truncate the inert text. However, when we truncate the text, we run
		// the risk of truncating it in the middle of a tick-escape. As such, we may have
		// to clean-up the text a bit after the truncation.
		inertText = inertText.left( maxLength );

		// If we have an odd number of ticks, we need to end on a tick.
		if ( inertText.reMatch( "`" ).len() % 2 ) {

			inertText &= "`";

		}

		return "#inertText#...";

	}


	/**
	* I format the status header text.
	*/
	private string function getStatusHeader(
		required string stage,
		required date createdAt
		) {

		var relativeDate = utilities.ucfirst( clock.fromNowDB( createdAt ) );

		return "#relativeDate# [ #stage# ]";

	}

}
