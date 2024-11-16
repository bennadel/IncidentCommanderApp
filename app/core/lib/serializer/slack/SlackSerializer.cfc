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
		var descriptionText = getDescriptionText( incident.descriptionHtml );

		// Todo: We should treat the description like a mini markdown field since it may
		// contain URLs. Slack will auto-link these. But, Slack is very generous about the
		// format of URLs that it will auto-link (just about anything that is "." followed
		// by a known TLD will be auto-linked). This is likely even more generous than the
		// markdown parser will do. It's a sticky situation. Punting on it for now.
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
				var statusText = getStatusText( status.contentHtml );

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
	* I normalize the incident description into a small text snippet.
	*/
	private string function getDescriptionText( required string descriptionHtml ) {

		return getInertText( descriptionHtml, 500 );

	}


	/**
	* I transform the given HTML into an inert snippet of text that can be safely dropped
	* into a Slack message.
	*
	* Todo: For the MVP, we're just gonna get the text content. In the future, I'd like to
	* be smarter about how I serialize this stuff, allowing for some formatting. JSoup
	* should allow us to do this.
	*/
	private string function getInertText(
		required string contentHtml,
		required numeric maxLength
		) {

		var dom = jsoup
			.parseBodyFragment( javaCast( "string", contentHtml ) )
			.body()
		;

		replaceAnchorsWithEscapedHref( dom );

		var inertText = dom.text();

		if ( inertText.len() > maxLength ) {

			inertText = ( inertText.left( maxLength ) & "..." );

		}

		return inertText;

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


	/**
	* I normalize the status update into a small text snippet.
	*/
	private string function getStatusText( required string contentHtml ) {

		return getInertText( contentHtml, 500 );

	}


	/**
	* I replace anchor elements with escaped hrefs to avoid open-graph tag interactions in
	* Slack messages.
	*/
	private void function replaceAnchorsWithEscapedHref( required any dom ) {

		for ( var element in dom.select( "a[href]" ) ) {

			var href = element.attr( "href" );
			var textNode = jsoupClassLoader.create( "org.jsoup.nodes.TextNode" )
				.init( "`#href#`" )
			;

			element.replaceWith( textNode );

		}

	}

}
