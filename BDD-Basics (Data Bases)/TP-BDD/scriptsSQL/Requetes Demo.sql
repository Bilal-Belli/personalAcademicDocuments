SELECT 
    idEquipe, idjoueur, COUNT(BUTS) NB_BUTS
FROM
    (SELECT 
        idEquipe, idJoueur, idMatch, 1 BUTS
    FROM
        but) AS T
GROUP BY idEquipe , idjoueur
HAVING NB_BUTS = (SELECT 
        MAX(NB_BUTS)
    FROM
        (SELECT 
            idEquipe, idjoueur, COUNT(BUTS) NB_BUTS
        FROM
            (SELECT 
            idEquipe, idJoueur, idMatch, 1 BUTS
        FROM
            but) AS T
        GROUP BY idEquipe , idjoueur) AS T);
