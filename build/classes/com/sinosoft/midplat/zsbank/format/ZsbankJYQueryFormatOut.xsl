<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<Body>
			<xsl:apply-templates select="Body"/>
			</Body>
		</TranData>
	</xsl:template>
	<xsl:template name="Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0��ʾ�ɹ���1��ʾʧ�� -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- ʧ��ʱ�����ش�����Ϣ -->
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">	
		
		<!-- ���յ��� -->
		<ContNo>
			<xsl:value-of select="ContNo"/>
		</ContNo>
		<!-- Ͷ�������� -->
		<AppntName>
			<xsl:value-of select="AppntName"/>
		</AppntName>
		<!-- Ͷ����֤������ -->
		<AppntIDType>
			<xsl:apply-templates select="AppntIDType"/>
		</AppntIDType>
  		<!-- Ͷ����֤���� -->
  		<AppntIDNo>
  			<xsl:value-of select="AppntIDNo"/>
  		</AppntIDNo>
  		<!-- ���� -->
  		<ActSumPrem>
  			<xsl:value-of select="ActSumPrem"/>
  		</ActSumPrem>
  		<!-- ���ɴ���� -->
  		<MaxLoanMoney>
  			<xsl:value-of select="MaxLoanMoney"/>
  		</MaxLoanMoney>
	</xsl:template>
	
	<!-- ֤������ -->
	<xsl:template name="tran_idtype" match="AppntIDType">
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
