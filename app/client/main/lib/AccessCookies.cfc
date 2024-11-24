component
	output = false
	hint = "I provide method for managing incident access cookies for the current request."
	{

	// Define properties for dependency-injection.
	property name="config" ioc:type="config";
	property name="cookieName" ioc:skip;
	property name="expiresInDays" ioc:skip;

	/**
	* I initialize the access cookies service.
	*/
	public void function $init() {

		variables.cookieName = "ic_access";
		// The cookie contains a set of access credentials for different incidents. Each
		// credential encodes its own expiration date. But, we also don't want the cookie
		// itself to expire in a somewhat timely manner.
		variables.expiresInDays = 7;

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I delete / expire the current cookie.
	*/
	public void function deleteCookie() {

		cookie[ cookieName ] = buildCookieSettings({
			value: "",
			expires: "now"
		});

	}


	/**
	* I get the current cookie.
	*/
	public string function getCookie() {

		return ( cookie[ cookieName ] ?: "" );

	}


	/**
	* I set / store the current cookie.
	*/
	public void function setCookie( required string accessToken ) {

		cookie[ cookieName ] = buildCookieSettings({
			value: accessToken,
			expires: expiresInDays
		});

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I build the cookie configuration using the given property overrides.
	*/
	private struct function buildCookieSettings( required struct overrides ) {

		// Caution: [sameSite:"strict"] means that the cookies will only be sent when the
		// request originates from the same site. Which means, if the user clicks on the
		// link from Slack, they'll have to re-enter the password even if they've already
		// entered it before. Let me start this way (with tighter security); and then, if
		// it proves to be a terrible UX, I can change it to be [sameSite:"lax"] for
		// easier cross-site navigation / authentication.
		var settings = [
			name: cookieName,
			domain: config.site.cookieDomain,
			encodeValue: false,
			httpOnly: true,
			secure: config.isLive, // I only have an SSL certificate in production.
			sameSite: "strict",
			preserveCase: true
		];

		// The "value" and "expires" attributes are expected to be overridden.
		settings.append( overrides );

		return settings;

	}

}
