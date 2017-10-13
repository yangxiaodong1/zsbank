<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">

	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<MainIns_Cvr_ID>
		<xsl:call-template name="tran_Riskcode">
			<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		</xsl:call-template>
	</MainIns_Cvr_ID>
	<Cvr_ID>
		<xsl:call-template name="tran_Riskcode">
			<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		</xsl:call-template>
	</Cvr_ID>
	<!-- �������ײͱ�� -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!-- ����ʧЧ���� -->
	<InsPolcy_ExpDt><xsl:value-of select="$MainRisk/InsuEndDate" /></InsPolcy_ExpDt>
	<!-- ������ȡ���� -->
	<InsPolcy_Rcv_Dt></InsPolcy_Rcv_Dt>
	<!-- �������� -->
	<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
	<!-- ���սɷѽ�� -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
	<!-- Ͷ���˵����ʼ���ַ -->
	<Plchd_Email_Adr><xsl:value-of select="Appnt/Email" /></Plchd_Email_Adr>
	<!-- ����Ͷ������ -->
	<InsPolcy_Ins_Dt><xsl:value-of select="$MainRisk/PolApplyDate" /></InsPolcy_Ins_Dt>
	<!-- ������Ч���� -->
	<InsPolcy_EfDt><xsl:value-of select="$MainRisk/CValiDate" /></InsPolcy_EfDt>
	<!-- �������ڽɴ����˺� -->
	<AgInsRgAutoDdcn_AccNo><xsl:value-of select="AccNo" /></AgInsRgAutoDdcn_AccNo>
	<!-- ÿ�ڽɷѽ����Ϣ -->
	<EcIst_PyF_Amt_Inf><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></EcIst_PyF_Amt_Inf>
	<!-- ���ѽɷѷ�ʽ���� -->
	<InsPrem_PyF_MtdCd>
		<xsl:apply-templates select="$MainRisk/PayIntv" mode="payintv"/>
	</InsPrem_PyF_MtdCd>
	<!-- ���ѽɷ����� -->
	<InsPrem_PyF_Prd_Num><xsl:value-of select="($MainRisk/PayTotalCount)-($MainRisk/PayCount)"/></InsPrem_PyF_Prd_Num>
	<!-- ���ѽɷ����ڴ��� -->
	<InsPrem_PyF_Cyc_Cd>
		<xsl:apply-templates select="$MainRisk/PayIntv" mode="zhouqi"/>
	</InsPrem_PyF_Cyc_Cd>
	<!-- 
	<InsPrem_PyF_Cyc_Cd>
		<xsl:choose>
			<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear='106'" >99</xsl:when>
			<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear!='106'" >98</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$MainRisk/PayIntv" />
			</xsl:otherwise>
		</xsl:choose>
	</InsPrem_PyF_Cyc_Cd>
	-->
	<!-- ������ԥ�� -->
	<InsPolcy_HsitPrd><xsl:value-of select="$MainRisk/HsitPrd" /></InsPolcy_HsitPrd>
	<Rvl_Rcrd_Num>0</Rvl_Rcrd_Num>
	<Ret_File_Num>0</Ret_File_Num>
	<!-- <Detail_List></Detail_List> -->
</xsl:template>


<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">���֤</xsl:when>
	<xsl:when test=".=1">����  </xsl:when>
	<xsl:when test=".=2">����֤</xsl:when>
	<xsl:when test=".=3">����  </xsl:when>
	<xsl:when test=".=5">���ڲ�</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- ����ת�� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>

		<!-- <xsl:when test="$riskcode='122046'">50002</xsl:when> -->	<!-- ������Ӯ�����ײ� -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- ����ʢ��1���������գ������ͣ�A -->
				
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- �ɷ����� -->
<!-- FIXME ��Ҫ�ͺ��ģ�ҵ��ȷ�ϣ����нɷ�Ƶ�Σ�01=�����ڡ�02=һ�Ρ�03=�����ڡ�04=��ĳ�ض����䡢05=���� -->
<xsl:template match="PayIntv" mode="payintv">
	<xsl:choose>
		<xsl:when test=".='0'">02</xsl:when><!--	���� -->
		<xsl:when test=".='12'">03</xsl:when><!-- �꽻 -->
		<xsl:when test=".='1'">03</xsl:when><!--	�½� -->
		<xsl:when test=".='3'">03</xsl:when><!--	���� -->
		<xsl:when test=".='6'">03</xsl:when><!--	���꽻 -->
		<xsl:when test=".='-1'">01</xsl:when><!-- �����ڽ� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- �ɷ��������� -->
<xsl:template match="PayIntv" mode="zhouqi">
	<xsl:choose>
		<xsl:when test=".='3'">0201</xsl:when><!--	���� -->
		<xsl:when test=".='6'">0202</xsl:when><!--	����� -->
		<xsl:when test=".='12'">0203</xsl:when><!--	��� -->
		<xsl:when test=".='1'">0204</xsl:when><!--	�½� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

