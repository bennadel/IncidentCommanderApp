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
						The update message supports <a href="https://www.markdownguide.org/basic-syntax/" target="_blank">basic markdown formatting</a> such as bold (<code>**</code>), italic (<code>_</code>), bulleted lists, blockquotes (<code>&gt;</code>), and code blocks (<code>```</code>).
					</p>

					<textarea
						id="id-contentMarkdown"
						aria-describedby="id-contentMarkdown--description id-contentMarkdown--note"
						name="contentMarkdown"
						@keydown.meta.enter="$el.form.submit()"
						@keydown.ctrl.enter="$el.form.submit()"
						maxlength="65535"
						class="ui-textarea"
						>#encodeForHtml( form.contentMarkdown )#</textarea>

					<p id="id-contentMarkdown--note" class="ui-hint">
						You can use <code>CMD+Enter</code> or <code>CTRL+Enter</code> to submit from the textarea.
					</p>
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

		<article tcr65f class="slack-message">

			<h2>
				Copy-Paste Slack Message
			</h2>

			<form x-data="tcr65f.SlackMessage" @submit.prevent="copyMessage()">
				<div class="ui-field">
					<label for="id-slackContent" class="ui-field__label">
						Slack Message:
					</label>
					<div class="ui-field__content">
						<p id="id-slackContent--description">
							The following textarea contains a Slack-friendly abbreviated message with insight into the current state of the incident. It also contains a link to the shareable timeline. Dropping this message in Slack will help keep your team informed.
						</p>

						<textarea
							id="id-slackContent"
							aria-describedby="id-slackContent--description"
							readonly
							x-ref="messageContent"
							@click="$el.select()"
							@focus="$el.select()"
							class="ui-textarea"
							>#encodeForHtml( slackContent )#</textarea>
					</div>
				</div>

				<div class="ui-form-buttons ui-row">
					<span class="ui-row__item">
						<button type="submit" class="ui-button is-submit">
							Copy Slack Message
						</button>
					</span>
					<span
						tcr65f
						role="status"
						aria-live="polite"
						class="ui-row__item copy-success"
						x-text="successMessage">
						<!-- Will be rendered dynamically. -->
					</span>
				</div>
			</form>

		</article>

		<article tcr65f class="all-updates">
			<h2>
				All Status Updates
			</h2>

			<p>
				The most recent updates are listed first. If you want to share this timeline with your team, consider using the <a href="/index.cfm?event=incident.share&incidentToken=#encodeForUrl( request.context.incidentToken )#">shareable timeline</a>.
			</p>

			<cfloop array="#statuses#" index="status">
				<section tcr65f class="update">
					<h3 tcr65f class="update__header">
						#encodeForHtml( stagesIndex[ status.stageID ].name )#:
						#dateFormat( status.createdAt, "dddd, mmmm d" )# at
						#timeFormat( status.createdAt, "h:mmtt" )#
					</h3>

					<div tcr65f class="update__content u-break-word">
						#status.contentHtml#

						<div class="update-controls">
							<a href="/index.cfm?event=incident.status.edit&incidentToken=#encodeForUrl( request.context.incidentToken )#&statusID=#encodeForUrl( status.id )#">Edit</a>
							&middot;
							<a href="/index.cfm?event=incident.status.delete&incidentToken=#encodeForUrl( request.context.incidentToken )#&statusID=#encodeForUrl( status.id )#">Delete</a>
						</div>
					</div>
				</section>
			</cfloop>
		</article>

	</cfoutput>
</cfsavecontent>
