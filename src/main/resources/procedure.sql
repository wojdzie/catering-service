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