<cfoutput>

	<!doctype html>
	<html lang="en">
	<head>
		<cfmodule template="/client/main/tags/meta.cfm">
		<cfmodule template="/client/main/tags/title.cfm">
		<cfmodule template="/client/main/tags/favicon.cfm">
		<cfmodule template="/client/main/tags/bugsnag.cfm">

		<!---
			Note: Since these Open Graph meta tags aren't page specific, I'm only
			including them in the start layout only.
		--->
		<cfmodule template="./openGraph.cfm">

		<!--- HTML files dynamically generated by Parcel. --->
		<cfinclude template="/wwwroot/client/main/main.html" />
	</head>
	<body>

		<cfmodule template="/client/main/tags/flashMessage.cfm">

		<main>
			#request.template.primaryContent#
		</main>

		<cfmodule template="/client/main/tags/localDebugging.cfm">

	</body>
	</html>

</cfoutput>
