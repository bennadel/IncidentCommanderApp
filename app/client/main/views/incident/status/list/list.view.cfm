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

			<div class="ui-field">
				<div class="ui-field__label">
					Incident Description:
				</div>
				<div class="ui-field__content">
					<p>
						#encodeForHtml( request.incident.description )#
					</p>
				</div>
			</div>

			<div class="ui-field">
				<div class="ui-field__label">
					Video Conference Url:
				</div>
				<div class="ui-field__content">
					<p>
						<cfif request.incident.videoUrl.len()>
							<a href="#encodeForHtmlAttribute( request.incident.videoUrl )#" target="_blank">#encodeForHtml( request.incident.videoUrl )#</a>
							<!-- Todo: Add copy button. -->
						<cfelse>
							<a href="/index.cfm?event=incident.settings&incidentToken=#encodeForUrl( request.context.incidentToken )#">Add url</a>
						</cfif>
					</p>
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
						The update content supports <a href="https://www.markdownguide.org/basic-syntax/" target="_blank">basic markdown formatting</a> such as bold (<code>**</code>), italic (<code>_</code>), bulleted lists, blockquotes (<code>&gt;</code>), and code blocks (<code>```</code>).
					</p>

					<textarea
						id="id-contentMarkdown"
						aria-describedby="id-contentMarkdown--description"
						name="contentMarkdown"
						maxlength="65535"
						class="ui-textarea"
						>#encodeForHtml( form.contentMarkdown )#</textarea>
				</div>
			</div>

			<div class="ui-form-buttons ui-row">
				<span class="ui-row__item">
					<button type="submit" class="ui-button is-submit">
						Post Update
					</button>
				</span>
			</div>
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
