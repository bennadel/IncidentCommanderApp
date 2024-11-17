<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
			&rarr;
			#encodeForHtml( mostRecentStage )#
		</h1>

		<h2>
			Overview
		</h2>

		<dl>
			<div>
				<dt>
					Summary Description:
				</dt>
				<dd>
					#request.incident.descriptionHtml#
				</dd>
			</div>
			<div>
				<dt>
					Created:
				</dt>
				<dd>
					<time datetime="#request.incident.createdAt.dateTimeFormat( 'iso' )#">
						#dateFormat( request.incident.createdAt, "mmmm d, yyyy" )# at
						#timeFormat( request.incident.createdAt, "h:mmtt" )# UTC
					</time>
				</dd>
			</div>
			<div>
				<dt>
					Priority:
				</dt>
				<dd>
					<p>
						#encodeForHtml( prioritiesIndex[ request.incident.priorityID ].name )#
						&mdash;
						#encodeForHtml( prioritiesIndex[ request.incident.priorityID ].description )#
					</p>
				</dd>
			</div>
			<div>
				<dt>
					Ownership:
				</dt>
				<dd>
					<cfif request.incident.ownership.len()>
						#encodeForHtml( request.incident.ownership )#
					<cfelse>
						<em>None provided.</em>
					</cfif>
				</dd>
			</div>
			<div>
				<dt>
					Video Conference Url:
				</dt>
				<dd>
					<cfif request.incident.videoUrl.len()>
						<a href="#encodeForHtmlAttribute( request.incident.videoUrl )#" target="_blank">#encodeForHtml( request.incident.videoUrl )#</a>
					<cfelse>
						<em>None provided.</em>
					</cfif>
				</dd>
			</div>
			<div>
				<dt>
					Support Ticket Url:
				</dt>
				<dd>
					<cfif request.incident.ticketUrl.len()>
						<a href="#encodeForHtmlAttribute( request.incident.ticketUrl )#" target="_blank">#encodeForHtml( request.incident.ticketUrl )#</a>
					<cfelse>
						<em>None provided.</em>
					</cfif>
				</dd>
			</div>
		</dl>

		<h2>
			Status Updates
		</h2>

		<p>
			Sort messages:
			<a href="/index.cfm?event=incident.share&incidentToken=#encodeForUrl( request.context.incidentToken )#&sort=desc">most recent update first</a> (default) or
			<a href="/index.cfm?event=incident.share&incidentToken=#encodeForUrl( request.context.incidentToken )#&sort=asc">oldest update first</a>.
		</p>

		<cfloop array="#statusesSorted#" index="status">

			<section id="status-#status.id#" rsyzpa class="update">
				<h3>
					<a href="##status-#status.id#" aria-hidden="true"><span class="ui-screen-reader">Link to this update</span>##</a>

					#encodeForHtml( stagesIndex[ status.stageID ].name )#:
					<time datetime="#status.createdAt.dateTimeFormat( 'iso' )#">
						<cfif useRelativeDates>
							#relativeDateFormatter.fromNow( status.createdAt )#
						<cfelse>
							#dateFormat( status.createdAt, "mmm d" )#
							<span class="u-weaker">at</span>
							#timeFormat( status.createdAt, "h:mm" )##timeFormat( status.createdAt, "tt" ).lcase()#
							<span class="u-weaker">UTC</span>
						</cfif>
					</time>
				</h3>

				<div rsyzpa class="update__content u-break-word">
					#status.contentHtml#
				</div>

				<cfif screenshotsIndex.keyExists( status.id )>

					<div rsyzpa class="update__screenshots">
						<h4>
							Supporting Screenshots
						</h4>

						<cfloop array="#screenshotsIndex[ status.id ]#" index="screenshot">

							<figure>
								<a href="/index.cfm?event=incident.screenshot.image&incidentToken=#encodeForUrl( request.context.incidentToken )#&screenshotID=#encodeForUrl( screenshot.id )#&disposition=inline" target="_blank">
									<img
										src="/index.cfm?event=incident.screenshot.image&incidentToken=#encodeForUrl( request.context.incidentToken )#&screenshotID=#encodeForUrl( screenshot.id )#"
										loading="lazy"
										rsyzpa
										class="update__screenshot"
									/>
								</a>
							</figure>

						</cfloop>
					</div>

				</cfif>

			</section>

		</cfloop>

	</cfoutput>
</cfsavecontent>
