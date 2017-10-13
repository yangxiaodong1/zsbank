<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/TXLife">
		<TranData>
			<xsl:apply-templates select="Head" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Head" match="Head">
		<Head>
			<TranDate><xsl:value-of select="MsgSendDate" /></TranDate>
			<TranTime><xsl:value-of select="MsgSendTime" /></TranTime>
			<TellerNo><xsl:value-of select="OperTellerNo" /></TellerNo>
			<TranNo><xsl:value-of select="TransSerialCode" /></TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	<xsl:template name="Body" match="Body">
		<ProposalPrtNo><xsl:value-of select="PolicyInfo/PolHNo" /></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="PolicyInfo/PolPrintCode" /></ContPrtNo>
		<PolApplyDate><xsl:value-of select="PolicyInfo/InsureDate" /></PolApplyDate>
		<AccName><xsl:value-of select="PolicyInfo/AccName" /></AccName>
		<AccNo><xsl:value-of select="PolicyInfo/AccNo" /></AccNo>
		<GetPolMode><xsl:apply-templates select="PolicyInfo/SendPolType" /></GetPolMode><!-- �������ͷ�ʽ:1=�ʼģ�2=���й�����ȡ -->
		<JobNotice><xsl:value-of select="PolicyInfo/DangerInf" /></JobNotice><!-- ְҵ��֪(N/Y) -->
		<HealthNotice><xsl:value-of select="PolicyInfo/HealthInf" /></HealthNotice><!-- ������֪(N/Y)  -->
		<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��/N��-->
        <PolicyIndicator>
            <xsl:choose>
                <xsl:when test="InsuredList/InsuredInFo/DeadInfo > 0">Y</xsl:when>
                <xsl:otherwise>N</xsl:otherwise>
            </xsl:choose>
        </PolicyIndicator>
        <!--�ۼ�Ͷ����ʱ���(���ĵ�λ��Ԫ)-->
        <xsl:choose>
			<xsl:when test="InsuredList/InsuredInFo/DeadInfo='0.00' or InsuredList/InsuredInFo/DeadInfo=''">
				<InsuredTotalFaceAmount></InsuredTotalFaceAmount>
			</xsl:when>
			<xsl:otherwise>
				<InsuredTotalFaceAmount><xsl:value-of select="InsuredList/InsuredInFo/DeadInfo*0.01" /></InsuredTotalFaceAmount>
			</xsl:otherwise>
		</xsl:choose>
		<PolicyDeliveryMethod>1</PolicyDeliveryMethod><!-- ������������1��ֽ�Ʊ���2�����ӱ��� -->
		<SellerNo>
        	<xsl:value-of select="PolicyInfo/ClerkCode" /><!-- ������Ա���� -->
        </SellerNo>
		<AgentComName><xsl:value-of select="BranchName" /></AgentComName><!--������������-->
		<AgentComCertiCode></AgentComCertiCode><!-- �������֤-->
		<TellerName><xsl:value-of select="PolicyInfo/ClerkName" /></TellerName><!--����������Ա����-->
		<TellerCertiCode><xsl:value-of select="PolicyInfo/ClerkCard" /></TellerCertiCode><!-- ������Ա�ʸ�֤-->
		<xsl:variable name="MainRisk"   select="PlanCodeInfo/PClist/PCCategory/PCInfo[PCIsMajor='Y']" />
		<!-- ��Ʒ��� -->
        <ContPlan>
            <!-- ��Ʒ��ϱ��� -->
            <ContPlanCode>
                <xsl:call-template name="tran_ContPlanCode">
                    <xsl:with-param name="contPlanCode">
                        <xsl:value-of select="$MainRisk/PCCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </ContPlanCode>
            <!-- ��Ʒ��Ϸ��� -->
            <ContPlanMult>
                <xsl:value-of select="$MainRisk/PCNumber" />
            </ContPlanMult>
        </ContPlan>
        <!-- Ͷ���� -->
        <Appnt>
        	<xsl:apply-templates select="PolicyHolder/CustomsGeneralInfo" />
        	<!-- 1.����2.ũ�� -->
			<LiveZone>
				<xsl:value-of select="PolicyHolder/CustomsGeneralInfo/Residence" />
			</LiveZone>
			<!-- Ͷ����������(����Ԫ) -->
			<xsl:choose>
				<xsl:when test="PolicyHolder/CustomsGeneralInfo/CusAnnualIncome=''">
					<Salary />
				</xsl:when>
				<xsl:otherwise>
					<Salary>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PolicyHolder/CustomsGeneralInfo/CusAnnualIncome)" />
					</Salary>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="PolicyHolder/CustomsGeneralInfo/HomeYearIncome=''">
					<FamilySalary />
				</xsl:when>
				<xsl:otherwise>
					<FamilySalary>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PolicyHolder/CustomsGeneralInfo/HomeYearIncome)" />
					</FamilySalary>
				</xsl:otherwise>
			</xsl:choose>
			<RiskAssess></RiskAssess>
        	<RelaToInsured>
				<xsl:apply-templates select="InsuredList/InsuredInFo/IsdToPolH" />
			</RelaToInsured>
        </Appnt>
        <!-- �������� -->
        <Insured>
        	<xsl:apply-templates select="InsuredList/InsuredInFo/CustomsGeneralInfo" />
        </Insured>
        <!-- ������ -->
        <xsl:apply-templates select="BeneficiaryList[BCount!='00']/BeneficiaryInfo" />
        <Risk>
        	<xsl:apply-templates select="PlanCodeInfo/PClist/PCCategory/PCInfo[PCIsMajor='Y']" />
        </Risk>
    </xsl:template>
    <!-- Ͷ����AND�������� -->
	<xsl:template name="Customs" match="CustomsGeneralInfo">
		<Name>
			<xsl:value-of select="CusName" />
		</Name>
		<Sex>
			<xsl:apply-templates select="CusGender" />
		</Sex>
		<Birthday>
			<xsl:value-of select="CusBirthDay" />
		</Birthday>
		<IDType>
			<xsl:apply-templates select="CusCerType" />
		</IDType>
		<IDNo>
			<xsl:value-of select="CusCerNo" />
		</IDNo>
		<IDTypeStartDate>
			<xsl:value-of select="CusCerStartDate" />
		</IDTypeStartDate>
		<IDTypeEndDate>
			<xsl:value-of select="CusCerEndDate" />
		</IDTypeEndDate>
		<JobCode>
			<xsl:apply-templates select="CusJobCode" />
		</JobCode>
		<Nationality>
			<xsl:apply-templates select="CusCty" />
		</Nationality>
		<Stature>
			<xsl:value-of select="Stature" />
		</Stature>
		<Weight>
			<xsl:value-of select="Weight" />
		</Weight>
		<MaritalStatus>
			<xsl:apply-templates select="CusMarriage" />
		</MaritalStatus>
		<Address>
			<xsl:value-of select="CusPostAddr" />
		</Address>
		<ZipCode>
			<xsl:value-of select="CusPostCode" />
		</ZipCode>
		<Mobile>
			<xsl:value-of select="CusCPhNo" /><!-- �ƶ��绰 -->
		</Mobile>
		<!-- ��ͥ�绰���͡��칫�绰�����ֻ����һ��������ͨ����ֵ��Ϊ�̶��绰��������ϵͳ���������ͬʱ���ͣ��򽫡���ͥ�绰����Ϊ�̶��绰��������ϵͳ�� -->
		<Phone><!-- �̶��绰 -->
			<xsl:choose>
				<xsl:when test="CusFmyPhNo=''">
					<xsl:value-of select="CusOffPhNo" /><!-- �칫�绰 -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="CusFmyPhNo" /><!-- ��ͥ�绰 -->
				</xsl:otherwise>
			</xsl:choose>
		</Phone>
		<Email>
			<xsl:value-of select="CusEmail" />
		</Email>
	</xsl:template>
	<!-- ��������Ϣ -->
    <xsl:template match="BeneficiaryInfo">
        <Bnf>
        	<!-- ����ͨ�ж�����������ֻ����Ϊ��1��������ˡ� -->
            <Type><xsl:value-of select="BFType" /></Type>
            <!-- ����˳�� (��������1��ʼ) -->
            <Grade>
                <xsl:value-of select="BFSequence" />
            </Grade>
            
            <xsl:apply-templates select="CustomsGeneralInfo" />
            
            <!-- �������뱻�����˹�ϵ -->
            <RelaToInsured>
                <xsl:apply-templates select="BFToIsd" />
            </RelaToInsured>
            
            <!-- ��������������� -->
            <Lot>
                <xsl:value-of select="BFLot" />
            </Lot>
        </Bnf>
    </xsl:template>
	<xsl:template match="PCInfo">
		<RiskCode><xsl:apply-templates select="PCCode" /></RiskCode>
   		<MainRiskCode><xsl:apply-templates select="PCCode" /></MainRiskCode>
   		<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)" /></Amnt>
   		<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Premium)" /></Prem>
   		<Mult><xsl:value-of select="format-number(PCNumber,'#')" /></Mult>
   		<PayMode></PayMode><!-- �ɷ���ʽ -->
   		<PayIntv><xsl:apply-templates select="PayPeriodType" /></PayIntv><!-- �ɷ���������+++�ɷ�Ƶ�� -->
   		<InsuYearFlag><xsl:apply-templates select="CovPeriodType" /></InsuYearFlag>
   		<!-- �������� -->
   		<xsl:choose>
			<xsl:when test="CovPeriodType='1'"><!-- ������ -->
				<InsuYear>106</InsuYear>
			</xsl:when>
			<xsl:otherwise>
				<InsuYear><xsl:value-of select="InsuYear" /></InsuYear>
			</xsl:otherwise>
		</xsl:choose>
   		<PayEndYearFlag><xsl:apply-templates select="PayTermType" /></PayEndYearFlag><!-- �ɷ�����/�������� -->
   		<xsl:choose>
			<xsl:when test="PayTermType='1'"><!-- 1 ���� -->
				<PayEndYear>1000</PayEndYear>
			</xsl:when>
			<xsl:otherwise>
				<PayEndYear><xsl:value-of select="PayYear" /></PayEndYear>
			</xsl:otherwise>
		</xsl:choose>   		
   		<BonusGetMode><xsl:apply-templates select="BonusPayMode" /></BonusGetMode><!-- ������ȡ��ʽ -->
   		<FullBonusGetMode></FullBonusGetMode><!-- ������ȡ����ȡ��ʽ -->
   		<GetYearFlag></GetYearFlag><!-- ��ȡ�������ڱ�־ -->
   		<GetYear><xsl:value-of select="FullBonusPeriod" /></GetYear><!-- ��ȡ���� -->
   		<GetIntv><xsl:apply-templates select="FullBonusGetMode" /></GetIntv> <!-- ��ȡ��ʽ -->
   		<GetBankCode><xsl:value-of select="../../../GetBankInfo/GetBankCode" /></GetBankCode> <!-- ��ȡ���б��� -->
   		<GetBankAccNo><xsl:value-of select="../../../GetBankInfo/GetBankAccNo" /></GetBankAccNo><!-- ��ȡ�����˻� -->
   		<GetAccName><xsl:value-of select="../../../GetBankInfo/GetAccName" /></GetAccName><!-- ��ȡ���л��� -->
   		<AutoPayFlag></AutoPayFlag> <!-- �Զ��潻��־ -->
	</xsl:template>
	
	
	<!-- SendPolType �������ͷ�ʽ:1=�ʼģ�2=���й�����ȡ -->
	<xsl:template match="SendPolType">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- ���չ�˾���ŷ��� -->
			<xsl:when test=".='2'">1</xsl:when><!-- �ʼ� -->
			<xsl:when test=".='3'">1</xsl:when><!-- ���ŵ��� -->
			<xsl:when test=".='4'">2</xsl:when><!-- ���й�̨ -->
		</xsl:choose>
	</xsl:template>
	
	<!-- CusGender �Ա�M/F/N -->
	<xsl:template match="CusGender">
		<xsl:choose>
			<xsl:when test=".='M'">0</xsl:when><!-- �� -->
			<xsl:when test=".='F'">1</xsl:when><!-- Ů -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- CusCerType ֤������ -->
	<xsl:template match="CusCerType">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- ���֤+++ �������֤ -->
			<xsl:when test=".='2'">5</xsl:when><!-- ���ڱ�+++ ���ڲ� -->
			<xsl:when test=".='3'">2</xsl:when><!-- ����֤+++ ����֤ -->
			<xsl:when test=".='4'">8</xsl:when><!-- ����֤+++ ���� -->
			<xsl:when test=".='5'">8</xsl:when><!-- ʿ��֤+++ ���� -->
			<xsl:when test=".='6'">8</xsl:when><!-- ��ְ�ɲ�֤+++ ���� -->
			<xsl:when test=".='7'">1</xsl:when><!-- ����+++ ���� -->
			<xsl:when test=".='8'">6</xsl:when><!-- �۰�̨ͨ��֤+++ �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test=".='9'">8</xsl:when><!-- ����+++ ���� -->
			<xsl:when test=".='A'">9</xsl:when><!-- ��ʱ���֤+++�쳣���֤ -->
		</xsl:choose>
	</xsl:template>
	
	<!-- CusMarriage ����״̬ -->
	<xsl:template match="CusMarriage">
		<xsl:choose>
			<xsl:when test=".='1'">N</xsl:when><!-- δ��+++�� -->
			<xsl:when test=".='2'">Y</xsl:when><!-- �ѻ� +++�� -->
			<xsl:when test=".='3'">N</xsl:when><!-- ����+++��Ů -->
			<xsl:when test=".='4'">N</xsl:when><!-- ɥż+++���� -->
			<xsl:when test=".='5'">N</xsl:when><!-- ����+++ -->
		</xsl:choose>
	</xsl:template>
	
	<!-- IsdToPolH ��ϵ�����ũ������������Ͷ���˹�ϵ�����ģ�Ͷ�����뱻���˹�ϵ -->
	<xsl:template match="IsdToPolH">
		<xsl:choose>
			<xsl:when test=".='1'">02</xsl:when><!-- ��ż+++��ż -->
			<xsl:when test=".='2'">03</xsl:when><!-- ��ĸ+++��Ů -->
			<xsl:when test=".='3'">01</xsl:when><!-- ��Ů+++��ĸ -->
			<xsl:when test=".='4'">04</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='5'">00</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='6'">04</xsl:when><!-- ����+++���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- BFToIsd ��ϵ�����ũ���������뱻�����˹�ϵ�����ģ��������뱻�����˹�ϵ -->
	<xsl:template match="BFToIsd">
		<xsl:choose>
			<xsl:when test=".='1'">02</xsl:when><!-- ��ż+++��ż -->
			<xsl:when test=".='2'">01</xsl:when><!-- ��ĸ+++��ĸ -->
			<xsl:when test=".='3'">03</xsl:when><!-- ��Ů+++��Ů -->
			<xsl:when test=".='4'">04</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='5'">00</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='6'">04</xsl:when><!-- ����+++���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ��Ʒ��ϴ��� -->
    <xsl:template name="tran_ContPlanCode">
        <xsl:param name="contPlanCode" />
        <xsl:choose>            
            <xsl:when test="$contPlanCode='50015'">50015</xsl:when><!-- �������Ӯ���ռƻ� -->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="PCCode">
		<xsl:choose>
			<xsl:when test=".='50015'">50015</xsl:when>  <!-- �������Ӯ���ռƻ� -->	
			
			<xsl:when test=".='L12088'">L12088</xsl:when>  <!-- �����9����ȫ���գ������ͣ� -->	
					
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PayPeriodType�ɷ��������� -->
	<xsl:template match="PayPeriodType">
		<xsl:choose>
			<xsl:when test=".='0'">12</xsl:when><!-- �꽻+++�꽻 -->
			<xsl:when test=".='1'">6</xsl:when><!-- ���꽻+++���꽻 -->
			<xsl:when test=".='2'">3</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='3'">1</xsl:when><!-- �½�+++�½� -->
			<xsl:when test=".='4'">0</xsl:when><!-- ����+++���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- CovPeriodType������������ -->
	<xsl:template match="CovPeriodType">
		<xsl:choose>
			<xsl:when test=".='1'">A</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='2'">Y</xsl:when><!-- �����ޱ�+++���� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳȷ������+++��ĳȷ������ -->
			<xsl:when test=".='4'">M</xsl:when><!-- ���±�+++���� -->
			<xsl:when test=".='5'">D</xsl:when><!-- ���챣+++���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PayTermType�ɷ��������� -->
	<xsl:template match="PayTermType">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='2'">Y</xsl:when><!-- �����޽�+++���� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳȷ������+++��ĳȷ������ -->
			<xsl:when test=".='4'">A</xsl:when><!-- ��������+++���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- BonusPayMode������ȡ��ʽ -->
	<xsl:template match="BonusPayMode">
		<xsl:choose>
			<xsl:when test=".='0'">4</xsl:when><!-- �ֽ����+++�ֽ���ȡ -->
			<xsl:when test=".='1'">3</xsl:when><!-- �ֽ�����+++�ֽ����� -->
			<xsl:when test=".='2'">1</xsl:when><!-- �ۼ���Ϣ+++�ۼ���Ϣ -->
			<xsl:when test=".='3'">5</xsl:when><!-- �������+++������� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- FullBonusGetMode������ȡ����ȡ��ʽ -->
	<xsl:template match="FullBonusGetMode">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='2'">3</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='3'">6</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='4'">12</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='5'">0</xsl:when><!-- ����+++���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<!-- CusCty ���� -->
	<xsl:template match="CusCty">
		<xsl:choose>
			<xsl:when test=".='CHN'">CHN</xsl:when><!-- �й�+++�й� -->
			<xsl:when test=".='AFG'">AF</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='ALB'">AL</xsl:when><!-- ����������+++���������� -->
			<xsl:when test=".='DZA'">OTH</xsl:when><!-- ����������+++���� -->
			<xsl:when test=".='ASM'">OTH</xsl:when><!-- ������Ħ��Ⱥ��+++���� -->
			<xsl:when test=".='AND'">AD</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='AGO'">AO</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='AIA'">AI</xsl:when><!-- ANGUILLA+++������ -->
			<xsl:when test=".='ATA'">OTH</xsl:when><!-- �ϼ���+++���� -->
			<xsl:when test=".='ATG'">AG</xsl:when><!-- ����ϺͰͲ���+++����ϺͰͲ��� -->
			<xsl:when test=".='ARG'">AR</xsl:when><!-- ����͢+++����͢ -->
			<xsl:when test=".='ARM'">OTH</xsl:when><!-- ��������+++���� -->
			<xsl:when test=".='ABW'">AW</xsl:when><!-- ��³��+++��³�� -->
			<xsl:when test=".='AUS'">AU</xsl:when><!-- �Ĵ�����+++�Ĵ����� -->
			<xsl:when test=".='AUT'">AT</xsl:when><!-- �µ���+++�µ��� -->
			<xsl:when test=".='AZE'">AZ</xsl:when><!-- �����ݽ�+++�����ݽ� -->
			<xsl:when test=".='BHS'">BS</xsl:when><!-- �͹���+++�͹��� -->
			<xsl:when test=".='BHR'">BH</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='BGD'">BD</xsl:when><!-- �ϼ���+++�ϼ��� -->
			<xsl:when test=".='BRB'">OTH</xsl:when><!-- �ͰͶ�˹+++���� -->
			<xsl:when test=".='BLR'">BY</xsl:when><!-- �׶���˹+++�׶���˹ -->
			<xsl:when test=".='BEL'">BE</xsl:when><!-- ����ʱ+++����ʱ -->
			<xsl:when test=".='BLZ'">BZ</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='BEN'">BJ</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='BMU'">BM</xsl:when><!-- ��Ľ��Ⱥ��+++��Ľ�� -->
			<xsl:when test=".='BTN'">OTH</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='BOL'">BO</xsl:when><!-- ����ά��+++����ά�� -->
			<xsl:when test=".='BIH'">OTH</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='BWA'">BW</xsl:when><!-- ��������+++�������� -->
			<xsl:when test=".='BVT'">OTH</xsl:when><!-- BOUVET ISLAND+++���� -->
			<xsl:when test=".='BRA'">BR</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='IOT'">OTH</xsl:when><!-- BRITISH INDIAN OCEAN TERRITORY+++���� -->
			<xsl:when test=".='BRN'">BN</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='BGR'">BG</xsl:when><!-- ��������+++�������� -->
			<xsl:when test=".='BFA'">BF</xsl:when><!-- BURKINA FASO+++�����ɷ��� -->
			<xsl:when test=".='BDI'">BI</xsl:when><!-- ��¡��+++��¡�� -->
			<xsl:when test=".='KHM'">OTH</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='CMR'">CM</xsl:when><!-- ����¡+++����¡ -->
			<xsl:when test=".='CAN'">CA</xsl:when><!-- ���ô�+++���ô� -->
			<xsl:when test=".='CPV'">CV</xsl:when><!-- ��ý�+++��ý�Ⱥ�� -->
			<xsl:when test=".='CYM'">KY</xsl:when><!-- CAYMAN ISLANDS+++����Ⱥ�� -->
			<xsl:when test=".='CAF'">CF</xsl:when><!-- CENTRAL AFRICAN REPUBLIC+++�зǹ��͹� -->
			<xsl:when test=".='TCD'">TD</xsl:when><!-- է��+++է�� -->
			<xsl:when test=".='CHL'">CL</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='CXR'">OTH</xsl:when><!-- CHRISTMAS ISLAND+++���� -->
			<xsl:when test=".='CCK'">OTH</xsl:when><!-- COCOS (KEELING) ISLANDS+++���� -->
			<xsl:when test=".='COL'">CO</xsl:when><!-- ���ױ���+++���ױ��� -->
			<xsl:when test=".='COM'">KM</xsl:when><!-- COMOROS+++��Ħ��Ⱥ�� -->
			<xsl:when test=".='COG'">ZR</xsl:when><!-- �չ�+++�չ������� -->
			<xsl:when test=".='COD'">CG</xsl:when><!-- CONGO, THE DEMOCRATIC REPUBLIC OF THE+++�չ����� -->
			<xsl:when test=".='COK'">CK</xsl:when><!-- ���Ⱥ��+++���Ⱥ�� -->
			<xsl:when test=".='CRI'">CR</xsl:when><!-- ��˹�����+++��˹����� -->
			<xsl:when test=".='CIV'">OTH</xsl:when><!-- COTE D'IVOIRE+++���� -->
			<xsl:when test=".='HRV'">HR</xsl:when><!-- ���޵���+++���޵��� -->
			<xsl:when test=".='CUB'">CU</xsl:when><!-- �Ű�+++�Ű� -->
			<xsl:when test=".='CYP'">CY</xsl:when><!-- ����·˹+++����·˹ -->
			<xsl:when test=".='CZE'">CZ</xsl:when><!-- �ݿ�+++�ݿ˹��͹� -->
			<xsl:when test=".='DNK'">DK</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='DJI'">DJ</xsl:when><!-- DJIBOUTI+++������ -->
			<xsl:when test=".='DMA'">DM</xsl:when><!-- �������+++����������� -->
			<xsl:when test=".='DOM'">DO</xsl:when><!-- DOMINICAN REPUBLIC+++������ӹ��͹� -->
			<xsl:when test=".='TMP'">OTH</xsl:when><!-- ������+++���� -->
			<xsl:when test=".='ECU'">EC</xsl:when><!-- ��϶��+++��϶�� -->
			<xsl:when test=".='EGY'">EG</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='SLV'">SV</xsl:when><!-- �����߶�+++�����߶� -->
			<xsl:when test=".='GNQ'">GQ</xsl:when><!-- ���������+++��������� -->
			<xsl:when test=".='ERI'">ER</xsl:when><!-- ERITREA+++���������� -->
			<xsl:when test=".='EST'">EE</xsl:when><!-- ��ɳ����+++��ɳ���� -->
			<xsl:when test=".='ETH'">ET</xsl:when><!-- ���������+++��������� -->
			<xsl:when test=".='FLK'">OTH</xsl:when><!-- FALKLAND ISLANDS (MALVINAS)+++���� -->
			<xsl:when test=".='FRO'">FO</xsl:when><!-- FAROE ISLANDS+++����Ⱥ�� -->
			<xsl:when test=".='FJI'">FJ</xsl:when><!-- 쳼�+++쳼� -->
			<xsl:when test=".='FIN'">FI</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='FRA'">FR</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='FXX'">OTH</xsl:when><!-- FRANCE, METROPOLITAN+++���� -->
			<xsl:when test=".='GUF'">OTH</xsl:when><!-- ����������+++���� -->
			<xsl:when test=".='PYF'">PF</xsl:when><!-- ��������������+++�������������� -->
			<xsl:when test=".='ATF'">OTH</xsl:when><!-- FRENCH SOUTHERN TERRITORIES+++���� -->
			<xsl:when test=".='GAB'">GA</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='GMB'">GM</xsl:when><!-- �Ա���+++�Ա��� -->
			<xsl:when test=".='GEO'">GE</xsl:when><!-- ��³����+++��³���� -->
			<xsl:when test=".='DEU'">DE</xsl:when><!-- �¹�+++�¹� -->
			<xsl:when test=".='GHA'">GH</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='GIB'">GI</xsl:when><!-- ֱ������+++ֱ������ -->
			<xsl:when test=".='GRC'">GR</xsl:when><!-- ϣ��+++ϣ�� -->
			<xsl:when test=".='GRL'">OTH</xsl:when><!-- ������+++���� -->
			<xsl:when test=".='GRD'">GD</xsl:when><!-- �����Ǵ�+++�����ɴ� -->
			<xsl:when test=".='GLP'">GP</xsl:when><!-- GUADELOUPE+++�ϵ����� -->
			<xsl:when test=".='GUM'">GU</xsl:when><!-- �ص�+++�ص� -->
			<xsl:when test=".='GTM'">OTH</xsl:when><!-- �ϵ�����+++���� -->
			<xsl:when test=".='GIN'">GN</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='GNB'">OTH</xsl:when><!-- �����Ǳ������͹�+++���� -->
			<xsl:when test=".='GUY'">OTH</xsl:when><!-- ������+++���� -->
			<xsl:when test=".='HTI'">HT</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='HMD'">OTH</xsl:when><!-- HEARD AND MC DONALD ISLANDS+++���� -->
			<xsl:when test=".='VAT'">OTH</xsl:when><!-- HOLY SEE (VATICAN CITY STATE)+++���� -->
			<xsl:when test=".='HND'">HN</xsl:when><!-- �鶼��˹+++�鶼��˹ -->
			<xsl:when test=".='HKG'">CHN</xsl:when><!-- ���+++�й� -->
			<xsl:when test=".='HUN'">HU</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='ISL'">IS</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='IND'">IN</xsl:when><!-- ӡ��+++ӡ�� -->
			<xsl:when test=".='IDN'">ID</xsl:when><!-- ӡ��+++ӡ�������� -->
			<xsl:when test=".='IRN'">IR</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='IRQ'">IQ</xsl:when><!-- �����˹��͹�+++������ -->
			<xsl:when test=".='IRL'">IE</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='ISR'">IL</xsl:when><!-- ��ɫ��+++��ɫ�� -->
			<xsl:when test=".='ITA'">IT</xsl:when><!-- �����+++����� -->
			<xsl:when test=".='JAM'">JM</xsl:when><!-- �����+++����� -->
			<xsl:when test=".='JPN'">JP</xsl:when><!-- �ձ�+++�ձ� -->
			<xsl:when test=".='JOR'">JO</xsl:when><!-- Լ��+++Լ�� -->
			<xsl:when test=".='KAZ'">KZ</xsl:when><!-- ������˹̹+++������˹̹ -->
			<xsl:when test=".='KEN'">KE</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='KIR'">OTH</xsl:when><!-- KIRIBATI+++���� -->
			<xsl:when test=".='PRK'">KP</xsl:when><!-- �������񹲺͹�+++���� -->
			<xsl:when test=".='KOR'">KR</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='KWT'">KW</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='KGZ'">KG</xsl:when><!-- KYRGYZSTAN+++������˼ -->
			<xsl:when test=".='LAO'">LA</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='LVA'">LV</xsl:when><!-- ����ά��+++����ά�� -->
			<xsl:when test=".='LBN'">LB</xsl:when><!-- �����+++����� -->
			<xsl:when test=".='LSO'">LB</xsl:when><!-- ������+++����� -->
			<xsl:when test=".='LBR'">OTH</xsl:when><!-- ��������+++���� -->
			<xsl:when test=".='LBY'">OTH</xsl:when><!-- LIBYAN ARAB JAMAHIRIYA+++���� -->
			<xsl:when test=".='LIE'">LI</xsl:when><!-- LIECHTENSTEIN+++��֧��ʿ�� -->
			<xsl:when test=".='LTU'">LT</xsl:when><!-- LITHUANIA+++������ -->
			<xsl:when test=".='LUX'">LU</xsl:when><!-- ¬ɭ��+++¬ɭ�� -->
			<xsl:when test=".='MAC'">CHN</xsl:when><!-- ����+++�й� -->
			<xsl:when test=".='MKD'">MK</xsl:when><!-- MACEDONIA+++����� -->
			<xsl:when test=".='MDG'">MG</xsl:when><!-- ����˹��+++����˹�� -->
			<xsl:when test=".='MWI'">OTH</xsl:when><!-- ������+++���� -->
			<xsl:when test=".='MYS'">MY</xsl:when><!-- ��������+++�������� -->
			<xsl:when test=".='MDV'">MV</xsl:when><!-- �������+++������� -->
			<xsl:when test=".='MLI'">ML</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='MLT'">MT</xsl:when><!-- �����+++����� -->
			<xsl:when test=".='MHL'">MH</xsl:when><!-- ���ܶ�Ⱥ��+++���ٶ�Ⱥ�� -->
			<xsl:when test=".='MTQ'">MQ</xsl:when><!-- MARTINIQUE+++������� -->
			<xsl:when test=".='MRT'">MR</xsl:when><!-- ë��������+++ë�������� -->
			<xsl:when test=".='MUS'">MU</xsl:when><!-- ë����˹+++ë����˹ -->
			<xsl:when test=".='MYT'">YT</xsl:when><!-- MAYOTTE+++��Լ�ص� -->
			<xsl:when test=".='MEX'">MX</xsl:when><!-- ī����+++ī���� -->
			<xsl:when test=".='FSM'">OTH</xsl:when><!-- �ܿ���������+++���� -->
			<xsl:when test=".='MDA'">MD</xsl:when><!-- Ħ������+++Ħ������ -->
			<xsl:when test=".='MCO'">MC</xsl:when><!-- Ħ�ɸ�+++Ħ�ɸ� -->
			<xsl:when test=".='MNG'">MN</xsl:when><!-- �ɹ�+++�ɹ� -->
			<xsl:when test=".='MSR'">MS</xsl:when><!-- MONTSERRAT+++���������� -->
			<xsl:when test=".='MAR'">MA</xsl:when><!-- Ħ���+++Ħ��� -->
			<xsl:when test=".='MOZ'">MZ</xsl:when><!-- Īɣ�ȿ�+++Īɣ�ȿ� -->
			<xsl:when test=".='MMR'">MM</xsl:when><!-- ���+++��� -->
			<xsl:when test=".='NAM'">NA</xsl:when><!-- ���ױ���+++���ױ��� -->
			<xsl:when test=".='NRU'">NR</xsl:when><!-- �³+++�³ -->
			<xsl:when test=".='NPL'">NP</xsl:when><!-- �Ჴ��+++�Ჴ�� -->
			<xsl:when test=".='NLD'">NL</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='ANT'">OTH</xsl:when><!-- NETHERLANDS ANTILLES+++���� -->
			<xsl:when test=".='NCL'">OTH</xsl:when><!-- �¼��������+++���� -->
			<xsl:when test=".='NZL'">NZ</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='NIC'">NI</xsl:when><!-- �������+++������� -->
			<xsl:when test=".='NER'">NE</xsl:when><!-- ���ն�+++���ն� -->
			<xsl:when test=".='NGA'">NG</xsl:when><!-- ��������+++�������� -->
			<xsl:when test=".='NIU'">NU</xsl:when><!-- NIUE+++Ŧ���� -->
			<xsl:when test=".='NFK'">NF</xsl:when><!-- NORFOLK ISLAND+++ŵ����Ⱥ�� -->
			<xsl:when test=".='MNP'">MP</xsl:when><!-- NORTHERN MARIANA ISLANDS+++����������Ⱥ�� -->
			<xsl:when test=".='NOR'">NO</xsl:when><!-- Ų��+++Ų�� -->
			<xsl:when test=".='OMN'">OM</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='PAK'">PK</xsl:when><!-- �ͻ�˹̹+++�ͻ�˹̹ -->
			<xsl:when test=".='PLW'">PW</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='PAN'">PA</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='PNG'">PG</xsl:when><!-- �Ͳ����¼�����+++�Ͳ����¼����� -->
			<xsl:when test=".='PRY'">PY</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='PER'">PE</xsl:when><!-- ��³+++��³ -->
			<xsl:when test=".='PHL'">PH</xsl:when><!-- ���ɱ����͹�+++���ɱ� -->
			<xsl:when test=".='PCN'">OTH</xsl:when><!-- PITCAIRN+++���� -->
			<xsl:when test=".='POL'">PL</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='PRT'">PT</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='PRI'">PR</xsl:when><!-- �������+++������� -->
			<xsl:when test=".='QAT'">QA</xsl:when><!-- QATAR+++������ -->
			<xsl:when test=".='REU'">RE</xsl:when><!-- REUNION+++�������� -->
			<xsl:when test=".='ROM'">RO</xsl:when><!-- ��������+++�������� -->
			<xsl:when test=".='RUS'">RU</xsl:when><!-- ����˹+++����˹ -->
			<xsl:when test=".='RWA'">RW</xsl:when><!-- ¬����+++¬���� -->
			<xsl:when test=".='KNA'">OTH</xsl:when><!-- SAINT KITTS AND NEVIS+++���� -->
			<xsl:when test=".='LCA'">SQ</xsl:when><!-- SAINT LUCIA+++ʥ¬���� -->
			<xsl:when test=".='VCT'">OTH</xsl:when><!-- SAINT VINCENT AND THE GRENADINES+++���� -->
			<xsl:when test=".='WSM'">WS</xsl:when><!-- ��Ħ��+++��Ħ�� -->
			<xsl:when test=".='SMR'">SM</xsl:when><!-- ʥ����ŵ+++ʥ����ŵ -->
			<xsl:when test=".='STP'">ST</xsl:when><!-- SAO TOME AND PRINCIPE+++ʥ�������������� -->
			<xsl:when test=".='SAU'">SA</xsl:when><!-- ɳ�ذ�����+++ɳ�ذ����� -->
			<xsl:when test=".='SEN'">SN</xsl:when><!-- SENEGAL+++���ڼӶ� -->
			<xsl:when test=".='SYC'">SC</xsl:when><!-- �����+++����� -->
			<xsl:when test=".='SLE'">SL</xsl:when><!-- ��������+++�����ﰺ -->
			<xsl:when test=".='SGP'">SG</xsl:when><!-- �¼���+++�¼��� -->
			<xsl:when test=".='SVK'">SK</xsl:when><!-- ˹�工��+++˹�工�� -->
			<xsl:when test=".='SVN'">SI</xsl:when><!-- ˹��������+++˹�������� -->
			<xsl:when test=".='SLB'">SB</xsl:when><!-- ������Ⱥ��+++������Ⱥ�� -->
			<xsl:when test=".='SOM'">SO</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='ZAF'">ZA</xsl:when><!-- �Ϸ�+++�Ϸ� -->
			<xsl:when test=".='SGS'">OTH</xsl:when><!-- SOUTH GEORGIA AND+++���� -->
			<xsl:when test=".='ESP'">ES</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='LKA'">LK</xsl:when><!-- ˹������+++˹������ -->
			<xsl:when test=".='SHN'">OTH</xsl:when><!-- ST. HELENA+++���� -->
			<xsl:when test=".='SPM'">OTH</xsl:when><!-- ST. PIERRE AND MIQUELON+++���� -->
			<xsl:when test=".='SDN'">SD</xsl:when><!-- �յ�+++�յ� -->
			<xsl:when test=".='SUR'">SR</xsl:when><!-- SURINAME+++������ -->
			<xsl:when test=".='SJM'">OTH</xsl:when><!-- SVALBARD AND JAN MAYEN ISLANDS+++���� -->
			<xsl:when test=".='SWZ'">OTH</xsl:when><!-- ʷ�߼���+++���� -->
			<xsl:when test=".='SWE'">SE</xsl:when><!-- ���+++��� -->
			<xsl:when test=".='CHE'">CH</xsl:when><!-- ��ʿ+++��ʿ -->
			<xsl:when test=".='SYR'">SY</xsl:when><!-- SYRIAN ARAB REPUBLIC+++������ -->
			<xsl:when test=".='TWN'">CHN</xsl:when><!-- ̨��+++�й� -->
			<xsl:when test=".='TJK'">TJ</xsl:when><!-- ������˹̹+++������˹̹ -->
			<xsl:when test=".='TZA'">TZ</xsl:when><!-- ̹ɣ����+++̹ɣ���� -->
			<xsl:when test=".='THA'">TH</xsl:when><!-- ̩��+++̩�� -->
			<xsl:when test=".='TGO'">TG</xsl:when><!-- TOGO+++��� -->
			<xsl:when test=".='TKL'">OTH</xsl:when><!-- TOKELAU+++���� -->
			<xsl:when test=".='TON'">TO</xsl:when><!-- TONGA+++���� -->
			<xsl:when test=".='TTO'">TT</xsl:when><!-- TRINIDAD AND TOBAGO+++�������Ͷ�͸� -->
			<xsl:when test=".='TUN'">TN</xsl:when><!-- ͻ��˹+++ͻ��˹ -->
			<xsl:when test=".='TUR'">TR</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='TKM'">TM</xsl:when><!-- ������˹̹+++������˹̹ -->
			<xsl:when test=".='TCA'">OTH</xsl:when><!-- TURKS AND CAICOS ISLANDS+++���� -->
			<xsl:when test=".='TUV'">TV</xsl:when><!-- TUVALU+++ͼ��¬ -->
			<xsl:when test=".='UGA'">UG</xsl:when><!-- �ڸɴ�+++�ڸɴ� -->
			<xsl:when test=".='UKR'">UA</xsl:when><!-- �ڿ���+++�ڿ��� -->
			<xsl:when test=".='ARE'">AE</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='GBR'">GB</xsl:when><!-- Ӣ��+++Ӣ�� -->
			<xsl:when test=".='USA'">US</xsl:when><!-- ����+++���� -->
			<xsl:when test=".='UMI'">OTH</xsl:when><!-- UNITED STATES MINOR OUTLYING ISLANDS+++���� -->
			<xsl:when test=".='URY'">UY</xsl:when><!-- ������+++������ -->
			<xsl:when test=".='UZB'">UZ</xsl:when><!-- ���ȱ��˹̹+++���ȱ��˹̹ -->
			<xsl:when test=".='VUT'">VU</xsl:when><!-- VANUATU+++��Ŭ��ͼ -->
			<xsl:when test=".='VEN'">VE</xsl:when><!-- ί������+++ί������ -->
			<xsl:when test=".='VNM'">VN</xsl:when><!-- Խ��+++Խ�� -->
			<xsl:when test=".='VGB'">VG</xsl:when><!-- VIRGIN ISLANDS (BRITISH)+++Ӣ��ά����Ⱥ�� -->
			<xsl:when test=".='WLF'">OTH</xsl:when><!-- WALLIS AND FUTUNA ISLANDS+++���� -->
			<xsl:when test=".='ESH'">OTH</xsl:when><!-- ��������+++���� -->
			<xsl:when test=".='YEM'">YE</xsl:when><!-- Ҳ��+++Ҳ�� -->
			<xsl:when test=".='YUG'">YU</xsl:when><!-- ��˹����+++��˹���� -->
			<xsl:when test=".='ZMB'">ZM</xsl:when><!-- �ޱ���+++�ޱ��� -->
			<xsl:when test=".='ZWE'">ZW</xsl:when><!-- ��Ͳ�Τ+++��Ͳ�Τ -->
		</xsl:choose>
	</xsl:template>
	
	<!-- CusJobCode ְҵ���� -->
	<xsl:template match="CusJobCode">
		<xsl:choose>
			<xsl:when test=".='000101'">4030111</xsl:when><!-- ����Ա��ְԱ�����ڣ�+++���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
			<xsl:when test=".='000102'">6050611</xsl:when><!-- ά�޹���˾�������ڣ�+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='000103'">6050611</xsl:when><!-- ����������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='010101'">5010107</xsl:when><!-- ��ֲҵ��+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010102'">5010107</xsl:when><!-- ��ֳҵ��+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010103'">5010107</xsl:when><!-- ��ũ +++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010104'">5010107</xsl:when><!-- ���Թ� +++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010105'">5010107</xsl:when><!-- ũҵ������Ա(��������ҵ)+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010106'">5010107</xsl:when><!-- ũҵ��ʦ +++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010107'">5010107</xsl:when><!-- ũҵ���� +++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010108'">5010107</xsl:when><!-- ũҵ��е������ά����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010109'">5010107</xsl:when><!-- ũҵʵ����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010110'">5010107</xsl:when><!-- ũ���ز�Ʒ�ӹ���Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010111'">5010107</xsl:when><!-- �ȴ�����������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010112'">5010107</xsl:when><!-- ���̹�+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010113'">5010107</xsl:when><!-- ũ����+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010201'">5010107</xsl:when><!-- ����������Ա(��������ҵ)+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010202'">5010107</xsl:when><!-- Ȧ����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010203'">5010107</xsl:when><!-- ������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010204'">5010107</xsl:when><!-- ��ҽ+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010205'">5010107</xsl:when><!-- �����߲�������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010206'">5010107</xsl:when><!-- ʵ�鶯��������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010207'">5010107</xsl:when><!-- ��ҵ������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010208'">5010107</xsl:when><!-- ���ݡ������������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010209'">5010107</xsl:when><!-- ��������ҵ������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010210'">5010107</xsl:when><!-- ����������Ա��������ҵ��+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010211'">5010107</xsl:when><!-- ���棨�۷䣩������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='010212'">5010107</xsl:when><!-- ���｡������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020101'">5010107</xsl:when><!-- �泡������Ա(��������ҵ)+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020102'">5010107</xsl:when><!-- �泡������Ա(������ҵ) +++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020103'">5010107</xsl:when><!-- ��ֳ����(��½)+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020104'">5010107</xsl:when><!-- ��ֳ����(�غ�)+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020105'">5010107</xsl:when><!-- ������(��½)+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020107'">5010107</xsl:when><!-- ˮ��ʵ����Ա(����)+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020108'">5010107</xsl:when><!-- ������(�غ�)+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020109'">5010107</xsl:when><!-- ˮ��Ʒ�ӹ���Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020110'">5010107</xsl:when><!-- ˮ��ݾ�Ӫ��+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020201'">5010107</xsl:when><!-- �����洬��Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020202'">5010107</xsl:when><!-- ������ҵ�������ȹ�����Ա������ʦ���󸱡��������������װ��֡������ˡ���ʦ���״����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='020203'">5010107</xsl:when><!-- Զ����ҵ�������ȹ�����Ա������ʦ���󸱡��������������װ��֡������ˡ���ʦ���״����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030101'">5010107</xsl:when><!-- ɽ�ֹ���Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030102'">5010107</xsl:when><!-- ɽ�����ֹ���+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030103'">5010107</xsl:when><!-- ɭ�ַ���Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030104'">5010107</xsl:when><!-- ƽ��������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030105'">5010107</xsl:when><!-- ʵ��������������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030201'">5010107</xsl:when><!-- ������������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030201'">5010107</xsl:when><!-- ������������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030202'">5010107</xsl:when><!-- ��ľ����+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030203'">5010107</xsl:when><!-- �˲ĳ���˾����Ѻ����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030204'">5010107</xsl:when><!-- ���ػ���������+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030205'">5010107</xsl:when><!-- װ�˹���+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030206'">5010107</xsl:when><!-- ���+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030207'">5010107</xsl:when><!-- ľ�Ĺ����ֳ�������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030301'">5010107</xsl:when><!-- һ�㹤����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030302'">5010107</xsl:when><!-- ������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030303'">5010107</xsl:when><!-- ��ľ����+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030304'">5010107</xsl:when><!-- ����������+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030305'">5010107</xsl:when><!-- ľ�Ĵ��ز۹���+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030306'">5010107</xsl:when><!-- ľ�İ��˹���+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030307'">5010107</xsl:when><!-- ����������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030308'">5010107</xsl:when><!-- ���+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030309'">5010107</xsl:when><!-- �ϰ����칤��+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030310'">5010107</xsl:when><!-- �ּ�Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030311'">5010107</xsl:when><!-- ���Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030312'">5010107</xsl:when><!-- ���Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030313'">5010107</xsl:when><!-- ����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030401'">5010107</xsl:when><!-- ����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030402'">5010107</xsl:when><!-- ɭ�ֲ��溦����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030403'">5010107</xsl:when><!-- ����ɭ����Դ�ܻ���Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030501'">5010107</xsl:when><!-- Ұ�����ﱣ����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030502'">5010107</xsl:when><!-- Ұ��ֲ�ﱣ����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030503'">5010107</xsl:when><!-- ��Ȼ������Ѳ�����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='030504'">5010107</xsl:when><!-- �걾Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='040101'">2020103</xsl:when><!-- ����������Ա(�����ֳ�)+++��ַ��̽��Ա -->
			<xsl:when test=".='040102'">2020103</xsl:when><!-- ��ҵ����ʦ����ʦ�����+++��ַ��̽��Ա -->
			<xsl:when test=".='040103'">2020103</xsl:when><!-- ��ʯ���ɿ���ҵ��Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040104'">2020103</xsl:when><!-- �Ϳ��꿱��ҵ��Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040105'">2020103</xsl:when><!-- ������ҵ��Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040106'">2020103</xsl:when><!-- ����������Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040107'">2020103</xsl:when><!-- ����ȫ��Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040108'">2020103</xsl:when><!-- �������ﴦ����Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040109'">2020103</xsl:when><!-- ����������Ա(�ֳ��ල)+++��ַ��̽��Ա -->
			<xsl:when test=".='040201'">2020103</xsl:when><!-- ��������������+++��ַ��̽��Ա -->
			<xsl:when test=".='040202'">2020103</xsl:when><!-- �ɾ�+++��ַ��̽��Ա -->
			<xsl:when test=".='040203'">2020103</xsl:when><!-- ������ҵ��Ա:�ط�����ú�󡢲�ʯ���ɿ�+++��ַ��̽��Ա -->
			<xsl:when test=".='040204'">2020103</xsl:when><!-- ��������������Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040205'">2020103</xsl:when><!-- �ɾ�+++��ַ��̽��Ա -->
			<xsl:when test=".='040206'">2020103</xsl:when><!-- ������ҵ��Ա:��������ҵú�󡢲�ʯ���ɿ�+++��ַ��̽��Ա -->
			<xsl:when test=".='040207'">2020103</xsl:when><!-- ��������������Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040208'">2020103</xsl:when><!-- �ɾ�+++��ַ��̽��Ա -->
			<xsl:when test=".='040209'">2020103</xsl:when><!-- ������ҵ��Ա:����ú�󡢲�ʯ���ɿ�+++��ַ��̽��Ա -->
			<xsl:when test=".='040210'">2020103</xsl:when><!-- ����˽Ӫú��+++��ַ��̽��Ա -->
			<xsl:when test=".='040301'">2020103</xsl:when><!-- ������ҵ��Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040401'">2020103</xsl:when><!-- ������Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040402'">2020103</xsl:when><!-- ����ʦ+++��ַ��̽��Ա -->
			<xsl:when test=".='040403'">2020103</xsl:when><!-- ����Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040404'">2020103</xsl:when><!-- ��������ౣ���޻���+++��ַ��̽��Ա -->
			<xsl:when test=".='040405'">2020103</xsl:when><!-- �꿱�豸װ�ޱ�����+++��ַ��̽��Ա -->
			<xsl:when test=".='040406'">2020103</xsl:when><!-- ���;�����+++��ַ��̽��Ա -->
			<xsl:when test=".='040407'">2020103</xsl:when><!-- ʯ�͡���Ȼ��������Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040408'">2020103</xsl:when><!-- ������̽�����￪����Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040501'">2020103</xsl:when><!-- ������Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040502'">2020103</xsl:when><!-- ����ʦ+++��ַ��̽��Ա -->
			<xsl:when test=".='040503'">2020103</xsl:when><!-- ����Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040504'">2020103</xsl:when><!-- ��������ౣ���޻���+++��ַ��̽��Ա -->
			<xsl:when test=".='040505'">2020103</xsl:when><!-- �꿱�豸װ�ޱ�����+++��ַ��̽��Ա -->
			<xsl:when test=".='040506'">2020103</xsl:when><!-- ���;�����+++��ַ��̽��Ա -->
			<xsl:when test=".='040507'">2020103</xsl:when><!-- ʯ�͡���Ȼ��������Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='040508'">2020103</xsl:when><!-- ������̽�����￪����Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='050101'">6240105</xsl:when><!-- һ�㹤����Ա(�������ʻ��)+++������Ա -->
			<xsl:when test=".='050103'">6240105</xsl:when><!-- ���⳵˾��+++������Ա -->
			<xsl:when test=".='050104'">6240105</xsl:when><!-- ��;�ͻ����䳵˾�����泵��Ա+++������Ա -->
			<xsl:when test=".='050105'">6240105</xsl:when><!-- �������ֳ���ʻԱ+++������Ա -->
			<xsl:when test=".='050106'">6240105</xsl:when><!-- ��������ũ�����ֳ���ʻ��Ա+++������Ա -->
			<xsl:when test=".='050107'">6240105</xsl:when><!-- �������ֳ���ʻԱ+++������Ա -->
			<xsl:when test=".='050108'">6240105</xsl:when><!-- ��;�ͻ����䳵˾�����泵��Ա+++������Ա -->
			<xsl:when test=".='050109'">6240105</xsl:when><!-- װж����+++������Ա -->
			<xsl:when test=".='050110'">6240105</xsl:when><!-- ɰʯ��˾�����泵��Ա+++������Ա -->
			<xsl:when test=".='050111'">6240105</xsl:when><!-- ���̿�����Ա+++������Ա -->
			<xsl:when test=".='050112'">6240105</xsl:when><!-- Һ���������͹޳���Ա+++������Ա -->
			<xsl:when test=".='050113'">6240105</xsl:when><!-- �³�����Ա+++������Ա -->
			<xsl:when test=".='050114'">6240105</xsl:when><!-- �ϵ�����ʻ��������Ա+++������Ա -->
			<xsl:when test=".='050115'">6240105</xsl:when><!-- �Ȼ�����ʻԱ+++������Ա -->
			<xsl:when test=".='050116'">6240105</xsl:when><!-- Ӫ��Ħ�г���ʻ��Ա+++������Ա -->
			<xsl:when test=".='050117'">6240105</xsl:when><!-- ��������ʻԱ+++������Ա -->
			<xsl:when test=".='050201'">6240105</xsl:when><!-- һ�㹤����Ա+++������Ա -->
			<xsl:when test=".='050202'">6240105</xsl:when><!-- ��վ��๤��+++������Ա -->
			<xsl:when test=".='050203'">6240105</xsl:when><!-- �泵��Ա(������Ա����)+++������Ա -->
			<xsl:when test=".='050204'">6240105</xsl:when><!-- ��ʻԱ+++������Ա -->
			<xsl:when test=".='050205'">6240105</xsl:when><!-- ȼ�����Ա+++������Ա -->
			<xsl:when test=".='050206'">6240105</xsl:when><!-- �����繤+++������Ա -->
			<xsl:when test=".='050207'">6240105</xsl:when><!-- ����һ�㹤����Ա+++������Ա -->
			<xsl:when test=".='050208'">6240105</xsl:when><!-- ��������+++������Ա -->
			<xsl:when test=".='050209'">6240105</xsl:when><!-- ��·��+++������Ա -->
			<xsl:when test=".='050210'">6240105</xsl:when><!-- ��·ά����+++������Ա -->
			<xsl:when test=".='050211'">6240105</xsl:when><!-- ���ڿ�����Ա+++������Ա -->
			<xsl:when test=".='050212'">6240105</xsl:when><!-- װж���˹���+++������Ա -->
			<xsl:when test=".='050213'">6240105</xsl:when><!-- ��̨������Ա+++������Ա -->
			<xsl:when test=".='050214'">6240105</xsl:when><!-- ��������ʦ+++������Ա -->
			<xsl:when test=".='050215'">6240105</xsl:when><!-- �������+++������Ա -->
			<xsl:when test=".='050301'">6240105</xsl:when><!-- ����+++������Ա -->
			<xsl:when test=".='050302'">6240105</xsl:when><!-- �ֻ���+++������Ա -->
			<xsl:when test=".='050303'">6240105</xsl:when><!-- ��+++������Ա -->
			<xsl:when test=".='050304'">6240105</xsl:when><!-- ����+++������Ա -->
			<xsl:when test=".='050305'">6240105</xsl:when><!-- ����+++������Ա -->
			<xsl:when test=".='050306'">6240105</xsl:when><!-- �����+++������Ա -->
			<xsl:when test=".='050307'">6240105</xsl:when><!-- ������+++������Ա -->
			<xsl:when test=".='050308'">6240105</xsl:when><!-- ������+++������Ա -->
			<xsl:when test=".='050309'">6240105</xsl:when><!-- ����Ա+++������Ա -->
			<xsl:when test=".='050310'">6240105</xsl:when><!-- ����+++������Ա -->
			<xsl:when test=".='050311'">6240105</xsl:when><!-- ҽ����Ա+++������Ա -->
			<xsl:when test=".='050312'">6240105</xsl:when><!-- ˮ�ֳ�+++������Ա -->
			<xsl:when test=".='050313'">6240105</xsl:when><!-- ˮ��+++������Ա -->
			<xsl:when test=".='050314'">6240105</xsl:when><!-- ������ľ�����ý�+++������Ա -->
			<xsl:when test=".='050315'">6240105</xsl:when><!-- ���ʦ+++������Ա -->
			<xsl:when test=".='050316'">6240105</xsl:when><!-- ��ʦ+++������Ա -->
			<xsl:when test=".='050317'">6240105</xsl:when><!-- ����Ա+++������Ա -->
			<xsl:when test=".='050318'">6240105</xsl:when><!-- ʵϰ��+++������Ա -->
			<xsl:when test=".='050319'">6240105</xsl:when><!-- ��������ʻ��������Ա+++������Ա -->
			<xsl:when test=".='050320'">6240105</xsl:when><!-- С��ͧ��ʻ��������Ա+++������Ա -->
			<xsl:when test=".='050321'">6240105</xsl:when><!-- ��ͷ���˼����+++������Ա -->
			<xsl:when test=".='050322'">6240105</xsl:when><!-- ���ػ�е����Ա+++������Ա -->
			<xsl:when test=".='050323'">6240105</xsl:when><!-- �ֿ������+++������Ա -->
			<xsl:when test=".='050324'">6240105</xsl:when><!-- �캽Ա+++������Ա -->
			<xsl:when test=".='050325'">6240105</xsl:when><!-- ��ˮ��+++������Ա -->
			<xsl:when test=".='050326'">6240105</xsl:when><!-- ������Ա+++������Ա -->
			<xsl:when test=".='050327'">6240105</xsl:when><!-- ������Ա+++������Ա -->
			<xsl:when test=".='050328'">6240105</xsl:when><!-- ��˽��Ա+++������Ա -->
			<xsl:when test=".='050329'">6240105</xsl:when><!-- �ϴ���ʻԱ��������Ա+++������Ա -->
			<xsl:when test=".='050330'">6240105</xsl:when><!-- ���ּ�ʻԱ��������Ա+++������Ա -->
			<xsl:when test=".='050331'">6240105</xsl:when><!-- ���Ѵ�Ա+++������Ա -->
			<xsl:when test=".='050401'">6240105</xsl:when><!-- һ�㹤����Ա+++������Ա -->
			<xsl:when test=".='050402'">6240105</xsl:when><!-- ��˽��Ա+++������Ա -->
			<xsl:when test=".='050403'">6240105</xsl:when><!-- ��๤��+++������Ա -->
			<xsl:when test=".='050404'">6240105</xsl:when><!-- �����ڽ�ͨ˾��+++������Ա -->
			<xsl:when test=".='050405'">6240105</xsl:when><!-- ���������˹�+++������Ա -->
			<xsl:when test=".='050406'">6240105</xsl:when><!-- ����ȼ��Ա+++������Ա -->
			<xsl:when test=".='050407'">6240105</xsl:when><!-- ������๤(��)���ɻ�ϴˢ��Ա(��)+++������Ա -->
			<xsl:when test=".='050408'">6240105</xsl:when><!-- �ܵ�ά����+++������Ա -->
			<xsl:when test=".='050409'">6240105</xsl:when><!-- ��еԱ+++������Ա -->
			<xsl:when test=".='050410'">6240105</xsl:when><!-- �ɻ��޻���Ա+++������Ա -->
			<xsl:when test=".='050411'">6240105</xsl:when><!-- һ�㹤����Ա+++������Ա -->
			<xsl:when test=".='050412'">6240105</xsl:when><!-- ���Ա+++������Ա -->
			<xsl:when test=".='050415'">6240105</xsl:when><!-- ֱ��������Ա+++������Ա -->
			<xsl:when test=".='050416'">6240105</xsl:when><!-- һ�㹤����Ա+++������Ա -->
			<xsl:when test=".='050417'">6240105</xsl:when><!-- Ʊ����Ա+++������Ա -->
			<xsl:when test=".='050418'">6240105</xsl:when><!-- ������̨��Ա+++������Ա -->
			<xsl:when test=".='050419'">6240105</xsl:when><!-- ���Ա+++������Ա -->
			<xsl:when test=".='050420'">6240105</xsl:when><!-- ������Ա+++������Ա -->
			<xsl:when test=".='050421'">6240105</xsl:when><!-- ������Ա+++������Ա -->
			<xsl:when test=".='050422'">6240105</xsl:when><!-- ���ʺ��߷�����Ա��������Ա+++������Ա -->
			<xsl:when test=".='050423'">6240105</xsl:when><!-- ���ں��߷�����Ա��������Ա+++������Ա -->
			<xsl:when test=".='050424'">6240105</xsl:when><!-- ����ѵ��ѧԱ+++������Ա -->
			<xsl:when test=".='060101'">4010101</xsl:when><!-- һ��������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060102'">4010101</xsl:when><!-- ����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060103'">4010101</xsl:when><!-- ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060104'">4010101</xsl:when><!-- ˾��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060201'">4010101</xsl:when><!-- һ�㹤����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060202'">4010101</xsl:when><!-- ������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060203'">4010101</xsl:when><!-- ����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060204'">4010101</xsl:when><!-- ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060301'">4010101</xsl:when><!-- һ�㹤����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060302'">4010101</xsl:when><!-- ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060303'">4010101</xsl:when><!-- ��ʦ+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060304'">4010101</xsl:when><!-- ����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060305'">4010101</xsl:when><!-- ����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='060306'">4010101</xsl:when><!-- ���׹���+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='070101'">2020906</xsl:when><!-- һ�㹤����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070102'">2020906</xsl:when><!-- ���������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070103'">2020906</xsl:when><!-- �ֳ��������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070104'">2020906</xsl:when><!-- ���+++����ʩ����Ա -->
			<xsl:when test=".='070105'">2020906</xsl:when><!-- ģ�幤+++����ʩ����Ա -->
			<xsl:when test=".='070106'">2020906</xsl:when><!-- ľ��(����)����ˮ�������ڣ�+++����ʩ����Ա -->
			<xsl:when test=".='070107'">2020906</xsl:when><!-- ��ˮ�������⼰�ߴ���+++����ʩ����Ա -->
			<xsl:when test=".='070108'">2020906</xsl:when><!-- �������̳�����е����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070109'">2020906</xsl:when><!-- �������̳�����ʻԱ+++����ʩ����Ա -->
			<xsl:when test=".='070110'">2020906</xsl:when><!-- ���Ṥ(����)+++����ʩ����Ա -->
			<xsl:when test=".='070111'">2020906</xsl:when><!-- ˮ�繤(����)+++����ʩ����Ա -->
			<xsl:when test=".='070112'">2020906</xsl:when><!-- �ֹǽṹ����+++����ʩ����Ա -->
			<xsl:when test=".='070113'">2020906</xsl:when><!-- �ּܼ��蹤��+++����ʩ����Ա -->
			<xsl:when test=".='070114'">2020906</xsl:when><!-- ����(����)+++����ʩ����Ա -->
			<xsl:when test=".='070115'">2020906</xsl:when><!-- ����(���⼰�ߴ�)+++����ʩ����Ա -->
			<xsl:when test=".='070116'">2020906</xsl:when><!-- ¥��������(������ըҩ)+++����ʩ����Ա -->
			<xsl:when test=".='070117'">2020906</xsl:when><!-- ¥��������(����ըҩ)+++����ʩ����Ա -->
			<xsl:when test=".='070118'">2020906</xsl:when><!-- ��װ����Ļǽ���ˡ���������+++����ʩ����Ա -->
			<xsl:when test=".='070119'">2020906</xsl:when><!-- ɢ��+++����ʩ����Ա -->
			<xsl:when test=".='070120'">2020906</xsl:when><!-- ����������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070121'">2020906</xsl:when><!-- ������(��������ҵ�����ֳ�)+++����ʩ����Ա -->
			<xsl:when test=".='070122'">2020906</xsl:when><!-- ������ (��������ҵż���ֳ�)+++����ʩ����Ա -->
			<xsl:when test=".='070123'">2020906</xsl:when><!-- ������(������ҵ�Ӿ�������)+++����ʩ����Ա -->
			<xsl:when test=".='070124'">2020906</xsl:when><!-- ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070125'">2020906</xsl:when><!-- ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070126'">2020906</xsl:when><!-- ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070127'">2020906</xsl:when><!-- ���ط�����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070128'">2020906</xsl:when><!-- ľ��(���⼰�ߴ�)+++����ʩ����Ա -->
			<xsl:when test=".='070129'">2020906</xsl:when><!-- ��������ϻ�����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070130'">2020906</xsl:when><!-- ĥʯ����+++����ʩ����Ա -->
			<xsl:when test=".='070131'">2020906</xsl:when><!-- ϴʯ����+++����ʩ����Ա -->
			<xsl:when test=".='070132'">2020906</xsl:when><!-- ��װ����(���⼰�ߴ�)+++����ʩ����Ա -->
			<xsl:when test=".='070133'">2020906</xsl:when><!-- װ����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070134'">2020906</xsl:when><!-- ��ˮ����ˮ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070135'">2020906</xsl:when><!-- ���Ṥ(���⼰�ߴ�)+++����ʩ����Ա -->
			<xsl:when test=".='070136'">2020906</xsl:when><!-- ˮ�繤(����)+++����ʩ����Ա -->
			<xsl:when test=".='070138'">2020906</xsl:when><!-- ��������ǽ������Ļǽά����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070139'">2020906</xsl:when><!-- �繤���ܵ����ˡ�����ϵͳ��װ��Ա+++����ʩ����Ա -->
			<xsl:when test=".='070140'">2020906</xsl:when><!-- ��������װ��Ա+++����ʩ����Ա -->
			<xsl:when test=".='070142'">2020906</xsl:when><!-- ��ҵ�����������칫�ҹ�����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070143'">2020906</xsl:when><!-- ����+++����ʩ����Ա -->
			<xsl:when test=".='070144'">2020906</xsl:when><!-- ����ʦ+++����ʩ����Ա -->
			<xsl:when test=".='070201'">2020906</xsl:when><!-- �ֳ��������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070202'">2020906</xsl:when><!-- ���̻�е����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070203'">2020906</xsl:when><!-- ���̳�����ʻԱ+++����ʩ����Ա -->
			<xsl:when test=".='070204'">2020906</xsl:when><!-- ���蹤��(ƽ��)+++����ʩ����Ա -->
			<xsl:when test=".='070205'">2020906</xsl:when><!-- ά������+++����ʩ����Ա -->
			<xsl:when test=".='070206'">2020906</xsl:when><!-- ���߼��輰ά������+++����ʩ����Ա -->
			<xsl:when test=".='070207'">2020906</xsl:when><!-- �ܵ����輰ά������+++����ʩ����Ա -->
			<xsl:when test=".='070208'">2020906</xsl:when><!-- ���蹤��(ɽ��)+++����ʩ����Ա -->
			<xsl:when test=".='070209'">2020906</xsl:when><!-- ����ʦ+++����ʩ����Ա -->
			<xsl:when test=".='070301'">2020906</xsl:when><!-- ��װ����+++����ʩ����Ա -->
			<xsl:when test=".='070302'">2020906</xsl:when><!-- ����ά������+++����ʩ����Ա -->
			<xsl:when test=".='070303'">2020906</xsl:when><!-- ����Ա(��������ʹ����)+++����ʩ����Ա -->
			<xsl:when test=".='070401'">2020906</xsl:when><!-- �����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070402'">2020906</xsl:when><!-- ����װ���Ա+++����ʩ����Ա -->
			<xsl:when test=".='070403'">2020906</xsl:when><!-- ����װ���Ա(�ߴ���ҵ)+++����ʩ����Ա -->
			<xsl:when test=".='070404'">2020906</xsl:when><!-- ��̺װ����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070405'">2020906</xsl:when><!-- �๤+++����ʩ����Ա -->
			<xsl:when test=".='070406'">2020906</xsl:when><!-- ����ʦ+++����ʩ����Ա -->
			<xsl:when test=".='070407'">2020906</xsl:when><!-- ��ࡢ�๤+++����ʩ����Ա -->
			<xsl:when test=".='070408'">2020906</xsl:when><!-- ����+++����ʩ����Ա -->
			<xsl:when test=".='070409'">2020906</xsl:when><!-- ����װ����Ա���Ǹߴ���ҵ��+++����ʩ����Ա -->
			<xsl:when test=".='070410'">2020906</xsl:when><!-- �а���+++����ʩ����Ա -->
			<xsl:when test=".='070411'">2020906</xsl:when><!-- �����Ŵ���������װ����+++����ʩ����Ա -->
			<xsl:when test=".='070501'">2020906</xsl:when><!-- ����̽��Ա(ɽ��������)+++����ʩ����Ա -->
			<xsl:when test=".='070502'">2020906</xsl:when><!-- ���ؿ���Ա+++����ʩ����Ա -->
			<xsl:when test=".='070503'">2020906</xsl:when><!-- ����ۿڹ�����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070504'">2020906</xsl:when><!-- ˮ�ӹ�����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070505'">2020906</xsl:when><!-- ����������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070506'">2020906</xsl:when><!-- ���������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070507'">2020906</xsl:when><!-- Ǳˮ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='070508'">2020906</xsl:when><!-- ���ƹ�����Ա+++����ʩ����Ա -->
			<xsl:when test=".='070509'">2020906</xsl:when><!-- ����̽��Ա(ƽ��)+++����ʩ����Ա -->
			<xsl:when test=".='070510'">2020906</xsl:when><!-- ���ബ���ˡ���ɳ����+++����ʩ����Ա -->
			<xsl:when test=".='070511'">2020906</xsl:when><!-- ����ʻ���Ա+++����ʩ����Ա -->
			<xsl:when test=".='070512'">2020906</xsl:when><!-- �ھ�������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080101'">2020906</xsl:when><!-- ��������������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080102'">2020906</xsl:when><!-- ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080103'">2020906</xsl:when><!-- ���ֹ���+++����ʩ����Ա -->
			<xsl:when test=".='080104'">2020906</xsl:when><!-- ��������+++����ʩ����Ա -->
			<xsl:when test=".='080201'">2020906</xsl:when><!-- ��������������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080202'">2020906</xsl:when><!-- ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080203'">2020906</xsl:when><!-- ���+++����ʩ����Ա -->
			<xsl:when test=".='080204'">2020906</xsl:when><!-- װ�乤+++����ʩ����Ա -->
			<xsl:when test=".='080205'">2020906</xsl:when><!-- *���ӹ������ڣ�+++����ʩ����Ա -->
			<xsl:when test=".='080206'">2020906</xsl:when><!-- ������+++����ʩ����Ա -->
			<xsl:when test=".='080207'">2020906</xsl:when><!-- ���칤+++����ʩ����Ա -->
			<xsl:when test=".='080208'">2020906</xsl:when><!-- ˮ�繤+++����ʩ����Ա -->
			<xsl:when test=".='080209'">2020906</xsl:when><!-- ��¯��+++����ʩ����Ա -->
			<xsl:when test=".='080210'">2020906</xsl:when><!-- ��ƹ�+++����ʩ����Ա -->
			<xsl:when test=".='080211'">2020906</xsl:when><!-- ϳ�������崲��+++����ʩ����Ա -->
			<xsl:when test=".='080219'">2020906</xsl:when><!-- ���ӹ������⼰�ߴ���+++����ʩ����Ա -->
			<xsl:when test=".='080212'">2020906</xsl:when><!-- ������Ʒ����ͨ�ù��չ���+++����ʩ����Ա -->
			<xsl:when test=".='080213'">2020906</xsl:when><!-- ʯ������������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080214'">2020906</xsl:when><!-- ú����������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080215'">2020906</xsl:when><!-- ��ѧ����������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080216'">2020906</xsl:when><!-- ��ҩ��ըҩ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080217'">2020906</xsl:when><!-- ���û�ѧƷ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080218'">2020906</xsl:when><!-- ����������Ʒ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='080301'">4010101</xsl:when><!-- ��������������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='080302'">4010101</xsl:when><!-- ������Ա������ʦ+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='080303'">6050611</xsl:when><!-- װ������+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080304'">6050611</xsl:when><!-- ���칤+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080305'">6050611</xsl:when><!-- ��װ��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080401'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080402'">6050611</xsl:when><!-- ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080403'">6050611</xsl:when><!-- ����������װ����Ա(�ߴ�)+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080404'">6050611</xsl:when><!-- �йظ�ѹ�繤����Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080405'">6050611</xsl:when><!-- �䶳���������ڿյ�װ��Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080501'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080502'">6050611</xsl:when><!-- ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080503'">6050611</xsl:when><!-- ����+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080504'">6050611</xsl:when><!-- �ܽ�������͹���(�Զ�)+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080505'">6050611</xsl:when><!-- �ܽ�������͸���(����)+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080506'">6050611</xsl:when><!-- ����ʦ+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080601'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080602'">6050611</xsl:when><!-- ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080603'">6050611</xsl:when><!-- ��������+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080604'">2020103</xsl:when><!-- �ɾ�+++��ַ��̽��Ա -->
			<xsl:when test=".='080605'">2020103</xsl:when><!-- ���ƹ�+++��ַ��̽��Ա -->
			<xsl:when test=".='080606'">2020103</xsl:when><!-- ����������+++��ַ��̽��Ա -->
			<xsl:when test=".='080607'">2020103</xsl:when><!-- ʯ���߹��ˡ���ҵ��+++��ַ��̽��Ա -->
			<xsl:when test=".='080608'">6050611</xsl:when><!-- �մɡ�ľ̿��ש��������+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080701'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080702'">6050611</xsl:when><!-- ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080703'">6050611</xsl:when><!-- һ�㹤��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080704'">2020103</xsl:when><!-- ���ᡢ���ᡢ�������칤+++��ַ��̽��Ա -->
			<xsl:when test=".='080705'">2020103</xsl:when><!-- ������칤��+++��ַ��̽��Ա -->
			<xsl:when test=".='080706'">2020103</xsl:when><!-- Һ���������칤��+++��ַ��̽��Ա -->
			<xsl:when test=".='080801'">2020103</xsl:when><!-- ��ҩ�������켰������Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='080802'">2020103</xsl:when><!-- ��Ʒ������Ա+++��ַ��̽��Ա -->
			<xsl:when test=".='080803'">2020103</xsl:when><!-- �׹����칤+++��ַ��̽��Ա -->
			<xsl:when test=".='080804'">2020103</xsl:when><!-- �����������졢ʵ�鹤+++��ַ��̽��Ա -->
			<xsl:when test=".='080901'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080902'">6050611</xsl:when><!-- ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080903'">6050611</xsl:when><!-- װ�칤��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080904'">6050611</xsl:when><!-- ����������+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080905'">6050611</xsl:when><!-- ���Ṥ��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='080906'">6050611</xsl:when><!-- �Գ���Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081001'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081002'">6050611</xsl:when><!-- ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081003'">6050611</xsl:when><!-- ֯�칤��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081004'">6050611</xsl:when><!-- Ⱦ������+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081005'">6050611</xsl:when><!-- ���ޡ�ѹ�ߡ��⹤���ε湤��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081006'">6050611</xsl:when><!-- ������ëռ�����ϡ���е����+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081007'">6050611</xsl:when><!-- �����ڳ������ж������﹤��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081101'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081102'">6050611</xsl:when><!-- ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081103'">6050611</xsl:when><!-- ��ֽ������+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081104'">6050611</xsl:when><!-- ֽ��������+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081105'">6050611</xsl:when><!-- ֽ�����칤��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081201'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081202'">6050611</xsl:when><!-- ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081203'">6050611</xsl:when><!-- ľ�ƼҾ�װ��������+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081204'">6050611</xsl:when><!-- �����Ҿ�װ��������+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081301'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081302'">6050611</xsl:when><!-- ��ľ���ֹ���Ʒ�ӹ�����+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081303'">6050611</xsl:when><!-- �����ֹ���Ʒ�ӹ�����+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081304'">6050611</xsl:when><!-- ����ֽƷ����Ʒ�ӹ�����+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081305'">6050611</xsl:when><!-- ��ʯ�ֹ���Ʒ�ӹ���Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081306'">6050611</xsl:when><!-- �����ֹ���Ʒ�ӹ���Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081307'">6050611</xsl:when><!-- �մ������ӹ���Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081308'">6050611</xsl:when><!-- ���������ӹ���Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081401'">6050611</xsl:when><!-- ��������������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081402'">6050611</xsl:when><!-- ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081403'">6050611</xsl:when><!-- ����+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081404'">6050611</xsl:when><!-- �����ж��к�����ҵ��Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081405'">6050611</xsl:when><!-- ����ϴ�ྫ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081406'">6050611</xsl:when><!-- �̲�ҵ������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081501'">6050611</xsl:when><!-- ��ʦ+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081502'">6050611</xsl:when><!-- ����+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081601'">6050611</xsl:when><!-- �������칤+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081602'">6050611</xsl:when><!-- ��ʦ+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081603'">6050611</xsl:when><!-- ���׳�������Ա+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081604'">6050611</xsl:when><!-- �������칤��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081605'">6050611</xsl:when><!-- װ�޹���+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='081606'">6050611</xsl:when><!-- ���칤��+++�ӹ����졢���鼰������Ա -->
			<xsl:when test=".='090101'">2100106</xsl:when><!-- һ�㹤����Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090102'">2100106</xsl:when><!-- ���ڼ���+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090103'">2100106</xsl:when><!-- ��Ӱ����+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090104'">2100106</xsl:when><!-- ӡˢ������+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090105'">2100106</xsl:when><!-- �ͱ�Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090106'">2100106</xsl:when><!-- ս�ؼ���+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090201'">2100106</xsl:when><!-- һ�㹤����Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090202'">2100106</xsl:when><!-- �༭��Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090203'">2100106</xsl:when><!-- ��Ӱ����+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090204'">2100106</xsl:when><!-- �ͻ�Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090301'">2100106</xsl:when><!-- һ�㹤����Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090302'">2100106</xsl:when><!-- ����ҵ����Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090303'">2100106</xsl:when><!-- ���ӰƬ֮����¼����Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090304'">2100106</xsl:when><!-- ������Ƽ��衢��װ��Ա(����)+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090305'">2100106</xsl:when><!-- �������������(����)+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090306'">2100106</xsl:when><!-- ��������ͼ�������Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='090307'">2100106</xsl:when><!-- ��װ��ܼ�����ά����Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='100101'">2050101</xsl:when><!-- һ��ҽ��������Ա+++����רҵ������Ա -->
			<xsl:when test=".='100102'">2050101</xsl:when><!-- һ��ҽʦ����ʿ+++����רҵ������Ա -->
			<xsl:when test=".='100103'">2050101</xsl:when><!-- ���񲡿�ҽʦ����������ʿ+++����רҵ������Ա -->
			<xsl:when test=".='100104'">2050101</xsl:when><!-- ������Ա+++����רҵ������Ա -->
			<xsl:when test=".='100105'">2050101</xsl:when><!-- �����߼�����Ա+++����רҵ������Ա -->
			<xsl:when test=".='100106'">2050101</xsl:when><!-- �������޻���Ա+++����רҵ������Ա -->
			<xsl:when test=".='100107'">2050101</xsl:when><!-- ҽԺ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='100108'">2050101</xsl:when><!-- �ӹ�+++����רҵ������Ա -->
			<xsl:when test=".='100109'">2050101</xsl:when><!-- ��๤+++����רҵ������Ա -->
			<xsl:when test=".='100110'">2050101</xsl:when><!-- ������������ҽ��+++����רҵ������Ա -->
			<xsl:when test=".='100111'">2050101</xsl:when><!-- ����ʿ+++����רҵ������Ա -->
			<xsl:when test=".='100112'">2050101</xsl:when><!-- ��������������Ա+++����רҵ������Ա -->
			<xsl:when test=".='100201'">2050101</xsl:when><!-- һ��ҽ��������Ա+++����רҵ������Ա -->
			<xsl:when test=".='100202'">2050101</xsl:when><!-- һ��ҽʦ����ʿ+++����רҵ������Ա -->
			<xsl:when test=".='100203'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='100204'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='110101'">2100106</xsl:when><!-- ������Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110102'">2100106</xsl:when><!-- ��Ƭ��+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110103'">2100106</xsl:when><!-- ���+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110104'">2100106</xsl:when><!-- һ����Ա(������)+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110105'">2100106</xsl:when><!-- �赸������Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110106'">2100106</xsl:when><!-- Ѳ���ݳ�����������Ա(�Ӽ�����)+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110107'">2100106</xsl:when><!-- һ���Ӽ���Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110108'">2100106</xsl:when><!-- ���Ѷȶ����Ӽ���Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110109'">2100106</xsl:when><!-- �����Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110110'">2100106</xsl:when><!-- �ؼ���Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110111'">2100106</xsl:when><!-- ������ҵ��Ա(�滭�����ࡢ������)+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110112'">2100106</xsl:when><!-- ѱ��ʦ�����з��ˡ��߸�˿+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110113'">2100106</xsl:when><!-- ����Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110114'">2100106</xsl:when><!-- ��ױʦ+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110115'">2100106</xsl:when><!-- ����+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110116'">2100106</xsl:when><!-- ��Ӱ������Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110117'">2100106</xsl:when><!-- �ƹ⼰����Ч��������Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110118'">2100106</xsl:when><!-- ��ϴƬ������Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110119'">2100106</xsl:when><!-- ���Ӽ���+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110120'">2100106</xsl:when><!-- ��е�����繤+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110121'">2100106</xsl:when><!-- ����������Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110122'">2100106</xsl:when><!-- ��ӰԺ��ƱԱ+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110123'">2100106</xsl:when><!-- ��ӰԺ��ӳ��Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110124'">2100106</xsl:when><!-- ��ӰԺ������Ա+++���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='110201'">4010101</xsl:when><!-- ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110202'">4010101</xsl:when><!-- �򳡱�������+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110203'">4010101</xsl:when><!-- ά������+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110204'">4010101</xsl:when><!-- �򳡷���Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110301'">4010101</xsl:when><!-- ��ݷ���+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110302'">4010101</xsl:when><!-- ��е�޻�Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110303'">4010101</xsl:when><!-- ��๤��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110304'">4010101</xsl:when><!-- ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110305'">4010101</xsl:when><!-- ��Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110401'">4010101</xsl:when><!-- ������+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110402'">4010101</xsl:when><!-- �Ƿ�Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110501'">4010101</xsl:when><!-- ������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110502'">4010101</xsl:when><!-- ����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110503'">4010101</xsl:when><!-- ��Ӿ�ؾ���Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110504'">4010101</xsl:when><!-- ��ˮԡ������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110601'">4010101</xsl:when><!-- ������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110602'">4010101</xsl:when><!-- ��ƱԱ+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110603'">4010101</xsl:when><!-- �綯��߲���Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110604'">4010101</xsl:when><!-- һ����๤+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110605'">4010101</xsl:when><!-- ������๤+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110606'">4010101</xsl:when><!-- ˮ���е��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110607'">4010101</xsl:when><!-- ����԰ѱ��ʦ+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110608'">4010101</xsl:when><!-- ������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110701'">4010101</xsl:when><!-- ������������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110702'">4010101</xsl:when><!-- ���ҹ�����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110703'">4010101</xsl:when><!-- �Ƽҹ�����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110704'">4010101</xsl:when><!-- ����������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110705'">4010101</xsl:when><!-- ����������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110706'">4010101</xsl:when><!-- ҹ�ܻṤ����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='110707'">4010101</xsl:when><!-- �ưɡ����ɹ�����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='120101'">2090104</xsl:when><!-- ��ʦ+++��ѧ��Ա -->
			<xsl:when test=".='120102'">2090104</xsl:when><!-- ѧ��+++��ѧ��Ա -->
			<xsl:when test=".='120103'">2090104</xsl:when><!-- У��+++��ѧ��Ա -->
			<xsl:when test=".='120104'">2090104</xsl:when><!-- ������ʦ+++��ѧ��Ա -->
			<xsl:when test=".='120105'">2090104</xsl:when><!-- ��ѵ�̹�+++��ѧ��Ա -->
			<xsl:when test=".='120106'">2090104</xsl:when><!-- �����˶�����+++��ѧ��Ա -->
			<xsl:when test=".='120107'">2090104</xsl:when><!-- ������ʻѵ������+++��ѧ��Ա -->
			<xsl:when test=".='120201'">2090104</xsl:when><!-- ά�޹�+++��ѧ��Ա -->
			<xsl:when test=".='120202'">2090104</xsl:when><!-- һ�㹤����Ա+++��ѧ��Ա -->
			<xsl:when test=".='120203'">2090104</xsl:when><!-- �ۻ�Ա+++��ѧ��Ա -->
			<xsl:when test=".='120204'">2090104</xsl:when><!-- ������Ա+++��ѧ��Ա -->
			<xsl:when test=".='120205'">2090104</xsl:when><!-- ����ݹ�����Ա+++��ѧ��Ա -->
			<xsl:when test=".='120206'">2090104</xsl:when><!-- ͼ��ݹ�����Ա+++��ѧ��Ա -->
			<xsl:when test=".='130101'">2090104</xsl:when><!-- �������ù�����Ա+++��ѧ��Ա -->
			<xsl:when test=".='130102'">2090104</xsl:when><!-- �ڽ����幤����Ա+++��ѧ��Ա -->
			<xsl:when test=".='130103'">2090104</xsl:when><!-- ɮ�ᡢ��ʿ��������Ա+++��ѧ��Ա -->
			<xsl:when test=".='140101'">3030101</xsl:when><!-- ������Ա+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140102'">3030101</xsl:when><!-- ��Ħ�г��ʵ���Ա+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140103'">3030101</xsl:when><!-- �ʵ���Ա+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140104'">3030101</xsl:when><!-- �������˹�+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140201'">3030101</xsl:when><!-- ������Ա+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140202'">3030101</xsl:when><!-- ����Ա���շ�Ա+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140203'">3030101</xsl:when><!-- ���ŵ���װ��ά������+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140204'">3030101</xsl:when><!-- ���ŵ���������ʩ֮������Ա+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140205'">3030101</xsl:when><!-- ���Ÿ�ѹ�繤����ʩ��Ա+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140206'">3030101</xsl:when><!-- ���ܷ��糧������Ա+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140207'">3030101</xsl:when><!-- ��̨����ά����Ա+++�����͵���ҵ����Ա -->
			<xsl:when test=".='140301'">5010107</xsl:when><!-- һ�㹤����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140302'">5010107</xsl:when><!-- ����Ա�� �շ�Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140303'">5010107</xsl:when><!-- ˮ�ӡ�ˮ�������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140304'">5010107</xsl:when><!-- ˮ��������ʩ��Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140305'">5010107</xsl:when><!-- ����ˮ��װ����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140306'">5010107</xsl:when><!-- ˮ��������ҵ��Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140307'">5010107</xsl:when><!-- ˮ�Ŀ�����ҵ��Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140308'">5010107</xsl:when><!-- ˮ�ʷ���Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140309'">5010107</xsl:when><!-- ����ˮ����ʩ�ܻ���Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140310'">5010107</xsl:when><!-- ����ˮ����Դ������Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140401'">5010107</xsl:when><!-- һ�㹤����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140402'">5010107</xsl:when><!-- �շ�Ա������Ա�����Ա+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140403'">5010107</xsl:when><!-- ����װ�޹�+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140404'">5010107</xsl:when><!-- ú���������칤+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140405'">5010107</xsl:when><!-- ������+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140406'">5010107</xsl:when><!-- ú����װ��+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='140407'">5010107</xsl:when><!-- Һ�������泵˾��������+++ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='150101'">4010101</xsl:when><!-- һ�㹤����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150102'">4010101</xsl:when><!-- �ۻ�Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150103'">4010101</xsl:when><!-- �ֿⱣ��Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150104'">4010101</xsl:when><!-- ȼ�ϲֿⱣ��Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150105'">4010101</xsl:when><!-- ���˹�+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150106'">4010101</xsl:when><!-- ˾��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150201'">4010101</xsl:when><!-- һ�㹤����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150202'">4010101</xsl:when><!-- �ۻ�Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150203'">4010101</xsl:when><!-- �鱦����Ʒ�ۻ�Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150204'">4010101</xsl:when><!-- ����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150205'">4010101</xsl:when><!-- �ɹ�������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150206'">4010101</xsl:when><!-- ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150207'">4010101</xsl:when><!-- ˾��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150208'">4010101</xsl:when><!-- ���ߡ��մɡ��Ŷ���������+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150209'">4010101</xsl:when><!-- ��¥�����̡��ӻ���ʳƷ��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150210'">4010101</xsl:when><!-- �Ҿߡ��������۾����ľ���+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150211'">4010101</xsl:when><!-- ��ƥ�����Ρ�ҩƷ��������+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150212'">4010101</xsl:when><!-- ������ʯ�ġ����ġ��ֲ���+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150213'">4010101</xsl:when><!-- ľ�ġ���𡢵�����������+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150214'">4010101</xsl:when><!-- ���㡢ҽ���������鱦��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150215'">4010101</xsl:when><!-- ��ѧԭ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150216'">4010101</xsl:when><!-- Һ����˹������+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150217'">4010101</xsl:when><!-- ��˹��װ��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='150218'">4010101</xsl:when><!-- �ɻ��չ���Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='160101'">2070109</xsl:when><!-- ������Ա+++����ҵ����Ա -->
			<xsl:when test=".='160102'">2070109</xsl:when><!-- ������Ա+++����ҵ����Ա -->
			<xsl:when test=".='160103'">2070109</xsl:when><!-- ������������Ա+++����ҵ����Ա -->
			<xsl:when test=".='160104'">2070109</xsl:when><!-- Ӫҵ�㹤����Ա+++����ҵ����Ա -->
			<xsl:when test=".='160105'">2070109</xsl:when><!-- �˳�Ѻ����Ա(��˾��)+++����ҵ����Ա -->
			<xsl:when test=".='170101'">2080103</xsl:when><!-- ��ʦ+++����רҵ��Ա -->
			<xsl:when test=".='170102'">2080103</xsl:when><!-- ���ʦ+++����רҵ��Ա -->
			<xsl:when test=".='170103'">2080103</xsl:when><!-- ����+++����רҵ��Ա -->
			<xsl:when test=".='170104'">2080103</xsl:when><!-- ������+++����רҵ��Ա -->
			<xsl:when test=".='170201'">4010101</xsl:when><!-- ��ʦ+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170202'">4010101</xsl:when><!-- ����ʦ���������ʦ+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170203'">4010101</xsl:when><!-- ԡ��(�������յ�)+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170204'">4010101</xsl:when><!-- ��ҵ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170205'">4010101</xsl:when><!-- ���ֹ�+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170206'">4010101</xsl:when><!-- ϴ�µ깤��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170207'">4010101</xsl:when><!-- ��¥����Ա���г�����Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170208'">4010101</xsl:when><!-- ��Ӱʦ+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170209'">4010101</xsl:when><!-- ��װ�ӹ�����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170210'">4010101</xsl:when><!-- ������Ա(��Ѳ��Ѻ��������)+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170211'">4010101</xsl:when><!-- ������Ա(����)+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170212'">4010101</xsl:when><!-- ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170213'">4010101</xsl:when><!-- �ʵ���Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170214'">4010101</xsl:when><!-- ��֤������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170215'">4010101</xsl:when><!-- ����������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170216'">4010101</xsl:when><!-- ��ӡʦ+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170217'">4010101</xsl:when><!-- �÷�+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170218'">4010101</xsl:when><!-- һ�����������Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170219'">4010101</xsl:when><!-- ����Ա������Ա���Ӵ�Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170220'">4010101</xsl:when><!-- ��Ħ��Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='170301'">2020906</xsl:when><!-- ��·��๤+++����ʩ����Ա -->
			<xsl:when test=".='170302'">2020906</xsl:when><!-- ��ˮ����๤+++����ʩ����Ա -->
			<xsl:when test=".='170303'">2020906</xsl:when><!-- ��¥�ⲿ��๤+++����ʩ����Ա -->
			<xsl:when test=".='170304'">2020906</xsl:when><!-- �泵��ϴ����+++����ʩ����Ա -->
			<xsl:when test=".='170305'">2020906</xsl:when><!-- װ�޹�+++����ʩ����Ա -->
			<xsl:when test=".='170306'">2020906</xsl:when><!-- ���Ṥ+++����ʩ����Ա -->
			<xsl:when test=".='170307'">2020906</xsl:when><!-- �̴���๤+++����ʩ����Ա -->
			<xsl:when test=".='170308'">2020906</xsl:when><!-- ����վ������Ա+++����ʩ����Ա -->
			<xsl:when test=".='170401'">3030101</xsl:when><!-- ά������ʦ+++�����͵���ҵ����Ա -->
			<xsl:when test=".='170402'">3030101</xsl:when><!-- ϵͳ����ʦ+++�����͵���ҵ����Ա -->
			<xsl:when test=".='170403'">3030101</xsl:when><!-- ���۹���ʦ+++�����͵���ҵ����Ա -->
			<xsl:when test=".='180101'">8010104</xsl:when><!-- ��ͥ����(��ҵ)+++��ͥ���� -->
			<xsl:when test=".='180102'">4010101</xsl:when><!-- Ӷ��+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='180103'">4010101</xsl:when><!-- ��ͥ����+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='190101'">7010103</xsl:when><!-- ����������������Ա+++���� -->
			<xsl:when test=".='190102'">7010103</xsl:when><!-- ����(��Ѳ��������)+++���� -->
			<xsl:when test=".='190103'">7010103</xsl:when><!-- ����������������Ա+++���� -->
			<xsl:when test=".='190104'">7010103</xsl:when><!-- ��ͨ����+++���� -->
			<xsl:when test=".='190105'">7010103</xsl:when><!-- �̾�+++���� -->
			<xsl:when test=".='190106'">7010103</xsl:when><!-- �����Ӷ�Ա+++���� -->
			<xsl:when test=".='190107'">7010103</xsl:when><!-- ������Ա+++���� -->
			<xsl:when test=".='190108'">7010103</xsl:when><!-- �ΰ���Ա+++���� -->
			<xsl:when test=".='190109'">7010103</xsl:when><!-- ���ܡ��߼�������Ա+++���� -->
			<xsl:when test=".='190110'">7010103</xsl:when><!-- �칫�ҹ�����Ա+++���� -->
			<xsl:when test=".='190111'">7010103</xsl:when><!-- ըҩ������+++���� -->
			<xsl:when test=".='190112'">7010103</xsl:when><!-- �ΰ�����+++���� -->
			<xsl:when test=".='190113'">7010103</xsl:when><!-- ��������+++���� -->
			<xsl:when test=".='190114'">7010103</xsl:when><!-- ��Уѧ��+++���� -->
			<xsl:when test=".='200101'">2050101</xsl:when><!-- ������Ա��������Ա+++����רҵ������Ա -->
			<xsl:when test=".='200102'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200103'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200104'">2050101</xsl:when><!-- �������˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200105'">2050101</xsl:when><!-- �����������˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200106'">2050101</xsl:when><!-- ���������˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200107'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200108'">2050101</xsl:when><!-- ��ë���˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200109'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200110'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200111'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200112'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200113'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200114'">2050101</xsl:when><!-- �ɹ����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200115'">2050101</xsl:when><!-- ������˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200116'">2050101</xsl:when><!-- �߶������˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200117'">2050101</xsl:when><!-- �������˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200201'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200202'">2050101</xsl:when><!-- �˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200301'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200302'">2050101</xsl:when><!-- �˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200401'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200402'">2050101</xsl:when><!-- ��Ӿ�˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200403'">2050101</xsl:when><!-- ��ˮ�˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200501'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200502'">2050101</xsl:when><!-- �˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200503'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200504'">2050101</xsl:when><!-- �˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200505'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200506'">2050101</xsl:when><!-- �˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200507'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200508'">2050101</xsl:when><!-- �˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200601'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200602'">2050101</xsl:when><!-- �˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200701'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200702'">2050101</xsl:when><!-- �˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200801'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200802'">2050101</xsl:when><!-- ���г��˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200803'">2050101</xsl:when><!-- ����������+++����רҵ������Ա -->
			<xsl:when test=".='200804'">2050101</xsl:when><!-- Ħ�г�������+++����רҵ������Ա -->
			<xsl:when test=".='200901'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='200902'">2050101</xsl:when><!-- �����������˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200903'">2050101</xsl:when><!-- ��ͧ�����˰��˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200904'">2050101</xsl:when><!-- ˮ��Ħ��ͧ�˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200905'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='200906'">2050101</xsl:when><!-- Ǳˮ�˶�Ա��0��50��+++����רҵ������Ա -->
			<xsl:when test=".='200907'">2050101</xsl:when><!-- Ǳˮ�˶�Ա��50����+++����רҵ������Ա -->
			<xsl:when test=".='200908'">2050101</xsl:when><!-- Ǳˮ����+++����רҵ������Ա -->
			<xsl:when test=".='201001'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='201002'">2050101</xsl:when><!-- �����˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='201003'">2050101</xsl:when><!-- ��ѩ�˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='201101'">2050101</xsl:when><!-- ����Ա+++����רҵ������Ա -->
			<xsl:when test=".='201102'">2050101</xsl:when><!-- �˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='201201'">2050101</xsl:when><!-- ����+++����רҵ������Ա -->
			<xsl:when test=".='201202'">2050101</xsl:when><!-- �����ˡ��������ʦ+++����רҵ������Ա -->
			<xsl:when test=".='201203'">2050101</xsl:when><!-- ��ʦ����ϰ��ʦ��������ʦ+++����רҵ������Ա -->
			<xsl:when test=".='201301'">2050101</xsl:when><!-- �ؼ�������Ա+++����רҵ������Ա -->
			<xsl:when test=".='201401'">2050101</xsl:when><!-- ����+++����רҵ������Ա -->
			<xsl:when test=".='201402'">2050101</xsl:when><!-- ��ʻ��Ա+++����רҵ������Ա -->
			<xsl:when test=".='201501'">2050101</xsl:when><!-- ����+++����רҵ������Ա -->
			<xsl:when test=".='201502'">2050101</xsl:when><!-- ��ɡ��Ա+++����רҵ������Ա -->
			<xsl:when test=".='201601'">2050101</xsl:when><!-- ��ɽ�˶�Ա+++����רҵ������Ա -->
			<xsl:when test=".='201602'">2050101</xsl:when><!-- ����+++����רҵ������Ա -->
			<xsl:when test=".='201701'">2050101</xsl:when><!-- ������Ա+++����רҵ������Ա -->
			<xsl:when test=".='201702'">2050101</xsl:when><!-- ����+++����רҵ������Ա -->
			<xsl:when test=".='210101'">2080103</xsl:when><!-- �����졢�������̡�˰������+++����רҵ��Ա -->
			<xsl:when test=".='210201'">4030111</xsl:when><!-- ����+++���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
			<xsl:when test=".='210202'">4030111</xsl:when><!-- ����+++���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
			<xsl:when test=".='210302'">4010101</xsl:when><!-- �޹̶�ְҵ��Ա+++��ҵ������ҵ��Ա -->
			<xsl:when test=".='210401'">8010101</xsl:when><!-- ѧ��ǰ��ͯ+++��ҵ -->
			<xsl:when test=".='210402'">8010101</xsl:when><!-- ��������Ա(�޼�ְ)+++��ҵ -->
			<xsl:when test=".='210403'">8010101</xsl:when><!-- ������Ա(�޼�ְ)+++��ҵ -->
			<xsl:when test=".='210501'">7010103</xsl:when><!-- һ����ˡ���Уѧ�����Ǿ���רҵ��+++���� -->
			<xsl:when test=".='210502'">7010103</xsl:when><!-- ������������Ա+++���� -->
			<xsl:when test=".='210503'">7010103</xsl:when><!-- ���ڲ�����ͨѶ��������Ա+++���� -->
			<xsl:when test=".='210504'">7010103</xsl:when><!-- ��ҽԺ�ٱ�+++���� -->
			<xsl:when test=".='210505'">7010103</xsl:when><!-- �����о���λ�����Ա+++���� -->
			<xsl:when test=".='210506'">7010103</xsl:when><!-- ���µ�λ������ҩ�о���������Ա+++���� -->
			<xsl:when test=".='210507'">7010103</xsl:when><!-- ɡ������+++���� -->
			<xsl:when test=".='210508'">7010103</xsl:when><!-- �����Է���Ա+++���� -->
			<xsl:when test=".='210509'">7010103</xsl:when><!-- һ����沿����Ա+++���� -->
			<xsl:when test=".='210510'">7010103</xsl:when><!-- ���ֱ�+++���� -->
			<xsl:when test=".='210511'">7010103</xsl:when><!-- �վ���������Ǳͧ����+++���� -->
			<xsl:when test=".='210512'">7010103</xsl:when><!-- ��Уѧ��������רҵ�����±�+++���� -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
