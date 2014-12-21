-- clear the table before we start.
truncate localization_lookup;

---DELIMITER---

-- insert into the lookup table for words and 
-- phrases to their localized counterparts, e.g. French, English, etc.
INSERT INTO localization_lookup (local_id, English, French, Spanish)
VALUES
(1, 'Search', 'FrenchSearch', 'SpanishSearch'),
(2, 'Create Request', 'FrenchCreate Request', 'SpanishCreate Request'),
(3, 'Logout', 'FrenchLogout', 'SpanishLogout'),
(4, 'Points', 'FrenchPoints', 'SpanishPoints'),
(5, 'Please enter a description', 'FrenchPlease enter a description', 'SpanishPlease enter a description'),
(6, 'Please enter a title', 'FrenchPlease enter a title', 'SpanishPlease enter a title')

