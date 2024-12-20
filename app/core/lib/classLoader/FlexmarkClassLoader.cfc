component
	output = false
	hint = "I provide a way to instantiate Flexmark Java classes."
	{

	// Define properties for dependency-injection.
	property name="classLoader" ioc:skip memoryLeakDetector:skip;
	property name="classLoaderFactory" ioc:type="core.lib.classLoader.ClassLoaderFactory";

	/**
	* I initialize the class loader factory.
	*/
	public void function $init() {

		// https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.64.8
		variables.classLoader = classLoaderFactory.createClassLoader([
			expandPath( "/core/vendor/flexmark/0.64.8/annotations-24.0.1.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/autolink-0.6.0.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-ext-autolink-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-ast-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-builder-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-collection-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-data-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-dependency-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-format-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-html-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-misc-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-options-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-sequence-0.64.8.jar" ),
			expandPath( "/core/vendor/flexmark/0.64.8/flexmark-util-visitor-0.64.8.jar" )
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
