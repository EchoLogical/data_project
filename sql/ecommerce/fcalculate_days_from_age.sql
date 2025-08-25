-- =============================================
-- fCalculateDaysFromAge: hitung jumlah hari berdasarkan umur (tahun) relatif ke hari ini
-- LB = jumlah hari dalam @age tahun terakhir
-- NB = jumlah hari dalam @age tahun ke depan
-- RB = jumlah hari yang lebih kecil antara LB dan NB
CREATE FUNCTION [dbo].[fCalculateDaysFromAge]
(
    @age_rule VARCHAR(2), -- 'LB' | 'NB' | 'RB'
    @age      INT         -- umur dalam tahun
)
    RETURNS INT
AS
BEGIN
    DECLARE @today date = CAST(GETDATE() AS date);
    DECLARE @result int;

    IF @age_rule = 'LB'
        BEGIN
            -- Hari dari (hari ini - @age tahun) sampai hari ini
            SET @result = DATEDIFF(day, DATEADD(year, -@age, @today), @today);
        END
    ELSE IF @age_rule = 'NB'
        BEGIN
            -- Hari dari hari ini sampai (hari ini + @age tahun)
            SET @result = DATEDIFF(day, @today, DATEADD(year, @age, @today));
        END
    ELSE IF @age_rule = 'RB'
        BEGIN
            DECLARE @pastDays   int = DATEDIFF(day, DATEADD(year, -@age, @today), @today);
            DECLARE @futureDays int = DATEDIFF(day, @today, DATEADD(year,  @age, @today));
            -- Pilih yang lebih kecil
            SET @result = CASE WHEN @futureDays < @pastDays THEN @futureDays ELSE @pastDays END;
        END
    ELSE
        BEGIN
            SET @result = NULL;
        END

    RETURN COALESCE(@result, 0);
END
GO