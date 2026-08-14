-- Carga inicial do FitNutri, em ordem de dependencias.
--
-- Execute este arquivo depois de 01_base.sql e 02_paciente.sql.
-- Ele usa somente as tabelas que ja estao definidas e nao depende de
-- valores fixos das colunas GENERATED ALWAYS AS IDENTITY.
--
-- Observacao: EVOLUCAO, consultas e planos individualizados ficam para uma
-- carga posterior, quando suas tabelas relacionadas estiverem concluidas.

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
-- Os identificadores destas tabelas sao sequenciais por paciente nesta carga.
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

INSERT INTO CONTATO_EMERGENCIA (id_contato_emr, id_paciente, nome, numero)
SELECT v.id_contato_emr, p.id_paciente, v.nome, v.numero
FROM PACIENTE AS p
JOIN (VALUES
    ('12345678901', 1, 'Marcos Costa', '+55 31 99111-2233'),
    ('23456789012', 1, 'Fernanda Lima', '+55 11 98888-7766'),
    ('34567890123', 1, 'Juliana Rocha', '+55 21 97777-6655'),
    ('45678901235', 1, 'Renata Nunes', '+55 41 96666-5544'),
    ('56789012346', 1, 'Paulo Moura', '+55 81 95555-4433')
) AS v(cpf, id_contato_emr, nome, numero) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO RESTRICAO_FISICA (id_restri_fisica, id_paciente, limitacoes_fisicas)
SELECT v.id_restri_fisica, p.id_paciente, v.limitacoes_fisicas
FROM PACIENTE AS p
JOIN (VALUES
    ('12345678901', 1, 'Evitar impacto excessivo no joelho direito'),
    ('34567890123', 1, 'Nenhuma restricao fisica declarada')
) AS v(cpf, id_restri_fisica, limitacoes_fisicas) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO RESTRICAO_ALIMENTAR (id_restri_alim, id_paciente, limitacoes_alimentares)
SELECT v.id_restri_alim, p.id_paciente, v.limitacoes_alimentares
FROM PACIENTE AS p
JOIN (VALUES
    ('12345678901', 1, 'Reduzir consumo de alimentos ultraprocessados'),
    ('34567890123', 1, 'Evitar frutos do mar')
) AS v(cpf, id_restri_alim, limitacoes_alimentares) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO PACIENTE_DOENCA (id_paciente_doenca, id_paciente, doencas)
SELECT v.id_paciente_doenca, p.id_paciente, v.doencas
FROM PACIENTE AS p
JOIN (VALUES
    ('23456789012', 1, 'Hipertensao arterial controlada')
) AS v(cpf, id_paciente_doenca, doencas) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO PACIENTE_ALERGIA (id_paciente_alerg, id_paciente, alergias)
SELECT v.id_paciente_alerg, p.id_paciente, v.alergias
FROM PACIENTE AS p
JOIN (VALUES
    ('34567890123', 1, 'Crustaceos')
) AS v(cpf, id_paciente_alerg, alergias) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

INSERT INTO MEDICAMENTO (id_medicamento, id_paciente, medicamentos)
SELECT v.id_medicamento, p.id_paciente, v.medicamentos
FROM PACIENTE AS p
JOIN (VALUES
    ('23456789012', 1, 'Losartana 50 mg')
) AS v(cpf, id_medicamento, medicamentos) ON v.cpf = p.cpf
ON CONFLICT DO NOTHING;

-- Profissionais: as especializacoes ainda serao inseridas quando as tabelas
-- NUTRICIONISTA e EDUCADOR_FISICO estiverem disponiveis.
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

COMMIT;
