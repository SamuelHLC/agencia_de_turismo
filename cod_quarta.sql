-- Define o caminho de busca padrão para o esquema "public"
SET search_path TO pg_catalog,public;

--------------------------------------------------------
-- ETAPA 1 – MODELAGEM E CRIAÇÃO DO BANCO (DDL)
--------------------------------------------------------

-- Revogação de privilégios públicos para controle de acesso mais restrito
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;

-- DDL: Fornecedor
CREATE TABLE public.fornecedor (
	id_fornecedor serial NOT NULL,
	fornecedor_nome varchar(50),
	fornecedor_tipo varchar(50),
	fornecedor_status char,
	CONSTRAINT fornecedor_pk PRIMARY KEY (id_fornecedor)
);

-- DDL: Cliente
CREATE TABLE public.cliente (
	id_cliente serial NOT NULL,
	cliente_nome varchar(100),
	cliente_cpf varchar(15),
	cliente_email varchar(50),
	CONSTRAINT cliente_pk PRIMARY KEY (id_cliente)
);

-- DDL: Destino
CREATE TABLE public.destino (
	id_destino serial NOT NULL,
	destino_pais varchar(30),
	destino_cidade varchar(40),
	CONSTRAINT destino_pk PRIMARY KEY (id_destino)
);

-- DDL: Serviço
CREATE TABLE public.servico (
	id_servico serial NOT NULL,
	servico_nome varchar(30),
	servico_preco_base numeric(10,2),
	servico_tipo varchar(30),
	id_fornecedor_fornecedor integer,
	CONSTRAINT servico_pk PRIMARY KEY (id_servico)
);

-- FK Serviço → Fornecedor
ALTER TABLE public.servico ADD CONSTRAINT fornecedor_fk FOREIGN KEY (id_fornecedor_fornecedor)
REFERENCES public.fornecedor (id_fornecedor) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- DDL: Reserva
DROP TABLE IF EXISTS public.reserva CASCADE;
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

-- FK Reserva → Serviço
ALTER TABLE public.reserva ADD CONSTRAINT reserva_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- FK Reserva → Cliente
ALTER TABLE public.reserva ADD CONSTRAINT reserva_cliente_fk FOREIGN KEY (id_cliente_cliente)
REFERENCES public.cliente (id_cliente) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- DDL: Transporte
DROP TABLE IF EXISTS public.transporte CASCADE;
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

-- FK Transporte → Serviço
ALTER TABLE public.transporte ADD CONSTRAINT transporte_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- FK Transporte → Destino
ALTER TABLE public.transporte ADD CONSTRAINT transporte_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- DDL: Hospedagem
DROP TABLE IF EXISTS public.hospedagem CASCADE;
CREATE TABLE public.hospedagem (
	hospedagem_nome_propriedade varchar(50),
	hospedagem_tipo_acomodacao varchar(40),
	hospedagem_categoria varchar(40),
	id_servico_servico integer,
	id_destino_destino integer
);

-- FK Hospedagem → Serviço
ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- FK Hospedagem → Destino
ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_uq UNIQUE (id_servico_servico);

-- DDL: Atrativo
DROP TABLE IF EXISTS public.atrativo CASCADE;
CREATE TABLE public.atrativo (
	atrativo_nome varchar(50),
	atrativo_horario_funcionando time,
	atrativo_tipo varchar(30),
	id_servico_servico integer,
	id_destino_destino integer
);

-- FK Atrativo → Serviço
ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- FK Atrativo → Destino
ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_uq UNIQUE (id_servico_servico);

--------------------------------------------------------
-- ETAPA 2 – POPULAÇÃO DE DADOS (DML)
--------------------------------------------------------

-- População: Clientes
TRUNCATE public.cliente RESTART IDENTITY CASCADE;
INSERT INTO public.cliente (cliente_nome, cliente_cpf, cliente_email) VALUES
('Ana Beatriz Silva','123.456.789-01','ana.silva@email.com'),
('Bruno Henrique Costa','234.567.890-12','bruno.costa@email.com'),
('Camila Rocha Almeida','345.678.901-23','camila.almeida@email.com'),
('Daniel Ferreira Souza','456.789.012-34','daniel.souza@email.com'),
('Eduardo Lima Pereira','567.890.123-45','eduardo.pereira@email.com'),
('Fernanda Oliveira Melo','678.901.234-56','fernanda.melo@email.com'),
('Gustavo Martins Ramos','789.012.345-67','gustavo.ramos@email.com'),
('Helena Duarte Cardoso','890.123.456-78','helena.cardoso@email.com'),
('Igor Nunes Batista','901.234.567-89','igor.batista@email.com'),
('Juliana Pinto Azevedo','012.345.678-90','juliana.azevedo@email.com');

-- População: Destinos
TRUNCATE public.destino RESTART IDENTITY CASCADE;
INSERT INTO public.destino (destino_pais, destino_cidade) VALUES
('Brasil','Rio de Janeiro'),
('Argentina','Buenos Aires'),
('Chile','Santiago'),
('Estados Unidos','Nova York'),
('França','Paris'),
('Itália','Roma'),
('Japão','Tóquio'),
('Canadá','Toronto'),
('Portugal','Lisboa'),
('Austrália','Sydney');

-- População: Fornecedores
TRUNCATE public.fornecedor RESTART IDENTITY CASCADE;
INSERT INTO public.fornecedor (fornecedor_nome, fornecedor_tipo, fornecedor_status) VALUES
('Hotel Sol & Mar','Hospedagem','A'),
('Voa Rápido S/A','Transporte Aéreo','A'),
('Guia Tur SP','Agência Turismo','A'),
('Pousada da Montanha','Hospedagem','A'),
('RodoExpresso BR','Transporte Rodoviário','A'),
('Museum Corp','Atração Cultural','A'),
('Tokyo Rail','Transporte Ferroviário','A'),
('Hostel Amigo','Hospedagem','A'),
('Tours Europa','Agência Turismo','A'),
('Ferry Sydney','Transporte Marítimo','A');

-- População: Serviços
TRUNCATE public.servico RESTART IDENTITY CASCADE;
INSERT INTO public.servico (servico_nome, servico_tipo, id_fornecedor_fornecedor, servico_preco_base) VALUES
('Diária Luxo Rio','Hospedagem',1, 350.00),
('Voo SP-Paris','Transporte',2, 1200.00),
('City Tour SP','Atrativo',3, 80.00),
('Chalé Simples','Hospedagem',4, 220.00),
('Ônibus RJ-MG','Transporte',5, 150.00),
('Ingresso Arte','Atrativo',6, 60.00),
('Trem-Bala Tóquio','Transporte',7, 450.00),
('Cama em Dorm.','Hospedagem',8, 90.00),
('Tour Roma Coliseu','Atrativo',9, 120.00),
('Passeio Baía','Transporte',10, 250.00),
('Diária Luxo Rio 2','Hospedagem',1, 380.00),
('Chalé Simples 2','Hospedagem',4, 250.00),
('Cama em Dorm. 1','Hospedagem',8, 100.00),
('Apartamento','Hospedagem',1, 300.00),
('Suíte Presid.','Hospedagem',4, 600.00),
('Cama em Dorm. 2','Hospedagem',8, 95.00),
('Quarto Casal','Hospedagem',1, 280.00),
('Bangalô','Hospedagem',4, 320.00),
('Cama em Dorm. 3','Hospedagem',8, 85.00),
('Diária Padrão','Hospedagem',1, 200.00),
('Translado Aeroporto','Transporte',3, 75.00);

-- População: Transporte
TRUNCATE public.transporte RESTART IDENTITY CASCADE;
INSERT INTO transporte (tipo, origem, destino, data_partida, data_chegada, preco, id_servico_servico, id_destino_destino) VALUES
('Ônibus','São Paulo','Rio de Janeiro','2025-01-10','2025-01-10',150.00,5,1),
('Avião','Brasília','Nova York','2025-02-05','2025-02-05',750.00,2,4),
('Navio','Rio de Janeiro','Buenos Aires','2025-03-12','2025-03-15',2200.00,10,2),
('Metrô','Rio de Janeiro','Rio de Janeiro','2025-01-01','2025-01-01',4.40,21,1),
('Uber','Santiago','Santiago','2025-01-18','2025-01-18',22.50,3,3),
('Táxi','Paris','Paris','2025-04-10','2025-04-10',35.90,6,5),
('Trem','Tóquio','Tóquio','2025-05-03','2025-05-03',120.00,7,7),
('Avião','Toronto','São Paulo','2025-06-20','2025-06-20',980.00,2,8),
('Trem','Lisboa','Porto','2025-07-14','2025-07-14',89.90,7,9),
('Navio','Sydney','Sydney','2025-08-02','2025-08-02',300.00,10,10),
('Avião','Nova York','Paris','2025-09-01','2025-09-01',1100.00,2,5);

-- População: Reservas
TRUNCATE public.reserva RESTART IDENTITY CASCADE;
INSERT INTO reserva (reserva_data,reserva_data_inicio,reserva_valor_total,reserva_status,id_servico_servico,id_cliente_cliente)
VALUES
('2025-01-01','2025-01-05',350.00,'A',1,1), -- Ativa
('2025-01-03','2025-01-04',200.00,'A',2,1), -- Ativa
('2025-02-10','2025-02-12',500.00,'C',3,2), -- Cancelada
('2025-03-15','2025-03-16',150.00,'A',1,3), -- Ativa
('2025-03-20','2025-03-22',320.00,'F',4,4), -- Finalizada
('2025-04-01','2025-04-10',1200.00,'A',2,5), -- Ativa
('2025-04-05','2025-04-07',450.00,'C',3,6), -- Cancelada
('2025-05-02','2025-05-03',180.00,'A',1,7), -- Ativa
('2025-05-10','2025-05-11',220.00,'F',4,8), -- Finalizada
('2025-06-01','2025-06-05',900.00,'A',5,9); -- Ativa

-- População: Atrativo
TRUNCATE public.atrativo RESTART IDENTITY CASCADE;
INSERT INTO atrativo VALUES
('Praia Central','08:00','Natural',3,1),
('Museu Histórico','09:00','Cultural',6,1),
('Parque das Aves','07:30','Natural',9,2),
('Mirante da Serra','10:00','Paisagem',11,2),
('Aquário Azul','08:30','Educativo',12,3),
('Centro Gastronômico','18:00','Culinária',13,3),
('Trilha da Mata','06:00','Aventura',14,4),
('Cachoeira Bela Vista','07:00','Natural',15,4),
('Planetário Municipal','14:00','Cultural',16,5),
('Feira de Artesanato','10:00','Comércio',17,5);

-- População: Hospedagem
TRUNCATE public.hospedagem RESTART IDENTITY CASCADE;
INSERT INTO hospedagem VALUES
('Hotel Copacabana','Hotel','Luxo',1,1),
('Pousada do Sol','Pousada','Simples',4,2),
('Hostel Central','Hostel','Econômico',8,3),
('Residencial Plaza','Apartamento','Standard',14,4),
('Suítes Royal','Hotel','Luxo',15,5),
('Alojamento Simples','Hostel','Econômico',16,6),
('Hotel Tokyo','Hotel','Standard',17,7),
('Cabana da Floresta','Bangalô','Rústico',18,8),
('Hostel Lisboa','Hostel','Econômico',19,9),
('Apartamento Sydney','Apartamento','Standard',20,10);

--------------------------------------------------------
-- ETAPA 2 – CONSULTAS SQL
--------------------------------------------------------

-- 2. Consultas SQL Iniciais (Responsáveis: Caio, Alex)
SELECT id_cliente, cliente_nome, cliente_email
FROM cliente
ORDER BY cliente_nome;

SELECT id_transporte, tipo, origem, destino, preco
FROM transporte
WHERE preco > 500
ORDER BY preco DESC;

SELECT atrativo_nome, atrativo_horario_funcionando
FROM atrativo
WHERE atrativo_horario_funcionando < '09:00'
ORDER BY atrativo_horario_funcionando;

-- 3. Consultas com JOIN (Responsáveis: Marcone, Caio)
SELECT r.id_reserva, c.cliente_nome, r.reserva_data, r.reserva_valor_total
FROM reserva r
INNER JOIN cliente c ON r.id_cliente_cliente = c.id_cliente;

SELECT s.id_servico, s.servico_nome, s.servico_tipo, f.fornecedor_nome
FROM servico s
LEFT JOIN fornecedor f ON s.id_fornecedor_fornecedor = f.id_fornecedor;

SELECT h.hospedagem_nome_propriedade, h.hospedagem_categoria, d.destino_cidade, d.destino_pais
FROM hospedagem h
JOIN destino d ON h.id_destino_destino = d.id_destino;

-- 4. Consultas Complexas (Responsáveis: João, Tiago)
-- Subconsulta no WHERE
SELECT c.cliente_nome, r.reserva_valor_total
FROM reserva r
JOIN cliente c ON r.id_cliente_cliente = c.id_cliente
WHERE r.reserva_valor_total > (SELECT AVG(reserva_valor_total) FROM reserva)
ORDER BY r.reserva_valor_total DESC;

-- Subconsulta no FROM
SELECT t.tipo, t.preco, d.destino_cidade
FROM transporte t
JOIN destino d ON t.id_destino_destino = d.id_destino
JOIN (
    SELECT id_destino_destino, MAX(preco) AS preco_max
    FROM transporte
    GROUP BY id_destino_destino
) m ON m.id_destino_destino = t.id_destino_destino AND m.preco_max = t.preco
ORDER BY d.destino_cidade;

-- Subconsulta no SELECT
SELECT c.cliente_nome,
       (SELECT COUNT(*) FROM reserva r WHERE r.id_cliente_cliente = c.id_cliente AND r.reserva_status='A') AS total_reservas_ativas,
       (SELECT SUM(reserva_valor_total) FROM reserva r WHERE r.id_cliente_cliente = c.id_cliente) AS valor_total_gasto
FROM cliente c
WHERE c.id_cliente IN (
    SELECT id_cliente_cliente
    FROM reserva
    WHERE reserva_status='A'
)
ORDER BY valor_total_gasto DESC;

-- 4. Consultas com GROUP BY e HAVING (Responsáveis: Samuel, Alex)
SELECT reserva_status, COUNT(*) AS total_reservas_por_status
FROM reserva
GROUP BY reserva_status
ORDER BY total_reservas_por_status DESC;

SELECT tipo, AVG(preco) AS preco_medio
FROM transporte
GROUP BY tipo
ORDER BY preco_medio DESC;

SELECT c.cliente_nome,
       SUM(r.reserva_valor_total) AS total_gasto
FROM reserva r
JOIN cliente c ON c.id_cliente = r.id_cliente_cliente
GROUP BY c.cliente_nome
HAVING SUM(r.reserva_valor_total) > 500
ORDER BY total_gasto DESC;

--------------------------------------------------------
-- ETAPA 3 – RECURSOS AVANÇADOS
--------------------------------------------------------

-- 3.1 Views (Visões)
-- RESPONSÁVEIS: Caio Vinícius e João Victor

-- View Simples (já existia no contexto de 3.8, mas também conta aqui)
CREATE OR REPLACE VIEW public.vw_cliente_resumo AS
SELECT id_cliente, cliente_nome, cliente_email
FROM public.cliente;

-- View 2: View com JOIN e Agregações (Faturamento por Cliente Finalizado)
CREATE OR REPLACE VIEW public.vw_faturamento_por_cliente AS
SELECT
    c.cliente_nome,
    COUNT(r.id_reserva) AS total_reservas,
    SUM(r.reserva_valor_total) AS valor_total_gasto
FROM
    public.cliente c
JOIN
    public.reserva r ON c.id_cliente = r.id_cliente_cliente
WHERE
    r.reserva_status = 'F'
GROUP BY
    c.cliente_nome
ORDER BY
    valor_total_gasto DESC;

-- View 3: View com Subconsulta (Serviços com preço acima da média do seu tipo)
CREATE OR REPLACE VIEW public.vw_servicos_acima_media AS
SELECT
    s.servico_nome,
    s.servico_tipo,
    s.servico_preco_base
FROM
    public.servico s
WHERE
    s.servico_preco_base > (
        SELECT AVG(s2.servico_preco_base)
        FROM public.servico s2
        WHERE s2.servico_tipo = s.servico_tipo
    )
ORDER BY
    s.servico_preco_base DESC;

-- 3.2 Triggers (Gatilhos)
-- RESPONSÁVEIS: Álex de Almeida e Samuel Henrique

-- Criação da Tabela de Auditoria
DROP TABLE IF EXISTS public.tb_auditoria;
CREATE TABLE public.tb_auditoria (
    id_log SERIAL PRIMARY KEY,
    tabela_alterada VARCHAR(50),
    acao VARCHAR(20),
    usuario VARCHAR(50),
    data_hora TIMESTAMP DEFAULT NOW(),
    dados_antigos TEXT,
    dados_novos TEXT
);

-- Trigger 1: Auditoria de Reservas (AFTER INSERT/UPDATE/DELETE) - Código Completo
CREATE OR REPLACE FUNCTION fn_auditoria_reserva()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.tb_auditoria (tabela_alterada, acao, usuario, dados_antigos, dados_novos)
    VALUES (
        'reserva',
        TG_OP,
        session_user,
        CASE WHEN TG_OP = 'DELETE' THEN ROW(OLD.*)::TEXT ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN ROW(NEW.*)::TEXT ELSE NULL END
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auditoria_reserva ON public.reserva;
CREATE TRIGGER trg_auditoria_reserva
AFTER INSERT OR UPDATE OR DELETE ON public.reserva
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_reserva();

-- Trigger 2: Validação de Regra de Negócio (BEFORE INSERT/UPDATE: Valor Positivo)
CREATE OR REPLACE FUNCTION fn_validacao_reserva_valor()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.reserva_valor_total <= 0 THEN
        RAISE EXCEPTION 'Valor total da reserva deve ser positivo.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validacao_reserva_valor ON public.reserva;
CREATE TRIGGER trg_validacao_reserva_valor
BEFORE INSERT OR UPDATE ON public.reserva
FOR EACH ROW EXECUTE FUNCTION fn_validacao_reserva_valor();


-- 3.3 Procedures e Functions
-- RESPONSÁVEIS: Tiago Geraldo e Marcone Oliveira

-- Procedure 1: inserir_reserva
CREATE OR REPLACE PROCEDURE public.inserir_reserva(
    p_reserva_data DATE,
    p_reserva_data_inicio DATE,
    p_reserva_valor_total NUMERIC,
    p_reserva_status CHAR,
    p_id_servico_servico INT,
    p_id_cliente_cliente INT,
    OUT p_new_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.reserva (
        reserva_data, reserva_data_inicio, reserva_valor_total, reserva_status,
        id_servico_servico, id_cliente_cliente
    ) VALUES (
        p_reserva_data, p_reserva_data_inicio, p_reserva_valor_total, p_reserva_status,
        p_id_servico_servico, p_id_cliente_cliente
    )
    RETURNING id_reserva INTO p_new_id;
END;
$$;

-- Procedure 2: cancelar_reserva
CREATE OR REPLACE PROCEDURE public.cancelar_reserva(
    p_id_reserva INT,
    OUT p_result BOOLEAN,
    OUT p_message TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status CHAR;
BEGIN
    SELECT reserva_status INTO v_status
    FROM public.reserva
    WHERE id_reserva = p_id_reserva;

    IF NOT FOUND THEN
        p_result := FALSE;
        p_message := 'Reserva não encontrada';
        RETURN;
    END IF;

    IF v_status = 'A' THEN
        UPDATE public.reserva
        SET reserva_status = 'C'
        WHERE id_reserva = p_id_reserva;
        p_result := TRUE;
        p_message := 'Reserva cancelada com sucesso';
    ELSE
        p_result := FALSE;
        p_message := concat('Não é possível cancelar. Status atual: ', v_status);
    END IF;
END;
$$;

-- Function 1: calcular_total_gasto_cliente
CREATE OR REPLACE FUNCTION public.calcular_total_gasto_cliente(p_id_cliente INT)
RETURNS NUMERIC
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(reserva_valor_total), 0)
    INTO v_total
    FROM public.reserva
    WHERE id_cliente_cliente = p_id_cliente;

    RETURN v_total;
END;
$$;

-- 3.4 Índices e Otimização de Consultas
-- RESPONSÁVEIS: Caio Vinícius e João Victor

-- Índice Simples: Acelerar buscas por nome de fornecedor (coluna 'fornecedor_nome')
CREATE INDEX idx_fornecedor_nome ON public.fornecedor (fornecedor_nome);

-- Índice Composto: Otimizar consultas em Reserva (status e data de início)
CREATE INDEX idx_reserva_status_data_inicio ON public.reserva (reserva_status, reserva_data_inicio);

-- Índice Único: Garantir unicidade no CPF do cliente
CREATE UNIQUE INDEX uq_cliente_cpf ON public.cliente (cliente_cpf);


-- 3.5 Etapas do Processamento de Consultas e 3.9 Desempenho e Tuning
-- RESPONSÁVEIS: Caio Vinícius e João Victor
-- (Comandos EXPLAIN ANALYZE para análise no relatório)

-- Consulta 1 (Complexa com JOIN e Subconsulta)
EXPLAIN ANALYZE
SELECT t.tipo, t.preco, d.destino_cidade
FROM transporte t
JOIN destino d ON t.id_destino_destino = d.id_destino
WHERE t.preco = (
    SELECT MAX(preco)
    FROM transporte t2
    WHERE t2.id_destino_destino = t.id_destino_destino
)
ORDER BY d.destino_cidade;

-- Consulta 2 (Consulta usando o Índice Composto criado acima)
EXPLAIN ANALYZE
SELECT r.id_reserva, c.cliente_nome, r.reserva_data_inicio
FROM public.reserva r
JOIN public.cliente c ON r.id_cliente_cliente = c.id_cliente
WHERE
    r.reserva_status = 'A'
    AND r.reserva_data_inicio > '2025-04-01';


-- 3.6 Transações e Controle de Concorrência e 3.7 Teoria da Serialização
-- RESPONSÁVEIS: Álex de Almeida e Samuel Henrique
-- (Blocos de comandos para demonstração no SGBD)

-- Cenário de Transação 1: Atualização Atômica (Atualizar Status e Gravar Log Interno)
BEGIN TRANSACTION;
  UPDATE public.reserva SET reserva_status = 'F' WHERE id_reserva = 1;
  -- Simulação de escrita em outra tabela de controle (poderia ser a tb_auditoria, mas usamos um UPDATE simples)
  UPDATE public.cliente SET cliente_email = 'finalizada_' || cliente_email WHERE id_cliente = 1;
COMMIT;
-- Para forçar ROLLBACK em caso de erro:
-- BEGIN TRANSACTION;
--   UPDATE public.reserva SET reserva_status = 'F' WHERE id_reserva = 999; -- Erro de ID
-- ROLLBACK;

-- Cenário de Transação 2: Controle de Isolamento (Simulação de Lock)
-- Na SESSÃO 1:
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;
    -- Bloqueia o registro 1
    SELECT * FROM public.reserva WHERE id_reserva = 2 FOR UPDATE;
    -- Faça um UPDATE simples
    UPDATE public.reserva SET reserva_valor_total = 1000.00 WHERE id_reserva = 2;
    -- A SESSÃO 2 tentará um UPDATE e ficará travada aqui
    -- Após a SESSÃO 1 fazer COMMIT, a SESSÃO 2 será liberada
COMMIT;


-- 3.8 Segurança e Controle de Acesso
-- RESPONSÁVEIS: Tiago Geraldo e Marcone Oliveira

-- Criar roles (perfis)
CREATE ROLE role_readonly NOINHERIT;
CREATE ROLE role_writer NOINHERIT;
CREATE ROLE role_admin NOINHERIT;

-- Criar 3 usuários (Substitua as senhas)
CREATE USER app_readonly WITH PASSWORD '<SENHA_APP_READONLY>';
CREATE USER app_writer WITH PASSWORD '<SENHA_APP_WRITER>';
CREATE USER admin_ops WITH PASSWORD '<SENHA_ADMIN_OPS>';

-- Atribuir usuários às roles
GRANT role_readonly TO app_readonly;
GRANT role_writer TO app_writer;
GRANT role_admin TO admin_ops;

-- View restrita (vw_cliente_resumo) para auditoria e controle
CREATE OR REPLACE VIEW public.vw_cliente_resumo AS
SELECT id_cliente, cliente_nome, cliente_email
FROM public.cliente;

-- Permissões para role_readonly
GRANT USAGE ON SCHEMA public TO role_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role_readonly;
GRANT EXECUTE ON FUNCTION public.calcular_total_gasto_cliente(INT) TO role_readonly;
GRANT SELECT ON public.vw_faturamento_por_cliente TO role_readonly;

-- Permissões para role_writer
GRANT USAGE ON SCHEMA public TO role_writer;
GRANT SELECT, INSERT, UPDATE ON TABLE public.reserva TO role_writer;
GRANT SELECT ON TABLE public.servico TO role_writer;
GRANT EXECUTE ON PROCEDURE public.inserir_reserva(DATE,DATE,NUMERIC,CHAR,INT,INT,OUT INT) TO role_writer;
GRANT EXECUTE ON PROCEDURE public.cancelar_reserva(INT,OUT BOOLEAN,OUT TEXT) TO role_writer;
REVOKE UPDATE, DELETE ON public.cliente FROM role_writer; -- Restrição de acesso

-- Permissões para role_admin
GRANT USAGE ON SCHEMA public TO role_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO role_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO role_admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO role_admin;

-- Garantir que futuras tabelas tenham privilégios controlados
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO role_readonly;
