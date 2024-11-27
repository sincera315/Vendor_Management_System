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
CREATE TABLE Employee (
    EmployeeId INT AUTO_INCREMENT PRIMARY KEY, -- Primary Key
    EmployeeName VARCHAR(255) NOT NULL,               -- Vendor Name (not null)
    Role Varchar(255) NOT NULL,
     ContactInfo VARCHAR(50) NOT NULL,        -- Contact Info (one contact only constraint)
    EmailAddress VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Budget (
    BudgetId INT AUTO_INCREMENT PRIMARY KEY, -- Primary Key
    EmployeeId int,               -- Vendor Name (not null)
    TotalBudget Int,
    SpentAmount Int ,
    RemainedBudget Int,
     FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);


CREATE TABLE PurchaseOrder (
    PurchaseId INT AUTO_INCREMENT, -- Primary Key
	VendorId int,               -- Vendor Name (not null)
	ItemName VarChar(255) not null,
    Quantity Int not Null,
    Unitprice Int,
    TotalCost int not null,
    PurchaseOrderStatus Varchar(255) not null,
    PRIMARY KEY (PurchaseId, VendorId),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);


CREATE TABLE Task (
    TaskId INT AUTO_INCREMENT Primary Key, -- Primary Key
	TaskStatus Varchar(20) Not Null,               -- Vendor Name (not null)
	TaskDescription VarChar(255) not null
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