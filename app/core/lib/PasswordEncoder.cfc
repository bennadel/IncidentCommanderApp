component
	output = false
	hint = "I provide methods for encrypting passwords at rest."
	{

	// Define properties for dependency-injection.
	property name="algorithm" ioc:skip;
	property name="base64UrlEncoder" ioc:type="core.lib.util.Base64UrlEncoder";
	property name="defaultKey" ioc:get="config.aesKeys.passwordEncoder";
	property name="ivSize" ioc:skip;
	property name="keySize" ioc:skip;

	/**
	* I initialize the password encoder.
	*/
	public void function init() {

		// [AES] = Advanced Encryption Standard. This is the new default as of the latest
		// ColdFusion update; but, I'm defining it explicitly for clarity.
		// [CBC] = Cipher Block Chaining. This uses a single thread to process one block
		// of data at a time, using the results of the previous block as the key used to
		// encrypt the next block.
		variables.algorithm = "AES/CBC/PKCS5Padding";

		// Note: the ColdFusion documentation states that the AES algorithm is limited to
		// 128 bits unless the Java Unlimited Strength Jurisdiction Policy Files are
		// installed. It's unclear to me if that is the common case or an outlier case.
		// Regardless, it seems to work for me in my development environment no problem.
		variables.keySize = 256;

		// The initialize vector (IV) size is tied to the block size of the AES algorithm,
		// which uses a fixed-block size of 16-bytes (128 bits). This has nothing to do
		// with the size of the encryption key that we will use.
		variables.ivSize = 128;

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I decode the given encrypted password.
	*/
	public string function decode(
		required string input,
		string key = defaultKey
		) {

		// If there's no value to decode, just return the input. This keeps the calling
		// context logic simple and uniform.
		if ( ! input.len() ) {

			return "";

		}

		// The encoded password is actually a compound token that includes both the unique
		// initialization vector and the encrypted password. To decrypt the password, we
		// have to break the token apart.
		var parts = input.listToArray( "." );
		var initializationVector = base64UrlEncoder.decode( parts[ 1 ] );
		var encodedPassword = base64UrlEncoder.decodeToBase64( parts[ 2 ] );

		return decrypt(
			encodedPassword,
			key,
			algorithm,
			"base64",
			initializationVector
		);

	}


	/**
	* I encode the given plain-text password.
	*/
	public string function encode(
		required string input,
		string key = defaultKey
		) {

		// If there's no value to encode, just return the input. This keeps the calling
		// context logic simple and uniform.
		if ( ! input.len() ) {

			return "";

		}

		// The initialization vector works much like the salt in a hashing routine. It
		// ensures that similar inputs always produce a different output, thereby making
		// it harder for a malicious actor to brute-force a decryption routine.
		var initializationVector = generateInitializationVectorForAlgorithm();

		var encodedPassword = encrypt(
			input,
			key,
			algorithm,
			"base64",
			initializationVector
		);

		// Much like the bCrypt hashing, we're going to return a compound token value that
		// contains both the "salt" and the encrypted payload. This way, the token can be
		// stored and passed around a single unit.
		// --
		// Note: there's no technical reason that I have to encode these values using the
		// Base64url format - this is just for aesthetics (I rather dislike those padding
		// characters at the end, seems entirely unnecessary).
		return (
			base64UrlEncoder.encode( initializationVector ) &
			"." &
			base64UrlEncoder.encodeFromBase64( encodedPassword )
		);

	}

	/**
	* I generate a Base64-encoded key for use with the AES encryption algorithm.
	* 
	* Note: this is a utility function to help generate one-off keys to be stored securely
	* outsize of the ColdFusion code.
	*/
	public string function generateKeyForAlgorithm() {

		return generateSecretKey( "AES", keySize );

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I generate a Base64-encoded initialization vector for the AES algorithm.
	*/
	private binary function generateInitializationVectorForAlgorithm() {

		return binaryDecode( generateSecretKey( "AES", ivSize ), "base64" );

	}

}
