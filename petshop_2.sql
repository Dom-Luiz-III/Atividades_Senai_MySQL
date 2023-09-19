create database PetShop2;
use PetShop2;


CREATE TABLE Racas (
    r_id INT AUTO_INCREMENT PRIMARY KEY,
    r_nome VARCHAR(100)
);


CREATE TABLE Clientes(

c_id int primary key auto_increment,
c_nome varchar(100),
c_fd int,
c_total_comprado FLOAT,
CONSTRAINT fk_c_fd FOREIGN KEY (c_fd) REFERENCES Forma_de_Pagamento(fd_forma_id)
);



CREATE TABLE Animais (
    a_animal_id INT AUTO_INCREMENT PRIMARY KEY,
    a_nome VARCHAR(255),
    a_cliente_id INT,
    a_rid  INT,
    q_quantidade_de_banhos INT,
    CONSTRAINT fk_cliente_id FOREIGN KEY (a_cliente_id) REFERENCES Clientes(c_id),
    CONSTRAINT fk_raça_id FOREIGN KEY (a_rid) REFERENCES Racas(r_id)
);


CREATE TABLE Vacinas (
    v_vacina_id INT AUTO_INCREMENT PRIMARY KEY,
    v_nome VARCHAR(100),
    v_descricao TEXT,
    v_validade DATE,
    v_preço int
);

CREATE TABLE Funcionarios (
    f_funcionario_id INT AUTO_INCREMENT PRIMARY KEY,
    f_nome VARCHAR(255),
    f_cargo VARCHAR(100),
    f_salario DECIMAL(10, 2),
    f_comissao float
);


CREATE TABLE Ordem_de_servico (
    o_ordem_id INT AUTO_INCREMENT PRIMARY KEY,
    o_animal_id INT,
    o_funcionario_id INT,
    o_data_do_servico DATE,
    o_valor_total DECIMAL(10, 2),
    CONSTRAINT fk_animal_id FOREIGN KEY (o_animal_id) REFERENCES Animais(a_animal_id),
    CONSTRAINT fk_funcionario_id FOREIGN KEY (o_funcionario_id) REFERENCES Funcionarios(f_funcionario_id)
);



CREATE TABLE Produto_Servico (
    ps_produto_servico_id INT AUTO_INCREMENT PRIMARY KEY,
    ps_nome VARCHAR(255),
    ps_descricao TEXT,
    ps_preco DECIMAL(10, 2),
    ps_serv_estoque FLOAT
);


CREATE TABLE Itens_da_ordem_de_servico (
    ido_item_id INT AUTO_INCREMENT PRIMARY KEY,
    ido_ordem_id INT,
    ido_produto_servico_id INT,
    ido_quantidade INT,
    ido_valor_unitario DECIMAL(10, 2),
    CONSTRAINT fk_ordem_id FOREIGN KEY (ido_ordem_id) REFERENCES Ordem_de_servico(o_ordem_id),
    CONSTRAINT fk_produto_servico_id FOREIGN KEY (ido_produto_servico_id) REFERENCES Produto_Servico(ps_produto_servico_id)
);



CREATE TABLE Vacinas_aplicadas (
    va_aplicacao_id INT AUTO_INCREMENT PRIMARY KEY,
    va_animal_id INT,
    va_vacina_id INT,
    va_data_aplicacao DATE,
    va_proxima_dose DATE,
    CONSTRAINT va_fk_animal_id FOREIGN KEY (va_animal_id) REFERENCES Animais(a_animal_id),
    CONSTRAINT fk_vacina_id FOREIGN KEY (va_vacina_id) REFERENCES Vacinas(v_vacina_id)
);


CREATE TABLE Forma_de_pagamento (
    fd_forma_id INT AUTO_INCREMENT PRIMARY KEY,
    fd_nome VARCHAR(50)
);



CREATE TABLE Recebimento (
    re_recebimento_id INT AUTO_INCREMENT PRIMARY KEY,
    re_ordem_id INT,
    re_forma_id INT,
    re_valor DECIMAL(10, 2),
    re_data_recebimento DATE,
    CONSTRAINT fk_r_ordem_id FOREIGN KEY (re_ordem_id) REFERENCES Ordem_de_servico(o_ordem_id),
    CONSTRAINT fk_forma_id FOREIGN KEY (re_forma_id) REFERENCES Forma_de_pagamento(fd_forma_id)
);


create table Estoque(
e_id int Primary key auto_increment,
e_produto_serviço_id int,
e_estoque float,
CONSTRAINT e_fk_produto_serviço_id FOREIGN KEY (e_produto_serviço_id) REFERENCES Produto_Servico(ps_produto_servico_id)
);

create table Lucro(
l_id int Primary key auto_increment,
l_produto_serviço_id int,
l_lucro float,
CONSTRAINT l_fk_produto_serviço_id  FOREIGN KEY (l_produto_serviço_id) REFERENCES Produto_Servico(ps_produto_servico_id)
);

CREATE TABLE Agendamento (
    agn_id INT AUTO_INCREMENT PRIMARY KEY,
    agn_data_agendamento DATE,
    agn_hora_agendamento TIME,
    agn_animal_id INT,
    agn_funcionario_id INT,
    CONSTRAINT fk_agn_animal_id FOREIGN KEY (agn_animal_id) REFERENCES Animais(a_animal_id),
    CONSTRAINT fk_agn_funcionario_id FOREIGN KEY (agn_funcionario_id) REFERENCES Funcionarios(f_funcionario_id)
);

CREATE TABLE Ranking (
    rk_id INT AUTO_INCREMENT PRIMARY KEY,
    rk_animal_id INT,
    rk_valor_total DECIMAL(10, 2),
    CONSTRAINT fk_rk_animal_id FOREIGN KEY (rk_animal_id) REFERENCES Animais(a_animal_id)
);

CREATE TABLE Animal_historico (
    ah_id INT AUTO_INCREMENT PRIMARY KEY,
    ah_animal_id INT,
    ah_data_evento DATE,
    ah_descricao VARCHAR(255),
    CONSTRAINT fk_ah_animal_id FOREIGN KEY (ah_animal_id) REFERENCES Animais(a_animal_id)
);

CREATE TABLE Logs (
    lg_id INT AUTO_INCREMENT PRIMARY KEY,
    lg_data_hora DATETIME,
    lg_usuario VARCHAR(100),
    lg_acao VARCHAR(255),
    lg_detalhes VARCHAR(255)
);

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create Views:

CREATE VIEW Cliente_Raca_Animais_v2 AS
SELECT c.c_id, c.c_nome, r.r_id, r.r_nome, a.a_animal_id, a.a_nome, a.q_quantidade_de_banhos
FROM Clientes c
INNER JOIN Animais a ON c.c_id = a.a_cliente_id
INNER JOIN Racas r ON a.a_rid = r.r_id;
SELECT * FROM Cliente_Raca_Animais_v2;

-- Create Views solicitadas na atividade:

CREATE VIEW Agendamento_da_semana AS
SELECT a.a_animal_id, a.a_nome, a.a_rid, a.q_quantidade_de_banhos, agn.agn_data_agendamento, agn.agn_hora_agendamento, agn.agn_funcionario_id
FROM Animais a
INNER JOIN Agendamento agn ON a.a_animal_id = agn.agn_animal_id
WHERE agn.agn_data_agendamento BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE();

CREATE VIEW Ranking_mensal AS
SELECT a.a_animal_id, a.a_nome, a.a_rid, SUM(o.o_valor_total) AS valor_total
FROM Ordem_de_servico o
INNER JOIN Animais a ON a.a_animal_id = o.o_animal_id
GROUP BY a.a_animal_id
ORDER BY valor_total DESC
LIMIT 10;

CREATE VIEW Logs_usuario AS
SELECT lg.lg_id, lg.lg_data_hora, lg.lg_usuario, lg.lg_acao, lg.lg_detalhes
FROM Logs lg;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create Triggers

CREATE TRIGGER Tgr_Estoque_Insert_BaixaDoLucro AFTER INSERT
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE lucro SET l_lucro = produto_servico.ps_valor - produto_servico.ps_custo
WHERE l_produto_serviço_id = NEW.ido_produto_servico_id;


CREATE TRIGGER Tgr_Estoque_Insert_BaixaDoLucro AFTER INSERT
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE lucro
SET l_lucro = (SELECT ps_preco - ps_custo FROM produto_servico WHERE ps_produto_servico_id = NEW.ido_produto_servico_id)
WHERE l_produto_serviço_id = NEW.ido_produto_servico_id;


CREATE TRIGGER Tgr_Estoque_Insert_VoltaDoLucro AFTER DELETE
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE lucro
SET l_lucro = l_lucro - (SELECT ps_preco - ps_custo FROM produto_servico WHERE ps_produto_servico_id = OLD.ido_produto_servico_id)
WHERE l_produto_serviço_id = OLD.ido_produto_servico_id;


CREATE TRIGGER Tgr_Estoque_Insert_BaixaDoEstoque AFTER INSERT
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE estoque SET e_estoque = e_estoque - NEW.ido_quantidade
WHERE e_produto_serviço_id = NEW.ido_produto_servico_id;


CREATE TRIGGER Tgr_Estoque_Delete_Volta_estoque AFTER DELETE
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE estoque SET e_estoque = e_estoque + OLD.ido_quantidade
WHERE e_produto_serviço_id = OLD.ido_produto_servico_id;

-- Create Tiggers solicitados na atividade:

DELIMITER //
CREATE TRIGGER Tgr_Log_Interacoes
AFTER INSERT ON Produto_Servico
FOR EACH ROW
BEGIN
    INSERT INTO Logs (lg_data_hora, lg_usuario, lg_acao, lg_detalhes)
    VALUES (NOW(), 'NomeDoUsuario', 'INSERT', 'Novo registro inserido na tabela Produto-Serviço');
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tgr_Log_Interacoes
AFTER UPDATE ON Produto_Servico
FOR EACH ROW
BEGIN
    INSERT INTO Logs (lg_data_hora, lg_usuario, lg_acao, lg_detalhes)
    VALUES (NOW(), 'NomeDoUsuario', 'UPDATE', 'Registro atualizado na tabela Produto-Serviço');
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tgr_Log_Interacoes
AFTER DELETE ON Produto_Servico
FOR EACH ROW
BEGIN
    INSERT INTO Logs (lg_data_hora, lg_usuario, lg_acao, lg_detalhes)
    VALUES (NOW(), 'NomeDoUsuario', 'DELETE', 'Registro excluído da tabela Produto-Serviço');
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tgr_Inserir_Animal_Historico_Aplicacao_Vacina
AFTER INSERT ON Vacinas_Aplicadas
FOR EACH ROW
BEGIN
    INSERT INTO Animal_Historico (ah_animal_id, ah_data_evento, ah_descricao)
    VALUES (NEW.va_animal_id, NEW.va_data_aplicacao, 'Aplicação de Vacina');
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tgr_Inserir_Animal_Historico_Ordem_de_Servico
AFTER INSERT ON Itens_da_Ordem_de_Servico
FOR EACH ROW
BEGIN
    INSERT INTO Animal_Historico (ah_animal_id, ah_data_evento, ah_descricao)
    VALUES (NEW.ido_animal_id, NOW(), 'Ordem de Serviço Criada');
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tgr_Inserir_Agendamento_Novo_Animal
AFTER INSERT ON Animais
FOR EACH ROW
BEGIN
    INSERT INTO Agendamento (agn_data_agendamento, agn_hora_agendamento, agn_animal_id, agn_funcionario_id)
    VALUES (NOW(), NOW(), NEW.a_animal_id, 'IDDoFuncionarioResponsavel');
END;
//
DELIMITER ;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- INSERT INTO

INSERT INTO Racas (r_nome) VALUES
    ('Poodle'),
    ('Labrador'),
    ('Siamês'),
    ('Persa');

INSERT INTO Clientes (c_nome, c_fd, c_total_comprado) VALUES
    ('João', 1, 500.00),
    ('Maria', 2, 750.00),
    ('Carlos', 3, 300.00);

INSERT INTO Animais (a_nome, a_cliente_id, a_rid, q_quantidade_de_banhos) VALUES
    ('Bobby', 1, 1, 3),
    ('Luna', 2, 2, 2),
    ('Whiskers', 3, 3, 1);

INSERT INTO Vacinas (v_nome, v_descricao, v_validade, v_preço) VALUES
    ('Vacina Raiva', 'Vacina para pets que pegaram raiva', '2023-12-31', 50),
    ('Vacina Hormonal', 'Vacina para pets do gênero feminino para não engravidar', '2023-12-31', 60),
    ('Vacina Febre', 'Vacina para pets com doenças relacionada a febre', '2023-12-31', 40);

INSERT INTO Funcionarios (f_nome, f_cargo, f_salario, f_comissao) VALUES
    ('Ana', 'Atendente', 2000.00, 0.10),
    ('Carlos', 'Veterinário', 3000.00, 0.15),
    ('Mariana', 'Faxineira', 1800.00, 0.12);

INSERT INTO Forma_de_pagamento (fd_nome) VALUES
    ('Cartão de Crédito'),
    ('Dinheiro Físico'),
    ('Pix');

INSERT INTO Produto_Servico (ps_nome, ps_descricao, ps_preco, ps_serv_estoque) VALUES
    ('Banho', 'Banho completo para cães', 40.00, 50),
    ('Tosa', 'Tosa para cães e gatos', 30.00, 30),
    ('Vacinação', 'Vacinação completa', 60.00, 20);

INSERT INTO Itens_da_ordem_de_servico (ido_ordem_id, ido_produto_servico_id, ido_quantidade, ido_valor_unitario) VALUES
    (1, 1, 1, 40.00),
    (1, 2, 1, 30.00),
    (2, 1, 1, 40.00);

INSERT INTO Vacinas_aplicadas (va_animal_id, va_vacina_id, va_data_aplicacao, va_proxima_dose) VALUES
    (1, 1, '2023-09-15', '2024-03-15'),
    (2, 2, '2023-09-10', '2024-03-10');

INSERT INTO Estoque (e_produto_serviço_id, e_estoque) VALUES
    (1, 50),
    (2, 30),
    (3, 20);

INSERT INTO Lucro (l_produto_serviço_id, l_lucro) VALUES
    (1, 10.00),
    (2, 8.00),
    (3, 15.00);

INSERT INTO Agendamento (agn_data_agendamento, agn_hora_agendamento, agn_animal_id, agn_funcionario_id) VALUES
    ('2023-09-20', '09:00:00', 1, 2),
    ('2023-09-25', '15:30:00', 2, 3);
