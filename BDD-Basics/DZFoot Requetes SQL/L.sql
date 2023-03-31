select team_id,player_id,minute from goals
group by  team_id,player_id,minute

having minute=(select min(minute) from (select team_id,player_id,minute from goals
group by  team_id,player_id,minute))