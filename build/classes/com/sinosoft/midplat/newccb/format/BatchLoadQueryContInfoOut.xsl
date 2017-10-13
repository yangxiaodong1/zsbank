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
			<!-- 保险公司编号 -->
			<Ins_Co_ID>010058</Ins_Co_ID>
			<!-- 保险公司名称 -->
			<Ins_Co_Nm>安邦人寿保险有限公司</Ins_Co_Nm>
			<!-- 建行代理标志 0-否  1-是 -->
			<CCB_Agnc_Ind>1</CCB_Agnc_Ind>
			<!-- 代理保险套餐编号 -->
			<AgIns_Pkg_ID></AgIns_Pkg_ID>
			<!-- 套餐名称 -->
			<Pkg_Nm></Pkg_Nm>
			<!-- 界面模板类型代码 -->
			<Intfc_Tpl_TpCd></Intfc_Tpl_TpCd>
			<!-- 投保人名称 -->
			<Plchd_Nm><xsl:value-of select="Appnt/Name" /></Plchd_Nm>
			<!-- 投保人性别代码 -->
			<Plchd_Gnd_Cd>
				<xsl:call-template name="tran_Sex">
					<xsl:with-param name="sex" select="Appnt/Sex" />
				</xsl:call-template>
			</Plchd_Gnd_Cd>
			<!-- 投保人出生日期 -->
			<Plchd_Brth_Dt><xsl:value-of select="Appnt/Birthday" /></Plchd_Brth_Dt>
			<!-- 投保人证件类型代码 -->
			<Plchd_Crdt_TpCd>
				<xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="Appnt/IDType" />
				</xsl:call-template>
			</Plchd_Crdt_TpCd>
			<Plchd_Crdt_No><xsl:value-of select="Appnt/IDNo" /></Plchd_Crdt_No>
			<!-- 投保人证件失效日期 -->
			<Plchd_Crdt_EfDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Appnt/IDTypeStartDate)" /></Plchd_Crdt_EfDt>
			<!-- 
			<Plchd_Crdt_ExpDt>20400101</Plchd_Crdt_ExpDt>
			 -->
			<Plchd_Crdt_ExpDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Appnt/IDTypeEndDate)" /></Plchd_Crdt_ExpDt>
			<!-- add 20150820 新一代2.2版本新增  投保人联系地址国家地区代码 -->
			<PlchdCtcAdrCtyRgon_Cd></PlchdCtcAdrCtyRgon_Cd>			
			<!-- add 20150820 新一代2.2版本新增  投保人省代码 -->
			<Plchd_Prov_Cd></Plchd_Prov_Cd>
			<!-- add 20150820 新一代2.2版本新增  投保人市代码 -->
			<Plchd_City_Cd></Plchd_City_Cd>
			<!-- add 20150820 新一代2.2版本新增  投保人区县代码 -->
			<Plchd_CntyAndDstc_Cd></Plchd_CntyAndDstc_Cd>
			<!-- add 20150820 新一代2.2版本新增  投保人详细地址内容 -->
			<Plchd_Dtl_Adr_Cntnt></Plchd_Dtl_Adr_Cntnt>
			<!-- add 20150820 新一代2.2版本新增  投保人固定电话国际区号 -->
			<PlchdFixTelItnlDstcNo></PlchdFixTelItnlDstcNo>
			<!-- add 20150820 新一代2.2版本新增  投保人固定电话国内区号 -->
			<PlchdFixTelDmstDstcNo><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.PhoneToDstcNo(Appnt/Phone)"/></PlchdFixTelDmstDstcNo>
			<!-- add 20150820 新一代2.2版本新增  投保人移动电话国际区号 -->
			<PlchdMoveTelItlDstcNo></PlchdMoveTelItlDstcNo>		
			<!-- 投保人国籍代码 -->
			<Plchd_Nat_Cd>
				<xsl:call-template name="tran_Nationality">
					<xsl:with-param name="nationality" select="Appnt/Nationality" />
				</xsl:call-template>
			</Plchd_Nat_Cd>
			<!-- 投保人通讯地址 -->
			<Plchd_Comm_Adr><xsl:value-of select="Appnt/Address" /></Plchd_Comm_Adr>
			<!-- 投保人邮政编码 -->
			<Plchd_ZipECD><xsl:value-of select="Appnt/ZipCode" /></Plchd_ZipECD>
			<!-- 投保人固定电话号码 -->
			<Plchd_Fix_TelNo><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.PhoneToTelNo(Appnt/Phone)"/></Plchd_Fix_TelNo>
			<!-- 投保人移动电话号码 -->
			<Plchd_Move_TelNo><xsl:value-of select="Appnt/Mobile" /></Plchd_Move_TelNo>
			<!-- 投保人电子邮件地址 -->
			<!-- 
			<Plchd_Email_Adr>dianziyoujian@126.com</Plchd_Email_Adr>
			 -->
			<Plchd_Email_Adr><xsl:value-of select="Appnt/Email" /></Plchd_Email_Adr>
			<!-- 投保人职业代码 -->
			<Plchd_Ocp_Cd>
				<xsl:call-template name="tran_JobCode">
					<xsl:with-param name="jobcode" select="Appnt/JobCode" />
				</xsl:call-template>
			</Plchd_Ocp_Cd>
			<!-- 投保人年收入金额 -->
			<Plchd_Yr_IncmAm><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Appnt/Salary)"/></Plchd_Yr_IncmAm>
			<!-- 家庭年收入金额 -->
			<Fam_Yr_IncmAm><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Appnt/FamilySalary)"/></Fam_Yr_IncmAm>
			<!-- 居民类型代码 -->
			<Rsdnt_TpCd><xsl:apply-templates select="Appnt/LiveZone" /></Rsdnt_TpCd>
			<!-- FIXME 投保人和被保人关系类型代码 -->
			<!-- 
			<Plchd_And_Rcgn_ReTpCd>133010</Plchd_And_Rcgn_ReTpCd>\
			 -->
			 <Plchd_And_Rcgn_ReTpCd>
				<xsl:call-template name="tran_RelationRoleCode">
				    <xsl:with-param name="relaToInsured"><xsl:value-of select="Appnt/RelaToInsured"/></xsl:with-param>
					<xsl:with-param name="insuredSex"><xsl:value-of select="Insured/Sex"/></xsl:with-param>
				</xsl:call-template>			
			</Plchd_And_Rcgn_ReTpCd>
			<!-- 被保人名称 -->
			<Rcgn_Nm><xsl:value-of select="Insured/Name" /></Rcgn_Nm>
			<!-- 被保人拼音全称 -->
			<Rcgn_CPA_FullNm />
			<!-- 被保人性别代码 -->
			<Rcgn_Gnd_Cd>
				<xsl:call-template name="tran_Sex">
					<xsl:with-param name="sex" select="Insured/Sex" />
				</xsl:call-template>
			</Rcgn_Gnd_Cd>
			<!-- 被保人出生日期 -->
			<Rcgn_Brth_Dt><xsl:value-of select="Insured/Birthday" /></Rcgn_Brth_Dt>
			<!-- 被保人证件类型代码 -->
			<Rcgn_Crdt_TpCd>
				<xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="Insured/IDType" />
				</xsl:call-template>
			</Rcgn_Crdt_TpCd>
			<!-- 被保人证件号码 -->
			<Rcgn_Crdt_No><xsl:value-of select="Insured/IDNo" /></Rcgn_Crdt_No>
			<!-- 被保人证件生效日期 -->
			<!-- 
			<Rcgn_Crdt_EfDt>20100101</Rcgn_Crdt_EfDt>
			-->
			<Rcgn_Crdt_EfDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Insured/IDTypeStartDate)" /></Rcgn_Crdt_EfDt>
			 
			<!-- 被保人证件失效日期 -->
			<!-- 
			<Rcgn_Crdt_ExpDt>20400101</Rcgn_Crdt_ExpDt>
			 -->
			<Rcgn_Crdt_ExpDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Insured/IDTypeEndDate)" /></Rcgn_Crdt_ExpDt>
			<!-- add 20150820 新一代2.2版本新增  被保人联系地址国家地区代码 -->
			<RcgnCtcAdr_CtyRgon_Cd></RcgnCtcAdr_CtyRgon_Cd>			
			<!-- add 20150820 新一代2.2版本新增  被保人省代码 -->
			<Rcgn_Prov_Cd></Rcgn_Prov_Cd>
			<!-- add 20150820 新一代2.2版本新增  被保人市代码 -->
			<Rcgn_City_Cd></Rcgn_City_Cd>
			<!-- add 20150820 新一代2.2版本新增  被保人区县代码 -->
			<Rcgn_CntyAndDstc_Cd></Rcgn_CntyAndDstc_Cd>
			<!-- add 20150820 新一代2.2版本新增  被保人详细地址内容 -->
			<Rcgn_Dtl_Adr_Cntnt></Rcgn_Dtl_Adr_Cntnt>
			<!-- add 20150820 新一代2.2版本新增  被保人固定电话国际区号 -->
			<RcgnFixTelItnl_DstcNo></RcgnFixTelItnl_DstcNo>
			<!-- add 20150820 新一代2.2版本新增  被保人固定电话国内区号 -->
			<RcgnFixTelDmst_DstcNo><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.PhoneToDstcNo(Insured/Phone)"/></RcgnFixTelDmst_DstcNo>
			<!-- add 20150820 新一代2.2版本新增  被保人移动电话国际区号 -->
			<RcgnMoveTelItnlDstcNo></RcgnMoveTelItnlDstcNo>		
			<!-- 被保人国籍代码 -->
			<Rcgn_Nat_Cd>
				<xsl:call-template name="tran_Nationality">
					<xsl:with-param name="nationality" select="Insured/Nationality" />
				</xsl:call-template>
			</Rcgn_Nat_Cd>
			<!-- 被保人通讯地址 -->
			<Rcgn_Comm_Adr><xsl:value-of select="Insured/Address" /></Rcgn_Comm_Adr>
			<!-- 被保人邮政编码 -->
			<Rcgn_ZipECD><xsl:value-of select="Insured/ZipCode" /></Rcgn_ZipECD>
			<!-- 被保人固定电话号码 -->
			<Rcgn_Fix_TelNo><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.PhoneToTelNo(Insured/Phone)"/></Rcgn_Fix_TelNo>
			<!-- 被保人移动电话号码 -->
			<Rcgn_Move_TelNo><xsl:value-of select="Insured/Mobile" /></Rcgn_Move_TelNo>
			<!-- 被保人电子邮件地址r -->
			<!-- 
			<Rcgn_Email_Adr>dianziyoujian@126.com</Rcgn_Email_Adr>
			 -->
			<Rcgn_Email_Adr><xsl:value-of select="Insured/Email" /></Rcgn_Email_Adr>
			<!-- 被保人职业代码 -->
			<Rcgn_Ocp_Cd>
				<xsl:call-template name="tran_JobCode">
					<xsl:with-param name="jobcode" select="Insured/JobCode" />
				</xsl:call-template>
			</Rcgn_Ocp_Cd>
			<!-- 被保人年收入金额 -->
			<Rcgn_Yr_IncmAm><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Insured/Salary)"/></Rcgn_Yr_IncmAm>
			<!-- 未成年人累计保额 -->
			<Minr_Acm_Cvr></Minr_Acm_Cvr>
			<!-- 被保人前往目的地个数 -->
			<Rcgn_LvFr_Pps_Lnd_Num>0</Rcgn_LvFr_Pps_Lnd_Num>
			<!-- 目的地信息循环，多个 -->
			<Pps_List>
				<Pps_Detail>
					<!-- 被保人前往目的地 -->
					<Rcgn_LvFr_Pps_Lnd></Rcgn_LvFr_Pps_Lnd>
				</Pps_Detail>
				<Pps_Detail>
					<!-- 被保人前往目的地 -->
					<Rcgn_LvFr_Pps_Lnd></Rcgn_LvFr_Pps_Lnd>
				</Pps_Detail>
			</Pps_List>
			<!-- 受益人个数 -->
			<Benf_Num><xsl:value-of select="count(Bnf)" /></Benf_Num>
			<Benf_List>
				<xsl:for-each select="Bnf">
					<Benf_Detail>
						<!-- 代理保险受益人类型代码 -->
						<AgIns_Benf_TpCd><xsl:apply-templates select="Type" /></AgIns_Benf_TpCd>
						<!-- 序号编号 -->
						<SN_ID></SN_ID>
						<!-- 代理保险受益次序值 -->
						<AgIns_Bnft_Ord_Val><xsl:value-of select="Grade" /></AgIns_Bnft_Ord_Val>
						<!-- 受益人名称 -->
						<Benf_Nm><xsl:value-of select="Name" /></Benf_Nm>
						<!-- 受益人性别代码 -->
						<!-- 
						<Benf_Gnd_Cd>01</Benf_Gnd_Cd>
						 -->
						<Benf_Gnd_Cd>
							<xsl:call-template name="tran_Sex">
								<xsl:with-param name="sex" select="Sex" />
							</xsl:call-template>
						</Benf_Gnd_Cd>
						<!-- FIXME 受益人出生日期 -->
						<!-- 
						<Benf_Brth_Dt>20140101</Benf_Brth_Dt>
						 -->
						<Benf_Brth_Dt><xsl:value-of select="Birthday" /></Benf_Brth_Dt>
						<!-- 受益人证件类型代码 -->
						<Benf_Crdt_TpCd>
							<xsl:call-template name="tran_IDType">
								<xsl:with-param name="idtype" select="IDType" />
							</xsl:call-template>
						</Benf_Crdt_TpCd>
						<!-- 受益人证件号码 -->
						<Benf_Crdt_No><xsl:value-of select="IDNo" /></Benf_Crdt_No>
						<!-- FIXME 受益人证件生效日期 -->
						<xsl:if test="IDTypeStartDate != ''">
						   <Benf_Crdt_EfDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(IDTypeStartDate)" /></Benf_Crdt_EfDt>
						</xsl:if>
						<xsl:if test="IDTypeStartDate = ''">
						   <Benf_Crdt_EfDt><xsl:value-of select="IDTypeStartDate" /></Benf_Crdt_EfDt>
						</xsl:if>
						<!-- 
						<Benf_Crdt_EfDt>20100101</Benf_Crdt_EfDt>
						 -->
						<!-- FIXME 受益人证件失效日期 -->
						<!-- 
						<Benf_Crdt_ExpDt>20400101</Benf_Crdt_ExpDt>
						 -->
						<xsl:if test="IDTypeEndDate != ''">
						   <Benf_Crdt_ExpDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(IDTypeEndDate)" /></Benf_Crdt_ExpDt>
						</xsl:if>
						<xsl:if test="IDTypeEndDate = ''">
						   <Benf_Crdt_ExpDt><xsl:value-of select="IDTypeEndDate" /></Benf_Crdt_ExpDt>
						</xsl:if>
						<!-- add 20150820 新一代2.2版本新增  受益人联系地址国家地区代码 -->
			            <BenfCtcAdr_CtyRgon_Cd></BenfCtcAdr_CtyRgon_Cd>			
			            <!-- add 20150820 新一代2.2版本新增  受益人省代码 -->
			            <Benf_Prov_Cd></Benf_Prov_Cd>
			            <!-- add 20150820 新一代2.2版本新增  受益人市代码 -->
			            <Benf_City_Cd></Benf_City_Cd>
			            <!-- add 20150820 新一代2.2版本新增  受益人区县代码 -->
			            <Benf_CntyAndDstc_Cd></Benf_CntyAndDstc_Cd>
			            <!-- add 20150820 新一代2.2版本新增  受益人详细地址内容 -->
			            <Benf_Dtl_Adr_Cntnt></Benf_Dtl_Adr_Cntnt>
						<!-- 受益人国籍代码 -->
						<Benf_Nat_Cd>
							<xsl:call-template name="tran_Nationality">
								<xsl:with-param name="nationality" select="Nationality" />
							</xsl:call-template>
						</Benf_Nat_Cd>
						<!-- FIXME 受益人与被保人关系 -->
						<!-- 
						<Benf_And_Rcgn_ReTpCd>133011</Benf_And_Rcgn_ReTpCd>
						-->
						<Benf_And_Rcgn_ReTpCd>
							<xsl:call-template name="tran_RelationRoleCode">
			                    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
			                    <xsl:with-param name="insuredSex"><xsl:value-of select="../Insured/Sex"/></xsl:with-param>
			                </xsl:call-template>
						</Benf_And_Rcgn_ReTpCd>
						<!-- 受益比例 因银行要求小数点后四位，用dive函数不行 -->
						<!-- <Bnft_Pct><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Lot)" /></Bnft_Pct>-->
						<Bnft_Pct><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.forDecimal(Lot,4)" /></Bnft_Pct>
						<!-- FIXME 受益人通讯地址 -->
						<!-- 
						<Benf_Comm_Adr>北京市建国门外大街8号</Benf_Comm_Adr>
						 -->
						<Benf_Comm_Adr><xsl:value-of select="Address" /></Benf_Comm_Adr>
						
					</Benf_Detail>
				</xsl:for-each>
			</Benf_List>
			<Rvl_Rcrd_Num><xsl:value-of select="count(Risk[RiskCode=MainRiskCode])" /></Rvl_Rcrd_Num>
			<Busi_List>
				<xsl:for-each select="Risk[RiskCode=MainRiskCode]">
					<Busi_Detail>
						<!-- 险种编号 -->
						<Cvr_ID>
							<xsl:call-template name="tran_Riskcode">
								<xsl:with-param name="riskcode" select="RiskCode" />
							</xsl:call-template>
						</Cvr_ID>
						<!-- 险种名称 -->
						<Cvr_Nm><xsl:value-of select="RiskName" /></Cvr_Nm>
						<!-- 主附险标志 -->
						<MainAndAdlIns_Ind>
							<xsl:choose>
								<xsl:when test="RiskCode=MainRiskCode">1</xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</MainAndAdlIns_Ind>
						<!-- 投保份数 -->
						<Ins_Cps><xsl:value-of select="Mult" /></Ins_Cps>
						<!-- 保费金额 -->
						<InsPrem_Amt>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
						</InsPrem_Amt>
						<!-- 投保保额 -->
						<Ins_Cvr></Ins_Cvr>
						<!-- 投保方案信息 -->
						<Ins_Scm_Inf></Ins_Scm_Inf>
						<!-- 可选部分身故保险金额 -->
						<Opt_Part_DieIns_Amt></Opt_Part_DieIns_Amt>
						<!-- 首次额外追加保费 -->
						<FTm_Extr_Adl_InsPrem></FTm_Extr_Adl_InsPrem>
						<!-- 投资方式代码 -->
						<Ivs_MtdCd></Ivs_MtdCd>
						<!-- 建行账号 -->
						<CCB_AccNo></CCB_AccNo>
						<!-- 保险年期类别代码 -->
						<Ins_Yr_Prd_CgyCd><xsl:apply-templates select="PayIntv" mode="payintv"/></Ins_Yr_Prd_CgyCd>
						<!-- 保险期限 -->
						<Ins_Ddln><xsl:value-of select="InsuYear" /></Ins_Ddln>
						<!-- 保险周期代码 -->
						<Ins_Cyc_Cd><xsl:apply-templates select="InsuYearFlag" /></Ins_Cyc_Cd>
						<!-- 保费缴费方式代码 -->
						<InsPrem_PyF_MtdCd><xsl:apply-templates select="PayIntv" mode="payintv" /></InsPrem_PyF_MtdCd>
						<!-- 保费缴费期数 -->
						<InsPrem_PyF_Prd_Num>
							<xsl:choose>
								<xsl:when test="PayIntv = '0'">0</xsl:when>
								<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
							</xsl:choose>
						</InsPrem_PyF_Prd_Num>
						<!-- 保费缴费周期代码 -->
						<InsPrem_PyF_Cyc_Cd><xsl:apply-templates select="PayIntv" mode="zhouqi"/></InsPrem_PyF_Cyc_Cd>
						<!-- 特别约定信息 -->
						<Spcl_Apnt_Inf></Spcl_Apnt_Inf>
						<!-- 年金领取类别代码 -->
						<Anuty_Drw_CgyCd></Anuty_Drw_CgyCd>
						<!-- 年金领取期数 -->
						<Anuty_Drw_Prd_Num></Anuty_Drw_Prd_Num>
						<!-- 年金领取周期代码 -->
						<Anuty_Drw_Cyc_Cd></Anuty_Drw_Cyc_Cd>
						<!-- 年金处理方式代码 -->
						<Anuty_Pcsg_MtdCd></Anuty_Pcsg_MtdCd>
						<!-- 满期保险金领取方式类别代码 -->
						<ExpPrmmRcvModCgyCd>001</ExpPrmmRcvModCgyCd>
						<!-- 生存金领取周期代码 -->
						<SvBnf_Drw_Cyc_Cd></SvBnf_Drw_Cyc_Cd>
						<!-- 红利处理方式代码 0	直接给付,1	抵交保费,2	累计生息,3	增额交清 -->
						<XtraDvdn_Pcsg_MtdCd><xsl:apply-templates select="BonusGetMode" /></XtraDvdn_Pcsg_MtdCd>
						<!-- 约定保费垫交标志 -->
						<ApntInsPremPyAdvnInd><xsl:apply-templates select="AutoPayFlag" /></ApntInsPremPyAdvnInd>
						<!-- 自动续保标志 -->
						<Auto_RnwCv_Ind></Auto_RnwCv_Ind>
						
						<!-- 红利分配标志 -->
						<XtraDvdn_Alct_Ind></XtraDvdn_Alct_Ind>
						<!-- 减额交清标志 -->
						<RdAmtPyCls_Ind></RdAmtPyCls_Ind>
						<!-- 保险金额递减方式代码 -->
						<Ins_Amt_Dgrs_MtdCd></Ins_Amt_Dgrs_MtdCd>
						<!-- 保单生效日期 -->
						<InsPolcy_EfDt><xsl:value-of select="CValiDate" /></InsPolcy_EfDt>
						<!-- 保单拟生效日期 -->
						<InsPolcy_Intnd_EfDt></InsPolcy_Intnd_EfDt>
						<!-- 保单失效日期 -->
						<InsPolcy_ExpDt><xsl:value-of select="InsuEndDate" /></InsPolcy_ExpDt>
						<!-- 紧急联系人 -->
						<Emgr_CtcPsn></Emgr_CtcPsn>
						<!-- 紧急联系人和被保人关系类型代码 -->
						<EmgrCtcPsnAndRcReTpCd></EmgrCtcPsnAndRcReTpCd>
						<!-- 紧急联系电话 -->
						<Emgr_Ctc_Tel></Emgr_Ctc_Tel>
						<!-- 银行贷款合同编号 新一代建行2.2版本调整为 代理保险贷款合同编号
						<Bnk_Loan_Ctr_ID></Bnk_Loan_Ctr_ID>-->
						<AgIns_Ln_Ctr_ID></AgIns_Ln_Ctr_ID>
						<!-- 贷款合同失效日期 -->
						<Ln_Ctr_ExpDt></Ln_Ctr_ExpDt>
						<!-- 未还贷款金额 -->
						<Upd_Loan_Amt></Upd_Loan_Amt>
						<!-- 主单保单凭证号码 -->
						<PrimBlInsPolcyVchr_No></PrimBlInsPolcyVchr_No>
						<!-- 投连险账户个数 -->
						<IvLkIns_Acc_Num>0</IvLkIns_Acc_Num>
						<PayAcctCode_List>
							<PayAcctCode_Detail>
								<ILIVA_ID></ILIVA_ID>
								<ILIVA_Nm></ILIVA_Nm>
								<Ivs_Tp_Alct_Pctg></Ivs_Tp_Alct_Pctg>
								<Adl_Ins_Fee_Alct_Pctg></Adl_Ins_Fee_Alct_Pctg>
							</PayAcctCode_Detail>
						</PayAcctCode_List>
						<!-- 保留字段一 -->
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
			<!-- 保单号码 -->
			<Ins_BillNo><xsl:value-of select="ProposalPrtNo" /></Ins_BillNo>
			<!-- 保单号 -->
			<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
			<!-- 投保人缴费账号 -->
			<Plchd_PyF_AccNo><xsl:value-of select="AccNo" /></Plchd_PyF_AccNo>
			<!-- 投保人领取账号 -->
			<Plchd_Drw_AccNo></Plchd_Drw_AccNo>
			<!-- 被保人账号 -->
			<Rcgn_AccNo></Rcgn_AccNo>
			<!-- 受益人账号 -->
			<Benf_AccNo></Benf_AccNo>
			<!-- 续期缴费支付方式代码 -->
			<Rnew_PyF_PyMd_Cd>2</Rnew_PyF_PyMd_Cd>
			<!-- 代理保险合约状态代码 -->
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
			<!-- 代理保险客户条线类型代码 -->
			<AgIns_Cst_Line_TpCd></AgIns_Cst_Line_TpCd>
			<!-- 保单介质类型代码 -->
			<InsPolcy_Medm_TpCd></InsPolcy_Medm_TpCd>
			<!-- 建行机构编号 -->
			<CCBIns_ID></CCBIns_ID>
			<!-- 一级分行号 -->
			<Lv1_Br_No><xsl:value-of select="SubBankCode" /></Lv1_Br_No>
			<!-- 网点保险兼职代理业务许可证编码 -->
			<BOInsPrAgnBsnLcns_ECD><xsl:value-of select="AgentComCertiCode" /></BOInsPrAgnBsnLcns_ECD>
			<!-- 网点分管代理保险业务负责人编号 -->
			<BOIChOfAgInsBsnPnp_ID></BOIChOfAgInsBsnPnp_ID>
			<!-- 网点分管代理保险业务负责人姓名 -->
			<BOIChOfAgInsBsnPnp_Nm></BOIChOfAgInsBsnPnp_Nm>
			<!-- 投保操作人编号 -->
			<Ins_Mnplt_Psn_ID></Ins_Mnplt_Psn_ID>
			<!-- 网点销售人员编号 -->
			<!--  <BO_Sale_Stff_ID><xsl:value-of select="SellerNo" /></BO_Sale_Stff_ID>	-->		
			<BO_Sale_Stff_ID><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.InsuToBankBoSaleStffID(SellerNo)" /></BO_Sale_Stff_ID>
			<!-- 网点销售人员姓名 -->
			<BO_Sale_Stff_Nm><xsl:value-of select="TellerName" /></BO_Sale_Stff_Nm>			
			<!-- 销售人员代理保险从业人员资格证书编号 -->
			<Sale_Stff_AICSQCtf_ID><xsl:value-of select="TellerCertiCode" /></Sale_Stff_AICSQCtf_ID>
			<!-- 推荐客户经理编号 -->
			<RcmCst_Mgr_ID></RcmCst_Mgr_ID>
			<!-- 推荐客户经理姓名 -->
			<RcmCst_Mgr_Nm></RcmCst_Mgr_Nm>
			<!-- 保险专案类别代码 -->
			<Ins_Prj_CgyCd></Ins_Prj_CgyCd>
			<!-- 见费出单类别代码 -->
			<PydFeeOutBill_CgyCd></PydFeeOutBill_CgyCd>
			<!-- 保单实际销售地区编号 -->
			<InsPolcyActSaleRgonID></InsPolcyActSaleRgonID>
			<!-- 保险客户名单提供地区编号 -->
			<Ins_CsLs_Prvd_Rgon_ID></Ins_CsLs_Prvd_Rgon_ID>
			<!-- 保单领取方式代码 -->
			<InsPolcy_Rcv_MtdCd></InsPolcy_Rcv_MtdCd>
			<!-- 争议处理方式代码 -->
			<Dspt_Pcsg_MtdCd>
			   <xsl:if test="DisputedFag = ''">03</xsl:if>
			   <xsl:if test="DisputedFag != ''">
			      <xsl:apply-templates select="DisputedFag" />
			   </xsl:if>			     
			</Dspt_Pcsg_MtdCd>
			<!--<Dspt_Pcsg_MtdCd>03</Dspt_Pcsg_MtdCd> -->
			<!-- 争议仲裁机构名称 -->
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
			<!-- 告知事项标志 0 无告知事项 -->
			<Ntf_Itm_Ind>0</Ntf_Itm_Ind>
			<!-- add 20150826 建行新一代2.2版本增加字段信息 begin-->
			<!-- 红利实际发放日期 -->
			<XtraDvdn_Act_Dstr_Dt></XtraDvdn_Act_Dstr_Dt>
			<!-- 本期红利金额 -->
			<CrnPrd_XtDvdAmt></CrnPrd_XtDvdAmt>
			<!-- 终了红利金额 -->
			<ATEndOBns_Amt></ATEndOBns_Amt>
			<!-- 累积红利金额 -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
			<!-- add 20150826 建行新一代2.2版本增加字段信息 end-->
		</Insu_Detail>
		</xsl:for-each>
	</Insu_List>
	
	
</xsl:template>
		
<!-- 险种代码 -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">122001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122002'">122002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122003'">122003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122004'">122004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122005'">122005</xsl:when>	<!-- 安邦黄金鼎3号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122006'">122006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='122008'">122008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='122046'">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  begin -->
		<xsl:when test="$riskcode='50012'">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
		<xsl:when test="$riskcode='L12070'">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 增加安享5号产品  end -->
		<!-- 新老险种代码并存 -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1终身寿险（万能型）B款 -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskcode='122035'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskcode='50002'">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- 安邦盛世1号两全保险（万能型） -->
		
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode=50015">50002</xsl:when>	<!-- 安邦长寿稳赢保险计划 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 性别转换 -->
<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
	<xsl:choose>
		<xsl:when test="$sex='0'">01</xsl:when>	<!-- 男性 -->
		<xsl:when test="$sex='1'">02</xsl:when>	<!-- 女性 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 证件类型转换 -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='0'">1010</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1'">1052</xsl:when>	<!-- 护照 -->
		<xsl:when test="$idtype='2'">1020</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='5'">1040</xsl:when>	<!-- 户口簿 -->
		<xsl:otherwise></xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>

<!-- 国籍代码转换 -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality" />
	<xsl:choose>
		<xsl:when test="$nationality='JP'">392</xsl:when>	<!-- 日本 -->
		<xsl:when test="$nationality='KR'">410</xsl:when>	<!-- 韩国 -->
		<xsl:when test="$nationality='RU'">643</xsl:when>	<!-- 俄罗斯联邦 -->
		<xsl:when test="$nationality='GB'">826</xsl:when>	<!-- 英国 -->
		<xsl:when test="$nationality='US'">840</xsl:when>	<!-- 美国 -->
		<xsl:when test="$nationality='OTH'">999</xsl:when>	<!-- 其他国家和地区 -->
		<xsl:when test="$nationality='AU'">036</xsl:when>	<!-- 澳大利亚 -->
		<xsl:when test="$nationality='CA'">124</xsl:when>	<!-- 加拿大 -->
		<xsl:when test="$nationality='CHN'">156</xsl:when>	<!-- 中国 -->
		<xsl:otherwise>999</xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>

<!-- 职业代码转换 -->
<xsl:template name="tran_JobCode">
	<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode='1010106'">A0000</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位负责人\国家行政机关及其工作机构负责人 -->
		<xsl:when test="$jobcode='4040111'">C0000</xsl:when>	<!-- 办事人员和有关人员\内勤工作人员 -->
		<xsl:when test="$jobcode='2021904'">B0000</xsl:when>	<!-- 专业技术人员\工程师 -->
		<xsl:when test="$jobcode='8010101'">Y0000</xsl:when>	<!-- 不便分类的其他从业人员\无固定职业人员（以收取各种租金维持生计的） -->
		<xsl:when test="$jobcode='9210102'">D0000</xsl:when>	<!-- 商业、服务业人员\从事旅游,旅馆,餐饮,商业等一般服务行业；非纯文职工作,但不涉及危险的职业,如新闻业, 杂志业等 -->
		<xsl:when test="$jobcode='5050104'">E0000</xsl:when>	<!-- 农、林、牧、渔、水利业生产人员\农用机械操作或修理人员 -->
		<xsl:when test="$jobcode='6240107'">F0000</xsl:when>	<!-- 生产、运输设备操作人员及有关人员\自用货车司机、随车工人、搬家工人 -->
		<xsl:otherwise></xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>

<!-- 代理保险受益人类型 -->
<!-- 银行：0	生存受益人,1	死亡受益人,2	红利受益人,3	满期受益人,4	年金受益人 -->
<xsl:template match="Type">
	<xsl:choose>
		<xsl:when test=".=1">1</xsl:when>	<!-- 死亡受益人 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 保单合约状态 FIXME 这部分需要与核心沟通确认码表映射关系 -->
<xsl:template name="tran_State">
	<xsl:param name="contState"></xsl:param>
	<xsl:choose><!-- 我司名称=银行名称 -->
		<xsl:when test="$contState='00'">076012</xsl:when>		<!-- 签单已回执=保单已有效，客户已签收 -->
		<xsl:when test="$contState='A'">076016</xsl:when>		<!-- 拒保、撤单=保险公司拒保(核保未通过) -->
		<xsl:when test="$contState='B'">076036</xsl:when>		<!-- 非实时保单已缴费待获取保单 -->
		<xsl:when test="$contState='C'">076023</xsl:when>		<!-- 当日撤单=当日撤单作废 -->
		<xsl:when test="$contState='WT'">076024</xsl:when>		<!-- 犹豫期内退保终止=犹豫期退保作废 -->
		<xsl:when test="$contState='02'">076025</xsl:when>		<!-- 退保终止=非犹豫期退保作废 -->
		<xsl:when test="$contState='01'">076030</xsl:when>		<!-- 满期终止=满期已给付 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="tran_nonRTContState">
	<xsl:param name="nonRTContState"></xsl:param>
	<xsl:choose><!-- 我司名称=银行名称 -->
		<xsl:when test="$nonRTContState='08'">076011</xsl:when>	<!-- 签单未回执=保单已有效，客户未签收 -->
		<xsl:when test="$nonRTContState='06'">076012</xsl:when>	<!-- 签单已回执=保单已有效，客户已签收 -->
		<xsl:when test="$nonRTContState='00'">076014</xsl:when>	<!-- 未处理=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='01'">076014</xsl:when>	<!-- 录入中=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='02'">076014</xsl:when>	<!-- 核保中=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='03'">076014</xsl:when>	<!-- 通知书待回复=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='07'">076015</xsl:when>	<!-- 契撤=银行契撤作废 -->
		<xsl:when test="$nonRTContState='05'">076016</xsl:when>	<!-- 拒保、撤单=保险公司拒保(核保未通过) -->
		<xsl:when test="$nonRTContState='04'">076019</xsl:when>	<!-- 核保通过=非实时保单保险公司核保通过待缴费 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 保险年期类型 -->
<xsl:template match="InsuYearFlag">
	<xsl:choose>
		<xsl:when test=".='Y'">03</xsl:when><!-- 按年 -->
		<xsl:when test=".='M'">04</xsl:when><!-- 按月 -->
		<xsl:when test=".='D'">05</xsl:when><!-- 按天 -->
		<xsl:otherwise>99</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 保单的缴费间隔/频次 -->
<xsl:template match="PayIntv" mode="payintv">
	<xsl:choose>
		<xsl:when test=".='0'">02</xsl:when><!--	趸交 -->
		<xsl:when test=".='12'">03</xsl:when><!-- 年交 -->
		<xsl:when test=".='1'">03</xsl:when><!--	月交 -->
		<xsl:when test=".='3'">03</xsl:when><!--	季交 -->
		<xsl:when test=".='6'">03</xsl:when><!--	半年交 -->
		<xsl:when test=".='-1'">01</xsl:when><!-- 不定期交 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 缴费年期类型 -->
<xsl:template match="PayIntv" mode="zhouqi">
	<xsl:choose>
		<xsl:when test=".='3'">0201</xsl:when><!--	季缴 -->
		<xsl:when test=".='6'">0202</xsl:when><!--	半年缴 -->
		<xsl:when test=".='12'">0203</xsl:when><!--	年缴 -->
		<xsl:when test=".='1'">0204</xsl:when><!--	月缴 -->
		<xsl:when test=".='0'">0100</xsl:when><!--	趸缴 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 红利领取方式 -->
<xsl:template match="BonusGetMode">
    <xsl:choose>
        <xsl:when test=".=2">0</xsl:when>   <!-- 直接给付 -->
        <xsl:when test=".=3">1</xsl:when>   <!-- 抵交保费 -->
        <xsl:when test=".=1">2</xsl:when>   <!-- 累计生息 -->
        <xsl:when test=".=5">3</xsl:when>   <!-- 增额交清  -->
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 居民来源 -->
<xsl:template match="LiveZone">
    <xsl:choose>
        <xsl:when test=".='1'">1</xsl:when><!-- 城镇 -->
        <xsl:when test=".='2'">2</xsl:when><!-- 农村 -->
        <xsl:otherwise>1</xsl:otherwise><!-- 其他 -->
    </xsl:choose>
</xsl:template>


<xsl:template name="tran_RelationRoleCode">
    <xsl:param name="relaToInsured"></xsl:param>
    <xsl:param name="insuredSex"></xsl:param>
	<xsl:choose>
		<!-- 本人 -->
		<xsl:when test="$relaToInsured='00'">0133043</xsl:when>
		<!-- 配偶 -->
		<xsl:when test="$relaToInsured='02'">0133010</xsl:when>
		<!-- 父母 -->
		<xsl:when test="$relaToInsured='01'">
		    <xsl:if test="$insuredSex='0'">0133011</xsl:if>
		    <xsl:if test="$insuredSex='1'">0133012</xsl:if>
        </xsl:when>
		<!-- 子女 -->
		<xsl:when test="$relaToInsured='03'">
	        <xsl:if test="$insuredSex='0'">0133015</xsl:if>
	        <xsl:if test="$insuredSex='1'">0133016</xsl:if>
        </xsl:when>
		<!-- 其他 -->
		<xsl:when test="$relaToInsured='04'">0133999</xsl:when>
		<!-- 其他 -->
		<xsl:otherwise>0133999</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
<!-- 争议处理方式 -->
<xsl:template match="DisputedFag">
    <xsl:choose>
        <xsl:when test=".=1">04</xsl:when>   <!-- 仲裁 -->
        <xsl:when test=".=2">03</xsl:when>   <!-- 诉讼 -->
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 约定保费垫交标志 -->
<xsl:template match="AutoPayFlag">
    <xsl:choose>
        <xsl:when test=".=1"></xsl:when>   <!-- 自动垫交 -->
        <xsl:when test=".=0">0</xsl:when>   <!-- 不自动垫交 -->
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>

