/*DROP DATABASE db_ligue_wilaya;*/
CREATE DATABASE db_ligue_wilaya;
CREATE TABLE Stade(
    id INTEGER PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);
CREATE TABLE Equipe(
    id VARCHAR(100) PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    couleurs VARCHAR(100),
    idStade INTEGER,
    FOREIGN KEY (idStade) REFERENCES Stade(id)
);
CREATE TABLE Joueur(
    id INTEGER,
    idEquipe VARCHAR(100),
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    categorie VARCHAR(100),
    dateNaissance DATE,
    lieuNaissance VARCHAR(100),
    PRIMARY KEY (id,idEquipe),
    FOREIGN KEY (idEquipe) REFERENCES Equipe(id)
);
CREATE TABLE Dirigeant(
    id INTEGER,
    idEquipe VARCHAR(100),
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    fonction VARCHAR(100),
    dateNaissance DATE,
    lieuNaissance VARCHAR(100),
    PRIMARY KEY (id,idEquipe),
    FOREIGN KEY (idEquipe) REFERENCES Equipe(id)
);
CREATE TABLE MembreStaff(
    id INTEGER,
    idEquipe VARCHAR(100),
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    fonction VARCHAR(100) NOT NULL,
    dateNaissance DATE,
    lieuNaissance VARCHAR(100),
    PRIMARY KEY (id,idEquipe),
    FOREIGN KEY (idEquipe) REFERENCES Equipe(id)
);
CREATE TABLE Arbitre(
    id INTEGER PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    dateNaissance DATE,
    lieuNaissance VARCHAR(100)
);
CREATE TABLE Saison(
    id VARCHAR(100) PRIMARY KEY,
    dateDebut DATE NOT NULL,
    dateFin DATE NOT NULL
);
CREATE TABLE Matche(
    id INTEGER PRIMARY KEY,
    idEquipe1 VARCHAR(100) NOT NULL,
    idEquipe2 VARCHAR(100) NOT NULL,
    butEquipe1 INTEGER NOT NULL,
    butEquipe2 INTEGER NOT NULL,
    idStade INTEGER NOT NULL,
    idArbitre INTEGER NOT NULL,
    date DATE NOT NULL,
    idSaison VARCHAR(100) NOT NULL,
    numJournee INTEGER NOT NULL,
    FOREIGN KEY (idEquipe1) REFERENCES Equipe(id),
    FOREIGN KEY (idEquipe2) REFERENCES Equipe(id),
    FOREIGN KEY (idStade) REFERENCES Stade(id),
    FOREIGN KEY (idArbitre) REFERENCES Arbitre(id),
    FOREIGN KEY (idSaison) REFERENCES Saison(id)
);
CREATE TABLE But(
    idMatch INTEGER,
    idJoueur INTEGER,
    idEquipe VARCHAR(100),
    minute INTEGER,
    PRIMARY KEY (idMatch,idJoueur,idEquipe,minute),
    FOREIGN KEY (idMatch) REFERENCES Matche(id),
    FOREIGN KEY (idJoueur,idEquipe) REFERENCES Joueur(id,idEquipe) 
);