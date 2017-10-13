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
<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
<xsl:if test="ContPlan/ContPlanCode = ''">
    <PbInsuType>
	   <xsl:call-template name="tran_riskcode">
		  <xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
	   </xsl:call-template>
    </PbInsuType>
</xsl:if>
<xsl:if test="ContPlan/ContPlanCode != ''">
    <PbInsuType>
	   <xsl:call-template name="tran_contPlanCode">
		  <xsl:with-param name="contPlanCode" select="ContPlan/ContPlanCode" />
	   </xsl:call-template>
    </PbInsuType>
</xsl:if>
	
<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate" /></PiEndDate>
<PbFinishDate></PbFinishDate>
<LiDrawstring></LiDrawstring>
<LiCashValueCount>0</LiCashValueCount>	<!-- ���Ų���ȡ�˴����ּۺͺ�����ֱ����0 ���ʵ� -->
<LiBonusValueCount>0</LiBonusValueCount><!-- ���Ų���ȡ�˴����ּۺͺ�����ֱ����0 ���ʵ� -->
<PbInsuSlipNo><xsl:value-of select="ContNo" /></PbInsuSlipNo>
<BkTotAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></BkTotAmt>
<LiSureRate></LiSureRate>
<PbBrokId></PbBrokId>
<LiBrokName></LiBrokName>
<LiBrokGroupNo></LiBrokGroupNo>
<BkOthName></BkOthName>
<BkOthAddr></BkOthAddr>
<PiCpicZipcode></PiCpicZipcode>
<PiCpicTelno></PiCpicTelno>
<BkFileNum>0</BkFileNum>
<BkFileNum>0</BkFileNum>
</xsl:template>

<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� --><!-- ���ʵ� �������е����֤�����֣��������֤���룬����֤Ϊ�����ˣ��侯�����֤���ȵ� -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">���֤</xsl:when>
	<xsl:when test=".=1">����  </xsl:when>
	<xsl:when test=".=2">����֤</xsl:when>
	<xsl:when test=".=3">����  </xsl:when>
	<xsl:when test=".=5">���ڲ�</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ɷѼ��  -->
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
 
 <!-- �Ա�ע�⣺����     ���ո��Ű��õģ�����ȥ����-->
<xsl:template match="Sex">
<xsl:choose>
	<xsl:when test=".=0">��  </xsl:when>		
	<xsl:when test=".=1">Ů  </xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='L12079'">122012</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	<!-- 20160215 PBKINSR-1086 ���������ֻ�����-L12080 ʢ��1�� begin -->
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- ����ʢ��1���������գ������ͣ� -->    
	<!-- 20160215 PBKINSR-1086 ���������ֻ�����-L12080 ʢ��1�� end -->
	<!-- PBKINSR-1272 ���������ֻ������²�Ʒ��ʢ��3�� begin -->
	<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<!-- PBKINSR-1272 ���������ֻ������²�Ʒ��ʢ��3�� end  -->
	<!-- PBKINSR-1278 ���������ֻ�����ʢ��3��-�㽭����ר����Ʒ begin -->
	<xsl:when test="$riskcode='L12090'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<!-- PBKINSR-1278 ���������ֻ�����ʢ��3��-�㽭����ר����Ʒ end  -->
	<xsl:when test="$riskcode='L12098'">122012</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� ���ż��Ϸ���ר����Ʒ-->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��Ʒ��ϱ��� -->
<xsl:template name="tran_contPlanCode">
	<xsl:param name="contPlanCode"/>

	<xsl:choose>
		<!-- �������Ӯ1����ȫ�������:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ���� -->
		<xsl:when test="$contPlanCode='50015'">50002</xsl:when>
		<xsl:otherwise>--</xsl:otherwise>	
	</xsl:choose>
</xsl:template>

<!-- ������ȡ  -->
<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
<xsl:choose>
	<xsl:when test=".=1">�ۼ���Ϣ</xsl:when>
	<xsl:when test=".=2">��ȡ�ֽ�</xsl:when>
	<xsl:when test=".=3">�ֽɱ���</xsl:when>
	<xsl:when test=".=5">�����</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
