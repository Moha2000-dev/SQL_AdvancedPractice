
#  SQL Advanced Practice

This repository contains practical SQL exercises exploring advanced database concepts including `UNION`, `Subqueries`, `Transactions`, 
and destructive commands like `DELETE`, `TRUNCATE`, 
and `DROP`. The practice is based on a simulated **Training & Job Application System**.

---

##  Contents

- `SQL-AdvancedPractice.sql` – Main script with all tasks and answers
- Topics covered:
  -  UNION vs UNION ALL
  -  DROP vs DELETE vs TRUNCATE
  -  Subqueries in SELECT, WHERE, FROM
  -  Transaction blocks and rollback control
  - ACID properties explained with examples

---

##  Scenario: Training & Job Application System

Two datasets managed by the institute:
- **Trainees**: Completed training programs.
- **Applicants**: People who applied for jobs.

### Goals:
- Compare data from both groups
- Clean or manipulate the database safely
- Explore and apply advanced SQL techniques

---

##  Practice Summary

###  UNION & INTERSECT Simulation
```sql
-- Unique people from both tables
SELECT FullName, Email FROM Trainees
UNION
SELECT FullName, Email FROM Applicants;

-- With duplicates (UNION ALL)
SELECT FullName, Email FROM Trainees
UNION ALL
SELECT FullName, Email FROM Applicants;

-- People in both tables
SELECT T.FullName, T.Email 
FROM Trainees T
INNER JOIN Applicants A ON T.Email = A.Email;
````

---

###  DROP, DELETE, TRUNCATE

```sql
-- DELETE specific rows
DELETE FROM Trainees WHERE Program = 'Outsystems';

-- TRUNCATE all data (faster, irreversible)
TRUNCATE TABLE Applicants;

-- DROP the entire table
DROP TABLE Applicants;
```

 **Observations**:

* DELETE: keeps table structure
* TRUNCATE: removes all data, can’t roll back easily
* DROP: deletes table completely

---

##  Subqueries

### What is a subquery?

* A query inside another query.
* Used in SELECT, FROM, or WHERE.

### Subquery examples:

```sql
-- Emails in both tables
SELECT * FROM Trainees
WHERE Email IN (SELECT Email FROM Applicants);

-- DELETE using subquery
DELETE FROM Applicants
WHERE Email IN (SELECT Email FROM Trainees);
```

---

##  Transactions

### What is a SQL transaction?

* A group of SQL commands that run together.
* All succeed or all fail (Atomicity).

### Syntax:

```sql
BEGIN TRANSACTION;

BEGIN TRY
  INSERT INTO Applicants VALUES (104, 'Zahra Al Amri', 'zahra.a@example.com', 'Referral', '2025-05-10');
  INSERT INTO Applicants VALUES (104, 'Error User', 'error@example.com', 'Website', '2025-05-11'); -- Duplicate
  COMMIT;
END TRY
BEGIN CATCH
  ROLLBACK;
  PRINT 'Transaction failed. Rolled back.';
END CATCH;
```

---

##  ACID Properties

| Property    | Meaning                                         | Real-life Example                         |
| ----------- | ----------------------------------------------- | ----------------------------------------- |
| Atomicity   | All steps succeed or none at all                | Bank transfer (deduct + deposit together) |
| Consistency | Data stays valid before and after a transaction | FK check on inserting a student           |
| Isolation   | Transactions don't affect each other            | Two people booking tickets at once        |
| Durability  | Committed data stays saved even after crash     | Order still exists after power outage     |

---





