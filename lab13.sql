/*
 * 			 parte 1
 */

-- 			inciso a
CREATE TABLE ventasTiempo
AS
	(SELECT
	invoiceid,
	billingcity as ciudad,
	billingcountry as pais,
	SUM(invoice.total) AS total,
    EXTRACT (YEAR FROM invoicedate) ANIO,
    EXTRACT (QUARTER FROM invoicedate) CUARTO,
    EXTRACT (MONTH FROM invoicedate) MES,
    EXTRACT (WEEK FROM invoicedate) SEMANA
	FROM
	    invoice
	GROUP BY
	     cube(
			invoiceid,
			billingcity,
			billingcountry, 
		    EXTRACT (YEAR FROM invoicedate),
		    EXTRACT (QUARTER FROM invoicedate),
		    EXTRACT (MONTH FROM invoicedate),
		    EXTRACT (WEEK FROM invoicedate)
	    )
	ORDER BY total);

SELECT * FROM VENTASTIEMPO

DROP TABLE VENTASTIEMPO
-- 				inciso b


SELECT * 
FROM ventasTiempo vt
JOIN invoiceline il on vt.invoiceid = il.invoiceid 

-- 				inciso c

CREATE MATERIALIZED VIEW vistaVentas 
AS (
	SELECT total, pais, ciudad, anio, cuarto, mes, semana, track.genreid as genero, track.mediatypeid as mediaType
	FROM ventasTiempo vt
	JOIN invoiceline il on vt.invoiceid = il.invoiceid
	JOIN track ON il.trackid = track.trackid
)





Select * from vistaVentas


--inciso d.i -> mpeg
select count(vistaVentas.mediatype), vistaVentas.mediatype
from vistaVentas
group by vistaVentas.mediatype
order by count(vistaVentas.mediatype) desc
limit 1;



--	inciso d.ii -> rock mas vendido
SELECT genero, COUNT(*) as Conteo
FROM vistaVentas
WHERE vistaVentas.anio = 2013
GROUP BY genero
ORDER BY COUNT(*) DESC;

--	inciso d. iii
SELECT semana, sum(total)
FROM vistaVentas
WHERE pais is null and ciudad is null and anio is null and cuarto is null and mes is null
GROUP BY semana
ORDER BY semana

--	inciso d. iv -> mejor es null, segundo mejor es 2.
SELECT cuarto, SUM(total) AS totalCuarto 
FROM vistaVentas
GROUP BY cuarto
ORDER BY totalCuarto DESC

-- 			inciso d.v

--de este query podemos observar que las ventas han comenzado a decaer..
SELECT anio, sum(total) as ventaAnual
from ventastiempo
group by anio
order by  anio DESC

-- de este query podemos ver donde podemos impulsar la campaña. 
-- propuesta: Canada y Francia por ser mercados similares con capacidad economica.
SELECT pais, sum(total) as ventaAnual
from ventastiempo
group by pais
order by ventaAnual DESC

--encontramos los generos mas vendidos en Francia: 1,4,7 (Rock, Punk y Latin)
select pais, genero, count(*) as conteo
from vistaventas
where pais = 'France'
group by genero, pais
order by conteo DESC
limit 3

--cuarto menos vendido.. el 3
select pais, cuarto, count(*) as conteo
from vistaventas
where pais = 'France' 
group by cuarto, pais
order by conteo DESC


--generos mas vendidos en canada: 1, 7, 3 (Rock, Latin y Metal)
select pais, genero, count(*) as conteo
from vistaventas
where pais = 'Canada'
group by genero, pais
order by conteo DESC
limit 3
--cuarto menos vendido.. el 4
select pais, cuarto, count(*) as conteo
from vistaventas
where pais = 'France' 
group by cuarto, pais
order by conteo DESC

/*
creemos que se puede hacer una estrategia de marketing debido a que se ha visto un declive en las ventas, sumado a lo anterior. los paises emergentes por hacer dicha 
campana seria Canada y Francia a los estilos de musica mas populares en respectivos paises. Siendo, Francia: Rock, Punk, Latin y en Canada: Rock, Latin y Metal.
La campana debera hacerse en el Q4 en caso de Canada, donde hay menos ventas y Francia en Q2 y Q3 donde las ventas llegan a su minimo
*/
