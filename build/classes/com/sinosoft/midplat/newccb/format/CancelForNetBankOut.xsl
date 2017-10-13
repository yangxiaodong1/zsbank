<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
			   <CnclIns_Amt></CnclIns_Amt>
			   <Cvr_ID></Cvr_ID>
			   <CCB_AccNo></CCB_AccNo>
			   <AgIns_Pkg_ID></AgIns_Pkg_ID>
			   <InsPolcy_No></InsPolcy_No>
			   <Plchd_Nm></Plchd_Nm>
			   <Rcgn_Num>0</Rcgn_Num>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>



</xsl:stylesheet>

