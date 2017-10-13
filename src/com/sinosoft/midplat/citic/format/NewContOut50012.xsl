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

<PbSlipNumb><xsl:value-of select="ContPlan/ContPlanMult"/></PbSlipNumb><!-- �Ǳ�׼���Ĳ�Ʒ��Ϸ�������ֵȡ��׼�����ĵĲ�Ʒ��Ͻڵ��µķ�������risk�ڵ��µķ�����׼ȷ -->
<PiStartDate><xsl:value-of select="$MainRisk/SignDate"/></PiStartDate><!-- ��ͬ��������  -->
<PiValidate><xsl:value-of select="$MainRisk/CValiDate"/></PiValidate><!-- ��ͬ��Ч����  -->
<PiSsDate><xsl:value-of select="$MainRisk/CValiDate"/></PiSsDate><!-- ���� ��Ч���� -->
<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate"/></PiEndDate>
<BkTotAmt></BkTotAmt>
<BkTxAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></BkTxAmt>
<PbMainExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)"/></PbMainExp>
<BkNum1><xsl:value-of select="0"/></BkNum1>
<!-- 
<BkNum1><xsl:value-of select="count(Risk[RiskCode!=MainRiskCode])"/></BkNum1>
 -->
 
<Appd_List>
<!-- 
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
-->
</Appd_List>
</xsl:template>

<!-- ���ִ��� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='L12079'">122012</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12073'">122029</xsl:when>	<!-- ����ʢ��5���������գ������ͣ� -->
	
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122036">122036</xsl:when>	<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
	
	<xsl:when test="$riskcode=50015">50002</xsl:when>	<!-- �������Ӯ2����ȫ������� -->
	<xsl:when test="$riskcode=122046">122046</xsl:when>	<!-- �������Ӯ1����ȫ���� -->
	<xsl:when test="$riskcode=122047">122047</xsl:when>	<!-- ����ӳ�����Ӯ��ȫ���� -->
	<xsl:when test="$riskcode=122048">122048</xsl:when>	<!-- ����������������գ������ͣ� -->
	
	<!-- add by duanjz ���Ӱ���ٰ���5�ű��ռƻ�50012  begin -->
	<xsl:when test="$riskcode=50012">50012</xsl:when>	<!-- �������Ӯ2����ȫ������� -->
	<xsl:when test="$riskcode=L12070">L12070</xsl:when>	<!-- ����ٰ���5������� -->
	<xsl:when test="$riskcode=L12071">L12071</xsl:when>	<!-- ����ӳ�������5����ȫ���գ������ͣ� -->
	<!-- add by duanjz ���Ӱ���ٰ���5�ű��ռƻ�50012  end -->
	
	<!-- add by duanjz ���Ӱ���ٰ���3�ű��ռƻ�50011  begin -->
	<xsl:when test="$riskcode=50011">50011</xsl:when>	<!-- ����ٰ���3�ű��ռƻ� -->
	<xsl:when test="$riskcode=L12068">L12068</xsl:when>	<!-- ����ٰ���3������� -->
	<xsl:when test="$riskcode=L12069">L12069</xsl:when>	<!-- ����ӳ�������3����ȫ���գ������ͣ� -->
	<!-- add by duanjz ���Ӱ���ٰ���3�ű��ռƻ�50011  end -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>

