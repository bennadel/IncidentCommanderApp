
// Import module styles.
import "./list.view.less";

// ----------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------- //

window.tcr65f = {
	ContentMarkdown,
	SlackMessage
};

function ContentMarkdown() {

	return {
		handleFocusRequest: handleFocusRequest
	};

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I handle the global focus request for the status update.
	*/
	function handleFocusRequest( event ) {

		if (
			// If the event has already been intercepted by another keyboard shortcut,
			// ignore it.
			event.defaultPrevented ||
			// If the event is modified in any way, ignore it.
			event.altKey ||
			event.ctrlKey ||
			event.metaKey ||
			event.shiftKey ||
			// If the event is coming from a form control, ignore it.
			event.target.matches( "input, select, textarea, button" )
			) {

			return;
		}

		event.preventDefault();
		this.$el.focus();

	}

}

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
