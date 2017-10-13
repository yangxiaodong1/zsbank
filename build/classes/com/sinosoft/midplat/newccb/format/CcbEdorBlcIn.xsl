<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

<xsl:template match="/">
	<!-- 新契约对账 -->
	<TranData>
		<!-- 报文头 -->
		<Head>
			<xsl:copy-of select="TranData/Head/*" />
		</Head>
		<Body>
			<PubContInfo>
				<!-- 对账 -->
				<EdorFlag>8</EdorFlag>
				<!-- 对账：1=对账，0=不对账 -->
				<CTBlcType>0</CTBlcType>
				<!-- 对账：1=对账，0=不对账 -->
				<WTBlcType>0</WTBlcType>
				<!-- 对账：1=对账，0=不对账 -->
				<MQBlcType>0</MQBlcType>
				<!-- 对账：1=对账，0=不对账 -->
				<XQBlcType>0</XQBlcType>
				<!-- 对账：1=对账，0=不对账 -->
				<xsl:if test="count(//DetailList/Detail[ORG_TX_ID='P53819161']) &gt; 0">
					<CABlcType>1</CABlcType>
				</xsl:if>
				<xsl:if test="count(//DetailList/Detail[ORG_TX_ID='P53819161']) = 0 ">
					<CABlcType>0</CABlcType>
				</xsl:if>
			</PubContInfo>
			
			<!-- 只映射犹豫期退保的保单or修改客户信息的保单 -->
			<xsl:apply-templates select="(//DetailList/Detail[ORG_TX_ID='P53819161'])"/>
		</Body>
	</TranData>
</xsl:template>

<xsl:template name="Body" match="Detail">
	<Detail>
		<TranNo><xsl:value-of select="RqPtTcNum"/></TranNo>
		<BankCode><xsl:value-of select="CCBIns_ID" /></BankCode>
		<EdorType>
			<xsl:call-template name="tran_EdorType">
				<xsl:with-param name="edorType" select="ORG_TX_ID" />
			</xsl:call-template>
		</EdorType>
		<EdorAppNo><xsl:value-of select="InsPolcy_Vchr_No" /></EdorAppNo>
		<EdorNo></EdorNo>
		<!-- 
		<EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Txn_Dt)"/></EdorAppDate>
		 -->
		<EdorAppDate><xsl:value-of select="Txn_Dt"/></EdorAppDate>
		<ContNo><xsl:value-of select="InsPolcy_No"/></ContNo>
		<RiskCode></RiskCode>
		<TranMoney />
		<AccNo></AccNo>
		<AccName></AccName>
		<!-- 响应码 0成功，1失败 -->
		<RCode>0</RCode>
	</Detail>
</xsl:template>

<!-- 证件类型转换 -->
<xsl:template name="tran_EdorType">
	<xsl:param name="edorType" />
	<xsl:choose>
		<xsl:when test="$edorType='P53819161'">CA</xsl:when>	<!-- 修改客户信息（修改保单基本信息） -->
		<xsl:otherwise></xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>