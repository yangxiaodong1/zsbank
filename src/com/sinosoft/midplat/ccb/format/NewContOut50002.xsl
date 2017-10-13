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
	<xsl:variable name="tActSumPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
	
	<!-- �Ǳ�׼���Ĳ�Ʒ��Ϸ�������ֵȡ��׼�����ĵĲ�Ʒ��Ͻڵ��µķ�������risk�ڵ��µķ�����׼ȷ -->
	<PbSlipNumb><xsl:value-of select="ContPlan/ContPlanMult"/></PbSlipNumb>
	
	<PiStartDate><xsl:value-of select="$MainRisk/CValiDate"/></PiStartDate>
	<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate"/></PiEndDate>
	<BkTotAmt></BkTotAmt>
	<BkTxAmt><xsl:value-of select="$tActSumPrem"/></BkTxAmt>
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

	<PbPayPerAmt><xsl:value-of select="$tActSumPrem"/></PbPayPerAmt>
	<PbPayFre><xsl:apply-templates select="$MainRisk/PayIntv"/></PbPayFre>

	<PbPayDeadLine>
		<xsl:for-each select="$MainRisk">
			<xsl:choose>
				<xsl:when test="PayIntv = 0">һ�ν���</xsl:when>
				<xsl:when test="PayEndYearFlag = 'Y'">
					<xsl:value-of select="concat(PayEndYear, '��')"/>
				</xsl:when>
				<xsl:when test="PayEndYearFlag = 'M'">
					<xsl:value-of select="concat(PayEndYear, '��')"/>
				</xsl:when>
				<xsl:when test="PayEndYearFlag = 'D'">
					<xsl:value-of select="concat(PayEndYear, '��')"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>	
	</PbPayDeadLine>
</xsl:template>
<!-- ���ִ��� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122001">2001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122002">2002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122003">2003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122004">2004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122005">2005</xsl:when>	<!-- ����ƽ�3����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122006">2006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122008">2008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
	<xsl:when test="$riskcode=122009">2009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122010">2010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode=122035">2035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
	
	<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
	<xsl:when test="$riskcode=50002">2046</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ת��Ƶ�ʡ��ɷ�Ƶ��  -->
<xsl:template match="PayIntv">
	<xsl:choose>
		<xsl:when test=".=0">һ�ν���</xsl:when>		
		<xsl:when test=".=1">�½�</xsl:when>
		<xsl:when test=".=3">����</xsl:when>
		<xsl:when test=".=6">���꽻</xsl:when>
		<xsl:when test=".=12">�꽻</xsl:when>
		<xsl:when test=".=-1">�����ڽ�</xsl:when>
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
