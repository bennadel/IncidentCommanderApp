<cfscript>

	param name="attributes.response" type="any" default="";
	param name="attributes.class" type="string" default="";

	// Since ColdFusion doesn't have the best notion of NULL, we're going to be defaulting
	// the error reponse to the empty string. It will only become actionalab as a Struct.
	if ( ! isStruct( attributes.response ) ) {

		exit "exitTag";

	}

	include "./errorMessage.view.cfm";

	// For CFML hierarchy purposes, allow for closing tag, but don't execute a second time.
	exit "exitTag";

</cfscript>