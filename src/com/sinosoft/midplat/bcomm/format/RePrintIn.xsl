<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
	
	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="RMBP/K_TrList"/>
		
			<Body>
				<!-- 保单号 -->
				<ContNo><xsl:value-of select="RMBP/K_TrList/KR_Idx1" /></ContNo>
				<!-- 投保单号，从银保通日志表中查询-->
				<ProposalPrtNo />
				<!-- 新保单合同印刷号 -->
				<ContPrtNo>
					<xsl:value-of select="RMBP/K_Invoice/InvInfo[K_Type=100]/K_NewInvCode" />
				</ContPrtNo>
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
				<xsl:value-of select="KR_AreaNo"/><xsl:value-of select="KR_BankNo"/>
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
</xsl:stylesheet>	