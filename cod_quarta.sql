-- Define o caminho de busca padrão para o esquema "public"
SET search_path TO pg_catalog,public;

--------------------------------------------------------
-- CRIAÇÃO DAS TABELAS
--------------------------------------------------------

-- Fornecedor
CREATE TABLE public.fornecedor (
	id_fornecedor serial NOT NULL,
	fornecedor_nome varchar(50),
	fornecedor_tipo varchar(50),
	fornecedor_status char,
	CONSTRAINT fornecedor_pk PRIMARY KEY (id_fornecedor)
);
ALTER TABLE public.fornecedor OWNER TO postgres;

-- Cliente
CREATE TABLE public.cliente (
	id_cliente serial NOT NULL,
	cliente_nome varchar(100),
	cliente_cpf varchar(15),
	cliente_email varchar(50),
	CONSTRAINT cliente_pk PRIMARY KEY (id_cliente)
);
ALTER TABLE public.cliente OWNER TO postgres;

-- Destino
CREATE TABLE public.destino (
	id_destino serial NOT NULL,
	destino_pais varchar(30),
	destino_cidade varchar(40),
	CONSTRAINT destino_pk PRIMARY KEY (id_destino)
);
ALTER TABLE public.destino OWNER TO postgres;

-- Serviço
CREATE TABLE public.servico (
	id_servico serial NOT NULL,
	servico_nome varchar(30),
	servico_preco_base numeric(10,2),
	servico_tipo varchar(30),
	id_fornecedor_fornecedor integer,
	CONSTRAINT servico_pk PRIMARY KEY (id_servico)
);
ALTER TABLE public.servico OWNER TO postgres;

-- Chave estrangeira serviço → fornecedor
ALTER TABLE public.servico ADD CONSTRAINT fornecedor_fk FOREIGN KEY (id_fornecedor_fornecedor)
REFERENCES public.fornecedor (id_fornecedor) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Reserva
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
ALTER TABLE public.reserva OWNER TO postgres;

ALTER TABLE public.reserva ADD CONSTRAINT reserva_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.reserva ADD CONSTRAINT reserva_cliente_fk FOREIGN KEY (id_cliente_cliente)
REFERENCES public.cliente (id_cliente) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Transporte
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
ALTER TABLE public.transporte OWNER TO postgres;

ALTER TABLE public.transporte ADD CONSTRAINT transporte_servico_fk FOREIGN KEY (id_servico_servico)
REFERENCES public.servico (id_servico) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.transporte ADD CONSTRAINT transporte_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

-- Hospedagem
DROP TABLE IF EXISTS public.hospedagem CASCADE;
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

ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.hospedagem ADD CONSTRAINT hospedagem_uq UNIQUE (id_servico_servico);

-- Atrativo
DROP TABLE IF EXISTS public.atrativo CASCADE;
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

ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_destino_fk FOREIGN KEY (id_destino_destino)
REFERENCES public.destino (id_destino) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE public.atrativo ADD CONSTRAINT atrativo_uq UNIQUE (id_servico_servico);

--------------------------------------------------------
-- INSERTS
--------------------------------------------------------

-- Clientes
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

-- Destinos
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

-- Fornecedores
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

-- Serviços
TRUNCATE public.servico RESTART IDENTITY CASCADE;
INSERT INTO public.servico (servico_nome, servico_tipo, id_fornecedor_fornecedor) VALUES
('Diária Luxo Rio','Hospedagem',1),
('Voo SP-Paris','Transporte',2),
('City Tour SP','Atrativo',3),
('Chalé Simples','Hospedagem',4),
('Ônibus RJ-MG','Transporte',5),
('Ingresso Arte','Atrativo',6),
('Trem-Bala Tóquio','Transporte',7),
('Cama em Dorm.','Hospedagem',8),
('Tour Roma Coliseu','Atrativo',9),
('Passeio Baía','Transporte',10),
('Diária Luxo Rio 2','Hospedagem',1),
('Chalé Simples 2','Hospedagem',4),
('Cama em Dorm. 1','Hospedagem',8),
('Apartamento','Hospedagem',1),
('Suíte Presid.','Hospedagem',4),
('Cama em Dorm. 2','Hospedagem',8),
('Quarto Casal','Hospedagem',1),
('Bangalô','Hospedagem',4),
('Cama em Dorm. 3','Hospedagem',8),
('Diária Padrão','Hospedagem',1),
('Translado Aeroporto','Transporte',3);

-- Transporte
TRUNCATE public.transporte RESTART IDENTITY CASCADE;
INSERT INTO transporte (tipo, origem, destino, data_partida, data_chegada, preco, id_servico_servico, id_destino_destino) VALUES
('Ônibus','São Paulo','Rio de Janeiro','2025-01-10','2025-01-10',150.00,1,1),
('Avião','Brasília','Nova York','2025-02-05','2025-02-05',750.00,2,4),
('Navio','Rio de Janeiro','Buenos Aires','2025-03-12','2025-03-15',2200.00,3,2),
('Metrô','Rio de Janeiro','Rio de Janeiro','2025-01-01','2025-01-01',4.40,4,1),
('Uber','Santiago','Santiago','2025-01-18','2025-01-18',22.50,5,3),
('Táxi','Paris','Paris','2025-04-10','2025-04-10',35.90,6,5),
('Trem','Tóquio','Tóquio','2025-05-03','2025-05-03',120.00,7,7),
('Avião','Toronto','São Paulo','2025-06-20','2025-06-20',980.00,8,8),
('Trem','Lisboa','Porto','2025-07-14','2025-07-14',89.90,9,9),
('Navio','Sydney','Sydney','2025-08-02','2025-08-02',300.00,10,10),
('Avião','Nova York','Paris','2025-09-01','2025-09-01',1100.00,21,5);

-- Reservas
TRUNCATE public.reserva RESTART IDENTITY CASCADE;
INSERT INTO reserva (reserva_data,reserva_data_inicio,reserva_valor_total,reserva_status,id_servico_servico,id_cliente_cliente)
VALUES
('2025-01-01','2025-01-05',350,'A',1,1),
('2025-01-03','2025-01-04',200,'A',2,1),
('2025-02-10','2025-02-12',500,'C',3,2),
('2025-03-15','2025-03-16',150,'A',1,3),
('2025-03-20','2025-03-22',320,'F',4,4),
('2025-04-01','2025-04-10',1200,'A',2,5),
('2025-04-05','2025-04-07',450,'C',3,6),
('2025-05-02','2025-05-03',180,'A',1,7),
('2025-05-10','2025-05-11',220,'F',4,8),
('2025-06-01','2025-06-05',900,'A',5,9);

-- Atrativo
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

-- Hospedagem
TRUNCATE public.hospedagem RESTART IDENTITY CASCADE;
INSERT INTO hospedagem VALUES
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

--------------------------------------------------------
-- CONSULTAS SQL (INICIAIS, JOIN, COMPLEXAS, AGREGAÇÃO)
--------------------------------------------------------

-- 2.1
SELECT id_cliente, cliente_nome, cliente_email
FROM cliente
ORDER BY cliente_nome;

-- 2.2
SELECT id_transporte, tipo, origem, destino, preco
FROM transporte
WHERE preco > 500
ORDER BY preco DESC;

-- 2.3
SELECT id_servico, servico_nome, servico_tipo
FROM servico
WHERE servico_tipo = 'Hospedagem';

-- 2.4
SELECT id_reserva, reserva_data, reserva_valor_total
FROM reserva
WHERE reserva_status = 'A'
ORDER BY reserva_data;

-- 2.5
SELECT atrativo_nome, atrativo_horario_funcionando
FROM atrativo
WHERE atrativo_horario_funcionando < '09:00'
ORDER BY atrativo_horario_funcionando;

--------------------------------------------------------
-- 3. JOIN
--------------------------------------------------------

-- 3.1
SELECT r.id_reserva, c.cliente_nome, r.reserva_data, r.reserva_valor_total
FROM reserva r
INNER JOIN cliente c ON r.id_cliente_cliente = c.id_cliente;

-- 3.2
SELECT s.id_servico, s.servico_nome, s.servico_tipo, f.fornecedor_nome
FROM servico s
LEFT JOIN fornecedor f ON s.id_fornecedor_fornecedor = f.id_fornecedor;

-- 3.3
SELECT h.hospedagem_nome_propriedade, h.hospedagem_categoria, d.destino_cidade, d.destino_pais
FROM hospedagem h
JOIN destino d ON h.id_destino_destino = d.id_destino;

-- 3.4
SELECT t.id_transporte, t.tipo, t.origem, t.destino, d.destino_cidade
FROM transporte t
LEFT JOIN destino d ON t.id_destino_destino = d.id_destino;

-- 3.5
SELECT a.atrativo_nome, a.atrativo_tipo,
       s.servico_nome AS servico_relacionado,
       d.destino_cidade
FROM atrativo a
JOIN servico s ON a.id_servico_servico = s.id_servico
JOIN destino d ON a.id_destino_destino = d.id_destino;

--------------------------------------------------------
-- 4. CONSULTAS COMPLEXAS
--------------------------------------------------------

-- 4.1
SELECT c.cliente_nome,
       (SELECT COUNT(*) FROM reserva r WHERE r.id_cliente_cliente = c.id_cliente AND r.reserva_status='A') AS total_reservas_ativas,
       (SELECT SUM(reserva_valor_total) FROM reserva r WHERE r.id_cliente_cliente = c.id_cliente) AS valor_total_gasto
FROM cliente c
WHERE c.id_cliente IN (
    SELECT id_cliente_cliente
    FROM reserva
    WHERE reserva_status='A'
    GROUP BY id_cliente_cliente
    HAVING COUNT(*) >= 2
)
ORDER BY valor_total_gasto DESC;

-- 4.2
SELECT t.tipo, t.preco, d.destino_cidade
FROM transporte t
JOIN destino d ON t.id_destino_destino = d.id_destino
JOIN (
    SELECT id_destino_destino, MAX(preco) AS preco_max
    FROM transporte
    GROUP BY id_destino_destino
) m ON m.id_destino_destino = t.id_destino_destino AND m.preco_max = t.preco
ORDER BY d.destino_cidade;

-- 4.3
SELECT c.cliente_nome, r.reserva_valor_total
FROM reserva r
JOIN cliente c ON r.id_cliente_cliente = c.id_cliente
WHERE r.reserva_valor_total > (SELECT AVG(reserva_valor_total) FROM reserva)
ORDER BY r.reserva_valor_total DESC;

-- 4.4
SELECT f.fornecedor_nome, COUNT(DISTINCT s.servico_tipo) AS total_tipos_servico
FROM fornecedor f
JOIN servico s ON s.id_fornecedor_fornecedor = f.id_fornecedor
GROUP BY f.fornecedor_nome
HAVING COUNT(DISTINCT s.servico_tipo) > 1
ORDER BY total_tipos_servico DESC;

--------------------------------------------------------
--  TAREFAS DE AGREGAÇÃO
--------------------------------------------------------

-- 1 COUNT
SELECT reserva_status, COUNT(*) AS total_reservas_por_status
FROM reserva
GROUP BY reserva_status
ORDER BY total_reservas_por_status DESC;

-- 2 SUM
SELECT SUM(reserva_valor_total) AS valor_total_reservas_ativas
FROM reserva
WHERE reserva_status='A';

-- 3 AVG
SELECT tipo, AVG(preco) AS preco_medio
FROM transporte
GROUP BY tipo
ORDER BY preco_medio DESC;

-- 4 MAX
SELECT servico_tipo, MAX(servico_preco_base) AS maior_preco
FROM servico
WHERE servico_preco_base IS NOT NULL
GROUP BY servico_tipo;

-- 5 MIN
SELECT MIN(preco) AS preco_minimo_onibus
FROM transporte
WHERE tipo='Ônibus';

-- 6 COUNT
SELECT servico_tipo, COUNT(*) AS total_servicos
FROM servico
GROUP BY servico_tipo
HAVING COUNT(*) > 3
ORDER BY total_servicos DESC;

-- 7 SUM
SELECT c.cliente_nome,
       SUM(r.reserva_valor_total) AS total_gasto
FROM reserva r
JOIN cliente c ON c.id_cliente = r.id_cliente_cliente
GROUP BY c.cliente_nome
HAVING SUM(r.reserva_valor_total) > 500
ORDER BY total_gasto DESC;

-- 8 AVG
SELECT d.destino_cidade, AVG(t.preco) AS media_preco
FROM transporte t
JOIN destino d ON d.id_destino = t.id_destino_destino
GROUP BY d.destino_cidade
HAVING AVG(t.preco) > 200
ORDER BY media_preco DESC;

-- 9 MAX
SELECT reserva_status, MAX(reserva_valor_total) AS maior_reserva
FROM reserva
GROUP BY reserva_status
HAVING MAX(reserva_valor_total) > 300
ORDER BY maior_reserva DESC;

-- 10 MIN
SELECT f.fornecedor_nome,
       MIN(s.servico_preco_base) AS menor_preco
FROM servico s
JOIN fornecedor f ON f.id_fornecedor = s.id_fornecedor_fornecedor
WHERE s.servico_preco_base IS NOT NULL
GROUP BY f.fornecedor_nome
HAVING MIN(s.servico_preco_base) < 500
ORDER BY menor_preco;

-- 11 COUNT (CORRIGIDA)
SELECT 
    d.destino_cidade,
    COUNT(t.id_transporte) AS total_transportes
FROM 
    destino d
LEFT JOIN 
    transporte t ON t.id_destino_destino = d.id_destino
GROUP BY 
    d.destino_cidade
HAVING 
    COUNT(t.id_transporte) > 1
ORDER BY 
    total_transportes DESC;

--------------------------------------------------------
-- 3.3 PROCEDURES e FUNCTION (Foco: Automação e Segurança)
-- Autor/Responsáveis: Tiago Geraldo e Marcone Oliveira
--------------------------------------------------------

-- 1) Procedure: inserir_reserva
-- Insere uma nova reserva e retorna o id gerado (OUT param).
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

-- 2) Procedure: cancelar_reserva
-- Cancela uma reserva se estiver no status 'A' (Ativa). Retorna boolean via OUT.
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
        SET reserva_status = 'C' -- 'C' para Cancelada
        WHERE id_reserva = p_id_reserva;
        p_result := TRUE;
        p_message := 'Reserva cancelada com sucesso';
    ELSE
        p_result := FALSE;
        p_message := concat('Não é possível cancelar. Status atual: ', v_status);
    END IF;
END;
$$;


-- 1 FUNCTION: calcular_total_gasto_cliente
-- Retorna o total gasto por um cliente (soma de reservas).
CREATE OR REPLACE FUNCTION public.calcular_total_gasto_cliente(p_id_cliente INT)
RETURNS NUMERIC
LANGUAGE plpgsql
SECURITY DEFINER    -- executa com privilégios do proprietário da função (geralmente 'postgres')
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

-- Garantir que o proprietário seja o superuser (opcional)
-- ALTER FUNCTION public.calcular_total_gasto_cliente(INT) OWNER TO postgres;

--------------------------------------------------------
-- 3.8 SEGURANÇA E CONTROLE DE ACESSO (USUÁRIOS, ROLES, GRANTS/REVOKES)
-- Cria 3 usuários e define permissões por perfil
--------------------------------------------------------

-- 1) Revoke de privilégios públicos (boa prática)
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;

-- 2) Criar roles (perfis) para agrupar privilégios (opcional, recomendado)
CREATE ROLE role_readonly NOINHERIT;
CREATE ROLE role_writer NOINHERIT;
CREATE ROLE role_admin NOINHERIT;

-- 3) Criar 3 usuários (substitua as senhas)
CREATE USER app_readonly WITH PASSWORD '<SENHA_APP_READONLY>';
CREATE USER app_writer   WITH PASSWORD '<SENHA_APP_WRITER>';
CREATE USER admin_ops    WITH PASSWORD '<SENHA_ADMIN_OPS>';

-- 4) Atribuir usuários às roles
GRANT role_readonly TO app_readonly;
GRANT role_writer   TO app_writer;
GRANT role_admin    TO admin_ops;

-- 5) Permissões mínimas por perfil (exemplos):
-- role_readonly: SELECT em views/tabelas necessárias
GRANT USAGE ON SCHEMA public TO role_readonly;
GRANT SELECT ON TABLE public.cliente TO role_readonly;
GRANT SELECT ON TABLE public.destino TO role_readonly;
GRANT SELECT ON TABLE public.transporte TO role_readonly;
GRANT SELECT ON TABLE public.servico TO role_readonly;
GRANT SELECT ON TABLE public.atrativo TO role_readonly;
GRANT SELECT ON TABLE public.hospedagem TO role_readonly;
GRANT EXECUTE ON FUNCTION public.calcular_total_gasto_cliente(INT) TO role_readonly;

-- role_writer: INSERT/UPDATE/SELECT nas tabelas de negócio controladas
GRANT USAGE ON SCHEMA public TO role_writer;
GRANT SELECT, INSERT, UPDATE ON TABLE public.reserva TO role_writer;
GRANT SELECT, INSERT ON TABLE public.transporte TO role_writer;
GRANT SELECT ON TABLE public.servico TO role_writer;
-- permitir executar procedures de negócio
GRANT EXECUTE ON PROCEDURE public.inserir_reserva(DATE,DATE,NUMERIC,CHAR,INT,INT,OUT INT) TO role_writer;
GRANT EXECUTE ON PROCEDURE public.cancelar_reserva(INT,OUT BOOLEAN,OUT TEXT) TO role_writer;
GRANT EXECUTE ON FUNCTION public.calcular_total_gasto_cliente(INT) TO role_writer;

-- role_admin: permissões administrativas mais amplas (sem ser superuser)
GRANT USAGE ON SCHEMA public TO role_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO role_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO role_admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO role_admin;

-- 6) Exemplo de restrição adicional: revogar UPDATE/DELETE em cliente para writer
REVOKE UPDATE, DELETE ON public.cliente FROM role_writer;

-- 7) Criar uma view protegida (exemplo) para expor somente campos necessários e conceder SELECT
CREATE OR REPLACE VIEW public.vw_cliente_resumo AS
SELECT id_cliente, cliente_nome, cliente_email
FROM public.cliente;

GRANT SELECT ON public.vw_cliente_resumo TO role_readonly;
GRANT SELECT ON public.vw_cliente_resumo TO role_writer;

-- 8) Reforçar: garantir que futuras tabelas tenham privilégios controlados
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO role_readonly;

--------------------------------------------------------
-- 3. FOCO EM INTEGRIDADE E CONCORRÊNCIA
-- Responsáveis: Álex de Almeida e Samuel Henrique 🤝

-- ETAPA 3.2: TRIGGERS (GATILHOS) E AUDITORIA

-- 1. Criação da Tabela de Auditoria
-- Vai guardar o histórico do que acontece no sistema
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

-- 2. Trigger 1: Auditoria de Reservas
-- Objetivo: Gravar um log sempre que uma reserva for alterada
CREATE OR REPLACE FUNCTION fn_auditoria_reserva()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.tb_auditoria (tabela_alterada, acao, usuario, dados_antigos, dados_novos)
    VALUES (
        'reserva', 
        TG_OP, 
        CURRENT_USER, 
        OLD::text, 
        NEW::text
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditoria_reserva
AFTER UPDATE ON public.reserva
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_reserva();

-- 3. Trigger 2: Validação de Regra de Negócio
-- Objetivo: Não permitir reservas com valor zerado ou negativo
CREATE OR REPLACE FUNCTION fn_validar_valor_reserva()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.reserva_valor_total <= 0 THEN
        RAISE EXCEPTION 'Erro: O valor da reserva deve ser maior que zero!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_valor_reserva
BEFORE INSERT OR UPDATE ON public.reserva
FOR EACH ROW
EXECUTE FUNCTION fn_validar_valor_reserva();


-- ETAPA 3.6 e 3.7: TRANSAÇÕES, CONCORRÊNCIA E SERIALIZAÇÃO

--OBS:execute um codigo por vez. Caso tente executar outro codigo e dizer que tem uma transação em andamento de ROLLBACK
-- CENÁRIO 1: PROBLEMA DE CONCORRÊNCIA (Lost Update - Atualização Perdida)
-- Nível de Isolamento Padrão (Read Committed)
-- Situação: Álex e Samuel tentam atualizar a mesma reserva ao mesmo tempo.

-- [Sessão A - Álex]OBS:execute um codigo por vez. Caso tenha uma transação em andamento de ROLLBACK;
BEGIN;
-- Álex lê o valor da reserva 1 (Digamos que seja 350.00)
SELECT reserva_valor_total FROM public.reserva WHERE id_reserva = 1;
-- Álex vai dar um desconto de 50.00 (Novo valor seria 300.00)
-- ... Álex está pensando ...

-- [Sessão B - Samuel]
BEGIN;
-- Samuel lê o mesmo valor (350.00) pois Álex ainda não salvou
SELECT reserva_valor_total FROM public.reserva WHERE id_reserva = 1;
-- Samuel aplica uma taxa de 10.00 (Novo valor seria 360.00)
UPDATE public.reserva SET reserva_valor_total = 360.00 WHERE id_reserva = 1;
COMMIT; -- Samuel salvou!

-- [Sessão A - Álex - Continuação]
-- Álex agora salva o calculo dele baseado nos 350.00 antigos
UPDATE public.reserva SET reserva_valor_total = 300.00 WHERE id_reserva = 1;
COMMIT; 
-- RESULTADO: O update do Samuel foi sobrescrito/perdido. Isso é o Lost Update.


-- CENÁRIO 2: SOLUÇÃO COM SERIALIZAÇÃO (Serializable)
-- Nível de Isolamento Mais Alto
-- O banco obriga as transações a acontecerem em fila (serialmente).

-- [Sessão A - Álex]
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- Define modo estrito
SELECT reserva_valor_total FROM public.reserva WHERE id_reserva = 1;

-- [Sessão B - Samuel]
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- Define modo estrito
SELECT reserva_valor_total FROM public.reserva WHERE id_reserva = 1;
UPDATE public.reserva SET reserva_valor_total = 360.00 WHERE id_reserva = 1;
COMMIT; -- Samuel salva com sucesso.

-- [Sessão A - Álex - Continuação]
UPDATE public.reserva SET reserva_valor_total = 300.00 WHERE id_reserva = 1;
-- ERRO! O banco bloqueia Álex: "could not serialize access due to concurrent update"
-- Álex terá que reiniciar a transação e ler o valor novo que Samuel colocou.
ROLLBACK;
