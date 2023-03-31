--Quelle est l’équipe qui a perdu le moins de matchs ?
SELECT team,SUM(Match_Perdu) NB_Match_Perdies
FROM (SELECT teama_id team,1 Match_Perdu FROM match Where goals_teama<goals_teamb
    UNION ALL
    SELECT teama_id team,0 Match_Perdu FROM match Where goals_teama=goals_teamb
    UNION ALL
    SELECT teamb_id team,1 Match_Perdu FROM match Where goals_teamb<goals_teama
    UNION ALL
    SELECT teamb_id team,0 Match_Perdu FROM match Where goals_teamb=goals_teama)
GROUP BY team

having  NB_Match_Perdies =(select min(NB_Match_Perdies) from (
SELECT team,SUM(Match_Perdu) NB_Match_Perdies
FROM (SELECT teama_id team,1 Match_Perdu FROM match Where goals_teama<goals_teamb
    UNION ALL
    SELECT teama_id team,0 Match_Perdu FROM match Where goals_teama=goals_teamb
    UNION ALL
    SELECT teamb_id team,1 Match_Perdu FROM match Where goals_teamb<goals_teama
    UNION ALL
    SELECT teamb_id team,0 Match_Perdu FROM match Where goals_teamb=goals_teama
    )
GROUP BY team
    ));
