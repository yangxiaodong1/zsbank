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
	<xsl:variable name="tMainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<!-- �������ײͱ�� -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>

	<!-- ����ϲ�Ʒ -->					
	<xsl:if test="$tContPlanCode = ''">
	<!-- ���ָ���,���ж��Է��ײ���ʽ��������ͳ�����ָ������и�����ʱ��������ָ��� -->
	<Cvr_Num><xsl:value-of select="count(Risk)"/></Cvr_Num>
	<Bu_List>
		<xsl:for-each select="Risk">
			<Bu_Detail>
				<!-- ���ֱ�� -->
				<Cvr_ID>
					<xsl:call-template name="tran_Riskcode">
						<xsl:with-param name="riskcode" select="RiskCode" />
					</xsl:call-template>
				</Cvr_ID>
				<!-- �����ձ�־ FIXME ȷ���ñ�ǩ��дֵ-->
				<MainAndAdlIns_Ind>1</MainAndAdlIns_Ind>
				<InsPrem_Amt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
				</InsPrem_Amt>
			</Bu_Detail>
		</xsl:for-each>
	</Bu_List>
	</xsl:if>
	<!-- ��ϲ�Ʒ -->
	<xsl:if test="$tContPlanCode != ''">
	<!-- ���ָ���,���ж��Է��ײ���ʽ��������ͳ�����ָ������и�����ʱ��������ָ��� -->
	<Cvr_Num>1</Cvr_Num>
	<Bu_List>
		<Bu_Detail>
			<Cvr_ID>
				<xsl:call-template name="tran_ContPlanCode">
					<xsl:with-param name="contPlanCode" select="$tContPlanCode" />
				</xsl:call-template>
			</Cvr_ID>
			<!-- �����ձ�־ FIXME ȷ���ñ�ǩ��дֵ-->
			<MainAndAdlIns_Ind>1</MainAndAdlIns_Ind>
			<InsPrem_Amt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
			</InsPrem_Amt>
		</Bu_Detail>
	</Bu_List>
	</xsl:if>
	<!-- Ͷ������ -->
	<Ins_BillNo>
		<xsl:value-of select="ProposalPrtNo" />
	</Ins_BillNo>
	<!-- �ܱ��ѽ�� -->
	<Tot_InsPrem_Amt>
		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
	</Tot_InsPrem_Amt>
	<!-- ���ڽɷѽ�� -->
	<Init_PyF_Amt>
		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
	</Init_PyF_Amt>
	<!-- Ͷ������ -->
	<Ins_Cvr><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/></Ins_Cvr>
	<!-- ���չ�˾��פ��Ա���� -->
	<Ins_Co_Acrdt_Stff_Nm></Ins_Co_Acrdt_Stff_Nm>
	<!-- ���չ�˾��פ��Ա��ҵ�ʸ�֤���� -->
	<InsCoAcrStCrQuaCtf_ID></InsCoAcrStCrQuaCtf_ID>
	<!-- ���ѽɷѷ�ʽ���� -->
	<InsPrem_PyF_MtdCd>
		<xsl:apply-templates select="$tMainRisk/PayIntv" mode="payintv"/>
	</InsPrem_PyF_MtdCd>
	<!-- �������ڽɴ����˺� -->
	<AgInsRgAutoDdcn_AccNo><xsl:value-of select="AccNo"/></AgInsRgAutoDdcn_AccNo>
	<!-- ÿ�ڽɷѽ����Ϣ -->
	<EcIst_PyF_Amt_Inf><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></EcIst_PyF_Amt_Inf>
	<!-- ���ѽɷ�����,FIXME ����ط���������ϢΪ׼����Ҫ�ͺ���ȷ�� -->
	<InsPrem_PyF_Prd_Num><xsl:value-of select="($tMainRisk/PayTotalCount)-($tMainRisk/PayCount)"/></InsPrem_PyF_Prd_Num>
	<!-- ���ѽɷ����ڴ��� -->
	<InsPrem_PyF_Cyc_Cd>
		<xsl:apply-templates select="$tMainRisk/PayIntv" mode="zhouqi"/>
	</InsPrem_PyF_Cyc_Cd>
</xsl:template>
		
<!-- ���ִ��� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>		
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<!-- add 20151229 PBKINSR-1004 ������������ʢ1 begin -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- ����ʢ��1���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when> 	<!-- ����ʢ��1���������գ������ͣ�B -->
		<!-- add 20151229 PBKINSR-1004 ������������ʢ1 end -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when> 	<!-- �����5����ȫ���գ������ͣ� -->
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
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

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

