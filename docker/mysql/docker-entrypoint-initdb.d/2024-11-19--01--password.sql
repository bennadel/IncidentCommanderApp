
ALTER TABLE
	`incident`
ADD COLUMN
	`password` VARCHAR(60) NOT NULL DEFAULT '' AFTER `videoUrl`
;

-- Then added code, and now I can drop the default.

ALTER TABLE
	`incident`
ALTER COLUMN
	`password` DROP DEFAULT
;