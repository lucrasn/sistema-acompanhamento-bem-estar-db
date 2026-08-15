BEGIN;

-- BASE

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
     'Retomar atividade fisica de forma gradual');

INSERT INTO PROFISSIONAL (
    nome, cpf, email, endereco_cep, endereco_estado, endereco_cidade, data_contrato
)
VALUES
    ('Daniela Freitas Souza', '45678901234', 'daniela.souza@example.com',
     '30140071', 'MG', 'Belo Horizonte', DATE '2024-01-15'),
    ('Eduardo Martins Alves', '56789012345', 'eduardo.alves@example.com',
     '01311000', 'SP', 'Sao Paulo', DATE '2023-08-01'),
    ('Fernanda Ribeiro Lopes', '67890123457', 'fernanda.lopes@example.com',
     '22011040', 'RJ', 'Rio de Janeiro', DATE '2025-03-10'),
    ('Gabriel Teixeira Ramos', '78901234568', 'gabriel.ramos@example.com',
     '50050000', 'PE', 'Recife', DATE '2024-06-17');

INSERT INTO PLANO_SERVICO (
    nome_do_plano, descricao, valor_mensal, periodicidade, data_inicio
)
VALUES
    ('Essencial', 'Acompanhamento mensal com uma consulta e orientacoes gerais.',
     149.90, 'Mensal', DATE '2026-01-01'),
    ('Completo', 'Acompanhamento integrado de nutricao e atividade fisica.',
     249.90, 'Mensal', DATE '2026-01-01'),
    ('Trimestral', 'Plano completo com contratacao trimestral.',
     699.00, 'Trimestral', DATE '2026-01-01');

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
    ('Abdominal bicicleta', 'Core', 'Funcional');

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
    ('Salmao grelhado', 'Carnes e ovos', 100.00, 25.40, 0.00, 13.40);

-- Cada avaliacao tem uma data distinta, usada adiante para vincular a subclasse.
INSERT INTO EVOLUCAO (data_avaliacao, peso, perc_gordura, medida_corporal)
VALUES
    (DATE '2026-03-10', 71.20, 26.50, 'Cintura 78 cm, quadril 96 cm'),
    (DATE '2026-03-12', 90.40, 24.10, 'Cintura 94 cm, torax 104 cm'),
    (DATE '2026-03-14', 63.50, 27.80, 'Cintura 72 cm, quadril 94 cm'),
    (DATE '2026-03-16', 75.10, 30.20, 'Cintura 84 cm, quadril 102 cm');

-- PACIENTE

INSERT INTO TELEFONE_PACIENTE (id_paciente, numero_telefone)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'), '31998761234'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '23456789012'), '11987654321'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '34567890123'), '21996543210'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '45678901235'), '41995432109'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '56789012346'), '81994321098');

INSERT INTO CONTATO_EMERGENCIA (id_paciente, nome, numero)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'), 'Marcos Costa', '31991112233'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '23456789012'), 'Fernanda Lima', '11988887766'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '34567890123'), 'Juliana Rocha', '21977776655'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '45678901235'), 'Renata Nunes', '41966665544'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '56789012346'), 'Paulo Moura', '81955554433');

INSERT INTO RESTRICAO_FISICA (id_paciente, limitacoes_fisicas)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'), 'Evitar impacto excessivo no joelho direito'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '45678901235'), 'Hernia de disco lombar em acompanhamento'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '56789012346'), 'Limitacao de amplitude no ombro esquerdo');

INSERT INTO RESTRICAO_ALIMENTAR (id_paciente, limitacoes_alimentares)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'), 'Reduzir consumo de alimentos ultraprocessados'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '34567890123'), 'Evitar frutos do mar'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '56789012346'), 'Dieta com baixo teor de sodio');

INSERT INTO PACIENTE_DOENCA (id_paciente, doencas)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '23456789012'), 'Hipertensao arterial controlada'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '56789012346'), 'Hipotireoidismo');

INSERT INTO PACIENTE_ALERGIA (id_paciente, alergias)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '34567890123'), 'Crustaceos'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'), 'Lactose');

INSERT INTO MEDICAMENTO (id_paciente, medicamentos)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '23456789012'), 'Losartana 50 mg'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '56789012346'), 'Levotiroxina 75 mcg');

-- PROFISSIONAIS

-- Fernanda consta nas duas subclasses: a especializacao de PROFISSIONAL e sobreposta.
INSERT INTO NUTRICIONISTA (id_profissional, CRN)
VALUES
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'), 'CRN9-12345'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'), 'CRN4-23456');

INSERT INTO EDUCADOR_FISICO (id_profissional, CREF)
VALUES
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '56789012345'), 'CREF3-34567'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'), 'CREF1-45678'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '78901234568'), 'CREF7-56789');

INSERT INTO ESPECIALIDADE_NUTRICIONISTA (id_profissional, especialidade)
VALUES
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'), 'Nutricao esportiva'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'), 'Nutricao clinica'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'), 'Nutricao comportamental');

INSERT INTO ESPECIALIDADE_EDUCADOR (id_profissional, especializacao)
VALUES
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '56789012345'), 'Treinamento de forca'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'), 'Treinamento funcional'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '78901234568'), 'Reabilitacao musculoesqueletica');

INSERT INTO TELEFONE_PROFISSIONAL (id_profissional, numero_telefone)
VALUES
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'), '31988112233'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '56789012345'), '11977223344'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'), '21966334455'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '78901234568'), '81955445566');

INSERT INTO DISPONIBILIDADE_PROFISSIONAL (id_profissional, dia_semana, hora_ini, hora_fim)
VALUES
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'), 2, TIME '08:00', TIME '12:00'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'), 4, TIME '08:00', TIME '12:00'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '56789012345'), 3, TIME '14:00', TIME '18:00'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '56789012345'), 5, TIME '14:00', TIME '18:00'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'), 2, TIME '13:00', TIME '17:00'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'), 6, TIME '09:00', TIME '13:00'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '78901234568'), 3, TIME '07:00', TIME '11:00'),
    ((SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '78901234568'), 7, TIME '08:00', TIME '12:00');

-- CONSULTAS

INSERT INTO CONSULTA_FISICA (
    id_paciente, id_profissional, data_consulta, horario, tipo_consulta,
    avaliacao_fisica, freq_cardiaca, press_arterial, cond_fisico, prox_consulta
)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'),
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '56789012345'),
     DATE '2026-03-10', TIME '09:00', 'Avaliacao inicial',
     'Paciente sedentaria ha dois anos, sem dor articular no momento.',
     78, '120/80', 'Regular', DATE '2026-04-10'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '23456789012'),
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '78901234568'),
     DATE '2026-03-12', TIME '15:30', 'Avaliacao inicial',
     'Pratica musculacao ha seis meses, boa mobilidade geral.',
     72, '130/85', 'Bom', DATE '2026-04-12'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '45678901235'),
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'),
     DATE '2026-03-18', TIME '10:00', 'Retorno',
     'Retorno apos quatro semanas de treino, evolucao dentro do esperado.',
     68, '118/76', 'Bom', DATE '2026-04-18');

INSERT INTO CONSULTA_NUTRICIONAL (
    id_paciente, id_profissional, data_consulta, horario,
    objetivo_nutricional, suplementacao, consumo_agua, prox_consulta
)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'),
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'),
     DATE '2026-03-14', TIME '08:30',
     'Deficit calorico moderado com preservacao de massa magra',
     'Vitamina D 2000 UI ao dia', 2.20, DATE '2026-04-14'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '34567890123'),
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'),
     DATE '2026-03-16', TIME '14:00',
     'Reeducacao alimentar com foco em rotina de refeicoes',
     NULL, 1.80, DATE '2026-04-16'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '56789012346'),
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234'),
     DATE '2026-03-20', TIME '16:00',
     'Controle de sodio e suporte ao tratamento de hipotireoidismo',
     'Omega 3 1000 mg ao dia', 2.00, DATE '2026-04-20');

INSERT INTO OBJETIVO_FISICO_PACIENTE (id_consulta_fisica, objetivo)
VALUES
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-10'), 'Reduzir percentual de gordura'),
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-10'), 'Melhorar condicionamento cardiorrespiratorio'),
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-12'), 'Ganhar massa muscular'),
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-18'), 'Aumentar resistencia aerobica');

INSERT INTO RECOMENDACAO_FISICA (id_consulta_fisica, recomendacao)
VALUES
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-10'), 'Iniciar com tres sessoes semanais de baixo impacto.'),
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-12'), 'Progredir carga em no maximo 10 por cento por semana.'),
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-18'), 'Incluir trabalho de mobilidade antes de cada sessao.');

INSERT INTO OBSERVACAO_GERAL_CONSULTA_FISICA (id_consulta_fisica, obs_geral)
VALUES
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-10'), 'Relata desconforto no joelho ao subir escadas.'),
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-12'), 'Boa adesao ao treino anterior, sem faltas.'),
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-18'), 'Acompanhar quadro lombar nas proximas sessoes.');

INSERT INTO INTOLERANCIA_CONSULTA_NUTRI (id_consulta_nutricional, intolerancia)
VALUES
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-14'), 'Lactose'),
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-16'), 'Crustaceos');

INSERT INTO HABITO_ALIMENTAR (id_consulta_nutricional, habito_alimentar)
VALUES
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-14'), 'Pula o cafe da manha em dias de trabalho.'),
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-16'), 'Faz refeicoes fora de casa cinco vezes por semana.'),
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-20'), 'Consome pouco liquido ao longo do dia.');

INSERT INTO OBSERVACAO_CLINICA (id_consulta_nutricional, observacoes_clinicas)
VALUES
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-14'), 'Exames bioquimicos dentro da normalidade.'),
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-20'), 'TSH em acompanhamento com endocrinologista.');

INSERT INTO RECOMENDACAO_NUTRICIONAL (id_consulta_nutricional, recomendacao)
VALUES
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-14'), 'Distribuir a proteina entre as tres refeicoes principais.'),
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-16'), 'Planejar as refeicoes da semana no domingo.'),
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-20'), 'Substituir o sal por ervas no preparo dos pratos.');

-- TREINO

INSERT INTO PLANO_TREINO (
    id_consulta_fisica, data_inicio, data_fim, dificuldade, frequencia_semanal, duracao
)
VALUES
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-10'),
     DATE '2026-03-11', DATE '2026-06-11', 'Iniciante', 3, 50),
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-12'),
     DATE '2026-03-13', DATE '2026-06-13', 'Intermediario', 5, 70),
    ((SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-18'),
     DATE '2026-03-19', NULL, 'Intermediario', 4, 60);

INSERT INTO OBJETIVO_TREINO (id_plano_treino, objetivos)
VALUES
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-11'), 'Emagrecimento'),
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-11'), 'Condicionamento geral'),
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-13'), 'Hipertrofia'),
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-19'), 'Resistencia aerobica');

INSERT INTO OBSERVACAO_GERAL_PLANO_TREINO (id_plano_treino, obs_geral)
VALUES
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-11'), 'Evitar exercicios de impacto no joelho.'),
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-13'), 'Priorizar tecnica antes de aumentar carga.'),
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-19'), 'Interromper em caso de dor lombar.');

INSERT INTO PLANO_TREINO_PODE_CONTER_EXERCICIO (
    id_exercicio, id_plano_treino, intervalo, tempo_execucao, carga, repeticao, serie
)
VALUES
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Caminhada'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-11'),
     INTERVAL '0 seconds', 1800, 0, 1, 1),
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Agachamento livre'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-11'),
     INTERVAL '60 seconds', 40, 20, 12, 3),
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Prancha abdominal'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-11'),
     INTERVAL '45 seconds', 30, 0, 1, 3),
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Supino reto'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-13'),
     INTERVAL '90 seconds', 45, 60, 10, 4),
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Levantamento terra'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-13'),
     INTERVAL '120 seconds', 50, 90, 8, 4),
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Puxada frontal'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-13'),
     INTERVAL '90 seconds', 40, 50, 10, 4),
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Bicicleta ergometrica'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-19'),
     INTERVAL '0 seconds', 1200, 0, 1, 1),
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Alongamento de cadeia posterior'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-19'),
     INTERVAL '30 seconds', 40, 0, 1, 2);

INSERT INTO OBSERVACAO_TECNICA (id_exercicio, id_plano_treino, observacoes)
VALUES
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Agachamento livre'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-11'),
     'Reduzir a amplitude por causa do joelho direito.'),
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Levantamento terra'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-13'),
     'Manter a coluna neutra durante toda a execucao.'),
    ((SELECT id_exercicio FROM EXERCICIO WHERE nome = 'Alongamento de cadeia posterior'),
     (SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-19'),
     'Nao forcar alem do ponto de desconforto na lombar.');

-- NUTRICAO

INSERT INTO PLANO_ALIMENTAR (
    id_consulta_nutricional, objetivo_nutri,
    quantidade_proteina, quantidade_caloria_diaria, quantidade_carboidrato, quantidade_gordura,
    data_inicio, data_termino
)
VALUES
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-14'),
     'Deficit calorico de 400 kcal ao dia', 110.00, 1700.00, 180.00, 55.00,
     DATE '2026-03-15', DATE '2026-06-15'),
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-16'),
     'Manutencao com rotina de cinco refeicoes', 95.00, 1900.00, 220.00, 62.00,
     DATE '2026-03-17', DATE '2026-06-17'),
    ((SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-20'),
     'Reducao de sodio com aporte proteico adequado', 105.00, 1800.00, 200.00, 58.00,
     DATE '2026-03-21', NULL);

INSERT INTO OBSERVACAO_PLANO_ALIMENTAR (id_plano_alimentar, obs_geral)
VALUES
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-15'), 'Substituir laticinios por versoes sem lactose.'),
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-17'), 'Levar marmita nos dias de trabalho presencial.'),
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-21'), 'Nao adicionar sal apos o preparo.');

INSERT INTO REFEICAO (id_plano_alimentar, nome, horario)
VALUES
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-15'), 'Cafe da manha', TIME '07:00'),
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-15'), 'Almoco', TIME '12:00'),
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-15'), 'Jantar', TIME '19:30'),
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-17'), 'Cafe da manha', TIME '07:30'),
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-17'), 'Almoco', TIME '12:30'),
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-21'), 'Almoco', TIME '13:00'),
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-21'), 'Jantar', TIME '20:00');

INSERT INTO REFEICAO_CONTEM_ALIMENTO (
    id_alimento, id_plano_alimentar, id_refeicao,
    unidade_de_medida, quantidade, substituicao_permitida
)
SELECT a.id_alimento, r.id_plano_alimentar, r.id_refeicao, v.unidade, v.qtd, v.subst
FROM (VALUES
    (DATE '2026-03-15', 'Cafe da manha', 'Aveia em flocos', 'gramas', 40.00, 'Pao integral em porcao equivalente'),
    (DATE '2026-03-15', 'Cafe da manha', 'Banana prata', 'unidade', 1.00, 'Maca ou mamao'),
    (DATE '2026-03-15', 'Almoco', 'Arroz integral cozido', 'gramas', 100.00, 'Batata-doce cozida'),
    (DATE '2026-03-15', 'Almoco', 'Peito de frango grelhado', 'gramas', 120.00, 'Salmao grelhado ou ovo cozido'),
    (DATE '2026-03-15', 'Almoco', 'Brocolis cozido', 'gramas', 100.00, NULL),
    (DATE '2026-03-15', 'Jantar', 'Salmao grelhado', 'gramas', 100.00, 'Peito de frango grelhado'),
    (DATE '2026-03-17', 'Cafe da manha', 'Pao integral', 'fatia', 2.00, 'Aveia em flocos'),
    (DATE '2026-03-17', 'Cafe da manha', 'Ovo de galinha cozido', 'unidade', 2.00, NULL),
    (DATE '2026-03-17', 'Almoco', 'Feijao carioca cozido', 'gramas', 100.00, NULL),
    (DATE '2026-03-17', 'Almoco', 'Arroz integral cozido', 'gramas', 120.00, 'Batata-doce cozida'),
    (DATE '2026-03-21', 'Almoco', 'Batata-doce cozida', 'gramas', 150.00, 'Arroz integral cozido'),
    (DATE '2026-03-21', 'Almoco', 'Peito de frango grelhado', 'gramas', 130.00, NULL),
    (DATE '2026-03-21', 'Jantar', 'Iogurte natural', 'pote', 1.00, 'Leite desnatado'),
    (DATE '2026-03-21', 'Jantar', 'Castanha-do-para', 'unidade', 3.00, 'Azeite de oliva')
) AS v(data_plano, refeicao, alimento, unidade, qtd, subst)
JOIN PLANO_ALIMENTAR pa ON pa.data_inicio = v.data_plano
JOIN REFEICAO r ON r.id_plano_alimentar = pa.id_plano_alimentar AND r.nome = v.refeicao
JOIN ALIMENTO a ON a.nome = v.alimento;

INSERT INTO OBSERVACAO_REFEICAO_CONTEM (
    id_alimento, id_plano_alimentar, id_refeicao, observacao
)
SELECT a.id_alimento, r.id_plano_alimentar, r.id_refeicao, v.obs
FROM (VALUES
    (DATE '2026-03-15', 'Almoco', 'Peito de frango grelhado', 'Preparar sem oleo, apenas grelhado.'),
    (DATE '2026-03-17', 'Cafe da manha', 'Ovo de galinha cozido', 'Cozinhar por dez minutos para gema firme.'),
    (DATE '2026-03-21', 'Almoco', 'Batata-doce cozida', 'Cozinhar sem sal.')
) AS v(data_plano, refeicao, alimento, obs)
JOIN PLANO_ALIMENTAR pa ON pa.data_inicio = v.data_plano
JOIN REFEICAO r ON r.id_plano_alimentar = pa.id_plano_alimentar AND r.nome = v.refeicao
JOIN ALIMENTO a ON a.nome = v.alimento;

-- EVOLUCAO
-- Ao vincular a evolucao a consulta, o gatilho calcula o IMC automaticamente.

INSERT INTO EVOLUCAO_FISICA (
    id_evolucao, id_consulta_fisica, massa_muscular, circ_abdominal, circ_toracica, desempenho_fisico
)
VALUES
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10'),
     (SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-10'),
     28.60, 78.00, 92.00, 'Completou 30 minutos de caminhada sem pausa.'),
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-12'),
     (SELECT id_consulta_fisica FROM CONSULTA_FISICA WHERE data_consulta = DATE '2026-03-12'),
     38.20, 94.00, 104.00, 'Aumentou a carga do supino em 5 kg no ultimo mes.');

INSERT INTO EVOLUCAO_NUTRICIONAL (
    id_evolucao, id_consulta_nutricional, aderencia_alimentar, consumo_calorico, evolucao_clinica
)
VALUES
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-14'),
     (SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-14'),
     'Seguiu o plano em cinco dos sete dias da semana.', 1750, 'Sem intercorrencias clinicas.'),
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-16'),
     (SELECT id_consulta_nutricional FROM CONSULTA_NUTRICIONAL WHERE data_consulta = DATE '2026-03-16'),
     'Dificuldade em manter o plano nos fins de semana.', 2050, 'Relata melhora na disposicao.');

INSERT INTO OBSERVACAO_EVOLUCAO (id_evolucao, observacao_evolucao)
VALUES
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10'), 'Primeira avaliacao do acompanhamento.'),
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-12'), 'Composicao corporal estavel em relacao ao mes anterior.'),
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-14'), 'Relata mais saciedade apos o ajuste das refeicoes.'),
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-16'), 'Combinado reforcar o planejamento do fim de semana.');

INSERT INTO META_ALCANCADA_EVOLUCAO (id_evolucao, metas_alcancadas)
VALUES
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-10'), 'Retomou a atividade fisica de forma regular.'),
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-12'), 'Aumentou a carga nos tres exercicios principais.'),
    ((SELECT id_evolucao FROM EVOLUCAO WHERE data_avaliacao = DATE '2026-03-14'), 'Passou a fazer o cafe da manha todos os dias.');

-- FINANCEIRO

INSERT INTO SERVICO_PLANO_SERVICO (id_plano_servico, servicos)
VALUES
    ((SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Essencial'), 'Uma consulta mensal'),
    ((SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Essencial'), 'Plano de treino ou plano alimentar'),
    ((SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Completo'), 'Duas consultas mensais'),
    ((SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Completo'), 'Plano de treino e plano alimentar'),
    ((SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Completo'), 'Acompanhamento de evolucao'),
    ((SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Trimestral'), 'Todos os servicos do plano Completo'),
    ((SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Trimestral'), 'Reavaliacao fisica trimestral');

INSERT INTO CONTRATA_PLANO (id_paciente, id_plano_servico, data_de_adesao, status_contratacao)
VALUES
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '12345678901'),
     (SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Completo'),
     DATE '2026-03-01', 'Ativo'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '23456789012'),
     (SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Trimestral'),
     DATE '2026-03-05', 'Ativo'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '34567890123'),
     (SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Essencial'),
     DATE '2026-03-08', 'Ativo'),
    -- Mesma paciente readerindo ao mesmo plano em outra data: permitido pelo
    -- UNIQUE (id_paciente, id_plano_servico, data_de_adesao).
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '34567890123'),
     (SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Essencial'),
     DATE '2025-09-08', 'Encerrado'),
    ((SELECT id_paciente FROM PACIENTE WHERE cpf = '56789012346'),
     (SELECT id_plano_servico FROM PLANO_SERVICO WHERE nome_do_plano = 'Completo'),
     DATE '2026-03-12', 'Ativo');

INSERT INTO OBSERVACAO_CONTRATO (id_contrato, obs_contrato)
VALUES
    ((SELECT id_contrato FROM CONTRATA_PLANO WHERE data_de_adesao = DATE '2026-03-01'), 'Adesao com desconto de primeira mensalidade.'),
    ((SELECT id_contrato FROM CONTRATA_PLANO WHERE data_de_adesao = DATE '2025-09-08'), 'Contrato encerrado a pedido da paciente.'),
    ((SELECT id_contrato FROM CONTRATA_PLANO WHERE data_de_adesao = DATE '2026-03-12'), 'Cobranca reprogramada para o dia 15.');

-- valor_liquido nao e informado: o gatilho calcula a partir do plano contratado.
INSERT INTO PAGAMENTO (
    id_contrato, tipo_cobranca, descricao, data_venc, data_pag,
    forma_pag, status_pag, desconto, multa
)
VALUES
    ((SELECT id_contrato FROM CONTRATA_PLANO WHERE data_de_adesao = DATE '2026-03-01'),
     'Mensalidade', 'Mensalidade de marco', DATE '2026-03-10', DATE '2026-03-09',
     'PIX', 'Pago', 20.00, 0.00),
    ((SELECT id_contrato FROM CONTRATA_PLANO WHERE data_de_adesao = DATE '2026-03-01'),
     'Mensalidade', 'Mensalidade de abril', DATE '2026-04-10', NULL,
     NULL, 'Pendente', 0.00, 0.00),
    ((SELECT id_contrato FROM CONTRATA_PLANO WHERE data_de_adesao = DATE '2026-03-05'),
     'Parcela trimestral', 'Primeira parcela', DATE '2026-03-15', DATE '2026-03-15',
     'Cartao de credito', 'Pago', 0.00, 0.00),
    ((SELECT id_contrato FROM CONTRATA_PLANO WHERE data_de_adesao = DATE '2026-03-08'),
     'Mensalidade', 'Mensalidade de marco', DATE '2026-03-20', NULL,
     NULL, 'Atrasado', 0.00, 15.00),
    ((SELECT id_contrato FROM CONTRATA_PLANO WHERE data_de_adesao = DATE '2026-03-12'),
     'Mensalidade', 'Mensalidade de marco', DATE '2026-03-25', NULL,
     NULL, 'Pendente', 0.00, 0.00);

INSERT INTO OBSERVACAO_PAGAMENTO (id_pagamento, observacao)
VALUES
    ((SELECT id_pagamento FROM PAGAMENTO WHERE descricao = 'Mensalidade de marco' AND status_pag = 'Pago'),
     'Desconto promocional de adesao aplicado.'),
    ((SELECT id_pagamento FROM PAGAMENTO WHERE status_pag = 'Atrasado'),
     'Multa por atraso de cinco dias.');

-- HISTORICO

INSERT INTO HISTORICO_PLANO_TREINO (id_plano_treino, data_alteracao, descricao_alteracao, id_profissional)
VALUES
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-11'),
     TIMESTAMP '2026-03-25 10:15:00',
     'Carga do agachamento livre alterada de 20 kg para 25 kg.',
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '56789012345')),
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-11'),
     TIMESTAMP '2026-04-02 09:40:00',
     'Frequencia semanal alterada de 3 para 4 sessoes.',
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457')),
    ((SELECT id_plano_treino FROM PLANO_TREINO WHERE data_inicio = DATE '2026-03-13'),
     TIMESTAMP '2026-03-28 16:00:00',
     'Puxada frontal substituida por remada baixa.',
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '78901234568'));

INSERT INTO HISTORICO_PLANO_ALIMENTAR (id_plano_alimentar, data_alteracao, descricao_alteracao, id_profissional)
VALUES
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-15'),
     TIMESTAMP '2026-03-27 11:20:00',
     'Meta calorica diaria reduzida de 1800 para 1700 kcal.',
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '45678901234')),
    ((SELECT id_plano_alimentar FROM PLANO_ALIMENTAR WHERE data_inicio = DATE '2026-03-17'),
     TIMESTAMP '2026-04-01 15:05:00',
     'Incluida refeicao intermediaria no meio da tarde.',
     (SELECT id_profissional FROM PROFISSIONAL WHERE cpf = '67890123457'));

COMMIT;
