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



-- inciso d. ii
SELECT genero, COUNT(*) as Conteo
FROM vistaVentas
WHERE vistaVentas.anio = 2013;
GROUP BY genero, COUNT(*)
ORDER BY COUNT(*)

Select * from vistaVentas


--inciso d.i
select count(vistaVentas.mediatype), vistaVentas.mediatype
from vistaVentas
group by vistaVentas.mediatype
order by count(vistaVentas.mediatype) desc
limit 1;

--inciso d.ii
SELECT vistaventas.genero, COUNT(*) as Conteo
FROM vistaVentas
WHERE vistaVentas.anio = 2013
GROUP BY vistaventas.genero
ORDER BY COUNT(*) DESC

-- 				inciso d. iii

SELECT semana, sum(total)
FROM vistaVentas
WHERE pais is null and ciudad is null and anio is null and cuarto is null and mes is null
GROUP BY semana
ORDER BY semana

-- 			inciso d.v

