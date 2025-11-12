-- ** Database generated with pgModeler (PostgreSQL Database Modeler).
-- ** pgModeler version: 1.2.2
-- ** PostgreSQL version: 18.0
-- ** Project Site: pgmodeler.io
-- ** Model Author: ---

-- ** Database creation must be performed outside a multi lined SQL file. 
-- ** These commands were put in this file only as a convenience.

-- object: new_database | type: DATABASE --
-- DROP DATABASE IF EXISTS new_database;
CREATE DATABASE new_database;
-- ddl-end --


SET search_path TO pg_catalog,public;
-- ddl-end --

-- object: public.servico | type: TABLE --
-- DROP TABLE IF EXISTS public.servico CASCADE;
CREATE TABLE public.servico (
	id_servico serial NOT NULL,
	servico_nome varchar(30),
	servico_preco_base serial,
	servico_tipo varchar(30),
	id_fornecedor_fornecedor integer,
	CONSTRAINT servico_pk PRIMARY KEY (id_servico)
);
-- ddl-end --
ALTER TABLE public.servico OWNER TO postgres;
-- ddl-end --

-- object: public.fornecedor | type: TABLE --
-- DROP TABLE IF EXISTS public.fornecedor CASCADE;
CREATE TABLE public.fornecedor (
	id_fornecedor serial NOT NULL,
	fornecedor_nome varchar(50),
	fornecedor_tipo varchar(50),
	fornecedor_status char,
	CONSTRAINT fornecedor_pk PRIMARY KEY (id_fornecedor)
);
-- ddl-end --
ALTER TABLE public.fornecedor OWNER TO postgres;
-- ddl-end --

-- object: fornecedor_fk | type: CONSTRAINT --
-- ALTER TABLE public.servico DROP CONSTRAINT IF EXISTS fornecedor_fk CASCADE;
ALTER TABLE public.servico ADD CONSTRAINT fornecedor_fk FOREIGN KEY (id_fornecedor_fornecedor)
REFERENCES public.fornecedor (id_fornecedor) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.atrativo | type: TABLE --
-- DROP TABLE IF EXISTS public.atrativo CASCADE;
CREATE TABLE public.atrativo (
	atrativo_nome varchar(50),
	atrativo_horario_funcionando time,
	atrativo_tipo varchar(30),
	id_servico_servico integer,
	id_destino_destino integer,

);
-- ddl-end --
ALTER TABLE public.atrativo OWNER TO postgres;
-- ddl-end --

-- object: servico_fk | type: CONSTRAINT --
-- ALTER TABLE public.atrativo DROP CONSTRAINT IF EXISTS servico_fk CASCADE;
ALTER TABLE public.atrativo ADD CONSTRAINT servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: atrativo_uq | type: CONSTRAINT --
-- ALTER TABLE public.atrativo DROP CONSTRAINT IF EXISTS atrativo_uq CASCADE;
ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_uq UNIQUE (id_servico_servico);
-- ddl-end --

-- object: public.hospedagem | type: TABLE --
-- DROP TABLE IF EXISTS public.hospedagem CASCADE;
CREATE TABLE public.hospedagem (
	hospedagem_nome_propriedade varchar(50),
	hospedagem_tipo_acomodacao varchar(40),
	hospedagem_categoria varchar(40),
	id_servico_servico integer,
	id_destino_destino integer,

);
-- ddl-end --
ALTER TABLE public.hospedagem OWNER TO postgres;
-- ddl-end --

-- object: servico_fk | type: CONSTRAINT --
-- ALTER TABLE public.hospedagem DROP CONSTRAINT IF EXISTS servico_fk CASCADE;
ALTER TABLE public.hospedagem ADD CONSTRAINT servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: hospedagem_uq | type: CONSTRAINT --
-- ALTER TABLE public.hospedagem DROP CONSTRAINT IF EXISTS hospedagem_uq CASCADE;
ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_uq UNIQUE (id_servico_servico);
-- ddl-end --

-- object: public.transporte | type: TABLE --
-- DROP TABLE IF EXISTS public.transporte CASCADE;
CREATE TABLE public.transporte (
	transporte_tipo char(1),
	transporte_origem varchar(100),
	transporte_hora_partida time,
	id_servico_servico integer,
	id_destino_destino integer,

);
-- ddl-end --
ALTER TABLE public.transporte OWNER TO postgres;
-- ddl-end --

-- object: servico_fk | type: CONSTRAINT --
-- ALTER TABLE public.transporte DROP CONSTRAINT IF EXISTS servico_fk CASCADE;
ALTER TABLE public.transporte ADD CONSTRAINT servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: transporte_uq | type: CONSTRAINT --
-- ALTER TABLE public.transporte DROP CONSTRAINT IF EXISTS transporte_uq CASCADE;
ALTER TABLE public.transporte ADD CONSTRAINT transporte_uq UNIQUE (id_servico_servico);
-- ddl-end --

-- object: public.destino | type: TABLE --
-- DROP TABLE IF EXISTS public.destino CASCADE;
CREATE TABLE public.destino (
	id_destino serial NOT NULL,
	destino_pais varchar(30),
	destino_cidade varchar(40),
	CONSTRAINT destino_pk PRIMARY KEY (id_destino)
);
-- ddl-end --
ALTER TABLE public.destino OWNER TO postgres;
-- ddl-end --

-- object: destino_fk | type: CONSTRAINT --
-- ALTER TABLE public.transporte DROP CONSTRAINT IF EXISTS destino_fk CASCADE;
ALTER TABLE public.transporte ADD CONSTRAINT destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: destino_fk | type: CONSTRAINT --
-- ALTER TABLE public.hospedagem DROP CONSTRAINT IF EXISTS destino_fk CASCADE;
ALTER TABLE public.hospedagem ADD CONSTRAINT destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: destino_fk | type: CONSTRAINT --
-- ALTER TABLE public.atrativo DROP CONSTRAINT IF EXISTS destino_fk CASCADE;
ALTER TABLE public.atrativo ADD CONSTRAINT destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.reserva | type: TABLE --
-- DROP TABLE IF EXISTS public.reserva CASCADE;
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
-- ddl-end --
ALTER TABLE public.reserva OWNER TO postgres;
-- ddl-end --

-- object: servico_fk | type: CONSTRAINT --
-- ALTER TABLE public.reserva DROP CONSTRAINT IF EXISTS servico_fk CASCADE;
ALTER TABLE public.reserva ADD CONSTRAINT servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.cliente | type: TABLE --
-- DROP TABLE IF EXISTS public.cliente CASCADE;
CREATE TABLE public.cliente (
	id_cliente serial NOT NULL,
	cliente_nome varchar(100),
	cliente_cpf varchar(11),
	cliente_email varchar(50),
	CONSTRAINT cliente_pk PRIMARY KEY (id_cliente)
);
-- ddl-end --
ALTER TABLE public.cliente OWNER TO postgres;
-- ddl-end --

-- object: cliente_fk | type: CONSTRAINT --
-- ALTER TABLE public.reserva DROP CONSTRAINT IF EXISTS cliente_fk CASCADE;
ALTER TABLE public.reserva ADD CONSTRAINT cliente_fk FOREIGN KEY (id_cliente_cliente)
REFERENCES public.cliente (id_cliente) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --


