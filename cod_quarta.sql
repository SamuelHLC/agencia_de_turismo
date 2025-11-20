-- Cria o banco de dados principal
CREATE DATABASE new_database;

-- Define o caminho de busca padrão para o esquema "public"
SET search_path TO pg_catalog,public;

-- --------------------------------------------------------
-- CRIAÇÃO DAS TABELAS
-- --------------------------------------------------------

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

-- Reserva (Recriada)
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

-- Chaves estrangeiras para Reserva
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
	id_destino_destino INTEGER -- Esta coluna é crucial para a Consulta 4.2
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

-- --------------------------------------------------------
-- INSERTS
-- --------------------------------------------------------

-- Clientes
TRUNCATE public.cliente RESTART IDENTITY CASCADE;
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
TRUNCATE public.destino RESTART IDENTITY CASCADE;
INSERT INTO public.destino (destino_pais, destino_cidade) VALUES
('Brasil', 'Rio de Janeiro'), -- id_destino = 1
('Argentina', 'Buenos Aires'), -- id_destino = 2
('Chile', 'Santiago'), -- id_destino = 3
('Estados Unidos', 'Nova York'), -- id_destino = 4
('França', 'Paris'), -- id_destino = 5
('Itália', 'Roma'), -- id_destino = 6
('Japão', 'Tóquio'), -- id_destino = 7
('Canadá', 'Toronto'), -- id_destino = 8
('Portugal', 'Lisboa'), -- id_destino = 9
('Austrália', 'Sydney'); -- id_destino = 10

-- Fornecedores
TRUNCATE public.fornecedor RESTART IDENTITY CASCADE;
INSERT INTO public.fornecedor (fornecedor_nome, fornecedor_tipo, fornecedor_status) VALUES
('Hotel Sol & Mar', 'Hospedagem', 'A'), 	-- id_fornecedor = 1
('Voa Rápido S/A', 'Transporte Aéreo', 'A'), 	-- id_fornecedor = 2
('Guia Tur SP', 'Agência Turismo', 'A'), 	-- id_fornecedor = 3
('Pousada da Montanha', 'Hospedagem', 'A'), 	-- id_fornecedor = 4
('RodoExpresso BR', 'Transporte Rodoviário', 'A'), 	-- id_fornecedor = 5
('Museum Corp', 'Atração Cultural', 'A'), 	-- id_fornecedor = 6
('Tokyo Rail', 'Transporte Ferroviário', 'A'), 	-- id_fornecedor = 7
('Hostel Amigo', 'Hospedagem', 'A'), 		-- id_fornecedor = 8
('Tours Europa', 'Agência Turismo', 'A'), 	-- id_fornecedor = 9
('Ferry Sydney', 'Transporte Marítimo', 'A'); -- id_fornecedor = 10

-- Serviços (1–10)
TRUNCATE public.servico RESTART IDENTITY CASCADE;
INSERT INTO public.servico (servico_nome, servico_tipo, id_fornecedor_fornecedor) VALUES
('Diária Luxo Rio', 'Hospedagem', 1), -- id_servico = 1
('Voo SP-Paris', 'Transporte', 2), -- id_servico = 2
('City Tour SP', 'Atrativo', 3), -- id_servico = 3
('Chalé Simples', 'Hospedagem', 4), -- id_servico = 4
('Ônibus RJ-MG', 'Transporte', 5), -- id_servico = 5
('Ingresso Arte', 'Atrativo', 6), -- id_servico = 6
('Trem-Bala Tóquio', 'Transporte', 7), -- id_servico = 7
('Cama em Dorm.', 'Hospedagem', 8), -- id_servico = 8
('Tour Roma Coliseu', 'Atrativo', 9), -- id_servico = 9
('Passeio Baía', 'Transporte', 10); -- id_servico = 10

-- Serviços (11–21) - Adicionados para completar exemplos
INSERT INTO public.servico (servico_nome, servico_tipo, id_fornecedor_fornecedor) VALUES
('Diária Luxo Rio 2', 'Hospedagem', 1), -- id_servico = 11
('Chalé Simples 2', 'Hospedagem', 4), -- id_servico = 12
('Cama em Dorm. 1', 'Hospedagem', 8), -- id_servico = 13
('Apartamento', 'Hospedagem', 1), -- id_servico = 14
('Suíte Presid.', 'Hospedagem', 4), -- id_servico = 15
('Cama em Dorm. 2', 'Hospedagem', 8), -- id_servico = 16
('Quarto Casal', 'Hospedagem', 1), -- id_servico = 17
('Bangalô', 'Hospedagem', 4), -- id_servico = 18
('Cama em Dorm. 3', 'Hospedagem', 8), -- id_servico = 19
('Diária Padrão', 'Hospedagem', 1), -- id_servico = 20
('Translado Aeroporto', 'Transporte', 3); -- id_servico = 21

-- Transportes (INSERTS DIRETOS COM CHAVES CORRETAS)
TRUNCATE public.transporte RESTART IDENTITY CASCADE;
INSERT INTO transporte (tipo, origem, destino, data_partida, data_chegada, preco, id_servico_servico, id_destino_destino) VALUES
('Ônibus', 'São Paulo', 'Rio de Janeiro', '2025-01-10', '2025-01-10', 150.00, 1, 1), 		-- Rio de Janeiro (Preço 150.00)
('Avião', 'Brasília', 'Nova York', '2025-02-05', '2025-02-05', 750.00, 2, 4), 			-- Nova York (Preço 750.00)
('Navio', 'Rio de Janeiro', 'Buenos Aires', '2025-03-12', '2025-03-15', 2200.00, 3, 2), 	-- Buenos Aires (Preço 2200.00)
('Metrô', 'Rio de Janeiro', 'Rio de Janeiro', '2025-01-01', '2025-01-01', 4.40, 4, 1), 		-- Rio de Janeiro (Preço 4.40)
('Uber', 'Santiago', 'Santiago', '2025-01-18', '2025-01-18', 22.50, 5, 3), 				-- Santiago (Preço 22.50)
('Táxi', 'Paris', 'Paris', '2025-04-10', '2025-04-10', 35.90, 6, 5), 					-- Paris (Preço 35.90)
('Trem', 'Tóquio', 'Tóquio', '2025-05-03', '2025-05-03', 120.00, 7, 7), 				-- Tóquio (Preço 120.00)
('Avião', 'Toronto', 'São Paulo', '2025-06-20', '2025-06-20', 980.00, 8, 8), 			-- Toronto (Preço 980.00)
('Trem', 'Lisboa', 'Porto', '2025-07-14', '2025-07-14', 89.90, 9, 9), 					-- Lisboa (Preço 89.90)
('Navio', 'Sydney', 'Sydney', '2025-08-02', '2025-08-02', 300.00, 10, 10), 				-- Sydney (Preço 300.00)
('Avião', 'Nova York', 'Paris', '2025-09-01', '2025-09-01', 1100.00, 21, 5); 			-- Paris (Preço 1100.00 - Novo máximo para Paris)

-- Reservas
TRUNCATE public.reserva RESTART IDENTITY CASCADE;
INSERT INTO reserva (reserva_data, reserva_data_inicio, reserva_valor_total, reserva_status, id_servico_servico, id_cliente_cliente)
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
TRUNCATE public.atrativo RESTART IDENTITY CASCADE;
INSERT INTO atrativo (atrativo_nome, atrativo_horario_funcionando, atrativo_tipo, id_servico_servico, id_destino_destino)
VALUES
('Praia Central', '08:00', 'Natural', 3, 1), 
('Museu Histórico', '09:00', 'Cultural', 6, 1), 
('Parque das Aves', '07:30', 'Natural', 9, 2),
('Mirante da Serra', '10:00', 'Paisagem', 11, 2),
('Aquário Azul', '08:30', 'Educativo', 12, 3),
('Centro Gastronômico', '18:00', 'Culinária', 13, 3),
('Trilha da Mata', '06:00', 'Aventura', 14, 4),
('Cachoeira Bela Vista', '07:00', 'Natural', 15, 4),
('Planetário Municipal', '14:00', 'Cultural', 16, 5),
('Feira de Artesanato', '10:00', 'Comércio', 17, 5);

-- Hospedagens
TRUNCATE public.hospedagem RESTART IDENTITY CASCADE;
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

-- 2.1.
SELECT id_cliente, cliente_nome, cliente_email
FROM cliente
ORDER BY cliente_nome ASC;

-- 2.2.
SELECT id_transporte, tipo, origem, destino, preco
FROM transporte
WHERE preco > 500
ORDER BY preco DESC;

-- 2.3.
SELECT id_servico, servico_nome, servico_tipo
FROM servico
WHERE servico_tipo = 'Hospedagem';

-- 2.4.
SELECT id_reserva, reserva_data, reserva_valor_total
FROM reserva
WHERE reserva_status = 'A'
ORDER BY reserva_data;

-- 2.5.
SELECT atrativo_nome, atrativo_horario_funcionando
FROM atrativo
WHERE atrativo_horario_funcionando < '09:00'
ORDER BY atrativo_horario_funcionando;

--------------------------------------------------------
-- 3. CONSULTAS COM JOIN (FORMATO SIMPLIFICADO)


-- 3.1. Lista todas as reservas com o nome do cliente.
SELECT
    r.id_reserva,
    c.cliente_nome,
    r.reserva_data,
    r.reserva_valor_total
FROM
    reserva r
INNER JOIN
    cliente c ON r.id_cliente_cliente = c.id_cliente;

-- 3.2. Lista todos os serviços e o nome do seu fornecedor.
SELECT
    s.id_servico,
    s.servico_nome,
    s.servico_tipo,
    f.fornecedor_nome
FROM
    servico s
LEFT JOIN
    fornecedor f ON s.id_fornecedor_fornecedor = f.id_fornecedor;

-- 3.3. Lista todas as hospedagens e o nome da cidade/país do destino.
SELECT
    h.hospedagem_nome_propriedade,
    h.hospedagem_categoria,
    d.destino_cidade,
    d.destino_pais
FROM
    hospedagem h
INNER JOIN
    destino d ON h.id_destino_destino = d.id_destino;

-- 3.4. Lista todos os transportes e a cidade de destino (ligada pela chave de destino).
SELECT
    t.id_transporte,
    t.tipo,
    t.origem,
    t.destino,
    d.destino_cidade
FROM
    transporte t
LEFT JOIN
    destino d ON t.id_destino_destino = d.id_destino;

-- 3.5. Lista atrativos, seus serviços e a cidade onde estão localizados.
SELECT
    a.atrativo_nome,
    a.atrativo_tipo,
    s.servico_nome AS servico_relacionado,
    d.destino_cidade AS cidade
FROM
    atrativo a
INNER JOIN
    servico s ON a.id_servico_servico = s.id_servico
INNER JOIN
    destino d ON a.id_destino_destino = d.id_destino;

--------------------------------------------------------
-- 4. CONSULTAS COMPLEXAS (COM SUBCONSULTAS E AGREGAÇÃO)
--------------------------------------------------------

-- 4.1. Consulta com Subconsulta no SELECT e Subconsulta no WHERE
-- Lista clientes com 2 ou mais reservas ativas, mostrando a contagem de reservas ativas e o valor total gasto.
SELECT
    c.cliente_nome,
    (SELECT COUNT(r.id_reserva)
     FROM reserva r
     WHERE r.id_cliente_cliente = c.id_cliente AND r.reserva_status = 'A') AS total_reservas_ativas,
    (SELECT SUM(r.reserva_valor_total)
     FROM reserva r
     WHERE r.id_cliente_cliente = c.id_cliente) AS valor_total_gasto
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
ORDER BY
    valor_total_gasto DESC;


-- 4.2. **CONSULTA SIMPLIFICADA E ESTÁVEL (JOIN + Subconsulta de Agregação)**
-- Encontra o transporte com o preço máximo em cada destino.
SELECT
    t.tipo AS tipo_transporte,
    t.preco AS preco_maximo,
    d.destino_cidade
FROM
    transporte t
INNER JOIN
    destino d ON t.id_destino_destino = d.id_destino
INNER JOIN
    (SELECT
        id_destino_destino,
        MAX(preco) AS preco_max_destino
     FROM
        transporte
     GROUP BY
        id_destino_destino
    ) AS max_precos ON t.id_destino_destino = max_precos.id_destino_destino
                   AND t.preco = max_precos.preco_max_destino -- Condição para pegar apenas o registro do preço máximo
ORDER BY
    d.destino_cidade, t.preco DESC;

-- 4.3. Consulta com Subconsulta no WHERE (Reservas acima da média)
-- Lista clientes que fizeram reservas com valor total superior à média de todas as reservas.
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

-- 4.4. Consulta com Uso de Agregação Avançada
-- Identifica e conta o número de tipos de serviço (servico_tipo) distintos fornecidos por cada fornecedor.
-- O HAVING filtra apenas os fornecedores que oferecem mais de um tipo de serviço.
SELECT
    f.fornecedor_nome,
    COUNT(DISTINCT s.servico_tipo) AS total_tipos_servico
FROM
    fornecedor f
INNER JOIN
    servico s ON f.id_fornecedor = s.id_fornecedor_fornecedor
GROUP BY
    f.fornecedor_nome
HAVING
    COUNT(DISTINCT s.servico_tipo) > 1
ORDER BY
    total_tipos_servico DESC, f.fornecedor_nome;


	
-- TAREFA DE SAMUEL E ALEX: Consultas de Agregação
-- O foco é usar as funções COUNT, SUM, AVG, MAX e MIN para
-- resumir os dados no banco.


-- 1. COUNT(): Contar o número total de reservas por status
-- Mostra a quantidade de cada status (Ativa, Cancelada, Finalizada).
SELECT
    reserva_status,
    COUNT(*) AS total_reservas_por_status
FROM
    public.reserva
GROUP BY
    reserva_status
ORDER BY
    total_reservas_por_status DESC; -- CLÁUSULA FINAL (ORDER BY)

-- 2. SUM(): Calcular o valor total (soma) de todas as reservas confirmadas ('A')
-- Esta consulta usa SUM em um conjunto filtrado, sem GROUP BY, para um total geral.
SELECT
    SUM(reserva_valor_total) AS valor_total_reservas_ativas
FROM
    public.reserva
WHERE
    reserva_status = 'A';

-- 3. AVG(): Calcular o preço médio dos transportes por tipo
-- Usa AVG para encontrar o preço médio de Ônibus, Avião, Navio, etc.
SELECT
    tipo AS tipo_transporte,
    AVG(preco) AS preco_medio_transporte
FROM
    public.transporte
GROUP BY
    tipo
ORDER BY
    preco_medio_transporte DESC;

-- 4. MAX(): Encontrar o maior valor base de serviço para cada tipo de serviço
-- Usa MAX para descobrir o serviço mais caro em cada categoria (Hospedagem, Transporte, Atrativo).
SELECT
    s.servico_tipo,
    MAX(s.servico_preco_base) AS maior_preco_base_servico
FROM
    public.servico s
WHERE
    s.servico_preco_base IS NOT NULL -- Ignora serviços sem preço base definido
GROUP BY
    s.servico_tipo;

-- 5. MIN(): Encontrar o preço do transporte mais barato de ônibus
-- Usa MIN para retornar o valor mínimo dentro do tipo 'Ônibus'.
SELECT
    MIN(preco) AS preco_minimo_onibus
FROM
    public.transporte
WHERE
    tipo = 'Ônibus';

-- 6. Consultas com (count) para ter uma quantidade de tipos de seriços que tenha 3 tipos.
SELECT 
    servico_tipo,
    COUNT(*) AS total_servicos
FROM 
    servico
GROUP BY 
    servico_tipo
HAVING 
    COUNT(*) > 3
ORDER BY 
    total_servicos DESC;

--7.Consultas com (Sum) para ter uma soma das reservas por clientes que gastaram mais de 500.
SELECT 
    c.cliente_nome,
    SUM(r.reserva_valor_total) AS total_gasto
FROM 
    reserva r
JOIN 
    cliente c ON c.id_cliente = r.id_cliente_cliente
GROUP BY 
    c.cliente_nome
HAVING 
    SUM(r.reserva_valor_total) > 500
ORDER BY 
    total_gasto DESC;

--8. Consultas com (Avg) para ter uma media de transporte por cidade/destino (media 200).
SELECT 
    d.destino_cidade,
    AVG(t.preco) AS media_preco_transporte
FROM 
    transporte t
JOIN 
    destino d ON d.id_destino = t.id_destino_destino
GROUP BY 
    d.destino_cidade
HAVING 
    AVG(t.preco) > 200
ORDER BY 
    media_preco_transporte DESC;

--9. Consultas com (Max) para ter o maior valor por status (max status > 300).
SELECT 
    reserva_status,
    MAX(reserva_valor_total) AS maior_reserva
FROM 
    reserva
GROUP BY 
    reserva_status
HAVING 
    MAX(reserva_valor_total) > 300
ORDER BY 
    maior_reserva DESC;

-- 10. Consultas com (Min) para ter o menor preco de serviço por fornecedor(fornecedores com preço base deinido).
SELECT
    f.fornecedor_nome,
    MIN(s.servico_preco_base) AS menor_preco
FROM
    servico s
JOIN 
    fornecedor f ON f.id_fornecedor = s.id_fornecedor_fornecedor
WHERE
    s.servico_preco_base IS NOT NULL
GROUP BY
    f.fornecedor_nome
HAVING
    MIN(s.servico_preco_base) < 500
ORDER BY
    menor_preco;

--11. Consultas com (count) para contar quantos transportes cade destino possui(somento destinos com mais de 1 transporte).
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

--12. consultas com (Avg) para ter media de valor das reservas por status (status medio +300 ).
SELECT
    reserva_status,
    AVG(reserva_valor_total) AS media_valor
FROM
    reserva
GROUP BY
    reserva_status
HAVING
    AVG(reserva_valor_total) > 300;

--13. Consulta com (Sum) para soma do preco de transporte do tipo que total utrapassa 1000.
SELECT 
    tipo,
    SUM(preco) AS soma_precos
FROM 
    transporte
GROUP BY 
    tipo
HAVING 
    SUM(preco) > 1000
ORDER BY 
    soma_precos DESC;

