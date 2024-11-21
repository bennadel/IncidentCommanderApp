component
	output = false
	hint = "I provide methods for encoding and decoding values as Base64Url."
	{

	/**
	* I decode the given Base64Url input into a binary value.
	*/
	public binary function decode( required string input ) {

		var base64Input = input
			.replace( "-", "+", "all" )
			.replace( "_", "/", "all" )
		;
		// When we generate the URL-safe value, we strip out the padding characters at the
		// end. When we decode the input, we then need to put the padding characters back
		// in. I don't think this is strictly required in all context; but, is adheres to
		// the Base64 specification on length.
		var paddingLength = ( 4 - ( base64Input.len() % 4 ) );
		var padding = repeatString( "=", paddingLength );

		return binaryDecode( ( base64Input & padding ), "base64" );

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

		return binaryEncode( input, "base64" )
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
