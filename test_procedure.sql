create database test;
use test;

CREATE TABLE Clientes (
    cliID INT AUTO_INCREMENT PRIMARY KEY,
    cli_nome_completo VARCHAR(255),
    cli_cidade VARCHAR(100),
    cli_estado VARCHAR(2)
);


CREATE TABLE Ordem_servico (
    o_ordem_id INT AUTO_INCREMENT PRIMARY KEY,
    ord_cli_id INT,
    o_data_do_servico DATE,
    o_valor_total DECIMAL(10, 2),
    CONSTRAINT fk_ord_cli_id FOREIGN KEY (ord_cli_id) REFERENCES Clientes(cliID)
);


DELIMITER //

CREATE PROCEDURE GetrOrdem_servico_cli(IN cliID INT)
BEGIN
	SELECT * FROM ordem_servico WHERE ord_cli_id = cliID;
END //

DELIMITER ;

CALL GetrOrdem_servico_cli(12)