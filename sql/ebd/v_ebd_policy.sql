SELECT srvae.srvae AS ldap,-- member
       srvae.name,
       srvae.role,
       srvae_pol.policyNo,
       inqpol.CompanyName
FROM COMPINAP_SRVAE srvae
LEFT JOIN COMPINAP_SRVAE_POLICY srvae_pol ON srvae.srvae = srvae_pol.srvae
JOIN CHISS_OUT_inquiryPolicy inqpol ON srvae_pol.policyNo = inqpol.PolicyNo

UNION

-- policy yang dimiliki dept head
SELECT hir.ldap_cd_dept_head AS ldap, --change member to dept head
       srvae.name,
       srvae.role,
       srvae_pol.policyNo,
       inqpol.CompanyName
FROM SRVAE_HIERARCHY hir
LEFT JOIN COMPINAP_SRVAE_POLICY srvae_pol ON hir.ldap_cd_member = srvae_pol.srvae
LEFT JOIN COMPINAP_SRVAE srvae ON hir.ldap_cd_member = srvae.srvae
JOIN CHISS_OUT_inquiryPolicy inqpol ON srvae_pol.policyNo = inqpol.PolicyNo

UNION

-- policy yang dimilik div head
SELECT (
            SELECT TOP 1 srvae
            FROM COMPINAP_SRVAE srvae2
            WHERE srvae2.role = 'DIV_HEAD'
              AND srvae2.status = 1
            ORDER BY srvae2.updated_at DESC
        ) AS ldap, -- change member to div head
       srvae.name,
       srvae.role,
       srvae_pol.policyNo,
       inqpol.CompanyName
FROM COMPINAP_SRVAE srvae
LEFT JOIN COMPINAP_SRVAE_POLICY srvae_pol ON srvae.srvae = srvae_pol.srvae
JOIN CHISS_OUT_inquiryPolicy inqpol ON srvae_pol.policyNo = inqpol.PolicyNo