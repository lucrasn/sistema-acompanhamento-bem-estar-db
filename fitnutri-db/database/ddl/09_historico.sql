-- 48 HISTORICO_PLANO_TREINO
    CREATE TABLE HISTORICO_PLANO_TREINO (
    id_historico_pt     INTEGER    GENERATED ALWAYS AS IDENTITY,
    id_plano_treino     INTEGER    NOT NULL,
    data_alteracao      TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descricao_alteracao TEXT       NOT NULL,
    id_profissional     INTEGER    NOT NULL,

    CONSTRAINT pk_historico_plano_treino
        PRIMARY KEY (id_historico_pt, id_plano_treino),

    CONSTRAINT fk_historico_plano_treino_plano
        FOREIGN KEY (id_plano_treino)
        REFERENCES PLANO_TREINO (id_plano_treino)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_historico_plano_treino_profissional
        FOREIGN KEY (id_profissional)
        REFERENCES PROFISSIONAL (id_profissional)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 49 HISTORICO_PLANO_ALIMENTAR
CREATE TABLE historico_plano_alimentar (
    id_historico_pa      INTEGER    GENERATED ALWAYS AS IDENTITY,
    id_plano_alimentar   INTEGER    NOT NULL,
    data_alteracao       TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descricao_alteracao  TEXT       NOT NULL,
    id_profissional      INTEGER    NOT NULL,

    CONSTRAINT pk_historico_plano_alimentar
        PRIMARY KEY (id_historico_pa, id_plano_alimentar),

    CONSTRAINT fk_historico_plano_alimentar_plano
        FOREIGN KEY (id_plano_alimentar)
        REFERENCES plano_alimentar (id_plano_alimentar)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_historico_plano_alimentar_profissional
        FOREIGN KEY (id_profissional)
        REFERENCES profissional (id_profissional)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
