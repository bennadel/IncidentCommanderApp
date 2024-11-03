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
						<input
							type="text"
							name="description"
							value="#encodeForHtmlAttribute( form.description )#"
							size="75"
							maxlength="1000"
							class="ui-input is-large"
						/>
					</dd>
				</div>
				<div>
					<dt>
						Ownership:
					</dt>
					<dd>
						<input
							type="text"
							name="ownership"
							value="#encodeForHtmlAttribute( form.ownership )#"
							size="50"
							maxlength="50"
							class="ui-input"
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
				<div>
					<dt>
						Ticket Url:
					</dt>
					<dd>
						<input
							type="text"
							name="ticketUrl"
							value="#encodeForHtmlAttribute( form.ticketUrl )#"
							size="50"
							maxlength="300"
							class="ui-input is-large"
						/>
					</dd>
				</div>
				<div>
					<dt>
						Video Url:
					</dt>
					<dd>
						<input
							type="text"
							name="videoUrl"
							value="#encodeForHtmlAttribute( form.videoUrl )#"
							size="50"
							maxlength="300"
							class="ui-input is-large"
						/>
					</dd>
				</div>
			</dl>

			<p class="ui-form-buttons">
				<button type="submit" class="ui-button is-submit">
					Update Incident
				</button>
			</p>
		</form>

	</cfoutput>
</cfsavecontent>
