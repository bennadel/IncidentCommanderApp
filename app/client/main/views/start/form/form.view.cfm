<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			Don't panic. We'll get through this together. Start by telling us a little bit about what's going wrong with your application? You can edit this information at any time in the future.
		</p>

		<cfmodule
			template="/client/main/tags/errorMessage.cfm"
			message="#errorMessage#"
		/>

		<form method="post" action="/index.cfm">
			<cfmodule template="/client/main/tags/event.cfm">
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
							placeholder="#encodeForHtmlAttribute( placeholder )#"
							size="75"
							maxlength="1000"
						/>
					</dd>
				</div>
				<div>
					<dt>
						<strong>Priority:</strong>
					</dt>
					<dd>
						<cfloop array="#priorities#" index="priority">
							<p>
								<label style="display: block ;">
									<input
										type="radio"
										name="priorityID"
										value="#encodeForHtmlAttribute( priority.id )#"
										#ui.attrChecked( form.priorityID == priority.id )#
									/>
									<strong>#encodeForHtml( priority.name )#</strong><br />
									#encodeForHtml( priority.description )#
								</label>
							</p>
						</cfloop>
					</dd>
				</div>
			</dl>

			<button type="submit">
				Open a New Incident
			</button>
		</form>

	</cfoutput>
</cfsavecontent>
