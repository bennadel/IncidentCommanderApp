<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			Are you sure you want to permanently delete your incident? This action cannot be undone.
		</p>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			message="#errorMessage#"
		/>

		<form method="post" action="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#">
			<cfmodule template="/client/main/tags/xsrf.cfm">

			<dl>
				<div>
					<dt>
						<strong>Description:</strong>
					</dt>
					<dd>
						#encodeForHtml( request.incident.description )#
					</dd>
				</div>
				<div>
					<dt>
						<strong>Ownership:</strong>
					</dt>
					<dd>
						#encodeForHtml( request.incident.ownership )#
					</dd>
				</div>
			</dl>

			<p>
				<button type="submit">
					Delete Incident
				</button>
				<a href="/index.cfm?event=incident&incidentToken=#encodeForHtml( request.context.incidentToken )#">
					Cancel
				</a>
			</p>
		</form>

	</cfoutput>
</cfsavecontent>
