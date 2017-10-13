<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="Req">
		<TranData>
			<xsl:apply-templates select="Head/Sender" />
			<Body>
				<ServiceType>3</ServiceType> <!--1:缴费冲正  2：保单打印冲正 3:缴费和单证一起冲正 -->
				<ContNo>
					<xsl:value-of select="Body/PolItem/PolNo" />
				</ContNo>
				<ProposalPrtNo></ProposalPrtNo>
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="Sender">
		<Head>
			<TranDate>
				<xsl:value-of select="BusDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="BrchId" /><xsl:value-of select="SubBrchId" />
			</NodeNo>	
			<SourceType>
				<xsl:apply-templates select="ChanNo" />
			</SourceType>			
			<BankCode><xsl:value-of select="../TranCom/@outcode"/></BankCode>	
			<xsl:copy-of select="../ClientIp" />
			<xsl:copy-of select="../FuncFlag" />
			<xsl:copy-of select="../TranCom" />
		</Head>
	</xsl:template>	
	<!-- 渠道 -->
	<xsl:template name="ChanNo" match="ChanNo">
		<xsl:choose>
			<xsl:when test=".=00">0</xsl:when>	<!-- 柜面 -->
			<xsl:when test=".=21">1</xsl:when>	<!-- 个人网银 -->
			<xsl:when test=".=51">17</xsl:when>	<!-- 手机银行 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
