component
	output = false
	hint = "I provide a way to instantiate OWASP AntiSamy Java classes."
	{

	// Define properties for dependency-injection.
	property name="classLoader" ioc:skip;
	property name="classLoaderFactory" ioc:type="core.lib.ClassLoaderFactory";

	/**
	* I initialize the class loader factory.
	*/
	public void function $init() {

		// https://mvnrepository.com/artifact/org.owasp.antisamy/antisamy/1.7.6
		variables.classLoader = classLoaderFactory.createClassLoader([
			expandPath( "/core/vendor/antisamy/1.7.6/antisamy-1.7.6.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/batik-constants-1.17.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/batik-css-1.17.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/batik-i18n-1.17.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/batik-shared-resources-1.17.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/batik-util-1.17.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/commons-io-2.16.1.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/commons-logging-1.0.4.jar" ),
			// expandPath( "/core/vendor/antisamy/1.7.6/httpclient5-5.3.1.jar" ),
			// expandPath( "/core/vendor/antisamy/1.7.6/httpcore5-5.2.5.jar" ),
			// expandPath( "/core/vendor/antisamy/1.7.6/httpcore5-h2-5.2.4.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/neko-htmlunit-4.3.0.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/slf4j-api-2.0.13.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/xercesImpl-2.12.2.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/xml-apis-1.4.01.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/xml-apis-ext-1.3.04.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/xml-resolver-1.2.jar" ),
			expandPath( "/core/vendor/antisamy/1.7.6/xmlgraphics-commons-2.9.jar" )
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


	/**
	* I execute the given operator in a thread that forces the use of the AntiSamy class
	* loader. This gets around issues in which Java classes try to load dependencies from
	* the wrong Class Loader.
	* 
	* NOTE: While in this method, you cannot access the core ColdFusion classes. As such,
	* this method should do AS LITTLE AS POSSIBLE such that it can return to the normal
	* execution context as fast as possible.
	*/
	public any function runWithForcedLoader(
		required function operator,
		required struct operatorArguments
		) {

		return classLoader.switchThreadContextClassLoader( operator, operatorArguments );

	}

}
