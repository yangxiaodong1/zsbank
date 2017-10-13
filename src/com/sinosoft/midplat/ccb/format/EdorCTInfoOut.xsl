<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<Transaction_Body>
		<BkRecNum><xsl:value-of select="count(TranData/Body/Detail)" /></BkRecNum>
		<Detail_List>
			<xsl:apply-templates select="TranData/Body/Detail" />
		</Detail_List>
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template match="Detail">
<Detail>
	<PbInsuType>
	<xsl:call-template name="tran_riskcode">
		<xsl:with-param name="riskcode" select="RiskCode" />
	</xsl:call-template>
	</PbInsuType>
	<PbInsuSlipNo><xsl:value-of select="ContNo"/></PbInsuSlipNo>
	<BkActBrch><xsl:value-of select="NodeNo"/></BkActBrch>
	<BkActTeller><xsl:value-of select="TellerNo"/></BkActTeller>
	<PbHoldName><xsl:value-of select="AppntName"/></PbHoldName>
	<LiRcgnName><xsl:value-of select="InsuredName"/></LiRcgnName>
	<BkTotAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(SumPrem)"/></BkTotAmt>
	<BkFlag1>G</BkFlag1> <!-- 退保标志，写死为“G-保险全单犹豫期退保” -->
	<PbSlipNumb><xsl:value-of select="Mult"/></PbSlipNumb>
	<PiAmount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EdorCTPrem)"/></PiAmount>
	<BkOthTxCode>02</BkOthTxCode> <!-- 退保交易类型，写死为“02-犹豫期内退保” -->
	<PiQdDate><xsl:value-of select="SignDate"/></PiQdDate>
	<Bk8Date1><xsl:value-of select="EdorCTDate"/></Bk8Date1>
</Detail>
</xsl:template>
<!-- 险种代码 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='122001'">2001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122002'">2002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122003'">2003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122004'">2004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122005'">2005</xsl:when>	<!-- 安邦黄金鼎3号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122006'">2006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122008'">2008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
	<xsl:when test="$riskcode='122009'">2009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122010'">2010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<xsl:when test="$riskcode='122035'">2035</xsl:when>	<!-- 安邦盛世9号 -->
	<!-- 当产品为组合产品时，因银行发送的请求报文转换为标准报文后主险代码为50002，存入bak1；应答报文转换标准到非标准时会将bak1的值填写进去，因此此处不能用122046 -->
	<xsl:when test="$riskcode='50002'">2046</xsl:when>	<!-- 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成 -->
	<!-- 50006: 安邦长寿智赢1号年金保险计划,2014-08-29停售 -->
	<!-- 
	<xsl:when test="$riskcode=50006">2052</xsl:when>
	-->
	<xsl:when test="$riskcode='L12052'">2052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>