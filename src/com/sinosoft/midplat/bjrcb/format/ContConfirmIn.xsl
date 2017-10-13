<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/Head" />
			<Body>
				<xsl:apply-templates select="TXLife/Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!--����ͷ��Ϣ-->
	<xsl:template name="pocket" match="Head">
		<Head>
			<TranDate>
				<xsl:value-of select="MsgSendDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="MsgSendTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OperTellerNo" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransSerialCode" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<!--��������Ϣ-->
	<xsl:template name="Body" match="Body">
		<ContNo></ContNo>
		<!-- Ͷ������ -->
		<ProposalPrtNo>
			<xsl:value-of select="PolHNo" />
		</ProposalPrtNo>
		<!-- ����ӡˢ���� -->
		<ContPrtNo>
			<xsl:value-of select="PolPrintNo" />
		</ContPrtNo>
		<!-- ԭ������ˮ�� -->
		<OldTranNo>
			<xsl:value-of select="OriginalTranNo" />
		</OldTranNo>
	</xsl:template>
</xsl:stylesheet>
