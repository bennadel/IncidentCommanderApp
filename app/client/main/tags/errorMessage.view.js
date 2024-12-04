
// Import module styles.
import "./errorMessage.view.less";

// ----------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------- //

window.ho5evf = {
	ErrorMessage
};

function ErrorMessage() {

	var invalidInstanceID = 0;

	return {
		init: init,
		applyAriaInvalidAttribute: applyAriaInvalidAttribute,
		applyFieldNote: applyFieldNote,
		augmentForm: augmentForm
	};

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I initialize the component.
	*/
	function init() {

		this.$el.focus();
		this.$refs.scrollTarget.scrollIntoView({
			behavior: "smooth",
			block: "start"
		});

		this.augmentForm( this.$el.dataset.errorType );

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I apply the "aria-invalid" attribute to relevant form controls.
	*/
	function applyAriaInvalidAttribute( errorType ) {

		for ( var control of document.querySelectorAll( "[data-error-types]" ) ) {

			for ( var prefix of control.dataset.errorTypes.match( /\S+/g ) ) {

				if ( errorType.startsWith( prefix ) ) {

					control.setAttribute( "aria-invalid", "true" );
					// Move onto next control.
					break;

				}

			}

		}

	}


	/**
	* For each control that is marked as invalid via aria, I prepend the "needs attention"
	* element to the top of the field content.
	*/
	function applyFieldNote() {

		for ( var control of document.querySelectorAll( "[aria-invalid='true']" ) ) {

			var container = control.closest( ".ui-field__content" );

			if ( container ) {

				var clone = this.$refs.invalidTemplate.content.cloneNode( true )
					.firstElementChild
				;
				var cloneID = clone.id = `invalid-${ ++invalidInstanceID }`;
				var describedBy = control.getAttribute( "aria-describedby" );

				container.prepend( clone );
				control.setAttribute( "aria-describedby", `${ cloneID } ${ describedBy }` );

			}

		}

	}


	/**
	* I augment the form with information about the error (where possible).
	*/
	function augmentForm( errorType ) {

		if ( errorType ) {

			this.applyAriaInvalidAttribute( errorType );
			this.applyFieldNote();

		}

	}

}
