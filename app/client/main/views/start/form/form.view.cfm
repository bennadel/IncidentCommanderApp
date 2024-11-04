<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			Don't panic. We'll get through this together. Start by telling us a little bit about what's going wrong with your application? You can edit this information at any time in the future.
		</p>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			message="#errorMessage#"
		/>

		<form method="post" action="/index.cfm">
			<cfmodule template="/client/main/tags/event.cfm">
			<cfmodule template="/client/main/tags/xsrf.cfm">

			<div class="ui-field">
				<label for="id-description" class="ui-field__label">
					Summary Description:
				</label>
				<div class="ui-field__content">
					<input
						id="id-description"
						type="text"
						name="description"
						value="#encodeForHtmlAttribute( form.description )#"
						size="75"
						maxlength="1000"
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

			<div class="ui-form-buttons">
				<button type="submit" class="ui-button is-submit">
					Open a New Incident
				</button>
			</div>
		</form>

	</cfoutput>
</cfsavecontent>
