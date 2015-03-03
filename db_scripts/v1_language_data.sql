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
  (171, 1,  'Message'),
  (172, 1,  'Timestamp'),
  (173, 1,  'Their open favors'),
  (174, 1,  'Old password'),
  (175, 1,  'New password'),
  (176, 1,  'Favor Resolution'),
  (177, 1,  'You need to provide feedback on'),
  (178, 1,  'Are you asleep? Wake up!  You have'),
  (179, 1,  'seconds before you are automatically logged out!'),
  (180, 1,  'has not yet determined'),
  (181, 1,  'have not yet determined'),
  (182, 1,  'I am not done!'),
  (183, 1,  'Favor created'),
  (184, 1,  'You have created a favor.  Right now, it is in draft mode, unviewable by other users. You may'),
  (185, 1,  'it now if you wish.  Until you publish, it will remain hidden.  You can also publish this favor from your profile page.'),
  (186, 1,  'Rank user'),
  (187, 1,  'Rank the other user for the following Favor'),
  (188, 1,  'happy'),
  (189, 1,  'unhappy'),
  (190, 1,  'Ranking confirmed'),
  (191, 1,  'Thanks!  By providing a ranking for this user, you make the system a safer place for everyone.'),
  (192, 1,  'no address selected'),
  (1,   2,  'Recherche'),
  (2,   2,  'Demande Favor'),
  (3,   2,  'Déconnexion'),
  (4,   2,  'Points'),
  (5,   2,  'Se il vous plaît entrer une description'),
  (6,   2,  'Publier'),
  (7,   2,  'Impossible d''analyser les points'),
  (8,   2,  'Aucune catégorie trouvés dans la chaîne'),
  (9,   2,  'est dû% d faveurs'),
  (10,  2,  'Description'),
  (11,  2,  'Points'),
  (12,  2,  'le doit, et qui est dû, rien.'),
  (13,  2,  'Catégories'),
  (14,  2,  'Rang minimum'),
  (15,  2,  'Rang maximum'),
  (16,  2,  'Le tableau de bord'),
  (17,  2,  'Bienvenue sur le tableau de bord!'),
  (18,  2,  'EMPTY_NOT_USED'),
  (19,  2,  'EMPTY_NOT_USED'),
  (20,  2,  'Manipuler'),
  (21,  2,  'Effacer'),
  (22,  2,  'Favoriser Détails'),
  (23,  2,  'Description'),
  (24,  2,  'Statut'),
  (25,  2,  'Date'),
  (26,  2,  'Points'),
  (27,  2,  'le doit de personnes% d faveurs'),
  (28,  2,  'Catégories'),
  (29,  2,  'Oui, supprimer!'),
  (30,  2,  'Passons, ne pas le supprimer'),
  (31,  2,  'Faveur a été supprimé'),
  (32,  2,  'Favoriser'),
  (33,  2,  'supprimé'),
  (34,  2,  'Cette faveur a été supprimé, ses points ont été remboursés de vous'),
  (35,  2,  'Tableau de bord'),
  (36,  2,  'Envoyer un message'),
  (37,  2,  'Manipuler'),
  (38,  2,  'Message (jusqu''à% d caractères)'),
  (39,  2,  'Êtes-vous sûr de vouloir supprimer cette faveur?'),
  (40,  2,  'points seront remboursés de vous'),
  (41,  2,  'Erreur suppression faveur'),
  (42,  2,  'S''identifier'),
  (43,  2,  'Se enregistrer'),
  (44,  2,  'Bienvenue à Xenos!'),
  (45,  2,  'Bien déconnecté'),
  (46,  2,  'Erreur générale'),
  (47,  2,  'Se il vous plaît entrer un mot de passe'),
  (48,  2,  'Se il vous plaît entrer un nom d''utilisateur'),
  (49,  2,  'Nom d''utilisateur valide / combinaison de mot de passe'),
  (50,  2,  'Page de connexion'),
  (51,  2,  'Nom d''utilisateur'),
  (52,  2,  'Mot de passe'),
  (53,  2,  'Se il vous plaît, entrez un prénom'),
  (54,  2,  'Se il vous plaît entrer un nom'),
  (55,  2,  'EMPTY_NOT_USED_TRY_47'),
  (56,  2,  'EMPTY_NOT_USED_TRY_48'),
  (57,  2,  'Cet utilisateur existe déjà'),
  (58,  2,  'Création d''un compte'),
  (59,  2,  'Créer un nouveau compte'),
  (60,  2,  'Prénom'),
  (61,  2,  'Nom De Famille'),
  (62,  2,  'Email'),
  (63,  2,  'Mot de passe'),
  (64,  2,  'Créer mon nouvel utilisateur!'),
  (65,  2,  'Déconnecté'),
  (66,  2,  'Vous avez enregistré avec succès'),
  (67,  2,  'Problème de sécurité'),
  (68,  2,  'Votre navigateur ne est pas nous envoyer les informations d''identification appropriées.'),
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
  (84,  2,  'VIDE-NOTUSED'),
  (85,  2,  'Aucun membre trouvé dans la chaîne'),
  (86,  2,  'Date de début'),
  (87,  2,  'Date de fin'),
  (88,  2,  'Points minimum'),
  (89,  2,  'Maximum de points'),
  (90,  2,  'Entrez les mots à rechercher dans une description'),
  (91,  2,  'Saisissez un ou plusieurs noms séparés par des espaces'),
  (92,  2,  'Entrez une ou plusieurs catégories séparées par des espaces'),
  (93,  2,  'Page'),
  (94,  2,  'Poignée faveur'),
  (95,  2,  'Confirmer'),
  (96,  2,  'Mes conversations'),
  (97,  2,  'Mon profil'),
  (98,  2,  'Transaction est terminée'),
  (99,  2,  'Faveur a été fermé'),
  (100, 2,  'Utilisateur propriétaire'),
  (101, 2,  'Manipulation utilisateur'),
  (102, 2,  'Faveurs que je me occupe'),
  (103, 2,  'Aucun'),
  (104, 2,  'Offre reçue'),
  (105, 2,  'Nous avons obtenu votre offre et nous allons montrer à l''utilisateur sous peu. Vous pouvez suivre cela sur votre page de profil.'),
  (106, 2,  'nouveau'),
  (107, 2,  'accepté'),
  (108, 2,  'rejeté'),
  (109, 2,  'ébauche'),
  (110, 2,  'Favoriser publié'),
  (111, 2,  'Les autres utilisateurs peuvent désormais visualiser votre faveur et peuvent offrir à manipuler.'),
  (112, 2,  'Mot de passe modifié'),
  (113, 2,  'Changer le mot de passe'),
  (114, 2,  'Vous avez saisi ne ancien mot de passe ou un nouveau mot de passe. Essayer à nouveau.'),
  (115, 2,  'Vous avez fourni un nouveau mot de passe, mais vous devez nous donner votre ancien mot de passe trop.'),
  (116, 2,  'Vous avez oublié de nous donner votre nouveau mot de passe. Essayer à nouveau.'),
  (117, 2,  'Votre nouveau mot de passe est trop court. Essayer à nouveau.'),
  (118, 2,  'Qu''est-ce que vous avez donné à votre ancien mot de passe ne est pas valide. Essayer à nouveau.'),
  (119, 2,  'Faveurs que je ai offerts au service'),
  (120, 2,  'Offres de réparer mes faveurs'),
  (121, 2,  'Si vous souhaitez offrir au service de cette faveur, cliquez sur le bouton de confirmation ci-dessous.'),
  (122, 2,  'Mes Faveurs ouvertes'),
  (123, 2,  'Mes Faveurs étant desservis'),
  (124, 2,  'Mes Faveurs fermées'),
  (125, 2,  'Mes projets Favors'),
  (126, 2,  'Annuler une Favor actif'),
  (127, 2,  'Favoriser annulée'),
  (128, 2,  'Votre transaction a été annulée'),
  (129, 2,  'Si vous souhaitez annuler cette faveur actif, cliquez sur le bouton de confirmation ci-dessous. Cela vous donnera la chance de fournir une note pour l''autre personne, ainsi que de leur donner une chance de vous grade.'),
  (130, 2,  'Annuler'),
  (131, 2,  'Votre transaction sur une faveur a été annulé par l''autre partie. Découvrez votre page de profil pour entrer les informations sur cette transaction.'),
  (132, 2,  'Félicitations! Vous avez reçu le droit de desservir une faveur. Vérifiez votre profil pour plus d''informations.'),
  (133, 2,  'Malheureusement, vous ne étiez pas accepté de gérer une faveur.'),
  (134, 2,  'Une faveur qui vous manipulez a été achevée.'),
  (135, 2,  'Une faveur dont vous étiez propriétaire du a été achevée.'),
  (136, 2,  'Vous avez annulé une transaction active.'),
  (137, 2,  'Choisir'),
  (138, 2,  'veut gérer'),
  (139, 2,  'Choisissez un gestionnaire'),
  (140, 2,  'Confirmez que vous souhaitez l''utilisateur suivant pour gérer cette demande.'),
  (141, 2,  'Vous avez sélectionné un gestionnaire pour votre faveur!'),
  (142, 2,  'Vous avez maintenant sélectionné quelqu''un pour gérer votre faveur. Cet utilisateur sera informé, et nous informera également les autres utilisateurs (le cas échéant) qu''ils ne ont pas été sélectionnés.'),
  (143, 2,  'Baby-sitting'),
  (144, 2,  'Promener son chien'),
  (145, 2,  'Taxi'),
  (146, 2,  'Mes messages système'),
  (147, 2,  'EMPTY_NOT_USED'),
  (148, 2,  'Vous ai reçu une offre pour gérer une faveur.'),
  (149, 2,  'Est-ce que cette faveur besoin d''un emplacement?'),
  (150, 2,  'Oui'),
  (151, 2,  'Aucun'),
  (152, 2,  'Adresse 1'),
  (153, 2,  'Adresse 2'),
  (154, 2,  'Ville'),
  (155, 2,  'État'),
  (156, 2,  'Code Postal'),
  (157, 2,  'Pays'),
  (158, 2,  'Sélectionnez l''une de vos adresses enregistrées'),
  (159, 2,  'Ou entrer une nouvelle adresse'),
  (160, 2,  'Enregistrer à mes favoris'),
  (161, 2,  'Entrez une valeur de classement entre 0.0 et 1.0'),
  (162, 2,  'Entrez un code postal pour rechercher'),
  (163, 2,  'Invalide - doit être un nombre entre 0 et 1'),
  (164, 2,  'Invalide - maximale rang doit être supérieur rang minimum'),
  (165, 2,  'Vous'),
  (166, 2,  'augmenté'),
  (167, 2,  'diminué'),
  (168, 2,  'la réputation de'),
  (169, 2,  'votre réputation'),
  (170, 2,  'la faveur'),
  (171, 2,  'Message'),
  (172, 2,  'Timestamp'),
  (173, 2,  'Leurs faveurs ouvertes'),
  (174, 2,  'Ancien mot de passe'),
  (175, 2,  'Nouveau mot de passe'),
  (176, 2,  'Faveur Résolution'),
  (177, 2,  'Vous devez fournir une rétroaction sur'),
  (178, 2,  'Tu dors? Réveillez-vous! Vous avez'),
  (179, 2,  'secondes avant sont automatiquement déconnectés!'),
  (180, 2,  'n''a pas encore déterminé'),
  (181, 2,  'ne ont pas encore déterminé'),
  (182, 2,  'Je ne suis pas fait!'),
  (183, 2,  'Favoriser créé'),
  (184, 2,  'Vous avez créé une faveur. À l''heure actuelle, il est en mode brouillon, unviewable par d''autres utilisateurs. Vous pouvez'),
  (185, 2,  'maintenant si vous le souhaitez. Jusqu''à ce que vous publiez, il restera caché. Vous pouvez également publier cette faveur à partir de votre page de profil.'),
  (186, 2,  'utilisateur Rang'),
  (187, 2,  'Classer l''autre utilisateur pour la faveur suivante'),
  (188, 2,  'heureux'),
  (189, 2,  'malheureux'),
  (190, 2,  'Classement confirmé'),
  (191, 2,  'Merci! En fournissant un classement pour cet utilisateur, vous faites du système un endroit plus sûr pour tout le monde.'),
  (192, 2,  'aucune adresse sélectionnée'),
  (1,   3,  'Búsqueda'),
  (2,   3,  'Solicitud Favor'),
  (3,   3,  'Cerrar sesión'),
  (4,   3,  'Puntos'),
  (5,   3,  'Por favor, introduzca una descripción'),
  (6,   3,  'Publicar'),
  (7,   3,  'No se pudo analizar puntos'),
  (8,   3,  'No se han encontrado en cadena categorías'),
  (9,   3,  'se le debe favores% d'),
  (10,  3,  'Descripción'),
  (11,  3,  'Puntos'),
  (12,  3,  'le debe, y que se debe, nada.'),
  (13,  3,  'Categorías'),
  (14,  3,  'Rango mínimo'),
  (15,  3,  'Rango máximo'),
  (16,  3,  'El tablero de instrumentos'),
  (17,  3,  'Bienvenido a el tablero!'),
  (18,  3,  'EMPTY_NOT_USED'),
  (19,  3,  'EMPTY_NOT_USED'),
  (20,  3,  'Manejar'),
  (21,  3,  'Borrar'),
  (22,  3,  'Favorecer Detalles'),
  (23,  3,  'Descripción'),
  (24,  3,  'Estado'),
  (25,  3,  'Fecha'),
  (26,  3,  'Puntos'),
  (27,  3,  'le debe la gente% d favores'),
  (28,  3,  'Categorías'),
  (29,  3,  'Sí, borrar!'),
  (30,  3,  'No importa, no lo elimine'),
  (31,  3,  'Favor ha sido borrado'),
  (32,  3,  'Favorecer'),
  (33,  3,  'eliminado'),
  (34,  3,  'Este favor se ha eliminado, sus puntos se han devuelto a usted'),
  (35,  3,  'Salpicadero'),
  (36,  3,  'Enviar mensaje'),
  (37,  3,  'Manejar'),
  (38,  3,  'Mensaje (hasta% d caracteres)'),
  (39,  3,  '¿Seguro que quieres borrar este favor?'),
  (40,  3,  'puntos serán reembolsados ​​a usted'),
  (41,  3,  'Error borrado favor'),
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
  (55,  3,  'EMPTY_NOT_USED_TRY_47'),
  (56,  3,  'EMPTY_NOT_USED_TRY_48'),
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
  (84,  3,  'VACÍO-NOTUSED'),
  (85,  3,  'No se han encontrado en cadena usuarios'),
  (86,  3,  'Fecha de inicio'),
  (87,  3,  'Fecha de finalización'),
  (88,  3,  'Puntos mínimos'),
  (89,  3,  'El máximo de puntos'),
  (90,  3,  'Introduzca las palabras a buscar en una descripción'),
  (91,  3,  'Ingrese uno o más nombres de usuario separados por espacios'),
  (92,  3,  'Introduce una o más categorías separadas por espacios'),
  (93,  3,  'Página'),
  (94,  3,  'Favor Mango'),
  (95,  3,  'Confirmar'),
  (96,  3,  'Mis conversaciones'),
  (97,  3,  'Mi perfil'),
  (98,  3,  'Transacción se complete'),
  (99,  3,  'Favor se ha cerrado'),
  (100, 3,  'Usuario propietario'),
  (101, 3,  'Usuario Manipulación'),
  (102, 3,  'Favores que estoy manejando'),
  (103, 3,  'Ninguno'),
  (104, 3,  'Oferta recibido'),
  (105, 3,  'Conseguimos su oferta y te lo enseñamos ese usuario en breve. Usted puede seguir esto en su página de perfil.'),
  (106, 3,  'nuevo'),
  (107, 3,  'aceptado'),
  (108, 3,  'rechazado'),
  (109, 3,  'borrador'),
  (110, 3,  'Favorecer publicado'),
  (111, 3,  'Otros usuarios pueden ahora ver su favor y pueden ofrecer para manejarlo.'),
  (112, 3,  'Contraseña cambiada'),
  (113, 3,  'Cambiar la contraseña'),
  (114, 3,  'Ha introducido ninguna contraseña antigua o nueva contraseña. Inténtalo de nuevo.'),
  (115, 3,  'Que ya ha proporcionado una nueva contraseña, pero hay que darnos tu contraseña antigua también.'),
  (116, 3,  'Se le olvidó a darnos su nueva contraseña. Inténtalo de nuevo.'),
  (117, 3,  'Su nueva contraseña es demasiado corta. Inténtalo de nuevo.'),
  (118, 3,  'Lo que usted le dio a su antigua contraseña no es válida. Inténtalo de nuevo.'),
  (119, 3,  'Los favores que he ofrecido al servicio'),
  (120, 3,  'Ofertas para dar servicio a mis favores'),
  (121, 3,  'Si a usted le gustaría ofrecer reparar este favor, haga clic en el botón de confirmación a continuación.'),
  (122, 3,  'Mis favores abiertas'),
  (123, 3,  'Mis favores siendo atendidos'),
  (124, 3,  'Mis favores cerradas'),
  (125, 3,  'Mis proyectos Favores'),
  (126, 3,  'Cancelar un favor activa'),
  (127, 3,  'Favorecer cancelado'),
  (128, 3,  'La transacción ha sido cancelada'),
  (129, 3,  'Si desea cancelar este favor activa, haga clic en el botón de confirmación a continuación. Esto le dará la oportunidad de proporcionar un grado de la otra persona, así como darles la oportunidad de que grado.'),
  (130, 3,  'Cancelar'),
  (131, 3,  'Su transacción en un favor ha sido cancelado por la otra parte. Echa un vistazo a su página de perfil para entrar en comentarios sobre la transacción.'),
  (132, 3,  '¡Enhorabuena! Se le ha concedido el derecho de administración a Favor. Revise su perfil para más información.'),
  (133, 3,  'Por desgracia, no fue aceptado para manejar un favor.'),
  (134, 3,  'A Favor que usted estaba manejando se ha completado.'),
  (135, 3,  'A Favor que usted era propietario de que se ha completado.'),
  (136, 3,  'Ha cancelado una transacción activa.'),
  (137, 3,  'Elegir'),
  (138, 3,  'quiere manejar'),
  (139, 3,  'Elige un controlador'),
  (140, 3,  'Confirme que desea que el siguiente usuario para manejar esta petición.'),
  (141, 3,  'Ha seleccionado un controlador para su favor!'),
  (142, 3,  'Ahora ha elegido a alguien para manejar a su favor. Ese usuario será informado, y también informará a los otros usuarios (si los hay) que no han sido seleccionados.'),
  (143, 3,  'Niñera'),
  (144, 3,  'Paseador de perros'),
  (145, 3,  'Taxi'),
  (146, 3,  'Mis mensajes del sistema'),
  (147, 3,  'EMPTY_NOT_USED'),
  (148, 3,  'Usted ha recibido una oferta para manejar un favor.'),
  (149, 3,  '¿Es necesario que este favor una ubicación?'),
  (150, 3,  'Sí'),
  (151, 3,  'No'),
  (152, 3,  'Dirección Calle 1'),
  (153, 3,  'Dirección Calle 2'),
  (154, 3,  'Ciudad'),
  (155, 3,  'Estado'),
  (156, 3,  'Código Postal'),
  (157, 3,  'País'),
  (158, 3,  'Seleccione una de las ubicaciones guardadas'),
  (159, 3,  'O introducir una nueva dirección'),
  (160, 3,  'Guardar en mis favoritos'),
  (161, 3,  'Introduzca un valor de clasificación entre 0.0 y 1.0'),
  (162, 3,  'Introduzca un código postal para buscar'),
  (163, 3,  'No válida - debe ser un número entre 0 y 1'),
  (164, 3,  'Inválido - rango máximo debe ser mayor que el rango mínimo'),
  (165, 3,  'Usted'),
  (166, 3,  'aumentado'),
  (167, 3,  'disminución'),
  (168, 3,  'la reputación de'),
  (169, 3,  'su reputación'),
  (170, 3,  'por el favor'),
  (171, 3,  'Mensaje'),
  (172, 3,  'Marca de tiempo'),
  (173, 3,  'Sus favores abiertas'),
  (174, 3,  'Contraseña anterior'),
  (175, 3,  'Nueva contraseña'),
  (176, 3,  'Resolución favor'),
  (177, 3,  'Es necesario proporcionar información sobre'),
  (178, 3,  '¿Estás durmiendo? Despertarse! Tienes'),
  (179, 3,  'segundos antes de que se registran de forma automática!'),
  (180, 3,  'No se ha determinado aún'),
  (181, 3,  'no han determinado todavía'),
  (182, 3,  'No he terminado!'),
  (183, 3,  'Favorecer creado'),
  (184, 3,  'Ha creado un favor. En este momento, está en modo borrador, unviewable por otros usuarios. Puedes'),
  (185, 3,  'ahora si lo desea. Hasta que publique, permanecerá oculto. También puede publicar este favor de su página de perfil.'),
  (186, 3,  'Rango usuario'),
  (187, 3,  'Clasifique el otro usuario para la siguiente Favor'),
  (188, 3,  'feliz'),
  (189, 3,  'infeliz'),
  (190, 3,  'La clasificación se confirmó'),
  (191, 3,  'Gracias! Al proporcionar un ranking para este usuario, usted hace el sistema de un lugar más seguro para todos.'),
  (192, 3,  'sin dirección seleccionada'),
  (1,   4,  '搜索'),
  (2,   4,  '请求青睐'),
  (3,   4,  '注销'),
  (4,   4,  '点'),
  (5,   4,  '请输入描述'),
  (6,   4,  '发布'),
  (7,   4,  '无法解析点'),
  (8,   4,  '没有在字符串中找到的类别'),
  (9,   4,  '欠％D青睐'),
  (10,  4,  '描述'),
  (11,  4,  '点'),
  (12,  4,  '欠和欠，什么都没有。'),
  (13,  4,  '分类'),
  (14,  4,  '最低排名'),
  (15,  4,  '最高排名'),
  (16,  4,  '仪表板'),
  (17,  4,  '欢迎到仪表板！'),
  (18,  4,  'EMPTY_NOT_USED'),
  (19,  4,  'EMPTY_NOT_USED'),
  (20,  4,  '处理'),
  (21,  4,  '删除'),
  (22,  4,  '详细青睐'),
  (23,  4,  '描述'),
  (24,  4,  '状态'),
  (25,  4,  '日期'),
  (26,  4,  '点'),
  (27,  4,  '欠人％D青睐'),
  (28,  4,  '分类'),
  (29,  4,  '是的，删除！'),
  (30,  4,  '没关系，请不要删除它'),
  (31,  4,  '利于已经被删除'),
  (32,  4,  '偏爱'),
  (33,  4,  '删除'),
  (34,  4,  '这有利于已被删除，其点已退还给你'),
  (35,  4,  '仪表盘'),
  (36,  4,  '发送信息'),
  (37,  4,  '处理'),
  (38,  4,  '消息（最多％d个字符）'),
  (39,  4,  '你确定你要删除这个忙吗？'),
  (40,  4,  '积分将被退还给你'),
  (41,  4,  '错误删除青睐'),
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
  (55,  4,  'EMPTY_NOT_USED_TRY_47'),
  (56,  4,  'EMPTY_NOT_USED_TRY_48'),
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
  (68,  4,  '您的浏览器并没有给我们正确的凭据。'),
  (69,  4,  '感谢您的注册！'),
  (70,  4,  '你真棒！感谢这么多的进入你的名字！'),
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
  (84,  4,  '空NOTUSED'),
  (85,  4,  '没有在字符串中找到用户'),
  (86,  4,  '开始日期'),
  (87,  4,  '结束日期'),
  (88,  4,  '最低点'),
  (89,  4,  '最高点'),
  (90,  4,  '输入文字的描述来搜索'),
  (91,  4,  '输入用空格分隔的一个或多个用户名'),
  (92,  4,  '输入用空格分隔的一个或多个类别'),
  (93,  4,  '页面'),
  (94,  4,  '手柄青睐'),
  (95,  4,  '确认'),
  (96,  4,  '我的谈话'),
  (97,  4,  '我的个人资料'),
  (98,  4,  '交易完成'),
  (99,  4,  '青睐已关闭'),
  (100, 4,  '拥有用户'),
  (101, 4,  '处理用户'),
  (102, 4,  '有利于我处理'),
  (103, 4,  '无'),
  (104, 4,  '收到报价'),
  (105, 4,  '我们得到了你的报价，这在短期内会显示给该用户。您可以在您的个人资料页面跟踪此。'),
  (106, 4,  '新'),
  (107, 4,  '公认'),
  (108, 4,  '拒绝'),
  (109, 4,  '草案'),
  (110, 4,  '发表青睐'),
  (111, 4,  '其他用户现在可以查看您的青睐，并可以提供来处理它。'),
  (112, 4,  '密码修改'),
  (113, 4,  '更改密码'),
  (114, 4,  '你没有输入旧密码和新密码。再试一次。'),
  (115, 4,  '你提供了一个新的密码，但你需要向我们提供您的旧密码了。'),
  (116, 4,  '你忘了给我们您的新密码。再试一次。'),
  (117, 4,  '您的新密码太短。再试一次。'),
  (118, 4,  '你给你的旧密码是无效的。再试一次。'),
  (119, 4,  '费沃斯我提供服务'),
  (120, 4,  '提供以服务我的恩惠'),
  (121, 4,  '如果您想提供给服务这个忙，请点击下面的确认按钮。'),
  (122, 4,  '我开费沃斯'),
  (123, 4,  '我的厚待被服务'),
  (124, 4,  '我关闭费沃斯'),
  (125, 4,  '我的厚待草案'),
  (126, 4,  '取消活动飞亚'),
  (127, 4,  '赞成取消'),
  (128, 4,  '您的交易已被取消'),
  (129, 4,  '如果你想取消这个活动的青睐，点击下面的确认键。这将让您有机会提供一个档次的其他人，并且给他们一个机会给你品位。'),
  (130, 4,  '取消'),
  (131, 4,  '你在一个人情交易已取消了对方。检查你的个人资料页上输入该事务的反馈。'),
  (132, 4,  '恭喜！您已经被授予服务的忙的权利。请检查您的个人资料以获取更多信息。'),
  (133, 4,  '不幸的是，你不接受处理的忙。'),
  (134, 4,  '一个忙，你正在处理已经完成。'),
  (135, 4,  '一个忙，你都已经完成老板。'),
  (136, 4,  '您已取消的活动事务。'),
  (137, 4,  '选择'),
  (138, 4,  '想处理'),
  (139, 4,  '选择一个处理程序'),
  (140, 4,  '请确认您想以下的用户来处理这个请求。'),
  (141, 4,  '您选择的处理程序，您的青睐！'),
  (142, 4,  '现在，您已经选择了专人处理您的青睐。该用户将被告知，并且我们也将通知其他用户（如果有的话），他们没有被选中。'),
  (143, 4,  '保姆'),
  (144, 4,  '遛狗'),
  (145, 4,  '出租车'),
  (146, 4,  '我的系统消息'),
  (147, 4,  'EMPTY_NOT_USED'),
  (148, 4,  '你有：收到要约处理青睐。'),
  (149, 4,  '这是否需要回礼的位置？'),
  (150, 4,  '是的'),
  (151, 4,  '没有'),
  (152, 4,  '街道地址1'),
  (153, 4,  '街道地址2'),
  (154, 4,  '城市'),
  (155, 4,  '状态'),
  (156, 4,  '邮政编码'),
  (157, 4,  '国家'),
  (158, 4,  '选择您保存的位置之一'),
  (159, 4,  '或输入一个新的地址'),
  (160, 4,  '保存到我的收藏夹'),
  (161, 4,  '0.0和1.0之间输入一个值排名'),
  (162, 4,  '输入一个邮政编码搜索'),
  (163, 4,  '无效 - 必须是数字0和1之间'),
  (164, 4,  '无效的 - 最高等级必须大于最低排名'),
  (165, 4,  '你'),
  (166, 4,  '增加'),
  (167, 4,  '下降'),
  (168, 4,  '声誉'),
  (169, 4,  '你的声誉'),
  (170, 4,  '对于青睐'),
  (171, 4,  '信息'),
  (172, 4,  '时间戳'),
  (173, 4,  '他们主张开放'),
  (174, 4,  '旧密码'),
  (175, 4,  '新密码'),
  (176, 4,  '有利于解决'),
  (177, 4,  '您需要提供反馈'),
  (178, 4,  '你睡着了吗？醒来！你有'),
  (179, 4,  '秒钟，然后被自动注销！'),
  (180, 4,  '尚未确定'),
  (181, 4,  '尚未确定'),
  (182, 4,  '我没有做过！'),
  (183, 4,  '创建青睐'),
  (184, 4,  '你已经创建了一个忙。现在，它在草稿模式下，无法观看其他用户。您可以'),
  (185, 4,  '现在，如果你想。直到您发布，它将保持隐藏。您也可以从您的个人资料页面发布此青睐。'),
  (186, 4,  '用户排名'),
  (187, 4,  '排名其它用户的青睐如下'),
  (188, 4,  '高兴'),
  (189, 4,  '不快乐'),
  (190, 4,  '排名确定'),
  (191, 4,  '谢谢！通过提供该用户的排名，你让系统给大家一个更安全的地方。'),
  (192, 4,  '没有选择的地址'),
  (1,   5,  'חיפוש'),
  (2,   5,  'בעד בקשה'),
  (3,   5,  'התנתקות'),
  (4,   5,  'נקודות'),
  (5,   5,  'נא להזין תיאור'),
  (6,   5,  'לפרסם'),
  (7,   5,  'אין אפשרות לנתח את הנקודות'),
  (8,   5,  'אין קטגוריות מצאו במחרוזת'),
  (9,   5,  'הוא חייב טובות% d'),
  (10,  5,  'תיאור'),
  (11,  5,  'נקודות'),
  (12,  5,  'חייב, והוא חייב, שום דבר.'),
  (13,  5,  'קטגוריות'),
  (14,  5,  'דירוג מינימאלי'),
  (15,  5,  'דירוג מרבי'),
  (16,  5,  'לוח המחוונים'),
  (17,  5,  'ברוכים הבאים ללוח המחוונים!'),
  (18,  5,  'EMPTY_NOT_USED'),
  (19,  5,  'EMPTY_NOT_USED'),
  (20,  5,  'ידית'),
  (21,  5,  'מחק'),
  (22,  5,  'להעדיף פרטים'),
  (23,  5,  'תיאור'),
  (24,  5,  'סטטוס'),
  (25,  5,  'תאריך'),
  (26,  5,  'נקודות'),
  (27,  5,  'חייב טובות% d אנשים'),
  (28,  5,  'קטגוריות'),
  (29,  5,  'כן, למחוק!'),
  (30,  5,  'Nevermind, אל תמחק אותו'),
  (31,  5,  'טובה נמחקה'),
  (32,  5,  'להעדיף'),
  (33,  5,  'נמחק'),
  (34,  5,  'בעד זה נמחק, הנקודות שלה כבר תוחזר אליך'),
  (35,  5,  'לוח מחוונים'),
  (36,  5,  'שלח הודעה'),
  (37,  5,  'ידית'),
  (38,  5,  'הודעה (עד תווי% d)'),
  (39,  5,  'האם אתה בטוח שאתה רוצה למחוק את הטובה הזאת?'),
  (40,  5,  'נקודות תוחזר אליך'),
  (41,  5,  'בעד מחיקת שגיאה'),
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
  (55,  5,  'EMPTY_NOT_USED_TRY_47'),
  (56,  5,  'EMPTY_NOT_USED_TRY_48'),
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
  (84,  5,  'ריק NOTUSED'),
  (85,  5,  'לא נמצאו משתמשים במחרוזת'),
  (86,  5,  'תאריך ההתחלה'),
  (87,  5,  'תאריך סיום'),
  (88,  5,  'נקודות מינימום'),
  (89,  5,  'נקודות המרביות'),
  (90,  5,  'הזן את מילות חיפוש בתיאור'),
  (91,  5,  'הזן שמות משתמשים אחד או יותר מופרדים על ידי רווחים'),
  (92,  5,  'הזן קטגוריה אחת או יותר מופרדת על ידי רווחים'),
  (93,  5,  'דף'),
  (94,  5,  'לטובת ידית'),
  (95,  5,  'אשר'),
  (96,  5,  'השיחות שלי'),
  (97,  5,  'הפרופיל שלי'),
  (98,  5,  'העסקה הושלמה'),
  (99,  5,  'טובה נסגרה'),
  (100, 5,  'משתמשים בעלות'),
  (101, 5,  'משתמשים טיפול'),
  (102, 5,  'אני מעדיף טיפול ב'),
  (103, 5,  'אף אחד'),
  (104, 5,  'הצעה שקיבלה'),
  (105, 5,  'יש לנו ההצעה שלך ויציגו אותו למשתמש, כי זמן קצר. אתה יכול לעקוב אחר זה בעמוד הפרופיל שלך.'),
  (106, 5,  'חדש'),
  (107, 5,  'מקובל'),
  (108, 5,  'נדחה'),
  (109, 5,  'טיוטה'),
  (110, 5,  'מעדיף שפורסם'),
  (111, 5,  'משתמשים אחרים יכולים כעת להציג לטובתך ועשויות להציע כדי להתמודד עם זה.'),
  (112, 5,  'סיסמא השתנתה'),
  (113, 5,  'שינוי סיסמא'),
  (114, 5,  'אתה נכנס ללא סיסמא ישנה או סיסמא חדשה. נסה שוב.'),
  (115, 5,  'שסיפקת סיסמא חדשה, אבל אתה צריך לתת לנו את הסיסמה שלך ישנה מדי.'),
  (116, 5,  'שכחת לתת לנו את הסיסמה החדשה שלך. נסה שוב.'),
  (117, 5,  'הסיסמה החדשה שלך היא קצרה מדי. נסה שוב.'),
  (118, 5,  'מה שנתת לסיסמא הישנה שלך אינו חוקי. נסה שוב.'),
  (119, 5,  'טובות הנאה שהוצעתי לשירות'),
  (120, 5,  'מציע שירות טובה שלי'),
  (121, 5,  'אם אתה רוצה להציע שירות זה לטובת, לחץ על לחצן אישור להמשך.'),
  (122, 5,  'המצדדים הפתוחים שלי'),
  (123, 5,  'מצדדיי זמן הטיפול'),
  (124, 5,  'המצדדים סגורים שלי'),
  (125, 5,  'מצדדי הטיוטה שלי'),
  (126, 5,  'לבטל בעד פעיל'),
  (127, 5,  'להעדיף בוטל'),
  (128, 5,  'העסקה שלך בוטלה'),
  (129, 5,  'אם ברצונכם לבטל בעד פעיל זה, לחץ על כפתור האישור בהמשך. זה ייתן לך את ההזדמנות לספק כיתה לאדם האחר, כמו גם לתת להם הזדמנות לכיתתך.'),
  (130, 5,  'לבטל'),
  (131, 5,  'העסקה שלך על טובה בוטלה על ידי הצד השני. בדקו את דף הפרופיל שלך להיכנס למשוב על עסקה ש.'),
  (132, 5,  'מזל טוב! הוענק לך את הזכות לשירות טובה. בדוק את הפרופיל שלך לקבלת מידע נוספת.'),
  (133, 5,  'לרוע המזל, לא היית מקובל לטפל בעד.'),
  (134, 5,  'טובה שהיית בטיפול הושלם.'),
  (135, 5,  'טובה שהיית הבעלים של הושלם.'),
  (136, 5,  'שבטלת את עסקה פעילה.'),
  (137, 5,  'בחר'),
  (138, 5,  'רוצה להתמודד'),
  (139, 5,  'בחר מטפל'),
  (140, 5,  'ודא שאתה רוצה המשתמש הבא לטפל בבקשה זו.'),
  (141, 5,  'בחרת מטפל לטובתך!'),
  (142, 5,  'עכשיו שבחרת מישהו שיטפל בטובתך. המשתמש שיקבל הודעה, ואנחנו גם נודיע למשתמשים האחרים (אם בכלל) שהם לא נבחרו.'),
  (143, 5,  'שמרטפות'),
  (144, 5,  'כלב לטיול'),
  (145, 5,  'מונית'),
  (146, 5,  'הודעות המערכת שלי'),
  (147, 5,  'EMPTY_NOT_USED'),
  (148, 5,  'יש לך קיבל הצעה לטיפול טובה.'),
  (149, 5,  'האם זה לטובה צריכה מיקום?'),
  (150, 5,  'כן'),
  (151, 5,  'לא'),
  (152, 5,  'כתובת רחוב 1'),
  (153, 5,  'כתובת רחוב 2'),
  (154, 5,  'עיר'),
  (155, 5,  'מדינה'),
  (156, 5,  'מיקוד'),
  (157, 5,  'מדינה'),
  (158, 5,  'בחר באחד מהמיקומים השמורים'),
  (159, 5,  'או להיכנס לכתובת חדשה'),
  (160, 5,  'שמור למועדפים שלי'),
  (161, 5,  'הזן ערך דירוג בין 0.0 ו 1.0'),
  (162, 5,  'הזן מיקוד לחיפוש'),
  (163, 5,  'לא תקף - חייב להיות מספר בין 0 ל -1'),
  (164, 5,  'לא תקף - דרגה המרבית חייבת להיות גדולה מ דרגה מינימאלית'),
  (165, 5,  'אתם'),
  (166, 5,  'גדל'),
  (167, 5,  'ירידה'),
  (168, 5,  'המוניטין של'),
  (169, 5,  'המוניטין שלך'),
  (170, 5,  'לטובה'),
  (171, 5,  'הודעה'),
  (172, 5,  'חותם זמן'),
  (173, 5,  'טובות הפתוחות'),
  (174, 5,  'סיסמא הישנה'),
  (175, 5,  'סיסמא חדשה'),
  (176, 5,  'החלטה לטובת'),
  (177, 5,  'אתה צריך לספק משוב על'),
  (178, 5,  'האם אתה ישן? תתעורר! יש לך'),
  (179, 5,  'שניות לפני שאתה מחובר באופן אוטומטי!'),
  (180, 5,  'עדיין לא נקבע'),
  (181, 5,  'עדיין לא נקבע'),
  (182, 5,  'אני לא עשיתי!'),
  (183, 5,  'מעדיף שנוצר'),
  (184, 5,  'שיצרת לטובת. נכון לעכשיו, הוא נמצא במצב טיוטה, unviewable על ידי משתמשים אחרים. אתה יכול'),
  (185, 5,  'זה עכשיו, אם ירצה. עד שתפרסם, הוא יישאר נסתר. אתה יכול גם לפרסם את הטובה הזאת מדף הפרופיל שלך.'),
  (186, 5,  'משתמשים דרגה'),
  (187, 5,  'דרג את המשתמש האחר לטובה הבאה'),
  (188, 5,  'מאושר'),
  (189, 5,  'אומלל'),
  (190, 5,  'דירוג אישר'),
  (191, 5,  'תודה! על ידי מתן דירוג עבור משתמש זה, אתה להפוך את המערכת למקום בטוח יותר עבור כולם.'),
  (192, 5,  'אין כתובת שנבחרה');
