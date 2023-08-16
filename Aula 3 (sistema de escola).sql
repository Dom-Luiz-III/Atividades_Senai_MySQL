/*
Aula 3:
Construindo um banco de dados para uma escola usando MySQL e BR Modelo
*/

CREATE database escola;
use escola;

CREATE TABLE Aluno 
( 
 alu_ID INT PRIMARY KEY AUTO_INCREMENT,  
 alu_Nome VARCHAR(100),  
 alu_Disciplina INT,  
 alu_Notas FLOAT,  
 alu_Turma VARCHAR(100) 
); 

CREATE TABLE Provas 
( 
 pro_ID INT PRIMARY KEY AUTO_INCREMENT,  
 pro_Disciplina VARCHAR(100),  
 pro_Notas FLOAT,  
 idProfessor INT  
); 

CREATE TABLE Professor 
( 
 prof_ID INT PRIMARY KEY AUTO_INCREMENT,  
 prof_Nome VARCHAR(100),  
 prof_Disciplina VARCHAR(100)  
); 

CREATE TABLE Turma 
( 
 turm_Aluno VARCHAR(100),  
 turm_ID INT PRIMARY KEY AUTO_INCREMENT,  
 turm_Nome VARCHAR(100),  
 idDisciplina INT,  
 idProfessor INT,  
 idAluno INT 
); 

CREATE TABLE Disciplina 
( 
 dis_ID INT PRIMARY KEY AUTO_INCREMENT,  
 dis_Nome VARCHAR(100)  
); 

ALTER TABLE Aluno ADD FOREIGN KEY(alu_Disciplina) REFERENCES Aluno (alu_Disciplina);
ALTER TABLE Aluno ADD FOREIGN KEY(alu_Notas) REFERENCES Provas (alu_Notas);
ALTER TABLE Aluno ADD FOREIGN KEY(alu_Turma) REFERENCES Turma (alu_Turma);
ALTER TABLE Provas ADD FOREIGN KEY(pro_Disciplina) REFERENCES Aluno (pro_Disciplina);
ALTER TABLE Provas ADD FOREIGN KEY(idProfessor) REFERENCES Professor (idProfessor);
ALTER TABLE Professor ADD FOREIGN KEY(prof_Disciplina) REFERENCES Disciplina (prof_Disciplina);
ALTER TABLE Turma ADD FOREIGN KEY(turm_Aluno) REFERENCES Aluno (turm_Aluno);
ALTER TABLE Turma ADD FOREIGN KEY(idDisciplina) REFERENCES Aluno (idDisciplina);
ALTER TABLE Turma ADD FOREIGN KEY(idProfessor) REFERENCES Professor (idProfessor);
ALTER TABLE Turma ADD FOREIGN KEY(idAluno) REFERENCES Aluno (idAluno)

/*
Rascunhos:

INSERT INTO Aluno (alu_Nome, alu_Disciplina, alu_Notas, alu_Turma);
VALUES ('Pedro',30,''

Código importante para resetar os padrões do MySQL
set sql_safe_updades = 0;
*/