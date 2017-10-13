<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="TranData">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*" />
			</Head>
			<Body>
			    <PubContInfo>
				<!-- 对账 -->
				<EdorFlag>8</EdorFlag>
				<!-- 对账：1=对账，0=不对账 -->
				<xsl:if test="count(Body//Detail[FuncFlag='583010']) &gt; 0">
					<CTBlcType>1</CTBlcType>
				</xsl:if>
				<xsl:if test="count(Body//Detail[FuncFlag='583010']) = 0 ">
					<CTBlcType>0</CTBlcType>
				</xsl:if>
				<!-- 对账：1=对账，0=不对账 -->
				<WTBlcType>0</WTBlcType>
				<!-- 对账：1=对账，0=不对账 -->
				<MQBlcType>0</MQBlcType>
				<!-- 对账：1=对账，0=不对账 -->
				<XQBlcType>0</XQBlcType>
				<!-- 对账：1=对账，0=不对账 -->
				<CABlcType>0</CABlcType>
			</PubContInfo>
			<!-- 只映射退保的保单 -->
			<xsl:apply-templates select="(Body/Detail[FuncFlag='583010'])"/>
		   </Body>
		</TranData>
	</xsl:template>
    <xsl:template name="Body" match="Detail">
	    <Detail>
		   <TranNo><xsl:value-of select="TranNo"/></TranNo>
		   <BankCode><xsl:value-of select="//Head/BankCode"/></BankCode>
		   <EdorType>CT</EdorType>
		   <EdorAppNo></EdorAppNo>
		   <EdorNo></EdorNo>
		   <!-- 
		   <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Txn_Dt)"/></EdorAppDate>
		   -->
		   <EdorAppDate><xsl:value-of select="TranDate"/></EdorAppDate>
		   <ContNo><xsl:value-of select="ContNo"/></ContNo>
		   <RiskCode></RiskCode>
		   <TranMoney />
		   <AccNo></AccNo>
		   <AccName></AccName>
		   <!-- 响应码 0成功，1失败 -->
		   <RCode>0</RCode>
	    </Detail>
    </xsl:template>
    <!-- 交易渠道 -->
	<xsl:template match="SOURCETYPE">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 柜面 -->
			<xsl:when test=".='1'">1</xsl:when><!-- 网银 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>