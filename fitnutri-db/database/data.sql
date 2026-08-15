-- Carga inicial do FitNutri, em ordem de dependencias.
--
-- Execute este arquivo apos schema.sql e os arquivos em triggers/.
-- A carga localiza as chaves estrangeiras por CPF, nome ou data; assim, nao
-- depende de valores fixos das colunas GENERATED ALWAYS AS IDENTITY.

BEGIN;

-- Pacientes
INSERT INTO PACIENTE (
    cpf, rg, nome, sexo, data_nascimento,
    endereco_cep, endereco_estado, endereco_cidade, endereco_bairro,
    endereco_logradouro, endereco_numero, endereco_complemento,
    email, profissao, altura, peso_ini, obj_principal
)
VALUES
    ('12345678901', 'MG1234567', 'Ana Beatriz Costa', 'F', DATE '1994-05-18',
     '30130010', 'MG', 'Belo Horizonte', 'Funcionarios',
     'Avenida Afonso Pena', '1200', 'Apto 502',
     'ana.costa@example.com', 'Analista de sistemas', 1.65, 72.40,
     'Reduzir percentual de gordura e melhorar o condicionamento'),
    ('23456789012', 'SP9876543', 'Bruno Henrique Lima', 'M', DATE '1988-11-02',
     '01310930', 'SP', 'Sao Paulo', 'Bela Vista',
     'Rua Martiniano de Carvalho', '425', NULL,
     'bruno.lima@example.com', 'Professor', 1.78, 91.80,
     'Ganhar massa muscular com seguranca'),
    ('34567890123', 'RJ4567890', 'Carla Mendes Rocha', 'F', DATE '1999-02-24',
     '22041080', 'RJ', 'Rio de Janeiro', 'Botafogo',
     'Rua Voluntarios da Patria', '88', 'Casa 3',
     'carla.rocha@example.com', 'Designer', 1.60, 64.20,
     'Organizar a alimentacao e criar rotina de exercicios'),
    ('45678901235', 'PR7654321', 'Diego Araujo Nunes', 'M', DATE '1992-07-10',
     '80010000', 'PR', 'Curitiba', 'Centro',
     'Rua das Flores', '210', 'Sala 12',
     'diego.nunes@example.com', 'Administrador', 1.82, 84.50,
     'Melhorar resistencia cardiovascular'),
    ('56789012346', 'PE1357924', 'Elisa Santos Moura', 'F', DATE '1985-09-29',
     '50030000', 'PE', 'Recife', 'Boa Viagem',
     'Avenida Conselheiro Aguiar', '1500', 'Apto 804',
     'elisa.moura@example.com', 'Enfermeira', 1.68, 76.30,
     'Retomar atividade fisica de forma gradual')
ON CONFLICT DO NOTHING;

-- Telefones e informacoes de saude declaradas pelos pacientes.
-- Os identificadores sao gerados pelo banco (GENERATED ALWAYS AS IDENTITY).
INSERT INTO TELEFONE_PACIENTE (id_paciente, numero_telefone)
SELECT p.id_paciente, v.numero_telefone
FROM PACIENTE AS p
JOIN (VALUES
    ('12345678901', '+55 31 99876-1234'),
    ('23456789012', '+55 11 98765-4321'),
    ('34567890123', '+55 21 99654-3210'),
    ('45678901235', '+55 41 99543-2109'),
    ('56789012346', '+55 81 99432-1098')
) AS v(cpf, numero_telefone) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO CONTATO_EMERGENCIA (id_paciente, nome, numero)
SELECT p.id_paciente, v.nome, v.numero
FROM PACIENTE AS p
JOIN (VALUES
    ('12345678901', 'Marcos Costa', '+55 31 99111-2233'),
    ('23456789012', 'Fernanda Lima', '+55 11 98888-7766'),
    ('34567890123', 'Juliana Rocha', '+55 21 97777-6655'),
    ('45678901235', 'Renata Nunes', '+55 41 96666-5544'),
    ('56789012346', 'Paulo Moura', '+55 81 95555-4433')
) AS v(cpf, nome, numero) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO RESTRICAO_FISICA (id_paciente, limitacoes_fisicas)
SELECT p.id_paciente, v.limitacoes_fisicas
FROM PACIENTE AS p
JOIN (VALUES
    ('12345678901', 'Evitar impacto excessivo no joelho direito'),
    ('34567890123', 'Nenhuma restricao fisica declarada')
) AS v(cpf, limitacoes_fisicas) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO RESTRICAO_ALIMENTAR (id_paciente, limitacoes_alimentares)
SELECT p.id_paciente, v.limitacoes_alimentares
FROM PACIENTE AS p
JOIN (VALUES
    ('12345678901', 'Reduzir consumo de alimentos ultraprocessados'),
    ('34567890123', 'Evitar frutos do mar')
) AS v(cpf, limitacoes_alimentares) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO PACIENTE_DOENCA (id_paciente, doencas)
SELECT p.id_paciente, v.doencas
FROM PACIENTE AS p
JOIN (VALUES
    ('23456789012', 'Hipertensao arterial controlada')
) AS v(cpf, doencas) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO PACIENTE_ALERGIA (id_paciente, alergias)
SELECT p.id_paciente, v.alergias
FROM PACIENTE AS p
JOIN (VALUES
    ('34567890123', 'Crustaceos')
) AS v(cpf, alergias) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO MEDICAMENTO (id_paciente, medicamentos)
SELECT p.id_paciente, v.medicamentos
FROM PACIENTE AS p
JOIN (VALUES
    ('23456789012', 'Losartana 50 mg')
) AS v(cpf, medicamentos) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

-- Cadastros principais de profissionais.
INSERT INTO PROFISSIONAL (
    nome, cpf, email, endereco_cep, endereco_estado, endereco_cidade,
    data_contrato
)
VALUES
    ('Daniela Freitas Souza', '45678901234', 'daniela.souza@example.com',
     '30140071', 'MG', 'Belo Horizonte', DATE '2024-01-15'),
    ('Eduardo Martins Alves', '56789012345', 'eduardo.alves@example.com',
     '01311000', 'SP', 'Sao Paulo', DATE '2023-08-01'),
    ('Fernanda Ribeiro Lopes', '67890123457', 'fernanda.lopes@example.com',
     '22011040', 'RJ', 'Rio de Janeiro', DATE '2025-03-10'),
    ('Gabriel Teixeira Ramos', '78901234568', 'gabriel.ramos@example.com',
     '50050000', 'PE', 'Recife', DATE '2024-06-17')
ON CONFLICT DO NOTHING;

-- Catalogos reutilizaveis
INSERT INTO PLANO_SERVICO (
    nome_do_plano, descricao, valor_mensal, periodicidade, data_inicio
)
VALUES
    ('Essencial', 'Acompanhamento mensal com uma consulta e orientacoes gerais.',
     149.90, 'Mensal', DATE '2026-01-01'),
    ('Completo', 'Acompanhamento integrado de nutricao e atividade fisica.',
     249.90, 'Mensal', DATE '2026-01-01'),
    ('Trimestral', 'Plano completo com contratacao trimestral.',
     699.00, 'Trimestral', DATE '2026-01-01')
ON CONFLICT DO NOTHING;

INSERT INTO EXERCICIO (nome, grupo_muscular, modalidade)
VALUES
    ('Agachamento livre', 'Membros inferiores', 'Musculacao'),
    ('Supino reto', 'Peitoral', 'Musculacao'),
    ('Remada baixa', 'Costas', 'Musculacao'),
    ('Caminhada', 'Cardiovascular', 'Aerobico'),
    ('Prancha abdominal', 'Core', 'Funcional'),
    ('Levantamento terra', 'Posterior de coxa', 'Musculacao'),
    ('Desenvolvimento com halteres', 'Ombros', 'Musculacao'),
    ('Puxada frontal', 'Costas', 'Musculacao'),
    ('Afundo', 'Membros inferiores', 'Musculacao'),
    ('Rosca direta', 'Biceps', 'Musculacao'),
    ('Triceps na polia', 'Triceps', 'Musculacao'),
    ('Bicicleta ergometrica', 'Cardiovascular', 'Aerobico'),
    ('Eliptico', 'Cardiovascular', 'Aerobico'),
    ('Alongamento de cadeia posterior', 'Flexibilidade', 'Mobilidade'),
    ('Abdominal bicicleta', 'Core', 'Funcional')
ON CONFLICT DO NOTHING;

-- valor_calorico_porcao e uma coluna gerada: por isso nao e informado.
INSERT INTO ALIMENTO (
    nome, grupo_alimentar, porcao_referencia,
    proteinas_porcao, carboidratos_porcao, gorduras_porcao
)
VALUES
    ('Arroz integral cozido', 'Cereais', 100.00, 2.60, 25.80, 1.00),
    ('Peito de frango grelhado', 'Carnes e ovos', 100.00, 31.00, 0.00, 3.60),
    ('Banana prata', 'Frutas', 80.00, 1.00, 20.80, 0.10),
    ('Aveia em flocos', 'Cereais', 40.00, 5.60, 26.40, 2.80),
    ('Iogurte natural', 'Laticinios', 170.00, 8.50, 9.00, 5.00),
    ('Feijao carioca cozido', 'Leguminosas', 100.00, 4.80, 13.60, 0.50),
    ('Ovo de galinha cozido', 'Carnes e ovos', 50.00, 6.30, 0.60, 5.30),
    ('Batata-doce cozida', 'Tuberculos', 100.00, 0.60, 18.40, 0.10),
    ('Brocolis cozido', 'Hortalicas', 100.00, 2.10, 3.90, 0.40),
    ('Maca', 'Frutas', 130.00, 0.40, 17.00, 0.30),
    ('Leite desnatado', 'Laticinios', 200.00, 6.80, 10.00, 0.20),
    ('Pao integral', 'Cereais', 50.00, 4.50, 22.00, 1.80),
    ('Castanha-do-para', 'Oleaginosas', 15.00, 2.10, 1.80, 10.00),
    ('Azeite de oliva', 'Oleaginosas', 10.00, 0.00, 0.00, 10.00),
    ('Salmao grelhado', 'Carnes e ovos', 100.00, 25.40, 0.00, 13.40)
ON CONFLICT DO NOTHING;

-- PROFISSIONAIS
INSERT INTO TELEFONE_PROFISSIONAL (id_profissional, numero_telefone)
SELECT p.id_profissional, v.numero_telefone
FROM PROFISSIONAL AS p
JOIN (VALUES
    ('45678901234', '31987654321'),
    ('56789012345', '11987654321'),
    ('67890123457', '21987654321'),
    ('78901234568', '81987654321')
) AS v(cpf, numero_telefone) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO DISPONIBILIDADE_PROFISSIONAL (
    id_profissional, dia_semana, hora_ini, hora_fim
)
SELECT p.id_profissional, v.dia_semana, v.hora_ini, v.hora_fim
FROM PROFISSIONAL AS p
JOIN (VALUES
    ('45678901234', 1, TIME '08:00', TIME '12:00'),
    ('45678901234', 3, TIME '14:00', TIME '18:00'),
    ('56789012345', 2, TIME '08:00', TIME '12:00'),
    ('56789012345', 4, TIME '14:00', TIME '18:00'),
    ('67890123457', 2, TIME '09:00', TIME '13:00'),
    ('78901234568', 5, TIME '08:00', TIME '12:00')
) AS v(cpf, dia_semana, hora_ini, hora_fim) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO NUTRICIONISTA (id_profissional, crn)
SELECT id_profissional, crn
FROM PROFISSIONAL
JOIN (VALUES
    ('45678901234', 'CRN-9 12345'),
    ('67890123457', 'CRN-4 23456')
) AS v(cpf, crn) USING (cpf)
ON CONFLICT DO NOTHING;

INSERT INTO EDUCADOR_FISICO (id_profissional, cref)
SELECT id_profissional, cref
FROM PROFISSIONAL
JOIN (VALUES
    ('56789012345', 'CREF-4 123456-G/SP'),
    ('78901234568', 'CREF-12 234567-G/PE')
) AS v(cpf, cref) USING (cpf)
ON CONFLICT DO NOTHING;

INSERT INTO ESPECIALIDADE_NUTRICIONISTA (id_profissional, especialidade)
SELECT p.id_profissional, v.especialidade
FROM PROFISSIONAL AS p
JOIN (VALUES
    ('45678901234', 'Nutricao esportiva'),
    ('67890123457', 'Reeducacao alimentar')
) AS v(cpf, especialidade) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO ESPECIALIDADE_EDUCADOR (id_profissional, especializacao)
SELECT p.id_profissional, v.especializacao
FROM PROFISSIONAL AS p
JOIN (VALUES
    ('56789012345', 'Musculacao'),
    ('78901234568', 'Treinamento funcional')
) AS v(cpf, especializacao) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

-- CONSULTAS
INSERT INTO CONSULTA_FISICA (
    id_paciente, id_profissional, data_consulta, horario, tipo_consulta,
    avaliacao_fisica, freq_cardiaca, press_arterial, cond_fisico, prox_consulta
)
SELECT pa.id_paciente, pr.id_profissional, v.data_consulta, v.horario,
       v.tipo_consulta, v.avaliacao_fisica, v.freq_cardiaca,
       v.press_arterial, v.cond_fisico, v.prox_consulta
FROM (VALUES
    ('12345678901', '56789012345', DATE '2026-03-05', TIME '09:00', 'Avaliacao inicial', 'Avaliacao postural e funcional realizada.', 72, '120/80', 'Condicionamento iniciante', DATE '2026-04-05'),
    ('23456789012', '78901234568', DATE '2026-03-07', TIME '10:00', 'Avaliacao inicial', 'Teste de mobilidade e forca realizado.', 78, '130/85', 'Condicionamento intermediario', DATE '2026-04-07'),
    ('45678901235', '56789012345', DATE '2026-03-10', TIME '16:00', 'Avaliacao inicial', 'Avaliacao cardiovascular realizada.', 74, '118/78', 'Condicionamento iniciante', DATE '2026-04-10')
) AS v(cpf_paciente, cpf_profissional, data_consulta, horario, tipo_consulta, avaliacao_fisica, freq_cardiaca, press_arterial, cond_fisico, prox_consulta)
JOIN PACIENTE AS pa ON pa.cpf = v.cpf_paciente
JOIN PROFISSIONAL AS pr ON pr.cpf = v.cpf_profissional
ON CONFLICT DO NOTHING;

INSERT INTO CONSULTA_NUTRICIONAL (
    id_paciente, id_profissional, data_consulta, horario,
    objetivo_nutricional, suplementacao, consumo_agua, prox_consulta
)
SELECT pa.id_paciente, pr.id_profissional, v.data_consulta, v.horario,
       v.objetivo_nutricional, v.suplementacao, v.consumo_agua, v.prox_consulta
FROM (VALUES
    ('12345678901', '45678901234', DATE '2026-03-06', TIME '10:30', 'Reducao de gordura corporal', 'Creatina 3 g por dia', 2.20, DATE '2026-04-06'),
    ('23456789012', '67890123457', DATE '2026-03-08', TIME '11:00', 'Ganho de massa muscular', 'Whey protein apos o treino', 3.00, DATE '2026-04-08'),
    ('34567890123', '67890123457', DATE '2026-03-09', TIME '15:00', 'Melhorar a rotina alimentar', NULL, 2.00, DATE '2026-04-09'),
    ('56789012346', '45678901234', DATE '2026-03-11', TIME '09:30', 'Reeducacao alimentar', 'Vitamina D conforme orientacao medica', 2.10, DATE '2026-04-11')
) AS v(cpf_paciente, cpf_profissional, data_consulta, horario, objetivo_nutricional, suplementacao, consumo_agua, prox_consulta)
JOIN PACIENTE AS pa ON pa.cpf = v.cpf_paciente
JOIN PROFISSIONAL AS pr ON pr.cpf = v.cpf_profissional
ON CONFLICT DO NOTHING;

INSERT INTO OBJETIVO_FISICO_PACIENTE (id_consulta_fisica, objetivo)
SELECT cf.id_consulta_fisica, v.objetivo
FROM CONSULTA_FISICA AS cf
JOIN PACIENTE AS p ON p.id_paciente = cf.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-05', 'Caminhar 5 km sem desconforto'),
    ('23456789012', DATE '2026-03-07', 'Aumentar a forca nos exercicios basicos'),
    ('45678901235', DATE '2026-03-10', 'Completar 30 minutos de exercicio aerobico')
) AS v(cpf, data_consulta, objetivo) ON v.cpf = p.cpf AND v.data_consulta = cf.data_consulta;

INSERT INTO RECOMENDACAO_FISICA (id_consulta_fisica, recomendacao)
SELECT cf.id_consulta_fisica, v.recomendacao
FROM CONSULTA_FISICA AS cf
JOIN PACIENTE AS p ON p.id_paciente = cf.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-05', 'Priorizar movimentos sem impacto no joelho direito.'),
    ('23456789012', DATE '2026-03-07', 'Manter progressao gradual de cargas.'),
    ('45678901235', DATE '2026-03-10', 'Iniciar com intensidade leve a moderada.')
) AS v(cpf, data_consulta, recomendacao) ON v.cpf = p.cpf AND v.data_consulta = cf.data_consulta;

INSERT INTO OBSERVACAO_GERAL_CONSULTA_FISICA (id_consulta_fisica, obs_geral)
SELECT cf.id_consulta_fisica, v.obs_geral
FROM CONSULTA_FISICA AS cf
JOIN PACIENTE AS p ON p.id_paciente = cf.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-05', 'Paciente motivada e sem dor durante a avaliacao.'),
    ('23456789012', DATE '2026-03-07', 'Boa tolerancia aos testes de forca.'),
    ('45678901235', DATE '2026-03-10', 'Liberacao medica recomendada antes de aumentar a intensidade.')
) AS v(cpf, data_consulta, obs_geral) ON v.cpf = p.cpf AND v.data_consulta = cf.data_consulta;

INSERT INTO INTOLERANCIA_CONSULTA_NUTRI (id_consulta_nutricional, intolerancia)
SELECT cn.id_consulta_nutricional, v.intolerancia
FROM CONSULTA_NUTRICIONAL AS cn
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente
JOIN (VALUES
    ('34567890123', DATE '2026-03-09', 'Lactose')
) AS v(cpf, data_consulta, intolerancia) ON v.cpf = p.cpf AND v.data_consulta = cn.data_consulta;

INSERT INTO HABITO_ALIMENTAR (id_consulta_nutricional, habito_alimentar)
SELECT cn.id_consulta_nutricional, v.habito_alimentar
FROM CONSULTA_NUTRICIONAL AS cn
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-06', 'Realiza tres refeicoes principais e um lanche por dia.'),
    ('23456789012', DATE '2026-03-08', 'Costuma realizar refeicao apos o treino.'),
    ('34567890123', DATE '2026-03-09', 'Costuma pular o cafe da manha.'),
    ('56789012346', DATE '2026-03-11', 'Consome frutas diariamente.')
) AS v(cpf, data_consulta, habito_alimentar) ON v.cpf = p.cpf AND v.data_consulta = cn.data_consulta;

INSERT INTO OBSERVACAO_CLINICA (id_consulta_nutricional, observacoes_clinicas)
SELECT cn.id_consulta_nutricional, v.observacoes_clinicas
FROM CONSULTA_NUTRICIONAL AS cn
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-06', 'Sem alteracoes clinicas relevantes.'),
    ('23456789012', DATE '2026-03-08', 'Pressao arterial acompanhada por medico.'),
    ('34567890123', DATE '2026-03-09', 'Relata desconforto apos consumo de leite.')
) AS v(cpf, data_consulta, observacoes_clinicas) ON v.cpf = p.cpf AND v.data_consulta = cn.data_consulta;

INSERT INTO RECOMENDACAO_NUTRICIONAL (id_consulta_nutricional, recomendacao)
SELECT cn.id_consulta_nutricional, v.recomendacao
FROM CONSULTA_NUTRICIONAL AS cn
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-06', 'Distribuir proteinas ao longo do dia.'),
    ('23456789012', DATE '2026-03-08', 'Aumentar carboidratos proximos ao treino.'),
    ('34567890123', DATE '2026-03-09', 'Planejar cafe da manha com fruta e aveia.'),
    ('56789012346', DATE '2026-03-11', 'Priorizar alimentos in natura.')
) AS v(cpf, data_consulta, recomendacao) ON v.cpf = p.cpf AND v.data_consulta = cn.data_consulta;

-- PLANOS DE TREINO
INSERT INTO PLANO_TREINO (
    id_consulta_fisica, data_inicio, data_fim, dificuldade,
    frequencia_semanal, duracao
)
SELECT cf.id_consulta_fisica, v.data_inicio, v.data_fim, v.dificuldade,
       v.frequencia_semanal, v.duracao
FROM CONSULTA_FISICA AS cf
JOIN PACIENTE AS p ON p.id_paciente = cf.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-05', DATE '2026-03-06', DATE '2026-05-06', 'Iniciante', 3, 45),
    ('23456789012', DATE '2026-03-07', DATE '2026-03-08', DATE '2026-05-08', 'Intermediario', 4, 60),
    ('45678901235', DATE '2026-03-10', DATE '2026-03-11', DATE '2026-05-11', 'Iniciante', 3, 40)
) AS v(cpf, data_consulta, data_inicio, data_fim, dificuldade, frequencia_semanal, duracao)
ON v.cpf = p.cpf AND v.data_consulta = cf.data_consulta;

INSERT INTO OBJETIVO_TREINO (id_plano_treino, objetivos)
SELECT pt.id_plano_treino, v.objetivos
FROM PLANO_TREINO AS pt
JOIN CONSULTA_FISICA AS cf ON cf.id_consulta_fisica = pt.id_consulta_fisica
JOIN PACIENTE AS p ON p.id_paciente = cf.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-06', 'Melhorar resistencia e mobilidade'),
    ('23456789012', DATE '2026-03-08', 'Aumentar forca e hipertrofia'),
    ('45678901235', DATE '2026-03-11', 'Criar aderencia ao exercicio')
) AS v(cpf, data_inicio, objetivos) ON v.cpf = p.cpf AND v.data_inicio = pt.data_inicio;

INSERT INTO OBSERVACAO_GERAL_PLANO_TREINO (id_plano_treino, obs_geral)
SELECT pt.id_plano_treino, v.obs_geral
FROM PLANO_TREINO AS pt
JOIN CONSULTA_FISICA AS cf ON cf.id_consulta_fisica = pt.id_consulta_fisica
JOIN PACIENTE AS p ON p.id_paciente = cf.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-06', 'Respeitar os limites do joelho direito.'),
    ('23456789012', DATE '2026-03-08', 'Registrar as cargas utilizadas.'),
    ('45678901235', DATE '2026-03-11', 'Priorizar regularidade antes de intensidade.')
) AS v(cpf, data_inicio, obs_geral) ON v.cpf = p.cpf AND v.data_inicio = pt.data_inicio;

INSERT INTO PLANO_TREINO_PODE_CONTER_EXERCICIO (
    id_exercicio, id_plano_treino, intervalo, tempo_execucao, carga, repeticao, serie
)
SELECT e.id_exercicio, pt.id_plano_treino, v.intervalo, v.tempo_execucao,
       v.carga, v.repeticao, v.serie
FROM (VALUES
    ('12345678901', DATE '2026-03-06', 'Caminhada', INTERVAL '1 minute', 30, 0, 1, 1),
    ('12345678901', DATE '2026-03-06', 'Prancha abdominal', INTERVAL '45 seconds', 30, 0, 3, 3),
    ('23456789012', DATE '2026-03-08', 'Agachamento livre', INTERVAL '90 seconds', 45, 40, 10, 4),
    ('23456789012', DATE '2026-03-08', 'Supino reto', INTERVAL '90 seconds', 40, 35, 10, 4),
    ('45678901235', DATE '2026-03-11', 'Bicicleta ergometrica', INTERVAL '1 minute', 25, 0, 1, 1)
) AS v(cpf, data_inicio, nome_exercicio, intervalo, tempo_execucao, carga, repeticao, serie)
JOIN EXERCICIO AS e ON e.nome = v.nome_exercicio
JOIN PLANO_TREINO AS pt ON pt.data_inicio = v.data_inicio
JOIN CONSULTA_FISICA AS cf ON cf.id_consulta_fisica = pt.id_consulta_fisica
JOIN PACIENTE AS p ON p.id_paciente = cf.id_paciente AND p.cpf = v.cpf
ON CONFLICT DO NOTHING;

INSERT INTO OBSERVACAO_TECNICA (id_plano_treino, id_exercicio, observacoes)
SELECT pt.id_plano_treino, e.id_exercicio, v.observacoes
FROM (VALUES
    ('12345678901', DATE '2026-03-06', 'Prancha abdominal', 'Manter alinhamento neutro da coluna.'),
    ('23456789012', DATE '2026-03-08', 'Agachamento livre', 'Descer ate onde houver controle e conforto.'),
    ('23456789012', DATE '2026-03-08', 'Supino reto', 'Manter escapulas estabilizadas.'),
    ('45678901235', DATE '2026-03-11', 'Bicicleta ergometrica', 'Manter cadencia confortavel.')
) AS v(cpf, data_inicio, nome_exercicio, observacoes)
JOIN EXERCICIO AS e ON e.nome = v.nome_exercicio
JOIN PLANO_TREINO AS pt ON pt.data_inicio = v.data_inicio
JOIN CONSULTA_FISICA AS cf ON cf.id_consulta_fisica = pt.id_consulta_fisica
JOIN PACIENTE AS p ON p.id_paciente = cf.id_paciente AND p.cpf = v.cpf;

-- PLANOS ALIMENTARES
INSERT INTO PLANO_ALIMENTAR (
    id_consulta_nutricional, objetivo_nutri, quantidade_proteina,
    quantidade_caloria_diaria, quantidade_carboidrato, quantidade_gordura,
    data_inicio, data_termino
)
SELECT cn.id_consulta_nutricional, v.objetivo_nutri, v.proteina,
       v.calorias, v.carboidrato, v.gordura, v.data_inicio, v.data_termino
FROM CONSULTA_NUTRICIONAL AS cn
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-06', 'Reducao de gordura corporal', 120.00, 1800.00, 190.00, 60.00, DATE '2026-03-07', DATE '2026-05-07'),
    ('23456789012', DATE '2026-03-08', 'Ganho de massa muscular', 170.00, 2800.00, 350.00, 75.00, DATE '2026-03-09', DATE '2026-05-09'),
    ('34567890123', DATE '2026-03-09', 'Melhorar a rotina alimentar', 100.00, 1700.00, 200.00, 50.00, DATE '2026-03-10', DATE '2026-05-10'),
    ('56789012346', DATE '2026-03-11', 'Reeducacao alimentar', 110.00, 1900.00, 210.00, 55.00, DATE '2026-03-12', DATE '2026-05-12')
) AS v(cpf, data_consulta, objetivo_nutri, proteina, calorias, carboidrato, gordura, data_inicio, data_termino)
ON v.cpf = p.cpf AND v.data_consulta = cn.data_consulta;

INSERT INTO OBSERVACAO_PLANO_ALIMENTAR (id_plano_alimentar, obs_geral)
SELECT pa.id_plano_alimentar, v.obs_geral
FROM PLANO_ALIMENTAR AS pa
JOIN CONSULTA_NUTRICIONAL AS cn ON cn.id_consulta_nutricional = pa.id_consulta_nutricional
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-07', 'Preparar lanches para evitar ultraprocessados.'),
    ('23456789012', DATE '2026-03-09', 'Ajustar porcoes conforme a resposta ao treino.'),
    ('34567890123', DATE '2026-03-10', 'Usar opcoes sem lactose quando necessario.'),
    ('56789012346', DATE '2026-03-12', 'Manter horarios regulares para as refeicoes.')
) AS v(cpf, data_inicio, obs_geral) ON v.cpf = p.cpf AND v.data_inicio = pa.data_inicio;

INSERT INTO REFEICAO (id_plano_alimentar, nome, horario)
SELECT pa.id_plano_alimentar, v.nome, v.horario
FROM PLANO_ALIMENTAR AS pa
JOIN CONSULTA_NUTRICIONAL AS cn ON cn.id_consulta_nutricional = pa.id_consulta_nutricional
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-07', 'Cafe da manha', TIME '07:00'),
    ('12345678901', DATE '2026-03-07', 'Almoco', TIME '12:30'),
    ('23456789012', DATE '2026-03-09', 'Cafe da manha', TIME '07:30'),
    ('23456789012', DATE '2026-03-09', 'Pos-treino', TIME '19:00'),
    ('34567890123', DATE '2026-03-10', 'Cafe da manha', TIME '08:00'),
    ('56789012346', DATE '2026-03-12', 'Jantar', TIME '19:30')
) AS v(cpf, data_inicio, nome, horario) ON v.cpf = p.cpf AND v.data_inicio = pa.data_inicio
ON CONFLICT DO NOTHING;

INSERT INTO REFEICAO_CONTEM_ALIMENTO (
    id_alimento, id_plano_alimentar, id_refeicao, unidade_de_medida, quantidade, substituicao_permitida
)
SELECT a.id_alimento, r.id_plano_alimentar, r.id_refeicao,
       v.unidade_de_medida, v.quantidade, v.substituicao_permitida
FROM (VALUES
    ('12345678901', DATE '2026-03-07', 'Cafe da manha', TIME '07:00', 'Aveia em flocos', 'g', 40.00, 'Pode substituir por pao integral.'),
    ('12345678901', DATE '2026-03-07', 'Cafe da manha', TIME '07:00', 'Banana prata', 'unidade', 1.00, 'Pode substituir por maca.'),
    ('12345678901', DATE '2026-03-07', 'Almoco', TIME '12:30', 'Peito de frango grelhado', 'g', 120.00, 'Pode substituir por salmao grelhado.'),
    ('23456789012', DATE '2026-03-09', 'Cafe da manha', TIME '07:30', 'Pao integral', 'g', 100.00, NULL),
    ('23456789012', DATE '2026-03-09', 'Pos-treino', TIME '19:00', 'Iogurte natural', 'ml', 170.00, 'Pode substituir por leite desnatado.'),
    ('34567890123', DATE '2026-03-10', 'Cafe da manha', TIME '08:00', 'Maca', 'unidade', 1.00, 'Pode substituir por banana prata.'),
    ('56789012346', DATE '2026-03-12', 'Jantar', TIME '19:30', 'Feijao carioca cozido', 'g', 100.00, NULL)
) AS v(cpf, data_inicio, nome_refeicao, horario, nome_alimento, unidade_de_medida, quantidade, substituicao_permitida)
JOIN ALIMENTO AS a ON a.nome = v.nome_alimento
JOIN PLANO_ALIMENTAR AS pa ON pa.data_inicio = v.data_inicio
JOIN CONSULTA_NUTRICIONAL AS cn ON cn.id_consulta_nutricional = pa.id_consulta_nutricional
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente AND p.cpf = v.cpf
JOIN REFEICAO AS r ON r.id_plano_alimentar = pa.id_plano_alimentar
                  AND r.nome = v.nome_refeicao AND r.horario = v.horario
ON CONFLICT DO NOTHING;

INSERT INTO OBSERVACAO_REFEICAO_CONTEM (
    id_alimento, id_plano_alimentar, id_refeicao, observacao
)
SELECT a.id_alimento, r.id_plano_alimentar, r.id_refeicao, v.observacao
FROM (VALUES
    ('12345678901', DATE '2026-03-07', 'Cafe da manha', TIME '07:00', 'Aveia em flocos', 'Consumir com iogurte natural.'),
    ('23456789012', DATE '2026-03-09', 'Pos-treino', TIME '19:00', 'Iogurte natural', 'Consumir logo apos o treino.'),
    ('34567890123', DATE '2026-03-10', 'Cafe da manha', TIME '08:00', 'Maca', 'Associar com fonte de proteina.')
) AS v(cpf, data_inicio, nome_refeicao, horario, nome_alimento, observacao)
JOIN ALIMENTO AS a ON a.nome = v.nome_alimento
JOIN PLANO_ALIMENTAR AS pa ON pa.data_inicio = v.data_inicio
JOIN CONSULTA_NUTRICIONAL AS cn ON cn.id_consulta_nutricional = pa.id_consulta_nutricional
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente AND p.cpf = v.cpf
JOIN REFEICAO AS r ON r.id_plano_alimentar = pa.id_plano_alimentar
                  AND r.nome = v.nome_refeicao AND r.horario = v.horario;

-- EVOLUCOES
INSERT INTO EVOLUCAO (data_avaliacao, peso, perc_gordura, medida_corporal)
VALUES
    (DATE '2026-04-05', 70.80, 29.50, 'Cintura: 78 cm; quadril: 101 cm'),
    (DATE '2026-04-07', 92.40, 22.10, 'Cintura: 91 cm; torax: 108 cm'),
    (DATE '2026-04-09', 63.10, 27.80, 'Cintura: 74 cm; quadril: 98 cm'),
    (DATE '2026-04-11', 75.20, 31.40, 'Cintura: 82 cm; quadril: 105 cm');

INSERT INTO EVOLUCAO_FISICA (
    id_evolucao, id_consulta_fisica, massa_muscular, circ_abdominal, circ_toracica, desempenho_fisico
)
SELECT e.id_evolucao, cf.id_consulta_fisica, v.massa_muscular,
       v.circ_abdominal, v.circ_toracica, v.desempenho_fisico
FROM (VALUES
    ('12345678901', DATE '2026-03-05', DATE '2026-04-05', 28.50, 78.00, 92.00, 'Melhora na estabilidade do core.'),
    ('23456789012', DATE '2026-03-07', DATE '2026-04-07', 39.20, 91.00, 108.00, 'Aumento de carga nos exercicios basicos.')
) AS v(cpf, data_consulta, data_avaliacao, massa_muscular, circ_abdominal, circ_toracica, desempenho_fisico)
JOIN EVOLUCAO AS e ON e.data_avaliacao = v.data_avaliacao
JOIN PACIENTE AS p ON p.cpf = v.cpf
JOIN CONSULTA_FISICA AS cf ON cf.id_paciente = p.id_paciente AND cf.data_consulta = v.data_consulta;

INSERT INTO EVOLUCAO_NUTRICIONAL (
    id_evolucao, id_consulta_nutricional, aderencia_alimentar, consumo_calorico, evolucao_clinica
)
SELECT e.id_evolucao, cn.id_consulta_nutricional, v.aderencia_alimentar,
       v.consumo_calorico, v.evolucao_clinica
FROM (VALUES
    ('34567890123', DATE '2026-03-09', DATE '2026-04-09', 'Boa aderencia aos horarios das refeicoes.', 1680, 'Menor desconforto digestivo.'),
    ('56789012346', DATE '2026-03-11', DATE '2026-04-11', 'Aderencia parcial ao plano alimentar.', 1850, 'Melhora na disposicao diaria.')
) AS v(cpf, data_consulta, data_avaliacao, aderencia_alimentar, consumo_calorico, evolucao_clinica)
JOIN EVOLUCAO AS e ON e.data_avaliacao = v.data_avaliacao
JOIN PACIENTE AS p ON p.cpf = v.cpf
JOIN CONSULTA_NUTRICIONAL AS cn ON cn.id_paciente = p.id_paciente AND cn.data_consulta = v.data_consulta;

INSERT INTO OBSERVACAO_EVOLUCAO (id_evolucao, observacao_evolucao)
SELECT e.id_evolucao, v.observacao_evolucao
FROM EVOLUCAO AS e
JOIN (VALUES
    (DATE '2026-04-05', 'Evolucao positiva na regularidade de exercicios.'),
    (DATE '2026-04-09', 'Paciente relatou melhor planejamento alimentar.')
) AS v(data_avaliacao, observacao_evolucao) ON v.data_avaliacao = e.data_avaliacao;

INSERT INTO META_ALCANCADA_EVOLUCAO (id_evolucao, metas_alcancadas)
SELECT e.id_evolucao, v.metas_alcancadas
FROM EVOLUCAO AS e
JOIN (VALUES
    (DATE '2026-04-05', 'Realizar tres treinos por semana.'),
    (DATE '2026-04-07', 'Aumentar a carga do agachamento com seguranca.'),
    (DATE '2026-04-11', 'Consumir pelo menos dois litros de agua por dia.')
) AS v(data_avaliacao, metas_alcancadas) ON v.data_avaliacao = e.data_avaliacao;

-- FINANCEIRO
INSERT INTO SERVICO_PLANO_SERVICO (id_plano_servico, servicos)
SELECT ps.id_plano_servico, v.servicos
FROM PLANO_SERVICO AS ps
JOIN (VALUES
    ('Essencial', 'Uma consulta mensal e orientacoes gerais.'),
    ('Completo', 'Consultas de nutricao e atividade fisica.'),
    ('Trimestral', 'Acompanhamento completo por tres meses.')
) AS v(nome_do_plano, servicos) ON v.nome_do_plano = ps.nome_do_plano;

INSERT INTO CONTRATA_PLANO (
    id_paciente, id_plano_servico, data_de_adesao, status_contratacao
)
SELECT p.id_paciente, ps.id_plano_servico, v.data_de_adesao, v.status_contratacao
FROM (VALUES
    ('12345678901', 'Completo', DATE '2026-03-01', 'Ativo'),
    ('23456789012', 'Completo', DATE '2026-03-01', 'Ativo'),
    ('34567890123', 'Essencial', DATE '2026-03-01', 'Ativo'),
    ('45678901235', 'Trimestral', DATE '2026-03-01', 'Ativo'),
    ('56789012346', 'Essencial', DATE '2026-03-01', 'Ativo')
) AS v(cpf, nome_do_plano, data_de_adesao, status_contratacao)
JOIN PACIENTE AS p ON p.cpf = v.cpf
JOIN PLANO_SERVICO AS ps ON ps.nome_do_plano = v.nome_do_plano
ON CONFLICT DO NOTHING;

INSERT INTO OBSERVACAO_CONTRATO (id_contrato, obs_contrato)
SELECT cp.id_contrato, v.obs_contrato
FROM CONTRATA_PLANO AS cp
JOIN PACIENTE AS p ON p.id_paciente = cp.id_paciente
JOIN (VALUES
    ('12345678901', DATE '2026-03-01', 'Contrato assinado digitalmente.'),
    ('45678901235', DATE '2026-03-01', 'Pagamento trimestral acordado.')
) AS v(cpf, data_de_adesao, obs_contrato) ON v.cpf = p.cpf AND v.data_de_adesao = cp.data_de_adesao;

INSERT INTO PAGAMENTO (
    id_contrato, tipo_cobranca, descricao, data_venc, data_pag,
    forma_pag, status_pag, desconto, multa
)
SELECT cp.id_contrato, v.tipo_cobranca, v.descricao, v.data_venc, v.data_pag,
       v.forma_pag, v.status_pag, v.desconto, v.multa
FROM (VALUES
    ('12345678901', DATE '2026-03-01', 'Mensalidade', 'Mensalidade de marco de 2026', DATE '2026-03-10', DATE '2026-03-08', 'Pix', 'Pago', 0.00, 0.00),
    ('23456789012', DATE '2026-03-01', 'Mensalidade', 'Mensalidade de marco de 2026', DATE '2026-03-10', DATE '2026-03-10', 'Cartao de credito', 'Pago', 10.00, 0.00),
    ('34567890123', DATE '2026-03-01', 'Mensalidade', 'Mensalidade de marco de 2026', DATE '2026-03-10', NULL, NULL, 'Pendente', 0.00, 0.00),
    ('45678901235', DATE '2026-03-01', 'Trimestral', 'Primeira parcela trimestral', DATE '2026-03-10', DATE '2026-03-12', 'Boleto', 'Atrasado', 0.00, 15.00),
    ('56789012346', DATE '2026-03-01', 'Mensalidade', 'Mensalidade de marco de 2026', DATE '2026-03-10', DATE '2026-03-09', 'Pix', 'Pago', 0.00, 0.00)
) AS v(cpf, data_de_adesao, tipo_cobranca, descricao, data_venc, data_pag, forma_pag, status_pag, desconto, multa)
JOIN PACIENTE AS p ON p.cpf = v.cpf
JOIN CONTRATA_PLANO AS cp ON cp.id_paciente = p.id_paciente AND cp.data_de_adesao = v.data_de_adesao;

INSERT INTO OBSERVACAO_PAGAMENTO (id_pagamento, observacao)
SELECT pg.id_pagamento, v.observacao
FROM PAGAMENTO AS pg
JOIN CONTRATA_PLANO AS cp ON cp.id_contrato = pg.id_contrato
JOIN PACIENTE AS p ON p.id_paciente = cp.id_paciente
JOIN (VALUES
    ('34567890123', DATE '2026-03-10', 'Pagamento pendente de confirmacao.'),
    ('45678901235', DATE '2026-03-10', 'Multa aplicada por pagamento apos o vencimento.')
) AS v(cpf, data_venc, observacao) ON v.cpf = p.cpf AND v.data_venc = pg.data_venc;

-- HISTORICOS
INSERT INTO HISTORICO_PLANO_TREINO (
    id_plano_treino, descricao_alteracao, id_profissional
)
SELECT pt.id_plano_treino, v.descricao_alteracao, pr.id_profissional
FROM (VALUES
    ('12345678901', DATE '2026-03-06', '56789012345', 'Plano de treino criado apos a avaliacao inicial.'),
    ('23456789012', DATE '2026-03-08', '78901234568', 'Carga inicial registrada no plano de treino.')
) AS v(cpf_paciente, data_inicio, cpf_profissional, descricao_alteracao)
JOIN PLANO_TREINO AS pt ON pt.data_inicio = v.data_inicio
JOIN CONSULTA_FISICA AS cf ON cf.id_consulta_fisica = pt.id_consulta_fisica
JOIN PACIENTE AS pa ON pa.id_paciente = cf.id_paciente AND pa.cpf = v.cpf_paciente
JOIN PROFISSIONAL AS pr ON pr.cpf = v.cpf_profissional;

INSERT INTO HISTORICO_PLANO_ALIMENTAR (
    id_plano_alimentar, descricao_alteracao, id_profissional
)
SELECT pa.id_plano_alimentar, v.descricao_alteracao, pr.id_profissional
FROM (VALUES
    ('12345678901', DATE '2026-03-07', '45678901234', 'Plano alimentar criado apos consulta nutricional.'),
    ('34567890123', DATE '2026-03-10', '67890123457', 'Substituicoes sem lactose registradas no plano.')
) AS v(cpf_paciente, data_inicio, cpf_profissional, descricao_alteracao)
JOIN PLANO_ALIMENTAR AS pa ON pa.data_inicio = v.data_inicio
JOIN CONSULTA_NUTRICIONAL AS cn ON cn.id_consulta_nutricional = pa.id_consulta_nutricional
JOIN PACIENTE AS p ON p.id_paciente = cn.id_paciente AND p.cpf = v.cpf_paciente
JOIN PROFISSIONAL AS pr ON pr.cpf = v.cpf_profissional;

COMMIT;
