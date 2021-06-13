CREATE PROCEDURE Purchase.GenerateNewMenu @menuSize INTEGER
AS
BEGIN
	DECLARE @currentMenuSize AS BIGINT;
	SELECT @currentMenuSize = COUNT(*) FROM Purchase.Menu;
	IF (@currentMenuSize = 0)
		BEGIN
			INSERT INTO Purchase.Menu (productId)
			SELECT TOP (@menuSize) id
			FROM Product.Product
			ORDER BY NEWID()
		END
	ELSE
		BEGIN
			UPDATE Purchase.Menu
			SET endDate = GETDATE()
			WHERE id IN (
				SELECT TOP (@menuSize / 2)
				id
				FROM Purchase.Menu
				WHERE endDate IS NULL
				ORDER BY NEWID()
			);

			INSERT INTO Purchase.Menu (productId)
			SELECT TOP (@menuSize / 2) id
			FROM Product.Product
			WHERE id NOT IN (
				SELECT productId
				FROM Purchase.Menu
				WHERE endDate IS NULL
			)
			ORDER BY NEWID();
		END;
END;

CREATE PROCEDURE Client.AddClient
(
@typeId	BIGINT,
@firstName  VARCHAR(50) NULL,
@lastName	VARCHAR(80) NULL,
@companyName	VARCHAR(100) NULL,
@NIP	VARCHAR(10) NULL,
@Regon	VARCHAR(14) NULL,
@phone	VARCHAR(9) NULL,
@email	VARCHAR(50) NULL,
@address	VARCHAR(100) NULL,
@city	VARCHAR(50) NULL,
@postalCode	VARCHAR(6) NULL,
@country	VARCHAR(50) NULL
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

CREATE PROCEDURE StaticData.AddRestrictions
(
    @startDate DATETIME,
    @endDate DATETIME,
    @newArea INT
)

AS
BEGIN
	SET NOCOUNT ON;

INSERT INTO StaticData.AreaRestriction (squareMetersLimit, startDate, endDate)
VALUES (@newArea, @startDate, @endDate)
END;

CREATE PROCEDURE Restaurant.BusinessTableReservation
(
@date DATETIME,
@peopleAmount INT,
@companyName	VARCHAR(100),
@NIP	VARCHAR(10),
@Regon	VARCHAR(14),
@phone	VARCHAR(9),
@email	VARCHAR(50)
)
AS
BEGIN
	DECLARE @typeId BIGINT
	DECLARE @clientId BIGINT

SELECT @typeId = id FROM Client.ClientType WHERE type = 'business'

    EXEC Client.AddClient
		@typeId = @typeId,
		@firstName = NULL,
		@lastName = NULL,
		@companyName = @companyName,
		@NIP = @NIP,
		@Regon = @Regon,
		@phone = @phone,
		@email = @email,
		@address = NULL,
		@city = NULL,
		@postalCode = NULL,
		@country = NULL,
		@clientId = @clientId OUTPUT

	EXEC Restaurant.TableReservation
		@date = @date,
		@clientId = @clientId,
		@peopleAmount = @peopleAmount
END;

CREATE PROCEDURE Client.AddClient
(
@typeId	BIGINT,
@firstName  VARCHAR(50) NULL,
@lastName	VARCHAR(80) NULL,
@companyName	VARCHAR(100) NULL,
@NIP	VARCHAR(10) NULL,
@Regon	VARCHAR(14) NULL,
@phone	VARCHAR(9) NULL,
@email	VARCHAR(50) NULL,
@address	VARCHAR(100) NULL,
@city	VARCHAR(50) NULL,
@postalCode	VARCHAR(6) NULL,
@country	VARCHAR(50) NULL,
@clientId BIGINT OUTPUT
)
AS
BEGIN
DECLARE @addressID BIGINT = NULL

IF(@address IS NOT NULL AND @city IS NOT NULL AND @postalCode IS NOT NULL AND @country IS NOT NULL)
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
						@email = @email,
						@id = @clientId OUTPUT;
END;

CREATE PROCEDURE Restaurant.ConfirmReservation(
    @reservationId BIGINT
)
    AS
BEGIN
UPDATE Restaurant.Reservation
SET confirmed = 1
WHERE id = @reservationId
END
GO


CREATE PROCEDURE Restaurant.IndividualOrder(
@peopleAmount INT
)
AS
BEGIN
	DECLARE @typeId BIGINT

SELECT @typeId = id FROM Purchase.PurchaseOrderType WHERE type = 'in-place'

    EXEC Restaurant.TableReservation
		@date = GETDATE,
		@clientId = NULL,
		@peopleAmount = @peopleAmount

INSERT INTO Purchase.PurchaseOrder("typeId", "paid")
VALUES(@typeId, 0)
END;

CREATE PROCEDURE Restaurant.IndividualOrderTakeaway
AS
BEGIN
	DECLARE @typeId BIGINT

SELECT @typeId = id FROM Purchase.PurchaseOrderType WHERE type = 'takeaway'

    INSERT INTO Purchase.PurchaseOrder("typeId", "paid", "pickupDate")
VALUES(@typeId, 0, GETDATE())
END;

CREATE PROCEDURE Restaurant.IndividualOrderTakeawayInAdvance(
@pickupDate DATETIME
)
AS
BEGIN
	DECLARE @typeId BIGINT

SELECT @typeId = id FROM Purchase.PurchaseOrderType WHERE type = 'takeaway'

    INSERT INTO Purchase.PurchaseOrder("typeId", "paid", "pickupDate")
VALUES(@typeId, 0, @pickupDate)
END;

CREATE PROCEDURE Restaurant.IndividualTableReservation
(
@date DATETIME,
@peopleAmount INT,
@firstName VARCHAR(50),
@lastName VARCHAR(80),
@companyName	VARCHAR(100),
@NIP	VARCHAR(10),
@Regon	VARCHAR(14),
@phone	VARCHAR(9),
@email	VARCHAR(50),
@address VARCHAR(100),
@city VARCHAR(50),
@postalCode VARCHAR(6),
@country VARCHAR(50)
)
AS
BEGIN
	DECLARE @typeId BIGINT
	DECLARE @clientId BIGINT

SELECT @typeId = id FROM Client.ClientType WHERE type = 'individual'

    EXEC Client.AddClient
		@typeId = @typeId,
		@firstName = @firstName,
		@lastName = @lastName,
		@companyName = @companyName,
		@NIP = @NIP,
		@Regon = @Regon,
		@phone = @phone,
		@email = @email,
		@address = @address,
		@city = @city,
		@postalCode = @postalCode,
		@country = @country,
		@clientId = @clientId OUTPUT

	EXEC Restaurant.TableReservation
		@date = @date,
		@clientId = @clientId,
		@peopleAmount = @peopleAmount
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
@email	VARCHAR(50),
@id BIGINT OUTPUT
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

    SET @id = SCOPE_IDENTITY()
END;

CREATE PROCEDURE Restaurant.TableReservation(
	@date DATETIME,
	@clientId BIGINT,
	@peopleAmount INT
)
AS
BEGIN

	IF(dbo.AvailableTables(@date) >= @peopleAmount AND @peopleAmount >= 2)
BEGIN
		DECLARE @peopleLeft INT = @peopleAmount

		WHILE @peopleLeft > 0
BEGIN
			DECLARE @freeTableId BIGINT;
			DECLARE @seats INT;

SELECT
        @freeTableId = Restaurant.SingleTable.id,
        @seats = seats
FROM Restaurant.SingleTable
         RIGHT JOIN Restaurant.Reservation
                    ON Restaurant.SingleTable.id = Restaurant.Reservation.tableId
WHERE reservationDate < @date AND DATEADD(HOUR, 2, reservationDate) > @date;

INSERT INTO Restaurant.Reservation ("clientId", "tableId", "reservationDate")
VALUES (@clientId, @freeTableId, @date)

    SET @peopleLeft = @peopleLeft - @seats
END
END
END

CREATE PROCEDURE Restaurant.WorkerTableReservation
(
@date DATETIME,
@peopleAmount INT,
@firstName VARCHAR(50),
@lastName VARCHAR(80),
@companyName	VARCHAR(100),
@NIP	VARCHAR(10),
@Regon	VARCHAR(14),
@phone	VARCHAR(9),
@email	VARCHAR(50)
)
AS
BEGIN
	DECLARE @typeId BIGINT
	DECLARE @clientId BIGINT

SELECT @typeId = id FROM Client.ClientType WHERE type = 'worker'

    EXEC Client.AddClient
		@typeId = @typeId,
		@firstName = @firstName,
		@lastName = @lastName,
		@companyName = @companyName,
		@NIP = @NIP,
		@Regon = @Regon,
		@phone = @phone,
		@email = @email,
		@address = NULL,
		@city = NULL,
		@postalCode = NULL,
		@country = NULL,
		@clientId = @clientId OUTPUT

	EXEC Restaurant.TableReservation
		@date = @date,
		@clientId = @clientId,
		@peopleAmount = @peopleAmount
END;