component
	output = false
	hint = "I provide methods for generating cryptographically secure random data."
	{

	/**
	* I return a random byte array of the given length.
	*/
	public binary function getBytes( required numeric length ) {

		var bytes = [];

		for ( var i = 1 ; i <= length ; i++ ) {

			bytes.append( randRange( -128, 127, "sha1prng" ) );

		}

		return javaCast( "byte[]", bytes );

	}

}
