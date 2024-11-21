component
	output = false
	hint = "I provide methods for securely encoding and decoding a payload. The payload is not encrypted (its contents can be viewed by anyone), but the contents are signed in order to prevent tampering."
	{

	// Define properties for dependency-injection.
	property name="base64UrlEncoder" ioc:type="core.lib.util.Base64UrlEncoder";
	property name="defaultAlgorithm" ioc:skip;
	property name="secureRandom" ioc:type="core.lib.util.SecureRandom";
	property name="supportedAlgorithms" ioc:skip;

	/**
	* I initialize the payload encoder.
	*/
	public void function $init() {

		// Each successive algorithm produces a more secure authentication code. But, this
		// comes at the cost of a longer output, more processing overhead, and calls for a
		// longer secret key (see the generateKeyForAlgorithm() method). For simple web
		// application needs, Sha256 is widely recommended as it strikes a good balance
		// between security and speed. Hence it is the default.
		variables.supportedAlgorithms = [
			"HmacSHA256",
			"HmacSHA384",
			"HmacSHA512"
		];
		variables.defaultAlgorithm = supportedAlgorithms.first();

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I decode the given token into the original payload. The key is assumed to be a
	* Base64-encoded value.
	*/
	public any function decode(
		required string token,
		required string key,
		string algorithm = defaultAlgorithm
		) {

		key = testKey( key );
		algorithm = testAlgorithm( algorithm );

		var segments = parseToken( token );
		// Before we parse and deserialize any of the data segments, let's ensure that the
		// token has not been tampered with. To do this, we're going to regenerate the
		// signature and then make sure that it matches the one provided by the token.
		var expectedSignature = buildSignatureSegment( segments.payload, key, algorithm );

		if ( compare( segments.signature, expectedSignature ) ) {

			throw(
				type = "PayloadEncoder.Token.SignatureMismatch",
				message = "The token signature does not match the expected signature."
			);

		}

		// At this point, we know that the token signature has been validated, which means
		// that all segments should be in a known good state. As such, I'm NOT going to
		// wrap this in any error handling. Any error that occurs during the parsing of
		// the segments will be a bug and (can be caught and logged at a higher level).
		return parsePayloadSegment( segments.payload );

	}


	/**
	* I encode the given payload into a secure token. The payload can be any serializable
	* value. The key is assumed to be a Base64-encoded value.
	*/
	public string function encode(
		required any payload,
		required string key,
		string algorithm = defaultAlgorithm
		) {

		key = testKey( key );
		algorithm = testAlgorithm( algorithm );

		var payloadSegment = buildPayloadSegment( payload );
		var signatureSegment = buildSignatureSegment( payloadSegment, key, algorithm );

		return "#payloadSegment#.#signatureSegment#";

	}


	/**
	* I generate a secure, random key of a length recommended for the given algorithm.
	*/
	public binary function generateKeyForAlgorithm( string algorithm = defaultAlgorithm ) {

		switch ( testAlgorithm( algorithm ) ) {
			// https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.hmacsha256.-ctor?view=net-9.0
			case "HmacSHA256":
				return secureRandom.getBytes( 64 );
			break;
			// https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.hmacsha384.-ctor?view=net-9.0
			case "HmacSHA384":
			// https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.hmacsha512.-ctor?view=net-9.0
			case "HmacSHA512":
				return secureRandom.getBytes( 128 );
			break;
		}

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I serialize the given payload into a segment.
	*/
	private string function buildPayloadSegment( required any payload ) {

		return base64UrlEncoder.encodeFromString( serializeJson( payload ) );

	}


	/**
	* I build the signature to prevent tampering with the given segments.
	*/
	private string function buildSignatureSegment(
		required string payloadSegment,
		required binary key,
		required string algorithm
		) {

		return base64UrlEncoder.encodeFromHex( hmac( payloadSegment, key, algorithm ) );

	}


	/**
	* I parse the given payload segment (it can result in any value).
	*/
	private any function parsePayloadSegment( required string payloadSegment ) {

		return deserializeJson( base64UrlEncoder.decodeToString( payloadSegment ) );

	}


	/**
	* I parse the given token into segments (which remain serialized and encoded).
	*/
	private struct function parseToken( required string token ) {

		var parts = token.listToArray( "." );

		if (
			( parts.len() != 2 ) ||
			! parts[ 1 ].len() ||
			! parts[ 2 ].len()
			) {

			throw(
				type = "PayloadEncoder.Token.Invalid",
				message = "The token doesn't have 2 dot-delimited segments."
			);

		}

		return {
			payload: parts[ 1 ],
			signature: parts[ 2 ]
		};

	}


	/**
	* I validate and return a normalized algorithm name.
	*/
	private string function testAlgorithm( required string algorithm ) {

		for ( var element in supportedAlgorithms ) {

			// Note: we're returning the one in the internal array in order to ensure
			// proper key-casing for when we pass the name into the hmac() function - I'm
			// not sure if it even matters, but I like to keep it consistently cased.
			if ( element == algorithm ) {

				return element;

			}

		}

		throw(
			type = "PayloadEncoder.Algorithm.Invalid",
			message = "The algorithm is not currently supported.",
			detail = "[#algorithm#] is not one of [#supportedAlgorithms.toList( ', ' )#]."
		);

	}


	/**
	* I validate and return a normalized key (which is converted into a binary value for
	* consumption in the hmac() function).
	*/
	private binary function testKey( required string key ) {

		if ( ! key.len() ) {

			throw( type = "PayloadEncoder.Key.Empty" );

		}

		try {

			return binaryDecode( key, "base64" );

		} catch ( any error ) {

			throw(
				type = "PayloadEncoder.Key.Invalid",
				message = "The key cannot be decoded as a Base64 value."
			);

		}

	}

}
