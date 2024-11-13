component
	output = false
	hint = "I provide secure access to application entities."
	{

	// Define properties for dependency-injection.
	property name="incidentService" ioc:type="core.lib.model.IncidentService";
	property name="incidentValidation" ioc:type="core.lib.model.IncidentValidation";
	property name="screenshotService" ioc:type="core.lib.model.ScreenshotService";
	property name="screenshotValidation" ioc:type="core.lib.model.ScreenshotValidation";
	property name="statusService" ioc:type="core.lib.model.StatusService";
	property name="statusValidation" ioc:type="core.lib.model.StatusValidation";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I get the incident with the given id:slug token.
	*/
	public struct function getIncident( required string incidentToken ) {

		var incidentID = val( incidentToken.listFirst( "-" ) );
		var incidentSlug = incidentToken.listRest( "-" );
		var incident = incidentService.getIncident( incidentID );

		// Since we don't have an authentication system for users (anyone can jump in and
		// open an incident), we are using the case-sensitive slug to ensure that someone
		// isn't trying to randomly guess values.
		if ( compare( incident.slug, incidentSlug ) ) {

			incidentValidation.throwIncidentNotFoundError();

		}

		return incident;

	}


	/**
	* I get the screenshot with the given ID and assert ownership under given incident.
	*/
	public struct function getScreenshot(
		required struct incident,
		required numeric screenshotID
		) {

		var screenshot = screenshotService.getScreenshot( screenshotID );

		// Ensure association under the given incident.
		if ( screenshot.incidentID != incident.id ) {

			screenshotValidation.throwScreenshotNotFoundError();

		}

		return screenshot;

	}


	/**
	* I get the status with the given ID and assert ownership under given incident.
	*/
	public struct function getStatus(
		required struct incident,
		required numeric statusID
		) {

		var status = statusService.getStatus( statusID );

		// Ensure association under the given incident.
		if ( status.incidentID != incident.id ) {

			statusValidation.throwStatusNotFoundError();

		}

		return status;

	}

}
