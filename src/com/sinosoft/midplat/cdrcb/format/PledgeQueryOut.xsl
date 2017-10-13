<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<xsl:apply-templates select="TranData/Body" />
</Transaction>
</xsl:template>

<xsl:template name="Body" match="Body">
	<TransBody>
		<Response>
			<InsurStatus><xsl:apply-templates select="MortStatu"/></InsurStatus><!-- ����״̬ -->
			<InsurAmount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></InsurAmount><!-- ���� -->
			<InsurCurAmount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueD)"/></InsurCurAmount><!-- �����ֽ��ֵ -->
			<InsurCorpNo>1</InsurCorpNo><!-- ���չ�˾��� -->
			<InsurPhoneNo><xsl:value-of select="Appnt/Mobile"/></InsurPhoneNo><!-- �������ֻ��� -->
			<InsurStartDate><xsl:value-of select="Risk[RiskCode=MainRiskCode]/CValiDate"/></InsurStartDate><!-- ������Ч���� -->
			<InsurEndDate><xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuEndDate"/></InsurEndDate><!-- ������������ -->
			<Assured><xsl:value-of select="Insured/Name"/></Assured><!-- �������� -->
			<AssuredCertType><xsl:apply-templates select="Insured/IDType"/></AssuredCertType><!-- ��������֤������ -->
			<AssuredCertId><xsl:value-of select="Insured/IDNo"/></AssuredCertId><!-- ��������֤������ -->
			<Beneficiary><xsl:value-of select="Bnf/Name"/></Beneficiary><!-- ������ -->
			<BeneCertType><xsl:apply-templates select="Bnf/IDType"/></BeneCertType><!-- ������֤������ -->
			<BeneCertId><xsl:value-of select="Bnf/IDNo"/></BeneCertId><!-- ������֤������ -->
			<InsurType>02</InsurType><!-- ��������:01-�Ʋ����գ�02-���ٱ��գ� -->
		</Response>		
	</TransBody>
</xsl:template>
<!-- ������Ѻ״̬�� 0δ��Ѻ��1��Ѻ -->
<xsl:template match="MortStatu">
	<xsl:choose>
		<xsl:when test=".='0'">2</xsl:when><!--	���� -->
		<xsl:when test=".='1'">1</xsl:when><!--	����Ѻ�����ᣩ -->
	</xsl:choose>
</xsl:template>

<!-- ֤�����ͣ�����**���� -->
<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".='0'">0</xsl:when><!--�������֤**���֤ -->
		<xsl:when test=".='1'">2</xsl:when><!--����**����-->
		<xsl:when test=".='2'">3</xsl:when><!--����֤**����֤ -->
		<xsl:when test=".='3'">X</xsl:when><!--����**��������֤�� -->
		<xsl:when test=".='4'">X</xsl:when><!--����֤��**��������֤�� -->
		<xsl:when test=".='5'">1</xsl:when><!--���ڲ�**���ڲ� -->
		<xsl:when test=".='6'">5</xsl:when><!--�۰ľ��������ڵ�ͨ��֤**�۰ľ��������ڵ�ͨ��֤-->
		<xsl:when test=".='7'">6</xsl:when><!--̨�����������½ͨ��֤**̨�����������½ͨ��֤-->
		<xsl:when test=".='8'">X</xsl:when><!--����**��������֤�� -->
		<xsl:when test=".='9'">X</xsl:when><!--�쳣���֤**��������֤�� -->
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>