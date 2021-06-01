

-- Functions
CREATE FUNCTION Invoice.IssueAnInvoiceForTheOrderForTheCompany (@orderId BIGINT)
    RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @sum DECIMAL(10,2);
    SELECT @sum = SUM(m.price)
    FROM Purchase.PurchaseOrderMenu pom
             INNER JOIN Purchase.Menu m ON pom.menuId = m.id
             INNER JOIN Purchase.PurchaseOrder po ON pom.purchaseOrderId = po.id
             INNER JOIN Client.Client c ON po.clientId = c.id
    WHERE pom.purchaseOrderId = @orderId
      AND c.companyName IS NOT NULL
      AND po.paid = FALSE
    RETURN @sum;
END;

CREATE FUNCTION Invoice.IssueAnMonthlyInvoiceFor    AllLastMonthOrdersForTheCompany (@companyId BIGINT)
    RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @sum DECIMAL(10,2);
    SELECT @sum = SUM(m.price)
    FROM Purchase.PurchaseOrder po
             INNER JOIN Purchase.PurchaseOrderMenu pom ON po.id = pom.purchaseOrderId
             INNER JOIN Purchase.Menu m ON pom.menuId = m.id
             INNER JOIN Client.Client c ON po.clientId = c.id
    WHERE po.clientId = @companyId
      AND DATEPART(m, po.createdDate) = DATEPART(m, DATEADD(m, -1, getdate()))
      AND DATEPART(yyyy, po.createdDate) = DATEPART(yyyy, DATEADD(m, -1, getdate()))
      AND c.companyName IS NOT NULL
      AND po.paid = FALSE
END;

CREATE PROCEDURE Purchase.CreateNewMenu
AS
BEGIN
    DECLARE @currentMenu TABLE(id BIGINT);
    DECLARE @newMenu TABLE(id BIGINT);

    SELECT m.productId INTO @currentMenu
    FROM Purchase.Menu m;

    DELETE FROM Purchase.Menu WHERE productId IN @currentMenu;

    SELECT TOP 20 p.id INTO @newMenu
    FROM Product.Product p
    WHERE p.id NOT IN @currentMenu
    ORDER BY NEWID()

    RETURN @newMenu;
END;
GO;

CREATE PROCEDURE StaticData.CreateNewLifetimeDiscount (
    @minOrderNumber INT, @minOrderPrice DECIMAL(10,2), @validityDate DATETIME
)
AS
BEGIN
    INSERT INTO StaticData.Discount (minOrderNumber, minOrderPrice, lifetime, validityDate)
    VALUES (@minOrderNumber, @minOrderPrice, 1, @validityDate);
END;
GO;

CREATE FUNCTION Report.GetMonthlyTableReservationReport()
    RETURNS BIGINT
AS
BEGIN
    DECLARE @sum BIGINT;
    SELECT @sum = COUNT(*)
    FROM Restaurant.Reservation
    WHERE DATEPART(m, createdDate) = DATEPART(m, DATEADD(m, -1, getdate()))
      AND DATEPART(yyyy, createdDate) = DATEPART(yyyy, DATEADD(m, -1, getdate()))
    RETURN @sum;
END;

CREATE FUNCTION Report.GetMonthlyDiscountReport()
    RETURNS BIGINT
AS
BEGIN
    DECLARE @sum BIGINT;
    SELECT @sum = COUNT(*)
    FROM StaticData.Discount
    WHERE DATEPART(m, createdDate) = DATEPART(m, DATEADD(m, -1, getdate()))
      AND DATEPART(yyyy, createdDate) = DATEPART(yyyy, DATEADD(m, -1, getdate()))
    RETURN @sum;
END;

CREATE FUNCTION Report.GetMonthlyIndividualClientOrderReport()
    RETURNS BIGINT
AS
BEGIN
    DECLARE @sum BIGINT;
    SELECT @sum = COUNT(*)
    FROM Purchase.PurchaseOrder po
             INNER JOIN Client.Client c ON c.id = po.clientId
             INNER JOIN Client.ClientType ct ON ct.id = c.typeId
    WHERE ct.type = 'individual'
      AND DATEPART(m, po.createdDate) = DATEPART(m, DATEADD(m, -1, getdate()))
      AND DATEPART(yyyy, po.createdDate) = DATEPART(yyyy, DATEADD(m, -1, getdate()))
    RETURN @sum;
END;

CREATE FUNCTION Report.GetMonthlyCompanyOrderReport()
    RETURNS BIGINT
AS
BEGIN
    DECLARE @sum BIGINT;
    SELECT @sum = COUNT(*)
    FROM Purchase.PurchaseOrder po
             INNER JOIN Client.Client c ON c.id = po.clientId
             INNER JOIN Client.ClientType ct ON ct.id = c.typeId
    WHERE ct.type = 'company'
      AND DATEPART(m, po.createdDate) = DATEPART(m, DATEADD(m, -1, getdate()))
      AND DATEPART(yyyy, po.createdDate) = DATEPART(yyyy, DATEADD(m, -1, getdate()))
    RETURN @sum;
END;






