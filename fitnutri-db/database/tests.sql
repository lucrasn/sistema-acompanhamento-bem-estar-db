-- Testes das regras criticas do FitNutri.
--
-- Execute depois do schema.sql, dos gatilhos e do data.sql.
-- Tudo roda dentro de uma transacao que termina em ROLLBACK: nenhum dado
-- do banco e alterado.
--
--   psql -d fitnutri -f database/tests.sql
--
-- Cada caso tenta uma operacao e registra se o banco reagiu como esperado.
-- No fim sai um relatorio e a contagem de falhas.

BEGIN;

CREATE TEMP TABLE resultado_teste (
    id SERIAL PRIMARY KEY,
    grupo TEXT NOT NULL,
    caso TEXT NOT NULL,
    esperado TEXT NOT NULL,
    situacao TEXT NOT NULL,
    detalhe TEXT
);

-- Registra um caso em que a operacao DEVE ser recusada pelo banco.
CREATE OR REPLACE FUNCTION pg_temp.deve_recusar(
    p_grupo TEXT, p_caso TEXT, p_comando TEXT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        EXECUTE p_comando;
        SET CONSTRAINTS ALL IMMEDIATE;   -- forca as verificacoes adiadas
        SET CONSTRAINTS ALL DEFERRED;    -- volta ao padrao para os proximos casos
        INSERT INTO resultado_teste (grupo, caso, esperado, situacao, detalhe)
        VALUES (p_grupo, p_caso, 'recusar', 'FALHOU', 'a operacao foi aceita');
    EXCEPTION WHEN OTHERS THEN
        INSERT INTO resultado_teste (grupo, caso, esperado, situacao, detalhe)
        VALUES (p_grupo, p_caso, 'recusar', 'PASSOU', SQLERRM);
    END;
END;
$$;

-- Registra um caso em que a operacao DEVE ser aceita pelo banco.
CREATE OR REPLACE FUNCTION pg_temp.deve_aceitar(
    p_grupo TEXT, p_caso TEXT, p_comando TEXT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        EXECUTE p_comando;
        SET CONSTRAINTS ALL IMMEDIATE;
        SET CONSTRAINTS ALL DEFERRED;
        INSERT INTO resultado_teste (grupo, caso, esperado, situacao, detalhe)
        VALUES (p_grupo, p_caso, 'aceitar', 'PASSOU', NULL);
    EXCEPTION WHEN OTHERS THEN
        INSERT INTO resultado_teste (grupo, caso, esperado, situacao, detalhe)
        VALUES (p_grupo, p_caso, 'aceitar', 'FALHOU', SQLERRM);
    END;
END;
$$;

-- Registra um caso em que um valor calculado deve bater com o esperado.
CREATE OR REPLACE FUNCTION pg_temp.deve_valer(
    p_grupo TEXT, p_caso TEXT, p_consulta TEXT, p_esperado TEXT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_obtido TEXT;
BEGIN
    EXECUTE p_consulta INTO v_obtido;
    INSERT INTO resultado_teste (grupo, caso, esperado, situacao, detalhe)
    VALUES (
        p_grupo, p_caso, p_esperado,
        CASE WHEN v_obtido IS NOT DISTINCT FROM p_esperado THEN 'PASSOU' ELSE 'FALHOU' END,
        'obtido: ' || COALESCE(v_obtido, 'nulo')
    );
END;
$$;


-- 1. HERANCA: EVOLUCAO E DISJUNTA E TOTAL

SELECT pg_temp.deve_recusar(
    'heranca',
    'mesma evolucao nas duas subclasses (INSERT)',
    $cmd$
    INSERT INTO EVOLUCAO_NUTRICIONAL (id_evolucao, id_consulta_nutricional, consumo_calorico)
    VALUES (
        (SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10'),
        (SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-20'),
        1900
    )
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'heranca',
    'mover uma evolucao nutricional para uma que ja e fisica (UPDATE)',
    $cmd$
    UPDATE EVOLUCAO_NUTRICIONAL
       SET id_evolucao = (SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10')
     WHERE id_evolucao = (SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-14')
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'heranca',
    'evolucao sem nenhuma subclasse',
    $cmd$
    INSERT INTO EVOLUCAO (data_avaliacao, peso, perc_gordura, medida_corporal)
    VALUES (DATE '2026-07-01', 70.00, 25.00, 'Sem subclasse')
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'heranca',
    'remover a unica subclasse de uma evolucao',
    $cmd$
    DELETE FROM EVOLUCAO_FISICA
     WHERE id_evolucao = (SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10')
    $cmd$
);


-- 2. HERANCA: PROFISSIONAL E SOBREPOSTA E TOTAL

SELECT pg_temp.deve_recusar(
    'heranca',
    'profissional sem nenhuma subclasse',
    $cmd$
    INSERT INTO PROFISSIONAL (nome, cpf, data_contrato)
    VALUES ('Teste Sem Subclasse', '99999999999', DATE '2026-01-01')
    $cmd$
);

SELECT pg_temp.deve_aceitar(
    'heranca',
    'educador fisico que tambem vira nutricionista (sobreposicao)',
    $cmd$
    INSERT INTO NUTRICIONISTA (id_profissional, CRN)
    VALUES ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '78901234568'), 'CRN9-90000')
    $cmd$
);

SELECT pg_temp.deve_valer(
    'heranca',
    'profissionais que sao nutricionista e educador ao mesmo tempo',
    $q$SELECT count(*)::TEXT FROM NUTRICIONISTA n JOIN EDUCADOR_FISICO e USING (id_profissional)$q$,
    '2'
);


-- 3. ATRIBUTOS DERIVADOS: IMC

SELECT pg_temp.deve_valer(
    'imc',
    'calculado ao vincular a evolucao a consulta (71.20 / 1.65^2)',
    $q$SELECT imc::TEXT FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10'$q$,
    '26.15'
);

UPDATE EVOLUCAO SET peso = 80.00 WHERE data_avaliacao = DATE '2026-03-10';
SELECT pg_temp.deve_valer(
    'imc',
    'recalculado quando o peso muda (80.00 / 1.65^2)',
    $q$SELECT imc::TEXT FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10'$q$,
    '29.38'
);

UPDATE PACIENTE SET altura = 1.70 WHERE cpf = '12345678901';
SELECT pg_temp.deve_valer(
    'imc',
    'recalculado quando a altura do paciente e corrigida (80.00 / 1.70^2)',
    $q$SELECT imc::TEXT FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10'$q$,
    '27.68'
);

SELECT pg_temp.deve_recusar(
    'imc',
    'informar o IMC no INSERT',
    $cmd$
    INSERT INTO EVOLUCAO (data_avaliacao, peso, perc_gordura, medida_corporal, imc)
    VALUES (DATE '2026-07-02', 70.00, 25.00, 'Teste', 24.00)
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'imc',
    'alterar o IMC diretamente',
    $cmd$
    UPDATE EVOLUCAO SET imc = 99.00 WHERE data_avaliacao = DATE '2026-03-10'
    $cmd$
);

SELECT pg_temp.deve_valer(
    'imc',
    'o valor continua o calculado depois da tentativa manual',
    $q$SELECT imc::TEXT FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10'$q$,
    '27.68'
);


-- 4. ATRIBUTOS DERIVADOS: VALOR LIQUIDO E VALOR CALORICO

SELECT pg_temp.deve_valer(
    'derivados',
    'valor liquido do plano Completo com 20.00 de desconto',
    $q$SELECT pg.valor_liquido::TEXT
         FROM PAGAMENTO pg
         JOIN CONTRATA_PLANO cp ON cp.id_contrato = pg.id_contrato
         JOIN PLANO_SERVICO ps ON ps.id_plano_servico = cp.id_plano_servico
        WHERE ps.nome_do_plano = 'Completo' AND pg.desconto = 20.00$q$,
    '229.90'
);

UPDATE PAGAMENTO SET multa = 30.00
 WHERE id_pagamento = (SELECT min(id_pagamento) FROM PAGAMENTO);
SELECT pg_temp.deve_valer(
    'derivados',
    'valor liquido recalculado ao aplicar multa de 30.00',
    $q$SELECT valor_liquido::TEXT FROM PAGAMENTO WHERE id_pagamento = (SELECT min(id_pagamento) FROM PAGAMENTO)$q$,
    '259.90'
);

SELECT pg_temp.deve_recusar(
    'derivados',
    'informar o valor liquido manualmente',
    $cmd$
    UPDATE PAGAMENTO SET valor_liquido = 1.00 WHERE id_pagamento = (SELECT min(id_pagamento) FROM PAGAMENTO)
    $cmd$
);

SELECT pg_temp.deve_valer(
    'derivados',
    'valor calorico do arroz integral (2.60 P + 25.80 C + 1.00 G)',
    $q$SELECT valor_calorico_porcao::TEXT FROM ALIMENTO WHERE nome = 'Arroz integral cozido'$q$,
    '122.60'
);


-- 5. INTEGRIDADE REFERENCIAL E EXCLUSAO LOGICA

SELECT pg_temp.deve_recusar(
    'integridade',
    'pagamento apontando para um contrato inexistente',
    $cmd$
    INSERT INTO PAGAMENTO (id_contrato, tipo_cobranca, data_venc)
    VALUES (999999, 'Mensalidade', DATE '2026-05-01')
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'integridade',
    'apagar paciente com consultas e contratos (RN12, ON DELETE RESTRICT)',
    $cmd$
    DELETE FROM PACIENTE WHERE cpf = '12345678901'
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'integridade',
    'alimento de uma refeicao que pertence a outro plano alimentar',
    $cmd$
    INSERT INTO REFEICAO_CONTEM_ALIMENTO (id_alimento, id_plano_alimentar, id_refeicao, unidade_de_medida, quantidade)
    VALUES (
        (SELECT id_alimento FROM ALIMENTO WHERE nome = 'Maca'),
        (SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-21'),
        (SELECT id_refeicao FROM REFEICAO
          WHERE id_plano_alimentar = (SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-15')
          LIMIT 1),
        'unidade', 1.00
    )
    $cmd$
);


-- 6. REGRAS DE NEGOCIO DECLARADAS POR UNIQUE

SELECT pg_temp.deve_recusar(
    'unicidade',
    'mesma adesao duplicada: paciente, plano e data iguais (RF12)',
    $cmd$
    INSERT INTO CONTRATA_PLANO (id_paciente, id_plano_servico, data_de_adesao)
    VALUES (
        (SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'),
        (SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Completo'),
        DATE '2026-03-01'
    )
    $cmd$
);

SELECT pg_temp.deve_aceitar(
    'unicidade',
    'readesao ao mesmo plano em outra data (RF12)',
    $cmd$
    INSERT INTO CONTRATA_PLANO (id_paciente, id_plano_servico, data_de_adesao)
    VALUES (
        (SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'),
        (SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Completo'),
        DATE '2027-01-01'
    )
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'unicidade',
    'exercicio com nome repetido no catalogo',
    $cmd$INSERT INTO EXERCICIO (nome, grupo_muscular) VALUES ('Supino reto', 'Peitoral')$cmd$
);

-- Uma evolucao nova, vinculada a consulta fisica que ainda estava livre.
INSERT INTO EVOLUCAO (data_avaliacao, peso, perc_gordura, medida_corporal)
VALUES (DATE '2026-08-01', 70.00, 25.00, 'Evolucao de teste');

INSERT INTO EVOLUCAO_FISICA (id_evolucao, id_consulta_fisica)
VALUES (
    (SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-08-01'),
    (SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-18')
);

SELECT pg_temp.deve_recusar(
    'unicidade',
    'duas evolucoes fisicas para a mesma consulta (relacionamento 1:1)',
    $cmd$
    UPDATE EVOLUCAO_FISICA
       SET id_consulta_fisica = (SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-10')
     WHERE id_evolucao = (SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-08-01')
    $cmd$
);


-- 7. DOMINIOS DECLARADOS POR CHECK

SELECT pg_temp.deve_recusar(
    'dominio',
    'status de paciente fora do dominio',
    $cmd$UPDATE PACIENTE SET status = 'Suspenso' WHERE cpf = '12345678901'$cmd$
);

SELECT pg_temp.deve_recusar(
    'dominio',
    'CPF com caractere nao numerico',
    $cmd$
    INSERT INTO PACIENTE (cpf, rg, nome, sexo) VALUES ('1234567890A', 'MG9999999', 'Teste', 'M')
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'dominio',
    'dia da semana igual a 8',
    $cmd$
    INSERT INTO DISPONIBILIDADE_PROFISSIONAL (id_profissional, dia_semana, hora_ini, hora_fim)
    VALUES ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'), 8, TIME '08:00', TIME '12:00')
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'dominio',
    'faixa de disponibilidade terminando antes de comecar',
    $cmd$
    INSERT INTO DISPONIBILIDADE_PROFISSIONAL (id_profissional, dia_semana, hora_ini, hora_fim)
    VALUES ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'), 5, TIME '18:00', TIME '14:00')
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'dominio',
    'percentual de gordura acima de 100',
    $cmd$
    UPDATE EVOLUCAO SET perc_gordura = 120.00 WHERE data_avaliacao = DATE '2026-03-12'
    $cmd$
);

SELECT pg_temp.deve_recusar(
    'dominio',
    'plano de treino com frequencia semanal de 9 dias',
    $cmd$
    UPDATE PLANO_TREINO SET frequencia_semanal = 9 WHERE data_inicio = DATE '2026-03-11'
    $cmd$
);


-- RELATORIO

SELECT grupo, caso, situacao, detalhe
  FROM resultado_teste
 ORDER BY id;

SELECT
    count(*)                                        AS total,
    count(*) FILTER (WHERE situacao = 'PASSOU')     AS passou,
    count(*) FILTER (WHERE situacao = 'FALHOU')     AS falhou
  FROM resultado_teste;

ROLLBACK;
