 Create database Populate 

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(100),
    Salary INT,
    DeptID INT
);

INSERT INTO Employees (EmpID, Name, Salary, DeptID)
VALUES
    (1, 'Alice', 60000, 101),
    (2, 'Bob', 45000, 102),
    (3, 'Charlie', 75000, 101),
    (4, 'Diana', 50000, 103),
    (5, 'Eve', 68000, 102);

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100),
    Location VARCHAR(100)
);

INSERT INTO Departments (DeptID, DeptName, Location)
VALUES
    (101, 'Engineering', 'New York'),
    (102, 'Sales', 'Chicago'),
    (103, 'HR', 'San Francisco');

-- Step 2: Tasks

-- 1. Create HighEarners View
CREATE VIEW HighEarners AS
SELECT Name, Salary
FROM Employees
WHERE Salary > 60000;

-- 2. Create EmpDepartmentInfo View
CREATE VIEW EmpDepartmentInfo AS
SELECT 
    E.Name, 
    E.Salary, 
    D.DeptName, 
    D.Location
FROM Employees E
JOIN Departments D ON E.DeptID = D.DeptID;

-- 3. Create ChicagoEmployees View
CREATE VIEW ChicagoEmployees AS
SELECT E.*
FROM Employees E
JOIN Departments D ON E.DeptID = D.DeptID
WHERE D.Location = 'Chicago';

-- 4. Update the HighEarners View to Include DeptID
DROP VIEW HighEarners;
CREATE VIEW HighEarners AS
SELECT Name, Salary, DeptID
FROM Employees
WHERE Salary > 60000;

-- 5. Try to update salary via HighEarners view (may or may not be allowed depending on DB)
UPDATE HighEarners
SET Salary = 80000
WHERE Name = 'Eve';

-- 6. Delete the ChicagoEmployees View
DROP VIEW ChicagoEmployees;

-- Bonus Challenge: DepartmentStats View
CREATE VIEW DepartmentStats AS
SELECT D.DeptName, COUNT(E.EmpID) AS NumEmployees
FROM Departments D
LEFT JOIN Employees E ON D.DeptID = E.DeptID
GROUP BY D.DeptName;
