<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
<xsl:template match="/">

	<xsl:apply-templates select="package/req" />

</xsl:template>


<xsl:template match="package/req">
<TranData>
 	<Head>
		<TranDate><xsl:value-of select="transexedate"/></TranDate>
		<TranTime><xsl:value-of select="transexetime"/></TranTime>
		<TellerNo><xsl:value-of select="teller"/></TellerNo>
		<TranNo><xsl:value-of select="transrefguid"/></TranNo>
		<NodeNo>
			<xsl:value-of select="regioncode"/>
			<xsl:value-of select="branch"/>
		</NodeNo>
		<xsl:copy-of select="../Head/*"/>
		<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	</Head>
	
	<Body>
		<!-- ���յ����� -->
		<ContNo><xsl:value-of select="polnumber" /></ContNo>
		<!-- ��ȫ�������� (yyyy-mm-dd)-->
		<EdorAppDate><xsl:value-of select="transexedate" /></EdorAppDate>
		<!-- ��ȫ����� -->
		<EdorAppNo />
		<!-- ҵ���Ԫ�� -->
		<TranMoney><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(amount)" /></TranMoney>
		<!-- ҵ������: CT=�˱���WT=���ˣ�CA=�޸Ŀͻ���Ϣ��MQ=���ڣ�XQ=����, PN=��� -->
		<EdorType>PN</EdorType>
		
	</Body>
</TranData>
</xsl:template>
	
</xsl:stylesheet>
