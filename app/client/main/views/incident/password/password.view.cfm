<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			The URL-based token already provides a sufficient amount (64 random bytes) of security. But, for teams that are extremely security-conscious, the password provides an optional, non-URL-based security mechanism.
		</p>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			response="#errorResponse#"
		/>

		<form method="post" action="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#">
			<cfmodule template="/client/main/tags/xsrf.cfm">

			<div class="ui-field">
				<label for="id-password" class="ui-field__label">
					Password:
				</label>
				<div class="ui-field__content">
					<p id="id-password--description">
						The password can be up to 32 characters long. Please note that leading and trailing spaces are automatically removed.
					</p>

					<input
						id="id-password"
						aria-describedby="id-password--description"
						type="text"
						name="password"
						value="#encodeForHtmlAttribute( form.password )#"
						size="50"
						maxlength="32"
						class="ui-input"
					/>
				</div>
			</div>

			<div class="ui-form-buttons ui-row">
				<span class="ui-row__item">
					<button type="submit" class="ui-button is-submit">
						Apply Password
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
