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
