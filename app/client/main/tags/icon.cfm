<cfscript>

	param name="attributes.type" type="string";

	icons = {
		"alert": "svg-sprite--alert-triangle--18157",
		"delete": "svg-sprite--bin-2--18148",
		"export": "svg-sprite--download-button--18211",
		"locked": "svg-sprite--lock-1--18160",
		"logo": "svg-sprite--safety-fire-shield--18430",
		"new": "svg-sprite--move-left-1--18116",
		"settings": "svg-sprite--settings-vertical--18158",
		"share": "svg-sprite--common-file-text-share--18337",
		"status": "svg-sprite--single-neutral-actions-shield--18350",
		"unlocked": "svg-sprite--lock-unlock--18160"
	};

	href = icons[ attributes.type ];

	include "./icon.view.cfm";

	// For CFML hierarchy purposes, allow for closing tag, but don't execute a second time.
	exit "exitTag";

</cfscript>
