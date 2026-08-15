-- OBTÉM O VALOR MENSAL DO PLANO VINCULADO AO CONTRATO
CREATE OR REPLACE FUNCTION fn_obter_valor_mensal_contrato(
    p_id_contrato INTEGER
)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_valor_mensal DECIMAL(10,2);
BEGIN
    SELECT ps.valor_mensal
      INTO v_valor_mensal
      FROM CONTRATA_PLANO cp
      JOIN PLANO_SERVICO ps
        ON ps.id_plano_servico = cp.id_plano_servico
     WHERE cp.id_contrato = p_id_contrato;

    RETURN v_valor_mensal;
END;
$$;

-- CALCULA O VALOR LÍQUIDO QUANDO O DESCONTO, A MULTA OU O CONTRATO SÃO ALTERADOS
CREATE OR REPLACE FUNCTION fn_calcular_valor_liquido()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_valor_mensal DECIMAL(10,2);
BEGIN
    v_valor_mensal := fn_obter_valor_mensal_contrato(
        NEW.id_contrato
    );

    IF v_valor_mensal IS NULL THEN
        NEW.valor_liquido := NULL;
    ELSE
        NEW.valor_liquido := ROUND(
            v_valor_mensal
            + COALESCE(NEW.multa, 0)
            - COALESCE(NEW.desconto, 0),
            2
        );
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_calcular_valor_liquido
BEFORE INSERT OR UPDATE OF desconto, multa, id_contrato
ON PAGAMENTO
FOR EACH ROW
EXECUTE FUNCTION fn_calcular_valor_liquido();

-- BLOQUEIA INSERÇÃO E ALTERAÇÃO MANUAL DO VALOR LÍQUIDO
CREATE OR REPLACE FUNCTION fn_bloquear_valor_liquido_manual()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.valor_liquido IS NOT NULL THEN
            RAISE EXCEPTION
                'O campo valor_liquido é calculado automaticamente e não pode ser informado manualmente.';
        END IF;
    ELSIF NEW.valor_liquido IS DISTINCT FROM OLD.valor_liquido THEN
        RAISE EXCEPTION
            'O campo valor_liquido é calculado automaticamente e não pode ser alterado manualmente.';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_bloquear_valor_liquido_manual
BEFORE INSERT OR UPDATE OF valor_liquido
ON PAGAMENTO
FOR EACH ROW
EXECUTE FUNCTION fn_bloquear_valor_liquido_manual();
