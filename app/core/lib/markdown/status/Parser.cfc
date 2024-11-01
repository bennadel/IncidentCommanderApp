component
	output = false
	hint = ""
	{

	// Define properties for dependency-injection.
	property name="markdownParser" ioc:type="core.lib.markdown.status.util.MarkdownParser";
	property name="htmlSanitizer" ioc:type="core.lib.markdown.status.util.HtmlSanitizer";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I parse the given status markdown into sanitized HTML. If there are issues with the
	* markdown or the HTML is unsafe, an error is thrown.
	*/
	public string function toHtml( required string markdown ) {

		var unsafeHtml = markdownParser.toHtml( markdown );


		return htmlSanitizer.sanitize( unsafeHtml );


		


		var scanResults = htmlSanitizer.scan( unsafeHtml );

		if ( scanResults.errors.len() ) {

			// Caution: this value may contain unsafe markup once it is canonicalized.
			var errorDetail = canonicalize( scanResults.errors.toList( " " ), false, false, false );

			throw(
				type = "App.Markdown.IllegalContent",
				message = "Markdown resulted in unsafe HTML.",
				detail = errorDetail
			);

		}

		return scanResults.html;

	}

}