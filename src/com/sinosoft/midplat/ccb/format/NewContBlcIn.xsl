<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
	   <!-- 
	   <Count><xsl:value-of select="Transaction/Transaction_Body/BkTotNum"/></Count>
       <Prem><xsl:value-of select="sum(Transaction/Transaction_Body/Detail_List/Detail/BkTotAmt)*100"/></Prem>
        --><!-- 此段注释，在程序里拼报文信息 -->
	   <xsl:apply-templates select="Transaction/Transaction_Body/Detail_List/Detail"/>
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="Transaction_Header">
<Head>
	<TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	<TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
	<TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	<NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<xsl:template name="Body" match="Detail">
<xsl:if test="BkOthTxCode = 'OPR011'"><!-- 新单对账 -->
<Detail>
	<TranDate><xsl:value-of select="BkPlatDate10"/></TranDate>
	<TranNo><xsl:value-of select="BkOthSeq"/></TranNo>
	<ContNo><xsl:value-of select="PbInsuSlipNo"/></ContNo>
	<Prem><xsl:value-of select="BkTotAmt*100"/></Prem>
	<NodeNo><xsl:value-of select="BkPlatBrch"/></NodeNo>
	<TranType><xsl:value-of select="BkOthTxCode"/></TranType>
</Detail>
</xsl:if>

<xsl:if test="BkOthTxCode != 'OPR011'"><!-- 保全对账 -->
<Detail>
	<TranNo><xsl:value-of select="BkOthSeq"/></TranNo> <!-- 交易流水号 -->
    <BankCode><xsl:value-of select="BkPlatBrch"/></BankCode> <!-- 网点号 -->
    <EdorType>
      <xsl:call-template name="tran_EdorType">
		 <xsl:with-param name="edortype">
		 	<xsl:value-of select="BkOthTxCode"/>
	     </xsl:with-param>
	  </xsl:call-template>
	</EdorType>  <!-- 保全交易类型 -->
    <EdorAppNo><xsl:value-of select="BkVchNo"/></EdorAppNo> <!-- 保全申请书号码 -->
    <EdorNo><xsl:value-of select="BkVchNo"/></EdorNo> <!-- 保全批单号码[非必须] -->
    <EdorAppDate><xsl:value-of select="BkPlatDate10"/></EdorAppDate> <!-- 保全批改申请日期 YYYYMMDD-->
    <ContNo><xsl:value-of select="PbInsuSlipNo"/></ContNo> <!-- 保单号 -->
    <RiskCode><xsl:value-of select="PbInsuType"/></RiskCode> <!-- 险种代码[非必须]，如果有是主险的 -->   
    <TranMoney><xsl:value-of select="BkTotAmt*100"/></TranMoney> <!-- 交易金额 单位（分）1000000分代表10000元-->
    <AccNo></AccNo> <!-- 银行账户[非必须] -->
    <AccName></AccName> <!-- 账户姓名[非必须] --> 
    <RCode>0</RCode> <!-- 响应码 0成功，1失败-->
    <TranType><xsl:value-of select="BkOthTxCode"/></TranType>
</Detail>
</xsl:if>
</xsl:template>

<!-- 保全类型转换 -->
<xsl:template name="tran_EdorType">
    <xsl:param name="edortype">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$edortype = 'SPE010'">1</xsl:when>  <!-- 客户签约 -->
		<xsl:when test="$edortype = 'SPE013'">2</xsl:when>  <!-- 客户解约  -->
		<xsl:when test="$edortype = 'OPR002'">3</xsl:when>  <!-- 犹豫期退保查询  -->
		<xsl:when test="$edortype = 'OPR012'">4</xsl:when>  <!-- 犹豫期退保  -->
		<xsl:otherwise>OTHER</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
