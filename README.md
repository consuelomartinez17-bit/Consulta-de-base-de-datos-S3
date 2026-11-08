# Consulta de Bases de Datos - Actividad Sumativa Semana 3

**Asignatura:** Consulta de Bases de Datos (PRY2205), Duoc UC
**Actividad:** Aplicando funciones de agrupación
**Autora:** Consuelo Martínez
**Motor de base de datos:** Oracle (SQL Developer)

## Descripción

Script SQL con la solución de tres casos de información para la empresa ASOCIADOS, dedicada al arriendo de propiedades en la región metropolitana. Los casos usan funciones de una fila, funciones de grupo y cláusulas de agrupación, restricción y ordenamiento.

## Contenido

- `PRY2205_ACTIVIDAD_S3.sql`: script con los tres casos, comentado.

## Casos desarrollados

| Caso | Descripción | Variable de sustitución |
|------|-------------|--------------------------|
| 1 | Análisis de propiedades: resumen por tipo de propiedad con clasificación del arriendo y total de gasto común | VALOR_TOTAL_GASTO_COMUN |
| 2 | Análisis de antigüedad de empleados: clasificación de sueldo y bono de antigüedad | CODIGO_SUCURSAL |
| 3 | Lista de clientes: clasificación por renta, cantidad, promedio y estado de teléfono | No aplica |

## Conceptos aplicados

- Funciones de grupo: COUNT, SUM, AVG, MAX, MIN
- Agrupación de datos: GROUP BY
- Restricción de grupos: HAVING
- Funciones de una fila: TO_CHAR, ROUND, TRUNC, MONTHS_BETWEEN, NVL, LPAD
- Expresiones condicionales: CASE
- Ordenamiento: ORDER BY
- Variables de sustitución

## Cómo ejecutarlo

1. Conectarse a Oracle con el usuario PRY2205_S3.
2. Ejecutar el script que crea y pobla las tablas del modelo (entregado en la actividad).
3. Abrir `PRY2205_ACTIVIDAD_S3.sql` en SQL Developer.
4. Ejecutar cada caso con **Run Script (F5)**. Cuando se solicite una variable de sustitución, ingresar el valor numérico sin puntos ni comillas.
