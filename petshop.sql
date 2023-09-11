create database petshop;
use petshop;

create table cliente (
	cli_id int primary key auto_increment,
	cli_nome varchar(100),
	cli_email varchar(100),
	cli_telefone varchar(20)
);

create table animais (
	ani_id int primary key auto_increment,
	ani_nome varchar(100),
    ani_sexo varchar(20),
	ani_cliente_id int,
	foreign key (ani_cliente_id) references cliente(cli_id)
);

create table vacina (
	vaci_id int primary key auto_increment,
	vaci_nome varchar(100)
);

create table vacina_aplicada (
	vaci_apli_id int primary key auto_increment,
	vaci_apli_nome varchar(100),
	vaci_apli_animal_id int,
	foreign key (vaci_apli_animal_id) references animais(ani_id),
    foreign key (vaci_apli_animal_id) references vacina(vaci_id)
);

create table ordem_de_servico (
	ordem_serv_id int primary key auto_increment,
	ordem_serv_nome varchar(100),
	ordem_serv_data date,
	ordem_serv_cliente_id int,
	foreign key (ordem_serv_cliente_id) references cliente(cli_id)
);

create table ordem_de_servico_itens (
	ordem_serv_item_id int primary key auto_increment,
	ordem_serv_item_nome varchar(100),
	ordem_serv_item_ordem_id int,
	ordem_serv_item_produto_id int,
	foreign key (ordem_serv_item_ordem_id) references ordem_de_servico(ordem_serv_id),
	foreign key (ordem_serv_item_produto_id) references produto_servico(prod_id)
);

create table produto_servico (
	prod_id int primary key auto_increment,
	prod_nome varchar(100),
    prod_data_validade DATE
);

create table forma_pagamento (
	paga_id int primary key auto_increment,
	paga_nome varchar(100)
);

create table funcionarios (
	func_id int primary key auto_increment,
	func_nome varchar(100)
);

create table recebimento (
	receb_id int primary key auto_increment,
	receb_nome varchar(100)
);

create table racas (
	raca_id int primary key auto_increment,
	raca_nome varchar(100)
);

create table estoque (
	estoq_id int primary key auto_increment,
    estoq_estoque float,
	estoq_fk_prod_serv int,
    foreign key (estoq_fk_prod_serv) references produto_servico(prod_id)
);

create table lucros (
	lucros_id int primary key auto_increment,
    lucros_lucro float,
	lucros_fk_prod_serv int,
    foreign key (lucros_fk_prod_serv) references produto_servico(prod_id)
);

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inserção de dados:

INSERT INTO cliente (cli_nome, cli_email, cli_telefone)
VALUES ('João Silva', 'joao.silva@example.com', '1234567890'),
       ('Maria Santos', 'maria.santos@example.com', '9876543210');

INSERT INTO animais (ani_nome, ani_sexo, ani_cliente_id)
VALUES ('Rex', 'Macho', 1),
       ('Mel', 'Fêmea', 2);

INSERT INTO vacina (vaci_nome)
VALUES ('Vacina Pfizer'),
       ('Vacina Zeneca');

INSERT INTO vacina_aplicada (vaci_apli_nome, vaci_apli_animal_id)
VALUES ('Aplicada', 1),
       ('Não Aplicada', 2);

INSERT INTO ordem_de_servico (ordem_serv_nome, ordem_serv_data, ordem_serv_cliente_id)
VALUES ('Ordem de Serviço 1', '2023-09-01', 1),
       ('Ordem de Serviço 2', '2023-09-02', 2);

INSERT INTO ordem_de_servico_itens (ordem_serv_item_nome, ordem_serv_item_ordem_id, ordem_serv_item_produto_id)
VALUES ('Item 1 - Ordem 1', 1, 1),
       ('Item 2 - Ordem 2', 2, 2);

INSERT INTO produto_servico (prod_nome, prod_data_validade)
VALUES ('Produto Pedigree', '2023-10-01'),
       ('Produto Whiskas', '2023-10-15');
       
INSERT INTO racas (raca_nome)
VALUES ('Vira Lata'),
       ('Pit Bull');
       
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Atividades

-- Liste os animais que fizeram serviço no pet.
SELECT a.ani_id, a.ani_nome, a.ani_pet
FROM animais a
JOIN ordem_de_servico_itens oi ON oi.ordem_serv_item_ordem_id = a.ani_id;

-- Liste produtos que irão vencer no próximo mês.
SELECT prod_id, prod_nome, prod_data_validade
FROM produto_servico
WHERE MONTH(prod_data_validade) = MONTH(CURDATE()) + 1;

-- Atualize a quantidade de banhos tomando no cadastro do animal.
UPDATE animais
SET ani_quantidade_banhos = ani_quantidade_banhos + 1
WHERE ani_id = 1;

-- Totalize quantidade de produtos vendidos no mês.
SELECT COUNT(*) AS total_produtos_vendidos
FROM ordem_de_servico_itens;

-- Totalize quantidade de serviço feito no mês.
SELECT COUNT(*) AS total_servicos_feitos
FROM ordem_de_servico;

-- Calcule a comissão dos funcionários sobre o faturamento dos serviços em 3%. 
UPDATE funcionarios
SET func_comissao = (SELECT SUM(ordem_serv_valor) * 0.03 FROM ordem_de_servico);

-- Atualize quando será a próxima dose de vacina no cadastro do animal.
UPDATE animais
SET ani_proxima_dose = DATE_ADD(CURDATE(), INTERVAL 1 MONTH)
WHERE ani_id = 1;

-- Atualize o total comprado no cadastro do cliente.
UPDATE cliente
SET cli_total_comprado = cli_total_comprado + 100
WHERE cli_id = 1;
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create Views:

create view vw_clientes as
select cli_nome, cli_email, cli_telefone
from cliente;

create view vw_animals as
select ani_nome, ani_sexo, ani_cliente_id
from animais;

create view vw_vacinas as
select vaci_nome
from vacina;

create view vw_vacinas_aplicadas as
select vaci_apli_nome,vaci_apli_animal_id
from vacina_aplicada;

create view vw_ordem_de_servico as
select ordem_serv_item_nome,ordem_serv_data,ordem_serv_cliente_id
from ordem_de_servico;

create view vw_produto_servico as
select prod_nome,prod_data_validade
from produto_servico;

create view vw_forma_pagamento as
select paga_nome
from forma_pagamento;

create view vw_funcionarios as
select func_nome
from funcionarios;

create view vw_recebimento as
select receb_nome
from recebimento;

create view vw_racas as
select raca_nome
from racas;

create view vw_estoque as
select estoq_estoque,estoq_fk_prod_serv
from estoque;

create view vw_lucros as
select lucros_lucro,lucros_fk_prod_serv
from lucros;
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Outros

-- Alter Table:
alter table produto_servico add column custo float;

-- Insert into diferenciado:
insert into estoque (estoq_fk_prod_serv, estoq_estoque)
select prod_id, 0 from produto_servico
