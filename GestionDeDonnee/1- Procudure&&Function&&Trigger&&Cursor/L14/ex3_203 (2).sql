-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 27 oct. 2023 à 09:21
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
-- Base de données : `ex3_203`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `Bulletin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Bulletin` (`codes` INT)   BEGIN

DECLARE n varchar(50);
DECLARE p varchar(50);
declare dt date;
/*-variables du crseur*/
declare cm int;
DECLARE nm varchar(50);
declare note float;
DECLARE coef int;
DECLARE nfc float;
/**************************/
declare ligne varchar(100);
declare tout varchar(8000) default '';
DECLARE fincurseur boolean DEFAULT false;

declare snfc float;
declare sc int;
declare moy float;
DECLARE decision varchar(50);
/*Afficher les notes du stagiaire*/


declare c1 CURSOR for
select distinct  m.code_Module,m.Nom_Module, n.note,p.coefficient , n.note * p.coefficient
from notation n,module m,programme p ,stagiaire s, filiere f
where m.code_Module=n.code_Module and m.code_Module=p.code_Module and p.code_filiere=s.code_filiere
and f.code_filiere=p.code_filiere and s.code_Stagiaire=n.code_Stagiaire
and n.code_stagiaire=codes;
DECLARE CONTINUE HANDLER for NOT found set fincurseur:=true;

select s.Nom_Stagiaire,s.Prenom_Stagiaire,s.Datenaissance into n,p,dt
from stagiaire s WHERE s.code_Stagiaire=codes;
set tout='\n**************************************************\n';
set tout=concat(tout,'Nom : ' ,n, '\t \t Prenom : ',p,'\n \t\t\t Date de naissance',dt);
set tout=concat(tout,'\n**************************************************\n');
set snfc=0;
set sc=0;
OPEN c1;
fetch c1 into cm, nm,note, coef,nfc;/*lire la première ligne*/


while(fincurseur=false)DO
 set sc=sc+coef;
 set snfc=snfc+nfc;
    set ligne=concat(cm,'\t',nm,'\t',note,'\t', coef ,'\t', nfc);
    set tout=concat(tout,'\n', ligne);
    fetch  c1 into cm, nm,note, coef,nfc; /*Lire la ligne suivante*/
end while;
set moy=snfc/sc;
if moy<10 THEN
	set decision='Redoublant';
ELSE
	set decision='Reussi, Félicitation';
end if;   
set tout= concat(tout, '\n************************************************\n','Moyenne :   ',moy);
set tout= concat(tout,'\n Décision :    ',decision,'\n************************************************\n');
select tout as '';
close c1;
end$$

DROP PROCEDURE IF EXISTS `Liste`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Liste` ()   BEGIN

/*declarer les variables du premier curseur (stagiaires)*/
DECLARE codes int;
DECLARE n varchar(50);
DECLARE p varchar(50);
declare dt date;
DECLARE f varchar(50);
/*--------------------------------------------------------*/
/*-variables du curseur des notes*/
declare cm int;
DECLARE nm varchar(50);
declare note float;
DECLARE coef int;
DECLARE nfc float;

declare snfc float;
declare sc int;
declare moy float default  0;
DECLARE decision varchar(50) default '';

/*--------------------------------------------------------*/
/**************************/
DECLARE lignest varchar(80);
DECLARE lignenote varchar(80) default '-';
DECLARE tout varchar(8000) default '';
DECLARE finCurseur1 boolean DEFAULT false;


DECLARE c1 CURSOR for select s.code_Stagiaire, s.Nom_Stagiaire,s.Prenom_Stagiaire, s.Datenaissance , f.Nom_Filiere
from stagiaire s, filiere f where f.code_filiere=s.code_filiere;
DECLARE CONTINUE HANDLER for NOT found set finCurseur1:=true;

open c1;
set tout='\n***********************************************\n';
set tout=concat(tout,'****Les notes de tous les stagiaires*********');
set tout=concat(tout,'\n***********************************************\n');
fetch c1 into codes,n,p,dt,f;/*Lire le première ligne du curseur des stagiaires*/
WHILE (finCurseur1=false) do

set tout=concat(tout,'\n***********************************************\n');
set tout=concat(tout,'codest\tNom\t prenom\tdate naiss\t filiere');
set tout=concat(tout,'\n***********************************************\n');

	set lignest=concat(codes,'\t',n,'\t',p,'\t',dt,'\t',f);
    set tout=concat(tout ,'\n', lignest);
    /*------------------------------------------------------------*/
     block2:BEGIN
     	DECLARE finCurseur2 boolean DEFAULT false;
        declare c2 CURSOR for
        select distinct  m.code_Module,m.Nom_Module, n.note,p.coefficient , n.note * p.coefficient
        from notation n,module m,programme p ,stagiaire s, filiere f
        where m.code_Module=n.code_Module and m.code_Module=p.code_Module and p.code_filiere=s.code_filiere
        and f.code_filiere=p.code_filiere and s.code_Stagiaire=n.code_Stagiaire
        and n.code_stagiaire=codes;
        DECLARE CONTINUE HANDLER for NOT found set finCurseur2:=true;
        set tout=concat(tout,'\n-------------------------------------------------\n');
        open c2;
        FETCH c2 into cm,nm,note,coef,nfc;
        set sc=0;
        set snfc=0;
        while (finCurseur2=false) DO 
        	set sc=sc+coef;
            set snfc=snfc+nfc;
        	set lignenote=concat(cm,'\t',nm,'\t',note,'\t',coef,'\t',nfc);
            set tout=concat(tout,'\n',lignenote);
            FETCH c2 into cm,nm,note,coef,nfc;
        end while;
            set tout=concat(tout,'\n-------------------------------------------------\n');
            set moy=snfc/sc;
            if moy<10 THEN
            	set decision='redoublant!!!';
            ELSE
            	set decision='Réussi: Félicitation';
           end if;
           set tout=concat(tout,'\nMoyenne :\t\t',moy,'\n');
           /*set tout=concat(tout,'\nDécision :\t\t',decision,'\n');*/
           set tout=concat(tout,'\n-------------------------------------------------\n');
        close c2;
    end block2;
    /*------------------------------------------------------------*/
    fetch c1 into codes,n,p,dt,f;/*Lire les lignes suivantes du curseur des stagiaires*/
end WHILE;

select tout as '';
close c1;

end$$

DROP PROCEDURE IF EXISTS `Notes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Notes` ()   BEGIN
/* les variabls du curseur des stagiaires*/
DECLARE cs int;
DECLARE ns varchar(20); 
DECLARE ps varchar(20);
DECLARE dt date;
DECLARE nf varchar(20);
/*------------------------*/
/* les variables du code*/
DECLARE ligneSt varchar(60);
DECLARE tout varchar(8000) default '';
/*------------------------*/

DECLARE fincurseur1 boolean DEFAULT false;
DECLARE c1 CURSOR FOR SELECT s.code_Stagiaire,s.Nom_Stagiaire,s.Prenom_Stagiaire,s.Datenaissance,f.Nom_Filiere from stagiaire s, filiere f WHERE s.code_filiere=f.code_filiere;
DECLARE  CONTINUE HANDLER for not found set fincurseur1:=true;
OPEN c1;

set tout= concat(tout,'\n******************************************************\n');
set tout= concat(tout,'codest\tnom\tprenom\tDatenaiss\tFiliere');
set tout= concat(tout,'\n******************************************************\n');
fetch c1 into cs,ns,ps,dt, nf;
while(fincurseur1=false) DO
select 'ok';
set ligneSt=concat(cs,'\t',ns,'\t',ps,'\t',dt, '\t',nf);
set tout= concat(tout,'\n', ligneSt);
fetch c1 into cs,ns,ps,dt, nf;
end while;

SELECT tout as '';
close c1;
end$$

DROP PROCEDURE IF EXISTS `Notes_St`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Notes_St` ()   BEGIN
/*declarer le variables du curseur des stagiaires*/
DECLARE cs int;
DECLARE ns varchar(15);
DECLARE ps varchar(15);
DECLARE dt date;
DECLARE nf varchar(15);
/*************************************************/
/*declarer le variables du curseur des notes*/
DECLARE cm int;
DECLARE coef int;
DECLARE nm varchar(15);
DECLARE note float;
DECLARE nfc float;

/*************************************************/

/*******Les variables du script*/
DECLARE ligneSt varchar(50);
DECLARE tout varchar(8000) default '';
DECLARE ligneNotes varchar(25);
DECLARE moy float;
DECLARE sc int default 0;
declare snfc float DEFAULT 0;
DECLARE decision varchar(30);
/*************************************************/
/*********************Déclarer le curseur des stagiaires*/
DECLARE fincurseur1 boolean DEFAULT false;
DECLARE c1 cursor for select s.code_Stagiaire,s.Nom_Stagiaire,s.Prenom_Stagiaire,s.Datenaissance, f.Nom_Filiere 
from stagiaire s, filiere f where s.code_filiere= f.code_filiere;
DECLARE CONTINUE HANDLER FOR not found set fincurseur1:=true;
/***********************************************************/
set tout=concat(tout,'**************************************************************\n');
set tout=concat(tout, 'codeSt\tnom\tprenom\tdatenaiss\tFiliere');
set tout=concat(tout,'\n**************************************************************\n');
open c1;
FETCH c1 into cs,ns,ps,dt, nf;
while (fincurseur1=false) DO
	set ligneSt=concat(cs,'\t',ns,'\t',ps,'\t',dt, '\t',nf);
    set tout=concat(tout,'\n', ligneSt);
    /*-----------------------------------------------------------------------------*/
    bloc1: BEGIN
    	declare  fincurseur2 boolean DEFAULT false;
    	DECLARE c2 cursor for SELECT m.code_Module,m.Nom_Module, p.Coefficient, n.Note,p.Coefficient * n.Note  from stagiaire s, notation n , module m ,programme 			      p, filiere f where s.code_Stagiaire=n.code_Stagiaire and n.code_Module=m.code_Module and m.code_Module=p.code_Module 
                and p.code_filiere=f.code_filiere and f.code_filiere=s.code_filiere and s.code_Stagiaire=cs;
        DECLARE CONTINUE HANDLER for not found set fincurseur2:=true;
        OPEN c2;
        fetch c2 into cm,nm,coef,note,nfc;
        set tout =concat(tout,'\n----------------------------------------------------------');
        set tout =concat(tout,'\nCodeMod\tModule\tcoeff\tnote\tNote*Coeff');
        set tout =concat(tout,'\n----------------------------------------------------------');
        set sc=0;
        set snfc=0;
        while(fincurseur2=false) DO
        	set sc=sc+coef;
            set snfc=snfc+nfc ;
        	set ligneNotes= concat(cm,'\t',nm,'\t',coef,'\t',note,'\t',nfc);
            set tout =concat(tout,'\n',ligneNotes);
            fetch c2 into cm,nm,coef,note,nfc;
        end while;
        close c2;
  		
        set moy=snfc/sc;
        if moy<10 THEN
        	set decision='Désolé!! redoublant';
        ELSE
        	set decision='Félicitation!! réussi';
       end if;
        set tout =concat(tout,'\n----------------------------------------------------------');
        set tout =concat(tout,'\nMoyenne : ',moy,'\t\tDécision : ',decision);
        set tout =concat(tout,'\n----------------------------------------------------------');
    end bloc1;
    set tout =concat(tout,'\n_______________________________________________________________\n');
    /*-----------------------------------------------------------------------------*/
    FETCH c1 into cs,ns,ps,dt, nf;
end while;

select tout as '';

close c1;
end$$

DROP PROCEDURE IF EXISTS `ps0`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps0` (IN `cf` INT, OUT `Nbrst` INT)   Begin
Select count(*) into Nbrst from stagiaire s where s.code_filiere= cf;
end$$

DROP PROCEDURE IF EXISTS `ps00`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps00` (INOUT `x` INT)   Begin
DECLARE nbr int;
Select count(*) into nbr 
from stagiaire s 
where s.code_filiere= x;
set x=nbr;
end$$

DROP PROCEDURE IF EXISTS `ps000`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps000` (INOUT `x` INT, INOUT `y` VARCHAR(10))   Begin
DECLARE nbr int;
Select count(*) into nbr 
from stagiaire s 
where s.code_filiere= x;
set x=nbr;
set y='www';
end$$

DROP PROCEDURE IF EXISTS `ps1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps1` ()   begin
select s.* from stagiaire s
where s.code_Stagiaire  not in (select code_Stagiaire from notation);

end$$

DROP PROCEDURE IF EXISTS `ps2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps2` ()   begin
select f.Nom_Filiere, count(p.code_Module)
from filiere f , programme p
where f.code_filiere=p.code_filiere
group by f.Nom_Filiere
having count(p.code_Module)>3;

end$$

DROP PROCEDURE IF EXISTS `ps3`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps3` (`s` INT)   begin
select m.Nom_Module,count(p.code_filiere)
from filiere f ,programme p , module m
where f.code_filiere=p.code_filiere and p.code_Module=m.code_Module
and f.code_secteur=s

group by m.Nom_Module
HAVING count(p.code_filiere)= (select count(f.code_filiere)FROM filiere f where f.code_secteur=s);
end$$

DROP PROCEDURE IF EXISTS `ps4`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps4` (`st` INT)   begin
select m.code_Module,m.Nom_Module,n.Note,p.Coefficient, n.Note*p.Coefficient 
from programme p , module m , notation n, stagiaire s
where p.code_Module=m.code_Module   
and n.code_Module =m.code_Module and s.code_Stagiaire=n.code_Stagiaire
and p.code_filiere=s.code_filiere
and s.code_Stagiaire=st;

end$$

DROP PROCEDURE IF EXISTS `ps44`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps44` (`st` INT)   begin
declare m FLoat;
declare rem varchar(20);
select m.code_Module,m.Nom_Module,n.Note,p.Coefficient, n.Note*p.Coefficient 
from programme p , module m , notation n, stagiaire s
where p.code_Module=m.code_Module   
and n.code_Module =m.code_Module and s.code_Stagiaire=n.code_Stagiaire
and p.code_filiere=s.code_filiere
and s.code_Stagiaire=st;

select sum(n.Note*p.Coefficient )/sum(p.Coefficient) into m
from programme p , module m , notation n, stagiaire s
where p.code_Module=m.code_Module   
and n.code_Module =m.code_Module and s.code_Stagiaire=n.code_Stagiaire
and p.code_filiere=s.code_filiere
and s.code_Stagiaire=st;
if m<10 THEN
	set rem='redoublant';
ELSE
	set rem='reussi';
end if;
select concat(m ,'          ',rem) as 'moyenne   Decicion';

end$$

DROP PROCEDURE IF EXISTS `Relevee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Relevee` (`codest` INT)   BEGIN

/*variable du curseur */
declare cm int;
declare nm varchar(40);
declare coef int;
declare note float;
declare sc int default 0;
declare nfc float;
DECLARE snfc float DEFAULT 0;
declare moy float;
declare decision varchar(30) default'';
/*************************/
declare ligne varchar(40);
declare tout varchar(8000) default '';
declare ns varchar(30);
DECLARE ps varchar(20);
DECLARE dt date;
DECLARE nf varchar(20);
/*******************************/
declare fincurseur boolean default false;
declare c1 cursor FOR SELECT m.code_module, m.nom_module,n.Note, p.Coefficient,n.Note* p.Coefficient  from stagiaire s,module m ,notation n ,programme p , filiere f where s.code_stagiaire=n.code_Stagiaire and n.code_Module=m. code_Module and m.code_Module=p.code_Module and f.code_filiere=p.code_filiere and f.code_filiere=s.code_filiere and s.code_Stagiaire=codest;
declare CONTINUE HANDLER for not found set fincurseur:=true;

SELECT s.Nom_Stagiaire , s.Prenom_Stagiaire, s.Datenaissance , f.Nom_Filiere into ns, ps, dt, nf 
FROM stagiaire s, filiere f
where s.code_filiere=f.code_filiere and s.code_Stagiaire=codest;

set tout=concat(tout,'\n************************************************\n');
set tout=concat(tout,'\nNom : ',ns,'\t Prénom : ', ps ,'\n né le : ' , dt , 'Inscrit dans : ', nf);
set tout=concat(tout,'\n************************************************\n');
open c1;
fetch  c1 into cm, nm,  note,coef, nfc;
set tout=concat(tout,'\nCodeMod\tNomMod\tCoeff\tNote\tNote*Coeff\n');
while(fincurseur=false)DO 
	set sc=sc+coef;
    set snfc=snfc+nfc;
 
	set ligne=concat(cm,'\t', nm, '\t',coef, '\t',note, '\t',nfc);
    set tout=concat(tout,'\n',ligne);
	fetch c1 into cm, nm, note,coef,  nfc;
END WHILE;

set moy=snfc/sc;
if moy<10 THEN
	set decision='redoublant';
ELSE
	set decision='Félicitation , Réussi!!!';
end if;
set tout=concat(tout,'\n----------------------------------------------\n');
set tout=concat(tout,'Moyenne : ',moy,'\t\t', 'décision : ', decision);
set tout=concat(tout,'\n----------------------------------------------\n');

select tout as ' ';
close c1;
end$$

DROP PROCEDURE IF EXISTS `w1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `w1` ()   BEGIN

call ps1();

end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `filiere`
--

DROP TABLE IF EXISTS `filiere`;
CREATE TABLE IF NOT EXISTS `filiere` (
  `code_filiere` int NOT NULL,
  `Nom_Filiere` varchar(30) DEFAULT NULL,
  `code_secteur` int DEFAULT NULL,
  PRIMARY KEY (`code_filiere`),
  KEY `code_secteur` (`code_secteur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `filiere`
--

INSERT INTO `filiere` (`code_filiere`, `Nom_Filiere`, `code_secteur`) VALUES
(1, 'Dev info', 1),
(2, 'ID', 1),
(3, 'Gestion', 2),
(4, 'Finance', 2);

-- --------------------------------------------------------

--
-- Structure de la table `module`
--

DROP TABLE IF EXISTS `module`;
CREATE TABLE IF NOT EXISTS `module` (
  `code_Module` int NOT NULL,
  `Nom_Module` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`code_Module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `module`
--

INSERT INTO `module` (`code_Module`, `Nom_Module`) VALUES
(100, 'FR'),
(200, 'POO'),
(300, 'ANG'),
(400, 'JS'),
(500, 'Compta'),
(600, 'PHP'),
(700, 'Gestion des Ese'),
(800, 'Finance'),
(900, 'Mysql');

-- --------------------------------------------------------

--
-- Structure de la table `notation`
--

DROP TABLE IF EXISTS `notation`;
CREATE TABLE IF NOT EXISTS `notation` (
  `code_Stagiaire` int NOT NULL,
  `code_Module` int NOT NULL,
  `Note` float DEFAULT NULL,
  PRIMARY KEY (`code_Stagiaire`,`code_Module`),
  KEY `code_Module` (`code_Module`)
) ;

--
-- Déchargement des données de la table `notation`
--

INSERT INTO `notation` (`code_Stagiaire`, `code_Module`, `Note`) VALUES
(8, 200, 14),
(8, 300, 3),
(8, 900, 10),
(10, 300, 12),
(10, 400, 14),
(10, 600, 16),
(20, 100, 12),
(20, 300, 16),
(30, 500, 12),
(30, 800, 14),
(40, 800, 2),
(50, 200, 2),
(50, 600, 7),
(60, 500, 14);

-- --------------------------------------------------------

--
-- Structure de la table `programme`
--

DROP TABLE IF EXISTS `programme`;
CREATE TABLE IF NOT EXISTS `programme` (
  `code_filiere` int NOT NULL,
  `code_Module` int NOT NULL,
  `Coefficient` int DEFAULT NULL,
  PRIMARY KEY (`code_filiere`,`code_Module`),
  KEY `code_Module` (`code_Module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `programme`
--

INSERT INTO `programme` (`code_filiere`, `code_Module`, `Coefficient`) VALUES
(1, 100, 2),
(1, 200, 3),
(1, 300, 2),
(1, 400, 3),
(1, 600, 4),
(1, 900, 3),
(2, 100, 1),
(2, 300, 1),
(3, 100, 2),
(3, 300, 2),
(3, 500, 5),
(3, 700, 4),
(3, 800, 5),
(4, 100, 1),
(4, 200, 3),
(4, 300, 1),
(4, 400, 3),
(4, 500, 3),
(4, 600, 5);

-- --------------------------------------------------------

--
-- Structure de la table `secteur`
--

DROP TABLE IF EXISTS `secteur`;
CREATE TABLE IF NOT EXISTS `secteur` (
  `code_secteur` int NOT NULL,
  `Nom_secteur` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`code_secteur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `secteur`
--

INSERT INTO `secteur` (`code_secteur`, `Nom_secteur`) VALUES
(1, 'NTIC'),
(2, 'AGC');

-- --------------------------------------------------------

--
-- Structure de la table `stagiaire`
--

DROP TABLE IF EXISTS `stagiaire`;
CREATE TABLE IF NOT EXISTS `stagiaire` (
  `code_Stagiaire` int NOT NULL,
  `Nom_Stagiaire` varchar(30) DEFAULT NULL,
  `Prenom_Stagiaire` varchar(30) DEFAULT NULL,
  `Genre_Stagiaire` char(1) DEFAULT NULL,
  `Datenaissance` date DEFAULT NULL,
  `code_filiere` int DEFAULT NULL,
  PRIMARY KEY (`code_Stagiaire`),
  KEY `code_filiere` (`code_filiere`)
) ;

--
-- Déchargement des données de la table `stagiaire`
--

INSERT INTO `stagiaire` (`code_Stagiaire`, `Nom_Stagiaire`, `Prenom_Stagiaire`, `Genre_Stagiaire`, `Datenaissance`, `code_filiere`) VALUES
(8, 'ww', 'abdo', 'H', '1999-05-05', 1),
(10, 'aaa', 'ali', 'H', '2000-08-08', 1),
(20, 'oo', 'omar', 'H', '2000-03-03', 2),
(30, 'sss', 'samira', 'F', '2000-08-08', 3),
(40, 'M', 'Meryem', 'F', '2000-03-03', 3),
(50, 'Ka', 'Karim', 'H', '2000-03-03', 4),
(60, 'FFF', 'Fatima', 'F', '2000-03-03', 4);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `filiere`
--
ALTER TABLE `filiere`
  ADD CONSTRAINT `filiere_ibfk_1` FOREIGN KEY (`code_secteur`) REFERENCES `secteur` (`code_secteur`);

--
-- Contraintes pour la table `notation`
--
ALTER TABLE `notation`
  ADD CONSTRAINT `notation_ibfk_1` FOREIGN KEY (`code_Stagiaire`) REFERENCES `stagiaire` (`code_Stagiaire`),
  ADD CONSTRAINT `notation_ibfk_2` FOREIGN KEY (`code_Module`) REFERENCES `module` (`code_Module`);

--
-- Contraintes pour la table `programme`
--
ALTER TABLE `programme`
  ADD CONSTRAINT `programme_ibfk_1` FOREIGN KEY (`code_filiere`) REFERENCES `filiere` (`code_filiere`),
  ADD CONSTRAINT `programme_ibfk_2` FOREIGN KEY (`code_Module`) REFERENCES `module` (`code_Module`);

--
-- Contraintes pour la table `stagiaire`
--
ALTER TABLE `stagiaire`
  ADD CONSTRAINT `stagiaire_ibfk_1` FOREIGN KEY (`code_filiere`) REFERENCES `filiere` (`code_filiere`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
