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
	<!-- Ͷ�������� -->
	<Plchd_Nm><xsl:value-of select="Appnt/Name" /></Plchd_Nm>
	<!-- ���ձ�������� -->
	<Ins_Ulyg_Nm></Ins_Ulyg_Nm>
	<!-- Ӫ���ͻ��������� -->
	<Cmpn_CstMgr_Nm><xsl:value-of select="TellerName" /></Cmpn_CstMgr_Nm> 
	<!-- Ӫ���ͻ������� -->
	<Cmpn_CstMgr_ID></Cmpn_CstMgr_ID>
	<!-- ��һ���������� -->
	<Fst_Benf_Nm></Fst_Benf_Nm>
	<!-- Ͷ������ -->
	<Ins_Cvr></Ins_Cvr>
	<!-- ���������� -->
	<RspbPsn_Nm></RspbPsn_Nm>
	<!-- ������֤�����ʹ��� -->
	<RspbPsn_Crdt_TpCd></RspbPsn_Crdt_TpCd>
	<!-- ������֤������ -->
	<RspbPsn_Crdt_No></RspbPsn_Crdt_No>
	<!-- ������Ч���� -->
	<InsPolcy_EfDt><xsl:value-of select="Risk[RiskCode=MainRiskCode]/CValiDate" /></InsPolcy_EfDt>
	<!-- ����ʧЧ���� -->
	<InsPolcy_ExpDt><xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuEndDate" /></InsPolcy_ExpDt>
	<!-- �����տͻ��������ʹ��� -->
	<AgIns_Cst_Line_TpCd></AgIns_Cst_Line_TpCd>
	<!-- �Ƽ������� -->
	<Rcmm_Psn_Nm></Rcmm_Psn_Nm>
	<!-- �Ƽ��˱�� -->
	<Rcmm_Psn_ID></Rcmm_Psn_ID>
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
		<!-- 
		<xsl:call-template name="tran_State">
			<xsl:with-param name="contState">
				<xsl:value-of select="ContState" />
			</xsl:with-param>
			<xsl:with-param name="nonRTContState">
				<xsl:value-of select="NonRTContState" />
			</xsl:with-param>
		</xsl:call-template>
		-->
	</AcIsAR_StCd>
	<!-- ���������� -->
	<Rcgn_Nm><xsl:value-of select="Insured/Name" /></Rcgn_Nm>
	<!-- Ͷ������ -->
	<Ins_Cps></Ins_Cps>

	
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

