-- 1. CRIAÇÃO DO BANCO DE DADOS
-- DROP DATABASE IF EXISTS new_database;
CREATE DATABASE new_database;

-- Define o caminho de busca padrão para o esquema "public"
SET search_path TO pg_catalog,public;

-- 2. CRIAÇÃO DAS TABELAS BASE (COM NOT NULL E UNIQUE)
-- Fornecedor
CREATE TABLE public.fornecedor (
	id_fornecedor serial NOT NULL,
	fornecedor_nome varchar(50) NOT NULL,
	fornecedor_tipo varchar(50),
	fornecedor_status char,
	CONSTRAINT fornecedor_pk PRIMARY KEY (id_fornecedor)
);
ALTER TABLE public.fornecedor OWNER TO postgres;

-- Cliente
CREATE TABLE public.cliente (
	id_cliente serial NOT NULL,
	cliente_nome varchar(100) NOT NULL,
	cliente_cpf varchar(15) NOT NULL,
	cliente_email varchar(50),
	CONSTRAINT cliente_pk PRIMARY KEY (id_cliente),
	CONSTRAINT cliente_cpf_unique UNIQUE (cliente_cpf)
);
ALTER TABLE public.cliente OWNER TO postgres;

-- Destino
CREATE TABLE public.destino (
	id_destino serial NOT NULL,
	destino_pais varchar(30) NOT NULL,
	destino_cidade varchar(40) NOT NULL,
	CONSTRAINT destino_pk PRIMARY KEY (id_destino)
);
ALTER TABLE public.destino OWNER TO postgres;

-- Serviço
CREATE TABLE public.servico (
	id_servico serial NOT NULL,
	servico_nome varchar(30) NOT NULL,
	servico_preco_base numeric(10,2) NOT NULL,
	servico_tipo varchar(30) NOT NULL,
	id_fornecedor_fornecedor integer,
	CONSTRAINT servico_pk PRIMARY KEY (id_servico)
);
ALTER TABLE public.servico OWNER TO postgres;

-- Reserva
CREATE TABLE public.reserva (
	id_reserva serial NOT NULL,
	reserva_data date NOT NULL,
	reserva_data_inicio date, 
	reserva_valor_total float NOT NULL,
	reserva_status char(1) NOT NULL,
	id_servico_servico integer,
	id_cliente_cliente integer,
	CONSTRAINT reserva_pk PRIMARY KEY (id_reserva)
);
ALTER TABLE public.reserva OWNER TO postgres;

-- 3. CRIAÇÃO DAS TABELAS DE ESPECIALIZAÇÃO (COM PK CORRIGIDA NA FK)

-- Transporte
CREATE TABLE public.transporte (
	tipo VARCHAR(50) NOT NULL,
	origem VARCHAR(100) NOT NULL,
	destino VARCHAR(100) NOT NULL,
	data_partida DATE NOT NULL,
	data_chegada DATE NOT NULL,
	preco DECIMAL(10,2) NOT NULL,
	id_servico_servico INTEGER NOT NULL,
	id_destino_destino INTEGER,
	CONSTRAINT transporte_pk PRIMARY KEY (id_servico_servico)
);
ALTER TABLE public.transporte OWNER TO postgres;

-- Hospedagem
CREATE TABLE public.hospedagem (
	hospedagem_nome_propriedade varchar(50) NOT NULL,
	hospedagem_tipo_acomodacao varchar(40),
	hospedagem_categoria varchar(40),
	id_servico_servico integer NOT NULL,
	id_destino_destino integer,
	CONSTRAINT hospedagem_pk PRIMARY KEY (id_servico_servico),
	CONSTRAINT hospedagem_uq UNIQUE (id_servico_servico)
);
ALTER TABLE public.hospedagem OWNER TO postgres;

-- Atrativo
CREATE TABLE public.atrativo (
	atrativo_nome varchar(50) NOT NULL,
	atrativo_horario_funcionando time,
	atrativo_tipo varchar(30),
	id_servico_servico integer NOT NULL,
	id_destino_destino integer,
	CONSTRAINT atrativo_pk PRIMARY KEY (id_servico_servico),
	CONSTRAINT atrativo_uq UNIQUE (id_servico_servico)
);
ALTER TABLE public.atrativo OWNER TO postgres;

-- 4. CRIAÇÃO DE CHAVES ESTRANGEIRAS (FKs)

-- Serviço (FK para Fornecedor)
ALTER TABLE public.servico ADD CONSTRAINT fornecedor_fk FOREIGN KEY (id_fornecedor_fornecedor)
REFERENCES public.fornecedor (id_fornecedor) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Reserva (FK para Serviço e Cliente)
ALTER TABLE public.reserva ADD CONSTRAINT reserva_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.reserva ADD CONSTRAINT reserva_cliente_fk FOREIGN KEY (id_cliente_cliente)
REFERENCES public.cliente (id_cliente) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Transporte (FK para Serviço e Destino)
ALTER TABLE public.transporte ADD CONSTRAINT transporte_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE public.transporte ADD CONSTRAINT transporte_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Hospedagem (FK para Serviço e Destino)
ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Atrativo (FK para Serviço e Destino)
ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- 5. CRIAÇÃO DE ÍNDICES ADICIONAIS
CREATE INDEX idx_reserva_cliente_data ON public.reserva (id_cliente_cliente, reserva_data);
CREATE INDEX idx_fornecedor_status ON public.fornecedor (fornecedor_status);
CREATE INDEX idx_servico_tipo ON public.servico (servico_tipo);

-- ########################################################
-- # ETAPA 2: POPULAÇÃO E CONSULTAS (DML)


-- 1. TRUNCATE E INSERTS DE DADOS

-- Clientes
TRUNCATE public.cliente RESTART IDENTITY CASCADE;
INSERT INTO public.cliente (cliente_nome, cliente_cpf, cliente_email) VALUES
('Ana Beatriz Silva', '12345678901', 'ana.silva@email.com'),
('Bruno Henrique Costa', '23456789012', 'bruno.costa@email.com'),
('Camila Rocha Almeida', '34567890123', 'camila.almeida@email.com'),
('Daniel Ferreira Souza', '45678901234', 'daniel.souza@email.com'),
('Eduardo Lima Pereira', '56789012345', 'eduardo.pereira@email.com'),
('Fernanda Oliveira Melo', '67890123456', 'fernanda.melo@email.com'),
('Gustavo Martins Ramos', '78901234567', 'gustavo.ramos@email.com'),
('Helena Duarte Cardoso', '89012345678', 'helena.cardoso@email.com'),
('Igor Nunes Batista', '90123456789', 'igor.batista@email.com'),
('Juliana Pinto Azevedo', '01234567890', 'juliana.azevedo@email.com'),
('Lucas Vieira Teixeira', '11122233344', 'lucas.vieira@email.com');

-- Destinos
TRUNCATE public.destino RESTART IDENTITY CASCADE;
INSERT INTO public.destino (destino_pais, destino_cidade) VALUES
('Brasil', 'Rio de Janeiro'), 
('Argentina', 'Buenos Aires'), 
('Chile', 'Santiago'), 
('Estados Unidos', 'Nova York'), 
('França', 'Paris'), 
('Itália', 'Roma'), 
('Japão', 'Tóquio'), 
('Canadá', 'Toronto'), 
('Portugal', 'Lisboa'), 
('Austrália', 'Sydney'); 

-- Fornecedores
TRUNCATE public.fornecedor RESTART IDENTITY CASCADE;
INSERT INTO public.fornecedor (fornecedor_nome, fornecedor_tipo, fornecedor_status) VALUES
('Hotel Sol & Mar', 'Hospedagem', 'A'), 	
('Voa Rápido S/A', 'Transporte Aéreo', 'A'), 	
('Guia Tur SP', 'Agência Turismo', 'A'), 	
('Pousada da Montanha', 'Hospedagem', 'A'), 	
('RodoExpresso BR', 'Transporte Rodoviário', 'A'), 	
('Museum Corp', 'Atração Cultural', 'I'), 	
('Tokyo Rail', 'Transporte Ferroviário', 'A'), 	
('Hostel Amigo', 'Hospedagem', 'A'), 		
('Tours Europa', 'Agência Turismo', 'A'), 	
('Ferry Sydney', 'Transporte Marítimo', 'A'); 

-- Serviços (Com servico_preco_base preenchido)
TRUNCATE public.servico RESTART IDENTITY CASCADE;
INSERT INTO public.servico (servico_nome, servico_preco_base, servico_tipo, id_fornecedor_fornecedor) VALUES
('Diária Luxo Rio', 300.00, 'Hospedagem', 1), 
('Voo SP-Paris', 1500.00, 'Transporte', 2), 
('City Tour SP', 80.00, 'Atrativo', 3), 
('Chalé Simples', 120.00, 'Hospedagem', 4), 
('Ônibus RJ-MG', 95.00, 'Transporte', 5), 
('Ingresso Arte', 60.00, 'Atrativo', 6),
('Trem-Bala Tóquio', 250.00, 'Transporte', 7), 
('Cama em Dorm.', 50.00, 'Hospedagem', 8), 
('Tour Roma Coliseu', 110.00, 'Atrativo', 9),
('Passeio Baía', 180.00, 'Transporte', 10), 
-- Serviços adicionais
('Diária Luxo Rio 2', 320.00, 'Hospedagem', 1), 
('Chalé Simples 2', 130.00, 'Hospedagem', 4), 
('Cama em Dorm. 1', 55.00, 'Hospedagem', 8), 
('Apartamento', 250.00, 'Hospedagem', 1), 
('Suíte Presid.', 800.00, 'Hospedagem', 4), 
('Cama em Dorm. 2', 45.00, 'Hospedagem', 8), 
('Quarto Casal', 280.00, 'Hospedagem', 1), 
('Bangalô', 190.00, 'Hospedagem', 4),
('Cama em Dorm. 3', 50.00, 'Hospedagem', 8), 
('Diária Padrão', 200.00, 'Hospedagem', 1), 
('Translado Aeroporto', 75.00, 'Transporte', 3); 

-- Transportes (INSERTS) - Chaves Estrangeiras são as Chaves Primárias
TRUNCATE public.transporte RESTART IDENTITY CASCADE;
INSERT INTO transporte (tipo, origem, destino, data_partida, data_chegada, preco, id_servico_servico, id_destino_destino) VALUES
('Ônibus', 'São Paulo', 'Rio de Janeiro', '2025-01-10', '2025-01-10', 150.00, 5, 1), 		
('Avião', 'Brasília', 'Nova York', '2025-02-05', '2025-02-05', 750.00, 2, 4), 			
('Navio', 'Rio de Janeiro', 'Buenos Aires', '2025-03-12', '2025-03-15', 2200.00, 10, 2), 	
('Metrô', 'Rio de Janeiro', 'Rio de Janeiro', '2025-01-01', '2025-01-01', 4.40, 7, 1), 		
('Uber', 'Santiago', 'Santiago', '2025-01-18', '2025-01-18', 22.50, 21, 3); 				

-- Reservas
TRUNCATE public.reserva RESTART IDENTITY CASCADE;
INSERT INTO reserva (reserva_data, reserva_data_inicio, reserva_valor_total, reserva_status, id_servico_servico, id_cliente_cliente)
VALUES
('2025-01-01', '2025-01-05', 350.00, 'A', 1, 1), 
('2025-01-03', '2025-01-04', 200.00, 'A', 2, 1), 
('2025-02-10', '2025-02-12', 500.00, 'C', 3, 2), 
('2025-03-15', '2025-03-16', 150.00, 'A', 4, 3), 
('2025-03-20', '2025-03-22', 320.00, 'F', 5, 4), 
('2025-04-01', '2025-04-10', 1200.00, 'A', 2, 5), 
('2025-04-05', '2025-04-07', 450.00, 'C', 6, 6), 
('2025-05-02', '2025-05-03', 180.00, 'A', 8, 7), 
('2025-05-10', '2025-05-11', 220.00, 'F', 9, 8), 
('2025-06-01', '2025-06-05', 900.00, 'A', 10, 9), 
('2025-06-10', '2025-06-15', 650.00, 'A', 11, 1), 
('2025-07-01', '2025-07-05', 400.00, 'F', 12, 10);

-- Atrativos (INSERTS)
TRUNCATE public.atrativo RESTART IDENTITY CASCADE;
INSERT INTO atrativo (atrativo_nome, atrativo_horario_funcionando, atrativo_tipo, id_servico_servico, id_destino_destino)
VALUES
('Praia Central', '08:00:00', 'Natural', 3, 1),
('Museu Histórico', '09:00:00', 'Cultural', 6, 1),
('Parque das Aves', '07:30:00', 'Natural', 9, 2),
('Mirante da Serra', '10:00:00', 'Paisagem', 13, 2),
('Aquário Azul', '08:30:00', 'Educativo', 16, 3);

-- Hospedagens (INSERTS)
TRUNCATE public.hospedagem RESTART IDENTITY CASCADE;
INSERT INTO public.hospedagem (hospedagem_nome_propriedade, hospedagem_tipo_acomodacao, hospedagem_categoria, id_servico_servico, id_destino_destino)
VALUES
('Hotel Copacabana', 'Hotel', 'Luxo', 1, 1),
('Pousada do Sol', 'Pousada', 'Simples', 4, 2),
('Hostel Central', 'Hostel', 'Econômico', 8, 3),
('Residencial Plaza', 'Apartamento', 'Standard', 11, 4),
('Suítes Royal', 'Hotel', 'Luxo', 14, 5);


-- 2. CONSULTAS SQL (DEMONSTRAÇÃO DE FUNCIONALIDADE)

-- 2.1. Lista serviços e o nome do seu fornecedor.
SELECT
    s.servico_nome,
    s.servico_tipo,
    f.fornecedor_nome
FROM
    servico s
LEFT JOIN
    fornecedor f ON s.id_fornecedor_fornecedor = f.id_fornecedor;

-- 2.2. Lista hospedagens e a cidade/país do destino.
SELECT
    h.hospedagem_nome_propriedade,
    d.destino_cidade,
    d.destino_pais
FROM
    hospedagem h
INNER JOIN
    destino d ON h.id_destino_destino = d.id_destino;

-- 2.3. Consulta com Subconsulta no WHERE (Reservas acima da média)
SELECT
    c.cliente_nome,
    r.reserva_valor_total
FROM
    reserva r
INNER JOIN
    cliente c ON r.id_cliente_cliente = c.id_cliente
WHERE
    r.reserva_valor_total > (
        SELECT AVG(reserva_valor_total)
        FROM reserva
    )
ORDER BY
    r.reserva_valor_total DESC;

-- 2.4. Consulta com HAVING (Média de valor das reservas por status > 300)
SELECT
    reserva_status,
    AVG(reserva_valor_total) AS media_valor
FROM
    reserva
GROUP BY
    reserva_status
HAVING
    AVG(reserva_valor_total) > 300;

-- 2.5. Consulta complexa (Clientes com 2+ reservas ativas)
SELECT
    c.cliente_nome,
    (SELECT COUNT(r.id_reserva) FROM reserva r WHERE r.id_cliente_cliente = c.id_cliente AND r.reserva_status = 'A') AS total_reservas_ativas
FROM
    cliente c
WHERE
    c.id_cliente IN (
        SELECT r_sub.id_cliente_cliente
        FROM reserva r_sub
        WHERE r_sub.reserva_status = 'A'
        GROUP BY r_sub.id_cliente_cliente
        HAVING COUNT(r_sub.id_reserva) >= 2
    )
ORDER BY total_reservas_ativas DESC;
