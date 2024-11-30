create Database Vendor_Contract_Management_System;
USE Vendor_Contract_Management_System;
-- now i will have Vectors strong entity.
CREATE TABLE Vendor (
    VendorId INT AUTO_INCREMENT PRIMARY KEY, -- Primary Key
    VendorName VARCHAR(255) NOT NULL,               -- Vendor Name (not null)
    ContactInfo VARCHAR(50) NOT NULL,        -- Contact Info (one contact only constraint)
    EmailAddress VARCHAR(255) NOT NULL UNIQUE, -- Unique Email Address
    ComplianceCertifications TEXT,          -- Descriptive field
    PerformanceRating DECIMAL(3, 2),        -- Derived attribute (updated via feedback calculation)
    CONSTRAINT unique_contact UNIQUE (ContactInfo) -- Enforce one contact only
);

-- now we will add the multicolumn ServiceCategory here in Vector Table.
CREATE TABLE VendorServiceCategory (
    VendorID INT,
    ServiceCategory VARCHAR(50),
    PRIMARY KEY (VendorID, ServiceCategory),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);
-- now it the Contract Table..
CREATE TABLE Contract (
    ContractId INT AUTO_INCREMENT PRIMARY KEY, -- Primary Key
    ContractName VARCHAR(255) NOT NULL,               -- Vendor Name (not null)
    VendorId INT,        -- Contact Info (one contact only constraint)
    StartDate date Not null,
    EndDate date not null,
    renewal_status VARCHAR(20) NOT NULL,
	ContractStatus VARCHAR(20) NOT NULL,
	FOREIGN KEY (VendorId) REFERENCES Vendor(VendorId)
);
-- now we will add the multicolumn Terms here in Contract Table.
CREATE TABLE ContractTerm (
    ContractId INT,
    TermId INT NOT NULL,
    Term VARCHAR(255),
    PRIMARY KEY (ContractId,TermId),
    FOREIGN KEY (ContractId) REFERENCES Contract(ContractId)
);
-- now we will have department entity.
CREATE TABLE Department (
    DepartmentId INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName varchar(255) Not NULL,
    AllocatedBudget int8 
);
-- Employee Table
-- Drop Table Budget;
-- Drop Table Employee;
CREATE TABLE Employee (
    EmployeeId INT AUTO_INCREMENT PRIMARY KEY, -- Primary Key
    EmployeeName VARCHAR(255) NOT NULL,               -- Vendor Name (not null)
    EmployeeRole Varchar(255) NOT NULL,
	ContactInfo VARCHAR(50) NOT NULL,        -- Contact Info (one contact only constraint)
    EmailAddress VARCHAR(255) NOT NULL UNIQUE,
    DepartmentId INT,
    FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId)
);

CREATE TABLE Budget (
    BudgetId INT AUTO_INCREMENT PRIMARY KEY, -- Primary Key
    DepartmentId INT,
    TotalBudget Int,
    SpentAmount Int ,
    RemainedBudget Int
);

Drop Table PurchaseOrder;
CREATE TABLE PurchaseOrder (
    PurchaseId INT AUTO_INCREMENT, -- Primary Key
	VendorId int,               -- Vendor Name (not null)
    DepartmentId INT,
	ItemName VarChar(255) not null,
    Quantity Int not Null,
    Unitprice Int,
    TotalCost int not null,
    PurchaseOrderStatus Varchar(255) not null,
    PRIMARY KEY (PurchaseId, VendorId),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID),
     FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId)
);

-- drop Table Task;
CREATE TABLE Task (
    TaskId INT AUTO_INCREMENT, -- Primary Key
    EmployeeId Int,
	TaskStatus Varchar(20) Not Null,               -- Vendor Name (not null)
	TaskDescription VarChar(255) not null,
	PRIMARY KEY (TaskId, EmployeeId),
    FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);

CREATE TABLE Notification (
    NotificationId INT AUTO_INCREMENT, -- Primary Key
	ContractId Int,
    NotificationDate Date not null,
    NotificationType varchar(255) not null,
    PRIMARY KEY (NotificationId, ContractId),
    FOREIGN KEY (ContractId) REFERENCES Contract(ContractId)
);

CREATE TABLE PerformanceFeedback (
    FeedbackId INT AUTO_INCREMENT, -- Primary Key
	VendorId Int,
    FeedbackDetails varchar(255) not null,
    Rating Int not null,
    DateProvided Date Not null,
    PRIMARY KEY (FeedbackId, VendorId),
    FOREIGN KEY (VendorId) REFERENCES Vendor(VendorId)
);
-- drop PROCEDURE RegisterVendor;



ALTER TABLE Vendor MODIFY COLUMN ContactInfo BigInt DEFAULT NULL;
-- Drop Procedure RegisterVendor;
DELIMITER //
CREATE PROCEDURE RegisterVendor(
    IN vendorName VARCHAR(100),
    IN ContactInfo BIGINT,
    IN EmailAdress VARCHAR(100),
    IN complianceCertifications TEXT,
    In PerformanceRating DECIMAL(3, 2)
)
BEGIN
    -- Insert the vendor details into the Vendor table
    INSERT INTO Vendor (VendorName , EmailAddress, ComplianceCertifications, PerformanceRating) 
    VALUES (VendorName , EmailAddress, ComplianceCertifications, PerformanceRating); 
END ;
// DELIMITER ;


DELIMITER //
CREATE PROCEDURE FinalizeContract(
    IN ContractName VARCHAR(255),
    In StartDate date ,
    In EndDate date ,
    In renewal_status VARCHAR(20),
	In ContractStatus VARCHAR(20) )
BEGIN
    -- Insert the vendor details into the Vendor table
    INSERT INTO Contract (ContractName , StartDate, EndDate, renewal_status,ContractStatus) 
    VALUES (ContractName , StartDate, EndDate, renewal_status,ContractStatus); 
END ;
// DELIMITER ;

Delimiter //
CREATE PROCEDURE ADDContractTerms(
    IN Term VARCHAR(255)  )
BEGIN
    -- Insert the vendor details into the Vendor table
    INSERT INTO ContractTerms (Term) VALUES (Term); 
END ;
// DELIMITER ;

Delimiter //
CREATE PROCEDURE AddVendorServiceCategory(
    IN ServiceCategory VARCHAR(255)  )
BEGIN
    -- Insert the vendor details into the Vendor table
    INSERT INTO VendorServiceCategory (ServiceCategory) VALUES (ServiceCategory); 
END ;
// DELIMITER ;

Delimiter //
CREATE PROCEDURE RenewContract(
    IN contractID INT,
    IN newEndDate DATE
)
BEGIN
    -- Update the contract with the new end date and renewal status
    UPDATE Contract
    SET EndDate = newEndDate, RenewalStatus = 'Renewed'
    WHERE ContractID = contractID;
END;
// DELIMITER ;

-- Triggers are as follows:
DELIMITER //
CREATE TRIGGER BudgetCheckBeforePurchase
BEFORE INSERT ON PurchaseOrder
FOR EACH ROW
BEGIN
    DECLARE allocatedBudget INT;
    DECLARE spentAmount INT;
    DECLARE remainingBudget INT;

    -- Fetch allocated budget and spent amount for the department
    SELECT TotalBudget, SpentAmount INTO allocatedBudget, spentAmount
    FROM Budget
    WHERE DepartmentId = NEW.DepartmentId;

    -- Calculate remaining budget
    SET remainingBudget = allocatedBudget - spentAmount;

    -- Check if the purchase exceeds the remaining budget
    IF NEW.TotalCost > remainingBudget THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Purchase exceeds the allocated budget.';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER UpdateContractStatusOnExpiry
AFTER UPDATE ON Contract
FOR EACH ROW
BEGIN
    -- Check if the contract has expired
    IF NEW.EndDate < CURDATE() THEN
        UPDATE Contract
        SET ContractStatus = 'Expired'
        WHERE ContractId = NEW.ContractId;
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER NotifyContractRenewalAfterInsert
AFTER INSERT ON Contract
FOR EACH ROW
BEGIN
    -- Check if the contract is nearing expiry (within 30 days)
    IF DATEDIFF(NEW.EndDate, CURDATE()) <= 30 THEN
        INSERT INTO Notification (ContractId, NotificationDate, NotificationType)
        VALUES (NEW.ContractId, CURDATE(), 'Renewal Reminder');
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER NotifyContractRenewalAfterUpdate
AFTER UPDATE ON Contract
FOR EACH ROW
BEGIN
    -- Check if the contract is nearing expiry (within 30 days)
    IF DATEDIFF(NEW.EndDate, CURDATE()) <= 30 THEN
        INSERT INTO Notification (ContractId, NotificationDate, NotificationType)
        VALUES (NEW.ContractId, CURDATE(), 'Renewal Reminder');
    END IF;
END;
//
DELIMITER ;


INSERT INTO Vendor (VendorName, ContactInfo, EmailAddress, ComplianceCertifications, PerformanceRating)
VALUES 
('Vendor A', '1234567890', 'vendorA@example.com', 'ISO 9001', 4.5),
('Vendor B', '0987654321', 'vendorB@example.com', 'ISO 27001', 4.2),
('Vendor C', '1112223333', 'vendorC@example.com', 'None', 3.8),
('Vendor D', '4445556666', 'vendorD@example.com', 'ISO 14001', 4.7),
('Vendor E', '7778889999', 'vendorE@example.com', 'ISO 45001', 4.0);

INSERT INTO VendorServiceCategory (VendorID, ServiceCategory)
VALUES
(1, 'IT Services'),
(1, 'Cloud Computing'),
(2, 'Consulting'),
(3, 'Maintenance'),
(4, 'Logistics');

INSERT INTO Contract (ContractName, VendorId, StartDate, EndDate, renewal_status, ContractStatus)
VALUES
('Contract A', 1, '2024-01-01', '2024-12-31', 'Pending', 'Active'),
('Contract B', 2, '2024-02-01', '2025-01-31', 'Renewed', 'Active'),
('Contract C', 3, '2023-03-01', '2023-12-01', 'Expired', 'Expired'),
('Contract D', 4, '2024-04-01', '2025-03-31', 'Pending', 'Active'),
('Contract E', 5, '2024-05-01', '2024-11-30', 'Pending', 'Active');

INSERT INTO ContractTerm (ContractId, TermId, Term)
VALUES
(1, 1, 'Payment within 30 days'),
(1, 2, 'Annual audit required'),
(2, 1, 'Quarterly reporting'),
(3, 1, 'Penalty for delays'),
(4, 1, 'On-site support');

INSERT INTO Department (DepartmentName, AllocatedBudget)
VALUES
('IT', 100000),
('Finance', 150000),
('HR', 50000),
('Logistics', 120000),
('Marketing', 80000);

INSERT INTO Employee (EmployeeName, EmployeeRole, ContactInfo, EmailAddress, DepartmentId)
VALUES
('John Doe', 'Manager', '1112223333', 'john.doe@example.com', 1),
('Jane Smith', 'Analyst', '4445556666', 'jane.smith@example.com', 2),
('Mike Brown', 'Coordinator', '7778889999', 'mike.brown@example.com', 3),
('Alice Davis', 'Supervisor', '1234567890', 'alice.davis@example.com', 4),
('Bob Wilson', 'Specialist', '0987654321', 'bob.wilson@example.com', 5);

INSERT INTO Budget (DepartmentId, TotalBudget, SpentAmount, RemainedBudget)
VALUES
(1, 100000, 25000, 75000),
(2, 150000, 50000, 100000),
(3, 50000, 20000, 30000),
(4, 120000, 40000, 80000),
(5, 80000, 10000, 70000);

INSERT INTO PurchaseOrder (VendorId, DepartmentId, ItemName, Quantity, Unitprice, TotalCost, PurchaseOrderStatus)
VALUES
(1, 1, 'Laptops', 10, 1000, 10000, 'Pending'),
(2, 2, 'Software License', 5, 2000, 10000, 'Approved'),
(3, 3, 'Office Chairs', 20, 150, 3000, 'Completed'),
(4, 4, 'Shipping Containers', 2, 5000, 10000, 'Pending'),
(5, 5, 'Advertising Material', 50, 100, 5000, 'Approved');

INSERT INTO Task (EmployeeId, TaskStatus, TaskDescription)
VALUES
(1, 'In Progress', 'Review vendor proposals'),
(2, 'Completed', 'Prepare monthly budget report'),
(3, 'Pending', 'Schedule employee training'),
(4, 'In Progress', 'Coordinate with logistics team'),
(5, 'Completed', 'Analyze marketing campaign results');

INSERT INTO Notification (ContractId, NotificationDate, NotificationType)
VALUES
(1, '2024-11-01', 'Renewal Reminder'),
(2, '2024-12-15', 'Expiry Warning'),
(3, '2023-11-20', 'Contract Expired'),
(4, '2025-03-01', 'Quarterly Review Reminder'),
(5, '2024-11-20', 'Renewal Reminder');

INSERT INTO PerformanceFeedback (VendorId, FeedbackDetails, Rating, DateProvided)
VALUES
(1, 'Excellent service quality', 5, '2024-11-01'),
(2, 'Delayed delivery but good support', 3, '2024-10-15'),
(3, 'Average performance overall', 4, '2024-09-20'),
(4, 'Outstanding customer support', 5, '2024-08-10'),
(5, 'Good adherence to deadlines', 4, '2024-07-25');
