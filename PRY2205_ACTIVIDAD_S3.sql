/* ==================================================================
   PRY2205 - Consulta de Bases de Datos
   Actividad Sumativa Semana 3: "Aplicando funciones de agrupación"
   Caso ASOCIADOS (arriendo de propiedades)
   Autora: Consuelo Martínez
   Usuario: PRY2205_S3  |  Conexión: PRY2205_ACTIVIDAD_S3

   Ejecución: usar "Run Script" (F5) en cada caso. Las variables de
   sustitución se ingresan como números, sin puntos ni comillas.
   ================================================================== */


/* ============================================================
   CASO 1: Análisis de Propiedades
   Reglas:
   - Resumen por tipo: cantidad, arriendo máximo, promedio
     (redondeado a entero) y arriendo mínimo.
   - Clasificación por arriendo máximo del tipo: hasta 1.000.000
     = ESTÁNDAR; sobre 1.000.000 = PREMIUM.
   - Solo tipos cuyo total de gasto común supera el monto
     ingresado (variable VALOR_TOTAL_GASTO_COMUN).
   - Orden: total de gasto común, descendente.
   ============================================================ */
SELECT id_tipo_propiedad                                                      AS "TIPO",
       COUNT(*)                                                               AS "TOTAL_PROPIEDADES",
       LPAD(TO_CHAR(MAX(valor_arriendo), 'FM$9G999G999'), 13)                 AS "MAX_ARRIENDO",
       LPAD(TO_CHAR(ROUND(AVG(valor_arriendo)), 'FM$9G999G999'), 18)          AS "PROMEDIO_ARRIENDO",
       LPAD(TO_CHAR(MIN(valor_arriendo), 'FM$9G999G999'), 13)                 AS "MIN_ARRIENDO",
       CASE
           WHEN MAX(valor_arriendo) <= 1000000 THEN 'ESTÁNDAR'
           ELSE 'PREMIUM'
       END                                                                    AS "CLASIFICACION",
       LPAD(TO_CHAR(SUM(NVL(valor_gasto_comun, 0)), 'FM$9G999G999'), 21)      AS "TOTAL_GASTOS_COMUNES"
FROM propiedad
GROUP BY id_tipo_propiedad
-- HAVING filtra grupos (WHERE no admite funciones de grupo)
HAVING SUM(NVL(valor_gasto_comun, 0)) > &VALOR_TOTAL_GASTO_COMUN
-- Se ordena por el valor numérico, no por el alias formateado (texto)
ORDER BY SUM(NVL(valor_gasto_comun, 0)) DESC;


/* ============================================================
   CASO 2: Análisis de antigüedad de empleados
   Reglas:
   - Ejecutivos de Arriendo (categoría 3) con más de 5 años de
     antigüedad, que no pertenezcan a la sucursal ingresada
     (variable CODIGO_SUCURSAL).
   - Nivel de sueldo: superior a 2.000.000 = ALTO; en otro
     caso = MEDIO.
   - Bono por años de servicio: 5 a 10 = 5%; 11 a 20 = 10%;
     más de 20 = 15% del sueldo (redondeado a entero).
   - Orden: sueldo descendente.
   ============================================================ */
SELECT nombre_emp || ' ' || appaterno_emp                                     AS "Nombre Empleado",
       LPAD(TO_CHAR(sueldo_emp, 'FM$9G999G999'), 19)                          AS "Sueldo con Formato",
       CASE
           WHEN sueldo_emp > 2000000 THEN 'ALTO'
           ELSE 'MEDIO'
       END                                                                    AS "Clasificación Sueldo",
       TO_CHAR(TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12))               AS "Años Antigüedad",
       CASE
           WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) > 20
               THEN 'Corresponde bono 15%:' || TO_CHAR(ROUND(sueldo_emp * 0.15), '$999G999G999')
           WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) >= 11
               THEN 'Corresponde bono 10%:' || TO_CHAR(ROUND(sueldo_emp * 0.10), '$999G999G999')
           ELSE     'Corresponde bono  5%:' || TO_CHAR(ROUND(sueldo_emp * 0.05), '$999G999G999')
       END                                                                    AS "BONO"
FROM empleado
WHERE id_categoria_emp = 3
  AND id_sucursal <> &CODIGO_SUCURSAL
  -- WHERE no puede usar el alias del SELECT: se repite la expresión
  AND MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12 > 5
ORDER BY sueldo_emp DESC;


/* ============================================================
   CASO 3: Lista de clientes
   Reglas:
   - Clasificación por renta: PREMIUM desde 1.000.000; ALTA desde
     600.000; MEDIA desde 300.000; BAJA bajo 300.000.
   - Se cuenta la cantidad de clientes y se promedia la renta por
     clasificación (redondeada a entero).
   - Solo grupos con renta promedio sobre 200.000.
   - Teléfono: un cliente tiene teléfono si celular_cli no es
     NULL (fonofijo_cli es NOT NULL en el modelo). Se muestra
     "sin Teléfono" solo si TODOS los del grupo carecen de celular.
   ============================================================ */
SELECT CASE
           WHEN renta_cli >= 1000000 THEN 'PREMIUM'
           WHEN renta_cli >= 600000  THEN 'ALTA'
           WHEN renta_cli >= 300000  THEN 'MEDIA'
           ELSE 'BAJA'
       END                                                                    AS "CLASIFICACION_RENTA",
       COUNT(*)                                                               AS "CANTIDAD_CLIENTES",
       LPAD(TO_CHAR(ROUND(AVG(renta_cli)), 'FM$9G999G999'), 15)               AS "RENTA_PROMEDIO",
       CASE
           WHEN COUNT(celular_cli) = 0 THEN 'Clientes sin Teléfono'
           ELSE 'Clientes con Teléfono'
       END                                                                    AS "ESTADO_TELEFONO"
FROM cliente
-- El GROUP BY no acepta alias: se repite la expresión CASE completa
GROUP BY CASE
             WHEN renta_cli >= 1000000 THEN 'PREMIUM'
             WHEN renta_cli >= 600000  THEN 'ALTA'
             WHEN renta_cli >= 300000  THEN 'MEDIA'
             ELSE 'BAJA'
         END
-- El promedio de renta solo existe por grupo: va en HAVING
HAVING AVG(renta_cli) > 200000;
