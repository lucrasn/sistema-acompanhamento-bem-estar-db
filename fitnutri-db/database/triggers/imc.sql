-- OBTÉM A ALTURA DO PACIENTE RELACIONADO À EVOLUÇÃO
CREATE OR REPLACE FUNCTION fn_obter_altura_evolucao(
    p_id_evolucao INTEGER
)
RETURNS DECIMAL(4,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_altura DECIMAL(4,2);
BEGIN
    SELECT p.altura
      INTO v_altura
      FROM EVOLUCAO_FISICA ef
      JOIN CONSULTA_FISICA cf
        ON cf.id_consulta_fisica = ef.id_consulta_fisica
      JOIN PACIENTE p
        ON p.id_paciente = cf.id_paciente
     WHERE ef.id_evolucao = p_id_evolucao;

    IF v_altura IS NULL THEN
        SELECT p.altura
          INTO v_altura
          FROM EVOLUCAO_NUTRICIONAL en
          JOIN CONSULTA_NUTRICIONAL cn
            ON cn.id_consulta_nutricional = en.id_consulta_nutricional
          JOIN PACIENTE p
            ON p.id_paciente = cn.id_paciente
         WHERE en.id_evolucao = p_id_evolucao;
    END IF;

    RETURN v_altura;
END;
$$;

-- CALCULA O IMC QUANDO O PESO É ALTERADO
CREATE OR REPLACE FUNCTION fn_calcular_imc()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_altura DECIMAL(4,2);
BEGIN
    v_altura := fn_obter_altura_evolucao(
        NEW.id_evolucao
    );

    IF v_altura IS NULL OR v_altura <= 0 THEN
        NEW.imc := NULL;
    ELSE
        NEW.imc := ROUND(
            NEW.peso / (v_altura * v_altura),
            2
        );
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_calcular_imc
BEFORE UPDATE OF peso
ON EVOLUCAO
FOR EACH ROW
EXECUTE FUNCTION fn_calcular_imc();

-- FORÇA O CÁLCULO DO IMC QUANDO A EVOLUÇÃO É VINCULADA A UMA CONSULTA
CREATE OR REPLACE FUNCTION fn_recalcular_imc_apos_vinculo()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE EVOLUCAO -- so pra ativar o trg_calcular_imc
       SET peso = peso
     WHERE id_evolucao = NEW.id_evolucao;

    RETURN NULL;
END;
$$;

CREATE TRIGGER trg_recalcular_imc_evolucao_fisica
AFTER INSERT OR UPDATE OF id_consulta_fisica
ON EVOLUCAO_FISICA
FOR EACH ROW
EXECUTE FUNCTION fn_recalcular_imc_apos_vinculo();

CREATE TRIGGER trg_recalcular_imc_evolucao_nutricional
AFTER INSERT OR UPDATE OF id_consulta_nutricional
ON EVOLUCAO_NUTRICIONAL
FOR EACH ROW
EXECUTE FUNCTION fn_recalcular_imc_apos_vinculo();

-- CALCULA O IMC QUANDO O ALTURA É ALTERADO
CREATE OR REPLACE FUNCTION fn_recalcular_imc_por_altura()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE EVOLUCAO e -- so pra ativar o trg_calcular_imc
       SET peso = e.peso
     WHERE e.id_evolucao IN (
               SELECT ef.id_evolucao
                 FROM EVOLUCAO_FISICA ef
                 JOIN CONSULTA_FISICA cf
                   ON cf.id_consulta_fisica = ef.id_consulta_fisica
                WHERE cf.id_paciente = NEW.id_paciente
               UNION
               SELECT en.id_evolucao
                 FROM EVOLUCAO_NUTRICIONAL en
                 JOIN CONSULTA_NUTRICIONAL cn
                   ON cn.id_consulta_nutricional = en.id_consulta_nutricional
                WHERE cn.id_paciente = NEW.id_paciente
           );

    RETURN NULL;
END;
$$;

CREATE TRIGGER trg_recalcular_imc_altura
AFTER UPDATE OF altura
ON PACIENTE
FOR EACH ROW
WHEN (NEW.altura IS DISTINCT FROM OLD.altura)
EXECUTE FUNCTION fn_recalcular_imc_por_altura();

-- BLOQUEIA INSERÇÃO E ALTERAÇÃO MANUAL DO IMC
CREATE OR REPLACE FUNCTION fn_bloquear_imc_manual()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.imc IS NOT NULL THEN
            RAISE EXCEPTION
                'O campo IMC é calculado automaticamente e não pode ser informado manualmente.';
        END IF;
    ELSIF NEW.imc IS DISTINCT FROM OLD.imc THEN
        RAISE EXCEPTION
            'O campo IMC é calculado automaticamente e não pode ser alterado manualmente.';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_bloquear_imc_manual
BEFORE INSERT OR UPDATE OF imc
ON EVOLUCAO
FOR EACH ROW
EXECUTE FUNCTION fn_bloquear_imc_manual();
