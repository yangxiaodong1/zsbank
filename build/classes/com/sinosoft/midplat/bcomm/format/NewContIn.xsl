<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="RMBP/K_TrList" />

			<Body>
				<!-- Ͷ������ -->
				<ProposalPrtNo>
					<xsl:value-of select="RMBP/K_TrList/KR_Idx" />
				</ProposalPrtNo>
				<!-- ����ӡˢ�� -->
				<ContPrtNo></ContPrtNo>
				<!-- Ͷ������ -->
				<PolApplyDate>
					<xsl:value-of select="RMBP/K_TrList/KR_TrDate" />
				</PolApplyDate>
				
				<!--������������-->
				<AgentComName><xsl:value-of select="RMBP/K_TrList/KR_BankName"/></AgentComName>
				<!-- �������ʱ�� -->
				<AgentComCertiCode><xsl:value-of select="RMBP/K_TrList/KR_BankCertNo" /></AgentComCertiCode>
				<!--����������Ա����-->
				<SellerNo><xsl:value-of select="RMBP/K_TrList/KR_SellNo"/></SellerNo>
				<!--����������Ա����-->
				<TellerName><xsl:value-of select="RMBP/K_TrList/KR_SellName"/></TellerName>
				<!--����������Ա�ʸ�֤-->
				<TellerCertiCode><xsl:value-of select="RMBP/K_TrList/KR_SellCode"/></TellerCertiCode>
								
				<!-- ְҵ��֪ -->
				<JobNotice>
					<xsl:value-of select="RMBP/K_BI/Info/Private/WorkFlag" />
				</JobNotice>
				<!-- ������֪ -->
				<HealthNotice>
					<xsl:value-of select="RMBP/K_BI/Info/Health" />
				</HealthNotice>
				<!-- �˻��� -->
				<AccName>
					<xsl:value-of select="RMBP/K_BI/App/AppName" />
				</AccName>
				<!-- �˻��� -->
				<AccNo>
					<xsl:value-of select="RMBP/K_BI/Info/OpenAct" />
				</AccNo>
				
				<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
				<xsl:variable name="InsuredTotalFaceAmount"><xsl:value-of select="RMBP/K_BI/Ins/InsCovSumAmt*0.0001"/></xsl:variable>
				<PolicyIndicator>
					<xsl:choose>
						<xsl:when test="$InsuredTotalFaceAmount>0">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</PolicyIndicator>
				<!--�ۼ�Ͷ����ʱ���, ��λ�ǣ���Ԫ-->
				<InsuredTotalFaceAmount><xsl:value-of select="$InsuredTotalFaceAmount" /></InsuredTotalFaceAmount>
				<!--�籣��֪-->
				<SocialInsure></SocialInsure>
				<!--����ҽ�Ƹ�֪-->
				<FreeMedical></FreeMedical>
				<!--����ҽ�Ƹ�֪-->
				<OtherMedical></OtherMedical>
				<ContPlan>
					<!--��ϲ�Ʒ����-->
					<ContPlanCode>
						<xsl:call-template name="tran_ContPlanCode">
							<xsl:with-param name="contPlanCode" select="RMBP/K_TrList/KR_IdxType" />
						</xsl:call-template>
					</ContPlanCode>
					<!--��ϲ�Ʒ����-->
					<ContPlanMult>
						<xsl:value-of select="number(RMBP/K_BI/Info/Unit)" />
					</ContPlanMult>
				</ContPlan>

				<!-- Ͷ���� -->
				<xsl:apply-templates select="RMBP/K_BI/App" />

				<!-- ������ -->
				<xsl:apply-templates select="RMBP/K_BI/Ins" />

				<!-- ������ -->
				<xsl:apply-templates select="RMBP/K_BI/Benefit" />

				<!-- ���� ����ֻ������-->
				<xsl:apply-templates select="RMBP/K_BI/Info" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����ͷ��� -->
	<xsl:template name="Head" match="K_TrList">
		<Head>
			<TranDate>
				<xsl:value-of select="KR_TrDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="KR_TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="KR_TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="KR_SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="KR_AreaNo" />
				<xsl:value-of select="KR_BankNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

	<!-- Ͷ���� -->
	<xsl:template name="Appnt" match="App">
		<Appnt>
			<Name>
				<xsl:value-of select="AppName" />
			</Name>
			<Sex>
				<xsl:value-of select="AppSex" />
			</Sex>
			<Birthday>
				<xsl:value-of select="AppBirthday" />
			</Birthday>
			<IDType>
				<xsl:apply-templates select="AppIdType" />
			</IDType>
			<IDNo>
				<xsl:value-of select="AppIdNo" />
			</IDNo>
			<JobCode>
				<xsl:apply-templates select="AppWork" />
			</JobCode>
			
			<!-- Ͷ���������룬���е�λ��Ԫ�����չ�˾��λ�� -->
			<Salary>
				<xsl:choose>
					<xsl:when test="AppYearSalary=''">
						<xsl:value-of select="AppYearSalary" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AppYearSalary)*10000"/>
					</xsl:otherwise>
				</xsl:choose>
			</Salary>
			<!-- ��ͥ������ -->
			<FamilySalary>
				<xsl:choose>
					<xsl:when test="../Info/Private/HomeYearSalary=''">
						<xsl:value-of select="../Info/Private/HomeYearSalary" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(../Info/Private/HomeYearSalary)*10000"/>
					</xsl:otherwise>
				</xsl:choose>
			</FamilySalary>
			<!-- �ͻ����� -->
			<LiveZone>
				<xsl:apply-templates select="../Info/Private/CusSource" />
			</LiveZone>
		
			<Nationality>
				<xsl:apply-templates select="AppCountry" />
			</Nationality>
			<Stature>
				<xsl:value-of select="AppHeight" />
			</Stature><!-- ���(cm) -->
			<Weight>
				<xsl:value-of select="AppWeight" />
			</Weight><!-- ����(g)-->
			<!-- ��� -->
			<MaritalStatus>
				<xsl:apply-templates select="AppMarStat" />
			</MaritalStatus>
			<Address>
				<xsl:value-of select="AppOfficAddr" />
			</Address>
			<ZipCode>
				<xsl:value-of select="AppOfficPost" />
			</ZipCode>
			<Mobile>
				<xsl:value-of select="AppMobile" />
			</Mobile>
			<Phone>
				<xsl:value-of select="AppOfficPhone" />
			</Phone>
			<Email>
				<xsl:value-of select="AppEmail" />
			</Email>
			<IDTypeStartDate></IDTypeStartDate>
			<IDTypeEndDate>
				<xsl:value-of select="AppIdExpDate" />
			</IDTypeEndDate>
			<!-- �ͱ������˹�ϵ -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation" select="../Info/Rela" />
				</xsl:call-template>
			</RelaToInsured>
		</Appnt>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Insured" match="Ins">
		<Insured>
			<Name>
				<xsl:value-of select="InsName" />
			</Name>
			<Sex>
				<xsl:value-of select="InsSex" />
			</Sex>
			<Birthday>
				<xsl:value-of select="InsBirthday" />
			</Birthday>
			<IDType>
				<xsl:apply-templates select="InsIdType" />
			</IDType>
			<IDNo>
				<xsl:value-of select="InsIdNo" />
			</IDNo>
			<IDTypeStartDate></IDTypeStartDate>
			<IDTypeEndDate>
				<xsl:value-of select="InsIdExpDate" />
			</IDTypeEndDate>
			<JobCode>
				<xsl:apply-templates select="InsWork" />
			</JobCode>
			<Nationality>
				<xsl:apply-templates select="InsCountry" />
			</Nationality>
			<Stature>
				<xsl:value-of select="InsHeight" />
			</Stature><!-- ���(cm) -->
			<Weight>
				<xsl:value-of select="InsWeight" />
			</Weight><!-- ����(g)-->
			<!-- ��� -->
			<MaritalStatus>
				<xsl:apply-templates select="InsMarStat" />
			</MaritalStatus>
			<Address>
				<xsl:value-of select="InsOfficAddr" />
			</Address>
			<ZipCode>
				<xsl:value-of select="InsOfficPost" />
			</ZipCode>
			<Mobile>
				<xsl:value-of select="InsMobile" />
			</Mobile>
			<Phone>
				<xsl:value-of select="InsOfficPhone" />
			</Phone>
			<Email>
				<xsl:value-of select="InsEmail" />
			</Email>
		</Insured>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Bnf" match="Benefit">
		<Bnf>
			<Type>
				<xsl:apply-templates select="BeneType" />
			</Type>
			<!--  ˳��  -->
			<Grade>
				<xsl:value-of select="BeneDisMode" />
			</Grade>
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<IDType>
				<xsl:apply-templates select="IdType" />
			</IDType>
			<IDNo>
				<xsl:value-of select="IdNo" />
			</IDNo>
			<!-- ������� -->
			<Lot>
				<xsl:value-of select="DisRate" />
			</Lot>
			<!--  �������뱻���˹�ϵ  -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation" select="Rela" />
				</xsl:call-template>
			</RelaToInsured>
		</Bnf>
	</xsl:template>

	<!-- ���� -->
	<xsl:template name="mainRisk" match="Info">
		<xsl:variable name="mainRiskCode" select="/RMBP/K_TrList/KR_IdxType" />
		<xsl:variable name="PayIntv"><xsl:apply-templates select="PremType" /></xsl:variable>
		<Risk>
			<!-- ���ֺ� -->
			<RiskCode>
				<xsl:apply-templates select="$mainRiskCode" />
			</RiskCode>
			<!-- ���պ� -->
			<MainRiskCode>
				<xsl:apply-templates select="$mainRiskCode" />
			</MainRiskCode>
			<!--  ��������  -->
			<Amnt>
				<xsl:value-of select="number(BaseAmt)" />
			</Amnt>
			<Prem>
				<xsl:value-of select="number(Premium)" />
			</Prem><!-- ���շ�(��) -->
			<Mult>
				<xsl:value-of select="number(Unit)" />
			</Mult><!-- Ͷ������ -->
			<PayMode></PayMode><!-- �ɷ���ʽ -->
			<PayIntv>
				<xsl:value-of select="$PayIntv" />
			</PayIntv><!-- �ɷ�Ƶ�� -->
			<InsuYearFlag>
				<xsl:apply-templates select="CoverageType" />
			</InsuYearFlag><!-- �������������־ -->
			<InsuYear>
				<xsl:value-of select="Coverage" />
			</InsuYear><!-- ������������ -->
			<PayEndYearFlag>
				<xsl:apply-templates select="PremTermType" />
			</PayEndYearFlag><!-- �ɷ����������־ -->
			<PayEndYear>
				<xsl:choose>
					<xsl:when test="$PayIntv=0">1000</xsl:when>
					<xsl:otherwise><xsl:value-of select="PremTerm" /></xsl:otherwise>
				</xsl:choose>
			</PayEndYear><!-- �ɷ��������� -->
			<BonusGetMode>
				<xsl:apply-templates select="DividMethod" />
			</BonusGetMode><!-- ������ȡ��ʽ -->
			<SpecContent></SpecContent>
			<FullBonusGetMode></FullBonusGetMode><!-- ������ȡ����ȡ��ʽ ����-->
			<GetYearFlag>
				<xsl:apply-templates select="Private/PayM" />
			</GetYearFlag><!-- ��ȡ�������ڱ�־ -->
			<GetYear>
				<xsl:value-of select="Private/PayD" />
			</GetYear><!-- ��ȡ���� -->
			<GetIntv></GetIntv>
			<GetBankCode></GetBankCode><!-- ��ȡ���б��� ����-->
			<GetBankAccNo></GetBankAccNo><!-- ��ȡ�����˻� ����-->
			<GetAccName></GetAccName><!-- ��ȡ���л���  ����-->
			<AutoPayFlag></AutoPayFlag><!-- �Զ��潻��־ ����-->
		</Risk>
	</xsl:template>


	<!-- �������ͷ�ʽ -->
	<xsl:template name="tran_GetPolMode" match="Deliver">
		<xsl:choose>
			<xsl:when test=".=0">2</xsl:when><!-- ������ȡ -->
			<xsl:when test=".=1">1</xsl:when><!-- �ʼĻ򴫵� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template name="tran_idtype"
		match="AppIdType | InsIdType | IdType">
		<xsl:choose>
			<xsl:when test=".=15">0</xsl:when><!-- �������֤ -->
			<xsl:when test=".=16">9</xsl:when><!-- ��ʱ���֤ -->
			<xsl:when test=".=17">2</xsl:when><!-- �������֤��  -->
			<xsl:when test=".=18">8</xsl:when><!-- �侯���֤��  -->
			<xsl:when test=".=19">8</xsl:when><!-- ͨ��֤  -->
			<xsl:when test=".=20">1</xsl:when><!-- ����  -->
			<xsl:when test=".=21">8</xsl:when><!-- ����  -->
			<xsl:when test=".=22">8</xsl:when><!-- ��ʱ����  -->
			<xsl:when test=".=23">5</xsl:when><!-- ���ڲ�  -->
			<xsl:when test=".=24">8</xsl:when><!-- �߾�֤  -->
			<xsl:when test=".=25">8</xsl:when><!-- ����˾���֤  -->
			<xsl:when test=".=26">8</xsl:when><!-- ���֤��  -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ְҵ���� -->
	<xsl:template name="tran_Job" match="AppWork | InsWork">
		<xsl:choose>
			<xsl:when test=".=1">3010101</xsl:when><!-- ��λ��ְ���� -->
			<xsl:when test=".=2">3010102</xsl:when><!-- �������ò��� -->
			<xsl:when test=".=3">6230608</xsl:when><!-- ũ������װ�� -->
			<xsl:when test=".=4">5030206</xsl:when><!-- ��۲�ɰˮ�� -->
			<xsl:when test=".=5">6230902</xsl:when><!-- ����������е -->
			<xsl:when test=".=6">6230618</xsl:when><!-- �߿պ��Ϻ��� -->
			<xsl:when test=".=7">2021305</xsl:when><!-- ���溽�˳��� -->
			<xsl:when test=".=8">6051302</xsl:when><!-- Ǳˮ�������� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ����״�� -->
	<xsl:template name="tran_marStat" match="AppMarStat | InsMarStat">
		<xsl:choose>
			<xsl:when test=".=5">N</xsl:when><!-- δ�� -->
			<xsl:when test=".=1">Y</xsl:when><!-- �ѻ� -->
			<xsl:when test=".=6"></xsl:when><!-- ɥż -->
			<xsl:when test=".=2"></xsl:when><!-- ��� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �뱻�����˵Ĺ�ϵ-->
	<xsl:template name="tran_relation">
		<xsl:param name="relation" />
		<xsl:choose>
			<xsl:when test="$relation='1'">00</xsl:when><!-- ���� -->
			<xsl:when test="$relation='2'">01</xsl:when><!-- ��ĸ -->
			<xsl:when test="$relation='3'">01</xsl:when><!-- ��ĸ -->
			<xsl:when test="$relation='4'">03</xsl:when><!-- ��Ů -->
			<xsl:when test="$relation='5'">03</xsl:when><!-- ��Ů -->
			<xsl:when test="$relation='6'">02</xsl:when><!-- ��ż -->
			<xsl:when test="$relation='7'">02</xsl:when><!-- ��ż -->
			<xsl:when test="$relation='45'">04</xsl:when><!-- ���� -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ײʹ��� -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- �������Ӯ���ռƻ�  -->
			<!-- ������ͣ��50002������50001�������в�������Ʒ���룬����Ҫ����ͨ���д���ת���� 
			<xsl:when test="$contPlanCode='50002'">50002</xsl:when>
			-->
			<xsl:when test="$contPlanCode='50002'">50001</xsl:when><!-- �������Ӯ���ռƻ�  -->
			<!-- add 20150819 PBKINSR-852  ���Ӱ���5�Ų�Ʒ  begin -->
			<xsl:when test="$contPlanCode='50012'">50012</xsl:when><!-- ����ٰ���5�ű��ռƻ�  -->
			<!-- add 20150819 PBKINSR-852  ���Ӱ���5�Ų�Ʒ  end -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template name="tran_RiskCode" match="KR_IdxType">
		<xsl:choose>
			<!-- �������Ӯ���ռƻ�  -->
			<!-- ������ͣ��50002������50001�������в�������Ʒ���룬����Ҫ����ͨ���д���ת����
			<xsl:when test="$riskCode='50002'">50002</xsl:when>
			 -->
			<xsl:when test=".='50002'">50001</xsl:when><!-- �������Ӯ1����ȫ����  -->
			<xsl:when test=".='50012'">50012</xsl:when><!-- ����ٰ���5�ű��ռƻ�  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ� -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �����ĽɷѼ��/Ƶ�� -->
	<xsl:template name="tran_payintv" match="PremType">
		<xsl:choose>
			<xsl:when test=".=0"></xsl:when><!-- �޹� -->
			<xsl:when test=".=1">0</xsl:when><!-- ���� -->
			<xsl:when test=".=2">1</xsl:when><!-- �½� -->
			<xsl:when test=".=3">3</xsl:when><!-- ���� -->
			<xsl:when test=".=4">6</xsl:when><!-- ���꽻 -->
			<xsl:when test=".=5">12</xsl:when><!-- ��� -->
			<xsl:when test=".=7">-1</xsl:when><!-- �����ڽ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ��������� -->
	<xsl:template name="tran_PremTermType" match="PremTermType">
		<xsl:choose>
			<xsl:when test=".=0"></xsl:when><!-- �޹� -->
			<xsl:when test=".=1">Y</xsl:when><!-- ���� -->
			<xsl:when test=".=2">Y</xsl:when><!-- �����޽� -->
			<xsl:when test=".=3">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".=4">A</xsl:when><!-- �����ɷ� -->
			<xsl:when test=".=5"></xsl:when><!-- �����ڽ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �������ڱ�־ -->
	<xsl:template name="tran_CoverageType" match="CoverageType ">
		<xsl:choose>
			<xsl:when test=".=5">D</xsl:when><!-- ���챣 -->
			<xsl:when test=".=4">M</xsl:when><!-- ���±� -->
			<xsl:when test=".=2">Y</xsl:when><!-- �����ޱ� -->
			<xsl:when test=".=3">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".=1">A</xsl:when><!-- ������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ������ȡ��ʽ -->
	<xsl:template name="tran_DividMethod" match="DividMethod">
		<xsl:choose>
			<xsl:when test=".=2">1</xsl:when><!-- �ۻ���Ϣ -->
			<xsl:when test=".=4">4</xsl:when><!-- ��ȡ�ֽ� -->
			<xsl:when test=".=1">3</xsl:when><!-- �ֽɱ��� -->
			<xsl:when test=".=3">5</xsl:when><!-- ����� -->
			<xsl:otherwise>4</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>

	<!-- ����ת�� -->
	<xsl:template match="AppCountry | InsCountry">
		<xsl:choose>
			<xsl:when test=".='HUN'">HU</xsl:when><!--	������     -->
			<xsl:when test=".='USA'">US</xsl:when><!--	����     -->
			<xsl:when test=".='THA'">TH</xsl:when><!--	̩��     -->
			<xsl:when test=".='SGP'">SG</xsl:when><!--	�¼���   -->
			<xsl:when test=".='IND'">IN</xsl:when><!--  ӡ��   -->
			<xsl:when test=".='BEL'">BE</xsl:when><!--	����ʱ     -->
			<xsl:when test=".='NLD'">NL</xsl:when><!--	����     -->
			<xsl:when test=".='MYS'">MY</xsl:when><!--	�������� -->
			<xsl:when test=".='KOR'">KR</xsl:when><!--	����     -->
			<xsl:when test=".='JPN'">JP</xsl:when><!--	�ձ�     -->
			<xsl:when test=".='AUT'">AT</xsl:when><!--	�µ���   -->
			<xsl:when test=".='FRA'">FR</xsl:when><!--	����     -->
			<xsl:when test=".='ESP'">ES</xsl:when><!--	������   -->
			<xsl:when test=".='GBR'">GB</xsl:when><!--	Ӣ��     -->
			<xsl:when test=".='CAN'">CA</xsl:when><!--	���ô�   -->
			<xsl:when test=".='AUS'">AU</xsl:when><!--	�Ĵ����� -->
			<xsl:when test=".='CHN'">CHN</xsl:when><!--	�й�     -->
			<xsl:otherwise>OTH</xsl:otherwise><!--	����     -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ������Դ -->
	<xsl:template match="CusSource">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!--	���� -->
			<xsl:when test=".='1'">2</xsl:when><!--	ũ�� -->
			<xsl:otherwise></xsl:otherwise><!--	���� -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
