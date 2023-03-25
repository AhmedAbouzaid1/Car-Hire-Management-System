CREATE SCHEMA `carhiremanagement` ;
USE `carhiremanagement`;  

-- Create Customer table
CREATE TABLE Customer (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  address VARCHAR(100) NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  email VARCHAR(50) NOT NULL
);
-- Create Vehicle table
CREATE TABLE Vehicle (
  vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
  type ENUM('Small Car', 'Family Car', 'Van') NOT NULL,
  model VARCHAR(50) NOT NULL,
  color VARCHAR(20) NOT NULL,
  rental_cost DECIMAL(10,2) NOT NULL
);

-- Create Booking table
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    CONSTRAINT check_end_date CHECK (end_date < start_date + INTERVAL 7 DAY),
    CONSTRAINT check_booking_requested CHECK (booking_date < booking_date + INTERVAL 7 DAY)
);

-- Create Payment table
CREATE TABLE Payment (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT NOT NULL,
  payment_date DATE NOT NULL,
  payment_amount DECIMAL(10,2) NOT NULL,
  payment_method VARCHAR(20) NOT NULL,
  FOREIGN KEY (booking_id) REFERENCES Booking (booking_id)
);

DELIMITER $$
CREATE TRIGGER tr_remove_overlapping_bookings
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
END$$
DELIMITER ;


-- Insert data for Customer table
INSERT INTO Customer (name, address, phone_number, email)
VALUES ('John Smith', '123 Main St, Anytown, USA', '555-1234', 'john.smith@example.com'),
       ('Jane Doe', '456 Oak St, Anycity, USA', '555-5678', 'jane.doe@example.com'),
       ('Bob Johnson', '789 Maple Ave, Anyville, USA', '555-9876', 'bob.johnson@example.com');
       
-- Insert data for Small Cars
INSERT INTO Vehicle (type, model, color, rental_cost)
VALUES ('Small Car', 'Toyota Yaris', 'Red', 30.00),
       ('Small Car', 'Ford Fiesta', 'Blue', 25.00),
       ('Small Car', 'Volkswagen Golf', 'White', 35.00);

-- Insert data for Family Cars
INSERT INTO Vehicle (type, model, color, rental_cost)
VALUES ('Family Car', 'Toyota Sienna', 'Silver', 70.00),
       ('Family Car', 'Honda Odyssey', 'Gray', 65.00),
       ('Family Car', 'Chrysler Pacifica', 'Black', 75.00);

-- Insert data for Vans
INSERT INTO Vehicle (type, model, color, rental_cost)
VALUES ('Van', 'Ford Transit', 'White', 90.00),
       ('Van', 'Mercedes Sprinter', 'Black', 100.00),
       ('Van', 'Toyota Hiace', 'Silver', 85.00);
	   
-- Insert data for Booking table
INSERT INTO Booking (customer_id, vehicle_id, booking_date, start_date, end_date)
VALUES (1, 1, '2023-04-01', '2023-04-01', '2023-04-07'),
       (2, 6, '2023-04-01', '2023-04-05', '2023-04-10'),
       (3, 8, '2023-04-02', '2023-04-03', '2023-04-09');
       
-- Insert data for Payment table
INSERT INTO Payment (booking_id, payment_date, payment_amount, payment_method)
VALUES (1, '2023-04-01', 245.00, 'Debit card'),
       (2, '2023-04-02', 450.00, 'Credit card'),
       (3, '2023-04-03', 655.00, 'Cash');


	   
