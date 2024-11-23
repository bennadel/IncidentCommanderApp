
// Import module styles.
import "./flashMessage.view.less";

// ----------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------- //

window.izm317 = {
	FlashMessage
};

function FlashMessage() {

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

		// In order to make sure that the target page remains easily sharable; and, that
		// sharing the given URL doesn't constantly show the flash message; we're going to
		// remove the flash query-string parameter.
		var url = new URL( window.location.href );
		url.searchParams.delete( "flash" );

		window.history.replaceState( {}, "", url );

		// Focus the flash message as well.
		this.$el.focus();

		// Todo: I found the scroll-to a little strange on this one. I'm going to disable
		// it until I can come back and have a better offset (like the error message).
		// --
		// this.$el.scrollIntoView({
		// 	behavior: "smooth",
		// 	block: "start"
		// });

	}

}
