component
	output = false
	hint = "I provide methods for sanitizing the parsed HTML content."
	{

	// Define properties for dependency-injection.
	property name="classLoader" ioc:type="core.lib.classLoader.JSoupClassLoader";
	property name="cleaner" ioc:skip memoryLeakDetection:skip;
	property name="safelist" ioc:skip memoryLeakDetection:skip;

	/**
	* I initialize the HTML sanitizer.
	*/
	public void function $init() {

		variables.safelist = classLoader.create( "org.jsoup.safety.Safelist" )
			.init()
			// Basic formatting.
			.addTags([ "strong", "b", "em", "i", "u", "strike" ])
			// Headers -- do we really want to allow these? Maybe in the mid-term we'll
			// replace them with P[Strong] versions. It just seems strange to have headers
			// in a status update.
			.addTags([ "h1", "h2", "h3", "h4", "h5", "h6" ])
			// Basic structuring.
			.addTags([ "p", "blockquote", "ul", "ol", "li", "br" ])
			// Code blocks.
			.addTags([ "pre", "code" ])
			.addAttributes( "pre", [ "class" ] )
			.addAttributes( "code", [ "class" ] )
			// Anchor links.
			.addTags([ "a" ])
			.addAttributes( "a", [ "href" ] )
			.addProtocols( "a", "href", [ "http", "https" ] )
			.addEnforcedAttribute( "a", "rel", "noopener noreferrer" )
			.addEnforcedAttribute( "a", "target", "_blank" )
		;

		variables.cleaner = classLoader.create( "org.jsoup.safety.Cleaner" )
			.init( safelist )
		;

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I sanitize the given HTML - any invalid or illegal markup is removed.
	*/
	public string function sanitize( required string unsafeHtml ) {

		var untrustedDom = classLoader.create( "org.jsoup.Jsoup" )
			.parse( unsafeHtml )
		;
		var trustedDom = cleaner.clean( untrustedDom );

		return trustedDom.body().html();

	}

}
