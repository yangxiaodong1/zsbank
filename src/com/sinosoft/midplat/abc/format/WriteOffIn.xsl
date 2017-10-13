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
      <ContNo><xsl:value-of select="Base/ContNo"/></ContNo> <!-- ���յ��� -->
      <ProposalPrtNo><xsl:value-of select="Base/ProposalContNo"/></ProposalPrtNo> <!-- Ͷ����(ӡˢ)�� -->
      <ContPrtNo></ContPrtNo> <!-- ������ͬӡˢ�� -->
    </Body>
	</TranData>
</xsl:template>
</xsl:stylesheet>
