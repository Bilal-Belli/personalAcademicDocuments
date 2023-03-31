--Qui a marqué le but le plus rapide du championnat ?
--select * from player natural join
--(
--select team_id,player_id,minute from goals
--group by  team_id,player_id,minute
--having minute=(select min(minute) from (select team_id,player_id,minute from goals
--group by  team_id,player_id,minute))) t

select name,team_id,player_id,minute from goals natural join player
group by  team_id,player_id,minute

having minute=(select min(minute) from (select team_id,player_id,minute from goals
group by  team_id,player_id,minute))