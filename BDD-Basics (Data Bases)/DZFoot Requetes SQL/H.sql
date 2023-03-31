--Afficher la moyenne des rencontres par stade
select stadium_id,count(stadium_id) NB_Rencontres from match group by stadium_id
having NB_Rencontres = ( select avg(NB_Rencontres) from (
select stadium_id,count(stadium_id) NB_Rencontres from match group by stadium_id))