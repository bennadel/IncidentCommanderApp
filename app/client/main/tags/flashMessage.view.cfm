<cfoutput>

	<div
		x-data="izm317.FlashMessage"
		tabindex="-1"
		role="alert"
		aria-live="polite"
		izm317
		class="flash-message u-no-inner-margin-y">

		<cfswitch expression="#request.context.flash#">
			<cfcase value="incident.deleted">
				<p>
					Your incident and all of its data has been deleted.
				</p>
			</cfcase>
			<cfcase value="incident.started">
				<p>
					Your new incident has been opened. You can adjust the settings at any time.
				</p>
			</cfcase>
			<cfcase value="incident.screenshot.deleted">
				<p>
					Your screenshot has been deleted.
				</p>
			</cfcase>
			<cfcase value="incident.status.created">
				<p>
					Your status update has been posted.
				</p>
			</cfcase>
			<cfcase value="incident.status.deleted">
				<p>
					Your status update has been deleted.
				</p>
			</cfcase>
			<cfcase value="incident.status.updated">
				<p>
					Your status update has been updated.
				</p>
			</cfcase>
			<cfcase value="incident.updated">
				<p>
					Your incident settings have been updated.
				</p>
			</cfcase>
			<cfdefaultcase>
				<p>
					Your form was processed successfully.
				</p>
			</cfdefaultcase>
		</cfswitch>
	</div>

</cfoutput>
