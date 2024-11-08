<cfoutput>

	<!doctype html>
	<html lang="en">
	<head>
		<cfmodule template="/client/main/tags/meta.cfm">
		<cfmodule template="/client/main/tags/title.cfm">
		<cfmodule template="/client/main/tags/favicon.cfm">
		<cfmodule template="/client/main/tags/bugsnag.cfm">

		<!--- HTML files dynamically generated by Parcel. --->
		<!--- <cfinclude template="/wwwroot/client/main/main.html" /> --->
	</head>
	<body>

		<main>

			<h1>
				#encodeForHtml( title )#
			</h1>

			<p>
				#encodeForHtml( message )#
			</p>

			<hr />

			<p>
				In the meantime, you can <a href="/index.cfm">return to the homepage</a>.
			</p>

		</main>

		<cfmodule template="/client/main/tags/localDebugging.cfm">

	</body>
	</html>

</cfoutput>
