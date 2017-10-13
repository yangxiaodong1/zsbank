<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="Req">
		<TranData>
			<xsl:apply-templates select="Head/Sender" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="Sender">
		<Head>
			<TranDate>
				<xsl:value-of select="BusDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="BrchId" /><xsl:value-of select="SubBrchId" />
			</NodeNo>
			<SourceType>
				<xsl:apply-templates select="ChanNo" />
			</SourceType>	
			<BankCode><xsl:value-of select="../TranCom/@outcode"/></BankCode>		
			<xsl:copy-of select="../ClientIp" />
			<xsl:copy-of select="../FuncFlag" />
			<xsl:copy-of select="../TranCom" />
		</Head>
	</xsl:template>

	<xsl:template name="Body" match="Body">
	
		 <xsl:variable name="MainRisk" select="PrdList/PrdItem[IsMain=1]" />
		
		 <ProposalPrtNo><xsl:value-of select="PolItem/AppPrintNo" /></ProposalPrtNo>
		 <ContPrtNo></ContPrtNo>
		 <PolApplyDate><xsl:value-of select="../Head/Sender/TrDate" /></PolApplyDate>
		 <AccName></AccName>
		 <AccNo></AccNo>
		 <!-- �������ͷ�ʽ:1=�ʼģ�2=���й�����ȡ -->
		 <GetPolMode><xsl:apply-templates select="PolItem/Deliver" /></GetPolMode>
		 <!-- ������������1��ֽ�Ʊ���2�����ӱ��� -->
		 <PolicyDeliveryMethod>1</PolicyDeliveryMethod>
		 <!-- ְҵ��֪ -->
		 <JobNotice><xsl:apply-templates select="PolItem/IsWorkTell" /></JobNotice>
		 <!-- ������֪ -->
		 <HealthNotice><xsl:apply-templates select="PolItem/IsHealthTell" /></HealthNotice>
		 <PolicyIndicator></PolicyIndicator>
		 <InsuredTotalFaceAmount></InsuredTotalFaceAmount> 
		 <!-- ��Ʒ��� -->
		 <ContPlan>
			<!-- ��Ʒ��ϱ��� -->
			<ContPlanCode><xsl:apply-templates select="$MainRisk/PrdId"  mode="contplan"/></ContPlanCode>
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult><xsl:value-of select="$MainRisk/Units" /></ContPlanMult>
		 </ContPlan>
		 <!--������������-->
		 <AgentComName></AgentComName>
		 <AgentComCertiCode>
		    <xsl:value-of select="PolItem/SubBrchCertNo" />
		 </AgentComCertiCode>
		 <!--����������Ա���ż�����������Ա���ƣ�
		 		�����ж������Ƽ���Ա��IntrNo��IntrName���Ƿ���ֵ���������ȡ��ֵ����������Ƽ���Աû��ֵ����ȡ����������Ա��ֵ��SellNo��SellName��-->
		 <xsl:choose>
			<xsl:when test="PolItem/IntrNo!=''">
				<TellerName><xsl:value-of select="PolItem/IntrName" /></TellerName>
		 		<SellerNo><xsl:value-of select="PolItem/IntrNo" /></SellerNo>
			</xsl:when>
			<xsl:otherwise>
				<TellerName><xsl:value-of select="PolItem/SellName" /></TellerName>
		 		<SellerNo><xsl:value-of select="PolItem/SellNo" /></SellerNo>
			</xsl:otherwise>
		</xsl:choose>		 
		 <TellerCertiCode>
		  	<xsl:value-of select="PolItem/SellCertNo" />
		 </TellerCertiCode>
		 <TellerEmail></TellerEmail>	  
		  
		<!-- Ͷ���� -->
		<Appnt>
			<xsl:apply-templates select="AppItem" />
		</Appnt>
		<!-- ������ -->
		<Insured>
			<xsl:apply-templates select="InsList/InsItem" />
		</Insured>
		<!-- ������ -->
		<!-- BenListIsLegal=1Ϊ���������� -->
		<xsl:if test="InsList/InsItem/BenTypeList/BenTypeItem[IsLegal=0]/BenItem!=''">
			<xsl:apply-templates select="InsList/InsItem/BenTypeList/BenTypeItem[IsLegal=0]/BenItem" /> 
		</xsl:if>
		
		<!-- ������Ϣ -->
		<xsl:for-each select="PrdList/PrdItem">
			<Risk>
				<!-- ���ִ��� -->
				<RiskCode><xsl:apply-templates select="PrdId"  mode="risk"/></RiskCode>
				<!-- �������ִ��� -->
				<xsl:choose>
					<xsl:when test="IsMain='1'">
						<MainRiskCode><xsl:apply-templates select="PrdId"  mode="risk"/></MainRiskCode>
					</xsl:when>
					<xsl:otherwise>
						<MainRiskCode><xsl:apply-templates select="../PrdItem[IsMain='1']/PrdId"  mode="risk"/></MainRiskCode>
					</xsl:otherwise>
				</xsl:choose>
				<!-- ���� -->
				<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(CovAmt)" /></Amnt>
				<!-- ����  -->
				<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PremAmt)" /></Prem>
				<!-- Ͷ������ -->
				<Mult><xsl:value-of select="Units" /></Mult>
				<PayMode></PayMode> <!-- �ɷ���ʽ -->
				<PayIntv><xsl:apply-templates select="PremType" /></PayIntv> <!-- �ɷ�Ƶ�� --> 
				<xsl:choose>
					<!-- ������ -->
					<xsl:when test="CovTermType='01'">
						<InsuYearFlag>A</InsuYearFlag>
						<InsuYear>106</InsuYear>
					</xsl:when>
					<xsl:otherwise>
						<!--  ��������/�����־  -->
						<InsuYearFlag><xsl:apply-templates select="CovTermType" /></InsuYearFlag>
						<!--  ��������  -->
						<InsuYear><xsl:value-of select="CovTerm" /></InsuYear>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<!-- ���� -->
					<xsl:when test="PremTermType='01'">
						<PayEndYearFlag>Y</PayEndYearFlag>
						<PayEndYear>1000</PayEndYear>
					</xsl:when>
					<!-- ���� -->
					<xsl:when test="PremTermType='04'">
						<PayEndYearFlag>A</PayEndYearFlag>
						<PayEndYear>106</PayEndYear>
					</xsl:when>
					<xsl:otherwise><!-- ���� -->
						<!--  ��������/��������  -->
						<PayEndYearFlag>
							<xsl:apply-templates select="PremTermType" />
						</PayEndYearFlag>
						<!--  ��������/����  -->
						<PayEndYear>
							<xsl:value-of select="PremTerm" />
						</PayEndYear>
					</xsl:otherwise>
				</xsl:choose>
				<BonusGetMode></BonusGetMode> <!-- ������ȡ��ʽ -->
				<FullBonusGetMode></FullBonusGetMode> <!-- ������ȡ����ȡ��ʽ -->
			    <GetYearFlag></GetYearFlag> <!-- ��ȡ�������ڱ�־ -->
			    <GetYear></GetYear> <!-- ��ȡ���� -->		
			    <GetIntv></GetIntv> <!-- ��ȡ��ʽ -->				
			    <GetBankCode></GetBankCode> <!-- ��ȡ���б��� -->
			    <GetBankAccNo></GetBankAccNo> <!-- ��ȡ�����˻� -->
				<GetAccName></GetAccName> <!-- ��ȡ���л��� -->
				<AutoPayFlag>0</AutoPayFlag> <!-- �Զ��潻��־ -->			
              </Risk>
		</xsl:for-each>		
	</xsl:template>
	
	
	<!-- �̶��绰�� -->
	<xsl:template name="PhoneItem" match="PhoneItem" >
		<xsl:choose>
			<xsl:when test="Extension=''">
				<xsl:value-of select="Section" /><xsl:value-of select="Phone" /><xsl:value-of select="Extension" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="Section" /><xsl:value-of select="Phone" /><xsl:value-of select="Extension" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

	<!-- Ͷ���� -->
	<xsl:template name="AppItem" match="AppItem">
		<!-- Ͷ�������� -->
		<Name>
			<xsl:value-of select="CusItem/Name" />
		</Name>
		<!-- �Ա� -->
		<Sex>
			<xsl:apply-templates select="CusItem/Sex" />
		</Sex>
		<!-- ��������[yyyymmdd] -->
		<Birthday><xsl:value-of	select="CusItem/Birthday" /></Birthday>
		<!-- ֤������[�ο�5.5] -->
		<IDType>
			<xsl:apply-templates select="CusItem/IdType" />
		</IDType>
		<!-- ֤������ -->
		<IDNo>
			<xsl:value-of select="CusItem/IdNo" />
		</IDNo>
		<IDTypeStartDate><xsl:value-of select="CusItem/IdStartDate" /></IDTypeStartDate> <!-- ֤����Ч���� -->
		<IDTypeEndDate><xsl:value-of select="CusItem/IdEndDate" /></IDTypeEndDate> <!-- ֤����Чֹ�� -->
		<JobCode><xsl:apply-templates select="CusItem/Work" /></JobCode> <!-- ְҵ���루��ӳ�䣩 -->
		<!-- Ͷ���������� ��λ�֣�������Ԫ -->
		<Salary>
			<xsl:choose>
				<xsl:when test="YearIncome=''">
					<xsl:value-of select="YearIncome" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(YearIncome)*1000000"/>
				</xsl:otherwise>
			</xsl:choose>
		</Salary>
		<!-- Ͷ���˼�ͥ���� ��λ�֣�������Ԫ -->
		<FamilySalary>
			<xsl:choose>
				<xsl:when test="HomeYearIncome=''">
					<xsl:value-of select="HomeYearIncome" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(HomeYearIncome)*1000000"/>
				</xsl:otherwise>
			</xsl:choose>
		</FamilySalary>
		<!-- ��ס���� ����1/ũ��2 -->
		<LiveZone>
			<xsl:apply-templates select="DenizenOrigin" />
		</LiveZone>  
		<RiskAssess><xsl:apply-templates select="IsRiskEval" /></RiskAssess><!--���ղ�������Ƿ��ʺ�Ͷ���������3�������Ӹ��ֶΡ�Y��N��-->
		<!-- ���� -->
		<Nationality><xsl:apply-templates select="CusItem/Country" /></Nationality>
		<Stature><xsl:value-of select="Stature" /></Stature><!-- ���(cm)�����У���ߣ����� -->
    	<Weight><xsl:value-of select="Weight" /></Weight> <!-- ����(kg) ���У����أ�ǧ�� -->
		<MaritalStatus><xsl:apply-templates select="CusItem/MarStat" /></MaritalStatus> <!-- ���(N/Y) -->
		<Company><xsl:value-of select="CusItem/Company" /></Company> <!-- ������λ--><!--�����3�����ʴ����Ӹ��ֶ�-->
		<Province></Province> <!-- ʡ�� --><!--�����3�����ʴ����Ӹ��ֶ�-->
		<City></City> <!-- ���� --><!--�����3�����ʴ����Ӹ��ֶ�-->
    	<Address><xsl:value-of select="CusItem/AddrItem/Province" /><xsl:value-of select="CusItem/AddrItem/City" /><xsl:value-of select="CusItem/AddrItem/County" /><xsl:value-of select="CusItem/AddrItem/AddrDetail" /></Address> <!-- ��ַ -->		
		<!-- �ʱ� -->
		<ZipCode>
			<xsl:value-of select="CusItem/AddrItem/Post" />
		</ZipCode>
		<!-- �ƶ��绰 -->
		<Mobile>
			<xsl:value-of select="CusItem/MobileItem/Mobile" />
		</Mobile>
		<!-- �̶��绰 -->
		<Phone>
			<xsl:apply-templates select="CusItem/PhoneItem" />
		</Phone>
		<!-- email -->
		<Email>
			<xsl:value-of select="CusItem/EmailItem/Email" />
		</Email>
		<!-- �뱻���˹�ϵ�����б�ʾͶ�����Ǳ����˵�** --> 
		<RelaToInsured>
			<xsl:call-template name="tran_relaCode_ins">
				<xsl:with-param name="relaCode" select="../InsList/InsItem/AppRela" />
			</xsl:call-template>
		</RelaToInsured>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Ins" match="InsItem">
				
		<!-- ���������� -->
		<Name>
			<xsl:value-of select="CusItem/Name" />
		</Name>
		<!-- �Ա� -->
		<Sex>
			<xsl:apply-templates select="CusItem/Sex" />
		</Sex>
		<!-- ��������[yyyymmdd] -->
		<Birthday><xsl:value-of	select="CusItem/Birthday" /></Birthday>
		<!-- ֤������ -->
		<IDType>
			<xsl:apply-templates select="CusItem/IdType" />
		</IDType>
		<!-- ֤������ -->
		<IDNo>
			<xsl:value-of select="CusItem/IdNo" />
		</IDNo>
		<IDTypeStartDate><xsl:value-of select="CusItem/IdStartDate" /></IDTypeStartDate> <!-- ֤����Ч���� -->
		<IDTypeEndDate><xsl:value-of select="CusItem/IdEndDate" /></IDTypeEndDate> <!-- ֤����Чֹ�� -->
		<JobCode><xsl:apply-templates select="CusItem/Work" /></JobCode> <!-- ְҵ���루��ӳ�䣩 -->
		<Stature><xsl:value-of select="Stature" /></Stature><!-- ���(cm)�����У���ߣ����� -->
   		<Weight><xsl:value-of select="Weight" /></Weight> <!-- ����(kg) ���У����أ�ǧ�� -->
		<!-- ���� -->
		<Nationality><xsl:apply-templates select="CusItem/Country" /></Nationality>
		<MaritalStatus><xsl:apply-templates select="CusItem/MarStat" /></MaritalStatus> <!-- ���(N/Y) -->
		<Company><xsl:value-of select="CusItem/Company" /></Company> <!-- ������λ--><!--�����3�����ʴ����Ӹ��ֶ�-->
		<Province></Province> <!-- ʡ�� --><!--�����3�����ʴ����Ӹ��ֶ�-->
		<City></City> <!-- ���� --><!--�����3�����ʴ����Ӹ��ֶ�-->
    	<Address><xsl:value-of select="CusItem/AddrItem/Province" /><xsl:value-of select="CusItem/AddrItem/City" /><xsl:value-of select="CusItem/AddrItem/County" /><xsl:value-of select="CusItem/AddrItem/AddrDetail" /></Address> <!-- ��ַ -->		
		<!-- �ʱ� -->
		<ZipCode>
			<xsl:value-of select="CusItem/AddrItem/Post" />
		</ZipCode>
		<!-- �ƶ��绰 -->
		<Mobile>
			<xsl:value-of select="CusItem/MobileItem/Mobile" />
		</Mobile>
		<!-- �̶��绰 -->
		<Phone>
			<xsl:apply-templates select="CusItem/PhoneItem" />
		</Phone>
		<!-- email -->
		<Email>
			<xsl:value-of select="CusItem/EmailItem/Email" />
		</Email>	
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="BenItem" match="BenItem">
		<Bnf>
		<Type>1</Type>	<!-- Ĭ��Ϊ��1-���������ˡ� -->
		<Grade><xsl:value-of select="BenOrder" /></Grade> <!-- ����˳�� -->		
		<!-- ���������� -->	
		<Name>
			<xsl:value-of select="CusItem/Name" />
		</Name>
		<!-- �Ա�[�ο�5.4] -->
		<Sex>
			<xsl:apply-templates select="CusItem/Sex" />
		</Sex>
		<!-- ��������[yyyymmdd] -->
		<Birthday><xsl:value-of	select="CusItem/Birthday" /></Birthday>
		 <!-- ֤������[�ο�5.5] -->
		<IDType>
			<xsl:apply-templates select="CusItem/IdType" />
		</IDType>
		 <!-- ֤������ -->
		<IDNo>
			<xsl:value-of select="CusItem/IdNo" />
		</IDNo>			
		<!-- �뱻�����˹�ϵ[�ο�5.7],���У���ʾ�������Ǳ����˵�** -->
		<RelaToInsured>
			<xsl:call-template name="tran_relaCode_ins">
				<xsl:with-param name="relaCode" select="InsRela" />
			</xsl:call-template>
		</RelaToInsured>
		<IDTypeStartDate><xsl:value-of select="CusItem/IdStartDate" /></IDTypeStartDate> <!-- ֤����Ч���� -->
		<IDTypeEndDate><xsl:value-of select="CusItem/IdEndDate" /></IDTypeEndDate> <!-- ֤����Чֹ�� -->
		<!-- ���� -->
		<Nationality><xsl:apply-templates select="CusItem/Country" /></Nationality>
		<!-- �������,�����ǣ��ٷֱȵķ��� -->
		<Lot><xsl:value-of select="BenRate" /></Lot>					
		</Bnf>
	</xsl:template>
	<!-- ���� -->
	<xsl:template name="ChanNo" match="ChanNo">
		<xsl:choose>
			<xsl:when test=".=00">0</xsl:when>	<!-- ���� -->
			<xsl:when test=".=21">1</xsl:when>	<!-- �������� -->
			<xsl:when test=".=51">17</xsl:when>	<!-- �ֻ����� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ���ִ��� -->
	<xsl:template match="PrdId"  mode="risk">
		<xsl:choose>
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �������  -->
			<!--<xsl:when test=".='50012'">50012</xsl:when> --><!--����ٰ���5�ű��ռƻ�-->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<!--<xsl:when test=".='50001'">50001</xsl:when>--><!-- �������Ӯ1����ȫ����  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ�  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template  match="PrdId" mode="contplan">
		<xsl:choose>
			<xsl:when test=".='50012'">50012</xsl:when><!--����ٰ���5�ű��ռƻ�-->
			<!-- <xsl:when test=".='50001'">50001</xsl:when>--><!-- �������Ӯ1����ȫ����  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �������ͷ�ʽ -->
	<xsl:template name="Deliver" match="Deliver">
		<xsl:choose>
			<xsl:when test=".=01">1</xsl:when>	<!-- �ʼ� -->
			<xsl:when test=".=02"></xsl:when>	<!-- ���ӷ��� -->
			<xsl:when test=".=03">2</xsl:when>	<!-- ������ȡ -->
		</xsl:choose>
	</xsl:template>
	<!-- ������֪ -->
	<xsl:template name="IsHealthTell" match="IsHealthTell">
		<xsl:choose>
			<xsl:when test=".=0">N</xsl:when>	<!-- �� -->
			<xsl:when test=".=1">Y</xsl:when>	<!-- �� -->
		</xsl:choose>
	</xsl:template>
	<!-- ְҵ��֪ -->
	<xsl:template name="IsWorkTell" match="IsWorkTell">
		<xsl:choose>
			<xsl:when test=".=0">N</xsl:when>	<!-- �� -->
			<xsl:when test=".=1">Y</xsl:when>	<!-- �� -->
		</xsl:choose>
	</xsl:template>
	<!-- �Ա� -->
	<xsl:template name="Sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".=01">0</xsl:when>	<!-- �� -->
			<xsl:when test=".=02">1</xsl:when>	<!-- Ů -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ֤������ -->
	<xsl:template name="IdType" match="IdType">
		<xsl:choose>
			<xsl:when test=".='0101'">0</xsl:when> <!-- ���֤ -->
			<xsl:when test=".='0102'">0</xsl:when> <!-- ���֤ -->
			<xsl:when test=".='0200'">0</xsl:when> <!-- ���֤ -->
			<xsl:when test=".='0300'">5</xsl:when> <!-- ���ڲ� -->
			<xsl:when test=".='0301'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='0400'">5</xsl:when> <!-- ���ڲ� -->
			<xsl:when test=".='0601'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='0604'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='0700'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='0701'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='0800'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='1000'">1</xsl:when> <!-- ���� -->
			<xsl:when test=".='1202'">1</xsl:when> <!-- ���� -->
			<xsl:when test=".='1100'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1110'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1111'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1112'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1113'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1114'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1120'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1121'">6</xsl:when> <!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test=".='1122'">6</xsl:when> <!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test=".='1123'">7</xsl:when> <!-- ̨�����������½ͨ��֤ -->
			<xsl:when test=".='1300'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='9999'">8</xsl:when> <!-- ���� -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ������Դ ����1/ũ��2 -->
	<xsl:template name="DenizenOrigin" match="DenizenOrigin">
		<xsl:choose>
			<xsl:when test=".=01">1</xsl:when>	<!-- ���� -->
			<xsl:when test=".=02">2</xsl:when>	<!-- ũ�� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �Ƿ��ѷ������� -->
	<xsl:template name="IsRiskEval" match="IsRiskEval">
		<xsl:choose>
			<xsl:when test=".=0">N</xsl:when>	<!-- �� -->
			<xsl:when test=".=1">Y</xsl:when>	<!-- �� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ���� -->
	<xsl:template name="Country" match="Country">
		<xsl:choose>
			<xsl:when test=".='ABW'">AW</xsl:when> <!-- ��³��       -->
			<xsl:when test=".='AFG'">AF</xsl:when> <!-- ������       -->
			<xsl:when test=".='AGO'">AO</xsl:when> <!-- ������       -->
			<xsl:when test=".='AIA'">AI</xsl:when> <!-- ������       -->
			<xsl:when test=".='ALB'">AL</xsl:when> <!-- ����������   -->
			<xsl:when test=".='AND'">AD</xsl:when> <!-- ������       -->
			<xsl:when test=".='ANT'">AN</xsl:when> <!-- ����������˹ -->
			<xsl:when test=".='ARE'">AE</xsl:when> <!-- ������       -->
			<xsl:when test=".='ARG'">AR</xsl:when> <!-- ����͢       -->
			<xsl:when test=".='ARM'">AM</xsl:when> <!-- ��������     -->
			<xsl:when test=".='ASM'">AS</xsl:when> <!-- ����Ħ��     -->
			<xsl:when test=".='ATA'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='ATG'">AG</xsl:when> <!-- ����ϺͰͲ� -->
			<xsl:when test=".='AUS'">AU</xsl:when> <!-- �Ĵ�����     -->
			<xsl:when test=".='AUT'">AT</xsl:when> <!-- �µ���       -->
			<xsl:when test=".='AZE'">AZ</xsl:when> <!-- �����ݽ�     -->
			<xsl:when test=".='BDI'">BI</xsl:when> <!-- ��¡��       -->
			<xsl:when test=".='BEL'">BE</xsl:when> <!-- ����ʱ       -->
			<xsl:when test=".='BEN'">BJ</xsl:when> <!-- ����         -->
			<xsl:when test=".='BFA'">BF</xsl:when> <!-- �����ɷ���   -->
			<xsl:when test=".='BGD'">BD</xsl:when> <!-- �ϼ���       -->
			<xsl:when test=".='BGR'">BG</xsl:when> <!-- ��������     -->
			<xsl:when test=".='BHR'">BH</xsl:when> <!-- ����         -->
			<xsl:when test=".='BHS'">BS</xsl:when> <!-- �͹���       -->
			<xsl:when test=".='BIH'">BA</xsl:when> <!-- ��˹���ǣ��� -->
			<xsl:when test=".='BLR'">BY</xsl:when> <!-- �׶���˹     -->
			<xsl:when test=".='BLZ'">BZ</xsl:when> <!-- ������       -->
			<xsl:when test=".='BMU'">BM</xsl:when> <!-- ��Ľ��       -->
			<xsl:when test=".='BOL'">BO</xsl:when> <!-- ����ά��     -->
			<xsl:when test=".='BRA'">BR</xsl:when> <!-- ����         -->
			<xsl:when test=".='BRB'">BB</xsl:when> <!-- �ͰͶ���     -->
			<xsl:when test=".='BRN'">BN</xsl:when> <!-- ����         -->
			<xsl:when test=".='BTN'">BT</xsl:when> <!-- ����         -->
			<xsl:when test=".='BVT'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='BWA'">BW</xsl:when> <!-- ��������     -->
			<xsl:when test=".='CAF'">CF</xsl:when> <!-- �зǹ��͹�   -->
			<xsl:when test=".='CAN'">CA</xsl:when> <!-- ���ô�       -->
			<xsl:when test=".='CCK'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='CHE'">CH</xsl:when> <!-- ��ʿ         -->
			<xsl:when test=".='CHL'">CL</xsl:when> <!-- ����         -->
			<xsl:when test=".='CHN'">CHN</xsl:when> <!--  �й�        -->
			<xsl:when test=".='CIV'">CI</xsl:when> <!-- ���ص���     -->
			<xsl:when test=".='CMR'">CM</xsl:when> <!-- ����¡       -->
			<xsl:when test=".='COD'">CG</xsl:when> <!-- �չ�����   -->
			<xsl:when test=".='COG'">ZR</xsl:when> <!-- �չ�������   -->
			<xsl:when test=".='COK'">CK</xsl:when> <!-- ���Ⱥ��     -->
			<xsl:when test=".='COL'">CO</xsl:when> <!-- ���ױ���     -->
			<xsl:when test=".='COM'">KM</xsl:when> <!-- ��Ħ��Ⱥ��   -->
			<xsl:when test=".='CPV'">CV</xsl:when> <!-- ��ý�Ⱥ��   -->
			<xsl:when test=".='CRI'">CR</xsl:when> <!-- ��˹�����   -->
			<xsl:when test=".='CUB'">CU</xsl:when> <!-- �Ű�         -->
			<xsl:when test=".='CXR'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='CYM'">KY</xsl:when> <!-- ����Ⱥ��     -->
			<xsl:when test=".='CYP'">CY</xsl:when> <!-- ����·˹     -->
			<xsl:when test=".='CZE'">CZ</xsl:when> <!-- �ݿ˹��͹�   -->
			<xsl:when test=".='DEU'">DE</xsl:when> <!-- �¹�         -->
			<xsl:when test=".='DJI'">DJ</xsl:when> <!-- ������       -->
			<xsl:when test=".='DMA'">DM</xsl:when> <!-- ����������� -->
			<xsl:when test=".='DNK'">DK</xsl:when> <!-- ����         -->
			<xsl:when test=".='DOM'">DO</xsl:when> <!-- ������ӹ��� -->
			<xsl:when test=".='DZA'">DZ</xsl:when> <!-- ����������   -->
			<xsl:when test=".='ECU'">EC</xsl:when> <!-- ��϶��     -->
			<xsl:when test=".='EGY'">EG</xsl:when> <!-- ����         -->
			<xsl:when test=".='ERI'">ER</xsl:when> <!-- ����������   -->
			<xsl:when test=".='ESH'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='ESP'">ES</xsl:when> <!-- ������       -->
			<xsl:when test=".='EST'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='ETH'">ET</xsl:when> <!-- ���������   -->
			<xsl:when test=".='FIN'">FI</xsl:when> <!-- ����         -->
			<xsl:when test=".='FJI'">FJ</xsl:when> <!-- 쳼�         -->
			<xsl:when test=".='FLK'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='FRA'">FR</xsl:when> <!-- ����         -->
			<xsl:when test=".='FSM'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='GAB'">GA</xsl:when> <!-- ����         -->
			<xsl:when test=".='GBR'">GB</xsl:when> <!-- Ӣ��         -->
			<xsl:when test=".='GEO'">GE</xsl:when> <!-- ��³����     -->
			<xsl:when test=".='GHA'">GH</xsl:when> <!-- ����         -->
			<xsl:when test=".='GIB'">GI</xsl:when> <!-- ֱ������     -->
			<xsl:when test=".='GIN'">GN</xsl:when> <!-- ������       -->
			<xsl:when test=".='GLP'">GP</xsl:when> <!-- �ϵ�����     -->
			<xsl:when test=".='GMB'">GM</xsl:when> <!-- �Ա���       -->
			<xsl:when test=".='GNB'">GW</xsl:when> <!-- �����Ǳ���   -->
			<xsl:when test=".='GNQ'">GQ</xsl:when> <!-- ���������   -->
			<xsl:when test=".='GRC'">GR</xsl:when> <!-- ϣ��         -->
			<xsl:when test=".='GRD'">GD</xsl:when> <!-- �����ɴ�     -->
			<xsl:when test=".='GRL'">GL</xsl:when> <!-- ��������     -->
			<xsl:when test=".='GTM'">GT</xsl:when> <!-- Σ������     -->
			<xsl:when test=".='GUF'">GF</xsl:when> <!-- ����������   -->
			<xsl:when test=".='GUM'">GU</xsl:when> <!-- �ص�         -->
			<xsl:when test=".='GUY'">GY</xsl:when> <!-- ������       -->
			<xsl:when test=".='HKG'">CHN</xsl:when> <!--  �й�        -->
			<xsl:when test=".='HMD'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='HND'">HN</xsl:when> <!-- �鶼��˹     -->
			<xsl:when test=".='HRV'">HR</xsl:when> <!-- ���޵���     -->
			<xsl:when test=".='HTI'">HT</xsl:when> <!-- ����         -->
			<xsl:when test=".='HUN'">HU</xsl:when> <!-- ������       -->
			<xsl:when test=".='IDN'">ID</xsl:when> <!-- ӡ��������   -->
			<xsl:when test=".='IND'">IN</xsl:when> <!-- ӡ��         -->
			<xsl:when test=".='IOT'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='IRL'">IE</xsl:when> <!-- ������       -->
			<xsl:when test=".='IRN'">IR</xsl:when> <!-- ����         -->
			<xsl:when test=".='IRQ'">IQ</xsl:when> <!-- ������       -->
			<xsl:when test=".='ISL'">IS</xsl:when> <!-- ����         -->
			<xsl:when test=".='ISR'">IL</xsl:when> <!-- ��ɫ��       -->
			<xsl:when test=".='ITA'">IT</xsl:when> <!-- �����       -->
			<xsl:when test=".='JAM'">JM</xsl:when> <!-- �����       -->
			<xsl:when test=".='JOR'">JO</xsl:when> <!-- Լ��         -->
			<xsl:when test=".='JPN'">JP</xsl:when> <!-- �ձ�         -->
			<xsl:when test=".='KAZ'">KZ</xsl:when> <!-- ������˹̹   -->
			<xsl:when test=".='KEN'">KE</xsl:when> <!-- ������       -->
			<xsl:when test=".='KGZ'">KG</xsl:when> <!-- ������˼     -->
			<xsl:when test=".='KHM'">KH</xsl:when> <!-- ����կ       -->
			<xsl:when test=".='KIR'">KT</xsl:when> <!-- ������˹     -->
			<xsl:when test=".='KNA'">SX</xsl:when> <!-- ʥ���ĺ���ά -->
			<xsl:when test=".='KOR'">KR</xsl:when> <!-- ����         -->
			<xsl:when test=".='KWT'">KW</xsl:when> <!-- ������       -->
			<xsl:when test=".='LAO'">LA</xsl:when> <!-- ����         -->
			<xsl:when test=".='LBN'">LB</xsl:when> <!-- �����       -->
			<xsl:when test=".='LBR'">LR</xsl:when> <!-- ��������     -->
			<xsl:when test=".='LBY'">LY</xsl:when> <!-- ������       -->
			<xsl:when test=".='LCA'">SQ</xsl:when> <!-- ʥ¬����     -->
			<xsl:when test=".='LIE'">LI</xsl:when> <!-- ��֧��ʿ��   -->
			<xsl:when test=".='LKA'">LK</xsl:when> <!-- ˹������     -->
			<xsl:when test=".='LSO'">LS</xsl:when> <!-- ������       -->
			<xsl:when test=".='LTU'">LT</xsl:when> <!-- ������       -->
			<xsl:when test=".='LUX'">LU</xsl:when> <!-- ¬ɭ��       -->
			<xsl:when test=".='LVA'">LV</xsl:when> <!-- ����ά��     -->
			<xsl:when test=".='MAC'">CHN</xsl:when> <!--  �й�        -->
			<xsl:when test=".='MAR'">MA</xsl:when> <!-- Ħ���       -->
			<xsl:when test=".='MCO'">MC</xsl:when> <!-- Ħ�ɸ�       -->
			<xsl:when test=".='MDA'">MD</xsl:when> <!-- Ħ������     -->
			<xsl:when test=".='MDG'">MG</xsl:when> <!-- ����˹��   -->
			<xsl:when test=".='MDV'">MV</xsl:when> <!-- �������     -->
			<xsl:when test=".='MEX'">MX</xsl:when> <!-- ī����       -->
			<xsl:when test=".='MHL'">MH</xsl:when> <!-- ���ٶ�Ⱥ��   -->
			<xsl:when test=".='MKD'">MK</xsl:when> <!-- �����       -->
			<xsl:when test=".='MLI'">ML</xsl:when> <!-- ����         -->
			<xsl:when test=".='MLT'">MT</xsl:when> <!-- �����       -->
			<xsl:when test=".='MMR'">MM</xsl:when> <!-- ���         -->
			<xsl:when test=".='MNG'">MN</xsl:when> <!-- �ɹ�         -->
			<xsl:when test=".='MNP'">MP</xsl:when> <!-- ����������Ⱥ -->
			<xsl:when test=".='MOZ'">MZ</xsl:when> <!-- Īɣ�ȿ�     -->
			<xsl:when test=".='MRT'">MR</xsl:when> <!-- ë��������   -->
			<xsl:when test=".='MSR'">MS</xsl:when> <!-- ����������   -->
			<xsl:when test=".='MTQ'">MQ</xsl:when> <!-- �������     -->
			<xsl:when test=".='MUS'">MU</xsl:when> <!-- ë����˹     -->
			<xsl:when test=".='MWI'">MW</xsl:when> <!-- ����ά       -->
			<xsl:when test=".='MYS'">MY</xsl:when> <!-- ��������     -->
			<xsl:when test=".='MYT'">YT</xsl:when> <!-- ��Լ�ص�     -->
			<xsl:when test=".='NAM'">NA</xsl:when> <!-- ���ױ���     -->
			<xsl:when test=".='NCL'">NC</xsl:when> <!-- �¿�������� -->
			<xsl:when test=".='NER'">NE</xsl:when> <!-- ���ն�       -->
			<xsl:when test=".='NFK'">NF</xsl:when> <!-- ŵ����Ⱥ��   -->
			<xsl:when test=".='NGA'">NG</xsl:when> <!-- ��������     -->
			<xsl:when test=".='NIC'">NI</xsl:when> <!-- �������     -->
			<xsl:when test=".='NIU'">NU</xsl:when> <!-- Ŧ����       -->
			<xsl:when test=".='NLD'">NL</xsl:when> <!-- ����         -->
			<xsl:when test=".='NOR'">NO</xsl:when> <!-- Ų��         -->
			<xsl:when test=".='NPL'">NP</xsl:when> <!-- �Ჴ��       -->
			<xsl:when test=".='NRU'">NR</xsl:when> <!-- �³         -->
			<xsl:when test=".='NZL'">NZ</xsl:when> <!-- ������       -->
			<xsl:when test=".='OWN'">OM</xsl:when> <!-- ����         -->
			<xsl:when test=".='PAK'">PK</xsl:when> <!-- �ͻ�˹̹     -->
			<xsl:when test=".='PAN'">PA</xsl:when> <!-- ������       -->
			<xsl:when test=".='PCN'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='PER'">PE</xsl:when> <!-- ��³         -->
			<xsl:when test=".='PHL'">PH</xsl:when> <!-- ���ɱ�       -->
			<xsl:when test=".='PLW'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='POL'">PL</xsl:when> <!-- ����         -->
			<xsl:when test=".='PRI'">PR</xsl:when> <!-- �������     -->
			<xsl:when test=".='PRK'">KP</xsl:when> <!-- ����         -->
			<xsl:when test=".='PRT'">PT</xsl:when> <!-- ������       -->
			<xsl:when test=".='PRY'">PY</xsl:when> <!-- ������       -->
			<xsl:when test=".='PSE'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='PYF'">PF</xsl:when> <!-- ������������ -->
			<xsl:when test=".='QAT'">QA</xsl:when> <!-- ������       -->
			<xsl:when test=".='REU'">RE</xsl:when> <!-- ��������     -->
			<xsl:when test=".='ROM'">RO</xsl:when> <!-- ��������     -->
			<xsl:when test=".='RUS'">RU</xsl:when> <!-- ����˹       -->
			<xsl:when test=".='RWA'">RW</xsl:when> <!-- ¬����       -->
			<xsl:when test=".='SAU'">SA</xsl:when> <!-- ɳ�ذ�����   -->
			<xsl:when test=".='SCG'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='SDN'">SD</xsl:when> <!-- �յ�         -->
			<xsl:when test=".='SEN'">SN</xsl:when> <!-- ���ڼӶ�     -->
			<xsl:when test=".='SGP'">SG</xsl:when> <!-- �¼���       -->
			<xsl:when test=".='SGS'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='SHN'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='SJM'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='SLB'">SB</xsl:when> <!-- ������Ⱥ��   -->
			<xsl:when test=".='SLE'">SL</xsl:when> <!-- �����ﰺ     -->
			<xsl:when test=".='SLV'">SV</xsl:when> <!-- �����߶�     -->
			<xsl:when test=".='SMR'">SM</xsl:when> <!-- ʥ����ŵ     -->
			<xsl:when test=".='SOM'">SO</xsl:when> <!-- ������       -->
			<xsl:when test=".='SPM'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='STP'">ST</xsl:when> <!-- ʥ���������� -->
			<xsl:when test=".='SUR'">SR</xsl:when> <!-- ������       -->
			<xsl:when test=".='SVK'">SK</xsl:when> <!-- ˹�工��     -->
			<xsl:when test=".='SVN'">SI</xsl:when> <!-- ˹��������   -->
			<xsl:when test=".='SWE'">SE</xsl:when> <!-- ���         -->
			<xsl:when test=".='SWZ'">SZ</xsl:when> <!-- ˹��ʿ��     -->
			<xsl:when test=".='SYC'">SC</xsl:when> <!-- �����       -->
			<xsl:when test=".='SYR'">SY</xsl:when> <!-- ������       -->
			<xsl:when test=".='TCA'">TC</xsl:when> <!-- �ؿ�˹�Ϳ��� -->
			<xsl:when test=".='TCD'">TD</xsl:when> <!-- է��         -->
			<xsl:when test=".='TGO'">TG</xsl:when> <!-- ���         -->
			<xsl:when test=".='THA'">TH</xsl:when> <!-- ̩��         -->
			<xsl:when test=".='TJK'">TJ</xsl:when> <!-- ������˹̹   -->
			<xsl:when test=".='TKL'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='TKM'">TM</xsl:when> <!-- ������˹̹   -->
			<xsl:when test=".='TMP'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='TON'">TO</xsl:when> <!-- ����         -->
			<xsl:when test=".='TTO'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='TUN'">TN</xsl:when> <!-- ͻ��˹       -->
			<xsl:when test=".='TUR'">TR</xsl:when> <!-- ������       -->
			<xsl:when test=".='TUV'">TV</xsl:when> <!-- ͼ��¬       -->
			<xsl:when test=".='TWN'">CHN</xsl:when> <!--  �й�        -->
			<xsl:when test=".='TZA'">TZ</xsl:when> <!-- ̹ɣ����     -->
			<xsl:when test=".='UGA'">UG</xsl:when> <!-- �ڸɴ�       -->
			<xsl:when test=".='UKR'">UA</xsl:when> <!-- �ڿ���       -->
			<xsl:when test=".='UMI'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='URY'">UY</xsl:when> <!-- ������       -->
			<xsl:when test=".='USA'">US</xsl:when> <!-- ����         -->
			<xsl:when test=".='UZB'">UZ</xsl:when> <!-- ���ȱ��˹̹ -->
			<xsl:when test=".='VAT'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='VCT'">VC</xsl:when> <!-- ʥ��˹��     -->
			<xsl:when test=".='VEN'">VE</xsl:when> <!-- ί������     -->
			<xsl:when test=".='VGB'">VG</xsl:when> <!-- Ӣ��ά����Ⱥ -->
			<xsl:when test=".='VIR'">VI</xsl:when> <!-- ����ά����Ⱥ -->
			<xsl:when test=".='VNM'">VN</xsl:when> <!-- Խ��         -->
			<xsl:when test=".='VUT'">VU</xsl:when> <!-- ��Ŭ��ͼ     -->
			<xsl:when test=".='WLF'">OTH</xsl:when> <!--  ����        -->
			<xsl:when test=".='WSM'">WS</xsl:when> <!-- ��Ħ��       -->
			<xsl:when test=".='YEM'">YE</xsl:when> <!-- Ҳ��         -->
			<xsl:when test=".='YUG'">YU</xsl:when> <!-- ��˹����     -->
			<xsl:when test=".='ZAF'">ZA</xsl:when> <!-- �Ϸ�         -->
			<xsl:when test=".='ZMB'">ZM</xsl:when> <!-- �ޱ���       -->
			<xsl:when test=".='ZWE'">ZW</xsl:when> <!-- ��Ͳ�Τ     -->
		</xsl:choose>
	</xsl:template>
	<!-- ����״�� -->
	<xsl:template name="MarStat" match="MarStat">
		<xsl:choose>
			<xsl:when test=".=0">N</xsl:when>	<!-- �� -->
			<xsl:when test=".=1">Y</xsl:when>	<!-- �� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �뱻�����˹�ϵ -->
	<xsl:template name="tran_relaCode_ins">
		<xsl:param name="relaCode" />
		<xsl:choose>
			<xsl:when test="$relaCode='01'">00</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='02'">01</xsl:when> <!-- ��ĸ -->
			<xsl:when test="$relaCode='03'">01</xsl:when> <!-- ��ĸ -->
			<xsl:when test="$relaCode='04'">03</xsl:when> <!-- ��Ů -->
			<xsl:when test="$relaCode='05'">03</xsl:when> <!-- ��Ů -->
			<xsl:when test="$relaCode='06'">02</xsl:when> <!-- ��ż -->
			<xsl:when test="$relaCode='07'">02</xsl:when> <!-- ��ż -->
			<xsl:when test="$relaCode='08'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='09'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='10'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='11'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='12'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='13'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='14'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='15'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='16'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='17'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='18'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='19'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='20'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='21'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='22'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='23'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='24'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='25'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='26'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='27'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='28'">05</xsl:when> <!-- ��Ӷ -->
			<xsl:when test="$relaCode='29'">05</xsl:when> <!-- ��Ӷ -->
			<xsl:when test="$relaCode='30'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='31'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='32'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='33'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='34'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='35'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='36'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='37'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='38'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='39'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='40'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='41'">06</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='42'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='43'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='44'">04</xsl:when> <!-- ���� -->
			<xsl:when test="$relaCode='45'">04</xsl:when> <!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷѷ�ʽ�����У����ɷ�Ƶ�Σ���˾�� -->
	<xsl:template name="PremType" match="PremType">
		<xsl:choose>
			<xsl:when test=".=01">0</xsl:when>	<!-- ����    -->
			<xsl:when test=".=02">1</xsl:when>	<!-- �½�    -->
			<xsl:when test=".=03">3</xsl:when>	<!-- ����    -->
			<xsl:when test=".=04">6</xsl:when>	<!-- �����  -->
			<xsl:when test=".=05">12</xsl:when>	<!-- ��� -->
			<xsl:when test=".=06">-1</xsl:when>	<!-- �����ڽ� -->
			<xsl:when test=".=07"></xsl:when>	  <!-- ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- ��������/�����־ -->
	<xsl:template name="CovTermType" match="CovTermType">
		<xsl:choose>
			<xsl:when test=".=01">A</xsl:when>	<!-- ������        -->
			<xsl:when test=".=02">Y</xsl:when>	<!-- ����          -->
			<xsl:when test=".=03">A</xsl:when>	<!-- ��ĳȷ������  -->
			<xsl:when test=".=04"></xsl:when>	  <!-- ������  -->
			<xsl:when test=".=05">M</xsl:when>	<!-- ���� -->
			<xsl:when test=".=06">D</xsl:when>	<!-- ���� -->
			<xsl:when test=".=99"></xsl:when>	  <!-- ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- �ɷ����� -->
	<xsl:template name="PremTermType" match="PremTermType">
		<xsl:choose>
			<xsl:when test=".=01">Y</xsl:when>	<!-- ����           -->
			<xsl:when test=".=02">Y</xsl:when>	<!-- ����           -->
			<xsl:when test=".=03">A</xsl:when>	<!-- ��ĳȷ������   -->
			<xsl:when test=".=04">A</xsl:when>	<!-- ����      -->        
			<xsl:when test=".=05"></xsl:when>	<!-- �����ڽ� -->
			<xsl:when test=".=06">M</xsl:when>	<!-- ���� -->
			<xsl:when test=".=07"></xsl:when>	  <!-- ���� -->
			<xsl:when test=".=99"></xsl:when>	  <!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ְҵ���� -->
	<xsl:template name="Work" match="Work">
		<xsl:choose>
			<xsl:when test=".='000'">4030111</xsl:when>	<!-- ���ҹ���Ա������ҵ��λ������                                            -->
			<xsl:when test=".='001'">4030111</xsl:when>	<!-- ���ҹ���Ա                                                              -->
			<xsl:when test=".='002'">4030111</xsl:when>	<!-- ��ҵ��λ������                                                          -->
			<xsl:when test=".='003'">4030111</xsl:when>	<!-- ��ҵ������                                                              -->
			<xsl:when test=".='100'">2050101</xsl:when>	<!-- רҵ������Ա                                                            -->
			<xsl:when test=".='101'">2050101</xsl:when>	<!-- ��ѧ�о���Ա                                                            -->
			<xsl:when test=".='102'">2050101</xsl:when>	<!-- ���̼�����Ա                                                            -->
			<xsl:when test=".='103'">2050101</xsl:when>	<!-- ũҵ������Ա                                                            -->
			<xsl:when test=".='104'">2050101</xsl:when>	<!-- �ɻ��ʹ���������Ա                                                      -->
			<xsl:when test=".='105'">2050101</xsl:when>	<!-- ����רҵ������Ա                                                        -->
			<xsl:when test=".='106'">2070109</xsl:when>	<!-- ����ҵ����Ա                                                            -->
			<xsl:when test=".='107'">2070109</xsl:when>	<!-- ����ҵ����Ա                                                            -->
			<xsl:when test=".='108'">2080103</xsl:when>	<!-- ����רҵ��Ա                                                            -->
			<xsl:when test=".='109'">2090104</xsl:when>	<!-- ��ѧ��Ա                                                                -->
			<xsl:when test=".='110'">2100106</xsl:when>	<!-- ��ѧ����������Ա                                                        -->
			<xsl:when test=".='111'">2100106</xsl:when>	<!-- ����������Ա                                                            -->
			<xsl:when test=".='112'">2100106</xsl:when>	<!-- ���ų��桢�Ļ�������Ա                                                  -->
			<xsl:when test=".='113'">2130101</xsl:when>	<!-- �ڽ�ְҵ��                                                              -->
			<xsl:when test=".='114'">2050101</xsl:when>	<!-- ����רҵ������Ա                                                        -->
			<xsl:when test=".='200'">4010101</xsl:when>	<!-- ������Ա���й���Ա                                                      -->
			<xsl:when test=".='201'">4010101</xsl:when>	<!-- �����칫��Ա                                                            -->
			<xsl:when test=".='202'">2020906</xsl:when>	<!-- ��ȫ������������Ա                                                      -->
			<xsl:when test=".='203'">3030101</xsl:when>	<!-- �����͵���ҵ����Ա                                                      -->
			<xsl:when test=".='204'">4010101</xsl:when>	<!-- ����������Ա���й���Ա                                                  -->
			<xsl:when test=".='300'">4010101</xsl:when>	<!-- ��ҵ������ҵ��Ա                                                        -->
			<xsl:when test=".='301'">4010101</xsl:when>	<!-- ������Ա                                                                -->
			<xsl:when test=".='302'">4010101</xsl:when>	<!-- �ִ���Ա                                                                -->
			<xsl:when test=".='303'">4010101</xsl:when>	<!-- ����������Ա                                                            -->
			<xsl:when test=".='304'">4010101</xsl:when>	<!-- ���ꡢ���μ��������ֳ���������Ա                                        -->
			<xsl:when test=".='305'">4010101</xsl:when>	<!-- ���������Ա                                                            -->
			<xsl:when test=".='306'">4010101</xsl:when>	<!-- ҽ����������������Ա                                                    -->
			<xsl:when test=".='307'">4010101</xsl:when>	<!-- ������;������������Ա                                              -->
			<xsl:when test=".='308'">4010101</xsl:when>	<!-- ������ҵ������ҵ��Ա                                                    -->
			<xsl:when test=".='400'">5010107</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա                                          -->
			<xsl:when test=".='401'">5010107</xsl:when>	<!-- ��ֲҵ������Ա                                                          -->
			<xsl:when test=".='402'">5010107</xsl:when>	<!-- ��ҵ������Ұ����ֲ�ﱣ����Ա                                            -->
			<xsl:when test=".='403'">5010107</xsl:when>	<!-- ����ҵ������Ա                                                          -->
			<xsl:when test=".='404'">5010107</xsl:when>	<!-- ��ҵ������Ա                                                            -->
			<xsl:when test=".='405'">5010107</xsl:when>	<!-- ˮ����ʩ����������Ա                                                    -->
			<xsl:when test=".='406'">5010107</xsl:when>	<!-- ����ũ���֡������桢ˮ��ҵ������Ա                                      -->
			<xsl:when test=".='500'">6240105</xsl:when>	<!-- �����������豸������Ա���й���Ա                                        -->
			<xsl:when test=".='501'">2020103</xsl:when>	<!-- ��̽�����￪����Ա                                                      -->
			<xsl:when test=".='502'">6050611</xsl:when>	<!-- ����ұ����������Ա                                                      -->
			<xsl:when test=".='503'">6050611</xsl:when>	<!-- ������Ʒ������Ա                                                        -->
			<xsl:when test=".='504'">6050611</xsl:when>	<!-- ��е����ӹ���Ա                                                        -->
			<xsl:when test=".='505'">6050611</xsl:when>	<!-- �����Ʒװ����Ա                                                        -->
			<xsl:when test=".='506'">6050611</xsl:when>	<!-- ��е�豸������Ա                                                        -->
			<xsl:when test=".='507'">6050611</xsl:when>	<!-- �����豸��װ�����С����޼�������Ա                                      -->
			<xsl:when test=".='508'">6050611</xsl:when>	<!-- ����Ԫ�������豸���졢װ�䡢���Լ�ά����Ա                              -->
			<xsl:when test=".='509'">6050611</xsl:when>	<!-- �𽺺�������Ʒ������Ա                                                  -->
			<xsl:when test=".='510'">6050611</xsl:when>	<!-- ��֯����֯��ӡȾ��Ա                                                    -->
			<xsl:when test=".='511'">6050611</xsl:when>	<!-- �ü������Һ�Ƥ�ëƤ��Ʒ�ӹ�������Ա                                  -->
			<xsl:when test=".='512'">6050611</xsl:when>	<!-- ���͡�ʳƷ�����������ӹ������������ӹ���Ա                              -->
			<xsl:when test=".='513'">6050611</xsl:when>	<!-- �̲ݼ�����Ʒ�ӹ���Ա                                                    -->
			<xsl:when test=".='514'">6050611</xsl:when>	<!-- ҩƷ������Ա                                                            -->
			<xsl:when test=".='515'">6050611</xsl:when>	<!-- ľ�ļӹ��������������ľ��Ʒ�������ƽ�����ֽ��ֽ��Ʒ�����ӹ���Ա        -->
			<xsl:when test=".='516'">6050611</xsl:when>	<!-- ���������������ӹ���Ա                                                  -->
			<xsl:when test=".='517'">6050611</xsl:when>	<!-- �������մɡ��´ɼ�����Ʒ�����ӹ���Ա                                    -->
			<xsl:when test=".='518'">6050611</xsl:when>	<!-- �㲥Ӱ����Ʒ���������ż����ﱣ����ҵ��Ա                                -->
			<xsl:when test=".='519'">6050611</xsl:when>	<!-- ӡˢ��Ա                                                                -->
			<xsl:when test=".='520'">6050611</xsl:when>	<!-- ���ա�����Ʒ������Ա                                                    -->
			<xsl:when test=".='521'">6050611</xsl:when>	<!-- �Ļ�������������Ʒ������Ա                                              -->
			<xsl:when test=".='522'">2020906</xsl:when>	<!-- ����ʩ����Ա                                                            -->
			<xsl:when test=".='523'">6240105</xsl:when>	<!-- �����豸������Ա���й���Ա                                              -->
			<xsl:when test=".='524'">6050611</xsl:when>	<!-- �����������ﴦ����Ա                                                  -->
			<xsl:when test=".='525'">6050611</xsl:when>	<!-- ���顢������Ա                                                          -->
			<xsl:when test=".='526'">6240105</xsl:when>	<!-- ���������������豸������Ա���й���Ա                                    -->
			<xsl:when test=".='600'">7010103</xsl:when>	<!-- ����                                                                    -->
			<xsl:when test=".='700'">4030111</xsl:when>	<!-- ˽Ӫҵ��                                                                -->
			<xsl:when test=".='801'">2090114</xsl:when>	<!-- ѧ��                                                                    -->
			<xsl:when test=".='802'">8010104</xsl:when>	<!-- ��ͥ����                                                                -->
			<xsl:when test=".='803'">8010101</xsl:when>	<!-- ��ҵ��Ա                                                                -->
			<xsl:when test=".='804'">8010102</xsl:when>	<!-- ������Ա                                                                -->
			<xsl:when test=".='805'">2070109</xsl:when>	<!-- ����ְҵ                                                                -->
			<xsl:when test=".='999'"></xsl:when>	<!-- ����           -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
