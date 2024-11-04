<cfscript>

	if ( ! request.context.keyExists( "flash" ) ) {

		exit;

	}

	include "./flashMessage.view.cfm";

</cfscript>
