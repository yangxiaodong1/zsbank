<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
			<SourceType>
				<xsl:apply-templates select="TX/TX_BODY/ENTITY/COM_ENTITY/TXN_ITT_CHNL_CGY_CODE" />
			</SourceType>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<ProposalPrtNo><xsl:value-of select="Ins_Bl_Prt_No" /></ProposalPrtNo>
	<ContPrtNo />
	<!-- ���в���Ͷ�����ڣ�ȡ�������� -->
	<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></PolApplyDate>
	<!-- 
	<PolApplyDate><xsl:value-of select="../COM_ENTITY/OprgDay_Prd" /></PolApplyDate>
	-->
	<!--������������-->
	<AgentComName><xsl:value-of select="BO_Nm"/></AgentComName>
	<!--���������ʸ�֤-->
	<AgentComCertiCode><xsl:value-of select="BOInsPrAgnBsnLcns_ECD"/></AgentComCertiCode>
	<!-- ����ֹܴ�����ҵ�����˱�� -->
	<ManagerNo><xsl:value-of select="BOIChOfAgInsBsnPnp_ID"/></ManagerNo>
	<!-- ����ֹܴ�����ҵ���������� -->
	<ManagerName><xsl:value-of select="BOIChOfAgInsBsnPnp_Nm"/></ManagerName>
	<!--����������Ա����-->
	<SellerNo><xsl:value-of select="BO_Sale_Stff_ID"/></SellerNo>
	<!--����������Ա����-->
	<TellerName><xsl:value-of select="BO_Sale_Stff_Nm"/></TellerName>
	<!--����������Ա�ʸ�֤-->
	<TellerCertiCode><xsl:value-of select="Sale_Stff_AICSQCtf_ID"/></TellerCertiCode>
	
	<AccName><xsl:value-of select="Plchd_Nm" /></AccName>	<!-- ȡͶ�������� -->
	<AccNo><xsl:value-of select="Plchd_PyF_AccNo" /></AccNo>
	<GetPolMode></GetPolMode> <!-- �������ͷ�ʽ 1=�ʼģ�2=������ȡ-->
	<!-- ������������1��ֽ�Ʊ���2�����ӱ��� -->
	<PolicyDeliveryMethod>2</PolicyDeliveryMethod>
	     
	<JobNotice /><!-- ְҵ��֪(N/Y) -->
	<HealthNotice><xsl:apply-templates select="Ntf_Itm_Ind" /></HealthNotice><!-- ������֪(N/Y) -->
	<!-- add Ϊ�˽����ȡ�������鷵�ر��������������ֶ�  begin -->
	<!-- ���ѵ潻��־ -->
	<AutoPayFlag>
	   <xsl:choose>
	        <xsl:when test="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/ApntInsPremPyAdvnInd=''"></xsl:when>
			<xsl:when test="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/ApntInsPremPyAdvnInd='0'">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</AutoPayFlag>
	<!-- ���鴦��ʽ -->
	<DisputedFag>
	    <xsl:choose>
			<xsl:when test="Dspt_Pcsg_MtdCd='03'">2</xsl:when>
			<xsl:when test="Dspt_Pcsg_MtdCd='04'">1</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</DisputedFag>
	<DisputedName><xsl:value-of select="Dspt_Arbtr_Inst_Nm" /></DisputedName><!-- �����ٲû����� -->
	<!-- add Ϊ�˽����ȡ�������鷵�ر��������������ֶ�  end -->
	<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N�� -->
	<PolicyIndicator>
		<xsl:choose>
			<xsl:when test="Minr_Acm_Cvr>0">Y</xsl:when>
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
	</PolicyIndicator>
	<!--�ۼ�δ������Ͷ����ʱ��� �������ֶαȽ����⣬��λ�ǰ�Ԫ-->
	<InsuredTotalFaceAmount><xsl:value-of select="Minr_Acm_Cvr*0.01" /></InsuredTotalFaceAmount>
	<!-- ����һ�����к� -->
	<SubBankCode><xsl:value-of select="Lv1_Br_No" /></SubBankCode>
	
	<!-- ��ϲ�Ʒ���� -->
	<xsl:variable name="ContPlanMult">
		<xsl:choose>
			<xsl:when test="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Ins_Cps=''">
				<xsl:value-of select="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Ins_Cps" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Ins_Cps,'#')" />
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable>
	
	<!-- ����,FIXME ��ȷ�����ձ�ʶMainAndAdlIns_Ind -->
	<xsl:variable name="MainRiskCode">
		<xsl:call-template name="tran_Riskcode">
			<xsl:with-param name="riskcode" select="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Cvr_ID" />
		</xsl:call-template>
	</xsl:variable>
	
	<!-- ��ϲ�Ʒ����, ��ȷ�����ձ�ʶMainAndAdlIns_Ind  -->
	<xsl:variable name="tContPlanCode">
		<xsl:call-template name="tran_ContPlanCode">
			<xsl:with-param name="contPlanCode" select="Busi_List/Busi_Detail[MainAndAdlIns_Ind=1]/Cvr_ID" />
		</xsl:call-template>
	</xsl:variable>
	
	<!-- ��Ʒ��� -->
	<ContPlan>
		<!-- ��Ʒ��ϱ��� -->
		<ContPlanCode><xsl:value-of select="$tContPlanCode" /></ContPlanCode>
		<!-- ��Ʒ��Ϸ��� -->
		<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
	</ContPlan>
	<!-- Ͷ������Ϣ -->
	<xsl:call-template name="Appnt" />
	<!-- ��������Ϣ -->
	<xsl:call-template name="Insured" />		
	<!-- ��������Ϣ -->
	<xsl:apply-templates select="Benf_List/Benf_Detail" />
		
	<xsl:for-each select="Busi_List/Busi_Detail">
		<Risk>
			<RiskCode>
				<xsl:call-template name="tran_Riskcode">
					<xsl:with-param name="riskcode" select="Cvr_ID" />
				</xsl:call-template>
			</RiskCode>
			<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
			<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Ins_Cvr)" /></Amnt>
			<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(InsPrem_Amt)" /></Prem>
			<Mult><xsl:value-of select="format-number(Ins_Cps, '#')" /></Mult>
		    <PayMode></PayMode>
			<PayIntv>
				<xsl:call-template name="tran_InsPrem_PyF_MtdCd">
					<xsl:with-param name="payIntv" select="InsPrem_PyF_MtdCd" />
					<xsl:with-param name="payEndYearFlag" select="InsPrem_PyF_Cyc_Cd" />
				</xsl:call-template>
			</PayIntv>
			<PayEndYearFlag>
				<xsl:call-template name="tran_InsPrem_PyF_Cyc_Cd">
					<xsl:with-param name="payIntv" select="InsPrem_PyF_MtdCd" />
					<xsl:with-param name="payEndYearFlag" select="InsPrem_PyF_Cyc_Cd" />
				</xsl:call-template>
			</PayEndYearFlag>
			<xsl:choose>
				<xsl:when test="InsPrem_PyF_MtdCd='02'">
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:otherwise>
					<PayEndYear><xsl:value-of select="InsPrem_PyF_Prd_Num" /></PayEndYear>
				</xsl:otherwise>
			</xsl:choose>
			<InsuYearFlag>				
				<xsl:call-template name="tran_Ins_Yr_Prd_CgyCd">
					<xsl:with-param name="insuYearType" select="Ins_Yr_Prd_CgyCd" />
					<xsl:with-param name="insuYearFlag" select="Ins_Cyc_Cd" />
				</xsl:call-template>
			</InsuYearFlag>
			<InsuYear>
				<xsl:if test="Ins_Yr_Prd_CgyCd='05'">106</xsl:if>
				<xsl:if test="Ins_Yr_Prd_CgyCd!='05'"><xsl:value-of select="Ins_Ddln" /></xsl:if>
			</InsuYear>
			<BonusGetMode><xsl:apply-templates select="XtraDvdn_Pcsg_MtdCd" /></BonusGetMode>
		</Risk>
	</xsl:for-each>		
</xsl:template>

<!-- Ͷ������Ϣ -->
<xsl:template name="Appnt">
	<Appnt>
		<Name><xsl:value-of select="Plchd_Nm" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				<xsl:with-param name="sex" select="Plchd_Gnd_Cd" />
			</xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="Plchd_Brth_Dt" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Plchd_Crdt_TpCd" />
			</xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="Plchd_Crdt_No" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="Plchd_Crdt_EfDt" /></IDTypeStartDate>
		<IDTypeEndDate><xsl:value-of select="Plchd_Crdt_ExpDt" /></IDTypeEndDate>
		<JobCode>
			<xsl:call-template name="tran_JobCode">
				<xsl:with-param name="jobcode" select="Plchd_Ocp_Cd" />
			</xsl:call-template>
		</JobCode>
		<Salary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Plchd_Yr_IncmAm)" /></Salary>
		<FamilySalary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Fam_Yr_IncmAm)" /></FamilySalary>
		<LiveZone><xsl:apply-templates select="Rsdnt_TpCd" /></LiveZone>
		<RiskAssess></RiskAssess>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality" select="Plchd_Nat_Cd" />
			</xsl:call-template>
		</Nationality>
		<Address><xsl:value-of select="Plchd_Comm_Adr" /></Address>
		<ZipCode><xsl:value-of select="Plchd_ZipECD" /></ZipCode>
		<Mobile><xsl:value-of select="Plchd_Move_TelNo" /></Mobile>
		<xsl:if test="PlchdFixTelDmstDstcNo != '' " >
		   <Phone><xsl:value-of select="PlchdFixTelDmstDstcNo" />-<xsl:value-of select="Plchd_Fix_TelNo" /></Phone>
		</xsl:if>
		<xsl:if test="PlchdFixTelDmstDstcNo = '' " >
		    <Phone><xsl:value-of select="Plchd_Fix_TelNo" /></Phone>
		</xsl:if>
		<Email><xsl:value-of select="Plchd_Email_Adr" /></Email>
		<RelaToInsured><xsl:call-template name="tran_Relation">
				<xsl:with-param name="relation" select="Plchd_And_Rcgn_ReTpCd" />
			</xsl:call-template>
		</RelaToInsured>
		<!-- ���ӱ���Ԥ��������Ĺ�ͨ���ڸýڵ����� -->
		<Premiumbudget><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(//InsPrem_Bdgt_Amt)" /></Premiumbudget>
	</Appnt>
</xsl:template>

<!-- ��������Ϣ -->
<xsl:template name="Insured">
	<Insured>
		<Name><xsl:value-of select="Rcgn_Nm" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				<xsl:with-param name="sex" select="Rcgn_Gnd_Cd" />
			</xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="Rcgn_Brth_Dt" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Rcgn_Crdt_TpCd" />
			</xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="Rcgn_Crdt_No" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="Rcgn_Crdt_EfDt" /></IDTypeStartDate>
		<IDTypeEndDate><xsl:value-of select="Rcgn_Crdt_ExpDt" /></IDTypeEndDate>
		<JobCode>
			<xsl:call-template name="tran_JobCode">
				<xsl:with-param name="jobcode" select="Rcgn_Ocp_Cd" />
			</xsl:call-template>
		</JobCode>
		<Salary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Rcgn_Yr_IncmAm)" /></Salary>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality" select="Rcgn_Nat_Cd" />
			</xsl:call-template>
		</Nationality>
		<Address><xsl:value-of select="Rcgn_Comm_Adr" /></Address>
		<ZipCode><xsl:value-of select="Rcgn_ZipECD" /></ZipCode>
		<Mobile><xsl:value-of select="Rcgn_Move_TelNo" /></Mobile>
		<xsl:if test="RcgnFixTelDmst_DstcNo != '' " >
		    <Phone><xsl:value-of select="RcgnFixTelDmst_DstcNo" />-<xsl:value-of select="Rcgn_Fix_TelNo" /></Phone>
		</xsl:if>
		<xsl:if test="RcgnFixTelDmst_DstcNo = '' " >
		    <Phone><xsl:value-of select="Rcgn_Fix_TelNo" /></Phone>
		</xsl:if>
		<Email><xsl:value-of select="Rcgn_Email_Adr" /></Email>
	</Insured>
</xsl:template>

<!-- ��������Ϣ -->
<xsl:template match="Benf_Detail">
	<Bnf>
		<Type>1</Type>	<!-- Ĭ��Ϊ��1-��������ˡ� -->
		<Grade><xsl:value-of select="Benf_Bnft_Seq" /></Grade>
		<Name><xsl:value-of select="Benf_Nm" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				<xsl:with-param name="sex" select="Benf_Gnd_Cd" />
			</xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="Benf_Brth_Dt" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Benf_Crdt_TpCd" />
			</xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="Benf_Crdt_No" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="Benf_Crdt_EfDt" /></IDTypeStartDate>
		<IDTypeEndDate><xsl:value-of select="Benf_Crdt_ExpDt" /></IDTypeEndDate>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality" select="Benf_Nat_Cd" />
			</xsl:call-template>
		</Nationality>
		<!-- �������(�������ٷֱ�) -->
		<Lot><xsl:value-of select="Bnft_Pct*100" /></Lot>
		<RelaToInsured>
			<xsl:call-template name="tran_Relation_benf">
				<xsl:with-param name="relation" select="Benf_And_Rcgn_ReTpCd" />
			</xsl:call-template>
		</RelaToInsured>
		<!-- FIXME  -->
		<Address><xsl:value-of select="Benf_Comm_Adr" /></Address>
	</Bnf>
</xsl:template>

<!-- �Ա�ת�� -->
<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
	<xsl:choose>
		<xsl:when test="$sex='01'">0</xsl:when>	<!-- ���� -->
		<xsl:when test="$sex='02'">1</xsl:when>	<!-- Ů�� -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ֤������ת�� -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='1010'">0</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1011'">0</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1052'">1</xsl:when>	<!-- ���� -->
		<xsl:when test="$idtype='1020'">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='1030'">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='1040'">5</xsl:when>	<!-- ���ڲ� -->
		<xsl:when test="$idtype=''">9</xsl:when>	<!-- �쳣���֤ -->
		<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

<!-- ְҵ����ת�� -->
<xsl:template name="tran_JobCode">
	<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode='A0000'">1010106</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ������\�����������ؼ��乤������������ -->
		<xsl:when test="$jobcode='C0000'">4040111</xsl:when>	<!-- ������Ա���й���Ա\���ڹ�����Ա -->
		<xsl:when test="$jobcode='B0000'">2021904</xsl:when>	<!-- רҵ������Ա\����ʦ -->
		<xsl:when test="$jobcode='Y0000'">8010101</xsl:when>	<!-- ��������������ҵ��Ա\�޹̶�ְҵ��Ա������ȡ�������ά�����Ƶģ� -->
		<xsl:when test="$jobcode='D0000'">9210102</xsl:when>	<!-- ��ҵ������ҵ��Ա\��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
		<xsl:when test="$jobcode='E0000'">5050104</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա\ũ�û�е������������Ա -->
		<xsl:when test="$jobcode='F0000'">6240107</xsl:when>	<!-- �����������豸������Ա���й���Ա\���û���˾�����泵���ˡ���ҹ��� -->
		<xsl:otherwise></xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

<!-- ��������ת�� -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality" />
	<xsl:choose>
		<xsl:when test="$nationality='392'">JP</xsl:when>	<!-- �ձ� -->
		<xsl:when test="$nationality='410'">KR</xsl:when>	<!-- ���� -->
		<xsl:when test="$nationality='643'">RU</xsl:when>	<!-- ����˹���� -->
		<xsl:when test="$nationality='826'">GB</xsl:when>	<!-- Ӣ�� -->
		<xsl:when test="$nationality='840'">US</xsl:when>	<!-- ���� -->
		<xsl:when test="$nationality='999'">OTH</xsl:when>	<!-- �������Һ͵��� -->
		<xsl:when test="$nationality='36'">AU</xsl:when>	<!-- �Ĵ����� -->
		<xsl:when test="$nationality='124'">CA</xsl:when>	<!-- ���ô� -->
		<xsl:when test="$nationality='156'">CHN</xsl:when>	<!-- �й� -->
		<xsl:otherwise>OTH</xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

<!-- ������Դ -->
<xsl:template match="Rsdnt_TpCd">
	<xsl:choose>
		<xsl:when test=".='1'">1</xsl:when><!--	���� -->
		<xsl:when test=".='2'">2</xsl:when><!--	ũ�� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- ������֪ -->
<xsl:template match="Ntf_Itm_Ind">
	<xsl:choose>
		<xsl:when test=".=1">Y</xsl:when>
		<xsl:otherwise>N</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- ��Ա��ϵ����ת��  ����Ϊ7λ������7λ����λ��"0"
	������������	����ȡֵ	��˾����
		����������	132001	����ͨУ�鲻����¼��
		��������	132002	����ͨУ�鲻����¼��
		ҵ�񾭰���	132003	����ͨУ�鲻����¼��
		һ���Ա	132004	����ͨУ�鲻����¼��
		�߹���Ա	132005	����ͨУ�鲻����¼��
		��ҵ���	133007	����ͨУ�鲻����¼��
		����	133008	����ͨУ�鲻����¼��
		����Ѫ��	133009	04
		��ż	133010	02
		����	133011	03
		Ů��	133012	03
		����	133013	04
		��Ů	133014	04
		����	133015	01
		ĸ��	133016	01
		�游	133017	04
		��ĸ	133018	04
		���	133019	04
		���	133020	04
		��������	133021	04
		���游	133031	04
		����ĸ	133032	04
		����	133033	04
		����Ů	133034	04
		�ܵ�	133035	04
		����	133036	04
		����	133037	04
		����	133038	04
		��ϱ	133039	04
		����	133040	04
		��ĸ	133041	04
		Ů��	133042	04
		����	133043	00
		������ϵ	133999	04
			
 -->

<xsl:template name="tran_Relation">
	<xsl:param name="relation" />
	<xsl:choose>
		<xsl:when test="$relation='0133043'">00</xsl:when>	<!-- ���� -->
		<xsl:when test="$relation='0133015'">03</xsl:when>	<!-- ��ĸ -->
		<xsl:when test="$relation='0133016'">03</xsl:when>	<!-- ��ĸ -->
		<xsl:when test="$relation='0133010'">02</xsl:when>	<!-- ��ż -->
		<xsl:when test="$relation='0133011'">01</xsl:when>	<!-- ��Ů -->
		<xsl:when test="$relation='0133012'">01</xsl:when>	<!-- ��Ů -->
		<xsl:otherwise>04</xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<xsl:template name="tran_Relation_benf">
	<xsl:param name="relation" />
	<xsl:choose>
		<xsl:when test="$relation='0133043'">00</xsl:when>	<!-- ���� -->
		<xsl:when test="$relation='0133015'">01</xsl:when>	<!-- ��ĸ -->
		<xsl:when test="$relation='0133016'">01</xsl:when>	<!-- ��ĸ -->
		<xsl:when test="$relation='0133010'">02</xsl:when>	<!-- ��ż -->
		<xsl:when test="$relation='0133011'">03</xsl:when>	<!-- ��Ů -->
		<xsl:when test="$relation='0133012'">03</xsl:when>	<!-- ��Ů -->
		<xsl:otherwise>04</xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>		
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- ����ʢ��1���������գ������ͣ�A -->	
		<xsl:when test="$riskcode='L12091'">L12091</xsl:when> 	<!-- �����Ӯ1�������A�� -->	
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ��ϲ�Ʒ���� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<!-- <xsl:when test="$contPlanCode='50002'">50015</xsl:when>-->	<!-- �������Ӯ���ռƻ� -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- ���нɷ�Ƶ�Σ�-1�������ڽ���0��������1���½���3��������6�����꽻��12�꽻��98 ����ĳȷ�����䣬99 �������� -->
<xsl:template name="tran_InsPrem_PyF_MtdCd">
	<xsl:param name="payIntv" />
	<xsl:param name="payEndYearFlag" />
	<xsl:choose>
		<xsl:when test="$payIntv='01'">-1</xsl:when><!--	�����ڽ� -->
		<xsl:when test="$payIntv='02'">0</xsl:when><!--	���� -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0201'">3</xsl:when><!--	���� -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0202'">6</xsl:when><!--	����� -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0203'">12</xsl:when><!--	��� -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0204'">1</xsl:when><!--	�½� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- �ɷ��������� -->
<xsl:template name="tran_InsPrem_PyF_Cyc_Cd">
	<xsl:param name="payIntv" />
	<xsl:param name="payEndYearFlag" />
	<xsl:choose>
		<xsl:when test="$payIntv='02'">Y</xsl:when><!--	���� -->
		<xsl:when test="$payIntv='04'">A</xsl:when><!--	��ĳȷ������ -->
		<xsl:when test="$payIntv='05'">A</xsl:when><!--	���� -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0203'">Y</xsl:when><!--	��� -->
		<xsl:when test="$payIntv='03' and $payEndYearFlag='0204'">M</xsl:when><!--	�½� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- ������������ -->
<xsl:template name="tran_Ins_Yr_Prd_CgyCd">
	<xsl:param name="insuYearType" />
	<xsl:param name="insuYearFlag" />
	<xsl:choose>
		<xsl:when test="$insuYearType='03' and $insuYearFlag='03'">Y</xsl:when><!--	���� -->
		<xsl:when test="$insuYearType='03' and $insuYearFlag='04'">M</xsl:when><!--	���� -->
		<xsl:when test="$insuYearType='04'">A</xsl:when><!--	��ĳȷ������ -->
		<xsl:when test="$insuYearType='05'">A</xsl:when><!--	���� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- ������ȡ��ʽ -->
<xsl:template match="XtraDvdn_Pcsg_MtdCd">
	<xsl:choose>
		<xsl:when test=".=0">2</xsl:when>	<!-- ֱ�Ӹ��� -->
		<xsl:when test=".=1">3</xsl:when>	<!-- �ֽ����� -->
		<xsl:when test=".=2">1</xsl:when>	<!-- �ۼ���Ϣ -->
		<xsl:when test=".=3">5</xsl:when>	<!-- �����  -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ���ڽ���ȡ��ʽ -->
<xsl:template match="ExpPrmmRcvModCgyCd">
</xsl:template>

<!-- ���б�����������: 10010003=��ҵ������10010001=����������10010002=˽�������������� 10030006���ֻ�����-->
	<xsl:template match="TXN_ITT_CHNL_CGY_CODE">
		<xsl:choose>
			<xsl:when test=".='10010003'">1</xsl:when><!-- ��ҵ����:���� -->
			<xsl:when test=".='10010001'">1</xsl:when><!-- ��������:���� -->
			<xsl:when test=".='10010002'">1</xsl:when><!-- ˽��������������:���� -->
			<xsl:when test=".='10030006'">17</xsl:when><!-- �ֻ����� -->
			<xsl:when test=".='10110109'">8</xsl:when><!-- �����ն� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
