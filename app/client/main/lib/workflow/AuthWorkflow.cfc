component
	output = false
	hint = "I provide workflow methods pertaining to authentication."
	{

	// Define properties for dependency-injection.
	property name="accessCookies" ioc:type="client.main.lib.AccessCookies";
	property name="clock" ioc:type="core.lib.util.Clock";
	property name="logger" ioc:type="core.lib.Logger";
	property name="passwordEncoder" ioc:type="core.lib.PasswordEncoder";
	property name="payloadEncoder" ioc:type="core.lib.PayloadEncoder";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I attempt to authorize the current request against the given incident. If the
	* password is correct, the request is authorized and the authorization is persisted to
	* the underlying cookie.
	*/
	public void function authorizeIncident(
		required struct incident,
		required string password
		) {

		var expectedPassword = passwordEncoder.decode( incident.password );

		if ( compare( password, expectedPassword ) ) {

			// Todo: move this somewhere better.
			throw( type = "App.Model.Incident.Password.Mismatch" );

		}

		ensureAccess( incident );

	}


	/**
	* I check to see if the current request has authorized access to the given incident.
	*/
	public boolean function canAccessIncident( required struct incident ) {

		return getCredentials().keyExists( incident.id );

	}


	/**
	* I ensure that the current request (and subsequent requests) will have authorized
	* access to the given incident.
	*/
	public void function ensureAccess( required struct incident ) {

		var credentials = getCredentials();

		credentials[ incident.id ] = clock.utcNow()
			.add( "d", 1 )
			.getTime()
		;

		setCredentials( credentials );

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I get the access credentials from the underlying cookie. The credentials are
	* represented as a simple struct in which the keys are the incident IDs and the values
	* are the expiration epochs.
	*/
	private struct function getCredentials() {

		try {

			var accessToken = accessCookies.getCookie();
			var expirationCutoff = getTickCount();

			if ( ! accessToken.len() ) {

				return {};

			}

			return payloadEncoder
				.decode( accessToken )
				.filter(
					( incidentID, expiresAt ) => {

						return ( expiresAt > expirationCutoff );

					}
				)
			;

		} catch ( any error ) {

			// If for any reason the access cookie or payload don't appear to be in a good
			// state, just delete them. In the worst case scenario, the user will just re-
			// authenticate, which should fix whatever issue has occurred.
			accessCookies.deleteCookie();
			logger.logException( error, "Error getting credentials from access token." );

		}

		return {};

	}


	/**
	* I securely store the given credentials into the underlying cookie.
	*/
	private void function setCredentials( required struct credentials ) {

		accessCookies.setCookie( payloadEncoder.encode( credentials ) );

	}

}
