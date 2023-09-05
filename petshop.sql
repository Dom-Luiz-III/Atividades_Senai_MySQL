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
	ani_pet varchar(100),
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

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inserção de clientes
INSERT INTO cliente (cli_nome, cli_email, cli_telefone)
VALUES ('João Silva', 'joao.silva@example.com', '1234567890'),
       ('Maria Santos', 'maria.santos@example.com', '9876543210');

-- Inserção de animais
INSERT INTO animais (ani_nome, ani_pet, ani_cliente_id)
VALUES ('Rex', 'Cachorro', 1),
       ('Mel', 'Gato', 2);

-- Inserção de vacinas
INSERT INTO vacina (vaci_nome)
VALUES ('Vacina Pfizer'),
       ('Vacina Zeneca');

-- Inserção de vacinas aplicadas
INSERT INTO vacina_aplicada (vaci_apli_nome, vaci_apli_animal_id)
VALUES ('Aplicada', 1),
       ('Não Aplicada', 2);

-- Inserção de ordens de serviço
INSERT INTO ordem_de_servico (ordem_serv_nome, ordem_serv_data, ordem_serv_cliente_id)
VALUES ('Ordem de Serviço 1', '2023-09-01', 1),
       ('Ordem de Serviço 2', '2023-09-02', 2);

-- Inserção de itens de ordens de serviço
INSERT INTO ordem_de_servico_itens (ordem_serv_item_nome, ordem_serv_item_ordem_id, ordem_serv_item_produto_id)
VALUES ('Item 1 - Ordem 1', 1, 1),
       ('Item 2 - Ordem 2', 2, 2);

-- Inserção de produtos/serviços
INSERT INTO produto_servico (prod_nome, prod_data_validade)
VALUES ('Produto 1', '2023-10-01'),
       ('Produto 2', '2023-10-15');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
