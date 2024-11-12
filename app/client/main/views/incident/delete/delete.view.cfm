<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			Before you delete your incident, you might want to <a href="/index.cfm?event=incident.export&incidentToken=#encodeForUrl( request.context.incidentToken )#">export your data</a>. Deleting an incident is an action that cannot be undone.
		</p>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			message="#errorMessage#"
		/>

		<form method="post" action="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#">
			<cfmodule template="/client/main/tags/xsrf.cfm">

			<div class="ui-field">
				<div class="ui-field__label">
					Incident Description:
				</div>
				<div class="ui-field__content">
					#request.incident.descriptionHtml#
				</div>
			</div>

			<div class="ui-field">
				<div class="ui-field__label">
					Ownership:
				</div>
				<div class="ui-field__content">
					<p>
						<cfif request.incident.ownership.len()>
							#encodeForHtml( request.incident.ownership )#
						<cfelse>
							<em>None provided.</em>
						</cfif>
					</p>
				</div>
			</div>

			<div class="ui-form-buttons ui-row">
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
			</div>
		</form>

	</cfoutput>
</cfsavecontent>
