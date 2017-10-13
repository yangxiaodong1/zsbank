<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:template match="/TranData">
	<TranData>
	 <Head>
			<xsl:copy-of select="Head/TranDate" />
			<xsl:copy-of select="Head/TranTime" />
			<xsl:copy-of select="Head/TellerNo" />
			<xsl:copy-of select="Head/TranNo" />
			<NodeNo>
				<xsl:value-of select="Head/ZoneNo" /><xsl:value-of select="Head/NodeNo" />
			</NodeNo>
			<xsl:copy-of select="Head/FuncFlag" />
			<xsl:copy-of select="Head/ClientIp" />
			<xsl:copy-of select="Head/TranCom" />
			<BankCode>
				<xsl:value-of select="Head/TranCom/@outcode" />
			</BankCode>
     </Head>
    <Body>
      <ContNo><xsl:value-of select="Body/ContNo"/></ContNo> <!-- ���յ��� -->
      <ProposalPrtNo><xsl:value-of select="Body/ProposalPrtNo"/></ProposalPrtNo> <!-- Ͷ����(ӡˢ)�� -->
      <ContPrtNo><xsl:value-of select="Body/ContPrtNo"/></ContPrtNo> <!-- ������ͬӡˢ�� -->
    </Body>
	</TranData>
</xsl:template>
</xsl:stylesheet>
