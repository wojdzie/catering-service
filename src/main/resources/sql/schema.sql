-- Create schemas
CREATE SCHEMA Product
GO
CREATE SCHEMA Purchase
GO
CREATE SCHEMA Client
GO
CREATE SCHEMA Restaurant
GO
CREATE SCHEMA StaticData
GO
CREATE SCHEMA Invoice
GO
CREATE SCHEMA Report
GO

-- Create tables
-- Product.ProductType
CREATE TABLE Product.ProductType (
	id						BIGINT NOT NULL IDENTITY,
	type					VARCHAR(50) NOT NULL,					
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,	
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id)
)
GO

CREATE TRIGGER Product.ProductTypeTrigger ON Product.ProductType
AFTER UPDATE
AS
BEGIN
	UPDATE Product.ProductType
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- Product.Product
CREATE TABLE Product.Product (
	id						BIGINT NOT NULL IDENTITY,
	typeId					BIGINT NOT NULL,
	name					VARCHAR(100) NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	FOREIGN KEY(typeId) REFERENCES Product.ProductType(id)
)
GO

CREATE TRIGGER Product.ProductTrigger ON Product.Product
AFTER UPDATE
AS
BEGIN
	UPDATE Product.Product
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- Client.Address
CREATE TABLE Client.Address (
	id						BIGINT NOT NULL IDENTITY,
	address					VARCHAR(100) NOT NULL,
	city					VARCHAR(50) NOT NULL,
	postalCode				VARCHAR(6) NOT NULL,
	country					VARCHAR(50) NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	CONSTRAINT CHK_postalCode CHECK (postalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]')
)
GO

CREATE TRIGGER Client.AddressTrigger ON Client.Address
AFTER UPDATE
AS
BEGIN
	UPDATE Client.Address
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- Client.ClientType
CREATE TABLE Client.ClientType (
	id						BIGINT NOT NULL IDENTITY,
	type					VARCHAR(50) NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id)
)
GO

CREATE TRIGGER Client.ClientTypeTrigger ON Client.ClientType
AFTER UPDATE
AS
BEGIN
	UPDATE Client.ClientType
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- Client.Client
CREATE TABLE Client.Client (
	id						BIGINT NOT NULL IDENTITY,
	typeId					BIGINT NOT NULL,
	firstName				VARCHAR(50) NULL,
	lastName				VARCHAR(80) NULL,
	companyName				VARCHAR(100) NULL,
	NIP						VARCHAR(10) NULL,
	Regon					VARCHAR(14) NULL,
	addressId				BIGINT NULL,
	phone					VARCHAR(9) NULL,
	email					VARCHAR(50) NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	FOREIGN KEY(typeId) REFERENCES Client.ClientType(id),
	FOREIGN KEY(addressId) REFERENCES Client.Address(id),
	CONSTRAINT CHK_Regon CHECK (Regon LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR Regon LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CHK_NIP CHECK (NIP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CHK_phone CHECK (phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CHK_email CHECK (email LIKE '%@%.%')
)
GO

CREATE TRIGGER Client.ClientTrigger ON Client.Client
AFTER UPDATE
AS
BEGIN
	UPDATE Client.Client
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- Purchase.PurchaseOrderType
CREATE TABLE Purchase.PurchaseOrderType (
	id						BIGINT NOT NULL IDENTITY,
	type					VARCHAR(50) NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id)
)
GO

CREATE TRIGGER Purchase.PurchaseOrderTypeTrigger ON Purchase.PurchaseOrderType
AFTER UPDATE
AS
BEGIN
	UPDATE Purchase.PurchaseOrderType
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- Purchase.PurchaseOrder
CREATE TABLE Purchase.PurchaseOrder (
	id						BIGINT NOT NULL IDENTITY,
    clientId				BIGINT NOT NULL,
	typeId					BIGINT NOT NULL,
    paid				    BIT NOT NULL DEFAULT 0,
	purchaseOrderDate		DATETIME NOT NULL DEFAULT GETDATE(),
	pickupDate				DATETIME NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	FOREIGN KEY(typeId) REFERENCES Purchase.PurchaseOrderType(id),
    FOREIGN KEY(clientId) REFERENCES Client.Client(id),
	CONSTRAINT CHK_pickupDate CHECK (pickupDate >= purchaseOrderDate),
)
GO

CREATE TRIGGER Purchase.PurchaseOrderTrigger ON Purchase.PurchaseOrder
AFTER UPDATE
AS
BEGIN
	UPDATE Purchase.PurchaseOrder
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- Purchase.Menu
CREATE TABLE Purchase.Menu (
	id						BIGINT NOT NULL IDENTITY,
	productId				BIGINT NOT NULL,
	price					DECIMAL(10,2) NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	FOREIGN KEY(productId) REFERENCES Product.Product(id)
)
GO

CREATE TRIGGER Purchase.MenuTrigger ON Purchase.Menu
AFTER UPDATE
AS
BEGIN
	UPDATE Purchase.Menu
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- Purchase.PurchaseOrderMenu
CREATE TABLE Purchase.PurchaseOrderMenu (
	id						BIGINT NOT NULL IDENTITY,
    purchaseOrderId         BIGINT NOT NULL,
    menuId                  BIGINT NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
    createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
    lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
    lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
    FOREIGN KEY(purchaseOrderId) REFERENCES Purchase.PurchaseOrder(id),
    FOREIGN KEY(menuId) REFERENCES Purchase.Menu(id)
)
GO

CREATE TRIGGER Purchase.PurchaseOrderMenuTrigger ON Purchase.PurchaseOrderMenu
AFTER UPDATE
AS
BEGIN
UPDATE Purchase.PurchaseOrderMenu
SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
WHERE id IN (
    SELECT id FROM inserted
)
END
GO

-- Restaurant.Restaurant
CREATE TABLE Restaurant.Restaurant (
	id						BIGINT NOT NULL IDENTITY,
	localSquareMeters		INT NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	CONSTRAINT CHK_localSquareMeters CHECK (localSquareMeters > 0)
)

-- Restaurant.SingleTable
CREATE TABLE Restaurant.SingleTable (
	id						BIGINT NOT NULL IDENTITY,
	seats					INT NOT NULL,
	available				BIT NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	CONSTRAINT CHK_seats CHECK (seats > 0)
)
GO

CREATE TRIGGER Restaurant.SingleTableTrigger ON Restaurant.SingleTable
AFTER UPDATE
AS
BEGIN
	UPDATE Restaurant.SingleTable
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- Restaurant.Reservation
CREATE TABLE Restaurant.Reservation (
	id						BIGINT NOT NULL IDENTITY,
	clientId				BIGINT NOT NULL,
	tableId					BIGINT NOT NULL,
	reservationDate			DATETIME NOT NULL,
	additionalInformation	VARCHAR(200) NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	FOREIGN KEY(clientId) REFERENCES Client.Client(id),
	FOREIGN KEY(tableId) REFERENCES Restaurant.SingleTable(id),
	CONSTRAINT CHK_reservationDate CHECK (reservationDate >= GETDATE())
)
GO

CREATE TRIGGER Restaurant.ReservationTrigger ON Restaurant.Reservation
AFTER UPDATE
AS
BEGIN
	UPDATE Restaurant.Reservation
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- StaticData.Discount
CREATE TABLE StaticData.Discount (
	id						BIGINT NOT NULL IDENTITY,
	minOrderNumber			INT NOT NULL,
	minOrderPrice			DECIMAL(10,2) NOT NULL,
	lifetime				BIT NOT NULL,
	validityDate			DATETIME NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	CONSTRAINT CHK_minOrderNumber CHECK (minOrderNumber > 0),
	CONSTRAINT CHK_minOrderPrice CHECK (minOrderPrice > 0),
	CONSTRAINT CHK_validityDate CHECK (validityDate >= GETDATE())
)
GO

CREATE TRIGGER StaticData.DiscountTrigger ON StaticData.Discount
AFTER UPDATE
AS
BEGIN
	UPDATE StaticData.Discount
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

-- StaticData.AreaRestriction
CREATE TABLE StaticData.AreaRestriction (
	id						BIGINT NOT NULL IDENTITY,
	squareMetersLimit		INT NOT NULL,
	startDate				DATETIME NOT NULL DEFAULT GETDATE(),
	endDate					DATETIME NOT NULL DEFAULT DATEADD(week, 2, GETDATE()),
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	CONSTRAINT CHK_squareMetersLimit CHECK (squareMetersLimit > 0)
)
GO

CREATE TRIGGER StaticData.AreaRestrictionTrigger ON StaticData.AreaRestriction
AFTER UPDATE
AS
BEGIN
	UPDATE StaticData.AreaRestriction
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END
GO

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

CREATE FUNCTION Invoice.IssueAnMonthlyInvoiceForAllLastMonthOrdersForTheCompany (@companyId BIGINT)
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

-- This procedure takes menu ID and client ID and inserts purchase data into 2 tables
-- with guaranteed PurchaseOrderType of 'in-place' 
CREATE PROCEDURE Purchase.OrderInPlace(
	@clientId BIGINT,
	@menuId BIGINT
)
    RETURNS BIGINT
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @id BIGINT

    INSERT INTO Purchase.PurchaseOrder (typeId, clientId) 
	SELECT id, @clientId FROM Purchase.PurchaseOrderType WHERE type = 'in-place'

	SET @id = SCOPE_IDENTITY();

	INSERT INTO Purchase.PurchaseOrderMenu (purchaseOrderId, menuId) 
	VALUES(@id, @menuId)
END;

-- This procedure takes menu ID and client ID and inserts purchase data into 2 tables
-- with guaranteed PurchaseOrderType of 'out-of-place' 
CREATE PROCEDURE Purchase.OrderOutOfPlace(
	@clientId BIGINT,
	@menuId BIGINT
)
    RETURNS BIGINT
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @id BIGINT

    INSERT INTO Purchase.PurchaseOrder (typeId, clientId) 
	SELECT id, @clientId FROM Purchase.PurchaseOrderType WHERE type = 'out-of-place'

	SET @id = SCOPE_IDENTITY();

	INSERT INTO Purchase.PurchaseOrderMenu (purchaseOrderId, menuId) 
	VALUES(@id, @menuId)
END;

-- This procedure takes menu ID, client ID and date and inserts purchase data into 2 tables
-- with guaranteed PurchaseOrderType of 'out-of-place' and in-advance receipt
CREATE PROCEDURE Purchase.OrderOutOfPlaceInAdvance(
	@clientId BIGINT,
	@menuId BIGINT,
	@date DATETIME
)
    RETURNS BIGINT
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @id BIGINT

    INSERT INTO Purchase.PurchaseOrder (typeId, clientId, pickupDate) 
	SELECT id, @clientId, @date FROM Purchase.PurchaseOrderType WHERE type = 'out-of-place'

	SET @id = SCOPE_IDENTITY();

	INSERT INTO Purchase.PurchaseOrderMenu (purchaseOrderId, menuId) 
	VALUES(@id, @menuId)
END;

CREATE FUNCTION Restaurant.AvailableTable
(	
	@peopleCount INT
)
RETURNS TABLE 
AS
RETURN (SELECT TOP 1 * FROM Restaurant.SingleTable WHERE seats = @peopleCount AND available = 1)


CREATE PROCEDURE Restaurant.BookTable
(
	@clientId BIGINT,
	@peopleCount INT
)
AS
BEGIN
	IF EXISTS (SELECT * FROM Restaurant.SingleTable WHERE seats = @peopleCount AND available = 1)
	BEGIN
		DECLARE @id BIGINT

		SELECT @id = id FROM AvailableTable(@peopleCount)

		INSERT INTO Restaurant.Reservation (clientId, tableId)
		SELECT @clientId, @id FROM Restaurant.SingleTable WHERE id = @id

		UPDATE Restaurant.SingleTable SET available = 0 WHERE id = @id
	END
END;

CREATE PROCEDURE StaticData.AddRestrictions
	@startDate DATETIME,
	@endDate DATETIME,
	@newArea INT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO StaticData.AreaRestriction (squareMetersLimit, startDate, endDate)
	VALUES (@newArea, @startDate, @endDate)
END;


CREATE PROCEDURE Client.InsertAddress
(
@address	VARCHAR(100),
@city	VARCHAR(50),
@postalCode	VARCHAR(6),
@country	VARCHAR(50),
@id BIGINT OUTPUT
)
AS
BEGIN
	INSERT INTO Client.Address(
	address,
	city,
	postalCode,
	country
	)
	VALUES (
	@address,
	@city,
	@postalCode,
	@country
	)
	SET @id = SCOPE_IDENTITY();
END;

CREATE PROCEDURE Client.InsertClient
(@typeId	BIGINT,
@firstName  VARCHAR(50),
@lastName	VARCHAR(80),
@companyName	VARCHAR(100),
@NIP	VARCHAR(10),
@Regon	VARCHAR(14),
@addressId	BIGINT,
@phone	VARCHAR(9),
@email	VARCHAR(50)
)
AS
BEGIN
	INSERT INTO Client.Client(
		typeId,
		firstName,
		lastName,
		companyName,
		NIP,
		Regon,
		addressId,
		phone,
		email	
)
VALUES (
		@typeId,
		@firstName,
		@lastName,
		@companyName,
		@NIP,
		@Regon,
		@addressId,
		@phone,
		@email	
)
END;

CREATE PROCEDURE Client.AddClient
(
@typeId	BIGINT,
@firstName  VARCHAR(50),
@lastName	VARCHAR(80),
@companyName	VARCHAR(100),
@NIP	VARCHAR(10),
@Regon	VARCHAR(14),
@phone	VARCHAR(9),
@email	VARCHAR(50),
@address	VARCHAR(100),
@city	VARCHAR(50),
@postalCode	VARCHAR(6),
@country	VARCHAR(50)
)
AS
BEGIN
DECLARE @addressID BIGINT
EXEC Client.InsertAddress @address = @address,
						@city = @city,
						@postalCode = @postalCode,
						@country = @country,
						@id = @addressID OUTPUT;

EXEC  Client.InsertClient @typeId = @typeId,
						@firstName = @firstName,
						@lastName = @lastName,
						@companyName = @companyName,
						@NIP = @NIP,
						@Regon = @Regon,
						@addressId = @addressId,
						@phone = @phone,
						@email = @email;
END;
