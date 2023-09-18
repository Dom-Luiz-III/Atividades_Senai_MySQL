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

CREATE VIEW Logs AS
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


CREATE TRIGGER Tgr_Animal_Historico AFTER INSERT ON Itens_da_ordem_de_servico
FOR EACH ROW
BEGIN
    INSERT INTO Animal_historico (ah_animal_id, ah_data_evento, ah_descricao)
    VALUES (NEW.ido_animal_id, NOW(), 'Serviço realizado: ', NEW.ido_produto_servico_id);
END;

CREATE TRIGGER Tgr_Agendamento_Animal AFTER INSERT ON Animais
FOR EACH ROW
BEGIN
    INSERT INTO Agendamento (agn_data_agendamento, agn_funcionario_id, agn_animal_id)
    VALUES (NOW(), CURRENT_USER(), NEW.a_animal_id);
END;

CREATE TRIGGER Tgr_Log_Insert_Update_Delete AFTER INSERT, UPDATE, DELETE
FOR EACH ROW
ON Produto_Servico, Ordem_de_servico, Vacinas_aplicadas
BEGIN

    INSERT INTO Logs (lg_data_hora, lg_usuario, lg_acao, lg_detalhes)
    VALUES (NOW(), CURRENT_USER(), EVENT_TYPE(), CONCAT('ID: ', NEW.ps_produto_servico_id));
END;;



