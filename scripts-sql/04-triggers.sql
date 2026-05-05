CREATE OR REPLACE FUNCTION fn_validar_cliente_alquiler()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    deuda_pendiente numeric(10,2);
BEGIN
    IF EXISTS (
        SELECT 1
        FROM rental r
        WHERE r.customer_id = NEW.customer_id
          AND r.return_date IS NULL
          AND r.rental_date < (CURRENT_DATE - INTERVAL '30 days')
    ) THEN
        RAISE EXCEPTION
            'No se permite el alquiler. El cliente % tiene alquileres no devueltos desde hace más de 30 días.',
            NEW.customer_id;
    END IF;

    SELECT
        COALESCE(SUM(f.rental_rate), 0) - COALESCE(SUM(p.amount), 0)
    INTO deuda_pendiente
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    LEFT JOIN payment p ON p.rental_id = r.rental_id
    WHERE r.customer_id = NEW.customer_id
      AND r.rental_id <> COALESCE(NEW.rental_id, -1);

    IF deuda_pendiente > 0 THEN
        RAISE EXCEPTION
            'No se permite el alquiler. El cliente % tiene una deuda pendiente de %.',
            NEW.customer_id,
            deuda_pendiente;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_validar_cliente_alquiler ON rental;

CREATE TRIGGER trg_validar_cliente_alquiler
BEFORE INSERT ON rental
FOR EACH ROW
EXECUTE FUNCTION fn_validar_cliente_alquiler();

COMMENT ON FUNCTION fn_validar_cliente_alquiler() IS 'Valida alquileres según deuda y retrasos';
COMMENT ON TRIGGER trg_validar_cliente_alquiler ON rental IS 'Impide alquileres a clientes con incidencias';
