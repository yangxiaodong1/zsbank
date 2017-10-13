<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date10to8(TransExeDate)" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TransExeTime)" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OLifEExtension/Teller" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="OLifEExtension/RegionCode" />
				<xsl:value-of select="OLifEExtension/Branch" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>


	<xsl:template name="Body" match="Policy">
		<ContNo>
			<xsl:value-of select="PolNumber" />
		</ContNo><!-- ���յ����� --><!--������ -->
		<ContNoPSW></ContNoPSW><!-- �������� -->
		<RiskCode>
			<xsl:apply-templates select="ProductCode" /><!-- ��Ʒ���� -->
		</RiskCode><!-- ���ղ�Ʒ���� �����գ� -->
		<EdorAppDate>
			<xsl:value-of
				select="java:com.sinosoft.midplat.common.DateUtil.date10to8(../../../TransExeDate)" />
		</EdorAppDate><!-- ��������[yyyyMMdd] --><!--������ -->
		<CertifyCode></CertifyCode><!-- ����ӡˢ�� --><!-- �Ǳ����� -->
		<!-- Ͷ���� -->
		<xsl:variable name="AppntPartyID"
			select="../../Relation[RelationRoleCode='80']/@RelatedObjectID" />
		<xsl:variable name="AppntPartyNode" select="../../Party[@id=$AppntPartyID]" />
		<AppntIDType>
			<xsl:apply-templates select="$AppntPartyNode/GovtIDTC" />
		</AppntIDType>
		<AppntIDNo>
			<xsl:value-of select="$AppntPartyNode/GovtID" />
		</AppntIDNo>
		<AppntName>
			<xsl:value-of select="$AppntPartyNode/FullName" />
		</AppntName>
		<!-- Ͷ���� -->
		<xsl:variable name="InsuredPartyID"
			select="../../Relation[RelationRoleCode='81']/@RelatedObjectID" />
		<xsl:variable name="InsuredPartyNode" select="../../Party[@id=$InsuredPartyID]" />
		<InsuredIDType>
			<xsl:apply-templates select="$InsuredPartyNode/GovtIDTC" />
		</InsuredIDType>
		<InsuredIDNo>
			<xsl:value-of select="$InsuredPartyNode/GovtID" />
		</InsuredIDNo>
		<InsuredName>
			<xsl:value-of select="$InsuredPartyNode/FullName" />
		</InsuredName>
	</xsl:template>

<!-- ���ִ��� -->
<xsl:template name="tran_RiskCode" match="ProductCode">
<xsl:choose>
	<xsl:when test=".=001">122001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=002">122002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=101">122004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=003">122003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=004">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test=".=005">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
	<xsl:when test=".=006">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
	<xsl:when test=".=007">122011</xsl:when>	<!-- ����ʢ��1���������գ������ͣ�  -->
	<xsl:when test=".=008">122012</xsl:when>	<!-- ����ʢ��2���������գ������ͣ�  -->
	<xsl:when test=".=009">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ�  -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ֤������ -->
<xsl:template name="tran_idtype" match="GovtIDTC">
<xsl:choose>
	<xsl:when test=".=0">0</xsl:when>	<!-- ���֤ -->
	<xsl:when test=".=1">1</xsl:when>	<!-- ���� -->
	<xsl:when test=".=2">2</xsl:when>	<!-- ����֤ -->
	<xsl:when test=".=3">2</xsl:when>	<!-- ʿ��֤ -->
	<xsl:when test=".=5">0</xsl:when>	<!-- ��ʱ���֤ -->
	<xsl:when test=".=6">5</xsl:when>	<!-- ���ڱ�  -->
	<xsl:when test=".=9">2</xsl:when>	<!-- ����֤  -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>


	

