component
	output = false
	hint = "I provide miscellaneous utility functions."
	{

	/**
	* I group the given collection using the given key as the associative entry.
	*/
	public struct function groupBy(
		required array collection,
		required string key
		) {

		var index = {};

		for ( var element in collection ) {

			var groupKey = element[ key ];

			if ( ! index.keyExists( groupKey ) ) {

				index[ groupKey ] = [];

			}

			index[ groupKey ].append( element );

		}

		return index;

	}


	/**
	* I index the given collection using the given key as the associative entry.
	*/
	public struct function indexBy(
		required array collection,
		required string key
		) {

		var index = {};

		for ( var element in collection ) {

			index[ element[ key ] ] = element;

		}

		return index;

	}


	/**
	* I determine if the given value is a ColdFusion component instance.
	*/
	public boolean function isComponent( required any value ) {

		if ( ! isObject( value ) ) {

			return false;

		}

		// The isObject() function will return true for both components and Java objects.
		// As such, we need to go one step further to see if we can get at the component
		// metadata before we can truly determine if the value is a ColdFusion component.
		try {

			var metadata = getMetadata( value );

			return ( metadata?.type == "component" );

		} catch ( any error ) {

			return false;

		}

	}


	/**
	* SHIM: I'm hoping this can be removed in future versions of ColdFusion.
	*/
	public array function structValueArray( required struct input ) {

		return input.keyArray().map(
			( key ) => {

				return input[ key ];

			}
		);

	}


	/**
	* I convert the given collection to an array of entries. Each entry has (index, key,
	* and value) properties.
	*/
	public array function toEntries( required any collection ) {

		if ( isArray( collection ) ) {

			return collection.map(
				( value, i ) => {

					return {
						index: i,
						key: i,
						value: value
					};

				}
			);

		}

		if ( isStruct( collection ) ) {

			return collection.keyArray().map(
				( key, i ) => {

					return {
						index: i,
						key: key,
						value: collection[ key ]
					};

				}
			);

		}

		throw(
			type = "UnsupportedCollectionType",
			message = "Cannot get entries for unsupported collection type."
		);

	}

}
