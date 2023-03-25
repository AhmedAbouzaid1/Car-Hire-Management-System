# Car-Hire-Management-System

# Introduction:

The Car Hire Management System is a software solution that is designed to manage the booking system of a car rental business. This system is developed using Python Flask microframework and MySQL database. It allows the customers to book cars and vans for a specific period and provides the business owner with all the necessary information to manage the rental business. This document provides an overview of the system and its functionalities.

The system consists of the following components:

- Database: The MySQL database is used to store all the information related to the system, including customers, bookings, and vehicles.

- SQL Connector: The SQL Connector is a Python class responsible for connecting to the MySQL database and performing database operations such as querying, inserting, updating, and deleting data.

- Customers: The Customers class is a Python class responsible for managing the customers' data, including adding, updating, deleting, and retrieving customers' information from the database.

- Flask App: The Flask App is responsible for handling user requests, interacting with the Customers class, and returning the appropriate response to the user.

# System Functionality:

The Car Hire Management System flask app provides the following functionalities:

- Add New Customer: This endpoint allows the user to add a new customer to the system by providing the customer's details such as name, email, and phone number.

- Update Customer: This endpoint allows the user to update the customer's details such as name, address, email, and phone number.

- Delete Customer: This endpoint allows the user to delete a customer from the system by providing the customer's id.

- Get Customer: This endpoint allows the user to retrieve a customer's information from the system by providing the customer's id.

The Car Hire Management System sql server provides the following functionalities:

- Avoid overlapping reservation: The system avoids overlapping reservation through the following trigger:

```SQL
CREATE TRIGGER Remove_overlapping_bookings
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    SET overlap_count = (SELECT COUNT(*)
                         FROM Booking
                         WHERE vehicle_id = NEW.vehicle_id
                         AND start_date < NEW.end_date
                         AND end_date > NEW.start_date);

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Booking overlaps with existing bookings';
    END IF;
END
```

- Allow potential or existing customers can book a vehicle up to 7 days in advance depending on availability.

- A customer cannot hire a car for longer than a week.

- Generate Daily Report: A daily report is generated thorugh the following stored procedure.

```SQL

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
END
```

This stored procedure selects all bookings that start or end on the specified date, and joins with the Customer and Vehicle tables to retrieve additional information about each booking.
Next, the following event runs the stored procedure at the start of each day:

```SQL
CREATE EVENT daily_report_event
ON SCHEDULE EVERY 1 DAY STARTS '2023-03-26 00:00:00'
DO CALL generate_daily_report();
```

This event is scheduled to run every day at midnight starting from 2023-03-26. You can adjust the STARTS parameter to schedule the event to start on a different date or time. When the event runs, it will execute the generate_daily_report() stored procedure and output the result to the console. You can also modify the stored procedure to store the report in a table or file if you prefer.

# Conclusion:
The Car Hire Management System is a comprehensive solution for managing a car rental business. It provides all the necessary functionalities to manage the customers, bookings, and vehicles. The system is developed using the Flask microframework and MySQL database, making it easy to use and maintain.
