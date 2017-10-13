<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	
	<xsl:template match="/INSU">
	<xsl:variable name="MainRisk" select="PRODUCTS/PRODUCT[PRODUCTID=MAINPRODUCTID]" />
		<TranData>
			<!-- ������ͷ -->
			<xsl:apply-templates select="MAIN" />
			
			<!-- �������� -->
			<Body>
				<!-- Ͷ����(ӡˢ)�� -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLYNO" />
				</ProposalPrtNo>
				<!-- ������ͬӡˢ�� -->
				<ContPrtNo>
					<xsl:value-of select="MAIN/BD_PRINT_NO" />
				</ContPrtNo>
				<!-- Ͷ������ -->
				<PolApplyDate>
					<xsl:value-of select="MAIN/TB_DATE" />
				</PolApplyDate>
				<!-- �˻����� -->
				<AccName>
					<xsl:value-of select="MAIN/PAYNAME" />
				</AccName>
				<!-- �����˻� -->
				<AccNo>
					<xsl:value-of select="MAIN/PAYACC" />
				</AccNo>
				<!-- �������ͷ�ʽ -->
				<GetPolMode>
					<xsl:apply-templates select="MAIN/SENDMETHOD" />
				</GetPolMode>
				<!-- ְҵ��֪(N/Y) -->
				<JobNotice />
				<!-- ������֪(N/Y)  -->
				<HealthNotice>
					<xsl:apply-templates select="MAIN/HEALTHTAG" />
				</HealthNotice>
				
				<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
				<PolicyIndicator />
				<!--�ۼ�Ͷ����ʱ��� �������ֶαȽ����⣬��λ�ǰ�Ԫ-->
				<InsuredTotalFaceAmount />
				
				<!-- ����Ա���� -->
				<SellerNo><xsl:value-of select="MAIN/REMARK1" /></SellerNo>
				<!-- ����Ա������ -->
				<TellerName />
				<!-- ����������Ա�ʸ�֤ -->
				<TellerCertiCode />
				<!-- �������� -->
				<AgentComName />
				
				<!-- ��Ʒ��� -->
				<ContPlan>
					<!-- ��Ʒ��ϱ��� -->
					<ContPlanCode>
						<xsl:call-template name="tran_ContPlanCode">
							<xsl:with-param name="contPlanCode">
								<xsl:value-of select="$MainRisk/PRODUCTID" />
							</xsl:with-param>
						</xsl:call-template>
					</ContPlanCode>
					<!-- ��Ʒ��Ϸ��� -->
					<ContPlanMult>
						<xsl:value-of select="$MainRisk/AMT_UNIT" />
					</ContPlanMult>
				</ContPlan>
				
				<!-- Ͷ���� -->
				<xsl:apply-templates select="TBR" />
	
				<!-- ������ -->
				<xsl:apply-templates select="BBR" />
	
				<!-- ������ -->
				<xsl:apply-templates select="SYRS/SYR" />
	
				<!-- ������Ϣ -->
				<xsl:apply-templates select="PRODUCTS/PRODUCT" />
				
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- ����ͷ����ת�� -->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<!-- �������ڣ�yyyymmdd�� -->
			<TranDate>
				<xsl:value-of select="BANK_DATE" />
			</TranDate>
			<!-- ����ʱ�� ��hhmmss��-->
			<TranTime>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/>
			</TranTime>
			<!-- ��Ա-->
			<TellerNo>
				<xsl:value-of select="TELLERNO" />
			</TellerNo>
			<!-- ��ˮ��-->
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<!-- ������+������-->
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<!-- ���б�ţ����Ķ��壩-->
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>
	
	<!-- Ͷ������Ϣ -->
	<xsl:template name="Appnt" match="TBR"> 
		<Appnt>
			<!-- ���� -->
			<Name>
				<xsl:value-of select="TBR_NAME" />
			</Name>
			<!-- �Ա� -->
			<Sex>
				<xsl:apply-templates select="TBR_SEX" />
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="TBR_BIRTH" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:apply-templates select="TBR_IDTYPE" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="TBR_IDNO" />
			</IDNo>
			<!-- ֤����Ч���� -->
			<IDTypeStartDate>
				<xsl:value-of select="TBR_IDEFFSTARTDATE" />
			</IDTypeStartDate>
			<!-- ֤����Чֹ�� -->
			<IDTypeEndDate>
				<xsl:value-of select="TBR_IDEFFENDDATE" />
			</IDTypeEndDate>
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode" select="TBR_OCCUTYPE" />
				</xsl:call-template>
			</JobCode>
			<!-- ������ -->
			<Salary>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_REMARK1)" />
			</Salary>
			<!-- ��ͥ������ -->
			<FamilySalary />
			<!-- �ͻ����� -->
			<LiveZone />
			<!--���ղ�������Ƿ��ʺ�Ͷ���������3�������Ӹ��ֶΡ�Y��N��-->
			<RiskAssess />
			<!-- ���� -->
			<Nationality>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="TBR_NATIVEPLACE" />
					<xsl:with-param name="iDType" select="TBR_IDTYPE" />
				</xsl:call-template>
			</Nationality>
			<!-- ���(cm) -->
			<Stature />
			<!-- ����(kg) -->
			<Weight />
			<!-- ���(N/Y) -->
			<MaritalStatus />
			<!-- ��ַ -->
			<Address>
				<xsl:value-of select="TBR_ADDR" />
			</Address>
			<!-- �ʱ� -->
			<ZipCode>
				<xsl:value-of select="TBR_POSTCODE" />
			</ZipCode>
			<!-- �ƶ��绰 -->
			<Mobile>
				<xsl:value-of select="TBR_MOBILE" />
			</Mobile>
			<!-- �̶��绰 -->
			<Phone>
				<xsl:value-of select="TBR_TEL" />
			</Phone>
			<!-- �����ʼ�-->
			<Email>
				<xsl:value-of select="TBR_EMAIL" />
			</Email>
			<!-- �뱻���˹�ϵ -->
			<RelaToInsured>
				<xsl:apply-templates select="TBR_BBR_RELA" />
			</RelaToInsured>
		</Appnt>
	</xsl:template>
	
	<!-- ��������Ϣ -->
	<xsl:template name="Insured" match="BBR">
		<Insured>
			<!-- ���� -->
			<Name>
				<xsl:value-of select="BBR_NAME" />
			</Name>
			<!-- �Ա� -->
			<Sex>
				<xsl:apply-templates select="BBR_SEX" />
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="BBR_BIRTH" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:apply-templates select="BBR_IDTYPE" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="BBR_IDNO" />
			</IDNo>
			
			<!-- ֤����Ч���� -->
			<IDTypeStartDate>
				<xsl:value-of select="BBR_IDEFFSTARTDATE" />
			</IDTypeStartDate>
			<!-- ֤����Чֹ�� -->
			<IDTypeEndDate>
				<xsl:value-of select="BBR_IDEFFENDDATE" />
			</IDTypeEndDate>
			
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode" select="BBR_OCCUTYPE" />
				</xsl:call-template>
			</JobCode>
			<!-- ���(cm)-->
			<Stature />
			<!-- ����-->
			<Nationality>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="BBR_NATIVEPLACE" />
					<xsl:with-param name="iDType" select="BBR_IDTYPE" />
				</xsl:call-template>
			</Nationality>
			<!-- ����(kg) -->
			<Weight />
			<!-- ���(N/Y) -->
			<MaritalStatus />
			<!-- ��ַ -->
			<Address>
				<xsl:value-of select="BBR_ADDR" />
			</Address>
			<!-- �ʱ� -->
			<ZipCode>
				<xsl:value-of select="BBR_POSTCODE" />
			</ZipCode>
			<!-- �ƶ��绰 -->
			<Mobile>
				<xsl:value-of select="BBR_MOBILE" />
			</Mobile>
			<!-- �̶��绰 -->
			<Phone>
				<xsl:value-of select="BBR_TEL" />
			</Phone>
			<!-- �����ʼ�-->
			<Email>
				<xsl:value-of select="BBR_EMAIL" />
			</Email>
		</Insured>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Bnf" match="SYRS/SYR">
		<Bnf>
			<!-- Ĭ��Ϊ��1-��������ˡ� -->
			<Type>1</Type>
			<!-- ����˳�� -->
			<Grade>
				<xsl:value-of select="SYR_ORDER" />
			</Grade>
			<!-- ���� -->
			<Name>
				<xsl:value-of select="SYR_NAME" />
			</Name>
			<!-- �Ա� -->
			<Sex>
				<xsl:apply-templates select="SYR_SEX" />
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="SYR_BIRTH" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:apply-templates select="SYR_IDTYPE" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="SYR_IDNO" />
			</IDNo>
			<!-- �뱻���˹�ϵ -->
			<RelaToInsured>
				<xsl:apply-templates select="SYR_BBR_RELA" />
			</RelaToInsured>
			<!-- ����-->
			<Nationality>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="SYR_NATIVEPLACE" />
					<xsl:with-param name="iDType" select="SYR_IDTYPE" />
				</xsl:call-template>
			</Nationality>
			<!-- �������(�������ٷֱ�) -->
			<Lot>
				<xsl:value-of select="SYR_PCT" />
			</Lot>
		</Bnf>
	</xsl:template>
	
	<!-- ��Ʒ��Ϣ -->
	<xsl:template name="Risk" match="PRODUCTS/PRODUCT">
		<Risk>
			<!-- ���ִ��� -->
			<RiskCode>
				<xsl:call-template name="tran_risk">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
			</RiskCode>
			<!-- �������ִ��� -->
			<MainRiskCode>
				<xsl:call-template name="tran_risk">
					<xsl:with-param name="riskcode" select="MAINPRODUCTID" />
				</xsl:call-template>
			</MainRiskCode>
			
			<!-- ����(��) -->
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMNT)" />
			</Amnt>
			<!-- ���շ�(��) -->
			<Prem>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIUM)" />
			</Prem>
			<!-- Ͷ������ -->
			<Mult>
				<xsl:value-of select="AMT_UNIT" />
			</Mult>
			<!-- �ɷ�Ƶ�� -->
			<PayIntv>
				<xsl:apply-templates select="../../MAIN/PAYMETHOD" />
			</PayIntv>
			<!-- �ɷ���ʽ:A=����ͨ����ת�� -->
			<PayMode>A</PayMode>
			
			<!-- �������������־ -->
			<InsuYearFlag>
				<xsl:apply-templates select="COVERAGE_PERIOD" />
			</InsuYearFlag>
			<!-- ������������ -->
			<InsuYear>
				<xsl:if test="COVERAGE_PERIOD='1'">106</xsl:if><!-- ������ -->
				<xsl:if test="COVERAGE_PERIOD!='1'">
					<xsl:value-of select="COVERAGE_YEAR" />
				</xsl:if>
			</InsuYear>
			<!-- �ɷ����������־ -->
			<xsl:choose>
				<xsl:when test="CHARGE_PERIOD = '5'">
					<!-- ���� -->
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:when test="CHARGE_PERIOD = '8'">
					<!-- ����ɷ� -->
					<PayEndYearFlag>A</PayEndYearFlag>
					<PayEndYear>106</PayEndYear>
				</xsl:when>
				<xsl:otherwise>
					<!-- �����ɷ����� -->
					<PayEndYearFlag>
						<xsl:apply-templates select="CHARGE_PERIOD" />
					</PayEndYearFlag>
					<PayEndYear>
						<xsl:value-of select="CHARGE_YEAR" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>

			<!-- ������ȡ��ʽ -->
			<BonusGetMode>
				<xsl:apply-templates select="DVDMETHOD" />
			</BonusGetMode>
			<!-- ������ȡ����ȡ��ʽ -->
			<FullBonusGetMode />
			<!-- ��ȡ�������ڱ�־ -->
			<GetYearFlag />
			<!-- ��ȡ���� -->
			<GetYear>
				<xsl:value-of select="REVAGE" />
			</GetYear>
			<!-- ��ȡ��ʽ -->
			<GetIntv>
				<xsl:apply-templates select="REVMETHOD" />
			</GetIntv>
			<!-- ��ȡ���б��� -->
			<GetBankCode />
			<!-- ��ȡ�����˻� -->
			<GetBankAccNo />
			<!-- ��ȡ���л��� -->
			<GetAccName />
			<!-- �Զ��潻��־ -->
			<AutoPayFlag>
				<xsl:apply-templates select="ALFLAG" />
			</AutoPayFlag>
		</Risk>
	</xsl:template>
	
	<!-- ������������,���ģ�1=�ʼģ�2=���й�����ȡ�����У�1=���ŷ��ͣ�2=�ʼģ�3=���ŵ��ͣ�4=���й�̨ -->
	<xsl:template match="SENDMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'"></xsl:when>
			<xsl:when test=".='2'">1</xsl:when>
			<xsl:when test=".='3'"></xsl:when>
			<xsl:when test=".='4'">2</xsl:when>
			<xsl:otherwise></xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ������֪�����ģ�N=�ޣ�Y=�У����У�0=�ޣ�1=�� -->
	<xsl:template match="HEALTHTAG">
		<xsl:choose>
			<xsl:when test=".='0'">N</xsl:when>
			<xsl:when test=".='1'">Y</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- �Ա𣬺��ģ�0=���ԣ�1=Ů�ԣ����У�1 �У�2 Ů��3 ��ȷ�� -->
	<xsl:template match="TBR_SEX|BBR_SEX|SYR_SEX">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">1</xsl:when><!-- Ů�� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤������ -->
	<!-- ����֤�����ͣ�51�������֤����ʱ���֤,52���������,53���ڲ�,54��������������Ч֤��,55�۰ľ��������ڵ�ͨ��֤,56���˻��侯���֤��,57ʿ��֤,58����֤,59��ְ�ɲ�֤,60��������֤,61��ְ�ɲ�����֤,62�侯���֤��,63�侯ʿ��֤,64����֤,65�侯��ְ�ɲ�֤,66�侯��������֤,67�侯��ְ�ɲ�����֤,98����,99���пͻ�����֤�� -->
	<xsl:template match="TBR_IDTYPE|BBR_IDTYPE|SYR_IDTYPE">
		<xsl:choose>
			<xsl:when test=".='51'">0</xsl:when><!-- ���֤ -->
			<xsl:when test=".='52'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='56'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='57'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='58'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='60'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='62'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='63'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='64'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='65'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='66'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='67'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='53'">5</xsl:when><!-- ���ڲ� -->
			<xsl:when test=".='98'">8</xsl:when><!-- ���� -->
			<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ְҵ���� -->
	<xsl:template name="tran_jobcode">
		<xsl:param name="jobcode" />
		<xsl:choose>
			<xsl:when test="$jobcode='A'">4030111</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
			<xsl:when test="$jobcode='B'">2050101</xsl:when>	<!-- ����רҵ������Ա -->
			<xsl:when test="$jobcode='C'">2070109</xsl:when>	<!-- ����ҵ����Ա -->
			<xsl:when test="$jobcode='D'">2080103</xsl:when>	<!-- ����רҵ��Ա -->
			<xsl:when test="$jobcode='E'">2090104</xsl:when>	<!-- ��ѧ��Ա -->
			<xsl:when test="$jobcode='F'">2100106</xsl:when>	<!-- ���ų��漰��ѧ����������Ա -->
			<xsl:when test="$jobcode='G'">2130101</xsl:when>	<!-- �ڽ�ְҵ�� -->
			<xsl:when test="$jobcode='H'">3030101</xsl:when>	<!-- �����͵���ҵ����Ա -->
			<xsl:when test="$jobcode='I'">4010101</xsl:when>	<!-- ��ҵ������ҵ��Ա -->
			<xsl:when test="$jobcode='J'">5010107</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test="$jobcode='K'">6240105</xsl:when>	<!-- ������Ա -->
			<xsl:when test="$jobcode='L'">2020103</xsl:when>	<!-- ��ַ��̽��Ա -->
			<xsl:when test="$jobcode='M'">2020906</xsl:when>	<!-- ����ʩ����Ա -->
			<xsl:when test="$jobcode='N'">6050611</xsl:when>	<!-- �ӹ����졢���鼰������Ա -->
			<xsl:when test="$jobcode='O'">7010103</xsl:when>	<!-- ���� -->
			<xsl:when test="$jobcode='P'">8010101</xsl:when>	<!-- ��ҵ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �������� -->
	<xsl:template name="tran_nativeplace">
		<xsl:param name="nativeplace" />
		<xsl:param name="iDType" />
		<xsl:choose>
			<xsl:when test="$nativeplace='' and $iDType='51'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='53'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='56'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='57'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='58'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='59'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='60'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='61'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='62'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='63'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='64'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='65'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='66'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='' and $iDType='67'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='51'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='53'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='56'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='57'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='58'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='59'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='60'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='61'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='62'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='63'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='64'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='65'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='66'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0999' and $iDType='67'">CHN</xsl:when><!-- �й� -->
			<xsl:when test="$nativeplace='0156'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='0344'">CHN</xsl:when>	<!-- �й���� -->
			<xsl:when test="$nativeplace='0158'">CHN</xsl:when>	<!-- �й�̨�� -->
			<xsl:when test="$nativeplace='0446'">CHN</xsl:when>	<!-- �й����� -->
			<xsl:when test="$nativeplace='0392'">JP</xsl:when>	<!-- �ձ� -->
			<xsl:when test="$nativeplace='0840'">US</xsl:when>	<!-- ���� -->
			<xsl:when test="$nativeplace='0643'">RU</xsl:when>	<!-- ����˹ -->
			<xsl:when test="$nativeplace='0826'">GB</xsl:when>	<!-- Ӣ�� -->
			<xsl:when test="$nativeplace='0250'">FR</xsl:when>	<!-- ���� -->
			<xsl:when test="$nativeplace='0276'">DE</xsl:when>	<!-- �¹� -->
			<xsl:when test="$nativeplace='0410'">KR</xsl:when>	<!-- ���� -->
			<xsl:when test="$nativeplace='0702'">SG</xsl:when>	<!-- �¼��� -->
			<xsl:when test="$nativeplace='0360'">ID</xsl:when>	<!-- ӡ�������� -->
			<xsl:when test="$nativeplace='0356'">IN</xsl:when>	<!-- ӡ�� -->
			<xsl:when test="$nativeplace='0380'">IT</xsl:when>	<!-- ����� -->
			<xsl:when test="$nativeplace='0458'">MY</xsl:when>	<!-- �������� -->
			<xsl:when test="$nativeplace='0764'">TH</xsl:when>	<!-- ̩�� -->
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Ͷ���ˡ������˹�ϵ�������ˡ������˹�ϵ -->
	<!-- ���ģ�00 ����,01 ��ĸ,02 ��ż,03 ��Ů,04 ����,05 ��Ӷ,06 ����,07 ����,08 ���� -->	
	<xsl:template match="TBR_BBR_RELA|SYR_BBR_RELA">
		<xsl:choose>
			<xsl:when test=".='1'">00</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">02</xsl:when><!-- �ɷ� -->
			<xsl:when test=".='3'">02</xsl:when><!-- ���� -->
			<xsl:when test=".='4'">01</xsl:when><!-- ���� -->
			<xsl:when test=".='5'">01</xsl:when><!-- ĸ�� -->
			
			<xsl:when test=".='6'">03</xsl:when><!-- ���� -->
			<xsl:when test=".='7'">03</xsl:when><!-- Ů�� -->
			<xsl:when test=".='8'">04</xsl:when><!-- �游 -->
			<xsl:when test=".='9'">04</xsl:when><!-- ��ĸ -->
			<xsl:when test=".='10'">04</xsl:when><!-- ���� -->
			<xsl:when test=".='11'">04</xsl:when><!-- ��Ů -->
			<xsl:when test=".='12'">04</xsl:when><!-- ���游 -->
			<xsl:when test=".='13'">04</xsl:when><!-- ����ĸ -->
			<xsl:when test=".='14'">04</xsl:when><!-- ���� -->
			<xsl:when test=".='15'">04</xsl:when><!-- ����Ů -->
			<xsl:when test=".='16'">04</xsl:when><!-- ��� -->
			<xsl:when test=".='17'">04</xsl:when><!-- ��� -->
			<xsl:when test=".='18'">04</xsl:when><!-- �ܵ� -->
			<xsl:when test=".='19'">04</xsl:when><!-- ���� -->
			<xsl:when test=".='20'">04</xsl:when><!-- ���� -->
			<xsl:when test=".='21'">04</xsl:when><!-- ���� -->
			<xsl:when test=".='22'">04</xsl:when><!-- ��ϱ -->
			<xsl:when test=".='23'">04</xsl:when><!-- ���� -->
			<xsl:when test=".='24'">04</xsl:when><!-- ��ĸ -->
			<xsl:when test=".='25'">04</xsl:when><!-- Ů�� -->
			<xsl:when test=".='26'">04</xsl:when><!-- �������� -->
			<xsl:when test=".='27'">04</xsl:when><!-- ͬ�� -->
			<xsl:when test=".='28'">04</xsl:when><!-- ���� -->
			<xsl:when test=".='29'">05</xsl:when><!-- ���� -->
			<xsl:when test=".='30'">04</xsl:when><!-- ���� -->
			<xsl:otherwise>04</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ��Ʒ��ϴ��� -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����, �����գ�122047 - ����ӳ�����Ӯ��ȫ���� , 122048-����������������գ������ͣ�-->
			<!-- 50015-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����, �����գ�122047 - ����ӳ�����Ӯ��ȫ���� , L12081-����������������գ������ͣ�-->
			<xsl:when test="$contPlanCode='50002'">50015</xsl:when>
			<!-- 50012-����ٰ���5�ű��ռƻ� ���գ�L12070 - ����ٰ���5������գ������գ�L12071 - ����ӳ�������5����ȫ���գ������ͣ� -->
			<xsl:when test="$contPlanCode='50012'">50012</xsl:when>
			<!-- 50011-����ٰ���3�ű��ռƻ� ���գ�L12068 - ����ٰ���3������գ������գ�L12069 - ����ӳ�������3����ȫ���գ������ͣ� -->
			<xsl:when test="$contPlanCode='50011'">50011</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<!-- ���ִ��� -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- ����ʢ��1���������գ������ͣ� -->
			<xsl:when test="$riskcode='122012'">L12079</xsl:when>	<!--����ʢ��2���������գ������ͣ� -->
			<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
			<!-- xsl:when test="$riskcode='122010'">L12078</xsl:when> -->	<!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='50002'">50015</xsl:when>	    <!-- �������Ӯ���ռƻ� -->
			<!-- add 20150807 ���Ӱ���3�źͰ���5�Ų�Ʒ  begin -->
			<xsl:when test="$riskcode='50011'">50011</xsl:when>	    <!--����ٰ���3�ű��ռƻ� -->
			<xsl:when test="$riskcode='50012'">50012</xsl:when>	    <!--����ٰ���5�ű��ռƻ� -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			<!-- add 20150807 ���Ӱ���3�źͰ���5�Ų�Ʒ  end -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ�  -->
			<xsl:when test="$riskcode='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when><!-- �����9����ȫ���գ������ͣ�  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�Ƶ�� -->
	<!-- ���У�1 �꽻��2 ���꽻��3 ������4 �½���5 ������6 �����ڽ���7 ����ĳȷ�����䣬8 �����ɷ� -->
	<xsl:template match="PAYMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">12</xsl:when><!-- ��� -->
			<xsl:when test=".='2'">6</xsl:when><!-- ���꽻 -->
			<xsl:when test=".='3'">3</xsl:when><!-- ����-->
			<xsl:when test=".='4'">1</xsl:when><!-- �½� -->
			<xsl:when test=".='5'">0</xsl:when><!-- ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ������������ -->
	<!-- ���У�0 �޹أ�1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">A</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">Y</xsl:when><!-- ���� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳ���� -->
			<xsl:when test=".='4'">M</xsl:when><!-- ���� -->
			<xsl:when test=".='5'">D</xsl:when><!-- ���� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ����������־ -->
	<!-- ���У�1 ��ɣ�2 ����ɣ�3 ���ɣ�4 �½ɣ�5 ���ɣ� 6 �����ڽɣ� 7 ����ĳȷ�����䣬 8 �����ɷ� -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- �����޽� -->
			<xsl:when test=".='4'">M</xsl:when><!-- �����޽� -->
			<xsl:when test=".='5'">Y</xsl:when><!-- ���� -->
			<xsl:when test=".='7'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='8'">A</xsl:when><!-- �����ɷ� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- ������ȡ��ʽ -->
	<!-- ���У�0 �ֽ���� ��1�ֽ����� �� 2�ۼ���Ϣ�� 3 ����� -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='0'">4</xsl:when><!-- ֱ�Ӹ���  -->
			<xsl:when test=".='1'">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test=".='2'">1</xsl:when><!-- �ۼ���Ϣ -->
			<xsl:when test=".='3'">5</xsl:when><!-- ����� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ��ȡ��ʽ -->
	<!-- ���У�1���� ��  2���� ��  3���죨һ������ȡ����4������ 5�������� -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">12</xsl:when><!--���� -->
			<xsl:when test=".='3'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='4'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='5'">6</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �潻��־ ���У�1�潻��0�ǵ�� -->
	<xsl:template match="ALFLAG">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- �� -->
			<xsl:when test=".='1'">1</xsl:when><!-- �� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

