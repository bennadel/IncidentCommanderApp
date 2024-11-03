<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			Are you sure you want to permanently delete your incident? This action cannot be undone.
		</p>

		<p>
			Also, before you delete your incident, you might want to <a href="/index.cfm?event=incident.export&incidentToken=#encodeForUrl( request.context.incidentToken )#">export your data</a>.
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
						Description:
					</dt>
					<dd>
						#encodeForHtml( request.incident.description )#
					</dd>
				</div>
				<div>
					<dt>
						Ownership:
					</dt>
					<dd>
						#encodeForHtml( request.incident.ownership )#
					</dd>
				</div>
			</dl>

			<p class="ui-form-buttons ui-row">
				<span class="ui-row__item">
					<button type="submit" class="ui-button is-submit is-destructive">
						Delete Incident
					</button>
				</span>
				<span class="ui-row__item">
					<a
						href="/index.cfm?event=incident&incidentToken=#encodeForHtml( request.context.incidentToken )#"
						class="ui-button is-cancel">
						Cancel
					</a>
				</span>
			</p>
		</form>

	</cfoutput>
</cfsavecontent>
