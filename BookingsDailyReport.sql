DELIMITER $$
CREATE PROCEDURE generate_daily_report()
BEGIN
    DECLARE report_date DATE;
    DECLARE start_date DATETIME;
    DECLARE end_date DATETIME;
DELIMITER $$

CREATE PROCEDURE generate_daily_report()
BEGIN
    DECLARE report_date DATE;
    DECLARE start_date DATETIME;
    DECLARE end_date DATETIME;
    SET report_date = CURDATE();
    SET start_date = CONCAT(report_date, ' 00:00:00');
    SET end_date = CONCAT(report_date, ' 23:59:59');
    
    SELECT 
        b.booking_id, 
        c.name as customer_name, 
        v.model as vehicle_model, 
        b.start_date, 
        b.end_date 
    FROM 
        Booking b 
        INNER JOIN Customer c ON b.customer_id = c.customer_id 
        INNER JOIN Vehicle v ON b.vehicle_id = v.vehicle_id 
    WHERE 
        b.start_date BETWEEN start_date AND end_date 
        OR b.end_date BETWEEN start_date AND end_date;
END$$

DELIMITER ;

CREATE EVENT daily_report_event
ON SCHEDULE EVERY 1 DAY STARTS '2023-03-26 00:00:00'
DO CALL generate_daily_report();