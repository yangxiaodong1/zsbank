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
	<!-- Ͷ������ -->
	<Ins_BillNo><xsl:value-of select="ProposalPrtNo" /></Ins_BillNo>
	<!-- �����ײͱ�� -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!-- �ײ����� -->
	<Pkg_Nm></Pkg_Nm>
	<xsl:if test="ContPlan/ContPlanCode = ''">
	   <Cvr_ID>
		  <xsl:call-template name="tran_Riskcode">
			 <xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		  </xsl:call-template>
	   </Cvr_ID>
	   <!-- �������� -->
	   <Cvr_Nm><xsl:value-of select="$MainRisk/RiskName" /></Cvr_Nm>
    </xsl:if>
    <xsl:if test="ContPlan/ContPlanCode != ''">
       <Cvr_ID>
		  <xsl:call-template name="tran_Riskcode">
			 <xsl:with-param name="riskcode" select="ContPlan/ContPlanCode" />
		  </xsl:call-template>
	   </Cvr_ID>
	   <!-- �������� -->
	   <Cvr_Nm><xsl:value-of select="ContPlan/ContPlanName" /></Cvr_Nm>    
    </xsl:if>
	<!-- Ͷ�������� -->
	<Plchd_Nm><xsl:value-of select="Appnt/Name" /></Plchd_Nm>
	<!-- ���սɷѽ�� -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
	<!-- add 20150820 ��һ��2.2�汾����  �������������� -->
	<xsl:if test="$MainRisk/MainRiskCode='122009'" ><Ins_Yr_Prd_CgyCd>03</Ins_Yr_Prd_CgyCd></xsl:if>
	<xsl:if test="$MainRisk/MainRiskCode='L12087'" ><Ins_Yr_Prd_CgyCd>03</Ins_Yr_Prd_CgyCd></xsl:if>
	<xsl:if test="$MainRisk/MainRiskCode!='122009' and $MainRisk/MainRiskCode!='L12087'" >
	  <Ins_Yr_Prd_CgyCd>					
	     <xsl:call-template name="tran_PayEndYearFlag">
			<xsl:with-param name="payEndYear" select="$MainRisk/PayEndYear" />
			<xsl:with-param name="payEndYearFlag" select="$MainRisk/PayEndYearFlag" />
	     </xsl:call-template>
	  </Ins_Yr_Prd_CgyCd>
	</xsl:if>
	<!-- add 20150820 ��һ��2.2�汾����  �������� -->
	<Ins_Ddln>
	    <xsl:if test="$MainRisk/MainRiskCode='122046'" >999</xsl:if>
	    <xsl:if test="$MainRisk/MainRiskCode!='122046'" >
			<xsl:if test="$MainRisk/InsuYearFlag='A'">999</xsl:if>
			<xsl:if test="$MainRisk/InsuYearFlag!='A'"><xsl:value-of select="$MainRisk/InsuYear" /></xsl:if>  
	    </xsl:if>
	</Ins_Ddln>
	<!-- add 20150820 ��һ��2.2�汾����  �������ڴ��� -->
	<Ins_Cyc_Cd><xsl:apply-templates select="$MainRisk/InsuYearFlag" /></Ins_Cyc_Cd>
	<!-- add 20150820 ��һ��2.2�汾����  ���ѽɷѷ�ʽ���� -->
	<InsPrem_PyF_MtdCd><xsl:apply-templates select="$MainRisk/PayIntv" mode="payintv"/></InsPrem_PyF_MtdCd>
	<!-- add 20150820 ��һ��2.2�汾����  ���ѽɷ����� -->
	<InsPrem_PyF_Prd_Num>
		<xsl:if test="$MainRisk/InsuYearFlag!='A'">
		    <xsl:if test="$MainRisk/PayEndYear = '1000'">
				<xsl:if test="$MainRisk/PayIntv = '0'">1</xsl:if>
				<xsl:if test="$MainRisk/PayIntv != '0'"><xsl:value-of select="$MainRisk/PayEndYear" /></xsl:if>      
			</xsl:if>
			<xsl:if test="$MainRisk/PayEndYear != '1000'">
				<xsl:value-of select="$MainRisk/PayEndYear" />    
			</xsl:if>
			<!-- 
			<xsl:choose>
				<xsl:when test="PayEndYear = '1000'">1</xsl:when>
				<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
			</xsl:choose>
			-->
		</xsl:if>
		<xsl:if test="$MainRisk/MainRiskCode='L12078'" >1</xsl:if>
		<xsl:if test="$MainRisk/MainRiskCode='L12100'" >1</xsl:if>
		<xsl:if test="$MainRisk/MainRiskCode='122010'" >1</xsl:if>
		<xsl:if test="$MainRisk/MainRiskCode='L12089'" >1</xsl:if>
	</InsPrem_PyF_Prd_Num>
	<!-- add 20150820 ��һ��2.2�汾����  ���ѽɷ����ڴ��� -->
	<InsPrem_PyF_Cyc_Cd><xsl:apply-templates select="$MainRisk/PayIntv" mode="zhouqi"/></InsPrem_PyF_Cyc_Cd>
	<!-- �����սɷ�ҵ��ϸ�ִ��� -->
	<AgInsPyFBsnSbdvsn_Cd>
	   <xsl:call-template name="tran_AgentPayType">
			<xsl:with-param name="agentPayType" select="AgentPayType" />
		</xsl:call-template>	
	</AgInsPyFBsnSbdvsn_Cd>
	
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
		<xsl:when test="$riskcode='122046'">50002</xsl:when>	<!-- ������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	<!-- ������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='50002'">50002</xsl:when>	<!-- ������Ӯ���ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒת�� begin -->
		<xsl:when test="$riskcode='L12070'">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒת�� end -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	
		
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when> <!-- �����5����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
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
<!-- �����ĽɷѼ��/Ƶ�� -->
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

<xsl:template name="tran_PayEndYearFlag">
	<xsl:param name="payEndYear" />
	<xsl:param name="payEndYearFlag" />
	<xsl:choose>
		<xsl:when test="$payEndYearFlag='Y' and $payEndYear!='1000'">03</xsl:when><!--������ -->
		<xsl:when test="$payEndYearFlag='M'">03</xsl:when><!--������ -->
		<xsl:when test="$payEndYearFlag='D'">03</xsl:when><!--������ -->
		<xsl:when test="$payEndYearFlag='A'">05</xsl:when><!--���� -->
		<xsl:when test="$payEndYearFlag='Y' and $payEndYear ='1000'">05</xsl:when><!--���� -->
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
		<xsl:when test=".='0'">0100</xsl:when><!--	���� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- ������������ -->
<xsl:template match="InsuYearFlag">
	<xsl:choose>
		<xsl:when test=".='Y'">03</xsl:when><!-- ���� -->
		<xsl:when test=".='M'">04</xsl:when><!-- ���� -->
		<xsl:when test=".='D'">05</xsl:when><!-- ���� -->
		<xsl:when test=".='A'">03</xsl:when><!-- ���� -->
		<xsl:otherwise>99</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>