component
	output = false
	hint = "I provide methods for sanitizing the parsed HTML content."
	{

	// Define properties for dependency-injection.
	property name="policyFile" ioc:skip;

	/**
	* I initialize the markdown parser.
	*/
	public void function init() {

		variables.policyFile = expandPath( "/core/lib/markdown/util/HtmlSanitizerPolicy.xml" );

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I sanitize the given HTML - any invalid or illegal markup is removed.
	*/
	public string function sanitize( required string unsafeHtml ) {

		return getSafeHtml( unsafeHtml, policyFile, false );

	}

}
