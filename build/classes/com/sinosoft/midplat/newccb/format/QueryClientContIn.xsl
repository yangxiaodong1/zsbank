<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	<Name><xsl:value-of select="Plchd_Nm" /></Name> <!--- �ͻ����� ����--> 
	<IDType>
		<xsl:call-template name="tran_IDType">
			<xsl:with-param name="idtype" select="Plchd_Crdt_TpCd" />
		</xsl:call-template>
	</IDType> <!--- �ͻ�֤������ ����-->
	<IDNo><xsl:value-of select="Plchd_Crdt_No" /></IDNo> <!--- ֤���������--> 
	<ClientType>1</ClientType><!--- 1Ͷ����, 2 ������, Ͷ���˻򱻱��� ����-->
	<ContNo><xsl:value-of select="InsPolcy_No" /></ContNo><!--- ������ �ɿ�-->
	<!--- ����ʱ�������һ��֮��-->
	<QueryStartDate>
		<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(QRY_START_DT)" />
	</QueryStartDate> <!--- ��ѯ��ʼʱ��-->
	<QueryEndDate>
		<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(QRY_END_DT)" />
	</QueryEndDate><!--- ��ѯ��ֹʱ��-->
</xsl:template>


<!-- ֤������ת�� -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='1010'">0</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1011'">0</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1052'">1</xsl:when>	<!-- ���� -->
		<xsl:when test="$idtype='1020'">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='1030'">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='1040'">5</xsl:when>	<!-- ���ڲ� -->
		<xsl:when test="$idtype=''">9</xsl:when>	<!-- �쳣���֤ -->
		<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
