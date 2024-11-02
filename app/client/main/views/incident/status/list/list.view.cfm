<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			message="#errorMessage#"
		/>

		<form method="post" action="#pageUrl#">
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
			<a href="#pageUrl#&sort=desc">newest first</a> ,
			<a href="#pageUrl#&sort=asc">oldest first</a>
		</p>

		<cfdump var="#sortedStatuses#">

	</cfoutput>
</cfsavecontent>
