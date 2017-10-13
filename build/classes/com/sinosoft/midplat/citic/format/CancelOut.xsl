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

<!-- 疑问：name="Transaction_Body" 中的变量名必须是与上方的同名么？如果随便叫一个怎么样，待验证。。 -->
<!-- 我方文档中：当日撤单交易是简单交易，无应答体，如何获取中信银行的应答报文体中的相应值 -->
<xsl:template name="Transaction_Body" match="Body">
	<PbInsuType></PbInsuType>	<!-- 险种代码-非必填 -->
	<PbInsuSlipNo><xsl:value-of select="ContNo"/></PbInsuSlipNo><!-- 保单号码-必填 -->
	<PbHoldName></PbHoldName>	<!-- 投保人姓名-非必填 -->
	<LiRcgnName></LiRcgnName>	<!-- 被保人姓名-非必填 -->
	<LiLoanValue><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></LiLoanValue>	<!-- 退保金额-必填 -->
	<BkAcctNo></BkAcctNo>	<!-- 银行帐号-非必填 -->
</xsl:template>

</xsl:stylesheet>
