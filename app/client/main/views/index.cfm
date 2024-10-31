<cfquery name="test" result="metaResults">
	SELECT
		@@Version AS version
	;
</cfquery>

<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>
		Incident Commander
	</title>
</head>
<body>

	<h1>
		Incident Commander (Main)
	</h1>

	<p>
		Hello world.
	</p>

	<cfdump var="#test#" />

</body>
</html>
