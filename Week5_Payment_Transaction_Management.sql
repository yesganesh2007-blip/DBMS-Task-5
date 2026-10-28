CREATE TABLE Payment (
    Payment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Payment_Mode VARCHAR(20) NOT NULL,
    Payment_Status VARCHAR(10) NOT NULL DEFAULT 'Pending',
    Transaction_Amount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_payment_order FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_payment_mode CHECK (Payment_Mode IN
        ('UPI','Credit Card','Debit Card','Net Banking','Cash on Delivery')),
    CONSTRAINT chk_payment_status CHECK (Payment_Status IN
        ('Pending','Success','Failed')),
    CONSTRAINT chk_transaction_amount CHECK (Transaction_Amount > 0)
);

INSERT INTO Payment (Order_ID, Payment_Date, Payment_Mode, Payment_Status, Transaction_Amount) VALUES
(1,  '2026-10-01 10:15:00', 'UPI',              'Success', 1499.00),
(2,  '2026-10-02 14:30:00', 'Credit Card',      'Success', 25999.00),
(3,  '2026-10-03 09:45:00', 'Debit Card',       'Failed',  799.00),
(4,  '2026-10-04 18:20:00', 'Net Banking',      'Success', 3499.00),
(5,  '2026-10-05 11:05:00', 'Cash on Delivery', 'Pending', 1299.00),
(6,  '2026-10-06 16:40:00', 'UPI',              'Success', 549.00),
(7,  '2026-10-07 12:10:00', 'Credit Card',      'Failed',  8999.00),
(8,  '2026-10-08 20:00:00', 'UPI',              'Pending', 2199.00),
(9,  '2026-10-09 13:25:00', 'Debit Card',       'Success', 1799.00),
(10, '2026-10-10 17:50:00', 'Cash on Delivery', 'Success', 999.00);

INSERT INTO Payment (Order_ID, Payment_Date, Payment_Mode, Payment_Status, Transaction_Amount)
VALUES (11, NOW(), 'UPI', 'Pending', 1599.00);

SELECT * FROM Payment WHERE Payment_Status = 'Success';

SELECT * FROM Payment WHERE Payment_Status IN ('Failed','Pending');

UPDATE Payment
SET Payment_Status = 'Success', Payment_Date = NOW()
WHERE Order_ID = 3 AND Payment_Status = 'Failed';

UPDATE Payment
SET Payment_Status = 'Failed'
WHERE Order_ID = 8 AND Payment_Status = 'Pending';

SELECT Payment_Status, COUNT(*) AS Total_Payments
FROM Payment
WHERE Payment_Status IN ('Success','Failed')
GROUP BY Payment_Status;

SELECT p.Payment_ID, p.Payment_Date, p.Payment_Mode, p.Payment_Status, p.Transaction_Amount,
       o.Order_ID, o.Order_Date, o.Order_Status,
       c.Customer_ID, c.Customer_Name
FROM Payment p
JOIN Orders o ON p.Order_ID = o.Order_ID
JOIN Customer c ON o.Customer_ID = c.Customer_ID;

SELECT Payment_Mode, COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Mode
ORDER BY Total_Transactions DESC;

SELECT Payment_Mode, COUNT(*) AS Times_Used
FROM Payment
GROUP BY Payment_Mode
ORDER BY Times_Used DESC
LIMIT 1;

SELECT SUM(Transaction_Amount) AS Total_Successful_Revenue
FROM Payment
WHERE Payment_Status = 'Success';

SELECT Payment_Mode, SUM(Transaction_Amount) AS Revenue
FROM Payment
WHERE Payment_Status = 'Success'
GROUP BY Payment_Mode
ORDER BY Revenue DESC;

SELECT ROUND(AVG(Transaction_Amount), 2) AS Average_Transaction_Amount
FROM Payment;

SELECT c.Customer_ID, c.Customer_Name, o.Order_ID,
       p.Payment_ID, p.Payment_Date, p.Payment_Mode, p.Payment_Status, p.Transaction_Amount
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Payment p ON o.Order_ID = p.Order_ID
ORDER BY c.Customer_ID, p.Payment_Date;

SELECT
    SUM(Payment_Status = 'Success') AS Total_Successful,
    SUM(Payment_Status = 'Failed')  AS Total_Failed,
    SUM(Payment_Status = 'Pending') AS Total_Pending
FROM Payment;

SELECT o.Order_ID, o.Order_Date, c.Customer_Name,
       p.Payment_Mode, p.Payment_Status, p.Transaction_Amount
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN Payment p ON o.Order_ID = p.Order_ID
WHERE p.Payment_Status IN ('Failed','Pending');
