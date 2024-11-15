<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
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
					#dateFormat( request.incident.createdAt, "mmmm d, yyyy" )# at
					#timeFormat( request.incident.createdAt, "h:mmtt" )# UTC
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
						<a href="#encodeForHtmlAttribute( request.incident.videoUrl )#">#encodeForHtml( request.incident.videoUrl )#</a>
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
						<a href="#encodeForHtmlAttribute( request.incident.ticketUrl )#">#encodeForHtml( request.incident.ticketUrl )#</a>
					<cfelse>
						<em>None provided.</em>
					</cfif>
				</dd>
			</div>
		</dl>

		<h2>
			Status Updates
		</h2>

		<cfloop array="#statuses#" index="status">

			<section rsyzpa class="update">
				<h3>
					#encodeForHtml( stagesIndex[ status.stageID ].name )#:
					#dateFormat( status.createdAt, "dddd, mmmm d" )# at
					#timeFormat( status.createdAt, "h:mmtt" )#
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
								<img
									src="/index.cfm?event=incident.screenshot.image&incidentToken=#encodeForUrl( request.context.incidentToken )#&screenshotID=#encodeForUrl( screenshot.id )#"
									loading="lazy"
									rsyzpa
									class="update__screenshot"
								/>
							</figure>

						</cfloop>
					</div>

				</cfif>

			</section>

		</cfloop>

	</cfoutput>
</cfsavecontent>
