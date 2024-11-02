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
			<input type="hidden" name="sort" value="#encodeForHtmlAttribute( request.context.sort )#" />

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

			<button type="submit">
				Post Update
			</button>
		</form>

		<h2>
			Previous Updates
		</h2>

		<p>
			Sort
			<a href="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#&sort=desc">newest first</a> ,
			<a href="/index.cfm?event=#encodeForUrl( request.context.event )#&incidentToken=#encodeForUrl( request.context.incidentToken )#&sort=asc">oldest first</a>
		</p>

		<dl>
			<cfloop array="#sortedStatuses#" index="status">
				<div>
					<dt>
						<p>
							<strong>#dateFormat( status.createdAt, "dddd, mmmm d" )# at
							#timeFormat( status.createdAt, "h:mmtt" )#</strong>

							&middot;
							<a href="/index.cfm?event=incident.status.edit&incidentToken=#encodeForUrl( request.context.incidentToken )#&statusID=#encodeForUrl( status.id )#">Edit</a>
							&middot;
							<a href="/index.cfm?event=incident.status.delete&incidentToken=#encodeForUrl( request.context.incidentToken )#&statusID=#encodeForUrl( status.id )#">Delete</a>

							<br />

							<strong>Stage:</strong>
							#encodeForHtml( stagesIndex[ status.stageID ].name )#
						</p>
					</dt>
					<dd>
						#status.contentHtml#
					</dd>
				</div>
			</cfloop>
		</dl>

	</cfoutput>
</cfsavecontent>
