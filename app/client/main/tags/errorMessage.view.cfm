<cfoutput>

	<p
		x-data="ho5evf.ErrorMessage"
		tabindex="-1"
		role="alert"
		aria-live="assertive"
		ho5evf
		class="error-message #attributes.class#">

		#encodeForHtml( attributes.message )#

		<!--- So that the top of the message doesn't butt-up against the viewport. --->
		<span
			aria-hidden="true"
			x-ref="scrollTarget"
			ho5evf
			class="scroll-margin">
		</span>
	</p>

</cfoutput>
