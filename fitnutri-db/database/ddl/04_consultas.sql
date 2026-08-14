-- 20 CONSULTA_FISICA
CREATE TABLE consulta_fisica (
    id_consulta_fisica  INTEGER      GENERATED ALWAYS AS IDENTITY,
    id_paciente         INTEGER      NOT NULL,
    id_profissional     INTEGER      NOT NULL,
    data_consulta       DATE         NOT NULL,
    horario             TIME         NOT NULL,
    tipo_consulta       VARCHAR(60)  NOT NULL,
    avaliacao_fisica    TEXT         NOT NULL,
    freq_cardiaca       INTEGER      NOT NULL,
    press_arterial      VARCHAR(20)  NOT NULL,
    cond_fisico         VARCHAR(120) NOT NULL,
    prox_consulta       DATE,

    CONSTRAINT pk_consulta_fisica
        PRIMARY KEY (id_consulta_fisica),

    CONSTRAINT fk_consulta_fisica_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES paciente (id_paciente)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_consulta_fisica_educador
        FOREIGN KEY (id_profissional)
        REFERENCES educador_fisico (id_profissional)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT ck_consulta_fisica_freq_cardiaca
        CHECK (freq_cardiaca > 0 AND freq_cardiaca < 300),

    CONSTRAINT ck_consulta_fisica_prox_consulta
        CHECK (prox_consulta IS NULL OR prox_consulta >= data_consulta)
);

-- 21 CONSULTA_NUTRICIONAL
CREATE TABLE consulta_nutricional (
    id_consulta_nutricional  INTEGER      GENERATED ALWAYS AS IDENTITY,
    id_paciente              INTEGER      NOT NULL,
    id_profissional          INTEGER      NOT NULL,
    data_consulta            INTEGER      NOT NULL,
    horario                  TIME         NOT NULL,
    objetivo_nutricional     VARCHAR(255),
    suplementacao            TEXT,
    consumo_agua             DECIMAL(4,2),
    prox_consulta            DATE,

    CONSTRAINT pk_consulta_nutricional
        PRIMARY KEY (id_consulta_nutricional),

    CONSTRAINT fk_consulta_nutricional_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES paciente (id_paciente)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_consulta_nutricional_nutricionista
        FOREIGN KEY (id_profissional)
        REFERENCES nutricionista (id_profissional)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT ck_consulta_nutricional_consumo_agua
        CHECK (consumo_agua IS NULL OR consumo_agua >= 0),

    CONSTRAINT ck_consulta_nutricional_prox_consulta
        CHECK (prox_consulta IS NULL OR prox_consulta >= data_consulta)
);

-- 22 OBJETIVO_FISICO_PACIENTE
CREATE TABLE objetivo_fisico_paciente (
    id_obj_paciente     INTEGER      GENERATED ALWAYS AS IDENTITY,
    id_consulta_fisica  INTEGER      NOT NULL,
    objetivo            VARCHAR(255) NOT NULL,

    CONSTRAINT pk_objetivo_fisico_paciente
        PRIMARY KEY (id_obj_paciente, id_consulta_fisica),

    CONSTRAINT fk_objetivo_fisico_paciente_consulta
        FOREIGN KEY (id_consulta_fisica)
        REFERENCES consulta_fisica (id_consulta_fisica)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- 23 RECOMENDACAO_FISICA
    CREATE TABLE recomendacao_fisica (
    id_recom_fisica     INTEGER  GENERATED ALWAYS AS IDENTITY,
    id_consulta_fisica  INTEGER  NOT NULL,
    recomendacao        TEXT     NOT NULL,

    CONSTRAINT pk_recomendacao_fisica
        PRIMARY KEY (id_recom_fisica, id_consulta_fisica),

    CONSTRAINT fk_recomendacao_fisica_consulta
        FOREIGN KEY (id_consulta_fisica)
        REFERENCES consulta_fisica (id_consulta_fisica)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- 24 OBSERVACAO_GERAL_CONSULTA_FISICA
CREATE TABLE observacao_geral_consulta_fisica (
    id_obs_geral_cf     INTEGER  GENERATED ALWAYS AS IDENTITY,
    id_consulta_fisica  INTEGER  NOT NULL,
    obs_geral           TEXT     NOT NULL,

    CONSTRAINT pk_observacao_geral_consulta_fisica
        PRIMARY KEY (id_obs_geral_cf, id_consulta_fisica),

    CONSTRAINT fk_obs_geral_cf_consulta
        FOREIGN KEY (id_consulta_fisica)
        REFERENCES consulta_fisica (id_consulta_fisica)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- 25 INTOLERANCIA_CONSULTA_NUTRI
CREATE TABLE intolerancia_consulta_nutri (
    id_intolerancia_consulta_nutri  INTEGER      GENERATED ALWAYS AS IDENTITY,
    id_consulta_nutricional         INTEGER      NOT NULL,
    intolerancia                    VARCHAR(255) NOT NULL,

    CONSTRAINT pk_intolerancia_consulta_nutri
        PRIMARY KEY (id_intolerancia_consulta_nutri, id_consulta_nutricional),

    CONSTRAINT fk_intolerancia_consulta_nutri_consulta
        FOREIGN KEY (id_consulta_nutricional)
        REFERENCES consulta_nutricional (id_consulta_nutricional)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- 26 HABITO_ALIMENTAR
CREATE TABLE habito_alimentar (
    id_habito_alimentar      INTEGER  GENERATED ALWAYS AS IDENTITY,
    id_consulta_nutricional  INTEGER  NOT NULL,
    habito_alimentar         TEXT     NOT NULL,

    CONSTRAINT pk_habito_alimentar
        PRIMARY KEY (id_habito_alimentar, id_consulta_nutricional),

    CONSTRAINT fk_habito_alimentar_consulta
        FOREIGN KEY (id_consulta_nutricional)
        REFERENCES consulta_nutricional (id_consulta_nutricional)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- 27 OBSERVACAO_CLINICA
CREATE TABLE observacao_clinica (
    id_obs_clinica            INTEGER  GENERATED ALWAYS AS IDENTITY,
    id_consulta_nutricional   INTEGER  NOT NULL,
    observacoes_clinicas      TEXT     NOT NULL,

    CONSTRAINT pk_observacao_clinica
        PRIMARY KEY (id_obs_clinica, id_consulta_nutricional),

    CONSTRAINT fk_observacao_clinica_consulta
        FOREIGN KEY (id_consulta_nutricional)
        REFERENCES consulta_nutricional (id_consulta_nutricional)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- 28 RECOMENDACAO_NUTRICIONAL
CREATE TABLE recomendacao_nutricional (
    id_recom_nutri            INTEGER  GENERATED ALWAYS AS IDENTITY,
    id_consulta_nutricional   INTEGER  NOT NULL,
    recomendacao              TEXT     NOT NULL,

    CONSTRAINT pk_recomendacao_nutricional
        PRIMARY KEY (id_recom_nutri, id_consulta_nutricional),

    CONSTRAINT fk_recomendacao_nutricional_consulta
        FOREIGN KEY (id_consulta_nutricional)
        REFERENCES consulta_nutricional (id_consulta_nutricional)
        ON DELETE CASCADE ON UPDATE CASCADE
);
