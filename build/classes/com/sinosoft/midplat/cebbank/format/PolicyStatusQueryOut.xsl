<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="TranData/Head" />
			<!-- ������ -->
			<Body>
				<xsl:apply-templates select="TranData/Body/Detail" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- �ļ���һ����¼ -->
	<xsl:template match="Detail">
		<Detail>
			<QueryDate></QueryDate>
			<ContNo>
				<xsl:value-of select="ContNo" />
			</ContNo>
			<ContState>
				<xsl:apply-templates select="ContState" />
			</ContState>
			<SumPrem>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(SumPrem)" />
			</SumPrem>
			<LastPayDate>
				<xsl:value-of select="LastPayDate" />
			</LastPayDate>
		</Detail>
	</xsl:template>


	<!-- ����״̬ -->
	<!-- ���״̬��0 δ֪ 4 ��Ч A����  E�����˱� F���� -->
	<!-- ����״̬��00:������Ч,01:������ֹ,02:�˱���ֹ,04:������ֹ,WT:��ԥ���˱���ֹ,A:�ܱ�,B:��ǩ��, -->
	<xsl:template name="tran_contstate" match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">4</xsl:when>
			<xsl:when test=".='01'">F</xsl:when>
			<xsl:when test=".='WT'">A</xsl:when>
			<xsl:when test=".='02'">E</xsl:when>
			<xsl:when test=".='-1'">A</xsl:when> <!-- ���ճ�������ɾ������-1���ݹ�Ϊ���� -->
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
