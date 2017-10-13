<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="Req">
		<TranData>
			<xsl:apply-templates select="Head/Sender" />
			<Body>
				<ServiceType>3</ServiceType> <!--1:�ɷѳ���  2��������ӡ���� 3:�ɷѺ͵�֤һ����� -->
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
	<!-- ���� -->
	<xsl:template name="ChanNo" match="ChanNo">
		<xsl:choose>
			<xsl:when test=".=00">0</xsl:when>	<!-- ���� -->
			<xsl:when test=".=21">1</xsl:when>	<!-- �������� -->
			<xsl:when test=".=51">17</xsl:when>	<!-- �ֻ����� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
