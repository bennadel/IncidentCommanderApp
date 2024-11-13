
CREATE TABLE `incident` (
	`id` bigint unsigned NOT NULL AUTO_INCREMENT,
	`slug` varchar(255) NOT NULL,
	`descriptionMarkdown` text NOT NULL,
	`descriptionHtml` text NOT NULL,
	`ownership` varchar(50) NOT NULL,
	`priorityID` tinyint unsigned NOT NULL,
	`ticketUrl` varchar(300) NOT NULL,
	`videoUrl` varchar(300) NOT NULL,
	`createdAt` datetime NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `priority` (
	`id` tinyint unsigned NOT NULL,
	`name` varchar(50) NOT NULL,
	`description` varchar(255) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `priority` (
	`id`,
	`name`,
	`description`
) VALUES (
	1,
	'P1 (Critical)',
	'Severe business impact; system-wide outage or critical functionality failure. Immediate attention required.'
),
(
	2,
	'P2 (High)',
	'Major impact on business operations; significant functionality is down, affecting multiple users. Needs urgent resolution.'
),
(
	3,
	'P3 (Medium)',
	'Moderate impact; partial loss of functionality, affecting a smaller group or specific feature. Addressed in the normal workflow.'
),
(
	4,
	'P4 (Low)',
	'Minor impact; non-critical issues or inconveniences with workarounds available. Scheduled for future fixes.'
),
(
	5,
	'P5 (Very Low)',
	'Minimal impact; cosmetic issues or requests with no immediate effect on functionality. Addressed as resources allow.'
);

CREATE TABLE `screenshot` (
	`id` bigint unsigned NOT NULL AUTO_INCREMENT,
	`incidentID` bigint unsigned NOT NULL,
	`statusID` bigint unsigned NOT NULL,
	`mimeType` varchar(50) NOT NULL,
	`createdAt` datetime NOT NULL,
	PRIMARY KEY (`id`),
	KEY `byIncident` (`incidentID`),
	KEY `byStatus` (`statusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `stage` (
	`id` tinyint unsigned NOT NULL,
	`name` varchar(50) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `stage` (
	`id`,
	`name`
) VALUES (
	1,
	'Investigating'
),
(
	2,
	'Identified'
),
(
	3,
	'Monitoring'
),
(
	4,
	'Resolved'
);

CREATE TABLE `status_update` (
	`id` bigint unsigned NOT NULL AUTO_INCREMENT,
	`incidentID` bigint unsigned NOT NULL,
	`stageID` tinyint unsigned NOT NULL,
	`contentMarkdown` text NOT NULL,
	`contentHtml` text NOT NULL,
	`createdAt` datetime DEFAULT NULL,
	PRIMARY KEY (`id`),
	KEY `byIncident` (`incidentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
