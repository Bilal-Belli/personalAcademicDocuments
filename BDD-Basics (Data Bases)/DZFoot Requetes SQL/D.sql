--Afficher la liste des équipes ordonnées par ordre décroissant du nombre de
--points obtenu au championnat (Victoire = 4 pts, Défaite = 0 pts, Nul=1 pt)
--SELECT teama_id,goals_teama,goals_teamb FROM match
-- et puis selectionner le championne
SELECT team,SUM(Points) Pt
FROM (SELECT teama_id team,4 Points FROM match Where goals_teama>goals_teamb
    UNION ALL
    SELECT teama_id team,1 Points FROM match Where goals_teama=goals_teamb
    UNION ALL
    SELECT teamb_id team,4 Points FROM match Where goals_teamb>goals_teama
    UNION ALL
    SELECT teamb_id team,1 Points FROM match Where goals_teamb=goals_teama
    )
GROUP BY team
--Order By Points Desc
having  Pt =(select max(Pt) from (
SELECT team,SUM(Points) Pt
FROM (SELECT teama_id team,4 Points FROM match Where goals_teama>goals_teamb
    UNION ALL
    SELECT teama_id team,1 Points FROM match Where goals_teama=goals_teamb
    UNION ALL
    SELECT teamb_id team,4 Points FROM match Where goals_teamb>goals_teama
    UNION ALL
    SELECT teamb_id team,1 Points FROM match Where goals_teamb=goals_teama
    )
GROUP BY team
    ));