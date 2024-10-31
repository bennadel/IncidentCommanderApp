component
	output = false
	hint = "I provide methods for sanitizing the parsed HTML content."
	{

	public struct function scan( required string unsafeHtml ) {

		// Todo: Sanitize the HTML input.
		return {
			html: unsafeHtml
		};

	}

}
