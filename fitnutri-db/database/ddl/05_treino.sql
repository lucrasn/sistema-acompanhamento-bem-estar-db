-- 29 PLANO_TREINO
CREATE TABLE PLANO_TREINO (
    id_plano_treino      INTEGER      GENERATED ALWAYS AS IDENTITY,
    id_consulta_fisica   INTEGER      NOT NULL,
    data_inicio          DATE         NOT NULL,
    data_fim             DATE,
    dificuldade          VARCHAR(30),
    frequencia_semanal   INTEGER,
    duracao              INTEGER,
    status               VARCHAR(20)  NOT NULL DEFAULT 'Ativo',

    CONSTRAINT pk_plano_treino
        PRIMARY KEY (id_plano_treino),

    CONSTRAINT fk_plano_treino_consulta
        FOREIGN KEY (id_consulta_fisica)
        REFERENCES CONSULTA_FISICO (id_consulta_fisica)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT ck_plano_treino_status
        CHECK (status IN ('Ativo', 'Inativo')),

    CONSTRAINT ck_plano_treino_datas
        CHECK (data_fim IS NULL OR data_fim >= data_inicio),

    CONSTRAINT ck_plano_treino_frequencia_semanal
        CHECK (frequencia_semanal IS NULL OR frequencia_semanal BETWEEN 1 AND 7),

    CONSTRAINT ck_plano_treino_duracao
        CHECK (duracao IS NULL OR duracao > 0)
);

-- 30 OBJETIVO_TREINO
CREATE TABLE OBJETIVO (
    id_obj_treino     INTEGER      GENERATED ALWAYS AS IDENTITY,
    id_plano_treino   INTEGER      NOT NULL,
    objetivos         VARCHAR(120) NOT NULL,

    CONSTRAINT pk_objetivo_treino
        PRIMARY KEY (id_obj_treino, id_plano_treino),

    CONSTRAINT fk_objetivo_treino_plano
        FOREIGN KEY (id_plano_treino)
        REFERENCES PLANO_TREINO (id_plano_treino)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 31 OBSERVACAO_GERAL_PLANO_TREINO
CREATE TABLE OBSERVACAO_GERAL_PLANO_TREINO (
    id_obs_geral_pt   INTEGER      GENERATED ALWAYS AS IDENTITY,
    id_plano_treino   INTEGER      NOT NULL,
    obs_geral         VARCHAR(120) NOT NULL,

    CONSTRAINT pk_observacao_geral_plano_treino
        PRIMARY KEY (id_obs_geral_pt, id_plano_treino),

    CONSTRAINT fk_obs_geral_pt_plano
        FOREIGN KEY (id_plano_treino)
        REFERENCES PLANO_TREINO (id_plano_treino)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- 32 PLANO_TREINO_PODE_CONTER_EXERCICIO
CREATE TABLE PLANO_TREINO_PODE_CONTER_EXERCICIO (
    id_exercicio      INTEGER  NOT NULL,
    id_plano_treino   INTEGER  NOT NULL,
    intervalo         INTERVAL NOT NULL,
    tempo_execucao    INTEGER  NOT NULL,
    carga             INTEGER  NOT NULL,
    repeticao         INTEGER  NOT NULL,
    serie             INTEGER  NOT NULL,

    CONSTRAINT pk_plano_treino_pode_conter_exercicio
        PRIMARY KEY (id_exercicio, id_plano_treino),

    CONSTRAINT fk_ptpce_exercicio
        FOREIGN KEY (id_exercicio)
        REFERENCES EXERCICIO (id_exercicio)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_ptpce_plano_treino
        FOREIGN KEY (id_plano_treino)
        REFERENCES PLANO_TREINO (id_plano_treino)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT ck_ptpce_intervalo
        CHECK (intervalo >= 0),

    CONSTRAINT ck_ptpce_tempo_execucao
        CHECK (tempo_execucao > INTERVAL '0'),

    CONSTRAINT ck_ptpce_carga
        CHECK (carga >= 0),

    CONSTRAINT ck_ptpce_repeticao
        CHECK (repeticao > 0),

    CONSTRAINT ck_ptpce_serie
        CHECK (serie > 0)
);
-- 33 OBSERVACAO_TECNICA
CREATE TABLE OBSERVACAO_TECNICA (
    id_obs_tecnica    INTEGER      GENERATED ALWAYS AS IDENTITY,
    id_plano_treino   INTEGER      NOT NULL,
    id_exercicio      INTEGER      NOT NULL,
    observacoes       VARCHAR(120) NOT NULL,

    CONSTRAINT pk_observacao_tecnica
        PRIMARY KEY (id_obs_tecnica, id_plano_treino, id_exercicio),

    CONSTRAINT fk_observacao_tecnica_ptpce
        FOREIGN KEY (id_plano_treino, id_exercicio)
        REFERENCES PLANO_TREINO_PODE_CONTER_EXERCICIO (id_plano_treino, id_exercicio)
        ON DELETE CASCADE ON UPDATE CASCADE
);
