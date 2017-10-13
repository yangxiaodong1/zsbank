<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/TranData">
<INSUREQRET>
	<xsl:copy-of select="Head" />
    <MAIN>	    
	  	<CORP_DEPNO></CORP_DEPNO>
		<CORP_AGENTNO></CORP_AGENTNO>
		<TRANSRNO_ORI></TRANSRNO_ORI>
	  	<!-- 如果交易成功，才返回下面的结点 -->
		<xsl:if test="Head/Flag='0'">
		<INSUREAMT><xsl:value-of select ="Body/ActSumPrem"/></INSUREAMT>
		</xsl:if> <!-- 如果交易成功，才返回上面的结点 -->			
    </MAIN>
</INSUREQRET>
</xsl:template>
</xsl:stylesheet>