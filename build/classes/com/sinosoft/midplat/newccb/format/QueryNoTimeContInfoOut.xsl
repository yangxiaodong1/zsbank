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
	<!-- ���ѽ�� -->
	<InsPrem_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)" /></InsPrem_Amt>
	<!-- �����պ�Լ״̬���� -->
	<AcIsAR_StCd>
	    <xsl:if test="NonRTContState='-1' or NonRTContState='06'">
			<xsl:call-template name="tran_State">
				<xsl:with-param name="contState">
					<xsl:value-of select="ContState" />
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="NonRTContState!='-1' and NonRTContState!='06'">
			<xsl:call-template name="tran_nonRTContState">
				<xsl:with-param name="nonRTContState">
					<xsl:value-of select="NonRTContState" />
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</AcIsAR_StCd>
	<!-- �������� -->
	<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
	<!-- ���ղ�Ʒ���ʹ��� -->
	<Ins_PD_TpCd>0</Ins_PD_TpCd>
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
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1�������գ������ͣ�B�� -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	<!-- ������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='50002'">50002</xsl:when>	<!-- ������Ӯ���ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒת�� begin -->
		<xsl:when test="$riskcode='50012'">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒת�� end -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ������Լ״̬ FIXME �ⲿ����Ҫ����Ĺ�ͨȷ�����ӳ���ϵ -->
<xsl:template name="tran_State">
	<xsl:param name="contState"></xsl:param>
	<xsl:choose><!-- ��˾����=�������� -->
		<xsl:when test="$contState='00'">076012</xsl:when>		<!-- ǩ���ѻ�ִ=��������Ч���ͻ���ǩ�� -->
		<xsl:when test="$contState='A'">076016</xsl:when>		<!-- �ܱ�������=���չ�˾�ܱ�(�˱�δͨ��) -->
		<xsl:when test="$contState='B'">076036</xsl:when>		<!-- ��ʵʱ�����ѽɷѴ���ȡ���� -->
		<xsl:when test="$contState='C'">076023</xsl:when>		<!-- ���ճ���=���ճ������� -->
		<xsl:when test="$contState='WT'">076024</xsl:when>		<!-- ��ԥ�����˱���ֹ=��ԥ���˱����� -->
		<xsl:when test="$contState='02'">076025</xsl:when>		<!-- �˱���ֹ=����ԥ���˱����� -->
		<xsl:when test="$contState='01'">076030</xsl:when>		<!-- ������ֹ=�����Ѹ��� -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="tran_nonRTContState">
	<xsl:param name="nonRTContState"></xsl:param>
	<xsl:choose><!-- ��˾����=�������� -->
		<xsl:when test="$nonRTContState='08'">076011</xsl:when>	<!-- ǩ��δ��ִ=��������Ч���ͻ�δǩ�� -->
		<xsl:when test="$nonRTContState='06'">076012</xsl:when>	<!-- ǩ���ѻ�ִ=��������Ч���ͻ���ǩ�� -->
		<xsl:when test="$nonRTContState='00'">076014</xsl:when>	<!-- δ����=���չ�˾�ѽ��շ�ʵʱ�˱���Ϣ -->
		<xsl:when test="$nonRTContState='01'">076014</xsl:when>	<!-- ¼����=���չ�˾�ѽ��շ�ʵʱ�˱���Ϣ -->
		<xsl:when test="$nonRTContState='02'">076014</xsl:when>	<!-- �˱���=���չ�˾�ѽ��շ�ʵʱ�˱���Ϣ -->
		<xsl:when test="$nonRTContState='03'">076014</xsl:when>	<!-- ֪ͨ����ظ�=���չ�˾�ѽ��շ�ʵʱ�˱���Ϣ -->
		<xsl:when test="$nonRTContState='07'">076015</xsl:when>	<!-- ����=������������ -->
		<xsl:when test="$nonRTContState='05'">076016</xsl:when>	<!-- �ܱ�������=���չ�˾�ܱ�(�˱�δͨ��) -->
		<xsl:when test="$nonRTContState='04'">076019</xsl:when>	<!-- �˱�ͨ��=��ʵʱ�������չ�˾�˱�ͨ�����ɷ� -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>