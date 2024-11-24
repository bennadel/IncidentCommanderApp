<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			The incident you are trying to access has been password-protected. In order to access this incident, you must enter the password below. If you do not know the password, please contact the incident commander.
		</p>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			message="#errorMessage#"
		/>

		<form method="post" action="/index.cfm?event=auth&incidentToken=#encodeForUrl( request.context.incidentToken )#">
			<cfmodule template="/client/main/tags/xsrf.cfm">

			<div class="ui-field">
				<label for="id-password" class="ui-field__label">
					Password:
				</label>
				<div class="ui-field__content">
					<input
						id="id-password"
						name="password"
						value="#encodeForHtmlAttribute( form.password )#"
						maxlength="30"
						class="ui-input"
					/>
				</div>
			</div>

			<div class="ui-form-buttons">
				<button type="submit" class="ui-button is-submit">
					Submit Password
				</button>
			</div>
		</form>

	</cfoutput>
</cfsavecontent>
