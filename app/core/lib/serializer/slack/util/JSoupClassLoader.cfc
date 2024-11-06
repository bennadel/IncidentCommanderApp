component
	output = false
	hint = "I provide a way to instantiate jSoup Java classes."
	{

	// Define properties for dependency-injection.
	property name="classLoader" ioc:skip memoryLeakDetector:skip;
	property name="classLoaderFactory" ioc:type="core.lib.ClassLoaderFactory";

	/**
	* I initialize the class loader factory.
	*/
	public void function $init() {

		variables.classLoader = classLoaderFactory.createClassLoader([
			expandPath( "/core/vendor/jsoup/1.18.1/jsoup-1.18.1.jar" )
		]);

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I create an instance of the given class.
	*/
	public any function create( required string classPath ) {

		return classLoader.create( javaCast( "string", classPath ) );

	}

}
