# Análisis del Rendimiento de Ventas — AdventureWorks

Proyecto de análisis de datos comerciales desarrollado con **Microsoft SQL Server y Power BI**, utilizando la base de datos AdventureWorks2025. El objetivo es transformar datos transaccionales en indicadores que permitan analizar el rendimiento de ventas, la contribución de los productos y el comportamiento de los clientes.

## 1. Problema de negocio

Los registros de ventas contienen información sobre pedidos, clientes y productos, pero requieren preparación y análisis para convertirse en información útil para la toma de decisiones.

Este proyecto busca responder la siguiente pregunta:

**¿Cómo se distribuyen las ventas entre los clientes y productos de AdventureWorks, y qué patrones comerciales pueden identificarse a partir de los datos?**

## 2. Preparación y transformación de datos

### SQL Server

Se exploró la estructura relacional de AdventureWorks2025 y se prepararon los datos para su análisis mediante consultas SQL.

Principales actividades:

- Exploración de tablas y relaciones relevantes.
- Integración de pedidos y detalles de ventas mediante `JOIN`.
- Uso de agregaciones, subconsultas, expresiones condicionales y CTE.
- Construcción de una tabla de hechos y tablas de dimensiones.
- Definición de métricas según la granularidad de los datos, evitando duplicar los importes de los pedidos al integrar sus líneas de detalle.

## 3. Modelado de datos

Se construyó un modelo dimensional en Power BI con una tabla de hechos central y cuatro dimensiones.

| Tabla | Descripción |
|---|---|
| `FactVentas` | Detalles de ventas, cantidades, precios, descuentos e importes por línea |
| `DimFecha` | Atributos del calendario para el análisis temporal |
| `DimProducto` | Productos, categorías y subcategorías |
| `DimCliente` | Información y segmentación de clientes |
| `DimTerritorio` | Territorios y atributos geográficos |

Esta estructura permite analizar las ventas desde distintas perspectivas y facilita la interacción entre las visualizaciones mediante filtros.

## 4. Indicadores y medidas — DAX

Se desarrollaron medidas para calcular indicadores clave del rendimiento comercial:

- Ventas totales.
- Número de pedidos.
- Unidades vendidas.
- Ticket promedio por pedido.
- Rendimiento comercial de clientes y productos.
- Clasificación de los principales clientes y tiendas mediante lógica Top N.

Las medidas permiten comparar resultados y explorar los datos mediante filtros y segmentaciones interactivas.

## 5. Dashboard en Power BI

El reporte está organizado en cuatro páginas analíticas. Actualmente, se han desarrollado las páginas de resumen ejecutivo, productos y clientes. El análisis temporal se encuentra pendiente.

### 5.1. Resumen ejecutivo

Presenta una visión general del rendimiento comercial mediante indicadores clave y visualizaciones que permiten identificar los principales resultados de ventas.

![Dashboard de resumen ejecutivo](images/01-resumen-ejecutivo.png)

### 5.2. Análisis temporal

**Pendiente de desarrollo.**

Se orientará al análisis de la evolución de las ventas por mes y trimestre, así como a la identificación de tendencias y variaciones entre periodos.

### 5.3. Análisis de productos

Permite examinar el rendimiento comercial de los productos, identificar los principales contribuyentes a las ventas y comparar resultados entre productos y categorías.

![Dashboard de análisis de productos](images/03-analisis-productos.png)

### 5.4. Análisis de clientes

Permite explorar la contribución de los clientes a las ventas, identificar los principales clientes y tiendas, y comparar su rendimiento comercial.

![Dashboard de análisis de clientes](images/04-analisis-clientes.png)

## 6. Herramientas utilizadas

- **Microsoft SQL Server:** exploración, integración, transformación y análisis de datos.
- **Power BI:** modelado dimensional y visualización interactiva.
- **DAX:** cálculo de indicadores, clasificación Top N y medidas analíticas.
- **Git y GitHub:** control de versiones y documentación del proyecto.

## 7. Estado del proyecto

Se ha desarrollado la estructura dimensional y se han implementado tres de las cuatro páginas previstas en Power BI.

Las siguientes etapas contemplan completar el análisis temporal, validar los indicadores del reporte frente a los resultados de SQL Server y documentar los principales hallazgos comerciales.

## 8. Estructura del repositorio

```text
sales-performance-analysis/
├── sql/
│   ├── 01_exploracion_datos.sql
│   ├── 02_tabla_hechos.sql
│   ├── 03_dimensiones.sql
│   └── 04_analisis_clientes.sql
├── images/
│   ├── 01-resumen-ejecutivo.png
│   ├── 03-analisis-productos.png
│   └── 04-analisis-clientes.png
├── powerbi/
│   └── sales-performance-analysis.pbix
└── README.md
```

*La estructura es referencial. Los nombres de carpetas y archivos deben ajustarse al contenido real del repositorio.*

## 9. Resultado esperado

Desarrollar una solución de análisis comercial que integre preparación de datos en SQL Server, modelado dimensional, medidas DAX y visualización interactiva en Power BI.

El proyecto busca convertir datos transaccionales en indicadores consistentes y facilitar el análisis del rendimiento de ventas desde las perspectivas de clientes, productos y periodos.
