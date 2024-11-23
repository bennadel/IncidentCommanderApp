component
	output = false
	hint = "I provide methods for encoding and decoding values as Base64Url."
	{

	/**
	* I decode the given Base64Url input into a binary value.
	*/
	public binary function decode( required string input ) {

		return binaryDecode( decodeToBase64( input ), "base64" );

	}


	/**
	* I decode the given Base64Url input into a Base64 value.
	*/
	public string function decodeToBase64( required string input ) {

		var unpadded = input
			.replace( "-", "+", "all" )
			.replace( "_", "/", "all" )
		;
		// When we generate the URL-safe value, we strip out the padding characters at the
		// end. When we decode the input, we then need to append the padding characters
		// back on the end.
		var paddingLength = ( 4 - ( unpadded.len() % 4 ) );
		var padding = repeatString( "=", paddingLength );

		return ( unpadded & padding );

	}


	/**
	* I decode the given Base64Url input into a string value with the given encoding.
	*/
	public string function decodeToString(
		required string input,
		string encoding = "utf-8"
		) {

		return charsetEncode( decode( input ), encoding );

	}


	/**
	* I encode the given binary input into a Base64Url value.
	*/
	public string function encode( required binary input ) {

		return encodeFromBase64( binaryEncode( input, "base64" ) );

	}


	/**
	* I encode the given Base64 input into a Base64Url value.
	*/
	public string function encodeFromBase64( required string input ) {

		return input
			.replace( "+", "-", "all" )
			.replace( "/", "_", "all" )
			.replace( "=", "", "all" )
		;

	}


	/**
	* I encode the given string input with given encoding into a Base64Url value.
	*/
	public string function encodeFromString(
		required string input,
		string encoding = "utf-8"
		) {

		return encode( charsetDecode( input, encoding ) );

	}


	/**
	* I encode the given HEX input into a Base64Url value.
	*/
	public string function encodeFromHex( required string input ) {

		return encode( binaryDecode( input, "hex" ) );

	}

}
