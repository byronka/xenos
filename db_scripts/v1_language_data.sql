-- clear the table before we start.
truncate localization_lookup;

---DELIMITER---

-- insert into the lookup table for words and 
-- phrases to their localized counterparts, e.g. French, English, etc.
INSERT INTO localization_lookup(local_id, language, text)
VALUES
(1,   1,  'Search'),
(2,   1,  'Create Requestoffer'),
(3,   1,  'Logout'),
(4,   1,  'Points'),
(5,   1,  'Please enter a description'),
(6,   1,  'Publish'),
(7,   1,  'Could not parse points'),
(8,   1,  'No categories found in string'),
(9,   1,  'is owed %d favors'),
(10,  1,  'Description'),
(11,  1,  'Points'),
(12,  1,  'owes, and is owed, nothing.'),
(13,  1,  'Categories'),
(14,  1,  'Create Requestoffer'),
(15,  1,  'Create a requestoffer'),
(16,  1,  'The dashboard'),
(17,  1,  'Welcome to the dashboard!'),
(18,  1,  'Your requestoffers'),
(19,  1,  'Other\'s requestoffers'),
(20,  1,  'Handle'),
(21,  1,  'Delete'),
(22,  1,  'Requestoffer Details'),
(23,  1,  'Description'),
(24,  1,  'Status'),
(25,  1,  'Date'),
(26,  1,  'Points'),
(27,  1,  'owes people %d favors'),
(28,  1,  'Categories'),
(29,  1,  'Yes, delete!'),
(30,  1,  'Nevermind, do not delete it'),
(31,  1,  'Requestoffer has been deleted'),
(32,  1,  'Requestoffer'),
(33,  1,  'deleted'),
(34,  1,  'This requestoffer has been deleted, its points have been refunded to you'),
(35,  1,  'Dashboard'),
(36,  1,  'Send message'),
(37,  1,  'Handle'),
(38,  1,  'Message(up to %d characters)'),
(39,  1,  'Are you sure you want to delete this requestoffer?'),
(40,  1,  'points will be refunded to you'),
(41,  1,  'Error deleting requestoffer'),
(42,  1,  'Login'),
(43,  1,  'Register'),
(44,  1,  'Welcome to Xenos!'),
(45,  1,  'Successfully logged out'),
(46,  1,  'General Error'),
(47,  1,  'Please enter a password'),
(48,  1,  'Please enter a username'),
(49,  1,  'Invalid username / password combination'),
(50,  1,  'Login page'),
(51,  1,  'Username'),
(52,  1,  'Password'),
(53,  1,  'Please enter a first name'),
(54,  1,  'Please enter a last name'),
(55,  1,  'EMPTY_NOT_USED_TRY_47'),
(56,  1,  'EMPTY_NOT_USED_TRY_48'),
(57,  1,  'That user already exists'),
(58,  1,  'Account Creation'),
(59,  1,  'Create a new account'),
(60,  1,  'First Name'),
(61,  1,  'Last Name'),
(62,  1,  'Email'),
(63,  1,  'Password'),
(64,  1,  'Create my new user!'),
(65,  1,  'Logged out'),
(66,  1,  'You have successfully logged out'),
(67,  1,  'Security problem'),
(68,  1,  'Your browser did not send us the proper credentials.'),
(69,  1,  'Thanks for registering!'),
(70,  1,  'You are awesome! thanks so much for entering your name!'),
(71,  1,  'math'),
(72,  1,  'physics'),
(73,  1,  'economics'),
(74,  1,  'history'),
(75,  1,  'English'),
(76,  1,  'open'),
(77,  1,  'closed'),
(78,  1,  'taken'),
(79,  1,  'Rank'),
(80,  1,  'User'),
(81,  1,  'Advanced search'),
(82,  1,  'No statuses found in string'),
(83,  1,  'Invalid date'),
(84,  1,  'EMPTY-NOTUSED'),
(85,  1,  'No users found in string'),
(86,  1,  'Start date'),
(87,  1,  'End date'),
(88,  1,  'Minimum points'),
(89,  1,  'Maximum points'),
(90,  1,  'Enter words to search in a description'),
(91,  1,  'Enter one or more usernames separated by spaces'),
(92,  1,  'Enter one or more categories separated by spaces'),
(93,  1,  'Page'),
(94,  1,  'Handle Requestoffer'),
(95,  1,  'Confirm'),
(96,  1,  'My messages'),
(97,  1,  'My profile'),
(98,  1,  'Transaction is complete'),
(99,  1,  'Requestoffer has been closed'),
(100, 1,  'Owning user'),
(101, 1,  'Handling user'),
(102, 1,  'Requestoffers I am handling'),
(103, 1,  'None'),
(104, 1,  'Offer received'),
(105, 1,  'We got your offer and will show it to that user shortly.  You can track this on your profile page.'),
(106, 1,  'new'),
(107, 1,  'accepted'),
(108, 1,  'rejected'),
(109, 1,  'draft'),
(110, 1,  'Favor published'),
(111, 1,  'Other users can now view your favor and may offer to handle it.'),
(112, 1,  'Password changed'),
(113, 1,  'Change password'),
(114, 1,  'You entered no old password or new password.  Try again.'),
(115, 1,  'You provided a new password, but you need to give us your old password too.'),
(116, 1,  'You forgot to give us your new password.  Try again.'),
(117, 1,  'Your new password is too short.  Try again.'),
(118, 1,  'What you gave for your old password is not valid. Try again.'),
(1,   2,  'Recherche'),
(2,   2,  'Créer demande'),
(3,   2,  'Déconnexion'),
(4,   2,  'Points'),
(5,   2,  'Se il vous plaît entrer une description'),
(6,   2,  'FRENCHPublish'),
(7,   2,  'Impossible d\'analyser les points'),
(8,   2,  'Aucune catégorie trouvés dans la chaîne'),
(9,   2,  'FRENCHis owed %d favors'),
(10,  2,  'FRENCHDescription'),
(11,  2,  'FRENChPoints'),
(12,  2,  'FRENCHowes, and is owed, nothing.'),
(13,  2,  'Catégories'),
(14,  2,  'Créer demande'),
(15,  2,  'Créez une demande'),
(16,  2,  'Le tableau de bord'),
(17,  2,  'Bienvenue sur le tableau de bord!'),
(18,  2,  'Vos demandes'),
(19,  2,  'D\'autres demandes'),
(20,  2,  'Manipuler'),
(21,  2,  'Effacer'),
(22,  2,  'Détails de la demande'),
(23,  2,  'Description'),
(24,  2,  'Statut'),
(25,  2,  'FRENCHDate'),
(26,  2,  'FRENCHPoints'),
(27,  2,  'FRENCHowes people %d favors'),
(28,  2,  'Catégories'),
(29,  2,  'Oui, supprimer!'),
(30,  2,  'Passons, ne pas le supprimer'),
(31,  2,  'Demande a été supprimé'),
(32,  2,  'Demande'),
(33,  2,  'supprimé'),
(34,  2,  'Cette demande a été supprimé, ses points ont été remboursés de vous'),
(35,  2,  'Tableau de bord'),
(36,  2,  'Envoyer un message'),
(37,  2,  'Manipuler'),
(38,  2,  'Message(jusqu\'à %d caractères)'),
(39,  2,  'Êtes-vous sûr de vouloir supprimer cette demande?'),
(40,  2,  'points seront remboursés de vous'),
(41,  2,  'demande de suppression d\'erreur'),
(42,  2,  'S\'identifier'),
(43,  2,  'Se enregistrer'),
(44,  2,  'Bienvenue à Xenos!'),
(45,  2,  'Bien déconnecté'),
(46,  2,  'Erreur générale'),
(47,  2,  'Se il vous plaît entrer un mot de passe'),
(48,  2,  'Se il vous plaît entrer un nom d\'utilisateur'),
(49,  2,  'Nom d\'utilisateur valide / combinaison de mot de passe'),
(50,  2,  'Page de connexion'),
(51,  2,  'Nom d\'utilisateur'),
(52,  2,  'Mot de passe'),
(53,  2,  'Se il vous plaît, entrez un prénom'),
(54,  2,  'Se il vous plaît entrer un nom'),
(55,  2,  'Se il vous plaît entrer un nom d\'utilisateur'),
(56,  2,  'Se il vous plaît entrer un mot de passe'),
(57,  2,  'Cet utilisateur existe déjà'),
(58,  2,  'Création d\'un compte'),
(59,  2,  'Créer un nouveau compte'),
(60,  2,  'Prénom'),
(61,  2,  'Nom De Famille'),
(62,  2,  'Email'),
(63,  2,  'Mot de passe'),
(64,  2,  'Créer mon nouvel utilisateur!'),
(65,  2,  'Déconnecté'),
(66,  2,  'Vous avez enregistré avec succès'),
(67,  2,  'Problème de sécurité'),
(68,  2,  'Votre navigateur ne est pas nous envoyer les informations d\'identification appropriées.'),
(69,  2,  'Merci de vous inscrire!'),
(70,  2,  'Vous êtes génial! merci beaucoup pour saisir votre nom!'),
(71,  2,  'math'),
(72,  2,  'physique'),
(73,  2,  'économie'),
(74,  2,  'histoire'),
(75,  2,  'Anglais'),
(76,  2,  'ouvert'),
(77,  2,  'fermé'),
(78,  2,  'pris'),
(79,  2,  'Rang'),
(80,  2,  'Utilisateur'),
(81,  2,  'Recherche avancée'),
(82,  2,  'Aucun statuts trouvés dans la chaîne'),
(83,  2,  'Date non valide'),
(84,  2,  'EMPTY-NOTUSED'),
(85,  2,  'Aucun membre trouvé dans la chaîne'),
(86,  2,  'Date de début'),
(87,  2,  'Date de fin'),
(88,  2,  'Points minimum'),
(89,  2,  'Maximum de points'),
(90,  2,  'FRENCHEnter words to search in a description'),
(91,  2,  'Saisissez un ou plusieurs noms séparés par des espaces'),
(92,  2,  'Entrez une ou plusieurs catégories séparées par des espaces'),
(93,  2,  'Page'),
(94,  2,  'FRENCHHandle Requestoffer'),
(95,  2,  'FRENCHConfirm'),
(96,  2,  'FRENCHMy messages'),
(97,  2,  'FRENCHMy profile'),
(98,  2,  'FRENCHTransaction is complete'),
(99,  2,  'FRENCHRequestoffer has been closed'),
(100, 2,  'FRENCHOwning user'),
(101, 2,  'FRENCHHandling user'),
(102, 2,  'FRENCHRequestoffers I am handling'),
(103, 2,  'FRENCHNone'),
(104, 2,  'FRENCHOffer received'),
(105, 2,  'FRENCHWe got your offer and will show it to that user shortly.  You can track this on your profile page.'),
(106, 2,  'FRENCHnew'),
(107, 2,  'FRENCHaccepted'),
(108, 2,  'FRENCHrejected'),
(109, 2,  'FRENCHdraft'),
(110, 2,  'FRENCHFavor published'),
(111, 2,  'FRENCHOther users can now view your favor and may offer to handle it.'),
(112, 2,  'FRENCHPassword changed'),
(113, 2,  'FRENCHChange password'),
(114, 2,  'FRENCHYou entered no old password or new password.  Try again.'),
(115, 2,  'FRENCHYou provided a new password, but you need to give us your old password too.'),
(116, 2,  'FRENCHYou forgot to give us your new password.  Try again.'),
(117, 2,  'FRENCHYour new password is too short.  Try again.'),
(118, 2,  'FRENCHWhat you gave for your old password is not valid. Try again.'),
(1,   3,  'Búsqueda'),
(2,   3,  'Crear solicitud'),
(3,   3,  'Cerrar sesión'),
(4,   3,  'Puntos'),
(5,   3,  'Por favor, introduzca una descripción'),
(6,   3,  'SPANISHPublish'),
(7,   3,  'No se pudo analizar puntos'),
(8,   3,  'No se han encontrado en cadena categorías'),
(9,   3,  'SPANISHis owed %d favors'),
(10,  3,  'Descripción'),
(11,  3,  'Puntos'),
(12,  3,  'SPANISHowes, and is owed, nothing.'),
(13,  3,  'Categorías'),
(14,  3,  'Crear solicitud'),
(15,  3,  'Crear una solicitud'),
(16,  3,  'El tablero de instrumentos'),
(17,  3,  'Bienvenido a el tablero!'),
(18,  3,  'Sus pedidos'),
(19,  3,  'Otras solicitudes de'),
(20,  3,  'Manejar'),
(21,  3,  'Borrar'),
(22,  3,  'Solicitar detalles'),
(23,  3,  'Descripción'),
(24,  3,  'Estado'),
(25,  3,  'Fecha'),
(26,  3,  'Puntos'),
(27,  3,  'SPANISHowes people %d favors'),
(28,  3,  'Categorías'),
(29,  3,  'Sí, borrar!'),
(30,  3,  'No importa, no lo elimine'),
(31,  3,  'Solicitud ha sido borrado'),
(32,  3,  'Solicitud'),
(33,  3,  'eliminado'),
(34,  3,  'Esta petición ha sido borrado, sus puntos se han devuelto a usted'),
(35,  3,  'Salpicadero'),
(36,  3,  'Enviar mensaje'),
(37,  3,  'Manejar'),
(38,  3,  'Mensaje(hasta %d caracteres)'),
(39,  3,  '¿Seguro que quieres eliminar esta petición?'),
(40,  3,  'puntos serán reembolsados a usted'),
(41,  3,  'Petición de borrado de errores'),
(42,  3,  'Iniciar Sesión'),
(43,  3,  'Registrarse'),
(44,  3,  'Bienvenido a Xenos!'),
(45,  3,  'Con éxito cerrado la sesión'),
(46,  3,  'Error general'),
(47,  3,  'Por favor, ingrese una contraseña'),
(48,  3,  'Por favor, introduzca un nombre de usuario'),
(49,  3,  'Nombre de usuario no válido combinación / contraseña'),
(50,  3,  'Página de registro'),
(51,  3,  'Nombre de usuario'),
(52,  3,  'Contraseña'),
(53,  3,  'Por favor ingrese un nombre de pila'),
(54,  3,  'Por favor, introduzca un apellido'),
(55,  3,  'Por favor, introduzca un nombre de usuario'),
(56,  3,  'Por favor, ingrese una contraseña'),
(57,  3,  'Ya existe ese usuario'),
(58,  3,  'Creación de cuentas'),
(59,  3,  'Crear una nueva cuenta'),
(60,  3,  'Nombre De Pila'),
(61,  3,  'Apellido'),
(62,  3,  'Correo electrónico'),
(63,  3,  'Contraseña'),
(64,  3,  'Crear mi nuevo usuario!'),
(65,  3,  'Sesión cerrada'),
(66,  3,  'Ha iniciado sesión con éxito'),
(67,  3,  'Problema de seguridad'),
(68,  3,  'Su navegador no nos envió las credenciales adecuadas.'),
(69,  3,  'Gracias por registrarse!'),
(70,  3,  'Usted es maravilloso! muchas gracias por entrar en su nombre!'),
(71,  3,  'matemáticas'),
(72,  3,  'física'),
(73,  3,  'ciencias económicas'),
(74,  3,  'historia'),
(75,  3,  'Inglés'),
(76,  3,  'abierto'),
(77,  3,  'cerrado'),
(78,  3,  'tomado'),
(79,  3,  'Rango'),
(80,  3,  'Usuario'),
(81,  3,  'Búsqueda avanzada'),
(82,  3,  'No se han encontrado en cadena estados'),
(83,  3,  'Fecha no válida'),
(84,  3,  'EMPTY-NOTUSED'),
(85,  3,  'No se han encontrado en cadena usuarios'),
(86,  3,  'Fecha de inicio'),
(87,  3,  'Fecha de finalización'),
(88,  3,  'Puntos mínimos'),
(89,  3,  'El máximo de puntos'),
(90,  3,  'SPANISHEnter words to search in a description'),
(91,  3,  'Ingrese uno o más nombres de usuario separados por espacios'),
(92,  3,  'Introduce una o más categorías separadas por espacios'),
(93,  3,  'Página'),
(94,  3,  'SPANISHHandle Requestoffer'),
(95,  3,  'SPANISHConfirm'),
(96,  3,  'SPANISHMy messages'),
(97,  3,  'SPANISHMy profile'),
(98,  3,  'SPANISHTransaction is complete'),
(99,  3,  'SPANISHRequestoffer has been closed'),
(100, 3,  'SPANISHOwning user'),
(101, 3,  'SPANISHHandling user'),
(102, 3,  'SPANISHRequestoffers I am handling'),
(103, 3,  'SPANISHNone'),
(104, 3,  'SPANISHOffer received'),
(105, 3,  'SPANISHWe got your offer and will show it to that user shortly.  You can track this on your profile page.'),
(106, 3,  'SPANISHnew'),
(107, 3,  'SPANISHaccepted'),
(108, 3,  'SPANISHrejected'),
(109, 3,  'SPANISHdraft'),
(110, 3,  'SPANISHFavor published'),
(111, 3,  'SPANISHOther users can now view your favor and may offer to handle it.'),
(112, 3,  'SPANISHPassword changed'),
(113, 3,  'SPANISHChange password'),
(114, 3,  'SPANISHYou entered no old password or new password.  Try again.'),
(115, 3,  'SPANISHYou provided a new password, but you need to give us your old password too.'),
(116, 3,  'SPANISHYou forgot to give us your new password.  Try again.'),
(117, 3,  'SPANISHYour new password is too short.  Try again.'),
(118, 3,  'SPANISHWhat you gave for your old password is not valid. Try again.'),
(1,   4,  '搜索'),
(2,   4,  '创建请求'),
(3,   4,  '注销'),
(4,   4,  '点'),
(5,   4,  '请输入描述'),
(6,   4,  'CHINESEPublish'),
(7,   4,  '无法解析点'),
(8,   4,  '没有在字符串中找到的类别'),
(9,   4,  'CHINESEis owed %d favors'),
(10,  4,  '描述'),
(11,  4,  '点'),
(12,  4,  'CHINESEowes, and is owed, nothing.'),
(13,  4,  '分类'),
(14,  4,  '创建请求'),
(15,  4,  '创建请求'),
(16,  4,  '仪表板'),
(17,  4,  '欢迎到仪表板！'),
(18,  4,  '您的要求'),
(19,  4,  '对方的请求'),
(20,  4,  '处理'),
(21,  4,  '删除'),
(22,  4,  '请求细节'),
(23,  4,  '描述'),
(24,  4,  '状态'),
(25,  4,  '日期'),
(26,  4,  '点'),
(27,  4,  'CHINESEowes people %d favors'),
(28,  4,  '分类'),
(29,  4,  '是的，删除！'),
(30,  4,  '没关系，请不要删除它'),
(31,  4,  '请求已被删除'),
(32,  4,  '要求'),
(33,  4,  '删除'),
(34,  4,  '这一要求已被删除，其点已退还给你'),
(35,  4,  '仪表盘'),
(36,  4,  '发送信息'),
(37,  4,  '处理'),
(38,  4,  '消息（最多%d个字符）'),
(39,  4,  '你确定要删除这个请求？'),
(40,  4,  '积分将被退还给你'),
(41,  4,  '错误删除请求'),
(42,  4,  '登录'),
(43,  4,  '注册'),
(44,  4,  '欢迎您的Xenos！'),
(45,  4,  '成功注销'),
(46,  4,  '一般错误'),
(47,  4,  '请输入密码'),
(48,  4,  '请输入用户名'),
(49,  4,  '无效的用户名/密码组合'),
(50,  4,  '登录页面'),
(51,  4,  '用户名'),
(52,  4,  '密码'),
(53,  4,  '请输入名字'),
(54,  4,  '请输入姓氏'),
(55,  4,  '请输入用户名'),
(56,  4,  '请输入密码'),
(57,  4,  '该用户已经存在'),
(58,  4,  '帐户创建'),
(59,  4,  '创建一个新帐户'),
(60,  4,  '名字'),
(61,  4,  '姓'),
(62,  4,  '电子邮件'),
(63,  4,  '密码'),
(64,  4,  '创建我的新用户！'),
(65,  4,  '注销'),
(66,  4,  '您已成功退出'),
(67,  4,  '安全问题'),
(68,  4,  '您的浏览器并没有给我们正确的凭据。 '),
(69,  4,  '感谢您的注册！'),
(70,  4,  '你真棒！感谢这么多的进入你的名字！ '),
(71,  4,  '数学'),
(72,  4,  '物理学'),
(73,  4,  '经济学'),
(74,  4,  '历史'),
(75,  4,  '英语'),
(76,  4,  '开放'),
(77,  4,  '关闭'),
(78,  4,  '拍摄'),
(79,  4,  '秩'),
(80,  4,  '用户'),
(81,  4,  '高级搜索'),
(82,  4,  '没有在字符串中找到状态'),
(83,  4,  '无效日期'),
(84,  4,  'EMPTY-NOTUSED'),
(85,  4,  '没有在字符串中找到用户'),
(86,  4,  '开始日期'),
(87,  4,  '结束日期'),
(88,  4,  '最低点'),
(89,  4,  '最高点'),
(90,  4,  'CHINESEEnter words to search in a description'),
(91,  4,  '输入用空格分隔的一个或多个用户名'),
(92,  4,  '输入用空格分隔的一个或多个类别'),
(93,  4,  '页面'),
(94,  4,  'CHINESE Handle Requestoffer'),
(95,  4,  'CHINESEConfirm'),
(96,  4,  'CHINESEMy messages'),
(97,  4,  'CHINESEMy profile'),
(98,  4,  'CHINESETransaction is complete'),
(99,  4,  'CHINESERequestoffer has been closed'),
(100, 4,  'CHINESEOwning user'),
(101, 4,  'CHINESEHandling user'),
(102, 4,  'CHINESERequestoffers I am handling'),
(103, 4,  'CHINESENone'),
(104, 4,  'CHINESEOffer received'),
(105, 4,  'CHINESEWe got your offer and will show it to that user shortly.  You can track this on your profile page.'),
(106, 4,  'CHINESEnew'),
(107, 4,  'CHINESEaccepted'),
(108, 4,  'CHINESErejected'),
(109, 4,  'CHINESEdraft'),
(110, 4,  'CHINESEFavor published'),
(111, 4,  'CHINESEOther users can now view your favor and may offer to handle it.'),
(112, 4,  'CHINESEPassword changed'),
(113, 4,  'CHINESEChange password'),
(114, 4,  'CHINESEYou entered no old password or new password.  Try again.'),
(115, 4,  'CHINESEYou provided a new password, but you need to give us your old password too.'),
(116, 4,  'CHINESEYou forgot to give us your new password.  Try again.'),
(117, 4,  'CHINESEYour new password is too short.  Try again.'),
(118, 4,  'CHINESEWhat you gave for your old password is not valid. Try again.'),
(1,   5,  'חיפוש'),
(2,   5,  'צור'),
(3,   5,  'התנתקות'),
(4,   5,  'נקודות'),
(5,   5,  'נא להזין תיאור'),
(6,   5,  'HEBREWPublish'),
(7,   5,  'אין אפשרות לנתח את הנקודות'),
(8,   5,  'אין קטגוריות מצאו במחרוזת'),
(9,   5,  'HEBREWis owed %d favors'),
(10,  5,  'תיאור'),
(11,  5,  'נקודות'),
(12,  5,  'HEBREWowes, and is owed, nothing.'),
(13,  5,  'קטגוריות'),
(14,  5,  'צור'),
(15,  5,  'ליצור בקשה'),
(16,  5,  'לוח המחוונים'),
(17,  5,  'ברוכים הבאים ללוח המחוונים!'),
(18,  5,  'הבקשות שלך'),
(19,  5,  'בקשות של אחרים'),
(20,  5,  'ידית'),
(21,  5,  'מחק'),
(22,  5,  'בקש פרטים'),
(23,  5,  'תיאור'),
(24,  5,  'סטטוס'),
(25,  5,  'תאריך'),
(26,  5,  'נקודות'),
(27,  5,  'HEBREWowes people %d favors'),
(28,  5,  'קטגוריות'),
(29,  5,  'כן, למחוק!'),
(30,  5,  'Nevermind, אל תמחק אותו'),
(31,  5,  'בקשה נמחקה'),
(32,  5,  'בקשה'),
(33,  5,  'נמחק'),
(34,  5,  'בקשה זו נמחקה, הנקודות שלה כבר תוחזר אליך'),
(35,  5,  'לוח מחוונים'),
(36,  5,  'שלח הודעה'),
(37,  5,  'ידית'),
(38,  5,  'הודעה(עד %d תווים)'),
(39,  5,  'האם אתה בטוח שאתה רוצה למחוק בקשה זו?'),
(40,  5,  'נקודות תוחזר אליך'),
(41,  5,  'בקשת מחיקת שגיאה'),
(42,  5,  'כניסה'),
(43,  5,  'הרשמה'),
(44,  5,  'ברוכים הבאים לXenos!'),
(45,  5,  'בהצלחה מתנתק'),
(46,  5,  'שגיאה כללית'),
(47,  5,  'יש להזין סיסמא'),
(48,  5,  'יש להזין שם משתמש'),
(49,  5,  'שם משתמש לא חוקי / שילוב סיסמא'),
(50,  5,  'דף כניסה'),
(51,  5,  'שם משתמש'),
(52,  5,  'סיסמא'),
(53,  5,  'נא להזין את השם פרטי'),
(54,  5,  'נא להזין שם משפחה'),
(55,  5,  'יש להזין שם משתמש'),
(56,  5,  'יש להזין סיסמא'),
(57,  5,  'משתמש שכבר קיים'),
(58,  5,  'יצירת חשבון'),
(59,  5,  'צור חשבון חדש'),
(60,  5,  'שם פרטים'),
(61,  5,  'שם משפחה'),
(62,  5,  'דוא"ל'),
(63,  5,  'סיסמא'),
(64,  5,  'צור המשתמש החדש שלי!'),
(65,  5,  'מתנתק'),
(66,  5,  'יש לך מחובר בהצלחה'),
(67,  5,  'בעיה בטחונית'),
(68,  5,  'הדפדפן שלך לא לשלוח לנו את אישורי המתאימים.'),
(69,  5,  'תודה על הרשמה!'),
(70,  5,  'אתה מדהים! תודה רבה להזנת השם שלך!'),
(71,  5,  'מתמטיקה'),
(72,  5,  'פיסיקה'),
(73,  5,  'כלכלה'),
(74,  5,  'היסטוריה'),
(75,  5,  'אנגלית'),
(76,  5,  'פתוח'),
(77,  5,  'סגור'),
(78,  5,  'לקחתי'),
(79,  5,  'דירוג'),
(80,  5,  'משתמש'),
(81,  5,  'חיפוש מתקדם'),
(82,  5,  'אין סטטוסים נמצאים במחרוזת'),
(83,  5,  'תאריך לא חוקי'),
(84,  5,  'EMPTY-NOTUSED'),
(85,  5,  'לא נמצאו משתמשים במחרוזת'),
(86,  5,  'תאריך ההתחלה'),
(87,  5,  'תאריך סיום'),
(88,  5,  'נקודות מינימום'),
(89,  5,  'נקודות המרביות'),
(90,  5,  'HEBREWEnter words to search in a description'),
(91,  5,  'הזן שמות משתמשים אחד או יותר מופרדים על ידי רווחים'),
(92,  5,  'הזן קטגוריה אחת או יותר מופרדת על ידי רווחים'),
(93,  5,  'דף'),
(94,  5,  'HEBREW Handle Requestoffer'),
(95,  5,  'HEBREWConfirm'),
(96,  5,  'HEBREWMy messages'),
(97,  5,  'HEBREWMy profile'),
(98,  5,  'HEBREWTransaction is complete'),
(99,  5,  'HEBREWRequestoffer has been closed'),
(100, 5,  'HEBREWOwning user'),
(101, 5,  'HEBREWHandling user'),
(102, 5,  'HEBREWRequestoffers I am handling'),
(103, 5,  'HEBREWNone'),
(104, 5,  'HEBREWOffer received'),
(105, 5,  'HEBREWWe got your offer and will show it to that user shortly.  You can track this on your profile page.'),
(106, 5,  'HEBREWnew'),
(107, 5,  'HEBREWaccepted'),
(108, 5,  'HEBREWrejected'),
(109, 5,  'HEBREWdraft'),
(110, 5,  'HEBREWFavor published'),
(111, 5,  'HEBREWOther users can now view your favor and may offer to handle it.'),
(112, 5,  'HEBREWPassword changed'),
(113, 5,  'HEBREWChange password'),
(114, 5,  'HEBREWYou entered no old password or new password.  Try again.'),
(115, 5,  'HEBREWYou provided a new password, but you need to give us your old password too.'),
(116, 5,  'HEBREWYou forgot to give us your new password.  Try again.'),
(117, 5,  'HEBREWYour new password is too short.  Try again.'),
(118, 5,  'HEBREWWhat you gave for your old password is not valid. Try again.');
