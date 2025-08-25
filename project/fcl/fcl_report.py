from db_con.compass_dwh import dwh_con
from tabulate import tabulate

@dwh_con
def fetch_data(db):
    policy_no = input("Enter policyNo: ").strip()

    rows, headers = db.execute_query("""
        DECLARE @PolicyNo VARCHAR(20) = '{policy_no}';

        SELECT
            tlh.polno AS PolicyNo, -- 0
            tlh.suboffcode AS SubOfficeCode, -- 1
            tlh.suboffname AS SubOfficeName,-- 2
            CONCAT(LTRIM(RTRIM(tlh.certno)), '-', tlh.depcode) AS CertNo, -- 3
            tlh.namelast AS NameOfMember,-- 4
            tlh.depcode AS DepCode, -- 5
            tlh.deptype AS DepType, -- 6
            tlh.dob AS DoB, -- 7
            tlh.sex AS Gender, -- 8
            tpd.prodcode AS ProductCode, -- 9
            tp.prodname AS ProductName, -- 10
            ISNULL((CAST(tpd.prolfia AS FLOAT)), tpolben.BENMULMB) AS UpProposed, -- 11
            tpd.nelamt AS NelPolis, -- 12
            ISNULL((CAST(tpd.prolfia AS FLOAT) - CAST(tpd.nelamt AS FLOAT)), tpolben.BENMULMB) AS UpProprosedNelPolis, -- 13
            ISNULL(
                STUFF(
                    (SELECT DISTINCT ', ' + LTRIM(RTRIM(b.medreqdesc))
                     FROM dbo.TUWLTRDETAILH b WITH (NOLOCK)
                     WHERE b.polno = tlh.polno
                       AND b.certno = tlh.certno
                       AND b.depcode = tlh.depcode
                       AND b.namelast = tlh.namelast
                       AND b.trandate BETWEEN
                           (SELECT POLDTFR FROM dbo.tpolyear
                            WHERE POLNO = @PolicyNo
                              AND POLYEAR = (SELECT MAX(POLYEAR) FROM dbo.tpolyear
                                             WHERE POLDTFR < GETDATE() AND POLNO = @PolicyNo))
                       AND
                           (SELECT POLDTTO FROM dbo.tpolyear
                            WHERE POLNO = @PolicyNo
                              AND POLYEAR = (SELECT MAX(POLYEAR) FROM dbo.tpolyear
                                             WHERE POLDTFR < GETDATE() AND POLNO = @PolicyNo))
                     FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),
                    1, 2, ''
                ), ''
            ) AS MedDesc, -- 14
            tlh.APPRCVDATE AS RcvDate, -- 15
            (
                SELECT TOP 1
                    tpd_1.UWSTATUS
                FROM dbo.TUWLTRDETAILH tlh_1 WITH (NOLOCK)
                JOIN dbo.TUWLTRDETAILPDTH tpd_1 WITH (NOLOCK)
                    ON tlh_1.uwcaseno = tpd_1.uwcaseno
                    AND tlh_1.polno = tpd_1.polno
                    AND tlh_1.certno = tpd_1.certno
                    AND tlh_1.depcode = tpd_1.depcode
                    AND tlh_1.trandate = tpd_1.trandate
                where tlh_1.POLNO = tlh.POLNO
                  AND tlh_1.suboffcode = tlh.SUBOFFCODE
                  AND tlh_1.suboffname = tlh.SUBOFFNAME
                  AND tlh_1.certno = tlh.CERTNO
                  AND tlh_1.DEPCODE = tlh.DEPCODE
                  AND tlh_1.namelast = tlh.NAMELAST
                  AND tlh_1.deptype = tlh.DEPTYPE
                  AND tlh_1.sex = tlh.SEX
                  AND tpd_1.prodcode = tpd.PRODCODE
                  AND tpd_1.prolfia = tpd.prolfia
                  AND tpd_1.nelamt = tpd.nelamt
                  AND tpd_1.inflfia = tpd.inflfia
                ORDER BY tpd_1.TRANDATE DESC
            ) AS Status, -- 16
            tpd.inflfia AS UpLast, -- 17
            tmem.MemberStatus AS MemberStatus -- 18
        FROM dbo.TUWLTRDETAILH tlh WITH (NOLOCK)
        JOIN dbo.TUWLTRDETAILPDTH tpd WITH (NOLOCK)
            ON tlh.uwcaseno = tpd.uwcaseno
            AND tlh.polno = tpd.polno
            AND tlh.certno = tpd.certno
            AND tlh.depcode = tpd.depcode
            AND tlh.trandate = tpd.trandate
        JOIN dbo.TPRODUCT tp WITH (NOLOCK)
            ON tpd.prodcode = tp.prodcode
        JOIN (
            SELECT
                POLDTFR AS StartDate,
                POLDTTO AS EndDate,
                POLYEAR AS PolYear
            FROM dbo.tpolyear
            WHERE POLNO = @PolicyNo
              AND POLYEAR = (
                  SELECT MAX(POLYEAR)
                  FROM dbo.tpolyear
                  WHERE POLDTFR < GETDATE()
                  AND POLNO = @PolicyNo
              )
        ) AS pyr
            ON tlh.trandate BETWEEN pyr.StartDate AND pyr.EndDate
        JOIN TPOLICY tpol WITH (NOLOCK)
            ON tlh.POLNO = tpol.POLNO
        JOIN (
            SELECT
                certno,
                CLNTCODE,
                STATUS AS MemberStatus
            FROM dbo.TMEMBER tmem WITH (NOLOCK)
            WHERE CHGEFFDT = (
                SELECT MAX(CHGEFFDT)
                FROM dbo.TMEMBER
                WHERE certno = tmem.certno
                  AND CLNTCODE = tmem.CLNTCODE
            )
        ) AS tmem
            ON tlh.CERTNO = tmem.CERTNO
            AND tlh.CLNTCODE = tmem.CLNTCODE
        LEFT JOIN (
            SELECT
                BENMULMB,
                POLNO,
                EFFDATE,
                PRODCODE,
                BENPLNCD
            FROM TPOLPDTBEN
            WHERE POLNO = @PolicyNo
            AND EFFDATE = (
                SELECT MAX(EFFDATE) FROM TPOLPDTBEN
                WHERE POLNO = @PolicyNo
            )
            GROUP BY POLNO, BENMULMB, EFFDATE, PRODCODE, BENPLNCD
        ) AS tpolben
            ON tpolben.EFFDATE = tpd.EFFDATE
            AND tpolben.POLNO = tpd.POLNO
            AND tpolben.PRODCODE = tpd.PRODCODE
            AND tpolben.BENPLNCD = tpd.BENPLNCD
        WHERE tpd.uwstatus != 'B'
          AND tlh.polno = @PolicyNo
          AND tpol.STATUS = 'A'
          AND tmem.MemberStatus = 'A'
        GROUP BY
            tlh.polno, tlh.suboffcode, tlh.suboffname, tlh.certno, tlh.namelast,
            tlh.depcode, tlh.deptype, tlh.dob, tlh.sex,
            tpd.prodcode, tp.prodname, tpd.prolfia, tpd.nelamt,
            tlh.APPRCVDATE, tpd.inflfia, tmem.MemberStatus,
            tpolben.BENMULMB
        ORDER BY tlh.namelast;
    """.format(policy_no=policy_no))
    if rows:
        print(tabulate(rows, headers=headers, tablefmt="grid"))
    else:
        print("No data returned.")


fetch_data()
