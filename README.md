# Analítica de Recursos Humanos y Distribución Demográfica Global

## Descripción Ejecutiva
Este repositorio reúne un conjunto estructurado de 32 consultas analíticas en MySQL 8.0 (DQL) diseñadas para la extracción de métricas clave sobre bases de datos relacionales corporativas (`employees`) y geográficas (`world`).

El proyecto responde a interrogantes estratégicas en dos áreas de negocio: optimización de costos en la gestión del talento humano y evaluación demográfica para expansión de mercado.

---

## Áreas de Análisis

### 1. Gestión de Recursos Humanos (HR Analytics)
* **Estructura Salarial:** Cálculo de masa salarial total, sueldos promedios, mínimos y máximos por área operativa.
* **Distribución de Plantilla y Paridad:** Evaluación de headcount por departamento e indicadores de equidad mediante agregaciones condicionales.
* **Movilidad y Retención:** Métricas de antigüedad laboral y seguimiento histórico de cambios de puesto.

### 2. Inteligencia de Mercado (Global Demographics)
* **Densidad Poblacional:** Análisis de concentración demográfica (habitantes por kilómetro cuadrado) a nivel país y continente.
* **Cobertura Idiomática:** Evaluación de penetración de idiomas oficiales para análisis de localización regional.
* **Concentración Urbana:** Medición de población metropolitana en comparación con totales nacionales.

---

## Estructura del Repositorio

```text
mysql-hr-global-workforce-analytics/
├── 01_hr_and_global_analytics.sql   -- Script con 32 consultas de negocio
└── README.md                        -- Documentación del proyecto
