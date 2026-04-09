DELIMITER //
CREATE PROCEDURE calculate_sales_growth(IN p_year INT, OUT growthRate DECIMAL(5,2))
BEGIN
    DECLARE current_sales DECIMAL(15,2) DEFAULT 0;
    DECLARE prev_sales DECIMAL(15,2) DEFAULT 0;
    SELECT SUM(od.priceEach * od.quantityOrdered) INTO current_sales FROM orders o JOIN orderdetails od ON o.orderNumber = od.orderNumber 
            WHERE year(o.orderDate)=p_year;
    SELECT SUM(od.priceEach * od.quantityOrdered) INTO prev_sales FROM orders o JOIN orderdetails od ON o.orderNumber = od.orderNumber 
            WHERE year(o.orderDate)=p_year-1;
    SET growthRate = ((current_sales - prev_sales)/prev_sales)*100; 
END //
DELIMITER ;

CALL calculate_sales_growth(2004, @growthRate);
SELECT @growthRate AS YearlySalesGrowth;

CREATE TABLE FailedPaymentsLog (
    customerNumber INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

DELIMITER //
CREATE TRIGGER after_payments_delete
    AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
    INSERT INTO FailedPaymentsLog VALUES (OLD.customerNumber,OLD.amount);
END// 
DELIMITER ;

/*
testing the trigger
*/
delete from payments where checknumber = 'HQ336336';

select * from failedpaymentslog;