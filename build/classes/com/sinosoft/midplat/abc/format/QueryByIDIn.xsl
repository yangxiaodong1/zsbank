<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/Req">
	<TranData>
 <Head>
	    <TranDate><xsl:value-of select="BankDate"/></TranDate>
	    <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
	    <TellerNo><xsl:value-of select="TellerNo"/></TellerNo>
	    <TranNo><xsl:value-of select="TransrNo"/></TranNo>
	    <NodeNo><xsl:value-of select="ZoneNo"/><xsl:value-of select="BrNo"/></NodeNo>
	    <xsl:copy-of select="Head/*"/>
	    <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
     </Head>
    <Body>
      <IDType><xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype">
						<xsl:value-of select ="Base/AppntIDType"/>
					</xsl:with-param>
		</xsl:call-template></IDType> <!-- 保险单号 -->
      <IDNo><xsl:value-of select="Base/AppntIDNo"/></IDNo> <!-- 投保单(印刷)号 -->
    </Body>
	</TranData>
</xsl:template>
  <!-- 证件类型 -->
	 <xsl:template name="tran_IDType">
		<xsl:param name="idtype">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$idtype = 110001">0</xsl:when>	<!-- 身份证 -->
			<xsl:when test="$idtype = 110002">9</xsl:when>	<!-- 重号居民身份证 -->
			<xsl:when test="$idtype = 110003">0</xsl:when>	<!-- 临时身份证 -->
			<xsl:when test="$idtype = 110004">9</xsl:when>	<!-- 重号临时居民身份证 -->
			<xsl:when test="$idtype = 110005">5</xsl:when>	<!-- 户口簿 -->
			<xsl:when test="$idtype = 110023">1</xsl:when>	<!-- 中华人民共和国护照 -->
			<xsl:when test="$idtype = 110025">1</xsl:when>	<!-- 外国护照 -->
			<xsl:when test="$idtype = 110027">2</xsl:when>	<!-- 军官证 -->
			<xsl:when test="$idtype = 110031">2</xsl:when>	<!-- 警官证 -->
			<xsl:when test="$idtype = 110033">2</xsl:when>	<!-- 军人士兵证 -->
			<xsl:when test="$idtype = 110035">2</xsl:when>	<!-- 武警士兵证 -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
