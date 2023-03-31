--Quelle est la meilleure défense ?

select team_id,min(somme)from (
select team_id,sum(NB_Buts_Encaisser) somme from
(
select teama_id team_id,sum(goals_teamb) NB_Buts_Encaisser from match group by teama_id
union all
select teamb_id team_id,sum(goals_teama) NB_Buts_Encaisser from match group by teamb_id
)
group by team_id
)