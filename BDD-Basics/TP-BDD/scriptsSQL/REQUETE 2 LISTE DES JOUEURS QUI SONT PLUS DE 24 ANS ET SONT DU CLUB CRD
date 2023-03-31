/*liste des joueurs qui sont plus de 24ans*/
select * from joueur where datediff(curdate(),dateNaissance)/356 > 24
/*liste des joueurs qui sont plus de 24ans et sont du club CRD*/
select * from joueur where (datediff(curdate(),dateNaissance)/356 > 24 and joueur.idEquipe="CRD")