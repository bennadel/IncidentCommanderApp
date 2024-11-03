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
						Video Call:
					</dt>
					<dd>
						<cfif request.incident.videoUrl.len()>
							<a href="#encodeForHtmlAttribute( request.incident.videoUrl )#" target="_blank">#encodeForHtml( request.incident.videoUrl )#</a>
							<!-- Todo: Add copy button. -->
						<cfelse>
							<a href="/index.cfm?event=incident.settings&incidentToken=#encodeForUrl( request.context.incidentToken )#">Add url</a>
						</cfif>
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
						Post Update
					</button>
				</span>
			</p>
		</form>

		<h2>
			Previous Updates
		</h2>

		<dl>
			<cfloop array="#statuses#" index="status">
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
