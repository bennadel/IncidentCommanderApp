<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			message="#errorMessage#"
		/>

		<form
			method="post"
			action="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#"
			enctype="multipart/form-data">
			<cfmodule template="/client/main/tags/xsrf.cfm">
			<input type="hidden" name="statusID" value="#encodeForHtmlAttribute( status.id )#" />

			<div class="ui-field">
				<div class="ui-field__label">
					Incident Description:
				</div>
				<div class="ui-field__content">
					#request.incident.descriptionHtml#
				</div>
			</div>

			<div class="ui-field">
				<label for="id-stageID" class="ui-field__label">
					Remediation Stage:
				</label>
				<div class="ui-field__content">
					<select id="id-stageID" name="stageID" class="ui-select">
						<cfloop array="#stages#" index="stage">
							<option
								value="#encodeForHtmlAttribute( stage.id )#"
								#ui.attrSelected( form.stageID == stage.id )#>
								#encodeForHtml( stage.name )#
							</option>
						</cfloop>
					</select>
				</div>
			</div>

			<div class="ui-field">
				<label for="id-contentMarkdown" class="ui-field__label">
					Status Update Message:
				</label>
				<div class="ui-field__content">
					<p id="id-contentMarkdown--description">
						The update message supports <a href="https://www.markdownguide.org/basic-syntax/" target="_blank">basic markdown formatting</a> such as bold (<code>**</code>), italic (<code>_</code>), bulleted lists, blockquotes (<code>&gt;</code>), and code blocks (<code>```</code>).
					</p>

					<textarea
						id="id-contentMarkdown"
						aria-describedby="id-contentMarkdown--description id-contentMarkdown--note"
						name="contentMarkdown"
						@keydown.meta.enter="$el.form.submit()"
						@keydown.ctrl.enter="$el.form.submit()"
						maxlength="65535"
						class="ui-textarea"
						>#encodeForHtml( form.contentMarkdown )#</textarea>

					<p id="id-contentMarkdown--note" class="ui-hint">
						You can use <code>CMD+Enter</code> or <code>CTRL+Enter</code> to submit from the textarea.
					</p>
				</div>
			</div>

			<div class="ui-field">
				<label for="id-screenshotFile" class="ui-field__label">
					Add Screenshot Image:
				</label>
				<div class="ui-field__content">
					<p id="id-screenshotFile--description">
						You can upload a PNG or JPEG image to help clarify your status update. This is an additive action - it will not replace any of your existing screenshots.
					</p>

					<input
						id="id-screenshotFile"
						aria-describedby="id-screenshotFile--description"
						type="file"
						name="screenshotFile"
						value="#encodeForHtmlAttribute( form.screenshotFile )#"
						accept=".png,.jpg,.jpeg"
					/>
				</div>
			</div>

			<div class="ui-form-buttons ui-row">
				<span class="ui-row__item">
					<button type="submit" class="ui-button is-submit">
						Save Status Update
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
