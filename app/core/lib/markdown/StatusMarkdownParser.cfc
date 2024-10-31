component
	output = false
	hint = "I provide methods for parsing status markdown into HTML."
	{

	/**
	* I parse the given markdown input into sanitized HTML. If the markdown results in
	* unsupported HTML, an error is thrown.
	*/
	public string function toHtml( required string input ) {

		// Todo: Use Flexmark to perform conversion to HTML.
		// Todo: Use AntiSamy to sanitize generated HTML.
		return encodeForHtml( input );

	}

}
