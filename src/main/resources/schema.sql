-- Create schemas
CREATE SCHEMA Example;
CREATE SCHEMA Product;
CREATE SCHEMA Purchase;
CREATE SCHEMA Client;
CREATE SCHEMA Restaurant;
CREATE SCHEMA StaticData;
CREATE SCHEMA Invoice;
CREATE SCHEMA Report;

-- Create tables
CREATE TABLE Example.Example (
     id						BIGINT NOT NULL IDENTITY,
     numberExample			BIGINT NULL,
     textExample			VARCHAR(50) NULL,
     textAreaExample		VARCHAR(200) NULL,
     selectExample  		VARCHAR(50) NULL,
     dateExample			DATETIME NULL,
     radioExample			VARCHAR(50) NULL,
     checkboxExample		BIT NULL,
     PRIMARY KEY(id)
);

CREATE TABLE Product.ProductType (
     id						BIGINT NOT NULL IDENTITY,
     type					VARCHAR(50) NOT NULL,
     createdDate			DATETIME NOT NULL DEFAULT GETDATE(),
     createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
     lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
     lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
     PRIMARY KEY(id)
);

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
);

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
);

CREATE TABLE Client.ClientType (
	id						BIGINT NOT NULL IDENTITY,
	type					VARCHAR(50) NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id)
);

CREATE TABLE Client.Client (
	id						BIGINT NOT NULL IDENTITY,
	typeId					BIGINT NOT NULL,
	firstName				VARCHAR(50) NULL,
	lastName				VARCHAR(80) NULL,
	companyName				VARCHAR(100) NULL,
	NIP						VARCHAR(10) NULL,
	regon					VARCHAR(14) NULL,
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
	CONSTRAINT CHK_Regon CHECK (regon LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR regon LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CHK_NIP CHECK (NIP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CHK_phone CHECK (phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CHK_email CHECK (email LIKE '%@%.%')
);

CREATE TABLE Purchase.PurchaseOrderType (
	id						BIGINT NOT NULL IDENTITY,
	type					VARCHAR(50) NOT NULL,
	createdDate				DATETIME NOT NULL DEFAULT GETDATE(),
	createdBy				VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	lastModified			DATETIME NOT NULL DEFAULT GETDATE(),
	lastModifiedBy			VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
	PRIMARY KEY(id)
);

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
);

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
);

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
);

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
);

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
);

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
);

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
);

-- Create triggers
CREATE TRIGGER Product.ProductTypeTrigger ON Product.ProductType
AFTER UPDATE
AS
BEGIN
	UPDATE Product.ProductType
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER Product.ProductTrigger ON Product.Product
AFTER UPDATE
AS
BEGIN
	UPDATE Product.Product
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER Client.AddressTrigger ON Client.Address
AFTER UPDATE
AS
BEGIN
	UPDATE Client.Address
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER Client.ClientTypeTrigger ON Client.ClientType
AFTER UPDATE
AS
BEGIN
	UPDATE Client.ClientType
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER Client.ClientTrigger ON Client.Client
AFTER UPDATE
AS
BEGIN
	UPDATE Client.Client
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER Purchase.PurchaseOrderTypeTrigger ON Purchase.PurchaseOrderType
AFTER UPDATE
AS
BEGIN
	UPDATE Purchase.PurchaseOrderType
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER Purchase.PurchaseOrderTrigger ON Purchase.PurchaseOrder
AFTER UPDATE
AS
BEGIN
	UPDATE Purchase.PurchaseOrder
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER Purchase.MenuTrigger ON Purchase.Menu
AFTER UPDATE
AS
BEGIN
	UPDATE Purchase.Menu
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER Purchase.PurchaseOrderMenuTrigger ON Purchase.PurchaseOrderMenu
AFTER UPDATE
AS
BEGIN
UPDATE Purchase.PurchaseOrderMenu
SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
WHERE id IN (
    SELECT id FROM inserted
)
END;

CREATE TRIGGER Restaurant.SingleTableTrigger ON Restaurant.SingleTable
AFTER UPDATE
AS
BEGIN
	UPDATE Restaurant.SingleTable
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER Restaurant.ReservationTrigger ON Restaurant.Reservation
AFTER UPDATE
AS
BEGIN
	UPDATE Restaurant.Reservation
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER StaticData.DiscountTrigger ON StaticData.Discount
AFTER UPDATE
AS
BEGIN
	UPDATE StaticData.Discount
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;

CREATE TRIGGER StaticData.AreaRestrictionTrigger ON StaticData.AreaRestriction
AFTER UPDATE
AS
BEGIN
	UPDATE StaticData.AreaRestriction
	SET lastModified = GETDATE(), lastModifiedBy = CURRENT_USER
	WHERE id IN (
		SELECT id FROM inserted
	)
END;