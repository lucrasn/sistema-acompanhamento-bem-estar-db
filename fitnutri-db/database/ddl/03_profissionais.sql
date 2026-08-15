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
