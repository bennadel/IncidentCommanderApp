<cfoutput>

	<!doctype html>
	<html lang="en">
	<head>
		<cfmodule template="/client/main/tags/meta.cfm">
		<cfmodule template="/client/main/tags/title.cfm">
		<cfmodule template="/client/main/tags/favicon.cfm">
		<cfmodule template="/client/main/tags/bugsnag.cfm">

		<!--- HTML files dynamically generated by Parcel. --->
		<cfinclude template="/wwwroot/client/main/main.html" />
	</head>
	<body>

		<div ks9bad class="wrapper">

			<cfmodule template="/client/main/tags/flashMessage.cfm">

			<main>
				#request.template.primaryContent#
			</main>

		</div>

		<cfmodule template="/client/main/tags/localDebugging.cfm">

	</body>
	</html>

</cfoutput>
