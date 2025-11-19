-- Cria o banco de dados principal
CREATE DATABASE new_database;

-- Define o caminho de busca padrão para o esquema "public"
SET search_path TO pg_catalog,public;

-- Cria a tabela de serviços
CREATE TABLE public.servico (
	id_servico serial NOT NULL,
	servico_nome varchar(30),
	servico_preco_base numeric(10,2),
	servico_tipo varchar(30),
	id_fornecedor_fornecedor integer,
	CONSTRAINT servico_pk PRIMARY KEY (id_servico)
);

ALTER TABLE public.servico OWNER TO postgres;

-- Cria a tabela de fornecedores
CREATE TABLE public.fornecedor (
	id_fornecedor serial NOT NULL,
	fornecedor_nome varchar(50),
	fornecedor_tipo varchar(50),
	fornecedor_status char,
	CONSTRAINT fornecedor_pk PRIMARY KEY (id_fornecedor)
);
ALTER TABLE public.fornecedor OWNER TO postgres;

-- Chave estrangeira serviço → fornecedor
ALTER TABLE public.servico ADD CONSTRAINT fornecedor_fk FOREIGN KEY (id_fornecedor_fornecedor)
REFERENCES public.fornecedor (id_fornecedor) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Atrativos
CREATE TABLE public.atrativo (
	atrativo_nome varchar(50),
	atrativo_horario_funcionando time,
	atrativo_tipo varchar(30),
	id_servico_servico integer,
	id_destino_destino integer
);

ALTER TABLE public.atrativo OWNER TO postgres;

ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_uq UNIQUE (id_servico_servico);

-- Hospedagem
CREATE TABLE public.hospedagem (
	hospedagem_nome_propriedade varchar(50),
	hospedagem_tipo_acomodacao varchar(40),
	hospedagem_categoria varchar(40),
	id_servico_servico integer,
	id_destino_destino integer
);

ALTER TABLE public.hospedagem OWNER TO postgres;

ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_uq UNIQUE (id_servico_servico);

-- Transporte
CREATE TABLE public.transporte (
    id_transporte SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    origem VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    data_partida DATE NOT NULL,
    data_chegada DATE NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    id_servico_servico INTEGER,
    id_destino_destino INTEGER 
);

ALTER TABLE public.transporte OWNER TO postgres;

ALTER TABLE public.transporte ADD CONSTRAINT transporte_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.transporte ADD CONSTRAINT transporte_uq UNIQUE (id_servico_servico);

-- Destino
CREATE TABLE public.destino (
	id_destino serial NOT NULL,
	destino_pais varchar(30),
	destino_cidade varchar(40),
	CONSTRAINT destino_pk PRIMARY KEY (id_destino)
);

ALTER TABLE public.destino OWNER TO postgres;

ALTER TABLE public.transporte ADD CONSTRAINT transporte_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Reserva
CREATE TABLE public.reserva (
	id_reserva serial NOT NULL,
	reserva_data date,
	reserva__data_inicio date,
	reserva_valor_total float,
	reserva_status char(1),
	id_servico_servico integer,
	id_cliente_cliente integer,
	CONSTRAINT reserva_pk PRIMARY KEY (id_reserva)
);

ALTER TABLE public.reserva OWNER TO postgres;

ALTER TABLE public.reserva ADD CONSTRAINT reserva_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Cliente
CREATE TABLE public.cliente (
	id_cliente serial NOT NULL,
	cliente_nome varchar(100),
	cliente_cpf varchar(15),
	cliente_email varchar(50),
	CONSTRAINT cliente_pk PRIMARY KEY (id_cliente)
);

ALTER TABLE public.cliente OWNER TO postgres;

ALTER TABLE public.reserva ADD CONSTRAINT reserva_cliente_fk FOREIGN KEY (id_cliente_cliente)
REFERENCES public.cliente (id_cliente) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

--------------------------------------------------------
-- INSERTS
--------------------------------------------------------

-- Clientes
INSERT INTO public.cliente (cliente_nome, cliente_cpf, cliente_email) VALUES
('Ana Beatriz Silva', '123.456.789-01', 'ana.silva@email.com'),
('Bruno Henrique Costa', '234.567.890-12', 'bruno.costa@email.com'),
('Camila Rocha Almeida', '345.678.901-23', 'camila.almeida@email.com'),
('Daniel Ferreira Souza', '456.789.012-34', 'daniel.souza@email.com'),
('Eduardo Lima Pereira', '567.890.123-45', 'eduardo.pereira@email.com'),
('Fernanda Oliveira Melo', '678.901.234-56', 'fernanda.melo@email.com'),
('Gustavo Martins Ramos', '789.012.345-67', 'gustavo.ramos@email.com'),
('Helena Duarte Cardoso', '890.123.456-78', 'helena.cardoso@email.com'),
('Igor Nunes Batista', '901.234.567-89', 'igor.batista@email.com'),
('Juliana Pinto Azevedo', '012.345.678-90', 'juliana.azevedo@email.com');

-- Destinos
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
INSERT INTO public.fornecedor (fornecedor_nome, fornecedor_tipo, fornecedor_status) VALUES
('Hotel Sol & Mar', 'Hospedagem', 'A'), 	
('Voa Rápido S/A', 'Transporte Aéreo', 'A'), 	
('Guia Tur SP', 'Agência Turismo', 'A'), 	
('Pousada da Montanha', 'Hospedagem', 'A'), 	
('RodoExpresso BR', 'Transporte Rodoviário', 'A'), 	
('Museum Corp', 'Atração Cultural', 'A'), 	
('Tokyo Rail', 'Transporte Ferroviário', 'A'), 	
('Hostel Amigo', 'Hospedagem', 'A'), 		
('Tours Europa', 'Agência Turismo', 'A'), 	
('Ferry Sydney', 'Transporte Marítimo', 'A');

-- Serviços (1–10)
INSERT INTO public.servico (servico_nome, servico_tipo, id_fornecedor_fornecedor) VALUES
('Diária Luxo Rio', 'Hospedagem', 1),
('Voo SP-Paris', 'Transporte', 2),
('City Tour SP', 'Atrativo', 3),
('Chalé Simples', 'Hospedagem', 4),
('Ônibus RJ-MG', 'Transporte', 5),
('Ingresso Arte', 'Atrativo', 6),
('Trem-Bala Tóquio', 'Transporte', 7),
('Cama em Dorm.', 'Hospedagem', 8),
('Tour Roma Coliseu', 'Atrativo', 9),
('Passeio Baía', 'Transporte', 10);

-- Transportes
TRUNCATE public.transporte RESTART IDENTITY;

INSERT INTO transporte (tipo, origem, destino, data_partida, data_chegada, preco) VALUES
('Ônibus', 'São Paulo', 'Rio de Janeiro', '2025-01-10', '2025-01-10', 150.00),
('Avião', 'Brasília', 'Salvador', '2025-02-05', '2025-02-05', 750.00),
('Navio', 'Rio de Janeiro', 'Buenos Aires', '2025-03-12', '2025-03-15', 2200.00),
('Metrô', 'São Paulo', 'São Paulo', '2025-01-01', '2025-01-01', 4.40),
('Uber', 'Curitiba', 'Curitiba', '2025-01-18', '2025-01-18', 22.50),
('Táxi', 'Porto Alegre', 'Porto Alegre', '2025-04-10', '2025-04-10', 35.90),
('Ônibus', 'Fortaleza', 'Natal', '2025-05-03', '2025-05-03', 120.00),
('Avião', 'Manaus', 'São Paulo', '2025-06-20', '2025-06-20', 980.00),
('Trem', 'Belo Horizonte', 'Vitória', '2025-07-14', '2025-07-14', 89.90),
('Navio', 'Santos', 'Ilhabela', '2025-08-02', '2025-08-02', 300.00);

-- Reservas
INSERT INTO reserva (reserva_data, reserva__data_inicio, reserva_valor_total, reserva_status, id_servico_servico, id_cliente_cliente)
VALUES 
('2025-01-01', '2025-01-05', 350.00, 'A', 1, 1),
('2025-01-03', '2025-01-04', 200.00, 'A', 2, 1),
('2025-02-10', '2025-02-12', 500.00, 'C', 3, 2),
('2025-03-15', '2025-03-16', 150.00, 'A', 1, 3),
('2025-03-20', '2025-03-22', 320.00, 'F', 4, 4),
('2025-04-01', '2025-04-10', 1200.00, 'A', 2, 5),
('2025-04-05', '2025-04-07', 450.00, 'C', 3, 6),
('2025-05-02', '2025-05-03', 180.00, 'A', 1, 7),
('2025-05-10', '2025-05-11', 220.00, 'F', 4, 8),
('2025-06-01', '2025-06-05', 900.00, 'A', 5, 9);

-- Atrativos
INSERT INTO atrativo (atrativo_nome, atrativo_horario_funcionando, atrativo_tipo, id_servico_servico, id_destino_destino)
VALUES
('Praia Central', '08:00', 'Natural', 1, 1),
('Museu Histórico', '09:00', 'Cultural', 2, 1),
('Parque das Aves', '07:30', 'Natural', 3, 2),
('Mirante da Serra', '10:00', 'Paisagem', 4, 2),
('Aquário Azul', '08:30', 'Educativo', 5, 3),
('Centro Gastronômico', '18:00', 'Culinária', 6, 3),
('Trilha da Mata', '06:00', 'Aventura', 7, 4),
('Cachoeira Bela Vista', '07:00', 'Natural', 8, 4),
('Planetário Municipal', '14:00', 'Cultural', 9, 5),
('Feira de Artesanato', '10:00', 'Comércio', 10, 5);

-- Serviços (11–20)
INSERT INTO public.servico (servico_nome, servico_tipo, id_fornecedor_fornecedor) VALUES
('Diária Luxo Rio', 'Hospedagem', 1),
('Chalé Simples', 'Hospedagem', 4),
('Cama em Dorm. 1', 'Hospedagem', 8),
('Apartamento', 'Hospedagem', 1),
('Suíte Presid.', 'Hospedagem', 4),
('Cama em Dorm. 2', 'Hospedagem', 8),
('Quarto Casal', 'Hospedagem', 1),
('Bangalô', 'Hospedagem', 4),
('Cama em Dorm. 3', 'Hospedagem', 8),
('Diária Padrão', 'Hospedagem', 1);

-- Hospedagens
INSERT INTO public.hospedagem (hospedagem_nome_propriedade, hospedagem_tipo_acomodacao, hospedagem_categoria, id_servico_servico, id_destino_destino)
VALUES
('Hotel Copacabana', 'Hotel', 'Luxo', 11, 1),
('Pousada do Sol', 'Pousada', 'Simples', 12, 2),
('Hostel Central', 'Hostel', 'Econômico', 13, 3),
('Residencial Plaza', 'Apartamento', 'Standard', 14, 4),
('Suítes Royal', 'Hotel', 'Luxo', 15, 5),
('Alojamento Simples', 'Hostel', 'Econômico', 16, 6),
('Hotel Tokyo', 'Hotel', 'Standard', 17, 7),
('Cabana da Floresta', 'Bangalô', 'Rústico', 18, 8),
('Hostel Lisboa', 'Hostel', 'Econômico', 19, 9),
('Apartamento Sydney', 'Apartamento', 'Standard', 20, 10);

--------------------------------------------------------
-- 2. CONSULTAS SQL INICIAIS 
--------------------------------------------------------


SELECT id_cliente, cliente_nome, cliente_email
FROM cliente
ORDER BY cliente_nome ASC;


SELECT id_transporte, tipo, origem, destino, preco
FROM transporte
WHERE preco > 500
ORDER BY preco DESC;


SELECT id_servico, servico_nome, servico_tipo
FROM servico
WHERE servico_tipo = 'Hospedagem';


SELECT id_reserva, reserva_data, reserva_valor_total
FROM reserva
WHERE reserva_status = 'A'
ORDER BY reserva_data;


SELECT atrativo_nome, atrativo_horario_funcionando
FROM atrativo
WHERE atrativo_horario_funcionando < '09:00'
ORDER BY atrativo_horario_funcionando;

--------------------------------------------------------
-- 3. CONSULTAS COM JOIN 
--------------------------------------------------------


SELECT r.id_reserva,
       c.cliente_nome,
       r.reserva_data,
       r.reserva_valor_total
FROM reserva r
INNER JOIN cliente c ON r.id_cliente_cliente = c.id_cliente;


SELECT s.id_servico,
       s.servico_nome,
       s.servico_tipo,
       f.fornecedor_nome
FROM servico s
LEFT JOIN fornecedor f ON s.id_fornecedor_fornecedor = f.id_fornecedor;


SELECT h.hospedagem_nome_propriedade,
       h.hospedagem_categoria,
       d.destino_cidade,
       d.destino_pais
FROM hospedagem h
INNER JOIN destino d ON h.id_destino_destino = d.id_destino;


SELECT t.id_transporte,
       t.tipo,
       t.origem,
       t.destino,
       d.destino_cidade
FROM transporte t
LEFT JOIN destino d ON t.id_destino_destino = d.id_destino;


SELECT a.atrativo_nome,
       a.atrativo_tipo,
       s.servico_nome AS servico_relacionado,
       d.destino_cidade AS cidade
FROM atrativo a
INNER JOIN servico s ON a.id_servico_servico = s.id_servico
INNER JOIN destino d ON a.id_destino_destino = d.id_destino;
