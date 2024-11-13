component
	output = false
	hint = "I help translate application errors into appropriate response codes and user-facing messages."
	{

	// Define properties for dependency-injection.
	property name="logger" ioc:type="core.lib.Logger";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I return the error response for the given error object. This is information that is
	* safe to show to the user.
	*/
	public struct function getResponse( required any error ) {

		// Some errors include metadata about why the error was thrown. These data-points
		// can be used to generate a more insightful message for the user.
		var metadata = getErrorMetadata( error );

		switch ( error.type ) {
			case "App.InternalOnly":
				return as403({
					type: error.type,
					message: "Sorry, you've attempted to use a feature that is currently in private beta. I'm hoping to start opening this up to a wider audience soon. But, I still have some kinks and rough edges to figure out."
				});
			break;
			case "App.MethodNotAllowed":
				return as405();
			break;
			case "App.Model.Incident.DescriptionHtml.Empty":
				return as422({
					type: error.type,
					message: "Your incident description markdown could not be parsed into valid HTML. Please double-check your markdown and limit it to simple formatting directives."
				});
			break;
			case "App.Model.Incident.DescriptionHtml.TooLong":
				return as422({
					type: error.type,
					message: "Your incident description markdown resulted in HTML that is too long. Please limit your description to less than 65k characters."
				});
			break;
			case "App.Model.Incident.DescriptionMarkdown.Empty":
				return as422({
					type: error.type,
					message: "Your incident description markdown is empty. Please provide a brief description so that your team has a sense of what is going wrong."
				});
			break;
			case "App.Model.Incident.DescriptionMarkdown.TooLong":
				return as422({
					type: error.type,
					message: "Your incident description markdown is too long. Please limit your description to less than 65k characters."
				});
			break;
			case "App.Model.Incident.NotFound":
				return as404({
					type: error.type,
					message: "The incident you requested cannot be found."
				});
			break;
			case "App.Model.Incident.Ownership.SuspiciousEncoding":
				return as422({
					type: error.type,
					message: "Your incident ownership contains characters with an unsupported encoding format. Please make sure that you're only using plain-text characters."
				});
			break;
			case "App.Model.Incident.Ownership.TooLong":
				return as422({
					type: error.type,
					message: "Your incident ownership is too long. Please use an ownership that is less than 50 characters."
				});
			break;
			case "App.Model.Incident.PriorityID.Invalid":
				return as422({
					type: error.type,
					message: "Your incident priority is invalid. Please make sure you select a priority from the drop-down menu."
				});
			break;
			case "App.Model.Incident.Slug.Empty":
				return as422({
					type: error.type,
					message: "Your incident slug is empty. This value is auto-generated by the system. If it's not valid, it means that something is wrong."
				});
			break;
			case "App.Model.Incident.Slug.Invalid":
				return as422({
					type: error.type,
					message: "Your incident slug is invalid. This value is auto-generated by the system. If it's not valid, it means that something is wrong."
				});
			break;
			case "App.Model.Incident.Slug.TooLong":
				return as422({
					type: error.type,
					message: "Your incident slug is too long. This value is auto-generated by the system. If it's not valid, it means that something is wrong."
				});
			break;
			case "App.Model.Incident.TicketUrl.TooLong":
				return as422({
					type: error.type,
					message: "Your incident ticket URL is too long. Please use a URL that is less than 300 characters."
				});
			break;
			case "App.Model.Incident.VideoUrl.TooLong":
				return as422({
					type: error.type,
					message: "Your incident video URL is too long. Please use a URL that is less than 300 characters."
				});
			break;
			case "App.Model.Priority.NotFound":
				return as404({
					type: error.type,
					message: "The priority you requested cannot be found."
				});
			break;
			case "App.Model.Screenshot.NotFound":
				return as404({
					type: error.type,
					message: "The screenshot you requested cannot be found."
				});
			break;
			case "App.Model.Screenshot.TooLarge":
				return as422({
					type: error.type,
					message: "Your screenshot image is larger than the 3MB filesize limit. Please export your image at a smaller resolution."
				});
			break;
			case "App.Model.Stage.NotFound":
				return as404({
					type: error.type,
					message: "The stage you requested cannot be found."
				});
			break;
			case "App.Model.Status.ContentHtml.Empty":
				return as422({
					type: error.type,
					message: "Your status markdown could not be parsed into valid HTML. Please double-check your markdown and limit it to simple formatting directives."
				});
			break;
			case "App.Model.Status.ContentHtml.TooLong":
				return as422({
					type: error.type,
					message: "Your status markdown resulted in HTML that is too long. Please limit your status update to less than 65k characters."
				});
			break;
			case "App.Model.Status.ContentMarkdown.Empty":
				return as422({
					type: error.type,
					message: "Your status markdown is empty. Please provide a brief description about your current understanding of the incident."
				});
			break;
			case "App.Model.Status.ContentMarkdown.TooLong":
				return as422({
					type: error.type,
					message: "Your status markdown is too long. Please limit your status update to less than 65k characters."
				});
			break;
			case "App.Model.Status.IncidentID.Invalid":
				return as422({
					type: error.type,
					message: "Your incident ID is invalid."
				});
			break;
			case "App.Model.Status.NotFound":
				return as404({
					type: error.type,
					message: "The status you requested cannot be found."
				});
			break;
			case "App.Model.Status.StageID.Invalid":
				return as422({
					type: error.type,
					message: "Your stage ID is invalid. Please make sure you select a stage from the drop-down menu."
				});
			break;
			case "App.NotFound":
				return as404();
			break;
			case "App.RateLimit.TooManyRequests":
				return(
					as429({
						type: error.type
					})
				);
			break;
			case "App.Routing.InvalidEvent":
			case "App.Routing.Start.InvalidEvent":
			case "App.Routing.Incident.InvalidEvent":
			case "App.Routing.Incident.Export.InvalidEvent":
			case "App.Routing.Incident.Status.InvalidEvent":
				return as404({
					type: error.type
				});
			break;
			// case "App.Turnstile.InvalidToken":
			// case "App.Turnstile.VerificationFailure":
			// 	return as400({
			// 		type: error.type,
			// 		message: "Your form has expired. Please try submitting your request again."
			// 	});
			// break;
			case "App.Unauthorized":
				return as401({
					type: error.type
				});
			break;
			case "App.Xsrf.Mismatch":
				return as403({
					type: error.type,
					message: "Your XSRF token isn't valid."
				});
			break;
			case "App.Xsrf.MissingChallenge":
				return as400({
					type: error.type,
					message: "Your request must include the XSRF challenge (X-XSRF-TOKEN)."
				});
			break;
			case "App.Xsrf.MissingCookie":
				return as400({
					type: error.type,
					message: "Your request must include the XSRF cookie (XSRF-TOKEN)."
				});
			break;
			// Anything not handled by an explicit case becomes a generic 500 response.
			default:
				// If this is a domain error, it should have been handled by an explicit
				// switch-case above. Let's log it so that we can fix the error handling
				// in a future update.
				// --
				// Note: Using toString() in order to fix an edge-case in which Adobe
				// ColdFusion throws some errors as objects.
				if ( toString( error.type ).listFirst( "." ) == "App" ) {

					logger.info( "Error not handled by case in ErrorService.", error );

				}

				return as500();
			break;
		}

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I generate a 400 response object for the given error attributes.
	*/
	private struct function as400( struct errorAttributes = {} ) {

		return getGeneric400Response().append( errorAttributes );

	}


	/**
	* I generate a 401 response object for the given error attributes.
	*/
	private struct function as401( struct errorAttributes = {} ) {

		return getGeneric401Response().append( errorAttributes );

	}


	/**
	* I generate a 403 response object for the given error attributes.
	*/
	private struct function as403( struct errorAttributes = {} ) {

		return getGeneric403Response().append( errorAttributes );

	}


	/**
	* I generate a 404 response object for the given error attributes.
	*/
	private struct function as404( struct errorAttributes = {} ) {

		return getGeneric404Response().append( errorAttributes );

	}


	/**
	* I generate a 405 response object for the given error attributes.
	*/
	private struct function as405( struct errorAttributes = {} ) {

		return getGeneric405Response().append( errorAttributes );

	}


	/**
	* I generate a 422 response object for the given error attributes.
	*/
	private struct function as422( struct errorAttributes = {} ) {

		return getGeneric422Response().append( errorAttributes );

	}


	/**
	* I generate a 429 response object for the given error attributes.
	*/
	private struct function as429( struct errorAttributes = {} ) {

		return getGeneric429Response().append( errorAttributes );

	}


	/**
	* I generate a 500 response object for the given error attributes.
	*/
	private struct function as500( struct errorAttributes = {} ) {

		return getGeneric500Response().append( errorAttributes );

	}


	/**
	* Some throw() commands OVERLOAD the "extendedInfo" property of an event to transmit
	* meta-data about why the error occurred up to the centralized error handler (ie, this
	* component). This methods attempts to deserialize the extendedInfo payload and return
	* the given structure. If the meta-data cannot be deserialized an empty struct is
	* returned.
	*/
	private struct function getErrorMetadata( required any error ) {

		try {

			if ( isJson( error.extendedInfo ) ) {

				return deserializeJson( error.extendedInfo );

			}

		} catch ( any deserializationError ) {

			// ... swallow any deserialization errors for now.

		}

		return {};

	}


	/**
	* I return the generic "400 Bad Request" response.
	*/
	private struct function getGeneric400Response() {

		return {
			statusCode: 400,
			statusText: "Bad Request",
			type: "App.BadRequest",
			title: "Bad Request",
			message: "Your request cannot be processed in its current state. Please validate the information in your request and try submitting it again."
		};

	}


	/**
	* I return the generic "401 Unauthorized" response.
	*/
	private struct function getGeneric401Response() {

		return {
			statusCode: 401,
			statusText: "Unauthorized",
			type: "App.Unauthorized",
			title: "Unauthorized",
			message: "Please login and try submitting your request again."
		};

	}


	/**
	* I return the generic "403 Forbidden" response.
	*/
	private struct function getGeneric403Response() {

		return {
			statusCode: 403,
			statusText: "Forbidden",
			type: "App.Forbidden",
			title: "Forbidden",
			message: "Your request is not permitted at this time."
		};

	}


	/**
	* I return the generic "404 Not Found" response.
	*/
	private struct function getGeneric404Response() {

		return {
			statusCode: 404,
			statusText: "Not Found",
			type: "App.NotFound",
			title: "Page Not Found",
			message: "The resource that you requested either doesn't exist or has been moved to a new location."
		};

	}


	/**
	* I return the generic "405 Method Not Allowed" response.
	*/
	private struct function getGeneric405Response() {

		return {
			statusCode: 405,
			statusText: "Method Not Allowed",
			type: "App.MethodNotAllowed",
			title: "Method Not Allowed",
			message: "Your request cannot be processed with the given HTTP method."
		};

	}


	/**
	* I return the generic "422 Unprocessable Entity" response.
	*/
	private struct function getGeneric422Response() {

		return {
			statusCode: 422,
			statusText: "Unprocessable Entity",
			type: "App.UnprocessableEntity",
			title: "Unprocessable Entity",
			message: "Your request cannot be processed in its current state. Please validate the information in your request and try submitting it again."
		};

	}


	/**
	* I return the generic "429 Too Many Requests" response.
	*/
	private struct function getGeneric429Response() {

		return {
			statusCode: 429,
			statusText: "Too Many Requests",
			type: "App.TooManyRequests",
			title: "Too Many Requests",
			message: "Your request has been rejected due to rate limiting. Please wait a few minutes and then try submitting your request again."
		};

	}


	/**
	* I return the generic "500 Server Error" response.
	*/
	private struct function getGeneric500Response() {

		return {
			statusCode: 500,
			statusText: "Server Error",
			type: "App.ServerError",
			title: "Something Went Wrong",
			message: "Sorry, something seems to have gone wrong while handling your request. I'll see if I can figure out what happened and fix it."
		};

	}

}
