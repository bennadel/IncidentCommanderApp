component
	output = false
	hint = "I generate random slugs for incident security."
	{

	/**
	* I generate a random slug. The slug is URL-friendly.
	*/
	public string function nextSlug() {

		var slugLength = 64;
		var alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-";
		var alphabetLength = alphabet.len();
		var letters = [ "i" ];

		for ( var i = 1 ; i < slugLength ; i++ ) {

			letters.append( alphabet[ randRange( 1, alphabetLength, "sha1prng" ) ] );

		}

		return letters.toList( "" );

	}

}
