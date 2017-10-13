<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/Head" />
			<Body>
				<xsl:apply-templates select="TXLife/Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!--����ͷ��Ϣ-->
	<xsl:template name="pocket" match="Head">
		<Head>
			<TranDate>
				<xsl:value-of select="MsgSendDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="MsgSendTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OperTellerNo" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransSerialCode" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<xsl:copy-of select="FuncFlag" />
			<xsl:copy-of select="ClientIp" />
			<xsl:copy-of select="TranCom" />
			<BankCode>
				<xsl:value-of select="TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<!--��������Ϣ-->
	<xsl:template name="Body" match="Body">

		<!-- ������Ϣ  -->
		<xsl:apply-templates select="PolicyInfo" />

		<!-- ������֪(N/Y)  -->
		<HealthNotice>
			<xsl:choose>
				<xsl:when test="(PolicyInfo/HealthInf = 'Y') or (HasNotification = 'Y')">Y</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</HealthNotice>
		<!-- δ�������ۼ���ʷ��ձ��� -->
		<xsl:variable name="InsuredTotalFaceAmount"><xsl:value-of select="//InsuredInFo/DeadInfo*0.01"/></xsl:variable>
		<PolicyIndicator>
			<xsl:choose>
			    <xsl:when test="$InsuredTotalFaceAmount>0">Y</xsl:when>
			    <xsl:otherwise>N</xsl:otherwise>
		    </xsl:choose>
		</PolicyIndicator>
		<InsuredTotalFaceAmount><xsl:value-of select="$InsuredTotalFaceAmount" /></InsuredTotalFaceAmount>
		<!-- ��ϲ�Ʒ -->
		<ContPlan>
			<ContPlanCode>
				<xsl:call-template name="tran_contPlancode">
					<xsl:with-param name="contPlancode">
						<xsl:value-of select="//PCInfo[BelongMajor=PCCode]/PCCode"/>
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			<ContPlanMult><xsl:value-of select="//PCInfo[BelongMajor=PCCode]/PCNumber" /></ContPlanMult>
		</ContPlan>

		<!-- Ͷ������Ϣ  -->
		<xsl:apply-templates select="PolicyHolder" />

		<!-- ��������Ϣ  -->
		<xsl:apply-templates select="InsuredList/InsuredInFo" />

		<!-- ��������Ϣ -->
		<xsl:apply-templates select="BeneficiaryList/BeneficiaryInfo" />

		<!-- ������Ϣ -->
		<xsl:apply-templates select="//PCInfo" />
	</xsl:template>

	<!--����ͷ��Ϣ-->
	<xsl:template name="PolicyInfo" match="PolicyInfo">
		<!-- Ͷ����(ӡˢ)�� -->
		<ProposalPrtNo>
			<xsl:value-of select="PolHNo" />
		</ProposalPrtNo>
		<!-- ������ͬӡˢ�� -->
		<ContPrtNo>
			<xsl:value-of select="PolPrintCode" />
		</ContPrtNo>
		
		<!-- ����Ա���� -->
		<SellerNo><xsl:value-of select="AgentCode" /></SellerNo>
		<!-- ����Ա������ -->
		<!--<TellerName><xsl:value-of select="java:com.sinosoft.midplat.lnrcclife.format.Trans_lnrcclife.BankToTellerName(PolHPrintCode)" /></TellerName> -->
		<TellerName><xsl:value-of select="PolHPrintCode" /></TellerName>
		<!-- �������� -->
		<AgentComName><xsl:value-of select="PolAddr" /></AgentComName>
		<!-- ��ҵ�ʸ�֤�� -->
		<!-- <TellerCertiCode><xsl:value-of select="java:com.sinosoft.midplat.lnrcclife.format.Trans_lnrcclife.BankToTellerCertiCode(PolHPrintCode)" /></TellerCertiCode> -->
		<TellerCertiCode></TellerCertiCode>
		<!-- Ͷ������ -->
		<PolApplyDate>
			<xsl:value-of select="InsureDate" />
		</PolApplyDate>
		<!-- �˻����� -->
		<AccName>
			<xsl:value-of select="AccName" />
		</AccName>
		<!-- �����˻� -->
		<AccNo>
			<xsl:value-of select="AccNo" />
		</AccNo>
		<!-- �������ͷ�ʽ -->
		<GetPolMode />
		<!-- ְҵ��֪(N/Y) -->
		<JobNotice />
	</xsl:template>

	<!-- Ͷ���� -->
	<xsl:template name="Appnt" match="PolicyHolder">
		<Appnt>
			<xsl:apply-templates select="CustomsGeneralInfo" />

			<!-- �뱻���˹�ϵ -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation_to_app">
					<xsl:with-param name="relation">
						<xsl:value-of
							select="../InsuredList/InsuredInFo/IsdToPolH" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
		</Appnt>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Insu" match="InsuredList/InsuredInFo">
		<Insured>
			<xsl:apply-templates select="CustomsGeneralInfo" />
		</Insured>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Bnf" match="BeneficiaryList/BeneficiaryInfo">
		<Bnf>
			<!-- Ĭ��Ϊ��1-��������ˡ� -->
			<Type>1</Type>
			<!-- ����˳�� -->
			<Grade>
				<xsl:value-of select="BFSequence" />
			</Grade>
			<!-- ��������Ϣ -->
			<xsl:apply-templates select="CustomsGeneralInfo" />
			<!-- �뱻���˹�ϵ -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation">
						<xsl:value-of select="BFToIsd" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
			<!-- �������(�������ٷֱ�) -->
			<Lot>
				<xsl:value-of select="BFLot" />
			</Lot>
		</Bnf>
	</xsl:template>

	<!-- ������Ϣ  -->
	<xsl:template name="Risk" match="PCInfo">
		<Risk>
			<!-- ���ִ��� -->
			<RiskCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PCCode" />
				</xsl:call-template>
			</RiskCode>
			<!-- �������ִ��� -->
			<MainRiskCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="BelongMajor" />
				</xsl:call-template>
			</MainRiskCode>
			<!-- ����(��) -->
			<Amnt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)" />
			</Amnt>
			<!-- ���շ�(��) -->
			<Prem>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Premium)" />
			</Prem>
			<!-- Ͷ������ -->
			<Mult>
				<xsl:value-of select="PCNumber" />
			</Mult>
			<!-- �ɷ�Ƶ�� -->
			<PayIntv>
				<xsl:call-template name="tran_PayIntv">
					<xsl:with-param name="payintv">
						<xsl:value-of select="PayPeriodType" />
					</xsl:with-param>
				</xsl:call-template>
			</PayIntv>
			<!-- �ɷ���ʽ -->
			<PayMode></PayMode>
			<!-- �������������־ -->
			<InsuYearFlag>
				<xsl:call-template name="tran_InsuYearFlag">
					<xsl:with-param name="insuyearflag">
						<xsl:value-of select="CovPeriodType" />
					</xsl:with-param>
				</xsl:call-template>
			</InsuYearFlag>
			<!-- ������������ -->
			<InsuYear>
				<xsl:if test="CovPeriodType=1">106</xsl:if><!-- ������ -->
				<xsl:if test="CovPeriodType!=1">
					<xsl:value-of select="InsuYear" />
				</xsl:if>
			</InsuYear>
			<xsl:if test="PayPeriodType = 4"><!-- ���� -->
				<!-- �ɷ����������־ -->
				<PayEndYearFlag>Y</PayEndYearFlag>
				<PayEndYear>1000</PayEndYear>
			</xsl:if>
			<xsl:if test="PayPeriodType != 4">
				<!-- �ɷ����������־ -->
				<PayEndYearFlag>
					<xsl:call-template name="tran_PayEndYearFlag">
						<xsl:with-param name="payendyearflag">
							<xsl:value-of select="PayTermType" />
						</xsl:with-param>
					</xsl:call-template>
				</PayEndYearFlag>
				<!-- �ɷ��������� -->
				<PayEndYear>
					<xsl:value-of select="PayYear" />
				</PayEndYear>
			</xsl:if>

			<BonusGetMode>
				<xsl:call-template name="tran_BonusGetMode">
					<xsl:with-param name="bonusgetmode"
						select="BonusPayMode" />
				</xsl:call-template>
			</BonusGetMode><!-- ������ȡ��ʽ -->
			<FullBonusGetMode></FullBonusGetMode><!-- ������ȡ����ȡ��ʽ -->
			<GetYearFlag></GetYearFlag><!-- ��ȡ�������ڱ�־ -->
			<GetYear>
				<xsl:value-of select="FullBonusPeriod" />
			</GetYear><!-- ��ȡ���� -->
			<GetIntv /><!-- ��ȡ��ʽ -->
			<GetBankCode></GetBankCode><!-- ��ȡ���б��� -->
			<GetBankAccNo></GetBankAccNo><!-- ��ȡ�����˻� -->
			<GetAccName></GetAccName><!-- ��ȡ���л��� -->
			<AutoPayFlag>
				<xsl:value-of select="AutoPayFlag" />
			</AutoPayFlag><!-- �Զ��潻��־ -->
		</Risk>
	</xsl:template>

	<!--�ͻ���Ϣ-->
	<xsl:template name="CustomsGeneralInfo"
		match="CustomsGeneralInfo">
		<!-- ���� -->
		<Name>
			<xsl:value-of select="CusName" />
		</Name>
		<!-- �Ա� -->
		<Sex>
			<xsl:call-template name="tran_sex">
				<xsl:with-param name="sex">
					<xsl:value-of select="CusGender" />
				</xsl:with-param>
			</xsl:call-template>
		</Sex>
		<!-- ��������(yyyyMMdd) -->
		<Birthday>
			<xsl:value-of select="CusBirthDay" />
		</Birthday>
		<!-- ֤������ -->
		<IDType>
			<xsl:call-template name="tran_idtype">
				<xsl:with-param name="idtype">
					<xsl:value-of select="CusCerType" />
				</xsl:with-param>
			</xsl:call-template>
		</IDType>
		<!-- ֤������ -->
		<IDNo>
			<xsl:value-of select="CusCerNo" />
		</IDNo>
		<!-- ֤����Ч���� -->
		<IDTypeStartDate>
			<xsl:value-of select="CusCerStartDate" />
		</IDTypeStartDate>
		<!-- ֤����Чֹ�� -->
		<IDTypeEndDate>
			<xsl:value-of select="CusCerEndDate" />
		</IDTypeEndDate>
		<!-- ְҵ���� -->
		<JobCode>
			<xsl:value-of select="CusJobCode" />
		</JobCode>
		<!-- ������ -->
		<Salary></Salary>
		<!-- <Salary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(CusAnnualIncome)" /></Salary>-->
		<!-- ��ͥ������ -->
		<FamilySalary></FamilySalary>
		<!-- <FamilySalary><xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(CusAnnualIncome)" /></FamilySalary>-->
		<!-- �ͻ����� -->
		<LiveZone></LiveZone>
		<!-- ���� -->
		<Nationality>
			<xsl:value-of select="CusCty" />
		</Nationality>
		<!-- ���(cm) -->
		<Stature></Stature>
		<!-- ����(kg) -->
		<Weight></Weight>
		<!-- ���(N/Y) -->
		<MaritalStatus></MaritalStatus>
		<!-- ��ַ -->
		<Address>
		    <xsl:if test="CusPostAddr !=''">
			  <xsl:value-of select="CusPostAddr" />
			</xsl:if>
			<xsl:if test="CusPostAddr =''">
			  <xsl:value-of select="CusAddr" />
			</xsl:if>
		</Address>
		<!-- �ʱ� -->
		<ZipCode>
		    <xsl:if test="CusPostCode !=''">
			  <xsl:value-of select="CusPostCode" />
			</xsl:if>
			<xsl:if test="CusPostCode =''">
			  <xsl:value-of select="CusHomePostCode" />
			</xsl:if>
		</ZipCode>
		<!-- �ƶ��绰 -->
		<Mobile>
			<xsl:value-of select="CusCPhNo" />
		</Mobile>
		<!-- �̶��绰 -->
		<Phone>
			<xsl:if test="CusFmyPhNo != ''">
				<xsl:value-of select="CusFmyPhNo" />
			</xsl:if>
			<xsl:if test="CusFmyPhNo = ''">
				<xsl:value-of select="CusOffPhNo" />
			</xsl:if>
		</Phone>
		<!-- �����ʼ�-->
		<Email>
			<xsl:value-of select="CusEmail" />
		</Email>
	</xsl:template>
	<!-- ����Ϊ�ַ�ת��ģ�� -->
	<!-- �Ա� -->
	<xsl:template name="tran_sex">
		<xsl:param name="sex" />
		<xsl:choose>
			<!-- �� -->
			<xsl:when test="$sex='M'">0</xsl:when>
			<!-- Ů -->
			<xsl:when test="$sex='F'">1</xsl:when>
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
			<!-- ���֤ -->
			<xsl:when test="$idtype='1'">0</xsl:when>
			<!-- ���ڱ� -->
			<xsl:when test="$idtype='2'">5</xsl:when>
			<!-- ����֤ -->
			<xsl:when test="$idtype='3'">2</xsl:when>
			<!-- ���� -->
			<xsl:when test="$idtype='7'">1</xsl:when>
			<!-- �۰�̨ͨ��֤ -->
			<xsl:when test="$idtype='8'">6</xsl:when>
			<!-- ��ʱ���֤ -->
			<xsl:when test="$idtype='A'">9</xsl:when>
			<!-- ���� -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Ͷ�����뱻���˹�ϵ -->
	<xsl:template name="tran_relation_to_app">
		<xsl:param name="relation" />
		<xsl:choose>
			<xsl:when test="$relation=1">02</xsl:when><!-- ��ż -->
			<xsl:when test="$relation=2">03</xsl:when><!-- ��ĸ -->
			<xsl:when test="$relation=3">01</xsl:when><!-- ��Ů -->
			<xsl:when test="$relation=4">04</xsl:when><!-- ���� -->
			<xsl:when test="$relation=5">00</xsl:when><!-- ���� -->
			<xsl:when test="$relation=6">04</xsl:when><!-- ���� -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �������뱻���˹�ϵ -->
	<xsl:template name="tran_relation">
		<xsl:param name="relation" />
		<xsl:choose>
			<xsl:when test="$relation=1">02</xsl:when><!-- ��ż -->
			<xsl:when test="$relation=2">01</xsl:when><!-- ��ĸ -->
			<xsl:when test="$relation=3">03</xsl:when><!-- ��Ů -->
			<xsl:when test="$relation=4">04</xsl:when><!-- ���� -->
			<xsl:when test="$relation=5">00</xsl:when><!-- ���� -->
			<xsl:when test="$relation=6">04</xsl:when><!-- ���� -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�Ƶ�� -->
	<xsl:template name="tran_PayIntv">
		<xsl:param name="payintv">0</xsl:param>
		<xsl:if test="$payintv = '0'">12</xsl:if><!-- ��� -->
		<xsl:if test="$payintv = '1'">6</xsl:if><!-- ���꽻 -->
		<xsl:if test="$payintv = '2'">3</xsl:if><!-- ����-->
		<xsl:if test="$payintv = '3'">1</xsl:if><!-- �½� -->
		<xsl:if test="$payintv = '4'">0</xsl:if><!-- ���� -->
	</xsl:template>

	<!-- �����������ڱ�־ -->
	<xsl:template name="tran_InsuYearFlag">
		<xsl:param name="insuyearflag" />
		<xsl:choose>
			<xsl:when test="$insuyearflag=5">D</xsl:when><!-- ���� -->
			<xsl:when test="$insuyearflag=4">M</xsl:when><!-- ���� -->
			<xsl:when test="$insuyearflag=2">Y</xsl:when><!-- ���� -->
			<xsl:when test="$insuyearflag=1">A</xsl:when><!-- ���� -->
			<xsl:when test="$insuyearflag=3">A</xsl:when><!-- ����ĳ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ����������־ -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="payendyearflag" />
		<xsl:choose>
		    <xsl:when test="$payendyearflag=1">Y</xsl:when><!-- ���� -->
			<xsl:when test="$payendyearflag=2">Y</xsl:when><!-- �����޽� -->
			<xsl:when test="$payendyearflag=3">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test="$payendyearflag=4">A</xsl:when><!-- ����ɷ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ������ȡ��ʽ -->
	<xsl:template name="tran_BonusGetMode">
		<xsl:param name="bonusgetmode" />
		<xsl:choose>
			<xsl:when test="$bonusgetmode=0">2</xsl:when><!-- ֱ�Ӹ���  -->
			<xsl:when test="$bonusgetmode=1">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test="$bonusgetmode=2">1</xsl:when><!-- �ۼ���Ϣ -->
			<xsl:when test="$bonusgetmode=3">5</xsl:when><!-- ����� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='LNABZX01'">L12079</xsl:when>
			<!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test="$riskcode='LNABZX02'">50015</xsl:when>
			<!-- 50002(50015)-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,122048(L12081) - ����������������գ������ͣ� -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when>
			<!-- �����2����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ��Ʒ��ϴ��� -->
	<xsl:template name="tran_contPlancode">
		<xsl:param name="contPlancode" />
		<xsl:choose>
			<!-- 50002(50015)-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,122048(L12081) - ����������������գ������ͣ� -->
			<xsl:when test="$contPlancode='LNABZX02'">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
