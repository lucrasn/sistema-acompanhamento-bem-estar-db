CREATE TABLE TELEFONE_PACIENTE (
    id_paciente INTEGER NOT NULL,
    numero_telefone VARCHAR(20) NOT NULL,

    CONSTRAINT pk_telefone_paciente PRIMARY KEY (id_paciente, numero_telefone),

    CONSTRAINT fk_telefone_paciente_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente)
);

CREATE TABLE CONTATO_EMERGENCIA (
    id_contato_emr INTEGER NOT NULL,
    id_paciente INTEGER NOT NULL,
    nome VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,

    CONSTRAINT pk_contato_emergencia PRIMARY KEY (id_contato_emr, id_paciente),

    CONSTRAINT fk_contato_emergencia_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente)
);

CREATE TABLE RESTRICAO_FISICA (
    id_restri_fisica INTEGER NOT NULL,
    id_paciente INTEGER NOT NULL,
    limitacoes_fisicas VARCHAR(255) NOT NULL,

    CONSTRAINT pk_restricao_fisica PRIMARY KEY (id_restri_fisica, id_paciente),

    CONSTRAINT fk_restricao_fisica_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente)
);

CREATE TABLE RESTRICAO_ALIMENTAR (
    id_restri_alim INTEGER NOT NULL,
    id_paciente INTEGER NOT NULL,
    limitacoes_alimentares VARCHAR(255) NOT NULL,

    CONSTRAINT pk_restricao_alim PRIMARY KEY (id_restri_alim, id_paciente),

    CONSTRAINT fk_restricao_alim_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente)
);

CREATE TABLE PACIENTE_DOENCA (
    id_paciente_doenca INTEGER NOT NULL,
    id_paciente INTEGER NOT NULL,
    doencas VARCHAR(255) NOT NULL,

    CONSTRAINT pk_paciente_doenca PRIMARY KEY (id_paciente_doenca, id_paciente),

    CONSTRAINT fk_paciente_doenca_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente)
);

CREATE TABLE PACIENTE_ALERGIA (
    id_paciente_alerg INTEGER NOT NULL,
    id_paciente INTEGER NOT NULL,
    alergias VARCHAR(255) NOT NULL,

    CONSTRAINT pk_paciente_alerg PRIMARY KEY (id_paciente_alerg, id_paciente),

    CONSTRAINT fk_paciente_alerg_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente)
);

CREATE TABLE MEDICAMENTO (
    id_medicamento INTEGER NOT NULL,
    id_paciente INTEGER NOT NULL,
    medicamentos VARCHAR(255) NOT NULL,

    CONSTRAINT pk_medicamento PRIMARY KEY (id_medicamento, id_paciente),

    CONSTRAINT fk_medicamento_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES PACIENTE (id_paciente)
);