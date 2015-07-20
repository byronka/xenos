-- Here we set the version of the database.  
-- This needs to get incremented each release.

CALL set_version(2);

-- incrementing the version will cause the "build-schema" ant target
-- to skip this script.  That's because it will check for the current
-- version in the database, and only run the appropriate scripts for
-- the particular version.  See com.renomad.xenos.schema.Build_db_schema,
-- in the main() function.

---DELIMITER---

ALTER TABLE temporary_message ADD COLUMN ( 
  has_displayed_in_website BOOL DEFAULT 0, -- if it's been displayed in corner
  has_emailed BOOL DEFAULT 0 -- if it's been emailed to user
)

---DELIMITER---

INSERT INTO audit_actions (action_id,action)
VALUES

-- user registration, login, security - 100s
(112,'User edited their email');
