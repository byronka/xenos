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
(18, 'Your requests', 'FrenchYour requests', 'SpanishYour requests'),
(19, 'Other\'s requests', 'FrenchOther\'s requests', 'SpanishOther\'s requests'),
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
(40, 'points will be refunded to you', 'Frenchpoints will be refunded to you', 'Spanishpoints will be refunded to you'),
(41, 'Error deleting request', 'FrenchError deleting request', 'SpanishError deleting request'),
(42, 'Login', 'FrenchLogin', 'SpanishLogin'),
(43, 'Register', 'FrenchRegister', 'SpanishRegister'),
(44, 'Welcome to Qarma!', 'FrenchWelcome to Qarma!', 'SpanishWelcome to Qarma!'),
(45, 'Successfully logged out', 'FrenchSuccessfully logged out', 'SpanishSuccessfully logged out'),
(46, 'General Error', 'FrenchGeneral Error', 'SpanishGeneral Error'),
(47, 'Please enter a password', 'FrenchPlease enter a password', 'SpanishPlease enter a password'),
(48, 'Please enter a username', 'FrenchPlease enter a username', 'SpanishPlease enter a username'),
(49, 'Invalid username / password combination', 'FrenchInvalid username / password combination', 'SpanishInvalid username / password combination'),
(50, 'Login page', 'FrenchLogin page', 'SpanishLogin page'),
(51, 'Username', 'FrenchUsername', 'SpanishUsername'),
(52, 'Password', 'FrenchPassword', 'SpanishPassword'),
(53, 'Please enter a first name', 'FrenchPlease enter a first name', 'SpanishPlease enter a first name'),
(54, 'Please enter a last name', 'FrenchPlease enter a last name', 'SpanishPlease enter a last name'),
(55, 'Please enter a username', 'FrenchPlease enter a username', 'SpaishPlease enter a username'),
(56, 'Please enter a password', 'FrenchPlease enter a password', 'SpanishPlease enter a password'),
(57, 'That user already exists', 'FrenchThat user already exists', 'SpanishThat user already exists'),
(58, 'Account Creation', 'FrenchAccount Creation', 'SpanishAccount Creation'),
(59, 'Create a new account', 'FrenchCreate a new account', 'SpanishCreate a new account'),
(60, 'First Name', 'FrenchFirst Name', 'SpanishFirst Name'),
(61, 'Last Name', 'FrenchLast Name', 'SpanishLast Name'),
(62, 'Email', 'FrenchEmail', 'SpanishEmail'),
(63, 'Password', 'FrenchPassword', 'SpanishPassword'),
(64, 'Create my new user!', 'FrenchCreate my new user!', 'SpanishCreate my new user!'),
(65, 'Logged out', 'FrenchLogged out', 'SpanishLogged out'),
(66, 'You have successfully logged out', 'FrenchYou have successfully logged out', 'SpanishYou have successfully logged out'),
(67, 'Security problem', 'FrenchSecurity problem', 'SpanishSecurity problem'),
(68, 'Your browser did not send us the proper credentials.', 'FrenchYour browser did not send us the proper credentials.', 'SpanishYour browser did not send us the proper credentials.'),
(69, 'Thanks for registering!', 'FrenchThanks for registering!', 'SpanishThanks for registering!'),
(70, 'You are awesome! thanks so much for entering your name!', 'FrenchYou are awesome! thanks so much for entering your name!', 'SpanishYou are awesome! thanks so much for entering your name!'),
(71, 'math', 'Frenchmath', 'Spanishmath'),
(72, 'physics', 'Frenchphysics', 'Spanishphysics'),
(73, 'economics', 'Frencheconomics', 'Spanisheconomics'),
(74, 'history', 'Frenchhistory', 'Spanishhistory'),
(75, 'English', 'FrenchEnglish', 'SpanishEnglish'),
(76, 'open', 'Frenchopen', 'Spanishopen'),
(77, 'closed', 'Frenchclosed', 'Spanishclosed'),
(78, 'taken', 'Frenchtaken', 'Spanishtaken'),
(79, 'Rank', 'FrenchRank', 'SpanishRank'),
(80, 'User', 'FrenchUser', 'SpanishUser'),
(81, 'Advanced search', 'FrenchAdvanced search', 'SpanishAdvanced search'),
(82, 'No statuses found in string', 'FrenchNo statuses found in string', 'SpanishNo statuses found in string'),
(83, 'Invalid date', 'FrenchInvalid date', 'SpanishInvalid date'),
(84, 'EMPTY-NOTUSED', 'EMPTY-NOTUSED', 'EMPTY-NOTUSED'),
(85, 'No users found in string', 'FrenchNo users found in string', 'SpanishNo users found in string')
-- (99999, '', 'French', 'Spanish')
