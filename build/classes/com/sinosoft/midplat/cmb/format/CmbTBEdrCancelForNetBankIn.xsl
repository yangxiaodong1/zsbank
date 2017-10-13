<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- head -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<!-- ���յ����� -->
                <ContNo><xsl:value-of select="TXLife/TXLifeRequest/OLife/Holding/Policy/PolNumber" /></ContNo>
                <!-- ��ȫ�������� (yyyy-mm-dd)-->
                <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></EdorAppDate>
                <!-- ��ȫ����� -->
                <EdorAppNo />
                <!-- ҵ���Ԫ�� -->
                <TranMoney />
                <!-- ��ȫ���� -->
                <EdorType>CT</EdorType>
			</Body>
		</TranData>
	</xsl:template>


	<!-- ����ͷ��� -->
	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TransExeTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TellerCode" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

</xsl:stylesheet>


