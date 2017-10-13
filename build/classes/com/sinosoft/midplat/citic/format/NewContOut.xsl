<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<Transaction_Body>
		<xsl:apply-templates select="TranData/Body" />
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
	
	<PbSlipNumb><xsl:value-of select="$MainRisk/Mult"/></PbSlipNumb>
	<PiStartDate><xsl:value-of select="$MainRisk/SignDate"/></PiStartDate><!-- ��ͬ��������  -->
	<PiValidate><xsl:value-of select="$MainRisk/CValiDate"/></PiValidate><!-- ��ͬ��Ч����  -->
	<PiSsDate><xsl:value-of select="$MainRisk/CValiDate"/></PiSsDate><!-- ���� ��Ч���� -->
	<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate"/></PiEndDate>
	<BkTotAmt></BkTotAmt>
	<BkTxAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></BkTxAmt>
	<PbMainExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)"/></PbMainExp>
	
	<!-- ���������ж��Է��ײ���ʽ���������и����գ��и�����ʱ�����BkNum1��ֵ -->
	<xsl:if test="ContPlan/ContPlanCode = ''">
		<BkNum1><xsl:value-of select="count(Risk[RiskCode!=MainRiskCode])"/></BkNum1>
	</xsl:if>
	<xsl:if test="ContPlan/ContPlanCode != ''">
		<BkNum1>0</BkNum1>
	</xsl:if>
	
	<Appd_List>
		<!-- ���������ж��Է��ײ���ʽ���������и����� -->
		<xsl:if test="ContPlan/ContPlanCode = ''">
			<xsl:for-each select="Risk[RiskCode!=MainRiskCode]">
			<Appd_Detail>
				<LiAppdInsuType>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="RiskCode" />
				</xsl:call-template>
				</LiAppdInsuType>	
				<LiAppdInsuExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/></LiAppdInsuExp>
			</Appd_Detail>
			</xsl:for-each>
		</xsl:if>
	</Appd_List>
</xsl:template>
<!-- ���ִ��� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when> <!-- ����ʢ��1���������գ������ͣ�-->
	<xsl:when test="$riskcode='L12079'">122012</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12073'">122029</xsl:when>	<!-- ����ʢ��5���������գ������ͣ� -->
	
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122036">122036</xsl:when>	<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
	
	<xsl:when test="$riskcode=50006">50006</xsl:when>	<!-- �������Ӯ1������ռƻ� -->
	<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1���������գ������ͣ�B��-->
	
	<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ�-->
	<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ�-->
	
	<!-- PBKINSR-1469 ���Ź��涫��9�� L12088 zx add 20160808 -->
	<xsl:when test="$riskcode='L12088'">L12088</xsl:when>
	<!-- PBKINSR-1458 ���Ź��涫��2�� L12085 zx add 20160808 -->
	<xsl:when test="$riskcode='L12085'">L12085</xsl:when>
	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
