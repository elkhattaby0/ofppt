-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : lun. 30 oct. 2023 à 09:25
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `curseurs00`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `ps_Add_Niv`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_Add_Niv` (`cnic` INT, `nv` VARCHAR(200), `frais` INT)   BEGIN
DECLARE continue HANDLER for 1048 select 'Erreur PK!! l''ajout a été annulé' as 'resultat';
DECLARE continue handler for 1062 select 'Erreur de valeur null' as 'remarque ';
	INSERT INTO niveau  VALUES (cnic, nv, frais);
	SELECT "le niveau a été ajoutée avec succès" as ‘résultat’;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `archive_classe`
--

DROP TABLE IF EXISTS `archive_classe`;
CREATE TABLE IF NOT EXISTS `archive_classe` (
  `code_cl` int NOT NULL,
  `nom_cl` varchar(50) NOT NULL,
  `Effectif` int DEFAULT NULL,
  `COdeniv` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `archive_classe`
--

INSERT INTO `archive_classe` (`code_cl`, `nom_cl`, `Effectif`, `COdeniv`) VALUES
(40, 'dev WFS 201', 25, 1),
(80, 'dev digit 105', 20, 1),
(120, '44', 44, 1),
(120, '44', 44, 1),
(10, 'dev digital 101', 22, 3),
(20, 'dev digital 102', 23, 3),
(22, 'Finnance201', 30, 3),
(30, 'dev digital 103', 25, 3),
(50, 'dev WFS 202', 21, 3),
(77, 'devOWFS202', 24, 3),
(90, 'dev digit 105', 25, 3),
(100, 'dev WFS 203', 200, 3);

-- --------------------------------------------------------

--
-- Structure de la table `archive_stagiaire`
--

DROP TABLE IF EXISTS `archive_stagiaire`;
CREATE TABLE IF NOT EXISTS `archive_stagiaire` (
  `code_St` int NOT NULL,
  `Nom` varchar(50) NOT NULL,
  `prenom` varchar(20) NOT NULL,
  `email` varchar(40) NOT NULL,
  `code_classe` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `archive_stagiaire`
--

INSERT INTO `archive_stagiaire` (`code_St`, `Nom`, `prenom`, `email`, `code_classe`) VALUES
(100, 'elattar', 'abdel', 'abdel@gamil', 40),
(606, '', 'hamid', 'hamid@gmail', 40),
(606, '', 'hamid', 'hamid@gmail', 40),
(606, '', 'hamid', 'hamid@gmail', 40),
(632, '', 'hassan', 'hassan@gmail', 120),
(642, '', 'jamila', 'jamila@gmail', 120),
(642, '', 'jamila', 'jamila@gmail', 120),
(70, 'www', 'walid', 'wal@', 10),
(90, 'yyy', 'yas', 'yas@', 10),
(120, 'KA', 'KARIMA', 'KARIMA@', 10),
(602, '', 'samira', 'samira@gmail', 10),
(612, '', 'amine', 'amine@gmail', 10),
(622, '', 'omar', 'omar@gmail', 10),
(30, 'aaa', 'ali', 'ali@', 20),
(40, 'BBBB', 'Bra', 'bra@', 20),
(130, 'idtaleb', 'OTMANE', 'OTMANE@', 20),
(604, '', 'karim', 'karim@gmail', 20),
(608, '', 'saaad', 'saaad@gmail', 20),
(133, 'OU', 'OUbakass', 'OUbakass@', 22),
(135, 's', 'salim', 'salim@', 22),
(136, 'M', 'maarouf', 'maarouf@', 22),
(80, 'aad', 'adam', 'ada@', 30),
(140, 'ERROUHE\r\n', 'MED', 'ERROUHE\r\n@', 30),
(605, '', 'nourddine', 'nourddine@gmail', 30),
(607, '', 'rachid', 'rachid@gmail', 50),
(609, '', 'amal', 'amal@gmail', 50);

-- --------------------------------------------------------

--
-- Structure de la table `arcive_niveau`
--

DROP TABLE IF EXISTS `arcive_niveau`;
CREATE TABLE IF NOT EXISTS `arcive_niveau` (
  `code_Niveau` int NOT NULL,
  `intitulé` varchar(50) NOT NULL,
  `Frais_inscription` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `arcive_niveau`
--

INSERT INTO `arcive_niveau` (`code_Niveau`, `intitulé`, `Frais_inscription`) VALUES
(1, 'Qualif', 750),
(3, 'technicien spécialisé', 950);

-- --------------------------------------------------------

--
-- Structure de la table `classe`
--

DROP TABLE IF EXISTS `classe`;
CREATE TABLE IF NOT EXISTS `classe` (
  `code_cl` int NOT NULL,
  `nom_cl` varchar(50) NOT NULL,
  `Effectif` int DEFAULT NULL,
  `COde_niveau` int NOT NULL,
  PRIMARY KEY (`code_cl`),
  KEY `COdeniv` (`COde_niveau`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `classe`
--

INSERT INTO `classe` (`code_cl`, `nom_cl`, `Effectif`, `COde_niveau`) VALUES
(8, 'GE101', 20, 2),
(26, 'classe26', 260, 4),
(27, 'dessin', 270, 4),
(28, 'gestion', 28, 1),
(44, 'Froid industriel', 44, 1),
(55, 'electricité', 22, 1),
(70, 'Gestion104', 20, 2),
(300, 'Ele de batiment', 300, 4);

-- --------------------------------------------------------

--
-- Structure de la table `niveau`
--

DROP TABLE IF EXISTS `niveau`;
CREATE TABLE IF NOT EXISTS `niveau` (
  `code_Niveau` int NOT NULL,
  `intitule` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Frais_inscription` float NOT NULL,
  PRIMARY KEY (`code_Niveau`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `niveau`
--

INSERT INTO `niveau` (`code_Niveau`, `intitule`, `Frais_inscription`) VALUES
(1, 'qualification', 550),
(2, 'Technicien', 900),
(4, 'spécialisation', 300),
(10, 'www', 200);

--
-- Déclencheurs `niveau`
--
DROP TRIGGER IF EXISTS `archivage`;
DELIMITER $$
CREATE TRIGGER `archivage` BEFORE DELETE ON `niveau` FOR EACH ROW BEGIN
/*declarer les variables du curseur des classes*/
DECLARE cc int;
DECLARE cniv int;
DECLARE Eff int;
DECLARE nc varchar(15);
/*archiver le niveau*/
/*declarer les variables du curseur des stagiaires*/
DECLARE cs int;
DECLARE ns varchar(15);
DECLARE ps varchar(15);
DECLARE es varchar(15);
DECLARE ccl int;

/*archiver les classes du niveau à supprimer */
DECLARE fincurseur1 boolean DEFAULT false;
DECLARE c1 CURSOR for select * from classe where code_niveau=old.code_niveau;
DECLARE CONTINUE HANDLER for not found set fincurseur1:=true;

/*archiver le niveau*/
INSERT INTO arcive_niveau select old.code_Niveau, old.intitule, old.Frais_inscription;

open c1;
fetch c1 into cc,nc,eff,cniv;
WHILE(fincurseur1 = false) do
	INSERT into archive_classe VALUES(cc,nc,eff,cniv);
    /*---------------------Archuver les stagiaires-----------------*/
     bloc2:begin 
    DECLARE fincurseur2 boolean DEFAULT false;
    DECLARE c2 cursor for select * from stagiaire where code_classe=cc;
    DECLARE CONTINUE HANDLER for not found set fincurseur2:=true;
    
    OPEN c2;
    FETCH c2 into cs,ns, ps,es,ccl;
    WHILE(fincurseur2 =false) DO 
    	 INSERT into archive_stagiaire values(cs,ns, ps,es,ccl);
       
         FETCH c2 into cs,ns, ps,es,ccl;
    end while;
     delete from stagiaire where code_classe=cc;
    close c2;
    end bloc2;
    /*--------------------------------------------------------------*/
	fetch c1 into cc,nc,eff,cniv;
end WHILE;
delete from classe where code_niveau=old.code_niveau;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `stagiaire`
--

DROP TABLE IF EXISTS `stagiaire`;
CREATE TABLE IF NOT EXISTS `stagiaire` (
  `code_St` int NOT NULL,
  `Nom` varchar(50) NOT NULL,
  `prenom` varchar(20) NOT NULL,
  `email` varchar(40) NOT NULL,
  `code_classe` int DEFAULT NULL,
  PRIMARY KEY (`code_St`),
  KEY `code_classe` (`code_classe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `stagiaire`
--

INSERT INTO `stagiaire` (`code_St`, `Nom`, `prenom`, `email`, `code_classe`) VALUES
(60, 'FFF', 'fat', 'fat@', 27),
(150, 'benhammouch', 'nouredine', 'benhammouch@', 300),
(200, 'Merbah', 'abdell', 'abdell@gamil', 28),
(600, '', 'samir', 'samir@gmail', 55),
(603, '', 'med', 'med@gmail', 70),
(652, '', 'jamil', 'jamil@gmail', 26),
(800, 'nou', 'nouhaila', 'nouhaila@', 28),
(900, 'ik', 'ikram', 'ikram@', 300);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `classe`
--
ALTER TABLE `classe`
  ADD CONSTRAINT `classe_ibfk_1` FOREIGN KEY (`COde_niveau`) REFERENCES `niveau` (`code_Niveau`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Contraintes pour la table `stagiaire`
--
ALTER TABLE `stagiaire`
  ADD CONSTRAINT `stagiaire_ibfk_1` FOREIGN KEY (`code_classe`) REFERENCES `classe` (`code_cl`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
