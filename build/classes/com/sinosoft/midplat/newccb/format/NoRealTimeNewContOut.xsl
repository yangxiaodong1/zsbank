<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<!-- 投保单号 -->
				<Ins_BillNo><xsl:value-of select="TranData/Body/ProposalPrtNo"/></Ins_BillNo>
				<!-- 保险公司派驻人员姓名 -->
				<Ins_Co_Acrdt_Stff_Nm />
				<!-- 保险公司派驻人员从业资格证书编号 -->
				<InsCoAcrStCrQuaCtf_ID />
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>

</xsl:stylesheet>

