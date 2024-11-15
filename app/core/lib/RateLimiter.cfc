/**
* Note: In a perfect world, I'd put this kind of functionality in Redis. However, since
* this is a small application that very few people will ever use, I'm going to brute-force
* it into the application memory space for now. I can always move to Redis it becomes a
* performance issue. The problem with this from an ergonomics perspective is that it makes
* locking much more complicated. I will have to lock at both the collection level and at
* the entry level.
*/
component
	output = false
	hint = "I provide methods for rate-limiting around a given property."
	{

	// Define properties for dependency-injection.
	property name="features" ioc:skip;
	property name="nextPurgeAt" ioc:skip;
	property name="purgeDelayInMilliseconds" ioc:skip;
	property name="windows" ioc:skip;

	/**
	* I initialize the rate limiting with the given configurations.
	*/
	public void function init() {

		var ONE_MINUTE = ( 60 * 1000 );
		var ONE_HOUR = ( 60 * ONE_MINUTE );

		// Features hold the settings for the workflows being rate-limited.
		variables.features = {
			// How many requests across ALL USERS can be made to the incident subsystem.
			"incident-by-all": createSettings( 300, ONE_MINUTE ),
			// How many requests by a given IP can be made to the incident subsystem.
			// Note that this is relatively high for now since this is also going to be
			// serving up screenshot images.
			"incident-by-ip": createSettings( 60, ONE_MINUTE ),
			// How many incidents can be started by a given IP.
			"start-by-ip": createSettings( 2, ONE_MINUTE )
		};
		// Windows hold specific instances of a feature being rate-limited for a specific
		// window ID (ie, the user/client uniquely identifying the request).
		variables.windows = {};
		// Since we're not managing this rate limiting functionality in a more
		// sophisticated system like Redis, we need to occasionally purge the in-memory
		// data. We're going to do this with a periodic blocking lock.
		variables.purgeDelayInMilliseconds = ONE_MINUTE;
		variables.nextPurgeAt = ( getTickCount() + purgeDelayInMilliseconds );

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I apply the current request against the associated feature window. If the count
	* exceeds the current window, an error is thrown. If not, a copy of the window state
	* is returned.
	*/
	public struct function testRequest(
		required string featureID,
		required string windowID
		) {

		purgeExpiredWindows();

		var window = getWindow( featureID, windowID );

		lock attributeCollection = getWindowLockExclusive( window.key ) {

			var timestamp = getTickCount();

			// Reset the window if its expired (or if its just been created).
			if ( window.expiresAt <= timestamp ) {

				window.expiresAt = ( timestamp + window.duration );
				window.count = 0;

			}

			if ( ++window.count > window.limit ) {

				throw(
					type = "App.RateLimit.TooManyRequests",
					message = "Rate limit feature window exceeded.",
					detail = "The rate limit window [#window.key#] has exceeded [#window.limit#], current count: [#window.count#]."
				);

			}

			return window.copy();

		}

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I create a settings structure with the given properties.
	*/
	private struct function createSettings(
		required numeric limit,
		required numeric duration
		) {

		return {
			limit: limit,
			duration: duration
		};

	}


	/**
	* I build the attributes for an exclusive collection lock with the given timeout.
	*/
	private struct function getCollectionLockExclusive( numeric timeoutInSeconds = 10 ) {

		return getCollectionLockShared( timeoutInSeconds ).append({
			type: "exclusive"
		});

	}


	/**
	* I build the attributes for a read-only collection lock with the given timeout.
	*/
	private struct function getCollectionLockShared( numeric timeoutInSeconds = 10 ) {

		return {
			name: "RateLimiter.Collection",
			type: "readonly",
			timeout: timeoutInSeconds
		};

	}


	/**
	* I get the feature with the given ID.
	*/
	private struct function getFeature( required string featureID ) {

		if ( ! features.keyExists( featureID ) ) {

			throw(
				type = "FeatureNotFound",
				message = "Rate limit feature not found.",
				detail = "The rate limit service does not have a feature with ID [#featureID#]. Features must be predefined."
			);

		}

		return features[ featureID ];

	}


	/**
	* I get the window for the for the given IDs.
	*/
	private struct function getWindow(
		required string featureID,
		required string windowID
		) {

		var feature = getFeature( featureID );
		var windowKey = lcase( "#featureID#:#windowID#" );

		// Since we're managing the rate limit data in-memory, we have to collocate both
		// the entry logic and the purging logic. And, since accessing a window may
		// trigger the creation of a new entry in the windows collection, we need to
		// acquire a collection lock. This way, we don't attempt to access a window that
		// is in the process of being purged.
		lock attributeCollection = getCollectionLockShared() {

			if ( windows.keyExists( windowKey ) ) {

				return windows[ windowKey ];

			}

		}

		lock attributeCollection = getCollectionLockExclusive() {

			if ( ! windows.keyExists( windowKey ) ) {

				windows[ windowKey ] = {
					key: windowKey,
					limit: feature.limit,
					duration: feature.duration,
					expiresAt: 0, // To be handled in the exclusive window lock.
					count: 0
				};

			}

			return windows[ windowKey ];

		}

	}


	/**
	* I build the attributes for an exclusive entry lock with the given timeout.
	*/
	private struct function getWindowLockExclusive(
		required string entryID,
		numeric timeoutInSeconds = 5
		) {

		return {
			name: "RateLimiter.Entry.#entryID#",
			type: "exclusive",
			timeout: timeoutInSeconds
		};

	}


	/**
	* I purge expired rate limit windows.
	*/
	private void function purgeExpiredWindows() {

		if ( getTickCount() < nextPurgeAt ) {

			return;

		}

		lock attributeCollection = getCollectionLockExclusive() {

			var timestamp = getTickCount();

			if ( timestamp < nextPurgeAt ) {

				return;

			}

			for ( var key in windows.keyArray() ) {

				if ( windows[ key ].expiresAt <= timestamp ) {

					windows.delete( key );

				}

			}

			// Note: Even though this isn't technically the best, I'm reusing the
			// timestamp that was created before the purging. The latency should be so
			// small that this is an acceptable lag.
			nextPurgeAt = ( timestamp + purgeDelayInMilliseconds );

		}

	}

}
