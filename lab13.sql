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
/*
Debido a que existe una brecha de ventas de 3072 unidades entre musica 
Rock y Jazz, que son el primer y segundo genero mas vendido respectivamente,
creemos oportuno enfocar una estrategia de marketing hacia el genero Jazz. 

Debido a que podemos conocer las semanas y quarters donde existen menor cantidad de ventas, siendo la semana 43
respectiva al quarter 4. Podemos intensificar una campaña de marketing a este genero, en esta semana en concreto.
*/
