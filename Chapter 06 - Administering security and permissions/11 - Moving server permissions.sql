--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
-- T-SQL SAMPLE 11
--
SELECT DISTINCT
	PERMISSION_STATE = RM.STATE_DESC
	, PERMISSION = RM.PERMISSION_NAME
	, PRINCIPAL_NAME = QUOTENAME(U.NAME)
	, PRINCIPAL_TYPE = U.TYPE_DESC
	, CREATETSQL_SOURCE = RM.STATE_DESC + N' ' + RM.PERMISSION_NAME + 
		CASE WHEN E.NAME IS NOT NULL THEN ' ON ENDPOINT::[' + E.NAME + ']' ELSE '' END +
		N' TO ' + CAST(QUOTENAME(U.NAME COLLATE DATABASE_DEFAULT) AS NVARCHAR(256)) + ';'
FROM SYS.SERVER_PERMISSIONS RM
	INNER JOIN SYS.SERVER_PRINCIPALS U ON RM.GRANTEE_PRINCIPAL_ID = U.PRINCIPAL_ID
	LEFT OUTER JOIN SYS.ENDPOINTS E ON E.ENDPOINT_ID = MAJOR_ID AND CLASS_DESC = 'ENDPOINT'
WHERE 
	-- IGNORE SYSTEM ACCOUNTS
	U.NAME NOT LIKE '##%' 
	-- IGNORE BUILT-IN ACCOUNTS
	AND U.NAME NOT IN ('DBO', 'SA') 
ORDER BY RM.PERMISSION_NAME, QUOTENAME(U.NAME);