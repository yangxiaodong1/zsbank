<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">

	<!-- �������� -->
	<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
	<!-- �������ֱ�� -->
	<MainIns_Cvr_ID></MainIns_Cvr_ID>
	<!-- �������ײͱ�� -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!-- ������ԥ�� -->
	<InsPolcy_HsitPrd></InsPolcy_HsitPrd>
	<!-- ������Ч���� -->
	<InsPolcy_EfDt></InsPolcy_EfDt>
	<!-- ����ʧЧ���� -->
	<InsPolcy_ExpDt></InsPolcy_ExpDt>
	<!-- ������ȡ���� -->
	<InsPolcy_Rcv_Dt></InsPolcy_Rcv_Dt>
	<!-- ���ѽɷѷ�ʽ���� -->
	<InsPrem_PyF_MtdCd></InsPrem_PyF_MtdCd>
	<!-- ���սɷѽ�� -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
</xsl:template>

</xsl:stylesheet>

