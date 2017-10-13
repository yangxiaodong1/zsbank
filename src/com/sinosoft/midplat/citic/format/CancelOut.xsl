<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head"/>
     <Transaction_Body>
		<xsl:apply-templates select="TranData/Body" />
	</Transaction_Body>
</Transaction>
</xsl:template>

<!-- ���ʣ�name="Transaction_Body" �еı��������������Ϸ���ͬ��ô���������һ����ô��������֤���� -->
<!-- �ҷ��ĵ��У����ճ��������Ǽ򵥽��ף���Ӧ���壬��λ�ȡ�������е�Ӧ�������е���Ӧֵ -->
<xsl:template name="Transaction_Body" match="Body">
	<PbInsuType></PbInsuType>	<!-- ���ִ���-�Ǳ��� -->
	<PbInsuSlipNo><xsl:value-of select="ContNo"/></PbInsuSlipNo><!-- ��������-���� -->
	<PbHoldName></PbHoldName>	<!-- Ͷ��������-�Ǳ��� -->
	<LiRcgnName></LiRcgnName>	<!-- ����������-�Ǳ��� -->
	<LiLoanValue><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></LiLoanValue>	<!-- �˱����-���� -->
	<BkAcctNo></BkAcctNo>	<!-- �����ʺ�-�Ǳ��� -->
</xsl:template>

</xsl:stylesheet>
