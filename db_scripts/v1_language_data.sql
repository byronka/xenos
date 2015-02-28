-- clear the table before we start.
truncate localization_lookup;

---DELIMITER---

-- insert into the lookup table for words and 
-- phrases to their localized counterparts, e.g. French, English, etc.
INSERT INTO localization_lookup(local_id, language, text)
VALUES
(1,   1,  'Search'),
(2,   1,  'Request Favor'),
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
(14,  1,  'Minimum Rank'),
(15,  1,  'Maximum Rank'),
(16,  1,  'The dashboard'),
(17,  1,  'Welcome to the dashboard!'),
(18,  1,  'EMPTY_NOT_USED'),
(19,  1,  'EMPTY_NOT_USED'),
(20,  1,  'Handle'),
(21,  1,  'Delete'),
(22,  1,  'Favor Details'),
(23,  1,  'Description'),
(24,  1,  'Status'),
(25,  1,  'Date'),
(26,  1,  'Points'),
(27,  1,  'owes people %d favors'),
(28,  1,  'Categories'),
(29,  1,  'Yes, delete!'),
(30,  1,  'Nevermind, do not delete it'),
(31,  1,  'Favor has been deleted'),
(32,  1,  'Favor'),
(33,  1,  'deleted'),
(34,  1,  'This favor has been deleted, its points have been refunded to you'),
(35,  1,  'Dashboard'),
(36,  1,  'Send message'),
(37,  1,  'Handle'),
(38,  1,  'Message(up to %d characters)'),
(39,  1,  'Are you sure you want to delete this favor?'),
(40,  1,  'points will be refunded to you'),
(41,  1,  'Error deleting favor'),
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
(94,  1,  'Handle favor'),
(95,  1,  'Confirm'),
(96,  1,  'My conversations'),
(97,  1,  'My profile'),
(98,  1,  'Transaction is complete'),
(99,  1,  'Favor has been closed'),
(100, 1,  'Owning user'),
(101, 1,  'Handling user'),
(102, 1,  'Favors I am handling'),
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
(119, 1,  'Favors I have offered to service'),
(120, 1,  'Offers to service my favors'),
(121, 1,  'If you would like to offer to service this favor, click the confirm button below.'),
(122, 1,  'My open Favors'),
(123, 1,  'My Favors being serviced'),
(124, 1,  'My closed Favors'),
(125, 1,  'My draft Favors'),
(126, 1,  'Cancel an active Favor'),
(127, 1,  'Favor canceled'),
(128, 1,  'Your transaction has been canceled'),
(129, 1,  'If you would like to cancel this active Favor, click the confirm button below.  This will give you the chance provide a grade for the other person, as well as giving them a chance to grade you.'),
(130, 1,  'Cancel'),
(131, 1,  'Your transaction on a favor has been canceled by the other party.  Check out your profile page to enter feedback on that transaction.'),
(132, 1,  'Congratulations! You have been awarded the right to service a Favor.  Check your profile for more information.'),
(133, 1,  'Unfortunately, you were not accepted to handle a Favor.'),
(134, 1,  'A Favor which you were handling has been completed.'),
(135, 1,  'A Favor which you were owner of has been completed.'),
(136, 1,  'You have canceled an active transaction.'),
(137, 1,  'Choose'),
(138, 1,  'wants to handle'),
(139, 1,  'Choose a handler'),
(140, 1,  'Confirm that you would like the following user to handle this request.'),
(141, 1,  'You have selected a handler for your Favor!'),
(142, 1,  'You have now selected someone to handle your favor.  That user will be informed, and we will also inform the other users (if any) that they have not been selected.'),
(143, 1,  'Babysitting'),
(144, 1,  'Dog-walking'),
(145, 1,  'Taxi'),
(146, 1,  'My system messages'),
(147, 1,  'EMPTY_NOT_USED'),
(148, 1,  'You have recieved an offer to handle a Favor.'),
(149, 1,  'Does this Favor need a location?'),
(150, 1,  'Yes'),
(151, 1,  'No'),
(152, 1,  'Street Address 1'),
(153, 1,  'Street Address 2'),
(154, 1,  'City'),
(155, 1,  'State'),
(156, 1,  'Postal code'),
(157, 1,  'Country'),
(158, 1,  'Select one of your saved locations'),
(159, 1,  'Or enter a new address'),
(160, 1,  'Save to my favorites'),
(161, 1,  'Enter a ranking value between 0.0 and 1.0'),
(162, 1,  'Enter a postal code to search'),
(163, 1,  'Invalid - must be a number between 0 and 1'),
(164, 1,  'Invalid - maximum rank must be greater than minimum rank'),
(165, 1,  'You'),
(166, 1,  'increased'),
(167, 1,  'decreased'),
(168, 1,  'the reputation of'),
(169, 1,  'your reputation'),
(170, 1,  'for the favor'),
(1, 2, 'Recherche'),
(2, 2, 'Demande Favor '),
(3, 2, 'Quitter'),
(4, 2, 'Points'),
(5, 2, 'Se il vous plaît entrez une description'),
(6, 2, 'Publier'),
(7, 2, 'Impossible d''analyser les points'),
(8, 2, 'Aucune catégorie trouvée dans la chaîne'),
(9, 2, 'est due% d faveurs'),
(10, 2, 'Description'),
(11, 2, 'Points'),
(12, 2, 'doit, et qui est dû, rien.'),
(13, 2, 'Catégories'),
(14, 2, 'EMPTY_NOT_USED'),
(15, 2, 'EMPTY_NOT_USED'),
(16, 2, 'Le tableau de bord '),
(17, 2, 'Bienvenue sur le tableau de bord!'),
(18, 2, 'EMPTY_NOT_USED'),
(19, 2, 'EMPTY_NOT_USED'),
(20, 2, 'poignée'),
(21, 2, 'Supprimer'),
(22, 2, 'Favor Détails'),
(23, 2, 'Description'),
(24, 2, 'Status'),
(25, 2, 'Date'),
(26, 2, 'Points'),
(27, 2, 'doit personnes% d favorise'),
(28, 2, 'Catégories'),
(29, 2, 'Oui, supprimer!'),
(30, 2, 'de Nevermind, ne le supprimez pas'),
(31, 2, 'Favor a été supprimé'),
(32, 2, 'faveur'),
(33, 2, 'supprimé'),
(34, 2, 'Cette faveur a été supprimé, ses points ont été remboursés de vous'),
(35, 2, 'Dashboard'),
(36, 2, 'Envoyer message'),
(37, 2, 'poignée'),
(38, 2, 'Message (jusqu''à% d caractères) '),
(39, 2, 'Etes-vous sûr de vouloir supprimer cette faveur?'),
(40, 2, 'points sera remboursé à vous '),
(41, 2, 'Erreur de suppression faveur'),
(42, 2, 'Login'),
(43, 2, 'Register'),
(44, 2, 'Bienvenue à Xenos!'),
(45, 2, 'bien déconnecté'),
(46, 2, 'Erreur général'),
(47, 2, 'Se il vous plaît entrer un mot de passe '),
(48, 2, 'Se il vous plaît entrez un nom d''utilisateur '),
(49, 2, 'la combinaison nom d''utilisateur / mot de passe invalide'),
(50, 2, 'page de connexion'),
(51, 2, 'Nom d''utilisateur'),
(52, 2, 'Mot de passe'),
(53, 2, 'Se il vous plaît, entrez un prénom'),
(54, 2, 'Se il vous plaît entrez un nom de famille '),
(55, 2, 'EMPTY_NOT_USED_TRY_47'),
(56, 2, 'EMPTY_NOT_USED_TRY_48'),
(57, 2, 'Cet utilisateur existe déjà '),
(58, 2, 'Création de compte '),
(59, 2, 'Créer un nouveau compte'),
(60, 2, 'Prénom'),
(61, 2, 'Nom'),
(62, 2, 'Email'),
(63, 2, 'Mot de passe'),
(64, 2, 'Créer mon nouvel utilisateur!'),
(65, 2, 'déconnectés'),
(66, 2, 'Vous avez bien déconnecté'),
(67, 2, 'problème de sécurité'),
(68, 2, 'Votre navigateur ne nous ont pas envoyer les informations d''identification appropriées.'),
(69, 2, 'Merci de vous inscrire!'),
(70, 2, 'Vous êtes génial! Merci beaucoup pour entrer votre nom!'),
(71, 2, 'mathématiques'),
(72, 2, 'physique'),
(73, 2, 'économie'),
(74, 2, 'histoire'),
(75, 2, 'anglais'),
(76, 2, 'ouvert'),
(77, 2, 'fermé'),
(78, 2, 'pris'),
(79, 2, 'Rang'),
(80, 2, 'User'),
(81, 2, 'Recherche avancée'),
(82, 2, 'Pas de statuts trouvé dans la chaîne'),
(83, 2, 'Date non valide'),
(84, 2, 'VIDE-NOTUSED'),
(85, 2, 'Aucun membre trouvé dans la chaîne'),
(86, 2, 'Date de début'),
(87, 2, 'Fin'),
(88, 2, 'points minimum'),
(89, 2, 'maximum de points '),
(90, 2, 'Entrez les mots à rechercher dans une description'),
(91, 2, 'Entrez un ou plusieurs noms séparés par des espaces '),
(92, 2, 'Entrez un ou plusieurs catégories séparées par des espaces '),
(93, 2, 'Page'),
(94, 2, 'Handle faveur'),
(95, 2, 'Confirmer'),
(96, 2, 'Mes conversations'),
(97, 2, 'Mon profil'),
(98, 2, 'transaction est terminée'),
(99, 2, 'Favor a été fermé '),
(100, 2, 'Posséder utilisateur'),
(101, 2, 'Manipulation utilisateur'),
(102, 2, 'faveurs que je me occupe'),
(103, 2, 'None'),
(104, 2, 'offre reçue'),
(105, 2, 'Nous avons obtenu votre offre et nous allons montrer à l''utilisateur sous peu. Vous pouvez suivre cela sur votre page de profil.'),
(106, 2, 'nouvelle'),
(107, 2, 'accepté'),
(108, 2, 'rejeté'),
(109, 2, 'projet'),
(110, 2, 'Faveur publié'),
(111, 2, 'Les autres utilisateurs peuvent désormais visualiser votre faveur et peuvent offrir à gérer. '),
(112, 2, 'Mot de passe changé '),
(113, 2, 'Modifier mot de passe'),
(114, 2, 'vous avez entré ne ancien mot de passe ou un nouveau mot de passe. Essayez à nouveau.'),
(115, 2, 'vous avez fourni un nouveau mot de passe, mais vous devez nous donner votre ancien mot de passe trop.'),
(116, 2, 'Vous avez oublié de nous donner votre nouveau mot de passe. Essayez à nouveau.'),
(117, 2, 'Votre nouveau mot de passe est trop court. Essayez à nouveau.'),
(118, 2, 'Qu''est-ce que vous avez donné à votre ancien mot de passe ne est pas valide. Essayez à nouveau.'),
(119, 2, 'faveurs que je ai offert de service '),
(120, 2, 'Offres de réparer mes faveurs'),
(121, 2, 'Si vous souhaitez offrir au service de cette faveur, cliquez sur le bouton de confirmation ci-dessous.'),
(122, 2, 'Mes Faveurs ouvertes '),
(123, 2, 'Mes Faveurs étant desservis'),
(124, 2, 'Mes Faveurs fermées '),
(125, 2, 'Mon projet Favors'),
(126, 2, 'annuler une Favor actif '),
(127, 2, 'faveur annulé'),
(128, 2, 'Votre transaction a été annulée'),
(129, 2, 'Si vous souhaitez annuler cette faveur actif, cliquez sur le bouton de confirmation ci-dessous. Cela vous donnera la chance de fournir une note pour l''autre personne, ainsi que de leur donner une chance de vous grade.'),
(130, 2, 'Annuler'),
(131, 2, 'Votre transaction sur une faveur a été effacé par l''autre partie. Commander votre page de profil pour entrer les informations sur cette transaction. '),
(132, 2, 'Félicitations! Vous avez reçu le droit de desservir une faveur. Consultez votre profil pour plus d''informations.'),
(133, 2, 'Malheureusement, vous ne ont pas été acceptés pour gérer une faveur. '),
(134, 2, 'Une faveur qui vous manipulez a été achevée.'),
(135, 2, 'Une faveur dont vous étiez propriétaire a été achevée.'),
(136, 2, 'Vous avez annulé une transaction active.'),
(137, 2, 'Choisir'),
(138, 2, 'veut gérer'),
(139, 2, 'Choisissez un gestionnaire '),
(140, 2, 'Confirmez que vous souhaitez l''utilisateur suivant pour gérer cette demande.'),
(141, 2, 'Vous avez choisi un gestionnaire pour votre faveur!'),
(142, 2, 'Vous avez choisi quelqu''un pour gérer votre faveur. Ce utilisateur sera informé, et nous informe également les autres utilisateurs (le cas échéant) qu''ils ne ont pas été sélectionnés.'),
(143, 2, 'garde'),
(144, 2, 'Dog-marche '),
(145, 2, 'Taxi'),
(146, 2, 'Mes messages système '),
(147, 2, 'Vous avez fait une offre pour gérer un Favor '),
(148, 2, 'Vous ai reçu une offre pour gérer une faveur. '),
(149, 2, 'Est-ce Favor besoin d''un endroit? '),
(150, 2, 'Oui'),
(151, 2, 'Non'),
(152, 2, 'Adresse civique 1'),
(153, 2, 'Adresse 2'),
(154, 2, 'City'),
(155, 2, 'État'),
(156, 2, 'Code postal'),
(157, 2, 'Pays'),
(158, 2, 'Sélectionnez un de vos emplacements enregistrés'),
(159, 2, 'Ou entrer une nouvelle adresse'),
(160, 2, 'Enregistrer à mes favoris'),
(161, 2, 'FRENCHEnter a ranking value between 0.0 and 1.0'),
(162, 2, 'FRENCHEnter a postal code to search'),
(163, 2, 'FRENChInvalid - must be a number between 0 and 1'),
(164, 2, 'FRENCHInvalid - maximum rank must be greater than minimum rank'),
(165, 2, 'FRENCHYou'),
(166, 2, 'FRENCHincreased'),
(167, 2, 'FRENCHdecreased'),
(168, 2, 'FRENCHthe reputation of'),
(169, 2, 'FRENCHyour reputation'),
(170, 2, 'FRENCHfor the favor'),
(1, 3, 'Buscar'),
(2, 3, 'Solicitud favor '),
(3, 3, 'Salir'),
(4, 3, 'Puntos'),
(5, 3, 'Por favor introduzca una descripción'),
(6, 3, 'Publicar'),
(7, 3, 'No se pudo analizar puntos'),
(8, 3, 'No hay categorías encuentran en cadena'),
(9, 3, 'se le debe favores% d'),
(10, 3, 'Descripción'),
(11, 3, 'Puntos'),
(12, 3, 'debe, y se le debe, nada.'),
(13, 3, 'Categorías'),
(14, 3, 'EMPTY_NOT_USED'),
(15, 3, 'EMPTY_NOT_USED'),
(16, 3, 'El salpicadero'),
(17, 3, 'Bienvenido a el tablero!'),
(18, 3, 'EMPTY_NOT_USED'),
(19, 3, 'EMPTY_NOT_USED'),
(20, 3, 'Handle'),
(21, 3, 'Eliminar'),
(22, 3, 'el favor Detalles '),
(23, 3, 'Descripción'),
(24, 3, 'Estado'),
(25, 3, 'Fecha'),
(26, 3, 'Puntos'),
(27, 3, 'le debe la gente% d favorece'),
(28, 3, 'Categorías'),
(29, 3, 'Sí, eliminar!'),
(30, 3, 'No importa, no lo elimine'),
(31, 3, 'Favor ha sido eliminado'),
(32, 3, 'favor'),
(33, 3, 'borrado'),
(34, 3, 'Este favor se ha eliminado, sus puntos han sido reembolsados ​​a usted'),
(35, 3, 'Dashboard'),
(36, 3, 'Enviar mensaje'),
(37, 3, 'Handle'),
(38, 3, 'Mensaje (hasta% personajes d)'),
(39, 3, '¿Estás seguro que quieres borrar este favor?'),
(40, 3, 'puntos se devolverá a usted'),
(41, 3, 'Error borrando favor '),
(42, 3, 'Entrar'),
(43, 3, 'Registro'),
(44, 3, 'Bienvenido a Xenos!'),
(45, 3, 'éxito conectado out'),
(46, 3, 'Error General '),
(47, 3, 'Por favor introduzca una contraseña'),
(48, 3, 'Por favor introduzca un nombre de usuario '),
(49, 3, 'Combinación no válida nombre de usuario / contraseña'),
(50, 3, 'Página de registro'),
(51, 3, 'nombre de usuario'),
(52, 3, 'contraseña'),
(53, 3, 'Por favor introduzca un nombre de pila '),
(54, 3, 'Por favor introduzca un apellido'),
(55, 3, 'EMPTY_NOT_USED_TRY_47'),
(56, 3, 'EMPTY_NOT_USED_TRY_48'),
(57, 3, 'Ese usuario ya existe '),
(58, 3, 'Creación de cuentas'),
(59, 3, 'Crear una nueva cuenta'),
(60, 3, 'Nombre'),
(61, 3, 'apellido'),
(62, 3, 'Correo electrónico'),
(63, 3, 'contraseña'),
(64, 3, 'Crear mi nuevo usuario!'),
(65, 3, 'cerrado la sesión'),
(66, 3, 'que se haya conectado con éxito'),
(67, 3, 'problema de seguridad'),
(68, 3, 'Su navegador no nos envían las credenciales adecuadas.'),
(69, 3, 'Gracias por registrarse!'),
(70, 3, 'Usted es impresionante! Muchas gracias por entrar en su nombre!'),
(71, 3, 'matemáticas'),
(72, 3, 'física'),
(73, 3, 'economía'),
(74, 3, 'historia'),
(75, 3, 'Inglés'),
(76, 3, 'abierto'),
(77, 3, 'cerrado'),
(78, 3, 'tomada'),
(79, 3, 'Rango'),
(80, 3, 'Usuario'),
(81, 3, 'Búsqueda Avanzada'),
(82, 3, 'No hay estados encuentran en cadena'),
(83, 3, 'Fecha no válida '),
(84, 3, 'NOTUSED VACÍA'),
(85, 3, 'No hay usuarios encuentran en cadena'),
(86, 3, 'Fecha de inicio'),
(87, 3, 'Fecha fin'),
(88, 3, 'puntos mínimos '),
(89, 3, 'el máximo de puntos'),
(90, 3, 'Introduzca las palabras a buscar en una descripción'),
(91, 3, 'Ingrese uno o más nombres de usuario separados por espacios'),
(92, 3, 'Introduzca una o varias categorías separadas por espacios'),
(93, 3, 'Página'),
(94, 3, 'favor Mango'),
(95, 3, 'Confirmar'),
(96, 3, 'Mis conversaciones'),
(97, 3, 'Mi perfil'),
(98, 3, 'transacción es completa'),
(99, 3, 'Favor se ha cerrado '),
(100, 3, 'Ser dueño de usuario'),
(101, 3, 'Manejo de usuario'),
(102, 3, 'favores que estoy manejando'),
(103, 3, 'None'),
(104, 3, 'oferta recibida'),
(105, 3, 'Tenemos su oferta y te lo enseñamos ese usuario en breve. Usted puede realizar un seguimiento de esto en su página de perfil.'),
(106, 3, 'nuevo'),
(107, 3, 'aceptados'),
(108, 3, 'rechazados'),
(109, 3, 'proyecto'),
(110, 3, 'favorecer publicado'),
(111, 3, 'Otros usuarios pueden ahora ver su favor y pueden ofrecer para manejarlo.'),
(112, 3, 'Contraseña cambió'),
(113, 3, 'Cambiar contraseña'),
(114, 3, 'Usted no introdujo ninguna contraseña antigua o nueva contraseña. Inténtalo de nuevo.'),
(115, 3, 'que ya ha proporcionado una nueva contraseña, pero tienes que darnos tu contraseña antigua también.'),
(116, 3, 'Usted se olvidó de darnos su nueva contraseña. Inténtalo de nuevo.'),
(117, 3, 'Tu nueva contraseña es demasiado corta. Inténtalo de nuevo.'),
(118, 3, '¿Qué le diste para su antigua contraseña no es válida. Inténtelo de nuevo.'),
(119, 3, 'favores que he ofrecido para el servicio '),
(120, 3, 'Ofertas para dar servicio a mis favores'),
(121, 3, 'Si a usted le gustaría ofrecer reparar este favor, haga clic en el botón de confirmación a continuación.'),
(122, 3, 'Mis favores abiertas'),
(123, 3, 'Mis favores siendo atendidos'),
(124, 3, 'Mis favores cerradas '),
(125, 3, 'Mi proyecto Favores '),
(126, 3, 'Anular un favor activa'),
(127, 3, 'favor cancelados'),
(128, 3, 'La transacción ha sido cancelado'),
(129, 3, 'Si usted desea cancelar este favor activa, haga clic en el botón de confirmación a continuación. Esto le dará la oportunidad de proporcionar un grado de la otra persona, así como darles la oportunidad de que grado.'),
(130, 3, 'Cancelar'),
(131, 3, 'Tu transacción en un favor ha sido cancelada por la otra parte. Échale un vistazo a su página de perfil para entrar en comentarios sobre la transacción.'),
(132, 3, '¡Enhorabuena, han sido galardonados con el derecho a dar servicio a Favor. Comprueba tu perfil para obtener más información.'),
(133, 3, 'Por desgracia, no fueron aceptados para manejar un favor.'),
(134, 3, 'A Favor que usted estaba manejando se ha completado.'),
(135, 3, 'A Favor que usted era propietario de que se ha completado.'),
(136, 3, 'Ha cancelado una transacción activa.'),
(137, 3, 'Elegir'),
(138, 3, 'quiere manejar'),
(139, 3, 'Elija un controlador'),
(140, 3, 'Confirme que desea que el siguiente usuario para manejar este pedido.'),
(141, 3, 'Ha seleccionado un controlador para su favor!'),
(142, 3, 'Ahora ha seleccionado a alguien para manejar a su favor. Eso usuario será informado, y también se informará a los demás usuarios (si los hay) que no han sido seleccionados.'),
(143, 3, 'canguro'),
(144, 3, 'Dog-pie'),
(145, 3, 'Taxi'),
(146, 3, 'Mis mensajes del sistema'),
(147, 3, 'Usted ha hecho una oferta para manejar un favor'),
(148, 3, 'Usted ha recibido una oferta para manejar un favor.'),
(149, 3, '¿Es necesario este favor una ubicación?'),
(150, 3, 'Sí'),
(151, 3, 'No'),
(152, 3, 'Dirección Calle 1'),
(153, 3, 'Dirección Calle 2'),
(154, 3, 'City'),
(155, 3, 'Estado'),
(156, 3, 'Código postal'),
(157, 3, 'País'),
(158, 3, 'Seleccione una de las ubicaciones guardadas'),
(159, 3, 'O introducir una nueva dirección '),
(160, 3, 'Guardar en Mis favoritos '),
(161, 3, 'SPANISHEnter a ranking value between 0.0 and 1.0'),
(162, 3, 'SPANISHEnter a postal code to search'),
(163, 3, 'SPANISHInvalid - must be a number between 0 and 1'),
(164, 3, 'SPANISHInvalid - maximum rank must be greater than minimum rank'),
(165, 3, 'SPANISHYou'),
(166, 3, 'SPANISHincreased'),
(167, 3, 'SPANISHdecreased'),
(168, 3, 'SPANISHthe reputation of'),
(169, 3, 'SPANISHyour reputation'),
(170, 3, 'SPANISHfor the favor'),
(1,4,'搜索'),
(2,4,'请求青睐'),
(3,4,'退出'),
(4,4,'分'),
(5,4,'请输入描述'),
(6,4,'发布'),
(7,4,'无法解析点'),
(8,4,'找到字符串无类'),
(9,4,'欠％D恩惠'),
(10,4,'说明'),
(11,4,'分'),
(12,4,'欠和欠,什么都没有。'),
(13,4,'类别'),
(14,4,'EMPTY_NOT_USED'),
(15,4,'EMPTY_NOT_USED'),
(16,4,'仪表板'),
(17,4,'欢迎到仪表板！'),
(18,4,'EMPTY_NOT_USED'),
(19,4,'EMPTY_NOT_USED'),
(20,4,'句柄'),
(21,4,'删除'),
(22,4,'青睐细节'),
(23,4,'说明'),
(24,4,'状态'),
(25,4,'日期'),
(26,4,'分'),
(27,4,'欠人％D有利于'),
(28,4,'类别'),
(29,4,'是的,删除！'),
(30,4,'没关系,不要删除它'),
(31,4,'青睐已被删除'),
(32,4,'青睐'),
(33,4,'已删除'),
(34,4,'这有利于已被删除,其点已退还给你'),
(35,4,'仪表盘'),
(36,4,'发送消息'),
(37,4,'处理'),
(38,4,'信息(最多％d个字符)'),
(39,4,'你确定要删除这个忙吗？'),
(40,4,'积分将被退还给你'),
(41,4,'错误删除青睐'),
(42,4,'登录'),
(43,4,'注册'),
(44,4,'欢迎光临的Xenos！'),
(45,4,'成功注销'),
(46,4,'一般错误'),
(47,4,'请输入密码'),
(48,4,'请输入用户名'),
(49,4,'无效的用户名/密码组合'),
(50,4,'登录页'),
(51,4,'用户名'),
(52,4,'密码'),
(53,4,'请输入一个名字'),
(54,4,'请输入姓氏'),
(55,4,'EMPTY_NOT_USED_TRY_47'),
(56,4,'EMPTY_NOT_USED_TRY_48'),
(57,4,'该用户已经存在'),
(58,4,'帐户创建'),
(59,4,'创建一个新帐户'),
(60,4,'名字'),
(61,4,'姓'),
(62,4,'电子邮件'),
(63,4,'密码'),
(64,4,'创建我的新用户！'),
(65,4,'注销'),
(66,4,'您已成功注销'),
(67,4,'安全问题'),
(68,4,'您的浏览器并没有给我们正确的凭据。'),
(69,4,'感谢您的注册！'),
(70,4,'你是真棒！感谢这么多的进入你的名字！'),
(71,4,'数学'),
(72,4,'物理'),
(73,4,'经济学'),
(74,4,'历史'),
(75,4,'英语'),
(76,4,'开放'),
(77,4,'封闭'),
(78,4,'截取'),
(79,4,'等级'),
(80,4,'用户'),
(81,4,'高级搜索'),
(82,4,'发现字符串无状态'),
(83,4,'无效的日期'),
(84,4,'空NOTUSED'),
(85,4,'没有用户发现字符串'),
(86,4,'开始日期'),
(87,4,'结束日期'),
(88,4,'最小点'),
(89,4,'最高点'),
(90,4,'输入字的说明,搜索'),
(91,4,'输入一个或多个用户名之间用空格分隔'),
(92,4,'输入一个或多个类别用空格分隔'),
(93,4,'页'),
(94,4,'把手青睐'),
(95,4,'确认'),
(96,4,'我的谈话'),
(97,4,'我的资料'),
(98,4,'交易完成'),
(99,4,'飞亚已关闭'),
(100,4,'拥有用户'),
(101,4,'处理用户'),
(102,4,'费沃斯我处理'),
(103,4,'无'),
(104,4,'接受要约'),
(105,4,'我们得到了你的报价,并会展示给用户在短期内,你可以在你的个人资料页面跟踪这一点。'),
(106,4,'新'),
(107,4,'接受'),
(108,4,'拒绝'),
(109,4,'草案'),
(110,4,'有利于出版'),
(111,4,'其他用户现在可以查看您的青睐,并可以提供来处理它。'),
(112,4,'密码修改'),
(113,4,'更改密码'),
(114,4,'你没有输入旧密码和新密码。请再试一次。'),
(115,4,'你提供了一个新的密码,但你需要向我们提供您的旧密码了。'),
(116,4,'你忘了给我们您的新密码。请再试一次。'),
(117,4,'您的新密码太短。请再试一次。'),
(118,4,'你给你的旧密码无效。请再试一次。'),
(119,4,'费沃斯我提供服务'),
(120,4,'信息来服务我的恩惠'),
(121,4,'如果你想提供给服务这个青睐,点击确认按钮下方。'),
(122,4,'我开厚待'),
(123,4,'我的厚待被服务'),
(124,4,'我收厚待'),
(125,4,'我的人情稿'),
(126,4,'取消活动青睐'),
(127,4,'赞成取消'),
(128,4,'您的交易已被取消'),
(129,4,'如果你想取消此活动的青睐,点击下面的确认按钮,这将让您有机会提供一个档次的其他人,也让他们有机会对你的分数。'),
(130,4,'取消'),
(131,4,'你在忙的交易已经取消了对方。看看你的个人资料页上输入该事务的反馈。'),
(132,4,'恭喜！您已被授予服务的忙的权利。检查您的个人资料以获取更多信息。'),
(133,4,'不幸的是,你不接受处理的忙。'),
(134,4,'帮个忙,你正在处理已经完成。'),
(135,4,'帮个忙,你是已经完成的主人。'),
(136,4,'您已取消的活动事务。'),
(137,4,'选择'),
(138,4,'要处理'),
(139,4,'选择处理程序'),
(140,4,'确认您希望以下的用户来处理这个请求。'),
(141,4,'您已选择的处理程序,您的青睐！'),
(142,4,'你现在选择的人来处理您的青睐。该用户将被告知,我们也会通知其他用户(如果有的话),他们没有被选中。'),
(143,4,'照顾'),
(144,4,'遛狗'),
(145,4,'出租车'),
(146,4,'我的系统消息'),
(147,4,'你已经作出的要约来处理一个忙'),
(148,4,'你：收到要约处理的忙。'),
(149,4,'这是否需要回礼的位置？'),
(150,4,'是'),
(151,4,'否'),
(152,4,'街道地址1'),
(153,4,'街道地址2'),
(154,4,'城市'),
(155,4,'国家'),
(156,4,'邮政编码'),
(157,4,'国家'),
(158,4,'选择你保存的位置之一'),
(159,4,'或输入新的地址'),
(160,4,'保存到我的收藏夹'),
(161, 4, 'CHINESEEnter a ranking value between 0.0 and 1.0'),
(162, 4, 'CHINESEEnter a postal code to search'),
(163, 4, 'CHINESEInvalid - must be a number between 0 and 1'),
(164, 4, 'CHINESEInvalid - maximum rank must be greater than minimum rank'),
(165, 4, 'CHINESEYou'),
(166, 4, 'CHINESEincreased'),
(167, 4, 'CHINESEdecreased'),
(168, 4, 'CHINESEthe reputation of'),
(169, 4, 'CHINESEyour reputation'),
(170, 4, 'CHINESEfor the favor'),
(1, 5, 'חיפוש'),
(2, 5, 'בעד בקשה '),
(3, 5, 'התנתקות'),
(4, 5, 'נקודות'),
(5, 5, 'נא להזין תיאור'),
(6, 5, 'פרסם'),
(7, 5, 'לא ניתן לנתח את הנקודות '),
(8, 5, 'אין קטגוריות מצאו במחרוזת'),
(9, 5, 'הוא חייב טובות% d'),
(10, 5, 'תיאור'),
(11, 5, 'נקודות'),
(12, 5, 'חייב, והוא חייב, שום דבר. '),
(13, 5, 'קטגוריות'),
(14, 5, 'EMPTY_NOT_USED'),
(15, 5, 'EMPTY_NOT_USED'),
(16, 5, 'לוח המחוונים'),
(17, 5, 'ברוכים הבאים ללוח המחוונים!'),
(18, 5, 'EMPTY_NOT_USED'),
(19, 5, 'EMPTY_NOT_USED'),
(20, 5, 'ידית'),
(21, 5, 'מחק'),
(22, 5, 'טובי פרטים '),
(23, 5, 'תיאור'),
(24, 5, 'סטטוס'),
(25, 5, 'תאריך'),
(26, 5, 'נקודות'),
(27, 5, 'חייב% d אנשים מעדיף'),
(28, 5, 'קטגוריות'),
(29, 5, 'כן, למחוק! '),
(30, 5, 'Nevermind, אל תמחקו אותו'),
(31, 5, 'בעד נמחק'),
(32, 5, 'בעד'),
(33, 5, 'נמחק'),
(34, 5, 'בעד זה נמחק, הנקודות שלה כבר תוחזר אליך '),
(35, 5, 'לוח מחוונים'),
(36, 5, 'שלח הודעה'),
(37, 5, 'ידית'),
(38, 5, 'הודעה (עד% d תווים)'),
(39, 5, 'האם אתה בטוח שאתה רוצה למחוק את הטובה הזאת?'),
(40, 5, 'נקודות תוחזר אליך '),
(41, 5, 'שגיאה בעת מחיקת טובה '),
(42, 5, 'כניסה'),
(43, 5, 'הירשם'),
(44, 5, 'ברוכים הבאים לXenos!'),
(45, 5, 'בהצלחה מתנתקים '),
(46, 5, 'שגיאה כללית '),
(47, 5, 'יש להזין סיסמא'),
(48, 5, 'יש להזין שם משתמש'),
(49, 5, 'שילוב שם משתמש / סיסמא לא חוקי'),
(50, 5, 'דף כניסה'),
(51, 5, 'שם משתמש'),
(52, 5, 'סיסמא'),
(53, 5, 'נא להזין את השם פרטי '),
(54, 5, 'נא להזין את שם משפחה '),
(55, 5, 'EMPTY_NOT_USED_TRY_47'),
(56, 5, 'EMPTY_NOT_USED_TRY_48'),
(57, 5, 'משתמש זה כבר קיים '),
(58, 5, 'יצירת חשבון'),
(59, 5, 'צור חשבון חדש'),
(60, 5, 'שם פרטי'),
(61, 5, 'משפחה שם '),
(62, 5, 'דוא''ל'),
(63, 5, 'סיסמא'),
(64, 5, 'צור המשתמש החדש שלי! '),
(65, 5, 'יצא מהמערכת '),
(66, 5, 'אתה יצאת בהצלחה '),
(67, 5, 'בעיה ביטחונית'),
(68, 5, 'הדפדפן שלך לא לשלוח לנו את אישורי המתאימים. '),
(69, 5, 'תודה לרישום! '),
(70, 5, 'אתה מדהים! תודה רבה להזנת השם שלך! '),
(71, 5, 'מתמטיקה'),
(72, 5, 'פיסיקה'),
(73, 5, 'כלכלה'),
(74, 5, 'ההיסטוריה'),
(75, 5, 'אנגלית'),
(76, 5, 'פתוח'),
(77, 5, 'סגורים'),
(78, 5, 'לקח'),
(79, 5, 'דירוג'),
(80, 5, 'משתמש'),
(81, 5, 'חיפוש מתקדם'),
(82, 5, 'לא מצאו סטטוסים במחרוזת'),
(83, 5, 'תאריך לא חוקי'),
(84, 5, 'ריק NOTUSED'),
(85, 5, 'לא נמצא משתמשים במחרוזת'),
(86, 5, 'תאריך ההתחלה'),
(87, 5, 'תאריך סיום'),
(88, 5, 'נקודות מינימליות '),
(89, 5, 'נקודות מקסימליים'),
(90, 5, 'הזן מילות לחיפוש בתיאור'),
(91, 5, 'הזן שמות משתמשים אחד או יותר מופרדים על ידי רווחים '),
(92, 5, 'הזן קטגוריה אחת או יותר מופרדת על ידי רווחים '),
(93, 5, 'עמוד'),
(94, 5, 'בעד ידית'),
(95, 5, 'אשר'),
(96, 5, 'השיחות שלי'),
(97, 5, 'הפרופיל שלי'),
(98, 5, 'העסקה הושלמה'),
(99, 5, 'בעד נסגר'),
(100, 5, 'בעלות משתמש '),
(101, 5, 'טיפול במשתמשים'),
(102, 5, 'מצדדים אני מטפל'),
(103, 5, 'ללא'),
(104, 5, 'הצעה שקיבלה '),
(105, 5, 'יש לנו את ההצעה שלך ותציגי אותו למשתמש, כי זמן קצר. אתה יכול לעקוב אחר זה בעמוד הפרופיל שלך. '),
(106, 5, 'חדש'),
(107, 5, 'קיבל'),
(108, 5, 'דחה'),
(109, 5, 'טיוטה'),
(110, 5, 'בעד פרסם'),
(111, 5, 'משתמשים אחרים יכולים כעת להציג לטובתך ועשויות להציע כדי להתמודד עם זה. '),
(112, 5, 'סיסמא השתנתה '),
(113, 5, 'שינוי סיסמא'),
(114, 5, 'אתה נכנס ללא סיסמא ישנה או סיסמא חדשה. נסה שוב. '),
(115, 5, 'אתה מסופק סיסמא חדשה, אבל אתה צריך לתת לנו את הסיסמה שלך ישנה מדי. '),
(116, 5, 'שכחת לתת לנו את הסיסמה החדשה שלך. נסה שוב.'),
(117, 5, 'הסיסמה החדשה שלך היא קצרה מדי. נסו שוב. '),
(118, 5, 'מה שנתת לסיסמא הישנה שלך אינו חוקי. נסו שוב. '),
(119, 5, 'מצדדים אני הצעתי שירות '),
(120, 5, 'מציע שירות טובה שלי '),
(121, 5, 'אם אתה רוצה להציע שירות זה לטובת, לחץ על לחצן אישור להמשך. '),
(122, 5, 'המצדדים הפתוחים שלי'),
(123, 5, 'הטובות שלי מקבלות שירות '),
(124, 5, 'הטובות שלי סגורות '),
(125, 5, 'הטיוטה שלי מצדדים '),
(126, 5, 'ביטול בעד פעיל'),
(127, 5, 'בעד ביטול '),
(128, 5, 'העסקה שלך בוטלה '),
(129, 5, 'אם אתה רוצה לבטל בעד פעיל זה, לחץ על כפתור האישור בהמשך. זה ייתן לך את ההזדמנות לספק כיתה לאדם האחר, כמו גם לתת להם הזדמנות לכיתתך. '),
(130, 5, 'ביטול'),
(131, 5, 'העסקה שלכם בטובה בוטלה על ידי הצד השני. בדקו את דף הפרופיל שלך להיכנס למשוב על עסקה ש. '),
(132, 5, 'מזל טוב! הוענק לך את הזכות לשירות טובה. בדוק את הפרופיל שלך לקבלת מידע נוספת. '),
(133, 5, 'לרוע המזל, לא היית מקובל לטפל בעד.'),
(134, 5, 'טובה שהיית בטיפול הושלם. '),
(135, 5, 'טובה שהיית הבעלים של הושלם. '),
(136, 5, 'אתה ביטלת את עסקה פעילה. '),
(137, 5, 'בחר'),
(138, 5, 'רוצה להתמודד'),
(139, 5, 'בחר מטפל'),
(140, 5, 'ודא שאתה רוצה המשתמש הבא לטפל בבקשה זו.'),
(141, 5, 'בחרת מטפל לטובתך! '),
(142, 5, 'יש לך עכשיו שנבחר מישהו שיטפל בטובתך. על המשתמש להיות מעודכן, ואנחנו גם נודיע למשתמשים האחרים (אם בכלל) שהם לא נבחרו. '),
(143, 5, 'בייביסיטר'),
(144, 5, 'כלב-הליכה '),
(145, 5, 'מוניות'),
(146, 5, 'הודעות המערכת שלי '),
(147, 5, 'אתה עשית את ההצעה לטפל בעד '),
(148, 5, 'יש לך קיבל הצעה לטיפול טובה. '),
(149, 5, 'האם הטובה הזאת צריכה מיקום?'),
(150, 5, 'כן'),
(151, 5, 'לא'),
(152, 5, 'כתובת רחוב 1'),
(153, 5, 'כתובת רחוב 2 '),
(154, 5, 'העיר'),
(155, 5, 'מדינה'),
(156, 5, 'מיקוד'),
(157, 5, 'המדינה'),
(158, 5, 'בחר באחד מהמיקומים השמורים'),
(159, 5, 'או להזין כתובת חדשה'),
(160, 5, 'שמור למועדפים שלי '),
(161, 5, 'HEBREWEnter a ranking value between 0.0 and 1.0'),
(162, 5, 'HEBREWEnter a postal code to search'),
(163, 5, 'HEBREWInvalid - must be a number between 0 and 1'),
(164, 5, 'HEBREWInvalid - maximum rank must be greater than minimum rank'),
(165, 5, 'HEBREWYou'),
(166, 5, 'HEBREWincreased'),
(167, 5, 'HEBREWdecreased'),
(168, 5, 'HEBREWthe reputation of'),
(169, 5, 'HEBREWyour reputation'),
(170, 5, 'HEBREWfor the favor');
