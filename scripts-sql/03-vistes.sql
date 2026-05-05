DROP VIEW IF EXISTS vista_recepcio_disponibilitat;

CREATE VIEW vista_recepcio_disponibilitat AS
SELECT
    f.film_id,
    f.title AS titol_pelicula,
    COUNT(i.inventory_id) AS total_copies,
    COUNT(i.inventory_id) AS copies_disponibles
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;

GRANT SELECT ON vista_recepcio_disponibilitat TO grup_atencio;
GRANT SELECT ON vista_recepcio_disponibilitat TO grup_gerencia;
