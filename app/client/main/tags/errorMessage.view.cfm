<cfoutput>

	<p
		tabindex="-1"
		role="alert"
		aria-live="assertive"
		class="error-message #attributes.class#">

		#encodeForHtml( attributes.message )#
	</p>

</cfoutput>
