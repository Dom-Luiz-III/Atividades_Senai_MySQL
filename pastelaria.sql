/*
Instituição SENAI
Atividade 5
Aluno: Luiz Henrique Carneiro Carvalho
Professora: Thaiany
Objetivo: Criar um banco de dados para uma pastelaria, atendendo os requisitos da atividade passada.
Data: 27/09/2023
*/

CREATE DATABASE Pastelaria;
USE Pastelaria;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- Tables

CREATE TABLE Clientes (
    cli_id INT AUTO_INCREMENT PRIMARY KEY,
    cli_nome_completo VARCHAR(255),
    cli_nome_preferido VARCHAR(100),
    cli_cpf VARCHAR(14) UNIQUE,
    cli_data_nascimento DATE,
    cli_telefone VARCHAR(15),
    cli_email VARCHAR(255),
    cli_bairro VARCHAR(100),
    cli_cidade VARCHAR(100),
    cli_estado VARCHAR(2)
);

CREATE TABLE Produtos (
    prod_id INT AUTO_INCREMENT PRIMARY KEY,
    prod_nome VARCHAR(255),
    prod_preco DECIMAL(10, 2),
    prod_categoria VARCHAR(50),
    prod_recheio VARCHAR(255),
    prod_tamanho VARCHAR(50)
);

CREATE TABLE Pedidos (
    pedi_id INT AUTO_INCREMENT PRIMARY KEY,
    cli_id INT,
    pedi_data DATE,
    pedi_valor_total DECIMAL(10, 2),
    FOREIGN KEY (cli_id) REFERENCES Clientes(cli_id)
);

CREATE TABLE ItensPedido (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    pedi_id INT,
    prod_id INT,
    item_quantidade INT,
    item_valor_total DECIMAL(10, 2),
    FOREIGN KEY (pedi_id) REFERENCES Pedidos(pedi_id),
    FOREIGN KEY (prod_id) REFERENCES Produtos(prod_id)
);

CREATE TABLE FormasPagamento (
    forma_pagamento_id INT AUTO_INCREMENT PRIMARY KEY,
    forma_pagamento VARCHAR(255)
);

-- Comando feito para impedir que o mesmo produto seja adicionado duas vezes num pedido
CREATE UNIQUE INDEX idx_pedi_prod ON ItensPedido (pedi_id, prod_id);
-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- Views

CREATE VIEW PasteisVeganosMaiores18 AS
SELECT p.prod_id, p.prod_nome, p.prod_preco
FROM Produtos p
WHERE p.prod_categoria = 'Vegano' AND p.prod_recheio NOT LIKE '%leite%' AND p.prod_recheio NOT LIKE '%queijo%';

CREATE VIEW ClientesMaisPedidosPorMes AS
SELECT
    DATE_FORMAT(pedi_data, '%Y-%m') AS mes,
    cli_id,
    COUNT(pedi_id) AS num_pedidos
FROM Pedidos
GROUP BY mes, cli_id
HAVING num_pedidos = (SELECT MAX(num_pedidos) FROM (SELECT COUNT(pedi_id) AS num_pedidos FROM Pedidos GROUP BY mes, cli_id) AS temp);

CREATE VIEW PasteisComBaconEQueijo AS
SELECT p.prod_id, p.prod_nome, p.prod_preco
FROM Produtos p
WHERE p.prod_recheio LIKE '%bacon%' AND p.prod_recheio LIKE '%queijo%';

CREATE VIEW ValorTotalPastéis AS
SELECT SUM(prod_preco) AS total_pastéis
FROM Produtos;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- Triggers

DELIMITER //
CREATE TRIGGER AtualizarDataPedido
BEFORE INSERT ON Pedidos
FOR EACH ROW
BEGIN
    SET NEW.pedi_data = CURDATE();
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER CalcValorTotalPedido
AFTER INSERT ON ItensPedido
FOR EACH ROW
BEGIN
    DECLARE subtotal DECIMAL(10, 2);
    SET subtotal = NEW.item_valor_total;
    UPDATE Pedidos
    SET pedi_valor_total = pedi_valor_total + subtotal
    WHERE pedi_id = NEW.pedi_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER ImpedirProdutoDuplicado
BEFORE INSERT ON ItensPedido
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM ItensPedido WHERE pedi_id = NEW.pedi_id AND prod_id = NEW.prod_id) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto duplicado em um pedido.';
    END IF;
END;
//
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- Inserts

INSERT INTO Clientes (cli_nome_completo, cli_nome_preferido, cli_cpf, cli_data_nascimento, cli_telefone, cli_email, cli_bairro, cli_cidade, cli_estado)
VALUES
    ('João Silva', 'João', '123.456.789-00', '1990-05-15', '(11) 9876-5432', 'joao@email.com', 'Sobradinho', 'Feira de Santana', 'BA'),
    ('Maria Santos', 'Maria', '987.654.321-00', '1985-03-20', '(21) 8765-4321', 'maria@email.com', 'Cidade Nova', 'Feira de Santana', 'BA'),
    ('Carlos Oliveira', 'Carlos', '456.789.123-00', '1998-11-10', '(51) 7654-3210', 'carlos@email.com', 'Papagaio', 'Feira de Santana', 'BA');

INSERT INTO Produtos (prod_nome, prod_categoria, prod_recheio, prod_tamanho, prod_preco)
VALUES
    ('Pastel de Carne', 'Carnes', 'Carne moída, cebola, azeitona', 'Grande', 6.50),
    ('Pastel de Queijo', 'Queijos', 'Queijo mussarela, orégano', 'Médio', 5.00),
    ('Pastel de Frango', 'Aves', 'Frango desfiado, milho, catupiry', 'Grande', 7.00);

INSERT INTO Pedidos (cli_id, pedi_data, pedi_valor_total)
VALUES
    (1, '2023-09-15', 13.50),
    (2, '2023-09-16', 12.50),
    (3, '2023-09-17', 14.00);

INSERT INTO ItensPedido (pedi_id, prod_id, item_quantidade, item_valor_total)
VALUES
    (1, 1, 2, 13.00),
    (1, 2, 1, 5.00),
    (2, 2, 3, 15.00),
    (3, 3, 2, 14.00);

INSERT INTO FormasPagamento (forma_pagamento)
VALUES
    ('Cartão de Crédito'),
    ('Dinheiro'),
    ('Pix');