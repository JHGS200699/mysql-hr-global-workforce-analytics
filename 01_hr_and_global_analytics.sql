-- ============================================================================
-- PROYECTO: HR Analytics & Global Demographics (32 Consultas de Negocio)
-- ARCHIVO: 01_hr_and_global_analytics.sql
-- ENTORNO: MySQL 8.0
-- AUTOR: José Humberto García Sánchez
-- ============================================================================

-- ============================================================================
-- MÓDULO 1: HR ANALYTICS & WORKFORCE MANAGEMENT (Base de datos: employees)
-- ============================================================================

USE employees;

-- 1. Catálogo completo de departamentos ordenados alfabéticamente
SELECT dept_no, dept_name 
FROM departments 
ORDER BY dept_name ASC;

-- 2. Conteo total de colaboradores registrados en el sistema histórico
SELECT COUNT(*) AS total_empleados_historico 
FROM employees;

-- 3. Distribución general de plantilla por género
SELECT gender AS genero, COUNT(*) AS total 
FROM employees 
GROUP BY gender;

-- 4. Búsqueda de empleados contratados en el año 1995
SELECT emp_no, first_name, last_name, hire_date 
FROM employees 
WHERE hire_date BETWEEN '1995-01-01' AND '1995-12-31'
ORDER BY hire_date ASC;

-- 5. Búsqueda de patronímica: Empleadas cuyo apellido inicia con 'S'
SELECT emp_no, first_name, last_name, gender 
FROM employees 
WHERE last_name LIKE 'S%' AND gender = 'F'
LIMIT 15;

-- 6. Los 10 empleados con mayor antigüedad en la organización
SELECT emp_no, first_name, last_name, hire_date 
FROM employees 
ORDER BY hire_date ASC 
LIMIT 10;

-- 7. Promedio salarial global de los contratos activos
SELECT ROUND(AVG(salary), 2) AS salario_promedio_actual 
FROM salaries 
WHERE to_date = '9999-01-01';

-- 8. Salario máximo y mínimo pagado en contratos activos
SELECT MIN(salary) AS salario_minimo, MAX(salary) AS salario_maximo 
FROM salaries 
WHERE to_date = '9999-01-01';

-- 9. Nómina actual detallada: Empleado, departamento y salario vigente
SELECT 
    e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS empleado,
    d.dept_name AS departamento,
    s.salary AS salario_actual
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01' AND de.to_date = '9999-01-01'
ORDER BY s.salary DESC
LIMIT 20;

-- 10. Headcount de colaboradores activos agrupado por departamento
SELECT 
    d.dept_name AS departamento,
    COUNT(e.emp_no) AS total_colaboradores
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY total_colaboradores DESC;

-- 11. Análisis presupuestal: Masa salarial total y promedio por departamento
SELECT 
    d.dept_name AS departamento,
    SUM(s.salary) AS masa_salarial_total,
    ROUND(AVG(s.salary), 2) AS salario_promedio
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01' AND de.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY masa_salarial_total DESC;

-- 12. Filtro ejecutivo: Departamentos con salario promedio superior a $65,000 USD
SELECT 
    d.dept_name AS departamento,
    ROUND(AVG(s.salary), 2) AS salario_promedio
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01' AND de.to_date = '9999-01-01'
GROUP BY d.dept_name
HAVING AVG(s.salary) > 65000
ORDER BY salario_promedio DESC;

-- 13. Subconsulta: Colaboradores cuyo salario supera el promedio general activo
SELECT 
    e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS empleado,
    s.salary AS salario
FROM employees e
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01'
  AND s.salary > (SELECT AVG(salary) FROM salaries WHERE to_date = '9999-01-01')
ORDER BY s.salary DESC
LIMIT 15;

-- 14. Matriz de género por área mediante agregación condicional (CASE WHEN)
SELECT 
    d.dept_name AS departamento,
    COUNT(e.emp_no) AS total,
    SUM(CASE WHEN e.gender = 'F' THEN 1 ELSE 0 END) AS mujeres,
    SUM(CASE WHEN e.gender = 'M' THEN 1 ELSE 0 END) AS hombres
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- 15. Movilidad interna: Empleados que han cambiado de puesto más de una vez
SELECT 
    e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS empleado,
    COUNT(t.title) AS total_puestos
FROM employees e
INNER JOIN titles t ON e.emp_no = t.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name
HAVING COUNT(t.title) > 1
ORDER BY total_puestos DESC
LIMIT 15;

-- 16. Promedio salarial y rango de compensación por título/puesto
SELECT 
    t.title AS puesto,
    COUNT(e.emp_no) AS ocupantes,
    ROUND(AVG(s.salary), 2) AS salario_promedio
FROM employees e
INNER JOIN titles t ON e.emp_no = t.emp_no
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01' AND t.to_date = '9999-01-01'
GROUP BY t.title
ORDER BY salario_promedio DESC;

-- 17. Filtrado múltiple: Empleados pertenecientes a 'Sales' o 'Marketing'
SELECT 
    e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS empleado,
    d.dept_name AS departamento
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01' AND d.dept_name IN ('Sales', 'Marketing')
LIMIT 20;

-- 18. Clasificación de antigüedad por rangos mediante CASE WHEN
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) >= 30 THEN 'Senior (+30 años)'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 25 AND 29 THEN 'Intermedio (25-29 años)'
        ELSE 'Junior (<25 años)'
    END AS categoria_antiguedad,
    COUNT(*) AS total_empleados
FROM employees
GROUP BY categoria_antiguedad;


-- ============================================================================
-- MÓDULO 2: GLOBAL DEMOGRAPHICS & MARKET INTELLIGENCE (Base de datos: world)
-- ============================================================================

USE world;

-- 19. Catálogo de continentes únicos en la base de datos
SELECT DISTINCT Continent 
FROM country 
ORDER BY Continent ASC;

-- 20. Top 10 países con mayor población en el mundo
SELECT Name AS pais, Continent AS continente, Population AS poblacion 
FROM country 
ORDER BY Population DESC 
LIMIT 10;

-- 21. Países de América del Sur con población superior a 20 millones
SELECT Name AS pais, Population AS poblacion 
FROM country 
WHERE Continent = 'South America' AND Population > 20000000
ORDER BY Population DESC;

-- 22. Esperanza de vida promedio agrupada por continente
SELECT 
    Continent AS continente,
    ROUND(AVG(LifeExpectancy), 2) AS esperanza_vida_promedio
FROM country
WHERE LifeExpectancy IS NOT NULL
GROUP BY Continent
ORDER BY esperanza_vida_promedio DESC;

-- 23. Cálculo de densidad poblacional por país (Habitantes por Km²)
SELECT 
    Name AS pais,
    Population AS poblacion,
    SurfaceArea AS superficie_km2,
    ROUND(Population / SurfaceArea, 2) AS densidad_hab_km2
FROM country
WHERE SurfaceArea > 0
ORDER BY densidad_hab_km2 DESC
LIMIT 15;

-- 24. Países con alta densidad urbana (>500 hab/km²)
SELECT Name AS pais, Population AS poblacion, SurfaceArea AS superficie 
FROM country 
WHERE SurfaceArea > 0 AND (Population / SurfaceArea) > 500
ORDER BY Population DESC;

-- 25. Total de ciudades registradas por país
SELECT 
    co.Name AS pais,
    COUNT(ci.ID) AS total_ciudades
FROM country co
INNER JOIN city ci ON co.Code = ci.CountryCode
GROUP BY co.Name
ORDER BY total_ciudades DESC
LIMIT 15;

-- 26. Países que cuentan con más de 30 ciudades en el registro
SELECT 
    co.Name AS pais,
    COUNT(ci.ID) AS total_ciudades
FROM country co
INNER JOIN city ci ON co.Code = ci.CountryCode
GROUP BY co.Name
HAVING COUNT(ci.ID) > 30
ORDER BY total_ciudades DESC;

-- 27. Países y sus idiomas oficiales registrados
SELECT 
    c.Name AS pais,
    cl.Language AS idioma_oficial,
    cl.Percentage AS porcentaje_hablantes
FROM country c
INNER JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T'
ORDER BY c.Name ASC
LIMIT 20;

-- 28. Presencia del idioma español ('Spanish') a nivel global
SELECT 
    c.Name AS pais,
    cl.IsOfficial AS es_oficial,
    cl.Percentage AS porcentaje_hablantes
FROM country c
INNER JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.Language = 'Spanish'
ORDER BY cl.Percentage DESC;

-- 29. Top 10 ciudades más pobladas del mundo con su país correspondiente
SELECT 
    ci.Name AS ciudad,
    co.Name AS pais,
    ci.Population AS poblacion_ciudad
FROM city ci
INNER JOIN country co ON ci.CountryCode = co.Code
ORDER BY ci.Population DESC
LIMIT 10;

-- 30. Concentración urbana: Suma de población de ciudades por país
SELECT 
    co.Name AS pais,
    co.Population AS poblacion_nacional,
    SUM(ci.Population) AS poblacion_urbana_registrada
FROM country co
INNER JOIN city ci ON co.Code = ci.CountryCode
GROUP BY co.Name, co.Population
ORDER BY poblacion_urbana_registrada DESC
LIMIT 15;

-- 31. Producto Nacional Bruto (PNB/GNP) total acumulado por continente
SELECT 
    Continent AS continente,
    ROUND(SUM(GNP), 2) AS gnp_total
FROM country
WHERE GNP IS NOT NULL
GROUP BY Continent
ORDER BY gnp_total DESC;

-- 32. Ciudades capitales del mundo con su población
SELECT 
    co.Name AS pais,
    ci.Name AS capital,
    ci.Population AS poblacion_capital
FROM country co
INNER JOIN city ci ON co.Capital = ci.ID
ORDER BY ci.Population DESC
LIMIT 15;