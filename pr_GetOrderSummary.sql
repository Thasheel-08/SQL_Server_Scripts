CREATE PROCEDURE pr_GetOrderSummary 
@StartDate datetime, 
@EndDate datetime, 
@EmployeeID int = NULL, 
@CustomerID varchar(50) = NULL
AS 
BEGIN
Select  
o.OrderID,
ei.TitleOfCourtesy + ' ' + ei.FirstName + ' ' + ei.LastName AS 'EmployeeFullName',
sid.CompanyName as 'Shipper CompanyName',
cid.CompanyName as 'Customer CompanyName',
CONVERT(VARCHAR(11), o.OrderDate, 106) AS 'Date',
o.Freight,
od.Quantity,
(od.UnitPrice * od.Quantity) * (1 - od.Discount) AS 'TotalOrderValue'

FROM Orders o
INNER Join Shippers sid 
on o.ShipVia = sid.ShipperID

INNER Join Employees  ei
on o.EmployeeID = ei.EmployeeID

INNER Join Customers cid
on o.CustomerID = cid.CustomerID

INNER Join [Order Details] od
on o.OrderID = od.OrderID

WHERE
o.OrderDate >= @StartDate and 
o.OrderDate <= @EndDate and
(@EmployeeID is null or o.EmployeeID = @EmployeeID) AND
(@CustomerID is null OR o.CustomerID = @CustomerID)

Order by Date, 
EmployeeFullName, 
[Customer CompanyName], 
[Shipper CompanyName];

END


exec pr_GetOrderSummary @StartDate='1 Jan 1996', @EndDate='31 Aug 1996', @EmployeeID = NULL , @CustomerID = NULL

exec pr_GetOrderSummary @StartDate='1 Jan 1996', @EndDate='31 Aug 1996', @EmployeeID=5 , @CustomerID=NULL

exec pr_GetOrderSummary @StartDate='1 Jan 1996', @EndDate='31 Aug 1996', @EmployeeID=NULL , @CustomerID='VINET'
 
exec pr_GetOrderSummary @StartDate='1 Jan 1996', @EndDate='31 Aug 1996', @EmployeeID=5 , @CustomerID='VINET'


DROP PROCEDURE IF EXISTS [pr_GetOrderSummary]