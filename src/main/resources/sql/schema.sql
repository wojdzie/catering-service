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
	purchaseOrderDate		DATETIME NOT NULL DEFAULT GETDATE(),
	pickupDate				DATETIME NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id),
	FOREIGN KEY(typeId) REFERENCES Purchase.PurchaseOrderType(id),
    FOREIGN KEY(clientId) REFERENCES Client.Client(id),
	CONSTRAINT CHK_pickupDate CHECK (pickupDate >= purchaseOrderDate)
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
    purchaseOrderId         BIGINT NOT NULL,
    menuId                  BIGINT NOT NULL,
    FOREIGN KEY(purchaseOrderId) REFERENCES Purchase.PurchaseOrder(id),
    FOREIGN KEY(menuId) REFERENCES Purchase.Menu(id),
    createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
    createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
    lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
    lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER
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








