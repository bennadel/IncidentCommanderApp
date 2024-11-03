<cfscript>

	title = "Share Timeline";
	errorMessage = "";

	request.template.activeNavItem = "share";
	request.template.title = title;

	include "./share.view.cfm";

</cfscript>
