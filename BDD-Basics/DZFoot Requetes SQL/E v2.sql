--Quel est le meilleur buteur ?

select team_id,player_id,count(player_id) NB_buts from goals
group by  team_id,player_id

having NB_buts=(select max(NB_buts) from (select team_id,player_id,count(player_id) NB_buts from goals
group by  team_id,player_id))

--Quel est le meilleur buteur ? version 1 sans rendre en compte les doublons(choixx du premier ligne)
select team_id,player_id,max(NB_buts) from (
select team_id,player_id,count(player_id) NB_buts from goals
group by  team_id,player_id)