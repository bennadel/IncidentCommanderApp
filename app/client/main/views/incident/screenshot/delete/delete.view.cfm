<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			response="#errorResponse#"
		/>

		<form method="post" action="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#&screenshotID=#encodeForUrl( screenshot.id )#">
			<cfmodule template="/client/main/tags/xsrf.cfm">

			<div class="ui-field">
				<div class="ui-field__label">
					Status Message (for reference):
				</div>
				<div class="ui-field__content">
					#status.contentHtml#
				</div>
			</div>

			<div class="ui-field">
				<div class="ui-field__label">
					Screeshot Image:
				</div>
				<div class="ui-field__content">

					<img
						src="/index.cfm?event=incident.screenshot.image&incidentToken=#encodeForUrl( request.context.incidentToken )#&screenshotID=#encodeForUrl( screenshot.id )#"
						alt="Screenshot"
						loading="lazy"
					/>

				</div>
			</div>

			<div class="ui-form-buttons ui-row">
				<span class="ui-row__item">
					<button type="submit" class="ui-button is-submit is-destructive">
						Delete Screenshot
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
