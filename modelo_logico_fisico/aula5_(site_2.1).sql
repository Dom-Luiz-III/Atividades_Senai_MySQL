create database site;
use site;

-- ----------------------------------------------------------------------------------------------------------------------------------------------

create table usuario (
	user_codigo int(11) primary key auto_increment,
	user_nome varchar (100) not null,
	user_senha varchar (10),
    user_nivel int (11)
);

create table produtos (
	prod_codigo int(11) primary key auto_increment,
	prod_nome varchar (100) not null,
	prod_preco float,
    prod_unidade_medida int (11),
    prod_cod_barras varchar (13),
    prod_departamento int (11),
    prod_estoque decimal (15,4)
);

create table unidade_medida (
	uni_codigo int(11) primary key auto_increment,
	uni_nome varchar (100) not null
);

create table departamentos (
	dep_codigo int(11) primary key auto_increment,
	dep_nome varchar (100) not null
);

create table itens_venda (
	iven_codigo int(11) primary key auto_increment,
	iven_valor decimal (15,4),
	iven_desconto decimal (15,4),
    iven_total decimal (15,4),
    iven_produto int (11),
    iven_fk_venda int (11)
    -- foreign key (
);

create table vendas (
	ven_codigo int(11) primary key auto_increment,
	ven_data date,
	ven_total decimal (15,4),
    ven_cliente int (11),
    ven_status tinyint(1)
);

create table cliente (
	cli_codigo int(11) primary key auto_increment,
	cli_nome varchar (100) not null,
	cli_endereco varchar (60),
    cli_cpf decimal (10,0),
    cli_tel decimal (10,0),
    cli_bairro varchar (60),
    cli_num_casa varchar (10),
    cli_fk_cidade_codigo int (11)
);

create table cidade (
	cid_codigo int(11) primary key auto_increment,
	cid_nome varchar (100) not null,
    cid_fk_estado int (11)
);

create table estados (
	est_codigo int(11) primary key auto_increment,
	est_nome varchar (100) not null
);

create table recebimento (
	rec_codigo int(11) primary key auto_increment,
	rec_data date,
	rec_valor decimal (15,4),
    rec_fk_codigo_venda int (11),
    rec_fk_codigo_formapag int(11)
);

create table forma_pagamento (
	fpag_codigo int(11) primary key auto_increment,
	fpag_nome varchar (30) not null
);

-- ----------------------------------------------------------------------------------------------------------------------------------------------

alter table produtos
add constraint fk_unidade_medida
	foreign key (prod_unidade_medida)
    references unidade_medida (uni_codigo)
    on delete no action
    on update no action;
    
alter table produtos
add constraint fk_departamento
	foreign key (prod_departamento)
    references departamentos (dep_codigo)
    on delete no action
    on update no action;

alter table vendas
add constraint fk_clientes
	foreign key (ven_cliente)
    references cliente (cli_codigo)
    on delete no action
    on update no action;
    
alter table recebimento
add constraint fk_venda
	foreign key (rec_fk_codigo_venda)
    references vendas (ven_codigo)
    on delete no action
    on update no action;
    
alter table recebimento
add constraint fk_forma_pagamento
	foreign key (rec_fk_codigo_formapag)
    references forma_pagamento (fpag_codigo)
    on delete no action
    on update no action;    

alter table itens_venda
add constraint fk_produtos
	foreign key (iven_produto)
    references produtos (prod_codigo)
    on delete no action
    on update no action;
    
alter table itens_venda
add constraint fk_vendas
	foreign key (iven_fk_venda)
    references vendas (ven_codigo)
    on delete no action
    on update no action;
    
alter table cliente
add constraint fk_cidade
	foreign key (cli_fk_cidade_codigo)
    references cidade (cid_codigo)
    on delete no action
    on update no action;
    
alter table cidade
add constraint fk_estado
	foreign key (cid_fk_estado)
    references estados (est_codigo)
    on delete no action
    on update no action;
-- ----------------------------------------------------------------------------------------------------------------------------------------------
    
insert into cliente(cli_nome, cli_endereco) value ('Erlon','rua A');
insert into cidade(cid_nome) value ('Salvador');

insert into departamentos(dep_nome) value('Alimentos'),('Limpeza');

insert into unidade_medida(uni_nome) value('KG'),('LT'),('UN'),('MT');

insert into produtos(prod_nome,prod_preco,prod_unidade_medida,prod_cod_barras,prod_departamento,prod_estoque)
value('Arroz Tio João',6.99,1,'7896352141',1,50);

select * from departamento;

select * from produtos
inner join departamentos on (dep_codigo = prod_departamento);

update cliente
	set cli_fk_cidade_codigo = 1
    where cli_codigo = 1;

select * from cliente;