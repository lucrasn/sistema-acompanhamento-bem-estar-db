CREATE TABLE PLANO_ALIMENTAR (
    id_plano_alimentar INTEGER NOT NULL,
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

    CONSTRAINT fk_plano_alimentar_consulta_nutricional
        FOREIGN KEY (id_consulta_nutricional)
        REFERENCES CONSULTA_NUTRICIONAL (id_consulta_nutricional),

    CONSTRAINT ck_plano_alimentar_status CHECK (status IN ('Ativo', 'Inativo')),

    CONSTRAINT ck_plano_alimentar_datas
    CHECK (data_termino >= data_inicio),

    CONSTRAINT ck_plano_alimentar_metas
    CHECK (
        quantidade_proteina >= 0
        AND quantidade_caloria_diaria >= 0
        AND quantidade_carboidrato >= 0
        AND quantidade_gordura >= 0
    )
);

CREATE TABLE OBSERVACAO_PLANO_ALIMENTAR (
    id_obs_plano_alim INTEGER NOT NULL,
    id_plano_alimentar INTEGER NOT NULL,
    obs_geral VARCHAR(255) NOT NULL,

    CONSTRAINT pk_observacao_plano_alimentar PRIMARY KEY (id_obs_plano_alim, id_plano_alimentar),

    CONSTRAINT fk_observacao_plano_alimentar_plano
        FOREIGN KEY (id_plano_alimentar)
        REFERENCES PLANO_ALIMENTAR (id_plano_alimentar)
);

CREATE TABLE REFEICAO (
    id_plano_alimentar INTEGER NOT NULL,
    id_refeicao INTEGER NOT NULL,
    horario TIME,
    nome VARCHAR(120) NOT NULL,

    CONSTRAINT pk_refeicao PRIMARY KEY (id_plano_alimentar, id_refeicao),

    CONSTRAINT fk_refeicao_plano_alimentar
        FOREIGN KEY (id_plano_alimentar)
        REFERENCES PLANO_ALIMENTAR (id_plano_alimentar)
);

CREATE TABLE REFEICAO_CONTEM_ALIMENTO (
    id_alimento INTEGER NOT NULL,
    id_plano_alimentar INTEGER NOT NULL,
    id_refeicao INTEGER NOT NULL,
    unidade_de_medida VARCHAR(30) NOT NULL,
    quantidade DECIMAL(7,2) NOT NULL,
    substituicao_permitida TEXT,

    CONSTRAINT pk_refeicao_contem_alimento PRIMARY KEY (id_alimento, id_plano_alimentar, id_refeicao),

    CONSTRAINT fk_refeicao_contem_alimento_alimento
        FOREIGN KEY (id_alimento)
        REFERENCES ALIMENTO (id_alimento),

    CONSTRAINT fk_refeicao_contem_alimento_refeicao
        FOREIGN KEY (id_plano_alimentar, id_refeicao)
        REFERENCES REFEICAO (id_plano_alimentar, id_refeicao),

    CONSTRAINT ck_refeicao_contem_alimento_quantidade
    CHECK (quantidade > 0)
);

CREATE TABLE OBSERVACAO_REFEICAO_CONTEM (
    id_alimento INTEGER NOT NULL,
    id_plano_alimentar INTEGER NOT NULL,
    id_refeicao INTEGER NOT NULL,
    id_obs_refeicao INTEGER NOT NULL,
    observacao TEXT NOT NULL,

    CONSTRAINT pk_observacao_refeicao_contem
        PRIMARY KEY (
            id_alimento,
            id_plano_alimentar,
            id_refeicao,
            id_obs_refeicao
        ),

    CONSTRAINT fk_observacao_refeicao_contem_item
        FOREIGN KEY (
            id_alimento,
            id_plano_alimentar,
            id_refeicao
        )
        REFERENCES REFEICAO_CONTEM_ALIMENTO (
            id_alimento,
            id_plano_alimentar,
            id_refeicao
        )
);