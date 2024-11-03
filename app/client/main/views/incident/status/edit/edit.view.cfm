<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			message="#errorMessage#"
		/>

		<form method="post" action="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#">
			<cfmodule template="/client/main/tags/xsrf.cfm">
			<input type="hidden" name="statusID" value="#encodeForHtmlAttribute( status.id )#" />

			<dl>
				<div>
					<dt>
						Incident:
					</dt>
					<dd>
						#encodeForHtml( request.incident.description )#
					</dd>
				</div>
				<div>
					<dt>
						Stage:
					</dt>
					<dd>
						<select name="stageID" class="ui-select">
							<cfloop array="#stages#" index="stage">
								<option
									value="#encodeForHtmlAttribute( stage.id )#"
									#ui.attrSelected( form.stageID == stage.id )#>
									#encodeForHtml( stage.name )#
								</option>
							</cfloop>
						</select>
					</dd>
				</div>
				<div>
					<dt>
						Status:
					</dt>
					<dd>
						<textarea
							name="contentMarkdown"
							maxlength="65535"
							class="ui-textarea"
							>#encodeForHtml( form.contentMarkdown )#</textarea>
					</dd>
				</div>
			</dl>

			<p class="ui-form-buttons ui-row">
				<span class="ui-row__item">
					<button type="submit" class="ui-button is-submit">
						Update Status
					</button>
				</span>
				<span class="ui-row__item">
					<a
						href="/index.cfm?event=incident.status.list&incidentToken=#encodeForUrl( request.context.incidentToken )#"
						class="ui-button is-cancel">
						Cancel
					</a>
				</span>
			</p>
		</form>

	</cfoutput>
</cfsavecontent>
