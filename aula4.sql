/*Comando para criar Database e usar*/
create database sis_mercado;
use sis_mercado;

/*Comando para tabela cliente*/
create table cliente (
	cli_codigo int primary key auto_increment,
	cli_nome varchar (100) not null,
	cli_email varchar (100),
	cli_telefone varchar (15),
    total_compra float
);

/*Comando para desativar o modo segurança do SQL*/
set SQL_SAFE_UPDATES = 0;

/*Comando para selecionar tabela clientes e visualizar*/
select * from cliente;
select cli_codigo, cli_nome, total_compra from cliente;

/*Comando para adicionar clientes, apenas para simulação*/
insert into cliente (cli_nome, cli_email, total_compra)
value('MARIA', 'maria@yahoo.com',10.60);

insert into cliente (cli_nome, cli_email, total_compra)
value('PAULO', 'paulao@yahoo.com',90.60);

insert into cliente (cli_nome, cli_email, total_compra)
value('JOSE', 'jose@yahoo.com',140.60);