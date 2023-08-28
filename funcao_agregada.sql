create database escola;
use escola;

-- ----------------------------------------------------------------------------------------------------------------------------------------------

create table notas (
	nota_id int primary key auto_increment,
	nota_alu_id int,
	nota float,
   FOREIGN KEY (nota_alu_id) REFERENCES alunos(alu_id) 
);

create table alunos (
	alu_id int primary key auto_increment,
	alu_nome varchar (100),
	alu_curso varchar (80),
    alu_nota float
);

create table materias (
	mat_id int primary key auto_increment,
	mat_nome varchar (100)
);

create table aluno_materia (
	amat_id int primary key auto_increment,
	amat_fk_materia int not null,
	amat_fk_aluno int not null,
    FOREIGN KEY (amat_fk_materia) REFERENCES materias(mat_id),
    FOREIGN KEY (amat_fk_aluno) REFERENCES alunos(alu_id) 
);

-- ----------------------------------------------------------------------------------------------------------------------------------------------

insert into alunos(alu_nome, alu_curso, alu_nota) value ('Erlon','Analista de Sistemas', 7.13);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Luiz Henrique','Analista de Sistemas', 10);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Vinicius','Programação Orientada a Objeto', 6.13);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Kleyton','Lógica de Programação', 9.13);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Débora','Excell Introdução', 7.15);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Ivana','Banco de Dados', 8.20);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Jéssica','Web Design', 2.13);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Ruan','Web Design', 8.23);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Bruno','Lógica de Programação', 2.13);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Marcos','Web Design', 9.11);
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Riquelme','Lógica de Programação', 7.13);

insert into notas(nota_alu_id, nota) value ('1', 10);
insert into notas(nota_alu_id, nota) value ('2', 7);
insert into notas(nota_alu_id, nota) value ('3', 8.50);
insert into notas(nota_alu_id, nota) value ('4', 7.55);
insert into notas(nota_alu_id, nota) value ('5', 8.13);
insert into notas(nota_alu_id, nota) value ('6', 6.44);
insert into notas(nota_alu_id, nota) value ('7', 7.55);
insert into notas(nota_alu_id, nota) value ('8', 5.99);
insert into notas(nota_alu_id, nota) value ('9', 9);
insert into notas(nota_alu_id, nota) value ('10', 9.10);
insert into notas(nota_alu_id, nota) value ('11', 7.14);
insert into notas(nota_alu_id, nota) value ('12', 8.14);
-- ----------------------------------------------------------------------------------------------------------------------------------------------

-- Calcular a média das notas dos alunos.
select avg(alu_nota) as media from alunos;

-- Contar o número total de alunos na tabela.
select count(*) as total_alunos from alunos;

-- Encontrar a nota mais alta entre todos os alunos.
select alu_nome, alu_nota from alunos where alu_nota = (select max(alu_nota) from alunos);

-- Encontrar a nota mais baixa entre todos os alunos.
select alu_nome, alu_nota from alunos where alu_nota = (select min(alu_nota) from alunos);

-- Fazendo o left join.
select alunos.alu_nome, notas.nota
from alunos
left join notas on alunos.alu_id = notas.nota_alu_id;

-- Mostrando a lista de alunos ou notas.
select * from alunos;
select * from notas;