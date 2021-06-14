CREATE VIEW Report.SinglePurchaseOrderReport AS
    SELECT pom.purchaseOrderId, p.name, p.price, pom.createdDate, c.companyName,
           c.NIP, a.address, a.postalCode, a.city
    FROM Purchase.PurchaseOrderMenu pom
             INNER JOIN Purchase.Menu m ON m.id = pom.menuId
             INNER JOIN Product.Product p ON p.id = m.productId
             INNER JOIN Purchase.PurchaseOrder po ON po.id = pom.purchaseOrderId
             INNER JOIN Client.Client c ON c.id = po.clientId
             INNER JOIN Client.Address a ON a.id = c.addressId;

CREATE VIEW Report.TableReservationReport AS
    SELECT rr.reservationDate,
           COUNT(rr.reservationDate) AS reservationNumber,
           SUM(st.seats) AS seats
    FROM Restaurant.Reservation rr
             INNER JOIN Restaurant.SingleTable st ON st.id = rr.tableId
    GROUP BY rr.reservationDate;