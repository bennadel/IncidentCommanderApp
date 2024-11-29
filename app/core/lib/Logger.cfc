component
	output = false
	hint = "I provide logging methods for errors and arbitrary data."
	{

	// Define properties for dependency-injection.
	property name="bugSnagLogger" ioc:type="core.lib.bugsnag.BugSnagLogger";
	property name="requestMetadata" ioc:type="core.lib.RequestMetadata";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I report the given item using a CRITICAL log-level.
	*/
	public void function critical(
		required string message,
		any data = {}
		) {

		logData(
			level = "critical",
			message = message,
			data = data
		);

	}


	/**
	* I report the given item using a DEBUG log-level.
	*/
	public void function debug(
		required string message,
		any data = {}
		) {

		logData(
			level = "debug",
			message = message,
			data = data
		);

	}


	/**
	* I report the given item using an ERROR log-level.
	*/
	public void function error(
		required string message,
		any data = {}
		) {

		logData(
			level = "error",
			message = message,
			data = data
		);

	}


	/**
	* I report the given item using an INFO log-level.
	*/
	public void function info(
		required string message,
		any data = {}
		) {

		logData(
			level = "info",
			message = message,
			data = data
		);

	}


	/**
	* I log the given data as a pseudo-exception (ie, we're shoehorning general log data
	* into a bug log tracking system).
	*/
	public void function logData(
		required string level,
		required string message,
		required any data
		) {

		bugSnagLogger.logData(
			level = level,
			message = message,
			data = data,
			stacktrace = buildStacktraceForNonError(),
			requestContext = buildRequestContext()
		);

	}


	/**
	* I report the given EXCEPTION object using an ERROR log-level.
	*/
	public void function logException(
		required any error,
		string message = "",
		any data = {}
		) {

		// Adobe ColdFusion doesn't treat the error like a Struct (when validating call
		// signatures). Let's make a shallow copy of the error so that we can use proper
		// typing in subsequent method calls.
		error = structCopy( error );

		// The following errors are high-volume and don't represent much value. Let's
		// ignore these for now (since they aren't something that I can act upon).
		switch ( error.type ) {
			case "Nope":
				// Swallow error for now.
				return;
			break;
		}

		bugSnagLogger.logException(
			error = error,
			message = message,
			data = data,
			stacktrace = buildStacktraceForError( error ),
			requestContext = buildRequestContext()
		);

	}


	/**
	* I report the given item using a WARNING log-level.
	*/
	public void function warning(
		required string message,
		any data = {}
		) {

		logData(
			level = "warning",
			message = message,
			data = data
		);

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I build the normalized form scope.
	*/
	private struct function buildFormScope() {

		var formScope = form.copy();

		formScope.delete( "fieldnames" );

		// Redact any fields that pose a security issue.
		// --
		// Todo: make this a configuration option.
		for ( var key in [ "password", "x-xsrf-token" ] ) {

			if ( formScope.keyExists( key ) ) {

				formScope[ key ] = "[redacted]";

			}

		}

		return formScope;

	}


	/**
	* I build the normalized request context for all logging implementations.
	*/
	private struct function buildRequestContext() {

		return {
			event: requestMetadata.getEvent().toList( "." ),
			http: {
				method: requestMetadata.getMethod(),
				url: requestMetadata.getUrl(),
				referer: requestMetadata.getReferer(),
				remoteAddress: requestMetadata.getIpAddress(),
				headers: requestMetadata.getHeaders([
					"host",
					"accept",
					"cf-connecting-ip",
					"cf-ipcountry",
					"content-type",
					"origin",
					"referer",
					"user-agent",
					"x-forwarded-for",
					"x-forwarded-proto"
				])
			},
			urlScope: url.copy(),
			formScope: buildFormScope()
		};

	}


	/**
	* I build the stacktrace for the given error.
	*/
	private array function buildStacktraceForError( required struct error ) {

		var tagContext = ( error.tagContext ?: [] );

		return tagContext
			.filter(
				( item ) => {

					return item.template.reFindNoCase( "\.(cfm|cfc)$" );

				}
			)
			.map(
				( item ) => {

					return {
						file: item.template,
						lineNumber: item.line
					};

				}
			)
		;

	}


	/**
	* I build the stacktrace to be used for non-exception logging.
	*/
	private array function buildStacktraceForNonError() {

		return callstackGet()
			.filter(
				( item ) => {

					return ! item.template.findNoCase( "Logger" );

				}
			)
			.map(
				( item ) => {

					return {
						file: item.template,
						lineNumber: item.lineNumber
					};

				}
			)
		;

	}

}
