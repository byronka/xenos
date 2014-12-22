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
(6, 'Please enter a title', 'FrenchPlease enter a title', 'SpanishPlease enter a title'),
(7, 'Could not parse points', 'FrenchCould not parse points', 'SpanishCould not parse points'),
(8, 'No categories found in string', 'FrenchNo categories found in string', 'SpanishNo categories found in string'),
(9, 'You do not have enough points to make this request!', 'FrenchYou do not have enough points to make this request!', 'SpanishYou do not have enough points to make this request!'),
(10, 'Description', 'FrenchDescription', 'SpanishDescription'),
(11, 'Points', 'FrenchPoints', 'SpanishPoints'),
(12, 'Title', 'FrenchTitle', 'SpanishTitle'),
(13, 'Categories', 'FrenchCategories', 'SpanishCategories'),
(14, 'Create Request', 'FrenchCreate Request', 'SpanishCreate Request'),
(15, 'Create a request', 'FrenchCreate a request', 'SpanishCreate a request'),
(16, 'The dashboard', 'FrenchThe dashboard', 'SpanishThe dashboard'),
(17, 'Welcome to the dashboard!', 'FrenchWelcome to the dashboard!', 'SpanishWelcome to the dashboard!'),
(18, 'Here are your requests', 'FrenchHere are your requests', 'SpanishHere are your requests'),
(19, 'Here are other\'s requests', 'FrenchHere are other\'s requests', 'SpanishHere are other\'s requests'),
(20, 'Handle', 'FrenchHandle', 'SpanishHandle'),
(21, 'Delete', 'FrenchDelete', 'SpanishDelete'),
(22, 'Request Details', 'FrenchRequest Details', 'SpanishRequest Details'),
(23, 'Description', 'FrenchDescription', 'SpanishDescription'),
(24, 'Status', 'FrenchStatus', 'SpanishStatus'),
(25, 'Date', 'FrenchDate', 'SpanishDate'),
(26, 'Points', 'FrenchPoints', 'SpanishPoints'),
(27, 'Title', 'FrenchTitle', 'SpanishTitle'),
(28, 'Categories', 'FrenchCategories', 'SpanishCategories'),
(29, 'Yes, delete!', 'FrenchYes, delete!', 'SpanishYes, delete!'),
(30, 'Nevermind, do not delete it', 'FrenchNevermind, do not delete it', 'SpanishNevermind, do not delete it'),
(31, 'Request has been deleted', 'FrenchRequest has been deleted', 'SpanishRequest has been deleted'),
(32, 'Request', 'FrenchRequest', 'SpanishRequest'),
(33, 'deleted', 'Frenchdeleted', 'Spanishdeleted'),
(34, 'This request has been deleted, its points have been refunded to you', 'FrenchThis request has been deleted, its points have been refunded to you', 'SpanishThis request has been deleted, its points have been refunded to you'),
(35, 'Dashboard', 'FrenchDashboard', 'SpanishDashboard'),
(36, 'Send message', 'FrenchSend message', 'SpanishSend message'),
(37, 'Handle', 'FrenchHandle', 'SpanishHandle'),
(38, 'Message (up to 10,000 characters)', 'FrenchMessage (up to 10,000 characters)', 'SpanishMessage (up to 10,000 characters)'),
(39, 'Are you sure you want to delete this request?', 'FrenchAre you sure you want to delete this request?', 'SpanishAre you sure you want to delete this request?'),
(40, '"points will be refunded to you', 'French"points will be refunded to you', 'Spanish"points will be refunded to you')
-- (99999, 'BLAH', 'FrenchBLAH', 'SpanishBLAH')
