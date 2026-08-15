-- IMPEDE QUE A MESMA EVOLUCAO CONSTE NAS DUAS SUBCLASSES
-- A ESPECIALIZACAO DE EVOLUCAO E DISJUNTA
CREATE OR REPLACE FUNCTION fn_verificar_disjuncao_evolucao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_TABLE_NAME = 'evolucao_fisica' THEN
        IF EXISTS (
            SELECT 1
              FROM EVOLUCAO_NUTRICIONAL
             WHERE id_evolucao = NEW.id_evolucao
        ) THEN
            RAISE EXCEPTION
                'A evolucao % ja esta registrada como nutricional. A especializacao de EVOLUCAO e disjunta.',
                NEW.id_evolucao;
        END IF;
    ELSE
        IF EXISTS (
            SELECT 1
              FROM EVOLUCAO_FISICA
             WHERE id_evolucao = NEW.id_evolucao
        ) THEN
            RAISE EXCEPTION
                'A evolucao % ja esta registrada como fisica. A especializacao de EVOLUCAO e disjunta.',
                NEW.id_evolucao;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_disjuncao_evolucao_fisica
BEFORE INSERT OR UPDATE OF id_evolucao
ON EVOLUCAO_FISICA
FOR EACH ROW
EXECUTE FUNCTION fn_verificar_disjuncao_evolucao();

CREATE TRIGGER trg_disjuncao_evolucao_nutricional
BEFORE INSERT OR UPDATE OF id_evolucao
ON EVOLUCAO_NUTRICIONAL
FOR EACH ROW
EXECUTE FUNCTION fn_verificar_disjuncao_evolucao();

-- EXIGE QUE TODA EVOLUCAO ESTEJA EM UMA DAS SUBCLASSES
-- A ESPECIALIZACAO DE EVOLUCAO E TOTAL
-- A VERIFICACAO E ADIADA PARA O FIM DA TRANSACAO, POIS A SUBCLASSE
-- SO PODE SER INSERIDA DEPOIS DA SUPERCLASSE
CREATE OR REPLACE FUNCTION fn_verificar_totalidade_evolucao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id INTEGER := COALESCE(NEW.id_evolucao, OLD.id_evolucao);
BEGIN
    IF NOT EXISTS (SELECT 1 FROM EVOLUCAO WHERE id_evolucao = v_id) THEN
        RETURN NULL; -- a superclasse foi removida, nao ha o que verificar
    END IF;

    IF NOT EXISTS (SELECT 1 FROM EVOLUCAO_FISICA WHERE id_evolucao = v_id)
   AND NOT EXISTS (SELECT 1 FROM EVOLUCAO_NUTRICIONAL WHERE id_evolucao = v_id) THEN
        RAISE EXCEPTION
            'A evolucao % precisa ser fisica ou nutricional. A especializacao de EVOLUCAO e total.',
            v_id;
    END IF;

    RETURN NULL;
END;
$$;

CREATE CONSTRAINT TRIGGER trg_totalidade_evolucao
AFTER INSERT
ON EVOLUCAO
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_verificar_totalidade_evolucao();

CREATE CONSTRAINT TRIGGER trg_totalidade_evolucao_fisica
AFTER DELETE
ON EVOLUCAO_FISICA
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_verificar_totalidade_evolucao();

CREATE CONSTRAINT TRIGGER trg_totalidade_evolucao_nutricional
AFTER DELETE
ON EVOLUCAO_NUTRICIONAL
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_verificar_totalidade_evolucao();

-- EXIGE QUE TODO PROFISSIONAL SEJA NUTRICIONISTA OU EDUCADOR FISICO
-- A ESPECIALIZACAO DE PROFISSIONAL E TOTAL E SOBREPOSTA
-- SOBREPOSTA NAO PRECISA DE VERIFICACAO: CONSTAR NAS DUAS SUBCLASSES E PERMITIDO
CREATE OR REPLACE FUNCTION fn_verificar_totalidade_profissional()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id INTEGER := COALESCE(NEW.id_profissional, OLD.id_profissional);
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PROFISSIONAL WHERE id_profissional = v_id) THEN
        RETURN NULL; -- a superclasse foi removida, nao ha o que verificar
    END IF;

    IF NOT EXISTS (SELECT 1 FROM NUTRICIONISTA WHERE id_profissional = v_id)
   AND NOT EXISTS (SELECT 1 FROM EDUCADOR_FISICO WHERE id_profissional = v_id) THEN
        RAISE EXCEPTION
            'O profissional % precisa ser nutricionista ou educador fisico. A especializacao de PROFISSIONAL e total.',
            v_id;
    END IF;

    RETURN NULL;
END;
$$;

CREATE CONSTRAINT TRIGGER trg_totalidade_profissional
AFTER INSERT
ON PROFISSIONAL
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_verificar_totalidade_profissional();

CREATE CONSTRAINT TRIGGER trg_totalidade_nutricionista
AFTER DELETE
ON NUTRICIONISTA
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_verificar_totalidade_profissional();

CREATE CONSTRAINT TRIGGER trg_totalidade_educador_fisico
AFTER DELETE
ON EDUCADOR_FISICO
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_verificar_totalidade_profissional();
