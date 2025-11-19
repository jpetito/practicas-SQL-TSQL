-- VENTAS Y COMPRAS POR SUCURSAL EN BD TRANSACCIONAL
SELECT 
    Sucursal_NroSucursal,
    YEAR(Compra_Fecha) AS anio,
    MONTH(Compra_Fecha) AS Mes,
    COUNT(*) AS Cantidad_Compras,
    SUM(Compra_Total) AS Total_Compras
FROM BDGRUPO.Compra
GROUP BY Sucursal_NroSucursal, YEAR(Compra_Fecha), MONTH(Compra_Fecha)
ORDER BY Sucursal_NroSucursal, anio, Mes;

SELECT 
    Factura_Sucursal AS Sucursal_NroSucursal,
    YEAR(Factura_Fecha) AS anio,
    MONTH(Factura_Fecha) AS Mes,
    COUNT(*) AS Cantidad_Ventas,
    SUM(Factura_Total) AS Total_Ventas
FROM BDGRUPO.Factura
GROUP BY Factura_Sucursal, YEAR(Factura_Fecha), MONTH(Factura_Fecha)
ORDER BY Factura_Sucursal, anio, Mes;

-- VENTAS Y COMPRAS POR SUCURSAL EN BD BI

SELECT 
    b.Sucursal_ID,
    SUM(b.Total) AS Total_Compras,
    COUNT(DISTINCT b.Compra_Numero) AS Cantidad_Compras,
    b.Tiempo_ID,
    d.Mes,
    d.anio
FROM BDGRUPOBI.HechoCompras b
JOIN BDGRUPOBI.DimTiempo d on b.tiempo_Id = d.Tiempo_ID
GROUP BY b.Sucursal_ID, b.Tiempo_ID, d.Mes, d.anio
ORDER BY d.anio, d.Mes

SELECT 
    v.Sucursal_ID,
    SUM(v.Total) AS Total_Ventas,
    COUNT(DISTINCT v.Factura_Numero) AS Cantidad_Ventas,
    v.Tiempo_ID,
    d.Mes,
    d.Anio
FROM BDGRUPOBI.HechoVentas v
JOIN BDGRUPOBI.DimTiempo d ON v.Tiempo_ID = d.Tiempo_ID
GROUP BY v.Sucursal_ID, v.Tiempo_ID, d.Mes, d.Anio
ORDER BY d.Anio, d.Mes

-- CONSULTAR SI HAY PEDIDOS CON ESTADO PENDIENTE
SELECT
    p.Pedido_Numero,
    p.Pedido_Estado
    FROM  BDGRUPO.Pedido P
WHERE p.Pedido_Estado = 'Cancelado';

select * from bdgrupo.DetallePedido


--consulta que me de Cantidad de pedidos registrados por turno (8 a 14) y (14 a 20), en la sucursal 37 según el mes de cada año.  
SELECT
    YEAR(Pedido_Fecha) AS Anio,
    MONTH(Pedido_Fecha) AS Mes,
    CASE 
        WHEN CAST(FORMAT(Pedido_Fecha, 'HH') AS INT) BETWEEN 8 AND 13 THEN 'Turno Mañana (8-14)'
        WHEN CAST(FORMAT(Pedido_Fecha, 'HH') AS INT) BETWEEN 14 AND 19 THEN 'Turno Tarde (14-20)'
        ELSE 'Fuera de turno'
    END AS Turno,
    COUNT(*) AS Cantidad_Pedidos
FROM BDGRUPO.Pedido
WHERE Pedido_Sucursal = 37
  AND Pedido_Fecha IS NOT NULL
  AND CAST(FORMAT(Pedido_Fecha, 'HH') AS INT) BETWEEN 8 AND 19
GROUP BY 
    YEAR(Pedido_Fecha),
    MONTH(Pedido_Fecha),
    CASE 
        WHEN CAST(FORMAT(Pedido_Fecha, 'HH') AS INT) BETWEEN 8 AND 13 THEN 'Turno Mañana (8-14)'
        WHEN CAST(FORMAT(Pedido_Fecha, 'HH') AS INT) BETWEEN 14 AND 19 THEN 'Turno Tarde (14-20)'
        ELSE 'Fuera de turno'
    END
ORDER BY Anio, Mes, Turno;

--Promedio de Compras: importe promedio de compras por mes. 
SELECT
    YEAR(Compra_Fecha) AS Anio,
    MONTH(Compra_Fecha) AS Mes,
    AVG(Compra_Total) AS Importe_Promedio_Compras,
    COUNT(*) AS Cantidad_Compras
FROM BDGRUPO.Compra
GROUP BY
    YEAR(Compra_Fecha),
    MONTH(Compra_Fecha)
ORDER BY
    Anio,
    Mes;

--Total compras transaccional y BI
SELECT 
    sum(c.Compra_Total),
    YEAR(c.Compra_Fecha)
    from BDGRUPO.Compra c
group by YEAR(c.Compra_Fecha)

SELECT
    SUM(b.Total) AS Total_Compras_BI,
    d.Anio
    FROM BDGRUPOBI.HechoCompras b
    JOIN BDGRUPOBI.DimTiempo d ON b.Tiempo_ID = d.Tiempo_ID
    GROUP BY d.Anio

Select * 
from bdgrupo.Pedido p
where p.Pedido_Sucursal = 37
and p.Pedido_Estado = 'entregado'
and p.Pedido_Numero = '56360536'


select * from bdgrupo.Factura f
join bdgrupo.FacturaDetalle df on f.Factura_Numero = df.Factura_Numero
where f.Factura_Sucursal = 37
and df.Detalle_Factura_Pedido_ID = '56360536'

select F.Factura_Fecha, P.Pedido_Fecha from BDGRUPO.FacturaDetalle
join BDGRUPO.DetallePedido dp on FacturaDetalle.Detalle_Factura_Pedido_ID = dp.Detalle_Pedido_ID
JOIN BDGRUPO.Factura f ON FacturaDetalle.Factura_Numero = f.Factura_Numero
JOIN BDGRUPO.Pedido p ON dp.Pedido_Numero = p.Pedido_Numero
where dp.Pedido_Numero = '56360536'
order by Detalle_Factura_Pedido_ID
