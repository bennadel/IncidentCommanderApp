component
	output = false
	hint = "I provide methods for parsing HTML using jSoup."
	{

	// Define properties for dependency-injection.
	property name="classloader" ioc:type="core.lib.classLoader.JSoupClassLoader";
	property name="jsoup" ioc:skip memoryLeakDetector:skip;;

	/**
	* I initialize the class loader factory.
	*/
	public void function $init() {

		variables.jsoup = create( "org.jsoup.Jsoup" );

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I create a JSoup class with the given class name.
	*/
	public any function create( required string className ) {

		return classloader.create( className );

	}


	/**
	* I parse the given fragment and return the resultant BODY node.
	*/
	public any function parseFragment( required string input ) {

		var node = jsoup
			.parseBodyFragment( javaCast( "string", input ) )
			.body()
		;

		return node;

	}

}
