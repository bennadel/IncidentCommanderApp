<cfscript>

	clock = request.ioc.get( "core.lib.util.Clock" );
	incidentService = request.ioc.get( "core.lib.model.IncidentService" );
	statusService = request.ioc.get( "core.lib.model.StatusService" );
	priorityService = request.ioc.get( "core.lib.model.PriorityService" );
	stageService = request.ioc.get( "core.lib.model.StageService" );

	transaction {

		incidentID = incidentService.createIncident(
			slug = "lakjflasjdflajsdflajklsdf",
			description = "This is a great incident",
			ownership = "Rainbow",
			priorityID = priorityService.getPriorityByFilter().first().id,
			stageID = stageService.getStageByFilter().first().id,
			ticketUrl = "ZENDESK-1234",
			videoUrl = "https://google.hangouts",
			createdAt = clock.utcNow()
		);
		statusID = statusService.createStatus(
			incidentID = incidentID,
			stageID = stageService.getStageByFilter().first().id,
			contentMarkdown = "Cool beans!",
			contentHtml = "Cool beans!",
			createdAt = clock.utcNow()
		);

	}

	writeDump( incidentID );
	writeDump( statusID );

</cfscript>

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
