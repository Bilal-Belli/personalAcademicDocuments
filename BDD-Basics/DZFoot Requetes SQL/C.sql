--Afficher toutes les rencontres qui ont eu lieu entre le MCA et l’USMA
SELECT * FROM match where ((teama_id='MCA' and teamb_id='USMA') or (teamb_id='MCA' and teama_id='USMA'))
