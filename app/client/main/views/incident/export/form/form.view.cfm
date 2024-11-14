<cfsavecontent variable="request.template.primaryContent">
	<cfoutput>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			You can export your incident data as a JSON (JavaScript Object Notation) file. Screenshot images will be embedded within the JSON as Base64-encoded data URLs.
		</p>

		<form method="post" action="/index.cfm?event=incident.export.json&incidentToken=#encodeForUrl( request.context.incidentToken )#">
			<cfmodule template="/client/main/tags/xsrf.cfm">

			<div class="ui-form-buttons ui-row">
				<span class="ui-row__item">
					<button type="submit" class="ui-button is-submit">
						Export Data
					</button>
				</span>
			</div>
		</form>

	</cfoutput>
</cfsavecontent>
