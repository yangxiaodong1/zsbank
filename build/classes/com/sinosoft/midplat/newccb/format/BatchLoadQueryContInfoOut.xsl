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

	<Insu_List>
		<xsl:for-each select="Detail">
		<Insu_Detail>
			<!-- ���չ�˾��� -->
			<Ins_Co_ID>010058</Ins_Co_ID>
			<!-- ���չ�˾���� -->
			<Ins_Co_Nm>�������ٱ������޹�˾</Ins_Co_Nm>
			<!-- ���д����־ 0-��  1-�� -->
			<CCB_Agnc_Ind>1</CCB_Agnc_Ind>
			<!-- �������ײͱ�� -->
			<AgIns_Pkg_ID></AgIns_Pkg_ID>
			<!-- �ײ����� -->
			<Pkg_Nm></Pkg_Nm>
			<!-- ����ģ�����ʹ��� -->
			<Intfc_Tpl_TpCd></Intfc_Tpl_TpCd>
			<!-- Ͷ�������� -->
			<Plchd_Nm><xsl:value-of select="Appnt/Name" /></Plchd_Nm>
			<!-- Ͷ�����Ա���� -->
			<Plchd_Gnd_Cd>
				<xsl:call-template name="tran_Sex">
					<xsl:with-param name="sex" select="Appnt/Sex" />
				</xsl:call-template>
			</Plchd_Gnd_Cd>
			<!-- Ͷ���˳������� -->
			<Plchd_Brth_Dt><xsl:value-of select="Appnt/Birthday" /></Plchd_Brth_Dt>
			<!-- Ͷ����֤�����ʹ��� -->
			<Plchd_Crdt_TpCd>
				<xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="Appnt/IDType" />
				</xsl:call-template>
			</Plchd_Crdt_TpCd>
			<Plchd_Crdt_No><xsl:value-of select="Appnt/IDNo" /></Plchd_Crdt_No>
			<!-- Ͷ����֤��ʧЧ���� -->
			<Plchd_Crdt_EfDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Appnt/IDTypeStartDate)" /></Plchd_Crdt_EfDt>
			<!-- 
			<Plchd_Crdt_ExpDt>20400101</Plchd_Crdt_ExpDt>
			 -->
			<Plchd_Crdt_ExpDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Appnt/IDTypeEndDate)" /></Plchd_Crdt_ExpDt>
			<!-- add 20150820 ��һ��2.2�汾����  Ͷ������ϵ��ַ���ҵ������� -->
			<PlchdCtcAdrCtyRgon_Cd></PlchdCtcAdrCtyRgon_Cd>			
			<!-- add 20150820 ��һ��2.2�汾����  Ͷ����ʡ���� -->
			<Plchd_Prov_Cd></Plchd_Prov_Cd>
			<!-- add 20150820 ��һ��2.2�汾����  Ͷ�����д��� -->
			<Plchd_City_Cd></Plchd_City_Cd>
			<!-- add 20150820 ��һ��2.2�汾����  Ͷ�������ش��� -->
			<Plchd_CntyAndDstc_Cd></Plchd_CntyAndDstc_Cd>
			<!-- add 20150820 ��һ��2.2�汾����  Ͷ������ϸ��ַ���� -->
			<Plchd_Dtl_Adr_Cntnt></Plchd_Dtl_Adr_Cntnt>
			<!-- add 20150820 ��һ��2.2�汾����  Ͷ���˹̶��绰�������� -->
			<PlchdFixTelItnlDstcNo></PlchdFixTelItnlDstcNo>
			<!-- add 20150820 ��һ��2.2�汾����  Ͷ���˹̶��绰�������� -->
			<PlchdFixTelDmstDstcNo><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.PhoneToDstcNo(Appnt/Phone)"/></PlchdFixTelDmstDstcNo>
			<!-- add 20150820 ��һ��2.2�汾����  Ͷ�����ƶ��绰�������� -->
			<PlchdMoveTelItlDstcNo></PlchdMoveTelItlDstcNo>		
			<!-- Ͷ���˹������� -->
			<Plchd_Nat_Cd>
				<xsl:call-template name="tran_Nationality">
					<xsl:with-param name="nationality" select="Appnt/Nationality" />
				</xsl:call-template>
			</Plchd_Nat_Cd>
			<!-- Ͷ����ͨѶ��ַ -->
			<Plchd_Comm_Adr><xsl:value-of select="Appnt/Address" /></Plchd_Comm_Adr>
			<!-- Ͷ������������ -->
			<Plchd_ZipECD><xsl:value-of select="Appnt/ZipCode" /></Plchd_ZipECD>
			<!-- Ͷ���˹̶��绰���� -->
			<Plchd_Fix_TelNo><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.PhoneToTelNo(Appnt/Phone)"/></Plchd_Fix_TelNo>
			<!-- Ͷ�����ƶ��绰���� -->
			<Plchd_Move_TelNo><xsl:value-of select="Appnt/Mobile" /></Plchd_Move_TelNo>
			<!-- Ͷ���˵����ʼ���ַ -->
			<!-- 
			<Plchd_Email_Adr>dianziyoujian@126.com</Plchd_Email_Adr>
			 -->
			<Plchd_Email_Adr><xsl:value-of select="Appnt/Email" /></Plchd_Email_Adr>
			<!-- Ͷ����ְҵ���� -->
			<Plchd_Ocp_Cd>
				<xsl:call-template name="tran_JobCode">
					<xsl:with-param name="jobcode" select="Appnt/JobCode" />
				</xsl:call-template>
			</Plchd_Ocp_Cd>
			<!-- Ͷ������������ -->
			<Plchd_Yr_IncmAm><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Appnt/Salary)"/></Plchd_Yr_IncmAm>
			<!-- ��ͥ�������� -->
			<Fam_Yr_IncmAm><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Appnt/FamilySalary)"/></Fam_Yr_IncmAm>
			<!-- �������ʹ��� -->
			<Rsdnt_TpCd><xsl:apply-templates select="Appnt/LiveZone" /></Rsdnt_TpCd>
			<!-- FIXME Ͷ���˺ͱ����˹�ϵ���ʹ��� -->
			<!-- 
			<Plchd_And_Rcgn_ReTpCd>133010</Plchd_And_Rcgn_ReTpCd>\
			 -->
			 <Plchd_And_Rcgn_ReTpCd>
				<xsl:call-template name="tran_RelationRoleCode">
				    <xsl:with-param name="relaToInsured"><xsl:value-of select="Appnt/RelaToInsured"/></xsl:with-param>
					<xsl:with-param name="insuredSex"><xsl:value-of select="Insured/Sex"/></xsl:with-param>
				</xsl:call-template>			
			</Plchd_And_Rcgn_ReTpCd>
			<!-- ���������� -->
			<Rcgn_Nm><xsl:value-of select="Insured/Name" /></Rcgn_Nm>
			<!-- ������ƴ��ȫ�� -->
			<Rcgn_CPA_FullNm />
			<!-- �������Ա���� -->
			<Rcgn_Gnd_Cd>
				<xsl:call-template name="tran_Sex">
					<xsl:with-param name="sex" select="Insured/Sex" />
				</xsl:call-template>
			</Rcgn_Gnd_Cd>
			<!-- �����˳������� -->
			<Rcgn_Brth_Dt><xsl:value-of select="Insured/Birthday" /></Rcgn_Brth_Dt>
			<!-- ������֤�����ʹ��� -->
			<Rcgn_Crdt_TpCd>
				<xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="Insured/IDType" />
				</xsl:call-template>
			</Rcgn_Crdt_TpCd>
			<!-- ������֤������ -->
			<Rcgn_Crdt_No><xsl:value-of select="Insured/IDNo" /></Rcgn_Crdt_No>
			<!-- ������֤����Ч���� -->
			<!-- 
			<Rcgn_Crdt_EfDt>20100101</Rcgn_Crdt_EfDt>
			-->
			<Rcgn_Crdt_EfDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Insured/IDTypeStartDate)" /></Rcgn_Crdt_EfDt>
			 
			<!-- ������֤��ʧЧ���� -->
			<!-- 
			<Rcgn_Crdt_ExpDt>20400101</Rcgn_Crdt_ExpDt>
			 -->
			<Rcgn_Crdt_ExpDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Insured/IDTypeEndDate)" /></Rcgn_Crdt_ExpDt>
			<!-- add 20150820 ��һ��2.2�汾����  ��������ϵ��ַ���ҵ������� -->
			<RcgnCtcAdr_CtyRgon_Cd></RcgnCtcAdr_CtyRgon_Cd>			
			<!-- add 20150820 ��һ��2.2�汾����  ������ʡ���� -->
			<Rcgn_Prov_Cd></Rcgn_Prov_Cd>
			<!-- add 20150820 ��һ��2.2�汾����  �������д��� -->
			<Rcgn_City_Cd></Rcgn_City_Cd>
			<!-- add 20150820 ��һ��2.2�汾����  ���������ش��� -->
			<Rcgn_CntyAndDstc_Cd></Rcgn_CntyAndDstc_Cd>
			<!-- add 20150820 ��һ��2.2�汾����  ��������ϸ��ַ���� -->
			<Rcgn_Dtl_Adr_Cntnt></Rcgn_Dtl_Adr_Cntnt>
			<!-- add 20150820 ��һ��2.2�汾����  �����˹̶��绰�������� -->
			<RcgnFixTelItnl_DstcNo></RcgnFixTelItnl_DstcNo>
			<!-- add 20150820 ��һ��2.2�汾����  �����˹̶��绰�������� -->
			<RcgnFixTelDmst_DstcNo><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.PhoneToDstcNo(Insured/Phone)"/></RcgnFixTelDmst_DstcNo>
			<!-- add 20150820 ��һ��2.2�汾����  �������ƶ��绰�������� -->
			<RcgnMoveTelItnlDstcNo></RcgnMoveTelItnlDstcNo>		
			<!-- �����˹������� -->
			<Rcgn_Nat_Cd>
				<xsl:call-template name="tran_Nationality">
					<xsl:with-param name="nationality" select="Insured/Nationality" />
				</xsl:call-template>
			</Rcgn_Nat_Cd>
			<!-- ������ͨѶ��ַ -->
			<Rcgn_Comm_Adr><xsl:value-of select="Insured/Address" /></Rcgn_Comm_Adr>
			<!-- �������������� -->
			<Rcgn_ZipECD><xsl:value-of select="Insured/ZipCode" /></Rcgn_ZipECD>
			<!-- �����˹̶��绰���� -->
			<Rcgn_Fix_TelNo><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.PhoneToTelNo(Insured/Phone)"/></Rcgn_Fix_TelNo>
			<!-- �������ƶ��绰���� -->
			<Rcgn_Move_TelNo><xsl:value-of select="Insured/Mobile" /></Rcgn_Move_TelNo>
			<!-- �����˵����ʼ���ַr -->
			<!-- 
			<Rcgn_Email_Adr>dianziyoujian@126.com</Rcgn_Email_Adr>
			 -->
			<Rcgn_Email_Adr><xsl:value-of select="Insured/Email" /></Rcgn_Email_Adr>
			<!-- ������ְҵ���� -->
			<Rcgn_Ocp_Cd>
				<xsl:call-template name="tran_JobCode">
					<xsl:with-param name="jobcode" select="Insured/JobCode" />
				</xsl:call-template>
			</Rcgn_Ocp_Cd>
			<!-- �������������� -->
			<Rcgn_Yr_IncmAm><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Insured/Salary)"/></Rcgn_Yr_IncmAm>
			<!-- δ�������ۼƱ��� -->
			<Minr_Acm_Cvr></Minr_Acm_Cvr>
			<!-- ������ǰ��Ŀ�ĵظ��� -->
			<Rcgn_LvFr_Pps_Lnd_Num>0</Rcgn_LvFr_Pps_Lnd_Num>
			<!-- Ŀ�ĵ���Ϣѭ������� -->
			<Pps_List>
				<Pps_Detail>
					<!-- ������ǰ��Ŀ�ĵ� -->
					<Rcgn_LvFr_Pps_Lnd></Rcgn_LvFr_Pps_Lnd>
				</Pps_Detail>
				<Pps_Detail>
					<!-- ������ǰ��Ŀ�ĵ� -->
					<Rcgn_LvFr_Pps_Lnd></Rcgn_LvFr_Pps_Lnd>
				</Pps_Detail>
			</Pps_List>
			<!-- �����˸��� -->
			<Benf_Num><xsl:value-of select="count(Bnf)" /></Benf_Num>
			<Benf_List>
				<xsl:for-each select="Bnf">
					<Benf_Detail>
						<!-- ���������������ʹ��� -->
						<AgIns_Benf_TpCd><xsl:apply-templates select="Type" /></AgIns_Benf_TpCd>
						<!-- ��ű�� -->
						<SN_ID></SN_ID>
						<!-- �������������ֵ -->
						<AgIns_Bnft_Ord_Val><xsl:value-of select="Grade" /></AgIns_Bnft_Ord_Val>
						<!-- ���������� -->
						<Benf_Nm><xsl:value-of select="Name" /></Benf_Nm>
						<!-- �������Ա���� -->
						<!-- 
						<Benf_Gnd_Cd>01</Benf_Gnd_Cd>
						 -->
						<Benf_Gnd_Cd>
							<xsl:call-template name="tran_Sex">
								<xsl:with-param name="sex" select="Sex" />
							</xsl:call-template>
						</Benf_Gnd_Cd>
						<!-- FIXME �����˳������� -->
						<!-- 
						<Benf_Brth_Dt>20140101</Benf_Brth_Dt>
						 -->
						<Benf_Brth_Dt><xsl:value-of select="Birthday" /></Benf_Brth_Dt>
						<!-- ������֤�����ʹ��� -->
						<Benf_Crdt_TpCd>
							<xsl:call-template name="tran_IDType">
								<xsl:with-param name="idtype" select="IDType" />
							</xsl:call-template>
						</Benf_Crdt_TpCd>
						<!-- ������֤������ -->
						<Benf_Crdt_No><xsl:value-of select="IDNo" /></Benf_Crdt_No>
						<!-- FIXME ������֤����Ч���� -->
						<xsl:if test="IDTypeStartDate != ''">
						   <Benf_Crdt_EfDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(IDTypeStartDate)" /></Benf_Crdt_EfDt>
						</xsl:if>
						<xsl:if test="IDTypeStartDate = ''">
						   <Benf_Crdt_EfDt><xsl:value-of select="IDTypeStartDate" /></Benf_Crdt_EfDt>
						</xsl:if>
						<!-- 
						<Benf_Crdt_EfDt>20100101</Benf_Crdt_EfDt>
						 -->
						<!-- FIXME ������֤��ʧЧ���� -->
						<!-- 
						<Benf_Crdt_ExpDt>20400101</Benf_Crdt_ExpDt>
						 -->
						<xsl:if test="IDTypeEndDate != ''">
						   <Benf_Crdt_ExpDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(IDTypeEndDate)" /></Benf_Crdt_ExpDt>
						</xsl:if>
						<xsl:if test="IDTypeEndDate = ''">
						   <Benf_Crdt_ExpDt><xsl:value-of select="IDTypeEndDate" /></Benf_Crdt_ExpDt>
						</xsl:if>
						<!-- add 20150820 ��һ��2.2�汾����  ��������ϵ��ַ���ҵ������� -->
			            <BenfCtcAdr_CtyRgon_Cd></BenfCtcAdr_CtyRgon_Cd>			
			            <!-- add 20150820 ��һ��2.2�汾����  ������ʡ���� -->
			            <Benf_Prov_Cd></Benf_Prov_Cd>
			            <!-- add 20150820 ��һ��2.2�汾����  �������д��� -->
			            <Benf_City_Cd></Benf_City_Cd>
			            <!-- add 20150820 ��һ��2.2�汾����  ���������ش��� -->
			            <Benf_CntyAndDstc_Cd></Benf_CntyAndDstc_Cd>
			            <!-- add 20150820 ��һ��2.2�汾����  ��������ϸ��ַ���� -->
			            <Benf_Dtl_Adr_Cntnt></Benf_Dtl_Adr_Cntnt>
						<!-- �����˹������� -->
						<Benf_Nat_Cd>
							<xsl:call-template name="tran_Nationality">
								<xsl:with-param name="nationality" select="Nationality" />
							</xsl:call-template>
						</Benf_Nat_Cd>
						<!-- FIXME �������뱻���˹�ϵ -->
						<!-- 
						<Benf_And_Rcgn_ReTpCd>133011</Benf_And_Rcgn_ReTpCd>
						-->
						<Benf_And_Rcgn_ReTpCd>
							<xsl:call-template name="tran_RelationRoleCode">
			                    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
			                    <xsl:with-param name="insuredSex"><xsl:value-of select="../Insured/Sex"/></xsl:with-param>
			                </xsl:call-template>
						</Benf_And_Rcgn_ReTpCd>
						<!-- ������� ������Ҫ��С�������λ����dive�������� -->
						<!-- <Bnft_Pct><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Lot)" /></Bnft_Pct>-->
						<Bnft_Pct><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.forDecimal(Lot,4)" /></Bnft_Pct>
						<!-- FIXME ������ͨѶ��ַ -->
						<!-- 
						<Benf_Comm_Adr>�����н���������8��</Benf_Comm_Adr>
						 -->
						<Benf_Comm_Adr><xsl:value-of select="Address" /></Benf_Comm_Adr>
						
					</Benf_Detail>
				</xsl:for-each>
			</Benf_List>
			<Rvl_Rcrd_Num><xsl:value-of select="count(Risk[RiskCode=MainRiskCode])" /></Rvl_Rcrd_Num>
			<Busi_List>
				<xsl:for-each select="Risk[RiskCode=MainRiskCode]">
					<Busi_Detail>
						<!-- ���ֱ�� -->
						<Cvr_ID>
							<xsl:call-template name="tran_Riskcode">
								<xsl:with-param name="riskcode" select="RiskCode" />
							</xsl:call-template>
						</Cvr_ID>
						<!-- �������� -->
						<Cvr_Nm><xsl:value-of select="RiskName" /></Cvr_Nm>
						<!-- �����ձ�־ -->
						<MainAndAdlIns_Ind>
							<xsl:choose>
								<xsl:when test="RiskCode=MainRiskCode">1</xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</MainAndAdlIns_Ind>
						<!-- Ͷ������ -->
						<Ins_Cps><xsl:value-of select="Mult" /></Ins_Cps>
						<!-- ���ѽ�� -->
						<InsPrem_Amt>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
						</InsPrem_Amt>
						<!-- Ͷ������ -->
						<Ins_Cvr></Ins_Cvr>
						<!-- Ͷ��������Ϣ -->
						<Ins_Scm_Inf></Ins_Scm_Inf>
						<!-- ��ѡ������ʱ��ս�� -->
						<Opt_Part_DieIns_Amt></Opt_Part_DieIns_Amt>
						<!-- �״ζ���׷�ӱ��� -->
						<FTm_Extr_Adl_InsPrem></FTm_Extr_Adl_InsPrem>
						<!-- Ͷ�ʷ�ʽ���� -->
						<Ivs_MtdCd></Ivs_MtdCd>
						<!-- �����˺� -->
						<CCB_AccNo></CCB_AccNo>
						<!-- �������������� -->
						<Ins_Yr_Prd_CgyCd><xsl:apply-templates select="PayIntv" mode="payintv"/></Ins_Yr_Prd_CgyCd>
						<!-- �������� -->
						<Ins_Ddln><xsl:value-of select="InsuYear" /></Ins_Ddln>
						<!-- �������ڴ��� -->
						<Ins_Cyc_Cd><xsl:apply-templates select="InsuYearFlag" /></Ins_Cyc_Cd>
						<!-- ���ѽɷѷ�ʽ���� -->
						<InsPrem_PyF_MtdCd><xsl:apply-templates select="PayIntv" mode="payintv" /></InsPrem_PyF_MtdCd>
						<!-- ���ѽɷ����� -->
						<InsPrem_PyF_Prd_Num>
							<xsl:choose>
								<xsl:when test="PayIntv = '0'">0</xsl:when>
								<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
							</xsl:choose>
						</InsPrem_PyF_Prd_Num>
						<!-- ���ѽɷ����ڴ��� -->
						<InsPrem_PyF_Cyc_Cd><xsl:apply-templates select="PayIntv" mode="zhouqi"/></InsPrem_PyF_Cyc_Cd>
						<!-- �ر�Լ����Ϣ -->
						<Spcl_Apnt_Inf></Spcl_Apnt_Inf>
						<!-- �����ȡ������ -->
						<Anuty_Drw_CgyCd></Anuty_Drw_CgyCd>
						<!-- �����ȡ���� -->
						<Anuty_Drw_Prd_Num></Anuty_Drw_Prd_Num>
						<!-- �����ȡ���ڴ��� -->
						<Anuty_Drw_Cyc_Cd></Anuty_Drw_Cyc_Cd>
						<!-- �����ʽ���� -->
						<Anuty_Pcsg_MtdCd></Anuty_Pcsg_MtdCd>
						<!-- ���ڱ��ս���ȡ��ʽ������ -->
						<ExpPrmmRcvModCgyCd>001</ExpPrmmRcvModCgyCd>
						<!-- �������ȡ���ڴ��� -->
						<SvBnf_Drw_Cyc_Cd></SvBnf_Drw_Cyc_Cd>
						<!-- ��������ʽ���� 0	ֱ�Ӹ���,1	�ֽ�����,2	�ۼ���Ϣ,3	����� -->
						<XtraDvdn_Pcsg_MtdCd><xsl:apply-templates select="BonusGetMode" /></XtraDvdn_Pcsg_MtdCd>
						<!-- Լ�����ѵ潻��־ -->
						<ApntInsPremPyAdvnInd><xsl:apply-templates select="AutoPayFlag" /></ApntInsPremPyAdvnInd>
						<!-- �Զ�������־ -->
						<Auto_RnwCv_Ind></Auto_RnwCv_Ind>
						
						<!-- ���������־ -->
						<XtraDvdn_Alct_Ind></XtraDvdn_Alct_Ind>
						<!-- ������־ -->
						<RdAmtPyCls_Ind></RdAmtPyCls_Ind>
						<!-- ���ս��ݼ���ʽ���� -->
						<Ins_Amt_Dgrs_MtdCd></Ins_Amt_Dgrs_MtdCd>
						<!-- ������Ч���� -->
						<InsPolcy_EfDt><xsl:value-of select="CValiDate" /></InsPolcy_EfDt>
						<!-- ��������Ч���� -->
						<InsPolcy_Intnd_EfDt></InsPolcy_Intnd_EfDt>
						<!-- ����ʧЧ���� -->
						<InsPolcy_ExpDt><xsl:value-of select="InsuEndDate" /></InsPolcy_ExpDt>
						<!-- ������ϵ�� -->
						<Emgr_CtcPsn></Emgr_CtcPsn>
						<!-- ������ϵ�˺ͱ����˹�ϵ���ʹ��� -->
						<EmgrCtcPsnAndRcReTpCd></EmgrCtcPsnAndRcReTpCd>
						<!-- ������ϵ�绰 -->
						<Emgr_Ctc_Tel></Emgr_Ctc_Tel>
						<!-- ���д����ͬ��� ��һ������2.2�汾����Ϊ �����մ����ͬ���
						<Bnk_Loan_Ctr_ID></Bnk_Loan_Ctr_ID>-->
						<AgIns_Ln_Ctr_ID></AgIns_Ln_Ctr_ID>
						<!-- �����ͬʧЧ���� -->
						<Ln_Ctr_ExpDt></Ln_Ctr_ExpDt>
						<!-- δ�������� -->
						<Upd_Loan_Amt></Upd_Loan_Amt>
						<!-- ��������ƾ֤���� -->
						<PrimBlInsPolcyVchr_No></PrimBlInsPolcyVchr_No>
						<!-- Ͷ�����˻����� -->
						<IvLkIns_Acc_Num>0</IvLkIns_Acc_Num>
						<PayAcctCode_List>
							<PayAcctCode_Detail>
								<ILIVA_ID></ILIVA_ID>
								<ILIVA_Nm></ILIVA_Nm>
								<Ivs_Tp_Alct_Pctg></Ivs_Tp_Alct_Pctg>
								<Adl_Ins_Fee_Alct_Pctg></Adl_Ins_Fee_Alct_Pctg>
							</PayAcctCode_Detail>
						</PayAcctCode_List>
						<!-- �����ֶ�һ -->
						<Rsrv_Fld_1></Rsrv_Fld_1>
						<Rsrv_Fld_2></Rsrv_Fld_2>
						<Rsrv_Fld_3></Rsrv_Fld_3>
						<Rsrv_Fld_4></Rsrv_Fld_4>
						<Rsrv_Fld_5></Rsrv_Fld_5>
						<Rsrv_Fld_6></Rsrv_Fld_6>
						<Rsrv_Fld_7></Rsrv_Fld_7>
						<Rsrv_Fld_8></Rsrv_Fld_8>
						<Rsrv_Fld_9></Rsrv_Fld_9>
						<Rsrv_Fld_10></Rsrv_Fld_10>
					</Busi_Detail>
				</xsl:for-each>
			</Busi_List>
			<!-- �������� -->
			<Ins_BillNo><xsl:value-of select="ProposalPrtNo" /></Ins_BillNo>
			<!-- ������ -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- Ͷ���˽ɷ��˺� -->
			<Plchd_PyF_AccNo><xsl:value-of select="AccNo" /></Plchd_PyF_AccNo>
			<!-- Ͷ������ȡ�˺� -->
			<Plchd_Drw_AccNo></Plchd_Drw_AccNo>
			<!-- �������˺� -->
			<Rcgn_AccNo></Rcgn_AccNo>
			<!-- �������˺� -->
			<Benf_AccNo></Benf_AccNo>
			<!-- ���ڽɷ�֧����ʽ���� -->
			<Rnew_PyF_PyMd_Cd>2</Rnew_PyF_PyMd_Cd>
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
			<!-- �����տͻ��������ʹ��� -->
			<AgIns_Cst_Line_TpCd></AgIns_Cst_Line_TpCd>
			<!-- �����������ʹ��� -->
			<InsPolcy_Medm_TpCd></InsPolcy_Medm_TpCd>
			<!-- ���л������ -->
			<CCBIns_ID></CCBIns_ID>
			<!-- һ�����к� -->
			<Lv1_Br_No><xsl:value-of select="SubBankCode" /></Lv1_Br_No>
			<!-- ���㱣�ռ�ְ����ҵ�����֤���� -->
			<BOInsPrAgnBsnLcns_ECD><xsl:value-of select="AgentComCertiCode" /></BOInsPrAgnBsnLcns_ECD>
			<!-- ����ֹܴ�����ҵ�����˱�� -->
			<BOIChOfAgInsBsnPnp_ID></BOIChOfAgInsBsnPnp_ID>
			<!-- ����ֹܴ�����ҵ���������� -->
			<BOIChOfAgInsBsnPnp_Nm></BOIChOfAgInsBsnPnp_Nm>
			<!-- Ͷ�������˱�� -->
			<Ins_Mnplt_Psn_ID></Ins_Mnplt_Psn_ID>
			<!-- ����������Ա��� -->
			<!--  <BO_Sale_Stff_ID><xsl:value-of select="SellerNo" /></BO_Sale_Stff_ID>	-->		
			<BO_Sale_Stff_ID><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.InsuToBankBoSaleStffID(SellerNo)" /></BO_Sale_Stff_ID>
			<!-- ����������Ա���� -->
			<BO_Sale_Stff_Nm><xsl:value-of select="TellerName" /></BO_Sale_Stff_Nm>			
			<!-- ������Ա�����մ�ҵ��Ա�ʸ�֤���� -->
			<Sale_Stff_AICSQCtf_ID><xsl:value-of select="TellerCertiCode" /></Sale_Stff_AICSQCtf_ID>
			<!-- �Ƽ��ͻ������� -->
			<RcmCst_Mgr_ID></RcmCst_Mgr_ID>
			<!-- �Ƽ��ͻ��������� -->
			<RcmCst_Mgr_Nm></RcmCst_Mgr_Nm>
			<!-- ����ר�������� -->
			<Ins_Prj_CgyCd></Ins_Prj_CgyCd>
			<!-- ���ѳ��������� -->
			<PydFeeOutBill_CgyCd></PydFeeOutBill_CgyCd>
			<!-- ����ʵ�����۵������ -->
			<InsPolcyActSaleRgonID></InsPolcyActSaleRgonID>
			<!-- ���տͻ������ṩ������� -->
			<Ins_CsLs_Prvd_Rgon_ID></Ins_CsLs_Prvd_Rgon_ID>
			<!-- ������ȡ��ʽ���� -->
			<InsPolcy_Rcv_MtdCd></InsPolcy_Rcv_MtdCd>
			<!-- ���鴦��ʽ���� -->
			<Dspt_Pcsg_MtdCd>
			   <xsl:if test="DisputedFag = ''">03</xsl:if>
			   <xsl:if test="DisputedFag != ''">
			      <xsl:apply-templates select="DisputedFag" />
			   </xsl:if>			     
			</Dspt_Pcsg_MtdCd>
			<!--<Dspt_Pcsg_MtdCd>03</Dspt_Pcsg_MtdCd> -->
			<!-- �����ٲû������� -->
			<Dspt_Arbtr_Inst_Nm><xsl:value-of select="DisputedName" /></Dspt_Arbtr_Inst_Nm>			
			<Rsrv_Fld_10_1></Rsrv_Fld_10_1>
			<Rsrv_Fld_10_2></Rsrv_Fld_10_2>
			<Rsrv_Fld_10_3></Rsrv_Fld_10_3>
			<Rsrv_Fld_10_4></Rsrv_Fld_10_4>
			<Rsrv_Fld_10_5></Rsrv_Fld_10_5>
			<Rsrv_Fld_10_6></Rsrv_Fld_10_6>
			<Rsrv_Fld_10_7></Rsrv_Fld_10_7>
			<Rsrv_Fld_10_8></Rsrv_Fld_10_8>
			<Rsrv_Fld_10_9></Rsrv_Fld_10_9>
			<Rsrv_Fld_10_10></Rsrv_Fld_10_10>
			<Pstcrpt_Rmrk></Pstcrpt_Rmrk>
			<!-- ��֪�����־ 0 �޸�֪���� -->
			<Ntf_Itm_Ind>0</Ntf_Itm_Ind>
			<!-- add 20150826 ������һ��2.2�汾�����ֶ���Ϣ begin-->
			<!-- ����ʵ�ʷ������� -->
			<XtraDvdn_Act_Dstr_Dt></XtraDvdn_Act_Dstr_Dt>
			<!-- ���ں������ -->
			<CrnPrd_XtDvdAmt></CrnPrd_XtDvdAmt>
			<!-- ���˺������ -->
			<ATEndOBns_Amt></ATEndOBns_Amt>
			<!-- �ۻ�������� -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
			<!-- add 20150826 ������һ��2.2�汾�����ֶ���Ϣ end-->
		</Insu_Detail>
		</xsl:for-each>
	</Insu_List>
	
	
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
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	<!-- �������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='122046'">50002</xsl:when>	<!-- �������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  begin -->
		<xsl:when test="$riskcode='50012'">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
		<xsl:when test="$riskcode='L12070'">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  end -->
		<!-- �������ִ��벢�� -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1�������գ������ͣ�B�� -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='122035'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='50002'">50002</xsl:when>	<!-- �������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- ����ʢ��1����ȫ���գ������ͣ� -->
		
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


<!-- �Ա�ת�� -->
<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
	<xsl:choose>
		<xsl:when test="$sex='0'">01</xsl:when>	<!-- ���� -->
		<xsl:when test="$sex='1'">02</xsl:when>	<!-- Ů�� -->
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

<!-- ��������ת�� -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality" />
	<xsl:choose>
		<xsl:when test="$nationality='JP'">392</xsl:when>	<!-- �ձ� -->
		<xsl:when test="$nationality='KR'">410</xsl:when>	<!-- ���� -->
		<xsl:when test="$nationality='RU'">643</xsl:when>	<!-- ����˹���� -->
		<xsl:when test="$nationality='GB'">826</xsl:when>	<!-- Ӣ�� -->
		<xsl:when test="$nationality='US'">840</xsl:when>	<!-- ���� -->
		<xsl:when test="$nationality='OTH'">999</xsl:when>	<!-- �������Һ͵��� -->
		<xsl:when test="$nationality='AU'">036</xsl:when>	<!-- �Ĵ����� -->
		<xsl:when test="$nationality='CA'">124</xsl:when>	<!-- ���ô� -->
		<xsl:when test="$nationality='CHN'">156</xsl:when>	<!-- �й� -->
		<xsl:otherwise>999</xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

<!-- ְҵ����ת�� -->
<xsl:template name="tran_JobCode">
	<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode='1010106'">A0000</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ������\�����������ؼ��乤������������ -->
		<xsl:when test="$jobcode='4040111'">C0000</xsl:when>	<!-- ������Ա���й���Ա\���ڹ�����Ա -->
		<xsl:when test="$jobcode='2021904'">B0000</xsl:when>	<!-- רҵ������Ա\����ʦ -->
		<xsl:when test="$jobcode='8010101'">Y0000</xsl:when>	<!-- ��������������ҵ��Ա\�޹̶�ְҵ��Ա������ȡ�������ά�����Ƶģ� -->
		<xsl:when test="$jobcode='9210102'">D0000</xsl:when>	<!-- ��ҵ������ҵ��Ա\��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
		<xsl:when test="$jobcode='5050104'">E0000</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա\ũ�û�е������������Ա -->
		<xsl:when test="$jobcode='6240107'">F0000</xsl:when>	<!-- �����������豸������Ա���й���Ա\���û���˾�����泵���ˡ���ҹ��� -->
		<xsl:otherwise></xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

<!-- ���������������� -->
<!-- ���У�0	����������,1	����������,2	����������,3	����������,4	��������� -->
<xsl:template match="Type">
	<xsl:choose>
		<xsl:when test=".=1">1</xsl:when>	<!-- ���������� -->
		<xsl:otherwise></xsl:otherwise>
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


<!-- ������������ -->
<xsl:template match="InsuYearFlag">
	<xsl:choose>
		<xsl:when test=".='Y'">03</xsl:when><!-- ���� -->
		<xsl:when test=".='M'">04</xsl:when><!-- ���� -->
		<xsl:when test=".='D'">05</xsl:when><!-- ���� -->
		<xsl:otherwise>99</xsl:otherwise>
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

<!-- ������Դ -->
<xsl:template match="LiveZone">
    <xsl:choose>
        <xsl:when test=".='1'">1</xsl:when><!-- ���� -->
        <xsl:when test=".='2'">2</xsl:when><!-- ũ�� -->
        <xsl:otherwise>1</xsl:otherwise><!-- ���� -->
    </xsl:choose>
</xsl:template>


<xsl:template name="tran_RelationRoleCode">
    <xsl:param name="relaToInsured"></xsl:param>
    <xsl:param name="insuredSex"></xsl:param>
	<xsl:choose>
		<!-- ���� -->
		<xsl:when test="$relaToInsured='00'">0133043</xsl:when>
		<!-- ��ż -->
		<xsl:when test="$relaToInsured='02'">0133010</xsl:when>
		<!-- ��ĸ -->
		<xsl:when test="$relaToInsured='01'">
		    <xsl:if test="$insuredSex='0'">0133011</xsl:if>
		    <xsl:if test="$insuredSex='1'">0133012</xsl:if>
        </xsl:when>
		<!-- ��Ů -->
		<xsl:when test="$relaToInsured='03'">
	        <xsl:if test="$insuredSex='0'">0133015</xsl:if>
	        <xsl:if test="$insuredSex='1'">0133016</xsl:if>
        </xsl:when>
		<!-- ���� -->
		<xsl:when test="$relaToInsured='04'">0133999</xsl:when>
		<!-- ���� -->
		<xsl:otherwise>0133999</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
<!-- ���鴦��ʽ -->
<xsl:template match="DisputedFag">
    <xsl:choose>
        <xsl:when test=".=1">04</xsl:when>   <!-- �ٲ� -->
        <xsl:when test=".=2">03</xsl:when>   <!-- ���� -->
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Լ�����ѵ潻��־ -->
<xsl:template match="AutoPayFlag">
    <xsl:choose>
        <xsl:when test=".=1"></xsl:when>   <!-- �Զ��潻 -->
        <xsl:when test=".=0">0</xsl:when>   <!-- ���Զ��潻 -->
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>

