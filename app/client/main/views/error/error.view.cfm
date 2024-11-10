<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

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

	</cfoutput>
</cfsavecontent>
