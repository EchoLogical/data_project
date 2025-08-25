SELECT
    UserID,
    COUNT(*) as duplicate_count
FROM tmember
GROUP BY
    UserID
HAVING COUNT(*) > 1;

select * from tmember
where UserID = 'DSNP100';

select * from tmember
where UserID = 'DSNP109';