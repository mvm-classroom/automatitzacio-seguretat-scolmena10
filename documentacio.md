# Práctica: Automatización, Seguridad e Integridad en PostgreSQL

## Caso Pagila

La práctica se ha realizado en la máquina `scolmena` con el usuario `alumne`.

---

## 1. Estructura del proyecto entregado

La estructura final del proyecto con scripts principales, scripts SQL y logs generados es la siguiente:

```text
alumne@scolmena:~/Documents$ tree
.
└── pagila-automatizacion
    ├── configuracio-pagila.log
    ├── configura.sh
    ├── documentacio.md
    ├── manteniment-pagila.log
    ├── manteniment.sh
    └── scripts-sql
        ├── 00-prepara-pagila.sh
        ├── 01-rols.sql
        ├── 02-permisos.sql
        ├── 03-vistes.sql
        └── 04-triggers.sql
```

---

## 2. Instalación de dependencias

Primero se instalaron PostgreSQL, el cliente de PostgreSQL y Git, con esto ya podremos clonar Pagila y ejecutar scripts

```bash
alumne@scolmena:~/Documents/pagila-automatizacion$ sudo apt update
alumne@scolmena:~/Documents/pagila-automatizacion$ sudo apt install postgresql postgresql-contrib postgresql-client git -y
```

---

## 3. Script principal `configura.sh`

El script configura.sh es la parte principal de la práctica

Este script realiza estas tareas:

- Activa el servicio PostgreSQL
- Ejecuta scripts-sql/00-prepara-pagila.sh
- Ejecuta los scripts SQL 01, 02, 03 y 04 en orden
- Guarda la salida en configuracio-pagila.log

Ejecutaremos el script configura.sh:

```bash
alumne@scolmena:~/Documents/pagila-automatizacion$ ./configura.sh
```

<details>
<summary>Salida real de la ejecución de configura.sh</summary>

```text
[INFO] Inicio de la configuración de Pagila
[INFO] Activando PostgreSQL
Synchronizing state of postgresql.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable postgresql
● postgresql.service - PostgreSQL RDBMS
Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
Active: active (exited) since Mon 2026-05-04 19:52:38 CEST; 7min ago
Main PID: 1167 (code=exited, status=0/SUCCESS)
CPU: 1ms
may 04 19:52:38 scolmena systemd[1]: Starting PostgreSQL RDBMS...
may 04 19:52:38 scolmena systemd[1]: Finished PostgreSQL RDBMS.
[INFO] Fase 0: preparación de Pagila
[INFO] Preparando base de datos Pagila
[INFO] Eliminando carpeta anterior /tmp/pagila-src
[INFO] Clonando repositorio oficial de Pagila
S'està clonant a «/tmp/pagila-src»...
[INFO] Eliminando base de datos anterior si existe
pg_terminate_backend
----------------------
(0 rows)
DROP DATABASE
[INFO] Creando base de datos pagila
[INFO] Cargando esquema
[OK] Ejecutado correctamente: /home/alumne/Documents/pagila-automatizacion/scripts-sql/01-rols.sql
[INFO] Ejecutando /home/alumne/Documents/pagila-automatizacion/scripts-sql/02-permisos.sql
REVOKE
REVOKE
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
[OK] Ejecutado correctamente: /home/alumne/Documents/pagila-automatizacion/scripts-sql/02-permisos.sql
[INFO] Ejecutando /home/alumne/Documents/pagila-automatizacion/scripts-sql/03-vistes.sql
NOTICE: view "vista_recepcio_disponibilitat" does not exist, skipping
DROP VIEW
CREATE VIEW
GRANT
GRANT
[OK] Ejecutado correctamente: /home/alumne/Documents/pagila-automatizacion/scripts-sql/03-vistes.sql
[INFO] Ejecutando /home/alumne/Documents/pagila-automatizacion/scripts-sql/04-triggers.sql
CREATE FUNCTION
NOTICE: trigger "trg_validar_cliente_alquiler" for relation "rental" does not exist, skipping
DROP TRIGGER
CREATE TRIGGER
COMMENT
COMMENT
[OK] Ejecutado correctamente: /home/alumne/Documents/pagila-automatizacion/scripts-sql/04-triggers.sql
[OK] Configuración completa finalizada correctamente
[INFO] Log guardado en /home/alumne/Documents/pagila-automatizacion/configuracio-pagila.log
```

</details>

Una vez termine de ejecutarse generará el archivo configuracio-pagila.log

---

## 4. Fase 0: preparación de Pagila

El script 00-prepara-pagila.sh se encargará de preparar la base de datos

Lo que hace es:

- Clona el repositorio oficial de Pagila en /tmp/pagila-src
- Elimina la base de datos pagila si ya existe
- Crea una nueva base de datos llamada pagila
- Carga el esquema pagila-schema.sql
- Carga los datos pagila-insert-data.sql

Para comprobar que la base de datos se cargó correctamente se ejecutó:

```bash
alumne@scolmena:~/Documents/pagila-automatizacion$ sudo -u postgres psql -d pagila -c "\dt"
```

<details>
<summary>Resultado real de la comprobación de tablas</summary>

```text
List of relations
Schema | Name             | Type              | Owner
--------+------------------+-------------------+----------
public | actor            | table             | postgres
public | address          | table             | postgres
public | category         | table             | postgres
public | city             | table             | postgres
public | country          | table             | postgres
public | customer         | table             | postgres
public | film             | table             | postgres
public | film_actor       | table             | postgres
public | film_category    | table             | postgres
public | inventory        | table             | postgres
public | language         | table             | postgres
public | payment          | partitioned table | postgres
public | payment_p2022_01 | table             | postgres
public | payment_p2022_02 | table             | postgres
public | payment_p2022_03 | table             | postgres
public | payment_p2022_04 | table             | postgres
public | payment_p2022_05 | table             | postgres
public | payment_p2022_06 | table             | postgres
public | payment_p2022_07 | table             | postgres
public | rental           | table             | postgres
public | staff            | table             | postgres
public | store            | table             | postgres
(22 rows)
```

</details>

También se comprobó que la tabla film tiene datos:

```bash
alumne@scolmena:/tmp$ sudo -u postgres psql -d pagila -c "SELECT COUNT(*) FROM film;"
```

<details>
<summary>Resultado real del conteo de películas</summary>

```text
count
-------
1000
(1 row)
```

</details>

---

## 5. Roles y usuarios

El script 01-rols.sql crea los roles de grupo y usuarios necesarios

Roles de grupo creados:

- grup_gerencia
- grup_atencio

Usuarios creados:

- manager_user
- staff_user

Asignación realizada:

- manager_user pertenece a grup_gerencia
- staff_user pertenece a grup_atencio

Comando ejecutado:

```bash
alumne@scolmena:/tmp$ sudo -u postgres psql -d pagila -c "\du"
```

<details>
<summary>Resultado real de roles y usuarios</summary>

```text
List of roles
Role name     | Attributes                                                 | Member of
--------------+------------------------------------------------------------+-----------------
grup_atencio  | Cannot login                                               | {}
grup_gerencia | Cannot login                                               | {}
manager_user  |                                                            | {grup_gerencia}
postgres      | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
staff_user    |                                                            | {grup_atencio}
```

</details>

---

## 6. Permisos

El script 02-permisos.sql aplica permisos sobre tablas clave

Tablas principales usadas para la comprobación:

- film
- rental
- inventory

El grupo grup_gerencia tiene permisos de lectura y escritura

El grupo grup_atencio tiene permisos limitados, orientados al personal de atención

Comandos ejecutados:

```bash
alumne@scolmena:/tmp$ sudo -u postgres psql -d pagila -c "\dp film"
alumne@scolmena:/tmp$ sudo -u postgres psql -d pagila -c "\dp rental"
alumne@scolmena:/tmp$ sudo -u postgres psql -d pagila -c "\dp inventory"
```

<details>
<summary>Resultado real de permisos sobre film</summary>

```text
Access privileges
Schema | Name | Type  | Access privileges            | Column privileges          | Policies
--------+------+-------+------------------------------+----------------------------+----------
public | film | table | postgres=arwdDxt/postgres + | film_id:                  +|
       |      |       | grup_gerencia=arwd/postgres | grup_atencio=r/postgres  +|
       |      |       |                              | title:                    +|
       |      |       |                              | grup_atencio=r/postgres  +|
       |      |       |                              | description:              +|
       |      |       |                              | grup_atencio=r/postgres  +|
       |      |       |                              | release_year:             +|
       |      |       |                              | grup_atencio=r/postgres  +|
       |      |       |                              | rental_duration:          +|
       |      |       |                              | grup_atencio=r/postgres   |
(1 row)
```

</details>

<details>
<summary>Resultado real de permisos sobre rental</summary>

```text
Access privileges
Schema | Name   | Type  | Access privileges             | Column privileges          | Policies
--------+--------+-------+-------------------------------+----------------------------+----------
public | rental | table | postgres=arwdDxt/postgres  + | return_date:              +|
       |        |       | grup_gerencia=arwd/postgres+ | grup_atencio=w/postgres  +|
       |        |       | grup_atencio=ar/postgres     | last_update:              +|
       |        |       |                               | grup_atencio=w/postgres   |
(1 row)
```

</details>

<details>
<summary>Resultado real de permisos sobre inventory</summary>

```text
Access privileges
Schema | Name      | Type  | Access privileges             | Column privileges | Policies
--------+-----------+-------+-------------------------------+-------------------+----------
public | inventory | table | postgres=arwdDxt/postgres  + |                   |
       |           |       | grup_gerencia=arwd/postgres+ |                   |
       |           |       | grup_atencio=r/postgres      |                   |
(1 row)
```

</details>

---

## 7. Vista personalizada

El script 03-vistes.sql crea la vista:

```text
vista_recepcio_disponibilitat
```

Esta vista muestra títulos de películas y disponibilidad sin mostrar datos sensibles de la empresa.

Comando ejecutado:

```bash
alumne@scolmena:/tmp$ sudo -u postgres psql -d pagila -c "SELECT * FROM vista_recepcio_disponibilitat LIMIT 10;"
```

<details>
<summary>Resultado real de la vista</summary>

```text
film_id | titol_pelicula   | total_copies | copies_disponibles
--------+------------------+--------------+--------------------
1       | ACADEMY DINOSAUR | 8            | 8
2       | ACE GOLDFINGER   | 3            | 3
3       | ADAPTATION HOLES | 4            | 4
4       | AFFAIR PREJUDICE | 7            | 7
5       | AFRICAN EGG      | 3            | 3
6       | AGENT TRUMAN     | 6            | 6
7       | AIRPLANE SIERRA  | 5            | 5
8       | AIRPORT POLLOCK  | 4            | 4
9       | ALABAMA DEVIL    | 5            | 5
10      | ALADDIN CALENDAR | 7            | 7
(10 rows)
```

</details>

---

## 8. Trigger de integridad

El script 04-triggers.sql crea la función:

```text
fn_validar_cliente_alquiler
```

Y el trigger:

```text
trg_validar_cliente_alquiler
```

El trigger se ejecuta antes de insertar un nuevo registro en rental para impedir que un cliente pueda alquilar una película si tiene deudas pendientes o alquileres no devueltos

Comando ejecutado para comprobar el trigger en la tabla:

```bash
alumne@scolmena:/tmp$ sudo -u postgres psql -d pagila -c "\d rental"
```

<details>
<summary>Resultado real de la tabla rental y sus triggers</summary>

```text
Table "public.rental"
Column       | Type                     | Collation | Nullable | Default
-------------+--------------------------+-----------+----------+-------------------------------------------
rental_id    | integer                  |           | not null | nextval('rental_rental_id_seq'::regclass)
rental_date  | timestamp with time zone |           | not null |
inventory_id | integer                  |           | not null |
customer_id  | integer                  |           | not null |
return_date  | timestamp with time zone |           |          |
staff_id     | integer                  |           | not null |
last_update  | timestamp with time zone |           | not null | now()
Indexes:
    "rental_pkey" PRIMARY KEY, btree (rental_id)
    "idx_fk_inventory_id" btree (inventory_id)
    "idx_unq_rental_rental_date_inventory_id_customer_id" UNIQUE, btree (rental_date, inventory_id, customer_id)
Foreign-key constraints:
    "rental_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT
    "rental_inventory_id_fkey" FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id) ON UPDATE CASCADE ON DELETE RESTRICT
    "rental_staff_id_fkey" FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON UPDATE CASCADE ON DELETE RESTRICT
Triggers:
    last_updated BEFORE UPDATE ON rental FOR EACH ROW EXECUTE FUNCTION last_updated()
    trg_validar_cliente_alquiler BEFORE INSERT ON rental FOR EACH ROW EXECUTE FUNCTION fn_validar_cliente_alquiler()
```

</details>

Comando ejecutado para comprobar la función:

```bash
alumne@scolmena:/tmp$ sudo -u postgres psql -d pagila -c "\df fn_validar_cliente_alquiler"
```

<details>
<summary>Resultado real de la función PL/pgSQL</summary>

```text
List of functions
Schema | Name                        | Result data type | Argument data types | Type
-------+-----------------------------+------------------+---------------------+------
public | fn_validar_cliente_alquiler | trigger          |                     | func
(1 row)
```

</details>

---

## 9. Script de mantenimiento manteniment.sh

El script manteniment.sh realiza tareas de mantenimiento sobre las tablas con más tráfico:

- rental
- payment
- inventory
- film

Las operaciones realizadas son:

- VACUUM ANALYZE
- REINDEX TABLE

Comando ejecutado:

```bash
alumne@scolmena:~/Documents/pagila-automatizacion$ ./manteniment.sh
```

<details>
<summary>Salida real de manteniment.sh</summary>

```text
[INFO] Inicio del mantenimiento de Pagila
[INFO] Ejecutando: VACUUM ANALYZE rental;
VACUUM
[INFO] Ejecutando: VACUUM ANALYZE payment;
VACUUM
[INFO] Ejecutando: VACUUM ANALYZE inventory;
VACUUM
[INFO] Ejecutando: VACUUM ANALYZE film;
VACUUM
[INFO] Ejecutando: REINDEX TABLE rental;
REINDEX
[INFO] Ejecutando: REINDEX TABLE payment;
REINDEX
[INFO] Ejecutando: REINDEX TABLE inventory;
REINDEX
[INFO] Ejecutando: REINDEX TABLE film;
REINDEX
[OK] Mantenimiento finalizado correctamente
[INFO] Log guardado en /home/alumne/Documents/pagila-automatizacion/manteniment-pagila.log
```

</details>

---

## 10. Logs generados

Durante la práctica se generaron los siguientes logs:

```text
configuracio-pagila.log
manteniment-pagila.log
```

configuracio-pagila.log guarda la salida del proceso de instalación y configuración

manteniment-pagila.log guarda la salida del script de mantenimiento

