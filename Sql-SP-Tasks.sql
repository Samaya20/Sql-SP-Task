-- 1. SP "Factorial". SP calculates the factorial of a given number. (5! = 1 * 2 * 3 * 4 * 5 = 120 ) 
-- (the factorial of a negative number does not exist).


ALTER PROCEDURE CalcFact @Number int
AS
BEGIN
    IF @Number < 0
    BEGIN
        PRINT 'eded menfi ola bilmez';
        RETURN;
    END

    DECLARE @Result bigint = 1;
    DECLARE @Counter int = 1;

    WHILE @Counter <= @Number
    BEGIN
        SET @Result = @Result * @Counter;
        SET @Counter = @Counter + 1;
    END

    PRINT @Result 
END


EXEC CalcFact @Number = 5;



-- 2. SP "Lazy Students." SP displays students who never took books in the library 
-- and through the output parameter returns the number of these students.


CREATE PROC us_findStudents
            @numberStudents int OUT
AS
BEGIN
    SELECT Students.Id, Students.FirstName, Students.LastName
    FROM Students
    LEFT JOIN S_Cards sc ON Students.Id = sc.Id_Student
    WHERE sc.Id_Book IS NULL;

    SELECT @numberStudents = @@ROWCOUNT;
END;


DECLARE @StudentCount int;
EXEC us_findStudents @numberStudents = @StudentCount OUT;
SELECT @StudentCount



-- 8. SP "Teacher takes the book."


CREATE PROCEDURE TeacherTakesBook
    @TeacherId ]int,
    @BookId int
AS
BEGIN
    DECLARE @CheckoutDate datetime = GETDATE();

    INSERT T_Cards (Id_Teacher, Id_Book, DateOut, DateIn, Id_Lib)
    VALUES (@TeacherId, @BookId, @CheckoutDate, NULL);

    UPDATE Books
    SET Quantity = Quantity - 1
    WHERE Id = @BookId;

END

DECLARE @TeacherId INT = 1; 
DECLARE @BookId INT = 3;

EXEC TeacherTakesBook @TeacherId, @BookId;




-- 10. SP "Teacher returns book".


CREATE PROCEDURE TeacherReturnsBook
    @TeacherId int,
    @BookId int
AS
BEGIN
    DECLARE @ReturnDate datetime = GETDATE();

    UPDATE T_Cards
    SET DateIn = @ReturnDate
    WHERE 
        Id_Teacher = @TeacherId
        AND Id_Book = @BookId
        AND DateIn IS NULL;

    UPDATE Books
    SET Quantity = Quantity + 1
    WHERE Id = @BookId;

END

DECLARE @TeacherId int = 2;
DECLARE @BookId int = 5;

EXEC TeacherReturnsBook @TeacherId, @BookId;

