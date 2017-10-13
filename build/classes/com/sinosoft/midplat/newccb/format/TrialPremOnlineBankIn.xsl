<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	<TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<TradeData>
			 	<BaseInfo>
			 		<xsl:apply-templates select="TX/Head"/>
			 	</BaseInfo>
			 	<ContInfo>	
			 		<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
			 	</ContInfo>
			</TradeData>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="BaseInfo" match="Head">
	<TradeCode>PremAppCal</TradeCode>
	<TradekSelNo><xsl:value-of select="TranNo" /></TradekSelNo>
	<RequestDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCurDateTime()"/></RequestDate>
	<ResponseDate></ResponseDate>
</xsl:template>

<xsl:template name="ContInfo" match="APP_ENTITY">
	<LCCont>
		<ContNo></ContNo><!---������-->
		<PrtNo></PrtNo><!---Ͷ������-->
		<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></PolApplyDate> <!---Ͷ������-->
		<CvaliDate></CvaliDate> <!---��Ч����-->
		<EndDate></EndDate> <!---��ֹ����-->
		<ManageCom></ManageCom> <!---�������-->
		<PackageFlag></PackageFlag> 
	</LCCont>
    <ContPlan>
         <xsl:choose>
            <xsl:when test="Life_List/Life_Detail/Cvr_ID='50002'">
                 <ContPlanCode>50015</ContPlanCode>
                 <ContPlanMult><xsl:value-of select="format-number(Life_List/Life_Detail//Ins_Cps, '#')" /></ContPlanMult>
            </xsl:when>
            <xsl:otherwise>
                 <ContPlanCode></ContPlanCode>
                 <ContPlanMult></ContPlanMult>
            </xsl:otherwise>
         </xsl:choose>      
    </ContPlan>
	<LCInsureds>
		<LCInsuredCount>1</LCInsuredCount> <!---��������Ŀ-->
		<LCInsured>
				<InsuredSelNo>1</InsuredSelNo> <!---���������-->
				<!---�������Ա�-->
				<Sex>
					<xsl:call-template name="tran_Sex">
						<xsl:with-param name="sex" select="Rcgn_Gnd_Cd" />
					</xsl:call-template>
				</Sex> 
				<Birthday><xsl:value-of select="Rcgn_Brth_Dt" /></Birthday> <!---�����˳�������-->
				<InsuredAppAge></InsuredAppAge> <!---������Ͷ������-->
				<Marriage></Marriage> <!---�Ƿ���-->
				<!---����-->
				<NativePlace>
					<xsl:call-template name="tran_Nationality">
						<xsl:with-param name="nationality" select="Rcgn_Nat_Cd" />
					</xsl:call-template>
				</NativePlace> 
				<OccupationType></OccupationType> <!---ְҵ����-->
				 <!---ְҵ����-->
				<OccupationCode>
					<xsl:call-template name="tran_JobCode">
						<xsl:with-param name="jobcode" select="Rcgn_Ocp_Cd" />
					</xsl:call-template>
				</OccupationCode>
				<SocietyFlag></SocietyFlag> 
				<PeakLine></PeakLine>
				<Risks>
					<RiskCount>1</RiskCount> <!---������Ŀ-->
					<xsl:variable name="Life_Detail" select="Life_List/Life_Detail" />
						<Risk>
							<RiskSelNo>1</RiskSelNo> <!---�������-->
							<!---���ֱ���-->
							<RiskCode>
								<xsl:call-template name="tran_Riskcode">
									<xsl:with-param name="riskcode" select="$Life_Detail/Cvr_ID" />
								</xsl:call-template>
							</RiskCode> 
							<!---���ձ���-->
							<MainRiskCode>
								<xsl:call-template name="tran_Riskcode">
									<xsl:with-param name="riskcode" select="$Life_Detail/Cvr_ID" />
								</xsl:call-template>
							</MainRiskCode> 
							<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Life_Detail/Ins_Cvr)" /></Amnt> <!---����-->
							<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Life_Detail/InsPrem_Amt)" /></Prem> <!---����-->
							<AddFee>0</AddFee> <!---�����ӷ�-->
							<JobAddPrem>0</JobAddPrem> <!---ְҵ�ӷ�-->
							<Mult><xsl:value-of select="format-number($Life_Detail/Ins_Cps, '#')" /></Mult> <!---����-->
							<!---���ѷ�ʽ-->
							<PayIntv>
								<xsl:call-template name="tran_InsPrem_PyF_MtdCd">
									<xsl:with-param name="payIntv" select="$Life_Detail/InsPrem_PyF_MtdCd" />
									<xsl:with-param name="payEndYearFlag" select="$Life_Detail/InsPrem_PyF_Cyc_Cd" />
								</xsl:call-template>
							</PayIntv>
							<!-- �����ڼ䵥λ -->
							<InsuYearFlag>				
								<xsl:call-template name="tran_Ins_Yr_Prd_CgyCd">
									<xsl:with-param name="insuYearType" select="$Life_Detail/Ins_Yr_Prd_CgyCd" />
									<xsl:with-param name="insuYearFlag" select="$Life_Detail/Ins_Cyc_Cd" />
								</xsl:call-template>
							</InsuYearFlag>
							<!---�����ڼ�-->
							<InsuYear>
								<xsl:if test="$Life_Detail/Ins_Yr_Prd_CgyCd='05'">106</xsl:if>
								<xsl:if test="$Life_Detail/Ins_Yr_Prd_CgyCd!='05'"><xsl:value-of select="$Life_Detail/Ins_Ddln" /></xsl:if>
							</InsuYear>
							<!-- �����ڼ䵥λ -->
							<PayEndYearFlag>
								<xsl:call-template name="tran_InsPrem_PyF_Cyc_Cd">
									<xsl:with-param name="payIntv" select="$Life_Detail/nsPrem_PyF_MtdCd" />
									<xsl:with-param name="payEndYearFlag" select="$Life_Detail/InsPrem_PyF_Cyc_Cd" />
								</xsl:call-template>
							</PayEndYearFlag>
							<xsl:choose>
								<xsl:when test="$Life_Detail/InsPrem_PyF_MtdCd='02'">
									<PayEndYear>1000</PayEndYear>
								</xsl:when>
								<xsl:otherwise>
									<PayEndYear><xsl:value-of select="$Life_Detail/InsPrem_PyF_Prd_Num" /></PayEndYear>
								</xsl:otherwise>
							</xsl:choose>
							<NeedDuty>1</NeedDuty>
							<BuildCalType></BuildCalType>
							<BuildArea></BuildArea>
							<BuildCost></BuildCost>
							<BuildHeigth></BuildHeigth>
							<Dutys>
								<DutyCount>1</DutyCount> <!---������Ŀ-->
								<Duty>
									<DutyCode></DutyCode> <!-- ���α��� -->
									<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Life_Detail/InsPrem_Amt)" /></Prem> <!---����-->
									<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($Life_Detail/Ins_Cvr)" /></Amnt> <!---����-->
									 <!---���ѷ�ʽ-->
									<PayIntv>
										<xsl:call-template name="tran_InsPrem_PyF_MtdCd">
											<xsl:with-param name="payIntv" select="$Life_Detail/InsPrem_PyF_MtdCd" />
											<xsl:with-param name="payEndYearFlag" select="$Life_Detail/InsPrem_PyF_Cyc_Cd" />
										</xsl:call-template>
									</PayIntv>
									<GetIntv></GetIntv> <!---��ȡ��ʽ-->
									<GetDutyKind></GetDutyKind>
									<GetLimit></GetLimit> <!---�����-->
									<GetRate></GetRate> <!---�⸶����-->
									<GetYear></GetYear> 
									<GetYearFlag></GetYearFlag> 
									<StandbyFlag1></StandbyFlag1>
									<StandbyFlag2></StandbyFlag2>
									<StandbyFlag3></StandbyFlag3>
								</Duty>
							</Dutys>
							<InputMode></InputMode>
							<InsuAccs>
								<InsuAccCount>1</InsuAccCount>
								<InsuAcc>
									<InsuAccNo></InsuAccNo>
									<InvestRate></InvestRate>
								</InsuAcc>
							</InsuAccs>
						</Risk>
				</Risks>
				<SSFlag></SSFlag>
			</LCInsured>
		</LCInsureds>
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
		<!-- �ݲ�����ʢ2��Ʒ -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1�������գ������ͣ�B�� -->
		<!-- <xsl:when test="$riskcode='L12079'">L12079</xsl:when> -->	<!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='122035'">L12074</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='50002'">50015</xsl:when>	    <!-- �������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 �������߰���5�Ų�Ʒ   ����5���ݲ����� begin -->
		<xsl:when test="$riskcode='L12070'">L12070</xsl:when>	<!-- ����ٰ���5������� -->
		<xsl:when test="$riskcode='L12071'">L12071</xsl:when>	<!-- ����ӳ�������5����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='50012'">50012</xsl:when>	    <!-- ����ٰ���5�ű��ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 �������߰���5�Ų�Ʒ   end -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ���нɷ�Ƶ�Σ�-1�������ڽɣ�0��������1���½���3��������6�����꽻��12�꽻��98 ����ĳȷ�����䣬99 �������� -->
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

</xsl:stylesheet>
