
-- I'm encrypting the password and including a IV salt as well. I need to increase the
-- size of the field.
ALTER TABLE
	`incident`
MODIFY COLUMN
	`password` VARCHAR(255) NOT NULL
;
