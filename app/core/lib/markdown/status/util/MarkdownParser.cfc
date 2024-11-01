component
	output = false
	hint = "I provide methods for parsing status markdown into HTML."
	{

	// Define properties for dependency-injection.
	property name="classLoader" ioc:type="core.lib.markdown.status.util.MarkdownParserClassLoader";
	property name="parser" ioc:skip;
	property name="renderer" ioc:skip;

	/**
	* I initialize the markdown parser.
	*/
	public void function $init() {

		var AutolinkExtensionClass = classLoader.create( "com.vladsch.flexmark.ext.autolink.AutolinkExtension" );
		var HtmlRendererClass = classLoader.create( "com.vladsch.flexmark.html.HtmlRenderer" );
		var ParserClass = classLoader.create( "com.vladsch.flexmark.parser.Parser" );

		// The option are used to configure both the parser and the renderer.
		var options = classLoader.create( "com.vladsch.flexmark.util.data.MutableDataSet" )
			.init()
		;
		// Define the extensions we're going to use. In this case, the only extension I
		// want to add is the Autolink extension, which automatically turns URLs into
		// Anchor tags.
		options.set(
			ParserClass.EXTENSIONS,
			[
				AutolinkExtensionClass.create()
			]
		);
		// Configure the Autolink extension. By default, this extension will create
		// anchor tags for both WEB addresses and MAIL addresses. But, no one uses the
		// "mailto:" link anymore. As such, I am going to configure the Autolink extension
		// to ignore any "link" that looks like an email. This should result in only WEB
		// addresses getting linked.
		options.set(
			AutolinkExtensionClass.IGNORE_LINKS,
			javaCast( "string", "[^@:]+@[^@]+" )
		);
		// Turn soft-breaks into hard-breaks (ie. line-returns into BR tags).
		options.set(
			HtmlRendererClass.SOFT_BREAK,
			javaCast( "string", "<br />#chr( 10 )#" )
		);

		// Create our parser and renderer - both using the options.
		variables.parser = ParserClass
			.builder( options )
			.build()
		;
		variables.renderer = HtmlRendererClass
			.builder( options )
			.build()
		;

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I parse the given markdown input into HTML.
	*/
	public string function toHtml( required string markdown ) {

		// Parse the markdown into an AST (Abstract Syntax Tree) document node.
		var document = parser.parse( javaCast( "string", markdown ) );

		// Render the AST (Abstract Syntax Tree) document into an HTML string.
		return renderer.render( document );

	}

}
