CREATE TABLE EVOLUCAO_FISICA (
    id_evolucao INTEGER NOT NULL,
    id_consulta_fisica INTEGER NOT NULL,
    massa_muscular DECIMAL(5,2),
    circ_abdominal DECIMAL(5,2),
    circ_toracica DECIMAL(5,2),
    desempenho_fisico TEXT,

    CONSTRAINT pk_evolucao_fisica PRIMARY KEY (id_evolucao),

    CONSTRAINT uq_evolucao_fisica_consulta UNIQUE (id_consulta_fisica),

    CONSTRAINT fk_evolucao_fisica_evolucao
        FOREIGN KEY (id_evolucao)
        REFERENCES EVOLUCAO (id_evolucao),

    CONSTRAINT fk_evolucao_fisica_consulta
        FOREIGN KEY (id_consulta_fisica)
        REFERENCES CONSULTA_FISICA (id_consulta_fisica),

    CONSTRAINT ck_evolucao_fisica_medidas
    CHECK (
        massa_muscular >= 0
        AND circ_abdominal >= 0
        AND circ_toracica >= 0
    )
);

CREATE TABLE EVOLUCAO_NUTRICIONAL (
    id_evolucao INTEGER NOT NULL,
    id_consulta_nutricional INTEGER NOT NULL,
    aderencia_alimentar TEXT,
    consumo_calorico INTEGER,
    evolucao_clinica TEXT,

    CONSTRAINT pk_evolucao_nutricional PRIMARY KEY (id_evolucao),

    CONSTRAINT uq_evolucao_nutricional_consulta UNIQUE (id_consulta_nutricional),

    CONSTRAINT fk_evolucao_nutricional_evolucao
        FOREIGN KEY (id_evolucao)
        REFERENCES EVOLUCAO (id_evolucao),

    CONSTRAINT fk_evolucao_nutricional_consulta
        FOREIGN KEY (id_consulta_nutricional)
        REFERENCES CONSULTA_NUTRICIONAL (id_consulta_nutricional),
    
    CONSTRAINT ck_evolucao_nutricional_consumo_calorico
    CHECK (consumo_calorico > 0)
);

CREATE TABLE OBSERVACAO_EVOLUCAO (
    id_obs_evolucao INTEGER NOT NULL,
    id_evolucao INTEGER NOT NULL,
    observacao_evolucao TEXT NOT NULL,

    CONSTRAINT pk_observacao_evolucao
        PRIMARY KEY (id_obs_evolucao, id_evolucao),

    CONSTRAINT fk_observacao_evolucao_evolucao
        FOREIGN KEY (id_evolucao)
        REFERENCES EVOLUCAO (id_evolucao)
);

CREATE TABLE META_ALCANCADA_EVOLUCAO (
    id_metas INTEGER NOT NULL,
    id_evolucao INTEGER NOT NULL,
    metas_alcancadas TEXT NOT NULL,

    CONSTRAINT pk_meta_alcancada_evolucao PRIMARY KEY (id_metas, id_evolucao),

    CONSTRAINT fk_meta_alcancada_evolucao
        FOREIGN KEY (id_evolucao)
        REFERENCES EVOLUCAO (id_evolucao)
);