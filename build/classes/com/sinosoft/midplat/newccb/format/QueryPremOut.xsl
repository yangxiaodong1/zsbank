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

	<xsl:variable name="tContPlanCode">
		<xsl:value-of select="ContPlan/ContPlanCode" />
	</xsl:variable>
	
	<xsl:variable name="tMainRiskCode">
		<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskCode" />
	</xsl:variable>
	
	<!-- ���д����־:1=�����������ı�����0=�ǽ��г��ı��� -->
	<CCB_Agnc_Ind>1</CCB_Agnc_Ind>
	<!-- һ�����к� -->
	<Lv1_Br_No><xsl:value-of select="SubBankCode" /></Lv1_Br_No>
	<!-- �����սɷ�ҵ��ϸ�ִ��� -->
	<AgInsPyFBsnSbdvsn_Cd>
		<xsl:call-template name="tran_AgentPayType">
			<xsl:with-param name="agentPayType" select="AgentPayType" />
		</xsl:call-template>
	</AgInsPyFBsnSbdvsn_Cd>
	<!--modify 20150820 Ͷ������ ��һ��2.2�汾����Ҫ����Ͷ������
	<Ins_BillNo></Ins_BillNo>
	-->
	<Ins_BillNo></Ins_BillNo>
	<!--add 20150820 ��һ��2.2�汾�����ײ����� -->
	<Pkg_Nm></Pkg_Nm>
	<!-- ����ϲ�Ʒ -->					
	<xsl:if test="$tContPlanCode = ''">
		<Cvr_ID>
			<xsl:call-template name="tran_Riskcode">
				<xsl:with-param name="riskcode" select="$tMainRiskCode" />
			</xsl:call-template>
		</Cvr_ID>
	    <!--add 20150820 ��һ��2.2�汾������������ -->
	    <Cvr_Nm><xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskName" /></Cvr_Nm>
	</xsl:if>
	<!-- ��ϲ�Ʒ -->
	<xsl:if test="$tContPlanCode != ''">
		<Cvr_ID>
			<xsl:call-template name="tran_ContPlanCode">
				<xsl:with-param name="contPlanCode" select="$tContPlanCode" />
			</xsl:call-template>
		</Cvr_ID>
		<!--add 20150820 ��һ��2.2�汾������������ -->
	    <Cvr_Nm><xsl:value-of select="ContPlan/ContPlanName" /></Cvr_Nm>
	</xsl:if>
	
	<!-- �ײͱ��� -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!--modify 20150820 �������� ��һ��2.2�汾����Ҫ���ر�����
	<InsPolcy_No></InsPolcy_No>
	--> 
	<InsPolcy_No></InsPolcy_No>	
	<!-- Ͷ�������� -->
	<Plchd_Nm><xsl:value-of select="Appnt/Name" /></Plchd_Nm>
	<!-- ����Ӧ������ -->
	<Rnew_Pbl_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Risk[RiskCode=MainRiskCode]/StartPayDate)" /></Rnew_Pbl_Dt>
	<!-- ���սɷѽ�� -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
	<!-- ����Ӧ������ -->
	<Rnew_Pbl_Prd_Num><xsl:value-of select="(Risk[RiskCode=MainRiskCode]/PayTotalCount)-(Risk[RiskCode=MainRiskCode]/PayCount) " /></Rnew_Pbl_Prd_Num>
				
</xsl:template>


<!-- �����սɷ�ҵ��ϸ�ִ��� 01-ʵʱͶ���ɷ� 02-��ʵʱͶ���ɷ� 03-���ڽ��� -->
<xsl:template name="tran_AgentPayType">
	<xsl:param name="agentPayType" />
	<xsl:choose>
		<xsl:when test="$agentPayType='01'">11</xsl:when>	<!-- ʵʱͶ���ɷ� -->
		<xsl:when test="$agentPayType='02'">12</xsl:when>	<!-- ��ʵʱͶ���ɷ� -->
		<xsl:when test="$agentPayType='03'">14</xsl:when>	<!-- ���ڽ��� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

		
<!-- ���ִ��� -->
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
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	    <!-- �������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  begin -->
		<xsl:when test="$riskcode='50012'">50012</xsl:when>	    <!-- ����ٰ���5�ű��ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  end -->
		<!-- ���ִ��벢�� -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='122035'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1�������գ������ͣ�B�� -->
		<xsl:when test="$riskcode='50002'">50002</xsl:when>	    <!-- �������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ�-->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode=50015">50002</xsl:when>	<!-- �������Ӯ���ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  begin -->
		<xsl:when test="$contPlanCode=50012">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  end -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>

