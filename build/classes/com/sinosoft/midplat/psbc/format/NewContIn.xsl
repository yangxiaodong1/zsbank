<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/INSUREQ">
		<TranData>
			<xsl:apply-templates select="MAIN" />

			<Body>
				<!-- Ͷ����(ӡˢ)�� -->
				<ProposalPrtNo>
					<xsl:value-of select="MAIN/APPLNO" />
				</ProposalPrtNo>
				<!-- ������ͬӡˢ�� -->
				<ContPrtNo></ContPrtNo>
				<!-- Ͷ������ -->
				<PolApplyDate>
					<xsl:value-of select="MAIN/TB_DATE" />
				</PolApplyDate>
				
				<!--������������-->
				<AgentComName><xsl:value-of select="MAIN/BRNM"/></AgentComName>
				<!--����������Ա����-->
				<SellerNo><xsl:value-of select="MAIN/SALE_ID"/></SellerNo>
				
				<!-- �˻����� -->
				<AccName>
					<xsl:value-of select="TBR/TBR_NAME" />
				</AccName>
				<!-- �����˻� -->
				<AccNo>
					<xsl:value-of select="MAIN/PAYACC" />
				</AccNo>
				<!-- �������ͷ�ʽ -->
				<GetPolMode>
					<xsl:call-template name="tran_sendmethod">
						<xsl:with-param name="sendmethod">
							<xsl:value-of select="MAIN/SENDMETHOD" />
						</xsl:with-param>
					</xsl:call-template>
				</GetPolMode>
				<!-- ְҵ��֪(N/Y) -->
				<JobNotice></JobNotice>
				<!-- ������֪(N/Y)  -->
				<HealthNotice>
					<xsl:call-template name="tran_healthnotice">
						<xsl:with-param name="healthnotice">
							<xsl:value-of select="HEALTH_NOTICE/NOTICE_ITEM" />
						</xsl:with-param>
					</xsl:call-template>
				</HealthNotice>
				<!-- ��Ʒ��� -->
				<ContPlan>
					<!-- ��Ʒ��ϱ��� -->
					<ContPlanCode>
						<xsl:call-template name="tran_ContPlanCode">
							<xsl:with-param name="contPlanCode">
								<xsl:value-of select="//PRODUCT[MAINSUBFLG='1']/PRODUCTID" />
							</xsl:with-param>
						</xsl:call-template>
					</ContPlanCode>
					<!-- ��Ʒ��Ϸ��� -->
					<ContPlanMult>
						<xsl:value-of select="//PRODUCT[MAINSUBFLG='1']/AMT_UNIT" />
					</ContPlanMult>
				</ContPlan>
				<!-- Ͷ���� -->
				<xsl:apply-templates select="TBR" />

				<!-- ������ -->
				<xsl:apply-templates select="BBR" />

				<!-- ������ -->
				<xsl:choose>
					<xsl:when test="SYRS/SYR/SYR_NAME!=''">
						<xsl:apply-templates select="SYRS/SYR" />
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>

				<!-- ������Ϣ -->
				<xsl:apply-templates select="PRODUCTS/PRODUCT" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="MAIN">
		<Head>
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TELLERNO" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
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
				<xsl:call-template name="tran_sex">
					<xsl:with-param name="sex">
						<xsl:value-of select="TBR_SEX" />
					</xsl:with-param>
				</xsl:call-template>
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="TBR_BIRTH" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:call-template name="tran_idtype">
					<xsl:with-param name="idtype">
						<xsl:value-of select="TBR_IDTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="TBR_IDNO" />
			</IDNo>
			<!-- ֤����Ч�� -->
			<IDTypeEndDate>
				<xsl:value-of select="TBR_EFF_DATE" />
			</IDTypeEndDate>
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode">
						<xsl:value-of select="TBR_WORKTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</JobCode>
			
			
			<!-- Ͷ���������룬���е�λΪ�� -->
			<Salary><xsl:value-of select="TBR_INCOME"/></Salary>
			
			<!-- Ͷ���˼�ͥ�����룬���е�λΪ�� -->
			<FamilySalary><xsl:value-of select="TBR_HM" /></FamilySalary>
			<!-- 1.����2.ũ�� -->
			<LiveZone><xsl:value-of select="TBR_TP"/></LiveZone>
			
			<!-- ���� FIXME ��Ҫӳ��-->
			<Nationality><xsl:value-of select="TBR_CNTY_CODE"/></Nationality>
			<!-- ���(cm) -->
			<Stature><xsl:value-of select="TBR_HEIGHT"/></Stature>
			<!-- ����(kg) -->
			<Weight><xsl:value-of select="TBR_WEIGHT"/></Weight>
			<!-- Ͷ���˹�����λ -->
			<Company><xsl:value-of select="TBR_UNIT"/></Company>
			<!-- Ͷ����ʡ�� FIXME ��Ҫӳ��-->
			<Province><xsl:value-of select="TBR_PROV"/></Province>
			<!-- Ͷ������������ -->
			<City></City>
			
			
			<!-- ���(N/Y) -->
			<MaritalStatus></MaritalStatus>
			<!-- ��ַ -->
			<Address>
				<xsl:value-of select="TBR_CITY"/><xsl:value-of select="TBR_ADDR" />
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
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation">
						<xsl:value-of select="TBR_BBR_RELA" />
					</xsl:with-param>
				</xsl:call-template>
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
				<xsl:call-template name="tran_sex">
					<xsl:with-param name="sex">
						<xsl:value-of select="BBR_SEX" />
					</xsl:with-param>
				</xsl:call-template>
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="BBR_BIRTH" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:call-template name="tran_idtype">
					<xsl:with-param name="idtype">
						<xsl:value-of select="BBR_IDTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="BBR_IDNO" />
			</IDNo>
			<!-- ֤����Ч�� -->
			<IDTypeEndDate>
				<xsl:value-of select="BBR_EFF_DATE" />
			</IDTypeEndDate>
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode">
						<xsl:value-of select="BBR_WORKTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</JobCode>
			
			
			<!-- ���� FIXME ��Ҫӳ��-->
			<Nationality><xsl:value-of select="BBR_CNTY_CODE"/></Nationality>
			<!-- ���(cm) -->
			<Stature><xsl:value-of select="BBR_HEIGHT"/></Stature>
			<!-- ����(kg) -->
			<Weight><xsl:value-of select="BBR_WEIGHT"/></Weight>
			<!-- �����˹�����λ -->
			<Company><xsl:value-of select="BBR_UNIT"/></Company>
			<!-- ������ʡ�� FIXME ��Ҫӳ��-->
			<Province><xsl:value-of select="BBR_PROV"/></Province>
			<!-- �������������� -->
			<City></City>
			
			
			<!-- ���(N/Y) -->
			<MaritalStatus></MaritalStatus>
			<!-- ��ַ -->
			<Address>
				<xsl:value-of select="BBR_CITY"/><xsl:value-of select="BBR_ADDR" />
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
				<xsl:value-of select="SYR_SEX" />
			</Sex>
			
			<!-- ���� FIXME ��Ҫӳ��-->
			<Nationality><xsl:value-of select="SYR_CNTY_CODE"/></Nationality>
			
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="SYR_BIRTH" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:call-template name="tran_idtype">
					<xsl:with-param name="idtype">
						<xsl:value-of select="SYR_IDTYPE" />
					</xsl:with-param>
				</xsl:call-template>
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="SYR_IDNO" />
			</IDNo>
			<!-- �뱻���˹�ϵ -->
			<RelaToInsured>
				<xsl:call-template name="tran_relation">
					<xsl:with-param name="relation">
						<xsl:value-of select="SYR_BBR_RELA" />
					</xsl:with-param>
				</xsl:call-template>
			</RelaToInsured>
			<!-- �������(�������ٷֱ�) -->
			<Lot>
				<xsl:value-of select="BNFT_PROFIT_PCENT" />
			</Lot>
		</Bnf>
	</xsl:template>

	<!-- ������Ϣ  -->
	<xsl:template name="Risk" match="PRODUCTS/PRODUCT">
		<Risk>
			<RiskCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
			</RiskCode><!-- ���ִ��� -->
			<MainRiskCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="../PRODUCT[MAINSUBFLG='1']/PRODUCTID" />
				</xsl:call-template>
			</MainRiskCode><!-- �������ִ��� -->
			<Amnt>
				<xsl:value-of select="AMT" />
			</Amnt><!-- ����(��) -->
			<Prem>
				<xsl:value-of select="PREMIUM" />
			</Prem><!-- ���շ�(��) -->
			<Mult>
				<xsl:value-of select="AMT_UNIT" />
			</Mult><!-- Ͷ������ -->
			<PayIntv><!-- �ɷ�Ƶ�� -->
				<xsl:call-template name="tran_PayIntv">
					<xsl:with-param name="payintv">
						<xsl:value-of select="PAYMETHOD" />
					</xsl:with-param>
				</xsl:call-template>
			</PayIntv>
			<PayMode></PayMode><!-- �ɷ���ʽ, ���۴�ʲô�����ģ����Ķ�Ĭ�ϴ�A=����ת�� -->
			<InsuYearFlag><!-- �������������־ -->
				<xsl:call-template name="tran_InsuYearFlag">
					<xsl:with-param name="insuyearflag">
						<xsl:value-of select="COVERAGE_PERIOD" />
					</xsl:with-param>
				</xsl:call-template>
			</InsuYearFlag>
			<!-- ������������ -->
			<InsuYear>
				<xsl:if test="COVERAGE_PERIOD=1">106</xsl:if><!-- ������ -->
				<xsl:if test="COVERAGE_PERIOD!=1">
					<xsl:value-of select="COVERAGE_YEAR" />
				</xsl:if>
			</InsuYear>
			<xsl:if test="PAYMETHOD = 5"><!-- ���� -->
				<PayEndYearFlag>Y</PayEndYearFlag>
				<PayEndYear>1000</PayEndYear>
			</xsl:if>
			<xsl:if test="PAYMETHOD != 5">
				<PayEndYearFlag>
					<xsl:call-template name="tran_PayEndYearFlag">
						<xsl:with-param name="payendyearflag">
							<xsl:value-of select="CHARGE_PERIOD" />
						</xsl:with-param>
					</xsl:call-template>
				</PayEndYearFlag><!-- �ɷ����������־ -->
				<PayEndYear>
					<xsl:value-of select="CHARGE_YEAR" />
				</PayEndYear><!-- �ɷ��������� -->
			</xsl:if>

			<BonusGetMode>
				<xsl:call-template name="tran_BonusGetMode">
					<xsl:with-param name="bonusgetmode"
						select="DVDMETHOD" />
				</xsl:call-template>
			</BonusGetMode><!-- ������ȡ��ʽ -->
			<FullBonusGetMode></FullBonusGetMode><!-- ������ȡ����ȡ��ʽ -->
			<GetYearFlag></GetYearFlag><!-- ��ȡ�������ڱ�־ -->
			<GetYear>
				<xsl:value-of select="REVAGE" />
			</GetYear><!-- ��ȡ���� -->
			<GetIntv/><!-- ��ȡ��ʽ -->
			<GetBankCode></GetBankCode><!-- ��ȡ���б��� -->
			<GetBankAccNo></GetBankAccNo><!-- ��ȡ�����˻� -->
			<GetAccName></GetAccName><!-- ��ȡ���л��� -->
			<AutoPayFlag>
				<xsl:value-of select="ALFLAG" />
			</AutoPayFlag><!-- �Զ��潻��־ -->
		</Risk>
	</xsl:template>



	<!-- ��Ҫ�ֶδ���ת��������ϸ�˶ԣ� -->
	<!-- �Ա� -->
	<xsl:template name="tran_sex">
		<xsl:param name="sex">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$sex = 1">0</xsl:when><!-- ���� -->
			<xsl:when test="$sex = 2">1</xsl:when><!-- Ů�� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
			<xsl:when test="$idtype=1">0</xsl:when><!-- ���֤ -->
			<xsl:when test="$idtype=2">2</xsl:when><!-- ����֤ -->
			<xsl:when test="$idtype=3">1</xsl:when><!-- ���� -->
			<xsl:when test="$idtype=4">4</xsl:when><!-- ����֤ -->
			<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>

	<!-- Ͷ�����뱻���˹�ϵ -->
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
		<xsl:if test="$payintv = '1'">12</xsl:if><!-- ��� -->
		<xsl:if test="$payintv = '2'">6</xsl:if><!-- ���꽻 -->
		<xsl:if test="$payintv = '3'">3</xsl:if><!-- ����-->
		<xsl:if test="$payintv = '4'">1</xsl:if><!-- �½� -->
		<xsl:if test="$payintv = '5'">0</xsl:if><!-- ���� -->
	</xsl:template>

	<!-- �ɷ���ʽ --><!-- ��Ҫ�ٴ�ȷ��  -->
	<xsl:template name="tran_PayMode">
		<xsl:param name="paymode">0</xsl:param>
		<xsl:if test="$paymode = '1'">7</xsl:if><!-- ����ת��  -->
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
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ����������־ --><!-- ��Ҫ�ٴ�ȷ��  -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="payendyearflag" />
		<xsl:choose>
			<xsl:when test="$payendyearflag=2">Y</xsl:when><!-- �����޽� -->
			<xsl:when test="$payendyearflag=3">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test="$payendyearflag=4">A</xsl:when><!-- ����ɷ� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<!-- ��ʹ���к���˾���ִ�����ͬҲҪת����Ϊ������ĳ������ֻ���������� -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='L12074'">L12074</xsl:when>
			<!-- ����ʢ��9����ȫ���գ��ֺ��ͣ�-->
			<xsl:when test="$riskcode=122006">122006</xsl:when>
			<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test="$riskcode=122009">122009</xsl:when>
			<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test="$riskcode=122012">L12079</xsl:when>
			<!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test="$riskcode=122010">L12100</xsl:when>
			<!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test="$riskcode=50003">50016</xsl:when>
			<!-- 50003(50016)-��������ᱣ�ռƻ�  -->
			<xsl:when test="$riskcode='L12084'">L12084</xsl:when>
			<!-- �����Ӯ2�������A��  -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when>
			<!-- �����5����ȫ���գ������ͣ�  -->
			<!-- <xsl:when test="$riskcode='L12094'">L12094</xsl:when>-->
			<!-- �����Ӯ3�������A��  -->
			<!-- <xsl:when test="$riskcode='L12088'">L12088</xsl:when>-->
			<!-- �����9����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ��Ʒ��ϴ��� -->
	<xsl:template name="tran_ContPlanCode">
		<xsl:param name="contPlanCode" />
		<xsl:choose>
			<!-- 50003(50016)-��������ᱣ�ռƻ�:���գ�122046 - �������Ӯ1����ȫ����, �����գ�122047 - ����ӳ�����Ӯ��ȫ���� , 122048(L12081)-����������������գ������ͣ�-->
			<xsl:when test="$contPlanCode='50003'">50016</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ������ȡ��ʽ -->
	<xsl:template name="tran_BonusGetMode">
		<xsl:param name="bonusgetmode" />
		<xsl:choose>
			<xsl:when test="$bonusgetmode=0">2</xsl:when><!-- ֱ�Ӹ���  -->
			<xsl:when test="$bonusgetmode=1">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test="$bonusgetmode=2">1</xsl:when><!-- �ۼ���Ϣ -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ��ȡ��ʽ -->
	<xsl:template name="tran_GetIntv">
		<xsl:param name="getintv" />
		<xsl:choose>
			<xsl:when test="$getintv=1">1</xsl:when><!-- ���� -->
			<xsl:when test="$getintv=2">2</xsl:when><!-- ���� -->
			<xsl:when test="$getintv=3">3</xsl:when><!-- ����  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- �������ͷ�ʽ -->
	<xsl:template name="tran_sendmethod">
		<xsl:param name="sendmethod">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$sendmethod = 1">2</xsl:when>
			<xsl:when test="$sendmethod = 2">0</xsl:when>
			<xsl:when test="$sendmethod = 3">3</xsl:when>
			<xsl:when test="$sendmethod = 4">1</xsl:when><!-- ������ȡ -->
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>

	<!-- ����״̬ -->
	<xsl:template name="tran_marriage">
		<xsl:param name="marriage">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$marriage = 0">0</xsl:when><!-- δ�� -->
			<xsl:when test="$marriage = 1">1</xsl:when><!-- �ѻ� -->
			<xsl:when test="$marriage = 2">6</xsl:when><!-- ��� -->
			<xsl:when test="$marriage = 3">2</xsl:when><!-- ɥż -->
			<xsl:when test="$marriage = 4">7</xsl:when><!-- ͬ�� -->
			<xsl:when test="$marriage = 5">8</xsl:when><!-- �־� -->
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>
	
	<!-- ְҵ���� -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
<xsl:choose>
	<xsl:when test="$jobcode= 4030111">4030111</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
	<xsl:when test="$jobcode= 2050101">2050101</xsl:when>	<!-- ����רҵ������Ա -->
	<xsl:when test="$jobcode= 2070109">2070109</xsl:when>	<!-- ����ҵ����Ա -->
	<xsl:when test="$jobcode= 2080103">2080103</xsl:when>	<!-- ����רҵ��Ա -->
	<xsl:when test="$jobcode= 2090104">2090104</xsl:when>	<!-- ��ѧ��Ա -->
	<xsl:when test="$jobcode= 2100106">2100106</xsl:when>	<!-- ���ų��漰��ѧ����������Ա -->
	<xsl:when test="$jobcode= 2130101">2130101</xsl:when>	<!-- �ڽ�ְҵ�� -->
	<xsl:when test="$jobcode= 3030101">3030101</xsl:when>	<!-- �����͵���ҵ����Ա -->
	<xsl:when test="$jobcode= 4010101">4010101</xsl:when>	<!-- ��ҵ������ҵ��Ա -->
	<xsl:when test="$jobcode= 5010107">5010107</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա -->
	<xsl:when test="$jobcode= 6240105">6240105</xsl:when>	<!-- ������Ա -->
	<xsl:when test="$jobcode= 2020103">2020103</xsl:when>	<!-- ��ַ��̽��Ա -->
	<xsl:when test="$jobcode= 2020906">2020906</xsl:when>	<!-- ����ʩ����Ա -->
	<xsl:when test="$jobcode= 6050611">6050611</xsl:when>	<!-- �ӹ����졢���鼰������Ա -->
	<xsl:when test="$jobcode= 7010103">7010103</xsl:when>	<!-- ���� -->
	<xsl:when test="$jobcode= 8010101">8010101</xsl:when>	<!-- ��ҵ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ������֪ -->
<xsl:template name="tran_healthnotice">
<xsl:param name="healthnotice" />
<xsl:choose>
	<xsl:when test="$healthnotice='Y'">N</xsl:when><!-- �ʴ�Y��ʾ������ -->
	<xsl:otherwise>Y</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
