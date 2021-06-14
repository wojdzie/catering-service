
    CREATE FUNCTION AvailableTables(@date DATETIME)
        RETURNS INT
    AS
    BEGIN
        DECLARE @localSquareMeters INT;
        DECLARE @squareMetersLimitPerPerson INT = NULL;
        DECLARE @notAvailable INT;
        DECLARE @available INT;
        DECLARE @all INT;
        DECLARE @availableSeatsAfterRestriction INT;

    SELECT @localSquareMeters = localSquareMeters
    FROM Restaurant.Restaurant

    SELECT @all = COUNT(seats)
    FROM Restaurant.SingleTable

    SELECT @squareMetersLimitPerPerson = squareMetersLimit
    FROM StaticData.AreaRestriction
    WHERE startDate <= @date AND endDate >= @date

        SET @availableSeatsAfterRestriction = @localSquareMeters / @squareMetersLimitPerPerson

        IF(@all > @availableSeatsAfterRestriction)
    BEGIN
    SELECT @notAvailable = SUM(seats)
    FROM Restaurant.SingleTable
             FULL JOIN Restaurant.Reservation
                       ON Restaurant.SingleTable.id = Restaurant.Reservation.tableId
    WHERE reservationDate < @date AND DATEADD(HOUR, 2, reservationDate) > @date;

    SET @available = @availableSeatsAfterRestriction - @notAvailable
    END
    ELSE
    SELECT @available = COUNT(DISTINCT Restaurant.SingleTable.id)
    FROM Restaurant.SingleTable
             LEFT JOIN Restaurant.Reservation
                       ON Restaurant.SingleTable.id = Restaurant.Reservation.tableId
    WHERE reservationDate IS NULL OR (reservationDate > @date OR DATEADD(HOUR, 2, reservationDate) < @date);

    RETURN @available
    END

CREATE FUNCTION CanOrderSeafood (
    @orderDate DATETIME,
    @reservationDate DATETIME
)
    RETURNS bit
AS
BEGIN
   IF
(DATEPART(WEEKDAY, @orderDate) = 5 AND DATEADD(DD, -2, @orderDate) < @reservationDate) OR
    (DATEPART(WEEKDAY, @orderDate) = 6 AND DATEADD(DD, -3, @orderDate) < @reservationDate) OR
    (DATEPART(WEEKDAY, @orderDate) = 7 AND DATEADD(DD, -4, @orderDate) < @reservationDate)
        RETURN 1

    RETURN 0
END
GO