/**
    exec sp_get_member_data
        @start_page = 1,
        @page_size = 10,
        @field_sort = 'name:asc,policyNo:asc',
        @search_text = NULL
 */
ALTER PROCEDURE sp_get_member_data
    @start_page INT = 1,
    @page_size INT = 10,
    @field_sort VARCHAR(255) = 'name:asc,policyNo:asc',
    @search_text VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @query NVARCHAR(MAX),
        @offset INT,
        @order_by NVARCHAR(MAX);

    SET @offset = (@start_page - 1) * @page_size;

    ---------------------------------------------------
    -- Convert sort string
    ---------------------------------------------------
    SET @order_by = REPLACE(@field_sort, ':', ' ');
    SET @order_by = REPLACE(@order_by, ',', ', ');
    IF @order_by IS NULL OR LTRIM(RTRIM(@order_by)) = ''
        SET @order_by = 'name ASC';

    ---------------------------------------------------
    -- Base Query (pakai parameterized @p_search)
    ---------------------------------------------------
    SET @query = N'
        SELECT
            id,
            birthDate,
            company,
            createdAt,
            eDate,
            empID,
            groupID,
            memberNo,
            name,
            policyNo,
            sDate,
            sex,
            status,
            terminate,
            toc,
            updatedAt,
            COUNT(1) OVER() AS total_data
        FROM member_data
        WHERE 1=1
    ';

    ---------------------------------------------------
    -- Dynamic Search Logic
    ---------------------------------------------------
    IF @search_text IS NOT NULL AND LTRIM(RTRIM(@search_text)) <> ''
        BEGIN
            SET @query += N'
            AND (
                CAST(toc AS NVARCHAR(50)) = @p_search OR
                empID LIKE ''%'' + @p_search + ''%'' OR
                policyNo LIKE ''%'' + @p_search + ''%'' OR
                memberNo LIKE ''%'' + @p_search + ''%'' OR
                name LIKE ''%'' + @p_search + ''%'' OR
                company LIKE ''%'' + @p_search + ''%'' OR
                status LIKE ''%'' + @p_search + ''%'' OR
                terminate LIKE ''%'' + @p_search + ''%''
        ';

            IF ISDATE(@search_text) = 1
                SET @query += N'
                OR CONVERT(DATE, birthDate) = CONVERT(DATE, @p_search)
                OR CONVERT(DATE, sDate) = CONVERT(DATE, @p_search)
                OR CONVERT(DATE, eDate) = CONVERT(DATE, @p_search)
            ';

            SET @query += N')';
        END;

    ---------------------------------------------------
    -- Pagination & Sorting
    ---------------------------------------------------
    SET @query += N'
        ORDER BY ' + @order_by + '
        OFFSET ' + CAST(@offset AS NVARCHAR(20)) + ' ROWS
        FETCH NEXT ' + CAST(@page_size AS NVARCHAR(20)) + ' ROWS ONLY;
    ';

    ---------------------------------------------------
    -- Execute Securely
    ---------------------------------------------------
    EXEC sp_executesql
         @query,
         N'@p_search NVARCHAR(255)',
         @p_search = @search_text;
END;
GO

