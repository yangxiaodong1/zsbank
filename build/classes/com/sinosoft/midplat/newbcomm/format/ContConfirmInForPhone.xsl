<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="Req">
		<TranData>
			<xsl:apply-templates select="Head/Sender" />
			<Body>
				<!--原交易流水号 -->
				<OrigTranNo>
					<xsl:value-of select="Head/Sender/OriSeqNo" />
				</OrigTranNo>
				<!-- 保单号，银行不给，自己从tranlog表里查 -->
				<ContNo></ContNo>
				<!--保单印刷号-->
				<ContPrtNo></ContPrtNo>
				<!--投保单号码 -->
				<ProposalPrtNo>
					<xsl:value-of select="Body/PolItem/ApplyNo" />
				</ProposalPrtNo>
				<!-- 首期保费账户名 -->
				<AccName><xsl:value-of select="Body/PolItem/CusActItem/ActName" /></AccName>
				<!-- 首期保费账户号 -->
        		<AccNo><xsl:value-of select="Body/PolItem/CusActItem/ActNo" /></AccNo>        			
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
