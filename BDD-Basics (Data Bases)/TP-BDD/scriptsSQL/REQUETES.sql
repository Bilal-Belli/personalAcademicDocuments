________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*------------nb buts pour chaque equipe-----------------*/
 select idEquipe,count(BUTS) NB_BUTS from (select idEquipe,idJoueur,idMatch,1 BUTS from but) AS T
 group by idEquipe
 order by count(BUTS) desc;
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*------------nb buts en saison-----------------*/
select count(*) NB_BUTS_Saison from but;
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*------------nb buts pour chaque joueur saison-----------------*/
 select idEquipe,idjoueur,count(BUTS) NB_BUTS from (select idEquipe,idJoueur,idMatch,1 BUTS from but) AS T
 group by idEquipe,idjoueur
 order by count(BUTS) desc;


SELECT 
    *
FROM
    joueur
        NATURAL JOIN
    (SELECT 
        idEquipe, idjoueur id, COUNT(BUTS) NB_BUTS
    FROM
        (SELECT 
        idEquipe, idJoueur, idMatch, 1 BUTS
    FROM
        but) AS T
    GROUP BY idEquipe , idjoueur) AS T
ORDER BY NB_BUTS DESC;
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*------------les meilleurs butteur-----------------*/
 select idEquipe,idjoueur,count(BUTS) NB_BUTS from (select idEquipe,idJoueur,idMatch,1 BUTS from but) AS T
 group by idEquipe,idjoueur
 having NB_BUTS = (select max(NB_BUTS) from (select idEquipe,idjoueur,count(BUTS) NB_BUTS from (select idEquipe,idJoueur,idMatch,1 BUTS from but) AS T group by idEquipe,idjoueur) AS T);
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*------------les joueurs qui ne marque pas-----------------*/
select * from joueur where not exists (select * from joueur natural join (select distinct idequipe,idjoueur id from but) as t);
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*----- la liste des joueurs qui sont marquées des buts ----*/
select * from joueur natural join (select distinct idequipe,idjoueur id from but) as t;
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*----- le nombre des joueurs qui sont marques pour chaque equipe ----*/
select idequipe,count(BUTTEUR) NB_BUTTEURS from (select distinct idequipe,idjoueur,1 BUTTEUR from but as t) as t
group by idequipe
order by NB_BUTTEURS desc;
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*----- --Quelle est la meilleure attaque ? ----*/
select idequipe,count(BUT) NB_BUTS from (select idequipe,1 BUT from but as t) as t
group by idequipe
having NB_BUTS = (select max(NB_BUTS ) from (select idequipe,count(BUT) NB_BUTS from (select idequipe,1 BUT from but as t) as t group by idequipe)  as t );
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*-------classement----*/
SELECT 
    idequipe, SUM(point) points
FROM
    ((SELECT 
        idequipe1 idequipe, 3 point
    FROM
        matche
    WHERE
        butequipe1 > butequipe2) UNION ALL (SELECT 
        idequipe1 idequipe, 1 point
    FROM
        matche
    WHERE
        butequipe1 = butequipe2) UNION ALL (SELECT 
        idequipe2 idequipe, 3 point
    FROM
        matche
    WHERE
        butequipe2 > butequipe1) UNION ALL (SELECT 
        idequipe2 idequipe, 1 point
    FROM
        matche
    WHERE
        butequipe2 = butequipe1)) AS t
GROUP BY idequipe
ORDER BY points DESC;
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*---------combien de match perdue pour chaque equipe ?----*/
SELECT 
    idequipe, SUM(MATCH_PERDUE) NB_MATCHS_PERDEES
FROM
    ((SELECT 
        idequipe1 idequipe, 1 MATCH_PERDUE
    FROM
        matche
    WHERE
        butequipe1 < butequipe2) UNION ALL (SELECT 
        idequipe2 idequipe, 1 MATCH_PERDUE
    FROM
        matche
    WHERE
        butequipe2 < butequipe1) ) AS t
GROUP BY idequipe
ORDER BY NB_MATCHS_PERDEES DESC;
________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*---------Quelle est l’équipe qui a perdu le moins de matchs ?----*/
SELECT 
    idequipe, SUM(MATCH_PERDUE) NB_MATCHS_PERDEES
FROM
    ((SELECT 
        idequipe1 idequipe, 1 MATCH_PERDUE
    FROM
        matche
    WHERE
        butequipe1 < butequipe2) UNION ALL (SELECT 
        idequipe2 idequipe, 1 MATCH_PERDUE
    FROM
        matche
    WHERE
        butequipe2 < butequipe1) ) AS t
GROUP BY idequipe
having NB_MATCHS_PERDEES=(select min(NB_MATCHS_PERDEES) from (SELECT 
    idequipe, SUM(MATCH_PERDUE) NB_MATCHS_PERDEES
FROM
    ((SELECT 
        idequipe1 idequipe, 1 MATCH_PERDUE
    FROM
        matche
    WHERE
        butequipe1 < butequipe2) UNION ALL (SELECT 
        idequipe2 idequipe, 1 MATCH_PERDUE
    FROM
        matche
    WHERE
        butequipe2 < butequipe1) ) AS t
GROUP BY idequipe) AS t )

________________________________________________________________________________________________________________________________________________
________________________________________________________________________________________________________________________________________________
/*---------championne----*/
SELECT idequipe, SUM(point) points
FROM (
(SELECT idequipe1 idequipe, 3 point FROM matche WHERE butequipe1 > butequipe2) 
UNION ALL 
(SELECT  idequipe1 idequipe, 1 point  FROM  matche  WHERE    butequipe1 = butequipe2) 
UNION ALL 
(SELECT   idequipe2 idequipe, 3 point FROM  matche   WHERE  butequipe2 > butequipe1) 
UNION ALL 
(SELECT  idequipe2 idequipe, 1 point   FROM   matche  WHERE  butequipe2 = butequipe1)) AS t
GROUP BY idequipe
having points= (select max(points) from 
(SELECT idequipe, SUM(point) points FROM(
(SELECT idequipe1 idequipe, 3 point FROM     matche  WHERE  butequipe1 > butequipe2) 
UNION ALL 
(SELECT  idequipe1 idequipe, 1 point FROM  matche  WHERE  butequipe1 = butequipe2) 
UNION ALL 
(SELECT idequipe2 idequipe, 3 point FROM matche WHERE butequipe2 > butequipe1)
 UNION ALL 
 (SELECT  idequipe2 idequipe, 1 point FROM matche WHERE butequipe2 = butequipe1)) 
 AS t GROUP BY idequipe) AS t)