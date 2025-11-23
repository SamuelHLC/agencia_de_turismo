-- PROJETO INTEGRADOR: SISTEMA DE BANCO DE DADOS (POSTGRESQL)
-- TEMA: AGÊNCIA DE VIAGENS
-- VERSÃO FINAL E COMPLETA: DDL + DML + DQL + RECURSOS AVANÇADOS + TESTES

-- Configuração inicial
SET search_path TO pg_catalog,public;

--------------------------------------------------------
-- ETAPA 1 – MODELAGEM E CRIAÇÃO DO BANCO (DDL)
--------------------------------------------------------

-- Limpeza preventiva de objetos para permitir re-execução limpa
DROP VIEW IF EXISTS public.vw_cliente_resumo CASCADE;
DROP VIEW IF EXISTS public.vw_faturamento_por_cliente CASCADE;
DROP VIEW IF EXISTS public.vw_servicos_acima_media CASCADE;
DROP TABLE IF EXISTS public.tb_auditoria CASCADE;
DROP TABLE IF EXISTS public.reserva CASCADE;
DROP TABLE IF EXISTS public.transporte CASCADE;
DROP TABLE IF EXISTS public.hospedagem CASCADE;
DROP TABLE IF EXISTS public.atrativo CASCADE;
DROP TABLE IF EXISTS public.servico CASCADE;
DROP TABLE IF EXISTS public.destino CASCADE;
DROP TABLE IF EXISTS public.cliente CASCADE;
DROP TABLE IF EXISTS public.fornecedor CASCADE;

-- Revogação de privilégios públicos (Segurança Base)
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;

-- 1. Tabela Fornecedor
CREATE TABLE public.fornecedor (
	id_fornecedor serial NOT NULL,
	fornecedor_nome varchar(50) NOT NULL,
	fornecedor_tipo varchar(50),
	fornecedor_status char DEFAULT 'A',
	CONSTRAINT fornecedor_pk PRIMARY KEY (id_fornecedor)
);

-- 2. Tabela Cliente (Contém dados sensíveis)
CREATE TABLE public.cliente (
	id_cliente serial NOT NULL,
	cliente_nome varchar(100) NOT NULL,
	cliente_cpf varchar(15) UNIQUE NOT NULL, -- Dado Sensível
	cliente_email varchar(50),
	CONSTRAINT cliente_pk PRIMARY KEY (id_cliente)
);

-- 3. Tabela Destino
CREATE TABLE public.destino (
	id_destino serial NOT NULL,
	destino_pais varchar(30) NOT NULL,
	destino_cidade varchar(40) NOT NULL,
	CONSTRAINT destino_pk PRIMARY KEY (id_destino)
);

-- 4. Tabela Serviço
CREATE TABLE public.servico (
	id_servico serial NOT NULL,
	servico_nome varchar(50) NOT NULL,
	servico_preco_base numeric(10,2) NOT NULL,
	servico_tipo varchar(30),
	id_fornecedor_fornecedor integer,
	CONSTRAINT servico_pk PRIMARY KEY (id_servico),
	CONSTRAINT fornecedor_fk FOREIGN KEY (id_fornecedor_fornecedor)
		REFERENCES public.fornecedor (id_fornecedor) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 5. Tabela Reserva (Central)
CREATE TABLE public.reserva (
	id_reserva serial NOT NULL,
	reserva_data date DEFAULT CURRENT_DATE,
	reserva_data_inicio date NOT NULL,
	reserva_valor_total numeric(10,2) NOT NULL,
	reserva_status char(1) DEFAULT 'A', -- A: Ativa, C: Cancelada, F: Finalizada
	id_servico_servico integer,
	id_cliente_cliente integer,
	CONSTRAINT reserva_pk PRIMARY KEY (id_reserva),
	CONSTRAINT reserva_servico_fk FOREIGN KEY (id_servico_servico)
		REFERENCES public.servico (id_servico) ON UPDATE CASCADE,
	CONSTRAINT reserva_cliente_fk FOREIGN KEY (id_cliente_cliente)
		REFERENCES public.cliente (id_cliente) ON UPDATE CASCADE
);

-- 6. Tabela Transporte (Especialização)
CREATE TABLE public.transporte (
	id_transporte SERIAL PRIMARY KEY,
	tipo VARCHAR(50),
	origem VARCHAR(100),
	destino VARCHAR(100),
	data_partida DATE,
	data_chegada DATE,
	preco DECIMAL(10,2),
	id_servico_servico INTEGER,
	id_destino_destino INTEGER,
	CONSTRAINT transporte_servico_fk FOREIGN KEY (id_servico_servico)
		REFERENCES public.servico (id_servico),
	CONSTRAINT transporte_destino_fk FOREIGN KEY (id_destino_destino)
		REFERENCES public.destino (id_destino)
);

-- 7. Tabela Hospedagem (Especialização)
CREATE TABLE public.hospedagem (
	id_hospedagem SERIAL PRIMARY KEY,
	hospedagem_nome_propriedade varchar(50),
	hospedagem_tipo_acomodacao varchar(40),
	hospedagem_categoria varchar(40),
	id_servico_servico integer,
	id_destino_destino integer,
	CONSTRAINT hospedagem_servico_fk FOREIGN KEY (id_servico_servico)
		REFERENCES public.servico (id_servico),
	CONSTRAINT hospedagem_destino_fk FOREIGN KEY (id_destino_destino)
		REFERENCES public.destino (id_destino)
);

-- 8. Tabela Atrativo (Especialização)
CREATE TABLE public.atrativo (
	id_atrativo SERIAL PRIMARY KEY,
	atrativo_nome varchar(50),
	atrativo_horario_funcionando time,
	atrativo_tipo varchar(30),
	id_servico_servico integer,
	id_destino_destino integer,
	CONSTRAINT atrativo_servico_fk FOREIGN KEY (id_servico_servico)
		REFERENCES public.servico (id_servico),
	CONSTRAINT atrativo_destino_fk FOREIGN KEY (id_destino_destino)
		REFERENCES public.destino (id_destino)
);

-- Constraint Unique Adicionais (Requisito do seu código original)
ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_uq UNIQUE (id_servico_servico);
ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_uq UNIQUE (id_servico_servico);

-- Tabela de Auditoria (Necessária para os Triggers da Etapa 3)
CREATE TABLE public.tb_auditoria (
    id_log SERIAL PRIMARY KEY,
    tabela_alterada VARCHAR(50),
    acao VARCHAR(20),
    usuario VARCHAR(50),
    data_hora TIMESTAMP DEFAULT NOW(),
    dados_antigos TEXT,
    dados_novos TEXT
);

--------------------------------------------------------
-- ETAPA 2 – POPULAÇÃO DE DADOS (DML)
--------------------------------------------------------

-- Clientes
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

-- Destinos
INSERT INTO public.destino (destino_pais, destino_cidade) VALUES
('Brasil','Rio de Janeiro'), ('Argentina','Buenos Aires'), ('Chile','Santiago'),
('Estados Unidos','Nova York'), ('França','Paris'), ('Itália','Roma'),
('Japão','Tóquio'), ('Canadá','Toronto'), ('Portugal','Lisboa'), ('Austrália','Sydney');

-- Fornecedores
INSERT INTO public.fornecedor (fornecedor_nome, fornecedor_tipo, fornecedor_status) VALUES
('Hotel Sol & Mar','Hospedagem', 'A'), ('Voa Rápido S/A','Transporte Aéreo', 'A'),
('Guia Tur SP','Agência Turismo', 'A'), ('Pousada da Montanha','Hospedagem', 'A'),
('RodoExpresso BR','Transporte Rodoviário', 'A'), ('Museum Corp','Atração Cultural', 'A'),
('Tokyo Rail','Transporte Ferroviário', 'A'), ('Hostel Amigo','Hospedagem', 'A'),
('Tours Europa','Agência Turismo', 'A'), ('Ferry Sydney','Transporte Marítimo', 'A');

-- Serviços
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

-- Reservas (População Inicial)
INSERT INTO public.reserva (reserva_data_inicio, reserva_valor_total, reserva_status, id_servico_servico, id_cliente_cliente) VALUES
('2025-01-05', 350.00, 'A', 1, 1),
('2025-01-04', 200.00, 'A', 2, 1),
('2025-02-12', 500.00, 'C', 3, 2),
('2025-03-16', 150.00, 'A', 4, 3),
('2025-03-22', 320.00, 'F', 5, 4),
('2025-04-10', 1200.00, 'A', 2, 5),
('2025-04-07', 450.00, 'C', 3, 6),
('2025-05-03', 180.00, 'A', 1, 7),
('2025-05-11', 220.00, 'F', 4, 8),
('2025-06-05', 900.00, 'A', 5, 9);

-- Transporte
INSERT INTO public.transporte (tipo, origem, destino, data_partida, data_chegada, preco, id_servico_servico, id_destino_destino) VALUES
('Ônibus','São Paulo','Rio de Janeiro','2025-01-10','2025-01-10',150.00,5,1),
('Avião','Brasília','Nova York','2025-02-05','2025-02-05',750.00,2,4),
('Navio','Rio de Janeiro','Buenos Aires','2025-03-12','2025-03-15',2200.00,10,2),
('Metrô','Rio de Janeiro','Rio de Janeiro','2025-01-01','2025-01-01',4.40,21,1),
('Uber','Santiago','Santiago','2025-01-18','2025-01-18',22.50,3,3),
('Táxi','Paris','Paris','2025-04-10','2025-04-10',35.90,6,5),
('Trem','Tóquio','Tóquio','2025-05-03','2025-05-03',120.00,7,7),
('Avião','Toronto','São Paulo','2025-06-20','2025-06-20',980.00,2,8),
('Trem','Lisboa','Porto','2025-07-14','2025-07-14',89.90,5,9),
('Navio','Sydney','Sydney','2025-08-02','2025-08-02',300.00,10,10);

-- Hospedagem
INSERT INTO public.hospedagem (hospedagem_nome_propriedade, hospedagem_tipo_acomodacao, hospedagem_categoria, id_servico_servico, id_destino_destino) VALUES
('Hotel Copacabana','Hotel','Luxo',11,1),
('Pousada do Sol','Pousada','Simples',12,2),
('Hostel Central','Hostel','Econômico',13,3),
('Residencial Plaza','Apartamento','Standard',14,4),
('Suítes Royal','Hotel','Luxo',15,5),
('Alojamento Simples','Hostel','Econômico',16,6),
('Hotel Tokyo','Hotel','Standard',17,7),
('Cabana da Floresta','Bangalô','Rústico',18,8),
('Hostel Lisboa','Hostel','Econômico',19,9),
('Apartamento Sydney','Apartamento','Standard',20,10);

-- Atrativo
INSERT INTO public.atrativo (atrativo_nome, atrativo_horario_funcionando, atrativo_tipo, id_servico_servico, id_destino_destino) VALUES
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

--------------------------------------------------------
-- ETAPA 2 – CONSULTAS SQL (Requisito: Iniciais, JOIN, Agregação)
--------------------------------------------------------

-- 2.1 Consultas Iniciais
SELECT id_cliente, cliente_nome, cliente_email FROM cliente ORDER BY cliente_nome;
SELECT id_transporte, tipo, origem, destino, preco FROM transporte WHERE preco > 500 ORDER BY preco DESC;
SELECT atrativo_nome, atrativo_horario_funcionando FROM atrativo WHERE atrativo_horario_funcionando < '09:00';

-- 3.1 Joins
SELECT r.id_reserva, c.cliente_nome, r.reserva_data, r.reserva_valor_total
FROM reserva r INNER JOIN cliente c ON r.id_cliente_cliente = c.id_cliente;

SELECT s.id_servico, s.servico_nome, s.servico_tipo, f.fornecedor_nome
FROM servico s LEFT JOIN fornecedor f ON s.id_fornecedor_fornecedor = f.id_fornecedor;

-- 4.1 Consultas Complexas
-- Subconsulta no WHERE
SELECT c.cliente_nome, r.reserva_valor_total FROM reserva r JOIN cliente c ON r.id_cliente_cliente = c.id_cliente
WHERE r.reserva_valor_total > (SELECT AVG(reserva_valor_total) FROM reserva);

-- Subconsulta no FROM
SELECT t.tipo, t.preco, d.destino_cidade FROM transporte t JOIN destino d ON t.id_destino_destino = d.id_destino
JOIN (SELECT id_destino_destino, MAX(preco) AS preco_max FROM transporte GROUP BY id_destino_destino) m
ON m.id_destino_destino = t.id_destino_destino AND m.preco_max = t.preco;

-- Agregação
SELECT reserva_status, COUNT(*) AS total FROM reserva GROUP BY reserva_status;

--------------------------------------------------------
-- ETAPA 3 – RECURSOS AVANÇADOS
--------------------------------------------------------

-- 3.1 VIEWS (VISÕES)

-- 1. View Simples (Restrita/Auditoria - Oculta CPF)
CREATE OR REPLACE VIEW public.vw_cliente_resumo AS
SELECT id_cliente, cliente_nome, cliente_email
FROM public.cliente;

-- 2. View com JOIN e Agregação
CREATE OR REPLACE VIEW public.vw_faturamento_por_cliente AS
SELECT c.cliente_nome, COUNT(r.id_reserva) as qtd_reservas, SUM(r.reserva_valor_total) as total_gasto
FROM cliente c
JOIN reserva r ON c.id_cliente = r.id_cliente_cliente
WHERE r.reserva_status = 'F'
GROUP BY c.cliente_nome;

-- 3. View com Subconsulta
CREATE OR REPLACE VIEW public.vw_servicos_vip AS
SELECT s.servico_nome, s.servico_preco_base
FROM servico s
WHERE s.servico_preco_base > (SELECT AVG(servico_preco_base) FROM servico);


-- 3.2 TRIGGERS (GATILHOS)

-- Função do Trigger 1: Auditoria de Reservas
CREATE OR REPLACE FUNCTION fn_auditoria_reserva()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.tb_auditoria (tabela_alterada, acao, usuario, dados_antigos, dados_novos)
    VALUES (
        'reserva', TG_OP, current_user,
        CASE WHEN TG_OP = 'DELETE' THEN ROW(OLD.*)::TEXT ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN ROW(NEW.*)::TEXT ELSE NULL END
    );
    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditoria_reserva
AFTER INSERT OR UPDATE OR DELETE ON public.reserva
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_reserva();

-- Função do Trigger 2: Validação de Valor Positivo
CREATE OR REPLACE FUNCTION fn_validacao_valor()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.reserva_valor_total <= 0 THEN
        RAISE EXCEPTION 'O valor da reserva deve ser positivo.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validacao_reserva_valor
BEFORE INSERT OR UPDATE ON public.reserva
FOR EACH ROW EXECUTE FUNCTION fn_validacao_valor();


-- 3.3 PROCEDURES E FUNCTIONS

-- Procedure 1: Inserir Reserva
CREATE OR REPLACE PROCEDURE public.inserir_reserva(
    p_inicio DATE, p_valor NUMERIC, p_servico INT, p_cliente INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO public.reserva (reserva_data_inicio, reserva_valor_total, id_servico_servico, id_cliente_cliente)
    VALUES (p_inicio, p_valor, p_servico, p_cliente);
END;
$$;

-- Procedure 2: Cancelar Reserva
CREATE OR REPLACE PROCEDURE public.cancelar_reserva(p_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE public.reserva SET reserva_status = 'C' WHERE id_reserva = p_id;
END;
$$;

-- Function 1: Calcular Gasto Total
CREATE OR REPLACE FUNCTION public.calcular_total_gasto_cliente(p_id INT)
RETURNS NUMERIC LANGUAGE plpgsql AS $$
DECLARE v_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(reserva_valor_total), 0) INTO v_total FROM public.reserva WHERE id_cliente_cliente = p_id;
    RETURN v_total;
END;
$$;


-- 3.4 ÍNDICES E OTIMIZAÇÃO (ETAPA 3.9 INCLUSA)

-- Índice Simples
CREATE INDEX idx_fornecedor_nome ON public.fornecedor (fornecedor_nome);

-- Índice Composto
CREATE INDEX idx_reserva_status_data ON public.reserva (reserva_status, reserva_data_inicio);

-- Índice Único
CREATE UNIQUE INDEX idx_transporte_servico_id ON public.transporte (id_servico_servico);

-- Exemplo de EXPLAIN ANALYZE (Tuning)
EXPLAIN ANALYZE SELECT * FROM reserva WHERE reserva_status = 'A';


-- 3.8 SEGURANÇA E CONTROLE DE ACESSO

-- Criar Roles
DROP ROLE IF EXISTS role_admin, role_writer, role_readonly;
CREATE ROLE role_admin;
CREATE ROLE role_writer;
CREATE ROLE role_readonly;

-- Criar Usuários (Substitua as senhas)
DROP USER IF EXISTS app_admin, app_writer, app_readonly;
CREATE USER app_admin WITH PASSWORD 'admin123';
CREATE USER app_writer WITH PASSWORD 'writer123';
CREATE USER app_readonly WITH PASSWORD 'read123';

-- Atribuir Roles
GRANT role_admin TO app_admin;
GRANT role_writer TO app_writer;
GRANT role_readonly TO app_readonly;

-- Permissões
GRANT USAGE ON SCHEMA public TO role_writer, role_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role_readonly;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO role_writer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO role_writer;

-- Conceder acesso à VIEW RESTRITA para leitura
GRANT SELECT ON public.vw_cliente_resumo TO role_readonly;

-- *** BLOQUEIO DE ACESSO INDEVIDO (DEMONSTRAÇÃO) ***
-- Revoga permissão de alterar dados sensíveis (Tabela Cliente) do usuário de escrita
REVOKE UPDATE, DELETE ON public.cliente FROM role_writer;


--------------------------------------------------------
-- ETAPA 4 – TESTES E EXECUÇÃO (DEMONSTRAÇÃO)
-- Esta etapa prova que os recursos funcionam (Relatório)
--------------------------------------------------------

DO $$
DECLARE
    v_total NUMERIC;
BEGIN
    RAISE NOTICE '--- INICIANDO TESTES AUTOMATIZADOS ---';

    -- 1. TESTE PROCEDURE E AUDITORIA (INSERT)
    CALL public.inserir_reserva(CURRENT_DATE, 999.99, 1, 1);
    RAISE NOTICE '1. Procedure Inserir Executada (Verificar tb_auditoria).';

    -- 2. TESTE PROCEDURE E AUDITORIA (UPDATE)
    -- Cancela a reserva recém criada (assumindo ser o maior ID)
    CALL public.cancelar_reserva((SELECT MAX(id_reserva) FROM public.reserva));
    RAISE NOTICE '2. Procedure Cancelar Executada (Verificar tb_auditoria).';

    -- 3. TESTE FUNCTION
    v_total := public.calcular_total_gasto_cliente(1);
    RAISE NOTICE '3. Function Executada. Total gasto cliente 1: %', v_total;

    -- 4. TESTE TRIGGER VALIDAÇÃO (ERRO ESPERADO)
    BEGIN
        INSERT INTO public.reserva (reserva_data_inicio, reserva_valor_total) VALUES (CURRENT_DATE, -50.00);
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '4. SUCESSO: Trigger de validação bloqueou valor negativo. Erro: %', SQLERRM;
    END;

    -- 5. DEMONSTRAÇÃO DE SEGURANÇA (Simulação Lógica)
    -- O bloco abaixo apenas ilustra o comando que falharia.
    -- Se estivesse logado como 'app_writer':
    -- DELETE FROM public.cliente WHERE id_cliente = 1; -> ERRO: permissão negada
    RAISE NOTICE '5. Teste de Segurança: A role app_writer está impedida de deletar clientes.';

    RAISE NOTICE '--- FIM DOS TESTES ---';
END $$;

-- 6. TRANSAÇÕES E CONTROLE DE CONCORRÊNCIA (Cenários de Teste)

-- Cenário A: Transação com Commit (Sucesso)
BEGIN TRANSACTION;
    UPDATE public.reserva SET reserva_status = 'F' WHERE id_reserva = 1;
    -- Simulação: Se houvesse outra tabela dependente, atualizaria aqui.
COMMIT;

-- Cenário B: Transação com Rollback (Simulado)
BEGIN TRANSACTION;
    UPDATE public.reserva SET reserva_status = 'C' WHERE id_reserva = 2;
    -- Simulação de erro ou cancelamento da operação
ROLLBACK; -- A reserva 2 voltará ao estado original ('F')

-- Consulta final para provar a auditoria
SELECT * FROM public.tb_auditoria ORDER BY id_log DESC LIMIT 5;
