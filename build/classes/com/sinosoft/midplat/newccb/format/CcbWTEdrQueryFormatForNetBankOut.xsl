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

	<xsl:variable name="MainRisk" select="PubContInfo/Risk[RiskCode=MainRiskCode]" />
	
	<Lv1_Br_No><xsl:value-of select="PubContInfo/SubBankCode" /></Lv1_Br_No>
	<ActCashPymt_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></ActCashPymt_Amt>
	<!-- ���˺������ -->
	<ATEndOBns_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(0)" /></ATEndOBns_Amt>
	<Cvr_ID>
		<xsl:call-template name="tran_Riskcode">
			<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		</xsl:call-template>
	</Cvr_ID>
	<InsPolcy_No><xsl:value-of select="PubContInfo/ContNo" /></InsPolcy_No>
	<Plchd_Nm><xsl:value-of select="PubContInfo/AppntName" /></Plchd_Nm>
	<Plchd_Crdt_No><xsl:value-of select="PubContInfo/AppntIDNo" /></Plchd_Crdt_No>
	<Plchd_Crdt_TpCd>
		<xsl:call-template name="tran_IDType">
			<xsl:with-param name="idtype" select="PubContInfo/AppntIDType" />
		</xsl:call-template>
	</Plchd_Crdt_TpCd>
	<!-- �˱����ʹ���, 1-��ԥ�ڣ�2-����ԥ�� -->
	<CnclIns_TpCd>1</CnclIns_TpCd>
	<!-- �����˸��� -->
	<Rcgn_Num>1</Rcgn_Num>
	<RcgnNm_List>
		<RcgnNm_Detail>
			<Rcgn_Nm><xsl:value-of select="PubContInfo/InsuredName" /></Rcgn_Nm>
		</RcgnNm_Detail>
	</RcgnNm_List>
	<CnclIns_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></CnclIns_Amt>
	<!-- ������ -->
	<Btch_BillNo></Btch_BillNo>
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	
</xsl:template>

<!-- ֤������ת�� -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='0'">1010</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1'">1052</xsl:when>	<!-- ���� -->
		<xsl:when test="$idtype='2'">1020</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='5'">1040</xsl:when>	<!-- ���ڲ� -->
		<xsl:otherwise></xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

<!-- ����ת�� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">122001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122002'">122002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122003'">122003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122004'">122004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122005'">122005</xsl:when>	<!-- ����ƽ�3����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122006'">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122008'">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
		<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
		
		<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
		<xsl:when test="$riskcode='122046'">50002</xsl:when>	<!-- �������Ӯ���ռƻ��������ͣ� -->
        <!-- add by duanjz PBKINSR-694 ���Ӱ���5�Ų�Ʒ  begin -->
        <xsl:when test="$riskcode='L12070'">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
        <!-- add by duanjz PBKINSR-694 ���Ӱ���5�Ų�Ʒ  end -->
		<!-- �¾����ִ��벢�� -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
		
</xsl:stylesheet>

