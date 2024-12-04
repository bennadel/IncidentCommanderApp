<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			You can add more detail to the incident metadata below. Or, you can <a href="/index.cfm?event=incident.status.list&incidentToken=#encodeForUrl( request.context.incidentToken )#"><mark>start the investigation</mark></a> &rarr;
		</p>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			response="#errorResponse#"
		/>

		<form method="post" action="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#">
			<cfmodule template="/client/main/tags/xsrf.cfm">

			<div class="ui-field">
				<label for="id-descriptionMarkdown" class="ui-field__label">
					Summary Description:
					<span aria-hidden="true" class="ui-field__star">(required)</span>
				</label>
				<div class="ui-field__content">
					<p id="id-descriptionMarkdown--description">
						The description supports <a href="https://www.markdownguide.org/basic-syntax/" target="_blank">basic markdown formatting</a> such as bold (<code>**</code>), italic (<code>_</code>), bulleted lists, blockquotes (<code>&gt;</code>), and code blocks (<code>```</code>).
					</p>

					<textarea
						id="id-descriptionMarkdown"
						aria-describedby="id-descriptionMarkdown--description"
						aria-required="true"
						name="descriptionMarkdown"
						data-error-types="App.Model.Incident.DescriptionMarkdown."
						@keydown.meta.enter="$el.form.submit()"
						@keydown.ctrl.enter="$el.form.submit()"
						maxlength="65535"
						class="ui-textarea"
						>#encodeForHtml( form.descriptionMarkdown )#</textarea>
				</div>
			</div>

			<div class="ui-field">
				<label for="id-videoUrl" class="ui-field__label">
					Video Conference Url:
				</label>
				<div class="ui-field__content">
					<p id="id-videoUrl--description">
						This is the triage call (Zoom, Hangouts, Teams, etc.) that is held open during the incident investigation. Team members can join this call to get a real-time sense of what is happening.
					</p>

					<input
						id="id-videoUrl"
						aria-describedby="id-videoUrl--description"
						type="text"
						name="videoUrl"
						value="#encodeForHtmlAttribute( form.videoUrl )#"
						size="50"
						maxlength="300"
						class="ui-input"
					/>
				</div>
			</div>

			<div class="ui-field">
				<label for="id-ticketUrl" class="ui-field__label">
					Support Ticket Url:
				</label>
				<div class="ui-field__content">
					<p>
						This is the internal Support ticket that was used to open the incident.
					</p>

					<input
						id="id-ticketUrl"
						type="text"
						name="ticketUrl"
						value="#encodeForHtmlAttribute( form.ticketUrl )#"
						size="50"
						maxlength="300"
						class="ui-input"
					/>
				</div>
			</div>

			<div class="ui-field">
				<label for="id-ownership" class="ui-field__label">
					Ownership:
				</label>
				<div class="ui-field__content">
					<p id="id-ownership--description">
						This is the team responsible for writing the root cause analysis (RCA) after the immediate incident has been remediated.
					</p>

					<input
						id="id-ownership"
						aria-describedby="id-ownership--description"
						type="text"
						name="ownership"
						value="#encodeForHtmlAttribute( form.ownership )#"
						size="50"
						maxlength="50"
						class="ui-input"
					/>
				</div>
			</div>

			<div class="ui-field">
				<div class="ui-field__label">
					Priority:
				</div>
				<div class="ui-field__content">

					<fieldset class="ui-fieldset">
						<legend class="ui-legend">
							This is the scope and severity of the impact:
						</legend>

						<cfloop array="#priorities#" index="priority">

							<cfset baseID = "id-priority-#encodeForHtmlAttribute( priority.id )#" />

							<label for="#baseID#" class="ui-option-card">
								<input
									id="#baseID#"
									aria-labelledby="#baseID#--label"
									aria-describedby="#baseID#--description"
									type="radio"
									name="priorityID"
									value="#encodeForHtmlAttribute( priority.id )#"
									#ui.attrChecked( form.priorityID == priority.id )#
									class="ui-radio ui-option-card__control"
								/>
							
								<p id="#baseID#--label" class="ui-option-card__label">
									#encodeForHtml( priority.name )#
								</p>

								<p id="#baseID#--description" class="ui-option-card__description">
									#encodeForHtml( priority.description )#
								</p>
							</label>

						</cfloop>
					</fieldset>

				</div>
			</div>

			<div class="ui-form-buttons ui-row">
				<span class="ui-row__item">
					<button type="submit" class="ui-button is-submit">
						Update Incident
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
