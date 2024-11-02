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
		// Starting every slug with "i" plays two roles. First, it ensures that the value
		// always starts with a letter, which helps to ensure that the value is always
		// interpreted as a string. Second, it ensures that the value never starts with a
		// "-" which would confuse the compound ("{id}-{slug}") token-parsing used to
		// identify the incident within the URL scheme.
		var letters = [ "i" ];

		for ( var i = 1 ; i <= slugLength ; i++ ) {

			letters.append( alphabet[ randRange( 1, alphabetLength, "sha1prng" ) ] );

		}

		return letters.toList( "" );

	}

}
