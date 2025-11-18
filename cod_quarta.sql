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

-- Cria chave estrangeira entre serviço e fornecedor
ALTER TABLE public.servico ADD CONSTRAINT fornecedor_fk FOREIGN KEY (id_fornecedor_fornecedor)
REFERENCES public.fornecedor (id_fornecedor) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Cria a tabela de atrativos turísticos
CREATE TABLE public.atrativo (
	atrativo_nome varchar(50),
	atrativo_horario_funcionando time,
	atrativo_tipo varchar(30),
	id_servico_servico integer,
	id_destino_destino integer
);

ALTER TABLE public.atrativo OWNER TO postgres;

-- Cria chave estrangeira entre atrativo e serviço
ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Garante que cada atrativo esteja vinculado a apenas um serviço (único)
ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_uq UNIQUE (id_servico_servico);

-- Cria a tabela de hospedagens
CREATE TABLE public.hospedagem (
	hospedagem_nome_propriedade varchar(50),
	hospedagem_tipo_acomodacao varchar(40),
	hospedagem_categoria varchar(40),
	id_servico_servico integer,
	id_destino_destino integer
);

ALTER TABLE public.hospedagem OWNER TO postgres;

-- Cria chave estrangeira entre hospedagem e serviço
ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Garante que cada hospedagem esteja vinculada a apenas um serviço
ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_uq UNIQUE (id_servico_servico);

-- Cria a tabela de transportes
CREATE TABLE transporte (
    id_transporte SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    origem VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    data_partida DATE NOT NULL,
    data_chegada DATE NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

ALTER TABLE public.transporte OWNER TO postgres;

-- Cria chave estrangeira entre transporte e serviço
ALTER TABLE public.transporte ADD CONSTRAINT transporte_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Garante que cada transporte esteja vinculado a apenas um serviço
ALTER TABLE public.transporte ADD CONSTRAINT transporte_uq UNIQUE (id_servico_servico);

-- Cria a tabela de destinos turísticos
CREATE TABLE public.destino (
	id_destino serial NOT NULL,
	destino_pais varchar(30),
	destino_cidade varchar(40),
	CONSTRAINT destino_pk PRIMARY KEY (id_destino)
);

ALTER TABLE public.destino OWNER TO postgres;

-- Cria chave estrangeira entre transporte e destino
ALTER TABLE public.transporte ADD CONSTRAINT transporte_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Cria chave estrangeira entre hospedagem e destino
ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Cria chave estrangeira entre atrativo e destino
ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Cria a tabela de reservas
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

-- Cria chave estrangeira entre reserva e serviço
ALTER TABLE public.reserva ADD CONSTRAINT reserva_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Cria a tabela de clientes
CREATE TABLE public.cliente (
	id_cliente serial NOT NULL,
	cliente_nome varchar(100),
	cliente_cpf varchar(15),
	cliente_email varchar(50),
	CONSTRAINT cliente_pk PRIMARY KEY (id_cliente)
);

ALTER TABLE public.cliente OWNER TO postgres;

-- Cria chave estrangeira entre reserva e cliente
ALTER TABLE public.reserva ADD CONSTRAINT reserva_cliente_fk FOREIGN KEY (id_cliente_cliente)
REFERENCES public.cliente (id_cliente) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Inserção de 10 clientes
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

-- Inserção de 10 destinos
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

-- Inserção de 10 fornecedores
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

-- Inserção de 10 serviços
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

-- Inserção de 10 transportes
TRUNCATE public.transporte RESTART IDENTITY;

-- Inserções corrigidas (10 registros)
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


-- Confirmar inserção
SELECT * FROM public.transporte;
