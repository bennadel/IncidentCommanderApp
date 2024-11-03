<cfscript>

	title = "Export Data";
	errorMessage = "";

	request.template.activeNavItem = "export";
	request.template.title = title;

	include "./export.view.cfm";

</cfscript>
