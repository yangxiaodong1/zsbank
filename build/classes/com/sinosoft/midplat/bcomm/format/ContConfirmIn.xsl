<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="RMBP/K_TrList" />

			<Body>
				<!-- 投保单号 -->
				<ProposalPrtNo><xsl:value-of select="RMBP/K_TrList/KR_Idx" /></ProposalPrtNo>
				<!-- 保单印刷号 -->
				<ContPrtNo><xsl:value-of select="RMBP/K_Invoice/InvInfo[K_Type=100]/K_NewInvCode" /></ContPrtNo>
      			<ContNo></ContNo> <!-- 保险单号 -->
				
				<!-- 首期保费账户名 -->
				<xsl:choose>
					<xsl:when test="RMBP/K_BI/App/AppName=''"></xsl:when>
					<xsl:otherwise>
						<AccName>
							<xsl:value-of select="RMBP/K_BI/App/AppName" />
						</AccName>
					</xsl:otherwise>
				</xsl:choose>
				
				<!-- 首期保费账户号 -->
				<xsl:choose>
					<xsl:when test="RMBP/K_BI/Info/OpenAct=''"></xsl:when>
					<xsl:otherwise>
						<AccNo>
							<xsl:value-of select="RMBP/K_BI/Info/OpenAct" />
						</AccNo>
					</xsl:otherwise>
				</xsl:choose>
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头结点 -->
	<xsl:template name="Head" match="K_TrList">
		<Head>
			<TranDate>
				<xsl:value-of select="KR_TrDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="KR_TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="KR_TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="KR_SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="KR_AreaNo" />
				<xsl:value-of select="KR_BankNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

</xsl:stylesheet>


