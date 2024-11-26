
// Import module styles.
import "./default.view.less";

// ----------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------- //

window.ys84gd = {
	AppShell
};

function AppShell() {

	var showNavText = "Show Navigation";
	var hideNavText = "Hide Navigation";

	return {
		// Properties.
		navToggleText: showNavText,

		// Methods.
		focusMain: focusMain,
		toggleNav: toggleNav
	};

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I programmatically focus the main content area.
	*/
	function focusMain() {

		this.$refs.main.focus();
		this.$refs.main.scrollIntoView();

	}


	/**
	* I toggle the rendering of the nav menu (only narrow devices only).
	*/
	function toggleNav() {

		var navToggle = this.$refs.navToggle;
		var navMenu = this.$refs.navMenu;
		var isExpanded = ( navToggle.getAttribute( "aria-expanded" ) === "true" );

		if ( isExpanded ) {

			this.navToggleText = showNavText;
			navToggle.setAttribute( "aria-expanded", "false" );
			navMenu.classList.remove( "is-expanded" );

		} else {

			this.navToggleText = hideNavText;
			navToggle.setAttribute( "aria-expanded", "true" );
			navMenu.classList.add( "is-expanded" );
			navMenu.focus();

		}

	}

}
