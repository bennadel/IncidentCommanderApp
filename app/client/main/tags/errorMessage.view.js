
// Import module styles.
import "./errorMessage.view.less";

// ----------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------- //

window.ho5evf = {
	ErrorMessage
};

function ErrorMessage() {

	return {
		init: init
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

	}

}
