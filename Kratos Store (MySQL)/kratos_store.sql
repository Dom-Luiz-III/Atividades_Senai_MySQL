/*
SENAI
Atividade Teórica e Pratica
Aluno: Luiz Henrique Carneiro Carvalho
Data: 25/09/2023
*/

CREATE DATABASE kratos_store;
USE kratos_store;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- Tables

CREATE TABLE Clientes (
    cli_id INT AUTO_INCREMENT PRIMARY KEY,
    cli_nome VARCHAR(255),
    cli_email VARCHAR(100),
    cli_telefone VARCHAR(15)
);

CREATE TABLE Pedidos (
    pedi_id INT AUTO_INCREMENT PRIMARY KEY,
    cli_id INT,
    pedi_data DATE,
    pedi_valor_total DECIMAL(10, 2),
    FOREIGN KEY (cli_id) REFERENCES Clientes(cli_id)
);

CREATE TABLE Produtos (
    prod_id INT AUTO_INCREMENT PRIMARY KEY,
    prod_nome VARCHAR(255),
    prod_descricao TEXT,
    prod_preco DECIMAL(10, 2),
    prod_estoque INT
);

CREATE TABLE ItensPedido (
    item_pedi_id INT AUTO_INCREMENT PRIMARY KEY,
    pedi_id INT,
    prod_id INT,
    item_pedi_quantidade INT,
    item_pedi_subtotal DECIMAL(10, 2),
    FOREIGN KEY (pedi_id) REFERENCES Pedidos(pedi_id),
    FOREIGN KEY (prod_id) REFERENCES Produtos(prod_id)
);

CREATE TABLE Vendas (
    venda_id INT AUTO_INCREMENT PRIMARY KEY,
    func_id INT,
    venda_data DATE,
    venda_valor_total DECIMAL(10, 2),
    FOREIGN KEY (func_id) REFERENCES Funcionarios(func_id)
);

CREATE TABLE ItensVenda (
    item_venda_id INT AUTO_INCREMENT PRIMARY KEY,
    venda_id INT,
    prod_id INT,
    item_venda_quantidade INT,
    item_venda_subtotal DECIMAL(10, 2),
    FOREIGN KEY (venda_id) REFERENCES Vendas(venda_id),
    FOREIGN KEY (prod_id) REFERENCES Produtos(prod_id)
);

CREATE TABLE Funcionarios (
    func_id INT AUTO_INCREMENT PRIMARY KEY,
    func_nome VARCHAR(255),
    func_cargo VARCHAR(100),
    func_salario DECIMAL(10, 2),
    func_comissao DECIMAL(5, 2)
);

CREATE TABLE Categorias (
    cat_id INT AUTO_INCREMENT PRIMARY KEY,
    cat_nome VARCHAR(255)
);

CREATE TABLE ProdutosCategorias (
    cat_id INT,
    prod_id INT,
    PRIMARY KEY (cat_id, prod_id),
    FOREIGN KEY (cat_id) REFERENCES Categorias(cat_id),
    FOREIGN KEY (prod_id) REFERENCES Produtos(prod_id)
);

CREATE TABLE HistoricoPrecoProduto (
    hist_id INT AUTO_INCREMENT PRIMARY KEY,
    prod_id INT,
    data_alteracao DATETIME,
    preco_anterior DECIMAL(10, 2),
    preco_novo DECIMAL(10, 2),
    FOREIGN KEY (prod_id) REFERENCES Produtos(prod_id)
);

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- Views

CREATE VIEW Clientes_Pedidos AS
SELECT c.cli_id AS cliente_id, c.cli_nome AS cliente_nome, p.pedi_id AS pedido_id, p.pedi_data AS data_pedido, p.pedi_valor_total AS valor_total
FROM Clientes c
LEFT JOIN Pedidos p ON c.cli_id = p.cli_id;

CREATE VIEW Produtos_Em_Estoque AS
SELECT prod_id, prod_nome, prod_estoque
FROM Produtos
WHERE prod_estoque > 0;

CREATE VIEW Vendas_Produtos AS
SELECT v.venda_id, v.func_id, v.venda_data, v.venda_valor_total, iv.prod_id, iv.item_venda_quantidade, iv.item_venda_subtotal
FROM Vendas v
INNER JOIN ItensVenda iv ON v.venda_id = iv.venda_id;

CREATE VIEW Categorias_Produtos AS
SELECT c.cat_id, c.cat_nome, pc.prod_id
FROM Categorias c
INNER JOIN ProdutosCategorias pc ON c.cat_id = pc.cat_id;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- Triggers

DELIMITER //
CREATE TRIGGER CalcValorTotalPedido
BEFORE INSERT ON ItensPedido
FOR EACH ROW
BEGIN
    DECLARE subtotal DECIMAL(10, 2);
    SET subtotal = NEW.item_pedi_quantidade * (SELECT prod_preco FROM Produtos WHERE prod_id = NEW.prod_id);
    UPDATE Pedidos SET pedi_valor_total = pedi_valor_total + subtotal WHERE pedi_id = NEW.pedi_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER CalcValorTotalVenda
BEFORE INSERT ON ItensVenda
FOR EACH ROW
BEGIN
    DECLARE subtotal DECIMAL(10, 2);
    SET subtotal = NEW.item_venda_quantidade * (SELECT prod_preco FROM Produtos WHERE prod_id = NEW.prod_id);
    UPDATE Vendas SET venda_valor_total = venda_valor_total + subtotal WHERE venda_id = NEW.venda_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER RegistraHistoricoPrecoProduto
AFTER UPDATE ON Produtos
FOR EACH ROW
BEGIN
    INSERT INTO HistoricoPrecoProduto (prod_id, data_alteracao, preco_anterior, preco_novo)
    VALUES (NEW.prod_id, NOW(), OLD.prod_preco, NEW.prod_preco);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER CalcValorTotalVenda
BEFORE INSERT ON ItensVenda
FOR EACH ROW
BEGIN
    DECLARE subtotal DECIMAL(10, 2);
    SET subtotal = NEW.item_venda_quantidade * (SELECT prod_preco FROM Produtos WHERE prod_id = NEW.prod_id);
    SET NEW.item_venda_subtotal = subtotal;
    SET NEW.venda_valor_total = (SELECT SUM(item_venda_subtotal) FROM ItensVenda WHERE venda_id = NEW.venda_id);
END;
//
DELIMITER ;
