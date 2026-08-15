-- BASE

CREATE TABLE PACIENTE (
    id_paciente INTEGER GENERATED ALWAYS AS IDENTITY,
    cpf CHAR(11) NOT NULL,
    rg VARCHAR(20) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    sexo CHAR(1) NOT NULL,
    data_nascimento DATE,
    endereco_cep CHAR(8),
    endereco_estado CHAR(2),
    endereco_cidade VARCHAR(100),
    endereco_bairro VARCHAR(100),
    endereco_logradouro VARCHAR(150),
    endereco_numero VARCHAR(10),
    endereco_complemento VARCHAR(80),
    email VARCHAR(120),
    profissao VARCHAR(80),
    altura DECIMAL(4,2),
    peso_ini DECIMAL(5,2),
    obj_principal VARCHAR(255),
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo',

    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente),

    CONSTRAINT uq_paciente_cpf UNIQUE (cpf),
    CONSTRAINT uq_paciente_rg UNIQUE (rg),
    CONSTRAINT uq_paciente_email UNIQUE (email),

    CONSTRAINT ck_paciente_status CHECK (status IN ('Ativo', 'Inativo')),
    CONSTRAINT ck_paciente_cpf CHECK (cpf ~ '^[0-9]{11}$'),
    CONSTRAINT ck_paciente_rg CHECK (rg ~ '^[A-Z0-9.-]{7,20}$'), -- pelo o que pesquisei pode conter letras alguns RGs
    CONSTRAINT ck_paciente_cep CHECK (endereco_cep ~ '^[0-9]{8}$'),
    CONSTRAINT ck_paciente_estado CHECK (endereco_estado ~ '^[A-Z]{2}$'),
    CONSTRAINT ck_paciente_sexo CHECK (sexo IN ('M', 'F', 'O')),
    CONSTRAINT ck_paciente_altura CHECK (altura > 0),
    CONSTRAINT ck_paciente_peso_ini CHECK (peso_ini > 0)
);

CREATE TABLE PROFISSIONAL (
    id_profissional INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(120),
    endereco_cep CHAR(8),
    endereco_estado CHAR(2),
    endereco_cidade VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo',
    data_contrato DATE NOT NULL,

    CONSTRAINT pk_profissional PRIMARY KEY (id_profissional),

    CONSTRAINT uq_profissional_cpf UNIQUE (cpf),
    CONSTRAINT uq_profissional_email UNIQUE (email),

    CONSTRAINT ck_profissional_status CHECK (status IN ('Ativo', 'Inativo')),
    CONSTRAINT ck_profissional_cpf CHECK (cpf ~ '^[0-9]{11}$'),
    CONSTRAINT ck_profissional_cep CHECK (endereco_cep ~ '^[0-9]{8}$'),
    CONSTRAINT ck_profissional_estado CHECK (endereco_estado ~ '^[A-Z]{2}$')
);

CREATE TABLE PLANO_SERVICO (
    id_plano_servico INTEGER GENERATED ALWAYS AS IDENTITY,
    nome_do_plano VARCHAR(100) NOT NULL,
    descricao TEXT,
    valor_mensal DECIMAL(10,2) NOT NULL,
    periodicidade VARCHAR(30) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    situacao_plano VARCHAR(20) NOT NULL DEFAULT 'Ativo',

    CONSTRAINT pk_plano_servico PRIMARY KEY (id_plano_servico),

    CONSTRAINT uq_plano_servico_nome UNIQUE (nome_do_plano),

    CONSTRAINT ck_plano_servico_situacao CHECK (situacao_plano IN ('Ativo', 'Inativo')),
    CONSTRAINT ck_plano_servico_valor CHECK (valor_mensal >= 0),
    CONSTRAINT ck_plano_servico_vigencia CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);

CREATE TABLE EXERCICIO (
    id_exercicio INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(120) NOT NULL,
    grupo_muscular VARCHAR(80),
    modalidade VARCHAR(80),

    CONSTRAINT pk_exercicio PRIMARY KEY (id_exercicio),

    CONSTRAINT uq_exercicio_nome UNIQUE (nome)
);

CREATE TABLE ALIMENTO (
    id_alimento INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(120) NOT NULL,
    grupo_alimentar VARCHAR(80),
    porcao_referencia DECIMAL(7,2),
    proteinas_porcao DECIMAL(5,2),
    carboidratos_porcao DECIMAL(5,2),
    gorduras_porcao DECIMAL(5,2),
    valor_calorico_porcao DECIMAL(7,2) -- COALESCE? ja que eles podem ser NULL
        GENERATED ALWAYS AS (
            (carboidratos_porcao * 4)
            + (proteinas_porcao * 4)
            + (gorduras_porcao * 9)
        ) STORED,

    CONSTRAINT pk_alimento PRIMARY KEY (id_alimento),

    CONSTRAINT uq_alimento_nome UNIQUE (nome),

    CONSTRAINT ck_alimento_porcao CHECK (porcao_referencia > 0),
    CONSTRAINT ck_alimento_proteinas CHECK (proteinas_porcao >= 0),
    CONSTRAINT ck_alimento_carboidratos CHECK (carboidratos_porcao >= 0),
    CONSTRAINT ck_alimento_gorduras CHECK (gorduras_porcao >= 0)
);

CREATE TABLE EVOLUCAO (
    id_evolucao INTEGER GENERATED ALWAYS AS IDENTITY,
    data_avaliacao DATE NOT NULL,
    peso DECIMAL(5,2) NOT NULL,
    perc_gordura DECIMAL(5,2) NOT NULL,
    medida_corporal TEXT NOT NULL,
    IMC DECIMAL(5,2), -- triger de fisica e nutricionla.

    CONSTRAINT pk_evolucao PRIMARY KEY (id_evolucao),

    CONSTRAINT ck_evolucao_peso CHECK (peso > 0),
    CONSTRAINT ck_evolucao_perc_gordura CHECK (perc_gordura BETWEEN 0 AND 100),
    CONSTRAINT ck_evolucao_imc CHECK (IMC > 0)
);


-- PACIENTE

CREATE TABLE TELEFONE_PACIENTE (
    id_paciente INTEGER NOT NULL,
    numero_telefone VARCHAR(20) NOT NULL,

    CONSTRAINT pk_telefone_paciente PRIMARY KEY (id_paciente, numero_telefone)
);

CREATE TABLE CONTATO_EMERGENCIA (
    id_contato_emr INTEGER GENERATED ALWAYS AS IDENTITY,
    id_paciente INTEGER NOT NULL,
    nome VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,

    CONSTRAINT pk_contato_emergencia PRIMARY KEY (id_contato_emr, id_paciente),

    CONSTRAINT uq_contato_emergencia UNIQUE (id_paciente, nome)
);

CREATE TABLE RESTRICAO_FISICA (
    id_restri_fisica INTEGER GENERATED ALWAYS AS IDENTITY,
    id_paciente INTEGER NOT NULL,
    limitacoes_fisicas VARCHAR(255) NOT NULL,

    CONSTRAINT pk_restricao_fisica PRIMARY KEY (id_restri_fisica, id_paciente),

    CONSTRAINT uq_restricao_fisica UNIQUE (id_paciente, limitacoes_fisicas)
);

CREATE TABLE RESTRICAO_ALIMENTAR (
    id_restri_alim INTEGER GENERATED ALWAYS AS IDENTITY,
    id_paciente INTEGER NOT NULL,
    limitacoes_alimentares VARCHAR(255) NOT NULL,

    CONSTRAINT pk_restricao_alim PRIMARY KEY (id_restri_alim, id_paciente),

    CONSTRAINT uq_restricao_alim UNIQUE (id_paciente, limitacoes_alimentares)
);

CREATE TABLE PACIENTE_DOENCA (
    id_paciente_doenca INTEGER GENERATED ALWAYS AS IDENTITY,
    id_paciente INTEGER NOT NULL,
    doencas VARCHAR(255) NOT NULL,

    CONSTRAINT pk_paciente_doenca PRIMARY KEY (id_paciente_doenca, id_paciente),

    CONSTRAINT uq_paciente_doenca UNIQUE (id_paciente, doencas)
);

CREATE TABLE PACIENTE_ALERGIA (
    id_paciente_alerg INTEGER GENERATED ALWAYS AS IDENTITY,
    id_paciente INTEGER NOT NULL,
    alergias VARCHAR(255) NOT NULL,

    CONSTRAINT pk_paciente_alerg PRIMARY KEY (id_paciente_alerg, id_paciente),

    CONSTRAINT uq_paciente_alerg UNIQUE (id_paciente, alergias)
);

CREATE TABLE MEDICAMENTO (
    id_medicamento INTEGER GENERATED ALWAYS AS IDENTITY,
    id_paciente INTEGER NOT NULL,
    medicamentos VARCHAR(255) NOT NULL,

    CONSTRAINT pk_medicamento PRIMARY KEY (id_medicamento, id_paciente),

    CONSTRAINT uq_medicamento UNIQUE (id_paciente, medicamentos)
);


-- PROFISSIONAIS

CREATE TABLE DISPONIBILIDADE_PROFISSIONAL (
    id_dispo_pro INTEGER GENERATED ALWAYS AS IDENTITY,
    id_profissional INTEGER NOT NULL,
    dia_semana SMALLINT NOT NULL,
    hora_ini TIME NOT NULL,
    hora_fim TIME NOT NULL,

    CONSTRAINT pk_disponibilidade_profissional PRIMARY KEY (id_dispo_pro, id_profissional),

    CONSTRAINT uq_disponibilidade_faixa UNIQUE (id_profissional, dia_semana, hora_ini),

    CONSTRAINT ck_disponibilidade_dia CHECK (dia_semana BETWEEN 1 AND 7),
    CONSTRAINT ck_disponibilidade_horario CHECK (hora_fim > hora_ini)
);

CREATE TABLE TELEFONE_PROFISSIONAL (
    id_profissional INTEGER NOT NULL,
    numero_telefone VARCHAR(20) NOT NULL,

    CONSTRAINT pk_telefone_profissional PRIMARY KEY (id_profissional, numero_telefone),

    CONSTRAINT ck_telefone_profissional_numero CHECK (numero_telefone ~ '^[0-9]{10,11}$')
);

CREATE TABLE NUTRICIONISTA (
    id_profissional INTEGER,
    CRN VARCHAR(20) NOT NULL,

    CONSTRAINT pk_nutricionista PRIMARY KEY (id_profissional),

    CONSTRAINT uq_nutricionista_crn UNIQUE (CRN)
);

CREATE TABLE EDUCADOR_FISICO (
    id_profissional INTEGER,
    CREF VARCHAR(20) NOT NULL,

    CONSTRAINT pk_educador_fisico PRIMARY KEY (id_profissional),

    CONSTRAINT uq_educador_fisico_cref UNIQUE (CREF)
);

CREATE TABLE ESPECIALIDADE_NUTRICIONISTA (
    id_especialidade_nutri INTEGER GENERATED ALWAYS AS IDENTITY,
    id_profissional INTEGER NOT NULL,
    especialidade VARCHAR(120) NOT NULL,

    CONSTRAINT pk_especialidade_nutricionista PRIMARY KEY (id_especialidade_nutri, id_profissional),

    CONSTRAINT uq_especialidade_nutricionista UNIQUE (id_profissional, especialidade)
);

CREATE TABLE ESPECIALIDADE_EDUCADOR (
    id_especialidade_edu INTEGER GENERATED ALWAYS AS IDENTITY,
    id_profissional INTEGER NOT NULL,
    especializacao VARCHAR(120) NOT NULL,

    CONSTRAINT pk_especialidade_educador PRIMARY KEY (id_especialidade_edu, id_profissional),

    CONSTRAINT uq_especialidade_educador UNIQUE (id_profissional, especializacao)
);


-- CONSULTAS

CREATE TABLE CONSULTA_FISICA (
    id_consulta_fisica INTEGER GENERATED ALWAYS AS IDENTITY,
    id_paciente INTEGER NOT NULL,
    id_profissional INTEGER NOT NULL,
    data_consulta DATE NOT NULL,
    horario TIME NOT NULL,
    tipo_consulta VARCHAR(60) NOT NULL,
    avaliacao_fisica TEXT NOT NULL,
    freq_cardiaca INTEGER NOT NULL,
    press_arterial VARCHAR(20) NOT NULL,
    cond_fisico VARCHAR(120) NOT NULL,
    prox_consulta DATE,

    CONSTRAINT pk_consulta_fisica PRIMARY KEY (id_consulta_fisica),

    CONSTRAINT ck_consulta_fisica_freq_cardiaca CHECK (freq_cardiaca > 0 AND freq_cardiaca < 300),
    CONSTRAINT ck_consulta_fisica_prox_consulta CHECK (prox_consulta IS NULL OR prox_consulta >= data_consulta)
);

CREATE TABLE CONSULTA_NUTRICIONAL (
    id_consulta_nutricional INTEGER GENERATED ALWAYS AS IDENTITY,
    id_paciente INTEGER NOT NULL,
    id_profissional INTEGER NOT NULL,
    data_consulta DATE NOT NULL,
    horario TIME NOT NULL,
    objetivo_nutricional VARCHAR(255),
    suplementacao TEXT,
    consumo_agua DECIMAL(4,2),
    prox_consulta DATE,

    CONSTRAINT pk_consulta_nutricional PRIMARY KEY (id_consulta_nutricional),

    CONSTRAINT ck_consulta_nutricional_consumo_agua CHECK (consumo_agua IS NULL OR consumo_agua >= 0),
    CONSTRAINT ck_consulta_nutricional_prox_consulta CHECK (prox_consulta IS NULL OR prox_consulta >= data_consulta)
);

CREATE TABLE OBJETIVO_FISICO_PACIENTE (
    id_obj_paciente INTEGER GENERATED ALWAYS AS IDENTITY,
    id_consulta_fisica INTEGER NOT NULL,
    objetivo VARCHAR(255) NOT NULL,

    CONSTRAINT pk_objetivo_fisico_paciente PRIMARY KEY (id_obj_paciente, id_consulta_fisica)
);

CREATE TABLE RECOMENDACAO_FISICA (
    id_recom_fisica INTEGER GENERATED ALWAYS AS IDENTITY,
    id_consulta_fisica INTEGER NOT NULL,
    recomendacao TEXT NOT NULL,

    CONSTRAINT pk_recomendacao_fisica PRIMARY KEY (id_recom_fisica, id_consulta_fisica)
);

CREATE TABLE OBSERVACAO_GERAL_CONSULTA_FISICA (
    id_obs_geral_cf INTEGER GENERATED ALWAYS AS IDENTITY,
    id_consulta_fisica INTEGER NOT NULL,
    obs_geral TEXT NOT NULL,

    CONSTRAINT pk_observacao_geral_consulta_fisica PRIMARY KEY (id_obs_geral_cf, id_consulta_fisica)
);

CREATE TABLE INTOLERANCIA_CONSULTA_NUTRI (
    id_intolerancia_consulta_nutri INTEGER GENERATED ALWAYS AS IDENTITY,
    id_consulta_nutricional INTEGER NOT NULL,
    intolerancia VARCHAR(255) NOT NULL,

    CONSTRAINT pk_intolerancia_consulta_nutri PRIMARY KEY (id_intolerancia_consulta_nutri, id_consulta_nutricional)
);

CREATE TABLE HABITO_ALIMENTAR (
    id_habito_alimentar INTEGER GENERATED ALWAYS AS IDENTITY,
    id_consulta_nutricional INTEGER NOT NULL,
    habito_alimentar TEXT NOT NULL,

    CONSTRAINT pk_habito_alimentar PRIMARY KEY (id_habito_alimentar, id_consulta_nutricional)
);

CREATE TABLE OBSERVACAO_CLINICA (
    id_obs_clinica INTEGER GENERATED ALWAYS AS IDENTITY,
    id_consulta_nutricional INTEGER NOT NULL,
    observacoes_clinicas TEXT NOT NULL,

    CONSTRAINT pk_observacao_clinica PRIMARY KEY (id_obs_clinica, id_consulta_nutricional)
);

CREATE TABLE RECOMENDACAO_NUTRICIONAL (
    id_recom_nutri INTEGER GENERATED ALWAYS AS IDENTITY,
    id_consulta_nutricional INTEGER NOT NULL,
    recomendacao TEXT NOT NULL,

    CONSTRAINT pk_recomendacao_nutricional PRIMARY KEY (id_recom_nutri, id_consulta_nutricional)
);


-- TREINO

CREATE TABLE PLANO_TREINO (
    id_plano_treino INTEGER GENERATED ALWAYS AS IDENTITY,
    id_consulta_fisica INTEGER NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    dificuldade VARCHAR(30),
    frequencia_semanal INTEGER,
    duracao INTEGER,
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo',

    CONSTRAINT pk_plano_treino PRIMARY KEY (id_plano_treino),

    CONSTRAINT ck_plano_treino_status CHECK (status IN ('Ativo', 'Inativo')),
    CONSTRAINT ck_plano_treino_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio),
    CONSTRAINT ck_plano_treino_frequencia_semanal CHECK (frequencia_semanal IS NULL OR frequencia_semanal BETWEEN 1 AND 7),
    CONSTRAINT ck_plano_treino_duracao CHECK (duracao IS NULL OR duracao > 0)
);

CREATE TABLE OBJETIVO_TREINO (
    id_obj_treino INTEGER GENERATED ALWAYS AS IDENTITY,
    id_plano_treino INTEGER NOT NULL,
    objetivos VARCHAR(120) NOT NULL,

    CONSTRAINT pk_objetivo_treino PRIMARY KEY (id_obj_treino, id_plano_treino)
);

CREATE TABLE OBSERVACAO_GERAL_PLANO_TREINO (
    id_obs_geral_pt INTEGER GENERATED ALWAYS AS IDENTITY,
    id_plano_treino INTEGER NOT NULL,
    obs_geral VARCHAR(120) NOT NULL,

    CONSTRAINT pk_observacao_geral_plano_treino PRIMARY KEY (id_obs_geral_pt, id_plano_treino)
);

CREATE TABLE PLANO_TREINO_PODE_CONTER_EXERCICIO (
    id_exercicio INTEGER NOT NULL,
    id_plano_treino INTEGER NOT NULL,
    intervalo INTERVAL NOT NULL,
    tempo_execucao INTEGER NOT NULL,
    carga INTEGER NOT NULL,
    repeticao INTEGER NOT NULL,
    serie INTEGER NOT NULL,

    CONSTRAINT pk_plano_treino_pode_conter_exercicio PRIMARY KEY (id_exercicio, id_plano_treino),

    CONSTRAINT ck_ptpce_intervalo CHECK (intervalo >= INTERVAL '0'),
    CONSTRAINT ck_ptpce_tempo_execucao CHECK (tempo_execucao > 0),
    CONSTRAINT ck_ptpce_carga CHECK (carga >= 0),
    CONSTRAINT ck_ptpce_repeticao CHECK (repeticao > 0),
    CONSTRAINT ck_ptpce_serie CHECK (serie > 0)
);

CREATE TABLE OBSERVACAO_TECNICA (
    id_obs_tecnica INTEGER GENERATED ALWAYS AS IDENTITY,
    id_plano_treino INTEGER NOT NULL,
    id_exercicio INTEGER NOT NULL,
    observacoes VARCHAR(120) NOT NULL,

    CONSTRAINT pk_observacao_tecnica PRIMARY KEY (id_obs_tecnica, id_plano_treino, id_exercicio)
);


-- NUTRICAO

CREATE TABLE PLANO_ALIMENTAR (
    id_plano_alimentar INTEGER GENERATED ALWAYS AS IDENTITY,
    id_consulta_nutricional INTEGER NOT NULL,
    objetivo_nutri VARCHAR(255) NOT NULL,
    quantidade_proteina DECIMAL(5,2) NOT NULL,
    quantidade_caloria_diaria DECIMAL(7,2) NOT NULL,
    quantidade_carboidrato DECIMAL(5,2) NOT NULL,
    quantidade_gordura DECIMAL(5,2) NOT NULL,
    data_inicio DATE NOT NULL,
    data_termino DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo',

    CONSTRAINT pk_plano_alimentar PRIMARY KEY (id_plano_alimentar),

    CONSTRAINT ck_plano_alimentar_status CHECK (status IN ('Ativo', 'Inativo')),
    CONSTRAINT ck_plano_alimentar_datas CHECK (data_termino IS NULL OR data_termino >= data_inicio),
    CONSTRAINT ck_plano_alimentar_metas CHECK (
        quantidade_proteina >= 0
        AND quantidade_caloria_diaria >= 0
        AND quantidade_carboidrato >= 0
        AND quantidade_gordura >= 0
    )
);

CREATE TABLE OBSERVACAO_PLANO_ALIMENTAR (
    id_obs_plano_alim INTEGER GENERATED ALWAYS AS IDENTITY,
    id_plano_alimentar INTEGER NOT NULL,
    obs_geral VARCHAR(255) NOT NULL,

    CONSTRAINT pk_observacao_plano_alimentar PRIMARY KEY (id_obs_plano_alim, id_plano_alimentar)
);

CREATE TABLE REFEICAO (
    id_refeicao INTEGER GENERATED ALWAYS AS IDENTITY,
    id_plano_alimentar INTEGER NOT NULL,
    nome VARCHAR(120) NOT NULL,
    horario TIME,

    CONSTRAINT pk_refeicao PRIMARY KEY (id_plano_alimentar, id_refeicao),

    CONSTRAINT uq_refeicao UNIQUE (id_plano_alimentar, nome, horario)
);

CREATE TABLE REFEICAO_CONTEM_ALIMENTO (
    id_alimento INTEGER NOT NULL,
    id_plano_alimentar INTEGER NOT NULL,
    id_refeicao INTEGER NOT NULL,
    unidade_de_medida VARCHAR(30) NOT NULL,
    quantidade DECIMAL(7,2) NOT NULL,
    substituicao_permitida TEXT,

    CONSTRAINT pk_refeicao_contem_alimento PRIMARY KEY (id_alimento, id_plano_alimentar, id_refeicao),

    CONSTRAINT ck_refeicao_contem_alimento_quantidade CHECK (quantidade > 0)
);

CREATE TABLE OBSERVACAO_REFEICAO_CONTEM (
    id_obs_refeicao INTEGER GENERATED ALWAYS AS IDENTITY,
    id_alimento INTEGER NOT NULL,
    id_plano_alimentar INTEGER NOT NULL,
    id_refeicao INTEGER NOT NULL,
    observacao TEXT NOT NULL,

    CONSTRAINT pk_observacao_refeicao_contem PRIMARY KEY (id_alimento, id_plano_alimentar, id_refeicao, id_obs_refeicao)
);


-- EVOLUCAO

CREATE TABLE EVOLUCAO_FISICA (
    id_evolucao INTEGER NOT NULL,
    id_consulta_fisica INTEGER NOT NULL,
    massa_muscular DECIMAL(5,2),
    circ_abdominal DECIMAL(5,2),
    circ_toracica DECIMAL(5,2),
    desempenho_fisico TEXT,

    CONSTRAINT pk_evolucao_fisica PRIMARY KEY (id_evolucao),

    CONSTRAINT uq_evolucao_fisica_consulta UNIQUE (id_consulta_fisica),

    CONSTRAINT ck_evolucao_fisica_massa_muscular CHECK (massa_muscular >= 0),
    CONSTRAINT ck_evolucao_fisica_circ_abdominal CHECK (circ_abdominal >= 0),
    CONSTRAINT ck_evolucao_fisica_circ_toracica CHECK (circ_toracica >= 0)
);

CREATE TABLE EVOLUCAO_NUTRICIONAL (
    id_evolucao INTEGER NOT NULL,
    id_consulta_nutricional INTEGER NOT NULL,
    aderencia_alimentar TEXT,
    consumo_calorico INTEGER,
    evolucao_clinica TEXT,

    CONSTRAINT pk_evolucao_nutricional PRIMARY KEY (id_evolucao),

    CONSTRAINT uq_evolucao_nutricional_consulta UNIQUE (id_consulta_nutricional),

    CONSTRAINT ck_evolucao_nutricional_consumo_calorico CHECK (consumo_calorico > 0)
);

CREATE TABLE OBSERVACAO_EVOLUCAO (
    id_obs_evolucao INTEGER GENERATED ALWAYS AS IDENTITY,
    id_evolucao INTEGER NOT NULL,
    observacao_evolucao TEXT NOT NULL,

    CONSTRAINT pk_observacao_evolucao PRIMARY KEY (id_obs_evolucao, id_evolucao)
);

CREATE TABLE META_ALCANCADA_EVOLUCAO (
    id_metas INTEGER GENERATED ALWAYS AS IDENTITY,
    id_evolucao INTEGER NOT NULL,
    metas_alcancadas TEXT NOT NULL,

    CONSTRAINT pk_meta_alcancada_evolucao PRIMARY KEY (id_metas, id_evolucao)
);


-- FINANCEIRO

CREATE TABLE SERVICO_PLANO_SERVICO (
    id_servico_plano_servico INTEGER GENERATED ALWAYS AS IDENTITY,
    id_plano_servico INTEGER NOT NULL,
    servicos TEXT NOT NULL,

    CONSTRAINT pk_servico_plano_servico PRIMARY KEY (id_servico_plano_servico, id_plano_servico)
);

CREATE TABLE CONTRATA_PLANO (
    id_contrato INTEGER GENERATED ALWAYS AS IDENTITY,
    id_paciente INTEGER NOT NULL,
    id_plano_servico INTEGER NOT NULL,
    data_de_adesao DATE NOT NULL,
    status_contratacao VARCHAR(20) NOT NULL DEFAULT 'Ativo',

    CONSTRAINT pk_contrata_plano PRIMARY KEY (id_contrato),

    CONSTRAINT uq_contrata_plano_adesao UNIQUE (id_paciente, id_plano_servico, data_de_adesao),

    CONSTRAINT ck_contrata_plano_status CHECK (status_contratacao IN ('Ativo', 'Suspenso', 'Encerrado', 'Cancelado'))
);

CREATE TABLE OBSERVACAO_CONTRATO (
    id_obs_contrato INTEGER GENERATED ALWAYS AS IDENTITY,
    id_contrato INTEGER NOT NULL,
    obs_contrato TEXT NOT NULL,

    CONSTRAINT pk_observacao_contrato PRIMARY KEY (id_obs_contrato, id_contrato)
);

CREATE TABLE PAGAMENTO (
    id_pagamento INTEGER GENERATED ALWAYS AS IDENTITY,
    id_contrato INTEGER NOT NULL,
    tipo_cobranca VARCHAR(60) NOT NULL,
    descricao VARCHAR(255),
    valor_liquido DECIMAL(10,2), -- trigger, vem do valor_mensal do plano contratado
    data_venc DATE NOT NULL,
    data_pag DATE,
    forma_pag VARCHAR(40),
    status_pag VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    desconto DECIMAL(5,2) DEFAULT 0.00,
    multa DECIMAL(5,2) DEFAULT 0.00,

    CONSTRAINT pk_pagamento PRIMARY KEY (id_pagamento),

    CONSTRAINT ck_pagamento_status CHECK (status_pag IN ('Pendente', 'Pago', 'Atrasado', 'Cancelado')),
    CONSTRAINT ck_pagamento_valor CHECK (valor_liquido >= 0),
    CONSTRAINT ck_pagamento_desconto CHECK (desconto >= 0),
    CONSTRAINT ck_pagamento_multa CHECK (multa >= 0),
    CONSTRAINT ck_pagamento_data_pag CHECK (data_pag IS NULL OR status_pag <> 'Pendente')
);

CREATE TABLE OBSERVACAO_PAGAMENTO (
    id_obs_pag INTEGER GENERATED ALWAYS AS IDENTITY,
    id_pagamento INTEGER NOT NULL,
    observacao TEXT NOT NULL,

    CONSTRAINT pk_observacao_pagamento PRIMARY KEY (id_obs_pag, id_pagamento)
);


-- HISTORICO

CREATE TABLE HISTORICO_PLANO_TREINO (
    id_historico_pt INTEGER GENERATED ALWAYS AS IDENTITY,
    id_plano_treino INTEGER NOT NULL,
    data_alteracao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descricao_alteracao TEXT NOT NULL,
    id_profissional INTEGER NOT NULL,

    CONSTRAINT pk_historico_plano_treino PRIMARY KEY (id_historico_pt, id_plano_treino)
);

CREATE TABLE HISTORICO_PLANO_ALIMENTAR (
    id_historico_pa INTEGER GENERATED ALWAYS AS IDENTITY,
    id_plano_alimentar INTEGER NOT NULL,
    data_alteracao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descricao_alteracao TEXT NOT NULL,
    id_profissional INTEGER NOT NULL,

    CONSTRAINT pk_historico_plano_alimentar PRIMARY KEY (id_historico_pa, id_plano_alimentar)
);


-- CHAVES ESTRANGEIRAS

-- PACIENTE

ALTER TABLE TELEFONE_PACIENTE
    ADD CONSTRAINT fk_telefone_paciente_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE;

ALTER TABLE CONTATO_EMERGENCIA
    ADD CONSTRAINT fk_contato_emergencia_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE;

ALTER TABLE RESTRICAO_FISICA
    ADD CONSTRAINT fk_restricao_fisica_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE;

ALTER TABLE RESTRICAO_ALIMENTAR
    ADD CONSTRAINT fk_restricao_alim_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE;

ALTER TABLE PACIENTE_DOENCA
    ADD CONSTRAINT fk_paciente_doenca_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE;

ALTER TABLE PACIENTE_ALERGIA
    ADD CONSTRAINT fk_paciente_alerg_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE;

ALTER TABLE MEDICAMENTO
    ADD CONSTRAINT fk_medicamento_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE CASCADE;

-- PROFISSIONAIS

ALTER TABLE DISPONIBILIDADE_PROFISSIONAL
    ADD CONSTRAINT fk_disponibilidade_profissional FOREIGN KEY (id_profissional)
    REFERENCES PROFISSIONAL (id_profissional) ON DELETE CASCADE;

ALTER TABLE TELEFONE_PROFISSIONAL
    ADD CONSTRAINT fk_telefone_profissional FOREIGN KEY (id_profissional)
    REFERENCES PROFISSIONAL (id_profissional) ON DELETE CASCADE;

ALTER TABLE NUTRICIONISTA
    ADD CONSTRAINT fk_nutricionista_profissional FOREIGN KEY (id_profissional)
    REFERENCES PROFISSIONAL (id_profissional) ON DELETE CASCADE;

ALTER TABLE EDUCADOR_FISICO
    ADD CONSTRAINT fk_educador_fisico_profissional FOREIGN KEY (id_profissional)
    REFERENCES PROFISSIONAL (id_profissional) ON DELETE CASCADE;

ALTER TABLE ESPECIALIDADE_NUTRICIONISTA
    ADD CONSTRAINT fk_especialidade_nutricionista FOREIGN KEY (id_profissional)
    REFERENCES NUTRICIONISTA (id_profissional) ON DELETE CASCADE;

ALTER TABLE ESPECIALIDADE_EDUCADOR
    ADD CONSTRAINT fk_especialidade_educador FOREIGN KEY (id_profissional)
    REFERENCES EDUCADOR_FISICO (id_profissional) ON DELETE CASCADE;

-- CONSULTAS

ALTER TABLE CONSULTA_FISICA
    ADD CONSTRAINT fk_consulta_fisica_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE CONSULTA_FISICA
    ADD CONSTRAINT fk_consulta_fisica_educador FOREIGN KEY (id_profissional)
    REFERENCES EDUCADOR_FISICO (id_profissional) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE CONSULTA_NUTRICIONAL
    ADD CONSTRAINT fk_consulta_nutricional_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE CONSULTA_NUTRICIONAL
    ADD CONSTRAINT fk_consulta_nutricional_nutricionista FOREIGN KEY (id_profissional)
    REFERENCES NUTRICIONISTA (id_profissional) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE OBJETIVO_FISICO_PACIENTE
    ADD CONSTRAINT fk_objetivo_fisico_paciente_consulta FOREIGN KEY (id_consulta_fisica)
    REFERENCES CONSULTA_FISICA (id_consulta_fisica) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE RECOMENDACAO_FISICA
    ADD CONSTRAINT fk_recomendacao_fisica_consulta FOREIGN KEY (id_consulta_fisica)
    REFERENCES CONSULTA_FISICA (id_consulta_fisica) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE OBSERVACAO_GERAL_CONSULTA_FISICA
    ADD CONSTRAINT fk_obs_geral_cf_consulta FOREIGN KEY (id_consulta_fisica)
    REFERENCES CONSULTA_FISICA (id_consulta_fisica) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE INTOLERANCIA_CONSULTA_NUTRI
    ADD CONSTRAINT fk_intolerancia_consulta_nutri_consulta FOREIGN KEY (id_consulta_nutricional)
    REFERENCES CONSULTA_NUTRICIONAL (id_consulta_nutricional) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE HABITO_ALIMENTAR
    ADD CONSTRAINT fk_habito_alimentar_consulta FOREIGN KEY (id_consulta_nutricional)
    REFERENCES CONSULTA_NUTRICIONAL (id_consulta_nutricional) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE OBSERVACAO_CLINICA
    ADD CONSTRAINT fk_observacao_clinica_consulta FOREIGN KEY (id_consulta_nutricional)
    REFERENCES CONSULTA_NUTRICIONAL (id_consulta_nutricional) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE RECOMENDACAO_NUTRICIONAL
    ADD CONSTRAINT fk_recomendacao_nutricional_consulta FOREIGN KEY (id_consulta_nutricional)
    REFERENCES CONSULTA_NUTRICIONAL (id_consulta_nutricional) ON DELETE CASCADE ON UPDATE CASCADE;

-- TREINO

ALTER TABLE PLANO_TREINO
    ADD CONSTRAINT fk_plano_treino_consulta FOREIGN KEY (id_consulta_fisica)
    REFERENCES CONSULTA_FISICA (id_consulta_fisica) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE OBJETIVO_TREINO
    ADD CONSTRAINT fk_objetivo_treino_plano FOREIGN KEY (id_plano_treino)
    REFERENCES PLANO_TREINO (id_plano_treino) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE OBSERVACAO_GERAL_PLANO_TREINO
    ADD CONSTRAINT fk_obs_geral_pt_plano FOREIGN KEY (id_plano_treino)
    REFERENCES PLANO_TREINO (id_plano_treino) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE PLANO_TREINO_PODE_CONTER_EXERCICIO
    ADD CONSTRAINT fk_ptpce_exercicio FOREIGN KEY (id_exercicio)
    REFERENCES EXERCICIO (id_exercicio) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PLANO_TREINO_PODE_CONTER_EXERCICIO
    ADD CONSTRAINT fk_ptpce_plano_treino FOREIGN KEY (id_plano_treino)
    REFERENCES PLANO_TREINO (id_plano_treino) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE OBSERVACAO_TECNICA
    ADD CONSTRAINT fk_observacao_tecnica_ptpce FOREIGN KEY (id_exercicio, id_plano_treino)
    REFERENCES PLANO_TREINO_PODE_CONTER_EXERCICIO (id_exercicio, id_plano_treino)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- NUTRICAO

ALTER TABLE PLANO_ALIMENTAR
    ADD CONSTRAINT fk_plano_alimentar_consulta_nutricional FOREIGN KEY (id_consulta_nutricional)
    REFERENCES CONSULTA_NUTRICIONAL (id_consulta_nutricional) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE OBSERVACAO_PLANO_ALIMENTAR
    ADD CONSTRAINT fk_observacao_plano_alimentar_plano FOREIGN KEY (id_plano_alimentar)
    REFERENCES PLANO_ALIMENTAR (id_plano_alimentar) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE REFEICAO
    ADD CONSTRAINT fk_refeicao_plano_alimentar FOREIGN KEY (id_plano_alimentar)
    REFERENCES PLANO_ALIMENTAR (id_plano_alimentar) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE REFEICAO_CONTEM_ALIMENTO
    ADD CONSTRAINT fk_refeicao_contem_alimento_alimento FOREIGN KEY (id_alimento)
    REFERENCES ALIMENTO (id_alimento) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE REFEICAO_CONTEM_ALIMENTO
    ADD CONSTRAINT fk_refeicao_contem_alimento_refeicao FOREIGN KEY (id_plano_alimentar, id_refeicao)
    REFERENCES REFEICAO (id_plano_alimentar, id_refeicao) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE OBSERVACAO_REFEICAO_CONTEM
    ADD CONSTRAINT fk_observacao_refeicao_contem_item FOREIGN KEY (id_alimento, id_plano_alimentar, id_refeicao)
    REFERENCES REFEICAO_CONTEM_ALIMENTO (id_alimento, id_plano_alimentar, id_refeicao)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- EVOLUCAO

ALTER TABLE EVOLUCAO_FISICA
    ADD CONSTRAINT fk_evolucao_fisica_evolucao FOREIGN KEY (id_evolucao)
    REFERENCES EVOLUCAO (id_evolucao) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE EVOLUCAO_FISICA
    ADD CONSTRAINT fk_evolucao_fisica_consulta FOREIGN KEY (id_consulta_fisica)
    REFERENCES CONSULTA_FISICA (id_consulta_fisica) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE EVOLUCAO_NUTRICIONAL
    ADD CONSTRAINT fk_evolucao_nutricional_evolucao FOREIGN KEY (id_evolucao)
    REFERENCES EVOLUCAO (id_evolucao) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE EVOLUCAO_NUTRICIONAL
    ADD CONSTRAINT fk_evolucao_nutricional_consulta FOREIGN KEY (id_consulta_nutricional)
    REFERENCES CONSULTA_NUTRICIONAL (id_consulta_nutricional) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE OBSERVACAO_EVOLUCAO
    ADD CONSTRAINT fk_observacao_evolucao_evolucao FOREIGN KEY (id_evolucao)
    REFERENCES EVOLUCAO (id_evolucao) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE META_ALCANCADA_EVOLUCAO
    ADD CONSTRAINT fk_meta_alcancada_evolucao FOREIGN KEY (id_evolucao)
    REFERENCES EVOLUCAO (id_evolucao) ON DELETE CASCADE ON UPDATE CASCADE;

-- FINANCEIRO

ALTER TABLE SERVICO_PLANO_SERVICO
    ADD CONSTRAINT fk_servico_plano_servico FOREIGN KEY (id_plano_servico)
    REFERENCES PLANO_SERVICO (id_plano_servico) ON DELETE CASCADE;

ALTER TABLE CONTRATA_PLANO
    ADD CONSTRAINT fk_contrata_plano_paciente FOREIGN KEY (id_paciente)
    REFERENCES PACIENTE (id_paciente) ON DELETE RESTRICT;

ALTER TABLE CONTRATA_PLANO
    ADD CONSTRAINT fk_contrata_plano_plano_servico FOREIGN KEY (id_plano_servico)
    REFERENCES PLANO_SERVICO (id_plano_servico) ON DELETE RESTRICT;

ALTER TABLE OBSERVACAO_CONTRATO
    ADD CONSTRAINT fk_observacao_contrato FOREIGN KEY (id_contrato)
    REFERENCES CONTRATA_PLANO (id_contrato) ON DELETE CASCADE;

ALTER TABLE PAGAMENTO
    ADD CONSTRAINT fk_pagamento_contrato FOREIGN KEY (id_contrato)
    REFERENCES CONTRATA_PLANO (id_contrato) ON DELETE RESTRICT;

ALTER TABLE OBSERVACAO_PAGAMENTO
    ADD CONSTRAINT fk_observacao_pagamento FOREIGN KEY (id_pagamento)
    REFERENCES PAGAMENTO (id_pagamento) ON DELETE CASCADE;

-- HISTORICO

ALTER TABLE HISTORICO_PLANO_TREINO
    ADD CONSTRAINT fk_historico_plano_treino_plano FOREIGN KEY (id_plano_treino)
    REFERENCES PLANO_TREINO (id_plano_treino) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE HISTORICO_PLANO_TREINO
    ADD CONSTRAINT fk_historico_plano_treino_educador FOREIGN KEY (id_profissional)
    REFERENCES EDUCADOR_FISICO (id_profissional) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE HISTORICO_PLANO_ALIMENTAR
    ADD CONSTRAINT fk_historico_plano_alimentar_plano FOREIGN KEY (id_plano_alimentar)
    REFERENCES PLANO_ALIMENTAR (id_plano_alimentar) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE HISTORICO_PLANO_ALIMENTAR
    ADD CONSTRAINT fk_historico_plano_alimentar_nutricionista FOREIGN KEY (id_profissional)
    REFERENCES NUTRICIONISTA (id_profissional) ON DELETE RESTRICT ON UPDATE CASCADE;
