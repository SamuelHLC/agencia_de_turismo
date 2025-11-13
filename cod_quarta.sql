-- Cria o banco de dados principal
CREATE DATABASE new_database;

-- Define o caminho de busca padrão para o esquema "public"
SET search_path TO pg_catalog,public;

CREATE TABLE public.fornecedor (
    id_fornecedor serial NOT NULL,
    fornecedor_nome varchar(50),
    fornecedor_tipo varchar(50),
    fornecedor_status char,
    CONSTRAINT fornecedor_pk PRIMARY KEY (id_fornecedor)
);
ALTER TABLE public.fornecedor OWNER TO postgres;

CREATE TABLE public.servico (
    id_servico serial NOT NULL,
    servico_nome varchar(30),
    servico_preco_base numeric(10,2),
    servico_tipo varchar(30),
    id_fornecedor_fornecedor integer,
    CONSTRAINT servico_pk PRIMARY KEY (id_servico)
);
ALTER TABLE public.servico OWNER TO postgres;

-- Cria chave estrangeira entre serviço e fornecedor
ALTER TABLE public.servico
ADD CONSTRAINT fornecedor_fk FOREIGN KEY (id_fornecedor_fornecedor)
REFERENCES public.fornecedor (id_fornecedor)
MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;


CREATE TABLE public.destino (
    id_destino serial NOT NULL,
    destino_pais varchar(30),
    destino_cidade varchar(40),
    CONSTRAINT destino_pk PRIMARY KEY (id_destino)
);
ALTER TABLE public.destino OWNER TO postgres;

CREATE TABLE public.atrativo (
    atrativo_nome varchar(50),
    atrativo_horario_funcionando time,
    atrativo_tipo varchar(30),
    id_servico_servico integer,
    id_destino_destino integer
);
ALTER TABLE public.atrativo OWNER TO postgres;

ALTER TABLE public.atrativo
ADD CONSTRAINT atrativo_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico)
MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_uq UNIQUE (id_servico_servico);

CREATE TABLE public.hospedagem (
    hospedagem_nome_propriedade varchar(50),
    hospedagem_tipo_acomodacao varchar(40),
    hospedagem_categoria varchar(40),
    id_servico_servico integer,
    id_destino_destino integer
);
ALTER TABLE public.hospedagem OWNER TO postgres;

ALTER TABLE public.hospedagem
ADD CONSTRAINT hospedagem_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico)
MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_uq UNIQUE (id_servico_servico);

CREATE TABLE public.transporte (
    transporte_tipo char(1),
    transporte_origem varchar(100),
    transporte_hora_partida time,
    id_servico_servico integer,
    id_destino_destino integer
);
ALTER TABLE public.transporte OWNER TO postgres;

ALTER TABLE public.transporte
ADD CONSTRAINT transporte_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico)
MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.transporte ADD CONSTRAINT transporte_uq UNIQUE (id_servico_servico);

ALTER TABLE public.transporte
ADD CONSTRAINT transporte_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino)
MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.hospedagem
ADD CONSTRAINT hospedagem_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino)
MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.atrativo
ADD CONSTRAINT atrativo_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino)
MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE public.cliente (
    id_cliente serial NOT NULL,
    cliente_nome varchar(100),
    cliente_cpf varchar(15),
    cliente_email varchar(50),
    CONSTRAINT cliente_pk PRIMARY KEY (id_cliente)
);
ALTER TABLE public.cliente OWNER TO postgres;

CREATE TABLE public.reserva (
    id_reserva serial NOT NULL,
    reserva_data date,
    reserva_data_inicio date,
    reserva_valor_total float,
    reserva_status char(1),
    id_servico_servico integer,
    id_cliente_cliente integer,
    CONSTRAINT reserva_pk PRIMARY KEY (id_reserva)
);
ALTER TABLE public.reserva OWNER TO postgres;

ALTER TABLE public.reserva
ADD CONSTRAINT reserva_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico)
MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.reserva
ADD CONSTRAINT reserva_cliente_fk FOREIGN KEY (id_cliente_cliente)
REFERENCES public.cliente (id_cliente)
MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE;



-- Limpa e reinicia IDs antes de inserir (garante IDs 1–10)
TRUNCATE public.fornecedor RESTART IDENTITY CASCADE;

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
INSERT INTO public.servico (servico_nome, servico_preco_base, servico_tipo, id_fornecedor_fornecedor)
VALUES 
('Diária Luxo Rio', 350.00, 'Hospedagem', 1),
('Voo SP-Paris', 2500.00, 'Transporte', 2),
('City Tour SP', 180.00, 'Atrativo', 3),
('Chalé Simples', 220.00, 'Hospedagem', 4),
('Ônibus RJ-MG', 90.00, 'Transporte', 5),
('Ingresso Arte', 75.00, 'Atrativo', 6),
('Trem-Bala Tóquio', 150.00, 'Transporte', 7),
('Cama em Dorm.', 120.00, 'Hospedagem', 8),
('Tour Roma Coliseu', 200.00, 'Atrativo', 9),
('Passeio Baía', 250.00, 'Transporte', 10);

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

-- Inserção de 10 transportes
INSERT INTO public.transporte (
    transporte_tipo,
    transporte_origem,
    transporte_hora_partida,
    id_servico_servico,
    id_destino_destino
) VALUES
('A', 'São Paulo', '10:30:00', 2, 5),
('R', 'Rio de Janeiro', '08:00:00', 5, 1),
('F', 'Tóquio', '09:15:00', 7, 7),
('M', 'Sydney', '13:00:00', 10, 10),
('A', 'Buenos Aires', '07:45:00', 2, 2),
('R', 'Roma', '06:30:00', 5, 6),
('F', 'Toronto', '11:00:00', 7, 8),
('M', 'Lisboa', '15:20:00', 10, 9),
('A', 'Nova York', '12:45:00', 2, 4),
('R', 'Santiago', '05:50:00', 5, 3);

-- Inserção de 10 reservas
INSERT INTO public.reserva (reserva_data, reserva_data_inicio, reserva_valor_total, reserva_status, id_servico_servico, id_cliente_cliente)
VALUES 
('2025-11-01', '2025-11-01', 150.00, 'A', 1, 1),
('2025-11-02', '2025-11-02', 250.00, 'A', 2, 2),
('2025-11-03', '2025-11-03', 100.00, 'A', 3, 3),
('2025-11-04', '2025-11-04', 200.00, 'A', 4, 4),
('2025-11-05', '2025-11-05', 300.00, 'A', 5, 5),
('2025-11-06', '2025-11-06', 50.00, 'A', 6, 6),
('2025-11-07', '2025-11-07', 400.00, 'A', 7, 7),
('2025-11-08', '2025-11-08', 80.00, 'A', 8, 8),
('2025-11-09', '2025-11-09', 120.00, 'A', 9, 9),
('2025-11-10', '2025-11-10', 180.00, 'A', 10, 10);

-- Confirmar inserção
SELECT * FROM public.servico;
