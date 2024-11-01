component
	output = false
	hint = "I provide methods for sanitizing the parsed HTML content."
	{

	// Define properties for dependency-injection.
	property name="antisamy" ioc:skip;
	property name="classLoader" ioc:type="core.lib.markdown.status.util.HtmlSanitizerClassLoader";
	property name="policy" ioc:skip;

	/**
	* I initialize the markdown parser.
	*/
	public void function $init() {

		// Create our AntiSamy instance.
		variables.antisamy = classLoader.create( "org.owasp.validator.html.AntiSamy" )
			.init()
		;

		// Note: We have to jump through some hoops here to create the policy instance
		// because of some funky thread-based class loader stuff that is happening below
		// the surface. I don't fully understand any of it.
		variables.policy = classLoader.runWithForcedLoader(
			( PolicyClass, policyFilePath ) => {

				// Read more about policy files:
				// https://www.wavemaker.com/learn/app-development/app-security/xss-antisamy-policy-configuration/
				return PolicyClass.getInstance( javaCast( "string", policyFilePath ) );

			},
			{
				PolicyClass: classLoader.create( "org.owasp.validator.html.Policy" ),
				policyFilePath: expandPath( "/core/lib/markdown/status/util/HtmlSanitizerPolicy.xml" )
			}
		);

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I scan the given untrusted HTML and return a sanitized version along with the
	* validation errors that were encountered during the scan.
	*/
	public struct function scan( required string unsafeHtml ) {

		var scanResults = antisamy.scan( javaCast( "string", unsafeHtml ), policy );
		var html = scanResults.getCleanHTML();
		var errors = scanResults.getErrorMessages();

		return {
			html: html,
			errors: errors
		};

	}


	public string function sanitize( required string unsafeHtml ) {

		return getSafeHtml(
			unsafeHtml,
			expandPath( "/core/lib/markdown/status/util/HtmlSanitizerPolicy.xml" ),
			false
		);

	}

}
