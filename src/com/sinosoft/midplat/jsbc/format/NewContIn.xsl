<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="INSUREQ">
		<TranData>
			<!-- ����ͷ -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/TRANSRDATE"/></TranDate>
				<TranTime><xsl:value-of select="MAIN/TRANSRTIME"/></TranTime>
				<TellerNo><xsl:value-of select="MAIN/TELLERNO"/></TellerNo>
				<TranNo><xsl:value-of select="MAIN/TRANSRNO"/></TranNo>
				<NodeNo>
					<xsl:value-of select="MAIN/ZONENO"/>
					<xsl:value-of select="MAIN/BRNO"/>
				</NodeNo>
				<xsl:copy-of select="Head/*"/>
				<BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
			</Head>
			<Body>
				
				<xsl:apply-templates select="MAIN" />
				<!-- Ͷ������Ϣ -->
				<xsl:apply-templates select="TBR" />
				<!-- ����������Ϣ -->
				<xsl:apply-templates select="BBR" />
				<!-- ��������Ϣ -->
				<xsl:apply-templates select="SYRS/SYR" />
				<!-- ������Ϣ -->
				<xsl:apply-templates select="PRODUCTS/PRODUCT[MAINSUBFLG=1]" />
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Body" match="MAIN">
		<ProposalPrtNo><xsl:value-of select="APPLNO" /></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="BD_PRINT_NO" /></ContPrtNo>
		<PolApplyDate><xsl:value-of select="TB_DATE" /></PolApplyDate>
		<AccName><xsl:value-of select="../TBR/TBR_NAME" /></AccName>
		<AccNo><xsl:value-of select="PAYACC" /></AccNo>
		<!-- ������ȡ��ʽ -->
		<GetPolMode><xsl:apply-templates select="SENDMETHOD" /></GetPolMode>
		<JobNotice></JobNotice>
		<HealthNotice><xsl:value-of select="../HEALTH_NOTICE/NOTICE_ITEM" /></HealthNotice>
		<!-- δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N�� -->
		<PolicyIndicator>
			<xsl:if test="../ADD_AMOUNT = '' or ../ADD_AMOUNT = '0'">N</xsl:if>
			<xsl:if test="../ADD_AMOUNT != '' and ../ADD_AMOUNT != '0'">Y</xsl:if>
		</PolicyIndicator>
		<!--�ۼ�δ������Ͷ����ʱ��� �������ֶαȽ����⣬��λ�ǰ�Ԫ-->
		<xsl:choose>
			<xsl:when test="../ADD_AMOUNT=''">
				<InsuredTotalFaceAmount />
			</xsl:when>
			<xsl:when test="../ADD_AMOUNT=0">
				<InsuredTotalFaceAmount>
					<xsl:value-of select="../ADD_AMOUNT" />
				</InsuredTotalFaceAmount>
			</xsl:when>
			<xsl:otherwise>
				<InsuredTotalFaceAmount>
					<xsl:value-of select="../ADD_AMOUNT*0.01" />
				</InsuredTotalFaceAmount>
			</xsl:otherwise>
		</xsl:choose>
		<AgentComName><xsl:value-of select="BRNAME" /></AgentComName>
		<!-- ���������ʸ�֤�� -->
		<AgentComCertiCode></AgentComCertiCode>
		<!-- ������Ա���� -->
		<SellerNo><xsl:value-of select="FINANCIALNO" /></SellerNo>
		<TellerName><xsl:value-of select="FINANCIALNAME " /></TellerName>
		<!-- ������Ա�ʸ�֤�� -->
		<TellerCertiCode></TellerCertiCode>
		<!-- ��Ʒ��� -->
        <ContPlan>
			<ContPlanCode>
			</ContPlanCode>
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult>
			</ContPlanMult>
        </ContPlan>
   </xsl:template>
   
   <!-- Ͷ������Ϣ -->
   <xsl:template name="Appnt" match="TBR">
	<Appnt>
		<Name><xsl:value-of select="TBR_NAME" /></Name>
		<Sex>
			<xsl:apply-templates select="TBR_SEX" />			
		</Sex>
		<Birthday><xsl:value-of select="TBR_BIRTH" /></Birthday>
		<IDType>
			<xsl:apply-templates select="TBR_IDTYPE"/>
		</IDType>
		<IDNo><xsl:apply-templates select="TBR_IDNO" /></IDNo>	
		<IDTypeStartDate><xsl:value-of select="TBR_IDEFFSTARTDATE" /></IDTypeStartDate>	
		<IDTypeEndDate><xsl:value-of select="TBR_IDEFFENDDATE" /></IDTypeEndDate>
		<JobCode>
			<xsl:apply-templates select="TBR_WORKCODE"/>
		</JobCode>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality">
					<xsl:value-of select="TBR_NATIVEPLACE"/>
				</xsl:with-param>
			</xsl:call-template>
		</Nationality>
		<Stature></Stature>
		<Weight></Weight>
		<!-- Ͷ����������(����Ԫ) -->
		<xsl:choose>
			<xsl:when test="TBR_AVR_SALARY=''">
				<Salary />
			</xsl:when>
			<xsl:otherwise>
				<Salary>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_AVR_SALARY)" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Ͷ���˼�ͥ����(����Ԫ) -->
		<xsl:choose>
			<xsl:when test="TBR_HOMEAVR_SALARY=''">
				<FamilySalary />
			</xsl:when>
			<xsl:otherwise>
				<FamilySalary>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_HOMEAVR_SALARY)" />
				</FamilySalary>
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- 1.����2.ũ�� -->
		<LiveZone><xsl:apply-templates select="TBR_ZONE" /></LiveZone>
		<Address><xsl:value-of select="TBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="TBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="TBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="TBR_FTEL" /></Phone>
		<RelaToInsured>
			<xsl:call-template name="tran_RelaToInsured">
				 <xsl:with-param name="relaToInsured">
				 	<xsl:value-of select="TBR_BBR_RELA"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</RelaToInsured>	
	</Appnt>
   </xsl:template>
    
    <!-- ����������Ϣ -->
    <xsl:template name="Insured" match="BBR">
    <Insured>
    	<Name><xsl:value-of select="BBR_NAME" /></Name>
    	<Sex>
			<xsl:apply-templates select="BBR_SEX" />			
		</Sex>
		<Birthday><xsl:value-of select="BBR_BIRTH" /></Birthday>
		<IDType>
			<xsl:apply-templates select="BBR_IDTYPE"/>
		</IDType>
		<IDNo><xsl:value-of select="BBR_IDNO" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="BBR_IDEFFSTARTDATE" /></IDTypeStartDate>	
		<IDTypeEndDate><xsl:value-of select="BBR_IDEFFENDDATE" /></IDTypeEndDate>
		<JobCode>
			<xsl:apply-templates select="BBR_WORKCODE" />
		</JobCode>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality">
					<xsl:value-of select="BBR_NATIVEPLACE"/>
				</xsl:with-param>
			</xsl:call-template>
		</Nationality>
		
		<Stature></Stature>
		<Weight></Weight>
		<MaritalStatus></MaritalStatus>
		<Address><xsl:value-of select="BBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="BBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="BBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="BBR_TEL" /></Phone>
		<Email><xsl:value-of select="BBR_EMAIL" /></Email>
    </Insured>
    </xsl:template>
    
	<!-- ��������Ϣ -->
	<xsl:template name="Bnf" match="SYRS/SYR">
    	<xsl:if test="SYR_BBR_RELA!=0">
    		<Bnf>
       		<!-- Ĭ��Ϊ��1-��������ˡ� -->
       		<Type>1</Type>
       		<Grade><xsl:value-of select="SYR_ORDER" /></Grade>
       		<Name><xsl:value-of select="SYR_NAME" /></Name>
       		<Sex>
				<xsl:apply-templates select="SYR_SEX" />			
			</Sex>
       		<Birthday><xsl:value-of select="SYR_BIRTH" /></Birthday>
       		<IDType>
	       		<xsl:apply-templates select="SYR_IDTYPE"/>
       		</IDType>
       		<IDNo><xsl:value-of select="SYR_IDNO" /></IDNo>
       		<IDTypeStartDate><xsl:value-of select="SYR_IDEFFSTARTDATE" /></IDTypeStartDate>	
       		<IDTypeEndDate><xsl:value-of select="SYR_IDEFFENDDATE" /></IDTypeEndDate>
       		<Nationality>
				<xsl:call-template name="tran_Nationality">
					<xsl:with-param name="nationality">
						<xsl:value-of select="SYR_NATIVEPLACE"/>
					</xsl:with-param>
				</xsl:call-template>
			</Nationality>
       		<RelaToInsured>
	       		<xsl:call-template name="tran_RelaToInsured">
					 <xsl:with-param name="relaToInsured">
					 	<xsl:value-of select="SYR_BBR_RELA"/>
				     </xsl:with-param>
				 </xsl:call-template>
       		</RelaToInsured>
       		<Lot><xsl:value-of select="BNFT_PROFIT_PCENT" /></Lot>
       		<Address><xsl:value-of select="SYR_ADDRESS" /></Address>
       	</Bnf>
    	</xsl:if>
    </xsl:template>
    
    <!-- ������Ϣ -->
    <xsl:template name="Risk" match="PRODUCTS/PRODUCT[MAINSUBFLG=1]">   
       <Risk>
       		<RiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
       		</RiskCode>
       		<MainRiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
       		</MainRiskCode>
       		<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMOUNT)" /></Amnt>
       		<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIUM)" /></Prem>
       		<Mult><xsl:value-of select="format-number(AMT_UNIT,'#')" /></Mult>
       		<!-- ������ʽ:�ֽ�ɷѣ�����ת�� -->
       		<PayMode></PayMode>
       		<PayIntv><xsl:apply-templates select="//MAIN/PAYMETHOD" /></PayIntv>
       		<InsuYearFlag><xsl:apply-templates select="COVERAGE_PERIOD" /></InsuYearFlag>
       		<!-- ������������ -->
			<InsuYear>
				<xsl:if test="COVERAGE_PERIOD = '1'">106</xsl:if><!-- ������ -->
				<xsl:if test="COVERAGE_PERIOD != '1'">
					<xsl:value-of select="COVERAGE_YEAR" />
				</xsl:if>
			</InsuYear>
       		<!-- �ɷ����������־ -->
			<xsl:choose>
				<xsl:when test="CHARGE_PERIOD = '1'">
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
       		<BonusGetMode><xsl:apply-templates select="DVDMETHOD" /></BonusGetMode>
       		<FullBonusGetMode></FullBonusGetMode>
       		<GetYearFlag></GetYearFlag>
       		<GetYear><xsl:value-of select="REVAGE" /></GetYear>
       		<GetIntv><xsl:apply-templates select="REVMETHOD" /></GetIntv>
       		<GetBankCode></GetBankCode>
       		<GetBankAccNo></GetBankAccNo>
       		<GetAccName></GetAccName>
       		<AutoPayFlag><xsl:value-of select="ALFLAG" /></AutoPayFlag>
       	</Risk>
	</xsl:template>
	
	<!-- �Ա� -->
	<xsl:template match="TBR_SEX|BBR_SEX|SYR_SEX">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">1</xsl:when><!-- Ů�� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ֤������ -->
	<!-- ����֤�����ͣ�1 ���֤��2 ����֤��3 ���գ�5 ����  -->
	<xsl:template match="TBR_IDTYPE|BBR_IDTYPE|SYR_IDTYPE">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- �������֤����ʱ���֤ -->
			<xsl:when test=".='2'">2</xsl:when><!-- �������֤ -->
			<xsl:when test=".='3'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='5'">8</xsl:when><!-- ���� -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �뱻�����˹�ϵ -->
	<xsl:template name="tran_RelaToInsured">
	<xsl:param name="relaToInsured" />
		<xsl:choose>
			<xsl:when test="$relaToInsured='7'"></xsl:when><!-- ���� -->
			<xsl:when test="$relaToInsured='5'">00</xsl:when><!-- ���� -->
			<xsl:when test="$relaToInsured='1'">02</xsl:when><!-- ��ż -->
			<xsl:when test="$relaToInsured='2'">01</xsl:when><!-- ��ĸ -->
			<xsl:when test="$relaToInsured='3'">03</xsl:when><!-- ��Ů -->
			<xsl:when test="$relaToInsured='4'">04</xsl:when><!-- ���� -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Ͷ���˾������� -->
	<xsl:template match="TBR_ZONE">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">2</xsl:when><!-- ũ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ��������� -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">Y</xsl:when><!-- ��� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='4'">A</xsl:when><!-- ����ɷ� -->
			<xsl:when test=".='5'"></xsl:when><!-- �����ڽ� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ������������1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">A</xsl:when><!-- ������ -->
			<xsl:when test=".='2'">Y</xsl:when><!-- �����ޱ� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='4'">M</xsl:when><!-- ���±� -->
			<xsl:when test=".='5'">D</xsl:when><!-- ���챣 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ��ȡ��ʽ -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">12</xsl:when><!-- ���� -->
			<xsl:when test=".='3'">0</xsl:when><!-- ���죨һ������ȡ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- FIXME �ò��������ֵ������⣬��Ҫ������ȷ�� -->
	<!-- ������ȡ��ʽ -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='2'">1</xsl:when><!-- �ۻ���Ϣ -->
			<xsl:when test=".='1'">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test=".='3'">4</xsl:when><!-- �ֽ���ȡ -->
			<xsl:when test=".='0'">4</xsl:when><!-- �ֽ���ȡ -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ���ʽ -->
	<xsl:template match="PAYMODE">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- �ֽ� -->
			<xsl:when test=".='1'">7</xsl:when><!-- ת�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷѼ��1���ɣ�5�½ɣ�4���ɣ�3����ɣ�2��� -->
	<xsl:template match="PAYMETHOD">
		<xsl:choose>
			<xsl:when test=".='5'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">12</xsl:when><!-- ��� -->
			<xsl:when test=".='2'">6</xsl:when><!-- ����� -->
			<xsl:when test=".='3'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='4'">1</xsl:when><!-- �½� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �������ͷ�ʽ -->
	<!-- ���У�1 ���ŷ��ͣ�2 �ʼģ�3 ���ŵ��ͣ�4 ���й�̨ -->
	<!-- ���ģ�1	�ʼģ�2	���й�����ȡ -->
	<xsl:template match="SENDMETHOD">
		<xsl:choose>
		    <xsl:when test=".=2">1</xsl:when>	  <!-- �ʼ� -->
			<xsl:when test=".=4">2</xsl:when>	  <!-- ���й�����ȡ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ְҵ���� -->
	<!-- ����ְҵ���룺A-���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա
		B-����רҵ������Ա
		C-����ҵ����Ա
		D-����רҵ��Ա
		E-��ѧ��Ա
		F-���ų��漰��ѧ����������Ա
		G-�ڽ�ְҵ��
		H-�����͵���ҵ����Ա
		I-��ҵ������ҵ��Ա
		J-ũ���֡������桢ˮ��ҵ������Ա
		K-������Ա 
		L-���ʿ�����Ա
		M-����ʩ����Ա
		N-�ӹ����졢���鼰������Ա
		O-����
		P-��ҵ
	 -->
	<xsl:template match="TBR_WORKCODE|BBR_WORKCODE">
		<xsl:choose>
		    <xsl:when test=".='A'">4030111</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
			<xsl:when test=".='B'">2050101</xsl:when>	<!-- ����רҵ������Ա -->
			<xsl:when test=".='C'">2070109</xsl:when>	<!-- ����ҵ����Ա -->
			<xsl:when test=".='D'">2080103</xsl:when>	<!-- ����רҵ��Ա -->
			<xsl:when test=".='E'">2090104</xsl:when>	<!-- ��ѧ��Ա -->
			<xsl:when test=".='F'">2100106</xsl:when>	<!-- ���ų��漰��ѧ����������Ա -->
			<xsl:when test=".='G'">2130101</xsl:when>	<!-- �ڽ�ְҵ�� -->
			<xsl:when test=".='H'">3030101</xsl:when>	<!-- �����͵���ҵ����Ա -->
			<xsl:when test=".='I'">4010101</xsl:when>	<!-- ��ҵ������ҵ��Ա -->
			<xsl:when test=".='J'">5010107</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test=".='K'">6240105</xsl:when>	<!-- ������Ա -->
			<xsl:when test=".='L'">2020103</xsl:when>	<!-- ��ַ��̽��Ա -->
			<xsl:when test=".='M'">2020906</xsl:when>	<!-- ����ʩ����Ա -->
			<xsl:when test=".='N'">6050611</xsl:when>	<!-- �ӹ����졢���鼰������Ա -->
			<xsl:when test=".='O'">7010103</xsl:when>	<!-- ���� -->
			<xsl:when test=".='P'">8010101</xsl:when>	<!-- ��ҵ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ����ת�� -->
	<xsl:template name="tran_Nationality">
		<xsl:param name="nationality">0</xsl:param>
		<xsl:choose>		
			<xsl:when test="$nationality = '1'">CHN</xsl:when> <!-- �й�  -->
			<xsl:when test="$nationality = '2'">OTH</xsl:when> <!-- ����  -->
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
