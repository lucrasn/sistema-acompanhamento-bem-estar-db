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

    CONSTRAINT pk_exercicio PRIMARY KEY (id_exercicio)
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
