
ALTER TABLE
	`incident`
ADD COLUMN
	`password` VARCHAR(60) NOT NULL DEFAULT '' AFTER `videoUrl`
;