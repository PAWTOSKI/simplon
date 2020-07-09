
-- -----------------------------------------------------
-- Schema ASSUR_AUTO
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ASSUR_AUTO` ;
USE `ASSUR_AUTO` ;

-- -----------------------------------------------------
-- Table `ASSUR_AUTO`.`AGENCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ASSUR_AUTO`.`AGENCE` (
  `AG_ID` INT(11) NOT NULL,
  `AG_adresse` VARCHAR(45) NOT NULL,
  `AG_codepostale` VARCHAR(45) NOT NULL,
  `AG_ville` VARCHAR(45) NOT NULL,
  `AG_coordonnees` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AG_ID`));


-- -----------------------------------------------------
-- Table `ASSUR_AUTO`.`CLIENTS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ASSUR_AUTO`.`CLIENTS` (
  `CL_ID` INT(11) NOT NULL,
  `CL_NOM` VARCHAR(30) NOT NULL,
  `CL_PRENOM` VARCHAR(30) NOT NULL,
  `CL_ADRESSE` VARCHAR(150) NOT NULL,
  `CL_VILLE` VARCHAR(15) NOT NULL,
  `CL_COORDONEES` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`CL_ID`));


-- -----------------------------------------------------
-- Table `ASSUR_AUTO`.`Vehicule_utilitaire`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ASSUR_AUTO`.`Vehicule_utilitaire` (
  `VH_ID` INT(11) NOT NULL,
  `VH_poids` INT(11) NOT NULL,
  `VH_largeur` FLOAT NOT NULL,
  `VH_longueur` FLOAT NOT NULL,
  `VH_poids_charge` INT(11) NOT NULL,
  `VH_marque` VARCHAR(45) NOT NULL,
  `VH_puissance` INT(11) NOT NULL,
  `VH_type` VARCHAR(45) NOT NULL,
  `VH_immatriculation` VARCHAR(20) NOT NULL,
  `VH_carte_grise` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`VH_immatriculation`));


-- -----------------------------------------------------
-- Table `ASSUR_AUTO`.`vehicule_tourisme`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ASSUR_AUTO`.`vehicule_tourisme` (
  `VH_ID` INT(11) NOT NULL,
  `VH_nombre_passager` INT(11) NULL DEFAULT NULL,
  `VH_marque` VARCHAR(15) NULL DEFAULT NULL,
  `VH_puissance` INT(11) NULL DEFAULT NULL,
  `VH_type` VARCHAR(20) NULL DEFAULT NULL,
  `VH_immatriculation` VARCHAR(20) NOT NULL,
  `VH_carte_grise` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`VH_immatriculation`, `VH_carte_grise`));


-- -----------------------------------------------------
-- Table `ASSUR_AUTO`.`CONTRATS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ASSUR_AUTO`.`CONTRATS` (
  `CO_ID_CONTRAT` VARCHAR(45) NOT NULL,
  `CO_DATE` DATE NOT NULL,
  `CO_CATEGORIE` VARCHAR(30) NOT NULL,
  `CO_BONUS_MALUS` FLOAT NOT NULL,
  `CO_CLIENTS_FK` INT(11) NOT NULL,
  `CO_AG_ID_FK` INT(11) NULL DEFAULT NULL,
  `CO_VH_immatriculation_ut_FK` VARCHAR(45) NULL DEFAULT NULL,
  `CO_VH_immatriculation_to_FK` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`CO_ID_CONTRAT`),
  CONSTRAINT `CO_AG_ID_FK`
    FOREIGN KEY (`CO_AG_ID_FK`)
    REFERENCES `ASSUR_AUTO`.`AGENCE` (`AG_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CO_CL_ID_FK`
    FOREIGN KEY (`CO_CLIENTS_FK`)
    REFERENCES `ASSUR_AUTO`.`CLIENTS` (`CL_ID`),
  CONSTRAINT `CO_VH_immatriculation`
    FOREIGN KEY (`CO_VH_immatriculation_ut_FK`)
    REFERENCES `ASSUR_AUTO`.`Vehicule_utilitaire` (`VH_immatriculation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CO_VH_immatriculation_to_FK`
    FOREIGN KEY (`CO_VH_immatriculation_to_FK`)
    REFERENCES `ASSUR_AUTO`.`vehicule_tourisme` (`VH_immatriculation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `ASSUR_AUTO`.`avenant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ASSUR_AUTO`.`avenant` (
  `AV_ID` INT(11) NOT NULL,
  `AV_date` VARCHAR(15) NOT NULL,
  `AV_tarif` FLOAT NOT NULL,
  `AV_bonus_malus` INT(3) NOT NULL,
  `AV_CO_ID_FK` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AV_ID`),
  INDEX `AV_CO_ID_FK_idx` (`AV_CO_ID_FK` ASC),
  CONSTRAINT `AV_CO_ID_FK`
    FOREIGN KEY (`AV_CO_ID_FK`)
    REFERENCES `ASSUR_AUTO`.`CONTRATS` (`CO_ID_CONTRAT`));


-- -----------------------------------------------------
-- Table `ASSUR_AUTO`.`employe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ASSUR_AUTO`.`employe` (
  `EM_ID` INT(11) NOT NULL,
  `EM_employe` VARCHAR(45) NULL DEFAULT NULL,
  `EM_prenom` VARCHAR(45) NULL DEFAULT NULL,
  `EM_nombre` INT(3) NULL DEFAULT NULL,
  `EM_coordonnées` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`EM_ID`),
  CONSTRAINT `fk_employe_1`
    FOREIGN KEY (`EM_ID`)
    REFERENCES `ASSUR_AUTO`.`AGENCE` (`AG_ID`));


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
