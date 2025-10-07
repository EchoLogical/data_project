ALTER FUNCTION dbo.fn_extractnamefromemail(@Email NVARCHAR(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @Name NVARCHAR(MAX);

    -- Split the email into the part before '@'
    SET @Name = LEFT(@Email, CHARINDEX('@', @Email) - 1);

    -- Replace '.' and '-' with a space
    SET @Name = REPLACE(@Name, '.', ' ');
    SET @Name = REPLACE(@Name, '-', ' ');

    -- Capitalize the first letter of each word with proper ordering using FOR XML PATH
    DECLARE @Result NVARCHAR(MAX);
    SELECT @Result = STUFF((
                               SELECT ' ' + UPPER(LEFT(value, 1)) + LOWER(SUBSTRING(value, 2, LEN(value)))
                               FROM STRING_SPLIT(@Name, ' ')
                               FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    RETURN @Result;
END;
GO