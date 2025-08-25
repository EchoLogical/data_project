CREATE FUNCTION dbo.fCalculateDays
(
    @value INT,
    @unit  VARCHAR(1) -- 'Y' (years), 'M' (months), 'D' (days)
)
    RETURNS INT
AS
BEGIN
    DECLARE @today  DATE = CAST(GETDATE() AS DATE);
    DECLARE @target DATE;

    SET @target = CASE
      WHEN @unit IN ('Y','y') THEN DATEADD(YEAR,  @value, @today)
      WHEN @unit IN ('M','m') THEN DATEADD(MONTH, @value, @today)
      WHEN @unit IN ('D','d') THEN DATEADD(DAY,   @value, @today)
      ELSE NULL
    END;

    IF @target IS NULL
        RETURN NULL; -- unit tidak valid

    RETURN DATEDIFF(DAY, @today, @target);
END
GO