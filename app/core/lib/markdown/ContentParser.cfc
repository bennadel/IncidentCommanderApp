component
	output = false
	hint = "I provide a markdown to html parser of incident-related content."
	{

	// Define properties for dependency-injection.
	property name="htmlSanitizer" ioc:type="core.lib.markdown.HtmlSanitizer";
	property name="markdownParser" ioc:type="core.lib.markdown.MarkdownParser";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I parse the given markdown into sanitized HTML. Illegal HTML is stripped-out.
	*/
	public string function toHtml( required string markdown ) {

		return htmlSanitizer.sanitize( markdownParser.toHtml( markdown ) );

	}

}
