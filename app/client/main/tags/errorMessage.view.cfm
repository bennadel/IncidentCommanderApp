<cfoutput>

	<p
		x-data="ho5evf.ErrorMessage"
		data-error-type="#encodeForHtmlAttribute( attributes.response.type )#"
		tabindex="-1"
		role="alert"
		aria-live="assertive"
		ho5evf
		class="error-message #attributes.class#">

		#encodeForHtml( attributes.response.message )#

		<!--- So that the top of the message doesn't butt-up against the viewport. --->
		<span
			aria-hidden="true"
			x-ref="scrollTarget"
			ho5evf
			class="scroll-margin">
		</span>

		<!---
			This template is used as the field decorator to be inserted at the top of
			each invalid form field.
		--->
		<template x-ref="invalidTemplate">
			<p class="ui-field__needs-attention">
				<cfmodule
					template="/client/main/tags/icon.cfm"
					type="alert"
				/>
				This field needs your attention.
			</p>
		</template>
	</p>

</cfoutput>
