<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/INSUREQ">
		<TranData>

			<!-- ����ͷ -->
			<xsl:apply-templates select="MAIN" />

			<!-- ������ -->
			<Body>
				<!-- �˴���������ͨ�ݴ�����Ͷ������ˮ�� -->
				<OldLogNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</OldLogNo>
				<!-- Ͷ����(ӡˢ)�� -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<!-- ������ͬӡˢ�� -->
				<ContPrtNo></ContPrtNo>
				<!-- Ͷ������ -->
				<PolApplyDate>
					<xsl:value-of select="MAIN/TRANSRDATE" />
				</PolApplyDate>
				<!-- �˻����� -->
				<AccName>
					<xsl:value-of select="ACCOUNT_INFO/PAY_IN_ACC_NAME" />
				</AccName>
				<!-- �����˻� -->
				<AccNo>
					<xsl:value-of select="ACCOUNT_INFO/PAY_IN_ACC" />
				</AccNo>
				<!-- �������ͷ�ʽ -->
				<GetPolMode />
				<!-- ������������1��ֽ�Ʊ���2�����ӱ��� -->
				<PolicyDeliveryMethod>2</PolicyDeliveryMethod>
				<!-- ְҵ��֪(N/Y) -->
				<JobNotice>
					<xsl:value-of
						select="OCCUPATION_NOTICE/NOTICE_ITEM" />
				</JobNotice>
				<!-- ������֪(N/Y)  -->
				<HealthNotice>
					<xsl:value-of select="HEALTH_NOTICE/NOTICE_ITEM" />
				</HealthNotice>

				<!-- ����Ա���� -->
				<SellerNo>
					<xsl:value-of select="MAIN/MANAGERNO" />
				</SellerNo>
				<!-- ����Ա������ -->
				<TellerName>
					<xsl:value-of select="MAIN/MANAGERNAME" />
				</TellerName>
				<!-- �������� -->
				<AgentComName>
					<xsl:value-of select="MAIN/BRANCHNAME" />
				</AgentComName>

				<!-- ��Ʒ��� -->
				<ContPlan>
					<!-- ��Ʒ��ϱ��� -->
					<ContPlanCode>
						<xsl:apply-templates
							select="PRODUCTS/PRODUCT[MAINSUBFLAG='0']/PRODUCTID" mode="plan" />
					</ContPlanCode>
					<!-- ��Ʒ��Ϸ��� -->
					<ContPlanMult>
						<xsl:value-of
							select="PRODUCTS/PRODUCT[MAINSUBFLAG='0']/AMT_UNIT" />
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

	<!-- ����ͷ -->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<!-- �������ڣ�yyyymmdd�� -->
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<!-- ����ʱ�� ��hhmmss��-->
			<TranTime>
				<xsl:value-of select="TRANSRTIME" />
			</TranTime>
			<!-- ��Ա-->
			<TellerNo>sys</TellerNo>
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
			<SourceType>1</SourceType><!-- 0=����ͨ���桢1=������8=�����ն� -->
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

	<!-- Ͷ���� -->
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
			<IDTypeStartDate>
				<xsl:value-of select="TBR_IDEFFSTARTDATE" />
			</IDTypeStartDate><!-- ֤����Ч���� -->
			<IDTypeEndDate>
				<xsl:value-of select="TBR_IDEFFENDDATE" />
			</IDTypeEndDate><!-- ֤����Чֹ�� -->
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:value-of select="TBR_WORKCODE" />
			</JobCode>
			<!-- ������ -->
			<Salary>
				<xsl:value-of select="TBR_AVR_SALARY" />
			</Salary>
			<!-- ��ͥ������ -->
			<FamilySalary></FamilySalary>
			<!-- �ͻ����� -->
			<LiveZone>
				<xsl:apply-templates select="TBR_RESIDENTSOURCE" />
			</LiveZone>
			<!-- ���� -->
			<Nationality>
				<xsl:value-of select="TBR_NATIVEPLACE" />
			</Nationality>
			<!-- ���(cm) -->
			<Stature></Stature>
			<!-- ����(kg) -->
			<Weight></Weight>
			<!-- ���(N/Y) -->
			<MaritalStatus></MaritalStatus>
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

	<!-- ������ -->
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
			<IDTypeStartDate>
				<xsl:value-of select="BBR_IDEFFSTARTDATE" />
			</IDTypeStartDate><!-- ֤����Ч���� -->
			<IDTypeEndDate>
				<xsl:value-of select="BBR_IDEFFENDDATE" />
			</IDTypeEndDate><!-- ֤����Чֹ�� -->
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:value-of select="BBR_WORKCODE" />
			</JobCode>
			<!-- ���(cm)-->
			<Stature></Stature>
			<!-- ����-->
			<Nationality>
				<xsl:value-of select="BBR_NATIVEPLACE" />
			</Nationality>
			<!-- ����(kg) -->
			<Weight></Weight>
			<!-- ���(N/Y) -->
			<MaritalStatus></MaritalStatus>
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
		<xsl:if test="SYR_NAME != ''">
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
				<!-- �������(�������ٷֱ�) -->
				<Lot>
					<xsl:value-of select="BNFT_PROFIT_PCENT" />
				</Lot>
			</Bnf>
		</xsl:if>
	</xsl:template>

	<!-- ������Ϣ  -->
	<xsl:template name="Risk" match="PRODUCTS/PRODUCT">
		<Risk>
			<!-- ���ִ��� -->
			<RiskCode>
				<xsl:apply-templates select="PRODUCTID" mode="risk" />
			</RiskCode>
			<!-- �������ִ��� -->
			<MainRiskCode>
				<xsl:apply-templates
					select="../PRODUCT[MAINSUBFLAG='0']/PRODUCTID" mode="risk" />
			</MainRiskCode>
			<!-- ����(��) -->
			<Amnt>
				<xsl:value-of select="AMOUNT" />
			</Amnt>
			<!-- ���շ�(��) -->
			<Prem>
				<xsl:value-of select="PREMIUM" />
			</Prem>
			<!-- Ͷ������ -->
			<Mult>
				<xsl:value-of select="AMT_UNIT" />
			</Mult>
			<!-- �ɷ�Ƶ�� -->
			<PayIntv>
				<xsl:apply-templates select="//PAYMETHOD" />
			</PayIntv>
			<!-- �ɷ���ʽ -->
			<PayMode></PayMode>
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
				<xsl:when
					test="CHARGE_PERIOD = '1' or CHARGE_PERIOD = '4'">
					<!-- ���������� -->
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
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
			<FullBonusGetMode></FullBonusGetMode>
			<!-- ��ȡ�������ڱ�־ -->
			<GetYearFlag></GetYearFlag>
			<!-- ��ȡ���� -->
			<GetYear>
				<xsl:value-of select="REVAGE" />
			</GetYear>
			<!-- ��ȡ��ʽ -->
			<GetIntv>
				<xsl:apply-templates select="REVMETHOD" />
			</GetIntv>
			<!-- ��ȡ���б��� -->
			<GetBankCode></GetBankCode>
			<!-- ��ȡ�����˻� -->
			<GetBankAccNo>
				<xsl:value-of select="//ACCOUNT_INFO/PAY_OUT_ACC" />
			</GetBankAccNo>
			<!-- ��ȡ���л��� -->
			<GetAccName>
				<xsl:value-of select="//ACCOUNT_INFO/PAY_OUT_ACC_NAME" />
			</GetAccName>
			<!-- �Զ��潻��־ -->
			<AutoPayFlag>
				<xsl:apply-templates select="ALFLAG" />
			</AutoPayFlag>
		</Risk>
	</xsl:template>

	<!-- �Ա� -->
	<!-- �㷢��1 �У�2 Ů��3 ��ȷ�� -->
	<!-- ���ģ�0 �У�1 Ů -->
	<xsl:template match="TBR_SEX|BBR_SEX|SYR_SEX">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">1</xsl:when><!-- Ů�� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ֤������ -->
	<!-- �㷢��1 ���֤��2 ����֤��3 ���գ�4 ����֤��5 ���� -->
	<!-- ���ģ�0	�������֤,1 ����,2 ����֤,3 ����,4 ����֤��,5	���ڲ�,8	����,9	�쳣���֤ -->
	<xsl:template match="TBR_IDTYPE|BBR_IDTYPE|SYR_IDTYPE">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- ���֤ -->
			<xsl:when test=".='2'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='3'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='4'">4</xsl:when><!-- ����֤ -->
			<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>

	<!-- Ͷ����/�������뱻���˹�ϵ -->
	<!-- �㷢��1 ��ż��2 ��ĸ��3 ��Ů��4 ������5 ���ˣ�6 ���� ��Ϊ���������ʱ��5��ָ���������� -->
	<!-- ���ģ�00 ����,01 ��ĸ,02 ��ż,03 ��Ů,04 ����,05 ��Ӷ,06 ����,07 ����,08 ���� -->
	<xsl:template match="TBR_BBR_RELA|SYR_BBR_RELA">
		<xsl:choose>
			<xsl:when test=".='1'">02</xsl:when><!-- ��ż -->
			<xsl:when test=".='2'">01</xsl:when><!-- ��ĸ -->
			<xsl:when test=".='3'">03</xsl:when><!-- ��Ů -->
			<xsl:when test=".='4'">04</xsl:when><!-- ���� -->
			<xsl:when test=".='5'">00</xsl:when><!-- ���� -->
			<xsl:when test=".='6'">04</xsl:when><!-- ���� -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�Ƶ�� -->
	<!-- �㷢��1 �꽻��2 ���꽻��3 ������4 �½���5 ���� -->
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

	<!-- ��ȡ��ʽ -->
	<!-- �㷢��1 ���죬2 ���죬3 ���� -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">12</xsl:when><!--���� -->
			<xsl:when test=".='3'">0</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �����������ڱ�־ -->
	<!-- �㷢��0 �޹أ�1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='5'">D</xsl:when><!-- ���� -->
			<xsl:when test=".='4'">M</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">Y</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">A</xsl:when><!-- ���� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ����������־ -->
	<!-- �㷢��0 �޹أ�1 ������2 �����޽���3 ����ĳȷ�����䣬4 �������ѣ�5 �����ڽ� -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='2'">Y</xsl:when><!-- �����޽� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template match="PRODUCTID" mode="risk">
		<xsl:choose>
			<xsl:when test=".='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<!-- xsl:when test=".='122010'">L12078</xsl:when> --><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='122012'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='50002'">50015</xsl:when><!-- �������Ӯ���ռƻ�  -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12079'">L12098</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1��B���������գ������ͣ�-->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������� -->
			<xsl:when test=".='L12091'">L12091</xsl:when><!-- �����Ӯ1�������A��-->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ײʹ��� -->
	<xsl:template match="PRODUCTID" mode="plan">
		<xsl:choose>
			<xsl:when test=".='50002'">50015</xsl:when><!-- �������Ӯ���ռƻ�  -->
			<xsl:when test=".=''"></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ������ȡ��ʽ -->
	<!-- �㷢��0 �ֽ���� ��1�ֽ����� �� 2�ۼ���Ϣ -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='0'">4</xsl:when><!-- ֱ�Ӹ���  -->
			<xsl:when test=".='1'">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test=".='2'">1</xsl:when><!-- �ۼ���Ϣ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �潻��־ -->
	<xsl:template match="ALFLAG">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- �� -->
			<xsl:when test=".='1'">1</xsl:when><!-- �� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ְҵ���� -->
	<xsl:template match="TBR_WORKCODE|BBR_WORKCODE">
		<xsl:choose>
			<xsl:when test=".= '100001'">4030111</xsl:when><!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
			<xsl:when test=".= '100002'">2050101</xsl:when><!-- ����רҵ������Ա -->
			<xsl:when test=".= '100003'">2070109</xsl:when><!-- ����ҵ����Ա -->
			<xsl:when test=".= '100004'">2080103</xsl:when><!-- ����רҵ��Ա -->
			<xsl:when test=".= '100005'">2090104</xsl:when><!-- ��ѧ��Ա -->
			<xsl:when test=".= '100006'">2100106</xsl:when><!-- ���ų��漰��ѧ����������Ա -->
			<xsl:when test=".= '100007'">2130101</xsl:when><!-- �ڽ�ְҵ�� -->
			<xsl:when test=".= '100008'">3030101</xsl:when><!-- �����͵���ҵ����Ա -->
			<xsl:when test=".= '100009'">4010101</xsl:when><!-- ��ҵ������ҵ��Ա -->
			<xsl:when test=".= '100010'">5010107</xsl:when><!-- ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".= '100011'">6240105</xsl:when><!-- ������Ա -->
			<xsl:when test=".= '100012'">2020103</xsl:when><!-- ��ַ��̽��Ա -->
			<xsl:when test=".= '100013'">2020906</xsl:when><!-- ����ʩ����Ա -->
			<xsl:when test=".= '100014'">6050611</xsl:when><!-- �ӹ����졢���鼰������Ա -->
			<xsl:when test=".= '100015'">7010103</xsl:when><!-- ���� -->
			<xsl:when test=".= '100016'">8010101</xsl:when><!-- ��ҵ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �������ͣ����з�0=����1=ũ�壻����1=����2=ũ�� -->
	<xsl:template match="TBR_RESIDENTSOURCE">
		<xsl:choose>
			<xsl:when test=".= '0'">1</xsl:when><!-- ���� -->
			<xsl:when test=".= '1'">2</xsl:when><!-- ũ�� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
