<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/Transaction">
<TranData>
	<xsl:apply-templates select="TransHeader" />
	<xsl:apply-templates select="TransBody/Request" />
</TranData>
</xsl:template>

<xsl:template name="Body" match="Request">
	<Body>		
		<IDType><xsl:apply-templates select="CAppCertfCls"/></IDType><!-- Ͷ����֤������ -->
		<IDNo><xsl:value-of select="CAppCertfCde"/></IDNo> <!-- Ͷ����֤���� -->
	</Body>
</xsl:template>

<xsl:template name="Head" match="TransHeader">
	<Head>
		<TranDate><xsl:value-of select="CTransactionDate"/></TranDate>
	    <TranTime><xsl:value-of select="CTransactionTime"/></TranTime>
	    <TellerNo>sys</TellerNo>
	    <TranNo><xsl:value-of select="MessageId"/></TranNo>
	    <!-- <NodeNo><xsl:value-of select="../TransBody/Request/OrgNo"/></NodeNo> -->
		    <NodeNo>02100000</NodeNo>
	    <xsl:copy-of select="../Head/*"/>
	    <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	    <SourceType>z</SourceType> <!-- 0=����ͨ���桢1=������8=�����նˡ�z-ֱ������ -->
	</Head>
</xsl:template>

<!-- ֤������ -->
	<xsl:template name="CAppCertfCls" match="CAppCertfCls">
		<xsl:choose>
			<xsl:when test=".='01'">0</xsl:when><!-- ���֤ -->
			<xsl:when test=".='02'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='03'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='201'">6</xsl:when><!-- �۰�֤ -->
			<xsl:when test=".='202'">7</xsl:when><!-- ̨��֤ -->
			<xsl:when test=".='99'">8</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
