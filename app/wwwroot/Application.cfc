component
	output = false
	hint = "I setup the application settings and event handlers."
	{

	// Define the application.
	this.name = "AppIncidentCommanderCom";
	this.applicationTimeout = createTimeSpan( 1, 0, 0, 0 );
	this.sessionManagement = false;
	this.setClientCookies = false;
	// As a security best practice, we DO NOT WANT to search for unscoped variables in any
	// scope other than the core variables, local, and arguments scope. The CGI, FORM,
	// URL, COOKIE, etc. should only ever be referenced explicitly.
	this.searchImplicitScopes = false;
	// Make sure that every struct key-case matches its original defining context. This
	// way, we don't get any unexpected upper-casing of keys (a legacy behavior).
	this.serialization = {
		preserveCaseForStructKey: true,
		preserveCaseForQueryColumn: true
	};
	// Make sure that all arrays are passed by reference. Historically, arrays have been
	// passed by value, which has no place in a modern language.
	this.passArrayByReference = true;
	// Make sure form fields with the same name are aggregated as an array. Historically,
	// like-named field were aggregated as a comma-delimited list.
	this.sameFormFieldsAsArray = true;
	// Stop ColdFusion from replacing "<script>" tags with "InvalidTag". This doesn't
	// really help us out.
	this.scriptProtect = "none";

	// CAUTION: We use this directory value to both load configuration files and to setup
	// mappings. As such, let's define it as the first thing we do.
	this.wwwroot = getDirectoryFromPath( getCurrentTemplatePath() );
	this.config = getConfigSettings();

	// Define the per-application path mappings. This is used for component paths and
	// expandPath() resolution.
	this.mappings = {
		"/client": "#this.wwwroot#../client",
		"/config": "#this.wwwroot#../config",
		"/core": "#this.wwwroot#../core",
		"/javaloader": "#this.wwwroot#../core/vendor/javaLoader",
		"/wwwroot": this.wwwroot
	};

	// Define the default data-source.
	this.datasources = {
		// Caution: The data-source names are CASE-SENSITIVE and need to be quoted.
		"incident_commander": {
			username: this.config.dsn.username,
			password: this.config.dsn.password,
			driver: "MySQL",
			class: "com.mysql.cj.jdbc.Driver",
			url: (
				"jdbc:mysql://#this.config.dsn.server#:#this.config.dsn.port#/#this.config.dsn.database#" &
				"?allowMultiQueries=true" &
				"&characterEncoding=UTF-8" &
				"&serverTimezone=UTC" &
				"&tinyInt1isBit=false" &
				// Max Performance properties: https://github.com/mysql/mysql-connector-j/blob/release/8.0/src/main/resources/com/mysql/cj/configurations/maxPerformance.properties
				"&useConfigs=maxPerformance"
				// NOTE: Leaving zeroDateTimeBehavior as default (EXCEPTION) since I don't
				// like the idea of any data/times values being shoe-horned into a working
				// version. I'd rather see the errors and then deal with them.
			),

			// Allowed SQL commands.
			delete: true,
			insert: true,
			select: true,
			update: true,

			// Disallowed SQL commands.
			alter: false,
			create: false,
			drop: false,
			grant: false,
			revoke: false,
			storedproc: false,

			// Disables the returning of generated keys (such as PKEY AUTO_INCREMENT) in
			// the "result" meta-data structure.
			disable_autogenkeys: false,

			// These two properties seem to work in conjunction and limit the size of the
			// long-text fields that can be PULLED BACK FROM THE DATABASE. If the CLOB is
			// disabled, then the given buffer size will truncate the value coming back
			// from the database.
			// --
			// Note: To be clear, this DOES NOT appear to prevent the INSERT of large
			// values GOING INTO the database - just the retrieval of large values coming
			// OUT OF the database.
			disable_clob: false,
			buffer: 0, // Doesn't mean anything unless above is TRUE.

			// I ASSUME these two properties for BLOB work the same way as the CLOB
			// settings above; but, I have not tested them directly.
			disable_blob: true,
			blob_buffer: 64000, // Doesn't mean anything unless above is TRUE.

			// Connection pooling.
			// --
			// Caution: I have NOT VALIDATED that the following settings actually work
			// (except for the urlmap.maxConnection property).
			pooling: true,
			// The number of seconds before ColdFusion times out the data source
			// connection login attempt.
			login_timeout: 30,
			// The number of seconds that ColdFusion maintains an unused connection before
			// destroying it.
			timeout: 1200,
			// The number of seconds that the server waits between cycles to check for
			// expired data source connections to close.
			interval: 420
			// urlmap: {
			// 	// Limit the number of concurrent connections to this datasource.
			// 	// --
			// 	// Caution: This value has to be a STRING - if you use a NUMBER, the
			// 	// entire datasource configuration will fail. And, if you don't want to
			// 	// limit connection, you have to OMIT THIS VALUE ENTIRELY.
			// 	// --
			// 	// maxConnections: ""
			// }
		}
	};
	this.datasource = "incident_commander";

	// ---
	// LIFE-CYCLE METHODS.
	// ---

	/**
	* I get called once to initialize the application.
	*
	* Note: This method is inherently single-threaded by the ColdFusion server. However,
	* if this method is called as part of an explicit re-initialization, then it will not
	* be single-threaded and concurrent traffic needs to be considered.
	*/
	public void function onApplicationStart() {

		var ioc
			= application.ioc
				= new core.lib.Injector()
		;
		// Provide the IoC container back to itself. This allows the Injector to be
		// injected into other services which may have need of more manual orchestration.
		ioc.provide( "core.lib.Injector", ioc );

		var config
			= this.config
				= application.config
					= ioc.provide( "config", getConfigSettings( useCachedConfig = false ) )
		;

		ioc.provide(
			"javaLoaderFactory",
			new core.vendor.javaLoaderFactory.JavaLoaderFactory()
		);

		// As the very last step in the initialization process, we want to flag that the
		// application has been fully bootstrapped. This way, we can test the state of the
		// application in the global onError() event handler.
		application.isBootstrapped = true;

	}


	/**
	* I get called once to initialize the request.
	*/
	public void function onRequestStart() {

		if ( url?.init == this.config.initPassword ) {

			this.onApplicationStart();

			// In the production app, redirect to the non-init page so that we don't run
			// the risk of re-initializing the application more often than we have to.
			if ( this.config.isLive ) {

				location( url = cgi.script_name, addToken = false );

			}

		}

		// Polyfill the Lucee CFML behavior in which "field[]" notation causes multiple
		// fields to be grouped together as an array. This is the way.
		polyfillFormFieldGrouping( form );

		// By default, we want the request timeout to be relatively low so that we lock
		// page processing down. This means that we have to make a cognizant choice to
		// create slow(er) pages later on by explicitly extending the timeout.
		cfsetting(
			requestTimeout = 5,
			showDebugOutput = false
		);

		// Create a unified container for all of the data submitted by the user. This will
		// make it easier to access data when a workflow might deliver the data initially
		// in the URL scope and then subsequently in the FORM scope.
		request.context = structNew()
			.append( url )
			.append( form )
		;

		request.ioc = application.ioc;

	}


	/**
	* I get called once to finalize the request.
	*/
	public void function onRequestEnd() {

		if ( this.config.isLive ) {

			return;

		}

		// Since the memory leak detection only runs in the development environment, I'm
		// not going to put any safe-guards around it. The memory leak detector both reads
		// from and writes to shared memory, which can be inherently unsafe. However, the
		// risks here are minimal.
		request.ioc.get( "core.lib.MemoryLeakDetector" )
			.inspect()
		;

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I return the application's environment-specific config object.
	*
	* Caution: The config object is cached in the SERVER scope using "this.name" as part
	* of the access key. It also uses "this.wwwroot" to locate the config object.
	*/
	private struct function getConfigSettings( boolean useCachedConfig = true ) {

		var configName = "appConfig_#this.name#";

		if ( useCachedConfig && server.keyExists( configName ) ) {

			return server[ configName ];

		}

		var config
			= server[ configName ]
				= deserializeJson( fileRead( "#this.wwwroot#../config/config.json" ) )
		;

		return config;

	}


	/**
	* I polyfill the "field[]" form parameter grouping behavior in Adobe ColdFusion.
	*/
	private void function polyfillFormFieldGrouping( required struct formScope ) {

		// If the fieldNames entry isn't defined, the form scope isn't populated.
		if ( ! formScope.keyExists( "fieldNames" ) ) {

			return;

		}

		// The parameter map gives us every form field as an array.
		var rawFormData = getPageContext()
			.getRequest()
			.getParameterMap()
		;

		for ( var key in rawFormData.keyArray() ) {

			if ( key.right( 2 ) == "[]" ) {

				// Remove the "[]" suffix.
				var normalizedKey = key.left( -2 );
				// The underlying Java value is of type, "string[]". We need to convert
				// that value to a native ColdFusion array (ArrayList) so that it will
				// behave like any other array, complete with member methods.
				var normalizedValue = arrayNew( 1 )
					.append( rawFormData[ key ], true )
				;

				// Swap the form scope key-value pairs with the normalized versions.
				formScope[ normalizedKey ] = normalizedValue;
				formScope.delete( key );

			}

		}

		// Clean-up list of field names (removing [] notation).
		formScope.fieldNames = formScope.fieldNames
			.reReplace( "\[\](,|$)", "\1", "all" )
		;

	}

}
