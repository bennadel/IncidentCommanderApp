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
						<strong>Incident:</strong>
					</dt>
					<dd>
						#encodeForHtml( request.incident.description )#
					</dd>
				</div>
				<div>
					<dt>
						<strong>Stage:</strong>
					</dt>
					<dd>
						<select name="stageID">
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
						<strong>Status:</strong>
					</dt>
					<dd>
						<textarea
							name="contentMarkdown"
							cols="50"
							rows="5"
							maxlength="65535"
							>#encodeForHtml( form.contentMarkdown )#</textarea>
					</dd>
				</div>
			</dl>

			<p>
				<button type="submit">
					Update Status
				</button>
				<a href="/index.cfm?event=incident.status.list&incidentToken=#encodeForUrl( request.context.incidentToken )#">
					Cancel
				</a>
			</p>
		</form>

	</cfoutput>
</cfsavecontent>
