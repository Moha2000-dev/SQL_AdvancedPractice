-- 1. Scalar function to return month name
CREATE FUNCTION GetMonthName (@date DATE)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN DATENAME(MONTH, @date)
END;
GO

-- 2. Multi-statement table-valued function: return values between two integers
CREATE FUNCTION GetValuesBetween (@start INT, @end INT)
RETURNS @Values TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @start
    WHILE @i <= @end
    BEGIN
        INSERT INTO @Values VALUES (@i)
        SET @i = @i + 1
    END
    RETURN
END;
GO

-- 3. Inline table-valued function: Student No to Department Name + Full Name
CREATE FUNCTION GetStudentDetails (@StudentNo INT)
RETURNS TABLE
AS
RETURN (
    SELECT Dept_Name, St_Fname + ' ' + St_Lname AS FullName
    FROM Student s 
    JOIN Department d ON d.Dept_Id = s.Dept_Id
    WHERE St_Id = @StudentNo
);
GO
select * from dbo.GetStudentDetails(1)
GO

-- 4. Scalar function: Return null message based on Student ID
CREATE FUNCTION CheckStudentNameNulls (@StudentID INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @FirstName VARCHAR(50)
    DECLARE @LastName VARCHAR(50)
    DECLARE @Result VARCHAR(100)

    SELECT 
        @FirstName = St_Fname, 
        @LastName = St_Lname
    FROM Student
    WHERE St_Id = @StudentID

    IF @FirstName IS NULL AND @LastName IS NULL
        SET @Result = 'First name & last name are null'
    ELSE IF @FirstName IS NULL
        SET @Result = 'First name is null'
    ELSE IF @LastName IS NULL
        SET @Result = 'Last name is null'
    ELSE
        SET @Result = 'First name & last name are not null'

    RETURN @Result
END;

GO
select dbo.CheckStudentNameNulls(1)
GO
-- 5. Inline table-valued function: Manager ID to department + manager info
CREATE FUNCTION GetManagerDetails (@ManagerID INT)
RETURNS TABLE
AS
RETURN (
    SELECT Dept_Name, Dept_Manager AS ManagerName, Manager_hiredate AS HireDate
    FROM Department
    WHERE Dept_Manager = @ManagerID
);
GO
select * from dbo.GetManagerDetails(1)
GO
-- 6. Multi-statement table-valued function: Get student name by input string
CREATE FUNCTION GetStudentNameByType (@Type VARCHAR(20))
RETURNS @Result TABLE (Value VARCHAR(100))
AS
BEGIN
    IF @Type = 'first name'
        INSERT INTO @Result SELECT ISNULL(St_Fname, 'N/A') FROM Student;
    ELSE IF @Type = 'last name'
        INSERT INTO @Result SELECT ISNULL(St_Lname, 'N/A') FROM Student;
    ELSE IF @Type = 'full name'
        INSERT INTO @Result SELECT ISNULL(St_Fname, '') + ' ' + ISNULL(St_Lname, '') FROM Student;
    RETURN;
END;
GO


-- 7. Cursor to update Employee salary in company DB
USE CompanyDB;
GO

CREATE PROCEDURE UpdateSalariesWithCursor
AS
BEGIN
    DECLARE @ID INT, @Salary DECIMAL(10,2)

    DECLARE SalaryCursor CURSOR FOR
    SELECT ssn, Salary FROM Employee

    OPEN SalaryCursor

    FETCH NEXT FROM SalaryCursor INTO @ID, @Salary

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @Salary < 3000
            UPDATE Employee SET Salary = Salary * 1.1 WHERE ssn = @ID
        ELSE
            UPDATE Employee SET Salary = Salary * 1.2 WHERE ssn = @ID

        FETCH NEXT FROM SalaryCursor INTO @ID, @Salary
    END

    CLOSE SalaryCursor
    DEALLOCATE SalaryCursor
END;
GO
EXEC UpdateSalariesWithCursor;

