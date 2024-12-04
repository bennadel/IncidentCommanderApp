<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			response="#errorResponse#"
		/>

		<form method="post" action="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#&statusID=#encodeForUrl( status.id )#">
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
					Remediation Stage:
				</div>
				<div class="ui-field__content">
					<p>
						#encodeForHtml( stage.name )#
					</p>
				</div>
			</div>

			<div class="ui-field">
				<div class="ui-field__label">
					Status Update Message:
				</div>
				<div class="ui-field__content">
					#status.contentHtml#
				</div>
			</div>

			<div class="ui-form-buttons ui-row">
				<span class="ui-row__item">
					<button type="submit" class="ui-button is-submit is-destructive">
						Delete Status Update
					</button>
				</span>
				<span class="ui-row__item">
					<a
						href="/index.cfm?event=incident.status.list&incidentToken=#encodeForUrl( request.context.incidentToken )#"
						class="ui-button is-cancel">
						Cancel
					</a>
				</span>
			</div>
		</form>

	</cfoutput>
</cfsavecontent>
