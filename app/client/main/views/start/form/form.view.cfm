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

			<dl>
				<div>
					<dt>
						Description:
					</dt>
					<dd>
						<input
							type="text"
							name="description"
							placeholder="#encodeForHtmlAttribute( placeholder )#"
							size="75"
							maxlength="1000"
						/>
					</dd>
				</div>
				<div>
					<dt>
						Priority:
					</dt>
					<dd>
						<cfloop array="#priorities#" index="priority">
							<p>
								<label style="display: block ;">
									<span class="ui-row">
										<span class="ui-row__item">
											<input
												type="radio"
												name="priorityID"
												value="#encodeForHtmlAttribute( priority.id )#"
												#ui.attrChecked( form.priorityID == priority.id )#
												class="ui-radio"
											/>
										</span>
										<strong class="ui-row__item">
											#encodeForHtml( priority.name )#
										</strong>
									</span>
									#encodeForHtml( priority.description )#
								</label>
							</p>
						</cfloop>
					</dd>
				</div>
			</dl>

			<p class="ui-form-buttons">
				<button type="submit" class="ui-button is-submit">
					Open a New Incident
				</button>
			</p>
		</form>

	</cfoutput>
</cfsavecontent>
