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
						<strong>Description:</strong>
					</dt>
					<dd>
						<input
							type="text"
							name="description"
							value="#encodeForHtmlAttribute( form.description )#"
							size="75"
							maxlength="1000"
						/>
					</dd>
				</div>
				<div>
					<dt>
						<strong>Ownership:</strong>
					</dt>
					<dd>
						<input
							type="text"
							name="ownership"
							value="#encodeForHtmlAttribute( form.ownership )#"
							size="50"
							maxlength="50"
						/>
					</dd>
				</div>
				<div>
					<dt>
						<strong>Priority:</strong>
					</dt>
					<dd>
						<select name="priorityID">
							<cfloop array="#priorities#" index="priority">
								<option
									value="#encodeForHtmlAttribute( priority.id )#"
									#ui.attrSelected( form.priorityID == priority.id )#>
									#encodeForHtml( priority.name )#
									&mdash;
									#encodeForHtml( priority.description )#
								</option>
							</cfloop>
						</select>
					</dd>
				</div>
				<div>
					<dt>
						<strong>Ticket Url:</strong>
					</dt>
					<dd>
						<input
							type="text"
							name="ticketUrl"
							value="#encodeForHtmlAttribute( form.ticketUrl )#"
							size="50"
							maxlength="300"
						/>
					</dd>
				</div>
				<div>
					<dt>
						<strong>Video Url:</strong>
					</dt>
					<dd>
						<input
							type="text"
							name="videoUrl"
							value="#encodeForHtmlAttribute( form.videoUrl )#"
							size="50"
							maxlength="300"
						/>
					</dd>
				</div>
			</dl>

			<p>
				<button type="submit">
					Update Incident
				</button>
			</p>
		</form>

	</cfoutput>
</cfsavecontent>
