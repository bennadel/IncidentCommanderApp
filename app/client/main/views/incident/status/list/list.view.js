
// Import module styles.
import "./list.view.less";

// ----------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------- //

window.tcr65f = {
	SlackMessage
};

function SlackMessage() {

	return {
		successMessage: "",
		copyMessage: copyMessage
	};

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I copy the current slack message into the user's clipboard.
	*/
	async function copyMessage() {

		try {

			await navigator.clipboard.writeText( this.$refs.messageContent.value );
			this.successMessage = "Your message has been copied!";

		} catch ( error ) {

			this.successMessage = "Sorry, clipboard access was blocked.";

		}

		setTimeout(
			() => {

				this.successMessage = "";

			},
			5000
		);

	}

}
