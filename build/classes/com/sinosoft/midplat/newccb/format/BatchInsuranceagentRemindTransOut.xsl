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
   <Ins_List>
        <!-- ���ڽɷ����� -->
		<xsl:for-each select="Detail/RenewReminds/RenewRemind">
		<Ins_Detail>
			<!-- ���չ�˾��� -->
			<Ins_Co_ID>010058</Ins_Co_ID>
            <!-- ���ֱ�� -->
            <xsl:if test="ContPlanCode=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_Riskcode">
					  <xsl:with-param name="riskcode" select="RiskCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
             <xsl:if test="ContPlanCode!=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_ContPlanCode">
					  <xsl:with-param name="contPlanCode" select="ContPlanCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>	
			<!-- �������� -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- �������������ʹ��� 1���˱���������  2�����ڽɷ�����  3�������ɷ�����  4����������ʧЧ����-->
			<AgIns_Rmndr_TpCd>2</AgIns_Rmndr_TpCd>
			<!-- Ͷ�������� -->
			<Plchd_Nm><xsl:value-of select="AppntName" /></Plchd_Nm>
			<!-- Ͷ����֤�����ʹ��� -->
			<Plchd_Crdt_TpCd>
			   <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="AppntIDNoType" />
			   </xsl:call-template>
			</Plchd_Crdt_TpCd>
			<!-- Ͷ����֤������ -->
			<Plchd_Crdt_No><xsl:value-of select="AppntIDNo" /></Plchd_Crdt_No>
			<!-- #�������� -->
			<TXN_DT><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(SignDate)" /></TXN_DT>
			<!-- ���ѽ�� -->
			<InsPrem_Amt></InsPrem_Amt>
			<!-- �˱���� -->
			<CnclIns_Amt></CnclIns_Amt>
			<!-- ���ڽɷѽ�� -->
			<Rnew_PyF_Amt><xsl:value-of select="PayMoney" /></Rnew_PyF_Amt>
			<!-- ����Ӧ������ -->
			<Rnew_Pbl_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(PayToDate)" /></Rnew_Pbl_Dt>
			<!-- ������������ -->
			<InsPolcy_ExDat></InsPolcy_ExDat>
			<!-- ���ں������ -->
			<CrnPrd_XtDvdAmt></CrnPrd_XtDvdAmt>
			<!-- �ۻ�������� -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
			<!-- ��������ʽ���� -->
			<XtraDvdn_Pcsg_MtdCd></XtraDvdn_Pcsg_MtdCd>
			<!-- Ͷ�����˺� -->
			<Plchd_AccNo></Plchd_AccNo>
			<!-- ���ղ�Ʒ���ʹ��� 0������ 1���ײ� 2��������-->
			<Ins_PD_TpCd>0</Ins_PD_TpCd>		
		</Ins_Detail>
		</xsl:for-each>
		<!-- �����ɷ����� -->
		<xsl:for-each select="Detail/BonusReminds/BonusRemind">
		<Ins_Detail>
			<!-- ���չ�˾��� -->
			<Ins_Co_ID>010058</Ins_Co_ID>
            <!-- ���ֱ�� -->
			<xsl:if test="ContPlanCode=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_Riskcode">
					  <xsl:with-param name="riskcode" select="RiskCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
             <xsl:if test="ContPlanCode!=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_ContPlanCode">
					  <xsl:with-param name="contPlanCode" select="ContPlanCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
			<!-- �������� -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- �������������ʹ��� 1���˱���������  2�����ڽɷ�����  3�������ɷ�����  4����������ʧЧ����-->
			<AgIns_Rmndr_TpCd>3</AgIns_Rmndr_TpCd>
			<!-- Ͷ�������� -->
			<Plchd_Nm><xsl:value-of select="AppntName" /></Plchd_Nm>
			<!-- Ͷ����֤�����ʹ��� -->
			<Plchd_Crdt_TpCd>
			   <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="AppntIDNoType" />
			   </xsl:call-template>
			</Plchd_Crdt_TpCd>
			<!-- Ͷ����֤������ -->
			<Plchd_Crdt_No><xsl:value-of select="AppntIDNo" /></Plchd_Crdt_No>
			<!-- #�������� -->
			<TXN_DT><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(SignDate)" /></TXN_DT>
			<!-- ���ѽ�� -->
			<InsPrem_Amt></InsPrem_Amt>
			<!-- �˱���� -->
			<CnclIns_Amt></CnclIns_Amt>
			<!-- ���ڽɷѽ�� -->
			<Rnew_PyF_Amt></Rnew_PyF_Amt>
			<!-- ����Ӧ������ -->
			<Rnew_Pbl_Dt></Rnew_Pbl_Dt>
			<!-- ������������ -->
			<InsPolcy_ExDat></InsPolcy_ExDat>
			<!-- ���ں������ -->
			<CrnPrd_XtDvdAmt><xsl:value-of select="CurrentBonus" /></CrnPrd_XtDvdAmt>
			<!-- �ۻ�������� -->
			<Acm_XtDvdAmt><xsl:value-of select="SumBonus" /></Acm_XtDvdAmt>
			<!-- ��������ʽ���� -->
			<XtraDvdn_Pcsg_MtdCd><xsl:apply-templates select="BonusGetMode" /></XtraDvdn_Pcsg_MtdCd>
			<!-- Ͷ�����˺� -->
			<Plchd_AccNo><xsl:value-of select="AccNo" /></Plchd_AccNo>
			<!-- ���ղ�Ʒ���ʹ��� 0������ 1���ײ� 2��������-->
			<Ins_PD_TpCd>0</Ins_PD_TpCd>		
		</Ins_Detail>
		</xsl:for-each>
		<!-- �˱��������� -->
		<xsl:for-each select="Detail/CTReminds/CTRemind">
		<Ins_Detail>
			<!-- ���չ�˾��� -->
			<Ins_Co_ID>010058</Ins_Co_ID>
            <!-- ���ֱ�� -->
			<xsl:if test="ContPlanCode=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_Riskcode">
					  <xsl:with-param name="riskcode" select="RiskCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
             <xsl:if test="ContPlanCode!=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_ContPlanCode">
					  <xsl:with-param name="contPlanCode" select="ContPlanCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
			<!-- �������� -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- �������������ʹ��� 1���˱���������  2�����ڽɷ�����  3�������ɷ�����  4����������ʧЧ����-->
			<AgIns_Rmndr_TpCd>1</AgIns_Rmndr_TpCd>
			<!-- Ͷ�������� -->
			<Plchd_Nm><xsl:value-of select="AppntName" /></Plchd_Nm>
			<!-- Ͷ����֤�����ʹ��� -->
			<Plchd_Crdt_TpCd>
			   <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="AppntIDNoType" />
			   </xsl:call-template>
			</Plchd_Crdt_TpCd>
			<!-- Ͷ����֤������ -->
			<Plchd_Crdt_No><xsl:value-of select="AppntIDNo" /></Plchd_Crdt_No>
			<!-- #�������� -->
			<TXN_DT><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(SignDate)" /></TXN_DT>
			<!-- ���ѽ�� -->
			<InsPrem_Amt></InsPrem_Amt>
			<!-- �˱���� -->
			<CnclIns_Amt><xsl:value-of select="CTGetMoney" /></CnclIns_Amt>
			<!-- ���ڽɷѽ�� -->
			<Rnew_PyF_Amt></Rnew_PyF_Amt>
			<!-- ����Ӧ������ -->
			<Rnew_Pbl_Dt></Rnew_Pbl_Dt>
			<!-- ������������ -->
			<InsPolcy_ExDat></InsPolcy_ExDat>
			<!-- ���ں������ -->
			<CrnPrd_XtDvdAmt></CrnPrd_XtDvdAmt>
			<!-- �ۻ�������� -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
			<!-- ��������ʽ���� -->
			<XtraDvdn_Pcsg_MtdCd></XtraDvdn_Pcsg_MtdCd>
			<!-- Ͷ�����˺� -->
			<Plchd_AccNo><xsl:value-of select="AccNo" /></Plchd_AccNo>
			<!-- ���ղ�Ʒ���ʹ��� 0������ 1���ײ� 2��������-->
			<Ins_PD_TpCd>0</Ins_PD_TpCd>		
		</Ins_Detail>
		</xsl:for-each>
		<!-- ��������ʧЧ���� -->
		<xsl:for-each select="Detail/InvalidateReminds/InvalidateRemind">
		<Ins_Detail>
			<!-- ���չ�˾��� -->
			<Ins_Co_ID>010058</Ins_Co_ID>
            <!-- ���ֱ�� -->
			<xsl:if test="ContPlanCode=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_Riskcode">
					  <xsl:with-param name="riskcode" select="RiskCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
             <xsl:if test="ContPlanCode!=''">
                <Cvr_ID>
			   	   <xsl:call-template name="tran_ContPlanCode">
					  <xsl:with-param name="contPlanCode" select="ContPlanCode" />
				   </xsl:call-template>
			    </Cvr_ID>  
            </xsl:if>
			<!-- �������� -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- �������������ʹ��� 1���˱���������  2�����ڽɷ�����  3�������ɷ�����  4����������ʧЧ����-->
			<AgIns_Rmndr_TpCd>4</AgIns_Rmndr_TpCd>
			<!-- Ͷ�������� -->
			<Plchd_Nm><xsl:value-of select="AppntName" /></Plchd_Nm>
			<!-- Ͷ����֤�����ʹ��� -->
			<Plchd_Crdt_TpCd>
			   <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="AppntIDNoType" />
			   </xsl:call-template>
			</Plchd_Crdt_TpCd>
			<!-- Ͷ����֤������ -->
			<Plchd_Crdt_No><xsl:value-of select="AppntIDNo" /></Plchd_Crdt_No>
			<!-- #�������� -->
			<TXN_DT><xsl:value-of select="SignDate" /></TXN_DT>
			<!-- ���ѽ�� -->
			<InsPrem_Amt></InsPrem_Amt>
			<!-- �˱���� -->
			<CnclIns_Amt></CnclIns_Amt>
			<!-- ���ڽɷѽ�� -->
			<Rnew_PyF_Amt></Rnew_PyF_Amt>
			<!-- ����Ӧ������ -->
			<Rnew_Pbl_Dt></Rnew_Pbl_Dt>
			<!-- ������������ -->
			<InsPolcy_ExDat><xsl:value-of select="EndDate" /></InsPolcy_ExDat>
			<!-- ���ں������ -->
			<CrnPrd_XtDvdAmt></CrnPrd_XtDvdAmt>
			<!-- �ۻ�������� -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
			<!-- ��������ʽ���� -->
			<XtraDvdn_Pcsg_MtdCd></XtraDvdn_Pcsg_MtdCd>
			<!-- Ͷ�����˺� -->
			<Plchd_AccNo></Plchd_AccNo>
			<!-- ���ղ�Ʒ���ʹ��� 0������ 1���ײ� 2��������-->
			<Ins_PD_TpCd>0</Ins_PD_TpCd>		
		</Ins_Detail>
		</xsl:for-each>
	</Ins_List>		
</xsl:template>
		
<!-- ���ִ��� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1�������գ������ͣ�B�� -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- ����ʢ��1���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
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

<!-- ������ȡ��ʽ -->
<xsl:template match="BonusGetMode">
    <xsl:choose>
        <xsl:when test=".=2">0</xsl:when>   <!-- ֱ�Ӹ��� -->
        <xsl:when test=".=3">1</xsl:when>   <!-- �ֽ����� -->
        <xsl:when test=".=1">2</xsl:when>   <!-- �ۼ���Ϣ -->
        <xsl:when test=".=5">3</xsl:when>   <!-- �����  -->
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
</xsl:template>
	
</xsl:stylesheet>

