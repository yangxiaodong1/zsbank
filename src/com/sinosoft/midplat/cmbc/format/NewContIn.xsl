<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/INSUREQ">
		<TranData>
			<!-- ������ͷ -->
			<Head>
				<!-- �������ڣ�yyyymmdd�� -->
				<TranDate>
					<xsl:value-of select="MAIN/TRANSRDATE" />
				</TranDate>
				<!-- ����ʱ�� ��hhmmss��-->
				<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(MAIN/TRANSRTIME)"/></TranTime>
				<!-- ��Ա-->
				<TellerNo>
					<xsl:value-of select="MAIN/TELLERNO" />
				</TellerNo>
				<!-- ��ˮ��-->
				<TranNo>
					<xsl:value-of select="MAIN/TRANSRNO" />
				</TranNo>
				<!-- ������+������-->
				<NodeNo>
					<xsl:value-of select="MAIN/BRNO1" />
					<xsl:value-of select="MAIN/BRNO" />
				</NodeNo>
				<!-- ���б�ţ����Ķ��壩-->
				<BankCode>
					<xsl:value-of select="Head/TranCom/@outcode" />
				</BankCode>
				<xsl:copy-of select="Head/*" />
			</Head>
			
			<!-- �������� -->
			<Body>

				<xsl:apply-templates select="MAIN" />
				
				<!-- Ͷ���� -->
				<xsl:apply-templates select="TBR" />
	
				<!-- ������ -->
				<xsl:apply-templates select="BBR" />
	
				<!-- ������ -->
				<xsl:if test="SYRS/SYS_COUNT!=''">
					<xsl:apply-templates select="SYRS/SYR" />
				</xsl:if>
	
				<!-- ������Ϣ -->
				<xsl:apply-templates select="PRODUCTS/PRODUCT" />
				
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- MAIN_SUB_FLG  0:����  1:������ -->
	<xsl:variable name="MainRisk" select="//PRODUCTS/PRODUCT[MAIN_SUB_FLG=0]" />
		
	<!-- Body��Ŀ¼��Ϣ  -->
	<xsl:template name="Body" match="MAIN">
		
		<!-- Ͷ����(ӡˢ)�� -->
		<ProposalPrtNo>
			<xsl:value-of select="APPLNO" />
		</ProposalPrtNo>
		<!-- ������ͬӡˢ�� -->
		<ContPrtNo>
			<xsl:value-of select="PRINT_NO" />
		</ContPrtNo>
		<!-- Ͷ������ -->
		<PolApplyDate>
			<xsl:value-of select="TB_DATE" />
		</PolApplyDate>
		<!-- �˻����� -->
		<AccName>
			<xsl:value-of select="BANKACC_NAME" />
		</AccName>
		<!-- �����˻� -->
		<AccNo>
			<xsl:value-of select="BANKACC" />
		</AccNo>
		<!-- �������ͷ�ʽ -->
		<GetPolMode>
			<xsl:apply-templates select="SENDMETHOD" />
		</GetPolMode>
		<!-- FIXME ������ȷ�ϸñ�ǩ ְҵ��֪(N/Y) -->
		<JobNotice />
		<!-- FIXME ������ȷ�ϸñ�ǩ ������֪(N/Y) -->
		<HealthNotice>
			<xsl:value-of select="../HEALTH_NOTICE/NOTICE_ITEM" />
		</HealthNotice>
		
		<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
		<PolicyIndicator />
		<!--�ۼ�Ͷ����ʱ��� �������ֶαȽ����⣬��λ�ǰ�Ԫ-->
		<InsuredTotalFaceAmount />
		
		<!-- ����Ա���� -->
		<SellerNo><xsl:value-of select="SALESSTAFFID" /></SellerNo>
		<!-- ����Ա������ -->
		<TellerName><xsl:value-of select="SALESSTAFFNAME" /></TellerName>
		<!-- ����������Ա�ʸ�֤ -->
		<TellerCertiCode><xsl:value-of select="SALESSTAFFINTEL" /></TellerCertiCode>
		<!-- ���������ʸ�֤ -->
		<AgentComCertiCode><xsl:value-of select="BRNOINTEL" /></AgentComCertiCode>
		<!-- �������� -->
		<AgentComName><xsl:value-of select="BANKNAME" /></AgentComName>
		
		<!-- ��Ʒ��� -->
        <ContPlan>
			<ContPlanCode>
				<xsl:call-template name="tran_contPlancode">
					<xsl:with-param name="contPlancode">
						<xsl:value-of select="$MainRisk/PRODUCTID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult>
				<xsl:if test="$MainRisk/PRODUCTID = 50002">
					<xsl:value-of select="format-number($MainRisk/AMT_UNIT,'#')" />
				</xsl:if>
				<!-- add by duanjz ���Ӱ���ٰ���5�ű��ռƻ�50012 begin -->
				<xsl:if test="$MainRisk/PRODUCTID = 50012">
					<xsl:value-of select="format-number($MainRisk/AMT_UNIT,'#')" />
				</xsl:if>
				<!-- add by duanjz ���Ӱ���ٰ���5�ű��ռƻ�50012 end -->
				<!-- add by duanjz 2015-7-3 PBKINSR-737  ���Ӱ���ٰ���3�ű��ռƻ�50011 begin -->
				<xsl:if test="$MainRisk/PRODUCTID = 50011">
					<xsl:value-of select="format-number($MainRisk/AMT_UNIT,'#')" />
				</xsl:if>
				<!-- add by duanjz 2015-7-3 PBKINSR-737  ���Ӱ���ٰ���5�ű��ռƻ�50011 end -->
			</ContPlanMult>
        </ContPlan>
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
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="TBR_IDTYPE"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="TBR_IDNO" />
			</IDNo>
			<!-- ֤����Ч���� -->
			<IDTypeStartDate><xsl:value-of select="substring(TBR_IDVALIDATE,1,8)" /></IDTypeStartDate>	
			<!-- ֤����Чֹ�� -->	
			<xsl:if test="substring(TBR_IDVALIDATE,10,8) = '99999999'"><IDTypeEndDate>99991231</IDTypeEndDate></xsl:if>
			<xsl:if test="substring(TBR_IDVALIDATE,10,8) != '99999999'"><IDTypeEndDate><xsl:value-of select="substring(TBR_IDVALIDATE,10,8)" /></IDTypeEndDate></xsl:if>		   	
			<!-- ְҵ���� -->
			<JobCode><xsl:value-of select="TBR_JOB_CODE" /></JobCode>
			<!-- FIXME ȷ�����еĵ�λ��ʲô? ������ -->
			<Salary>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_ANNUALINCOME)" />
			</Salary>
			<!-- FIXME ȷ�����еĵ�λ��ʲô? ��ͥ������ -->
			<FamilySalary><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_AVG_INCOME)" /></FamilySalary>
			<!-- �ͻ����� -->
			<!-- 1.����2.ũ�� -->
			<LiveZone><xsl:apply-templates select="TBR_RESIDENTS" /></LiveZone>
			<!--���ղ�������Ƿ��ʺ�Ͷ���������3�������Ӹ��ֶΡ�Y��N��-->
			<RiskAssess><xsl:apply-templates select="RISKRATING" /></RiskAssess>
			<!-- ���� -->
			<Nationality><xsl:apply-templates select="TBR_COUNTRY_CODE" /></Nationality>
			<!-- FIXME TBR_HW �Ƿ�������ߺ����� ��  ���(cm) -->
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
			<!-- ����Ԥ���� ���֣� -->
			<Premiumbudget><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_PRM_BUDGET)" /></Premiumbudget>
		</Appnt>
	</xsl:template>
	
	<!-- ��������Ϣ -->
	<xsl:template name="Insured" match="BBR">
		<Insured>
			<!-- ���� -->
			<Name><xsl:value-of select="BBR_NAME" /></Name>
			<!-- �Ա� -->
			<Sex><xsl:apply-templates select="BBR_SEX" /></Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday><xsl:value-of select="BBR_BIRTH" /></Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="BBR_IDTYPE"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</IDType>
			<!-- ֤������ -->
			<IDNo><xsl:value-of select="BBR_IDNO" /></IDNo>
			
			<!-- ֤����Ч���� -->
			<IDTypeStartDate><xsl:value-of select="substring(BBR_IDVALIDATE,1,8)" /></IDTypeStartDate>	
			<!-- ֤����Чֹ�� -->
			<xsl:if test="substring(BBR_IDVALIDATE,10,8) = '99999999'"><IDTypeEndDate>99991231</IDTypeEndDate></xsl:if>
			<xsl:if test="substring(BBR_IDVALIDATE,10,8) != '99999999'"><IDTypeEndDate><xsl:value-of select="substring(BBR_IDVALIDATE,10,8)" /></IDTypeEndDate></xsl:if>		   		   
			<!-- ְҵ���� -->
			<JobCode><xsl:value-of select="BBR_WORKCODE" /></JobCode>
			<!-- ���(cm)-->
			<Stature />
			<!-- ����-->
			<Nationality><xsl:apply-templates select="BBR_COUNTRY_CODE" /></Nationality>
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
			<Grade><xsl:value-of select="SYR_ORDER" /></Grade>
			<!-- ���� -->
			<Name><xsl:value-of select="SYR_NAME" /></Name>
			<!-- �Ա� -->
			<Sex><xsl:apply-templates select="SYR_SEX" /></Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday><xsl:value-of select="SYR_BIRTHDAY" /></Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="SYR_IDTYPE"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</IDType>
			<!-- ֤������ -->
			<IDNo><xsl:value-of select="SYR_IDNO" /></IDNo>
			<!-- �뱻���˹�ϵ -->
			<RelaToInsured>
				<xsl:apply-templates select="SYR_BBR_RELA" />
			</RelaToInsured>
			<!-- ����-->
			<Nationality><xsl:apply-templates select="SYR_COUNTRY_CODE" /></Nationality>
			<!-- �������(�������ٷֱ�) -->
			<Lot><xsl:value-of select="SYR_BEN_RATE" /></Lot>
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
					<xsl:with-param name="riskcode" select="$MainRisk/PRODUCTID" />
				</xsl:call-template>
			</MainRiskCode>
			
			<!-- FIXME ȷ�����еĵ�λ��ʲô������(��) -->
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMOUNT)" />
			</Amnt>
			<!-- FIXME ȷ�����еĵ�λ��ʲô�����շ�(��) -->
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
				<xsl:if test="COVERAGE_PERIOD='3'">106</xsl:if><!-- ������ -->
				<xsl:if test="COVERAGE_PERIOD!='3'">
					<xsl:value-of select="COVERAGE_YEAR" />
				</xsl:if>
			</InsuYear>
			<!-- �ɷ����������־ -->
			<xsl:choose>
				<xsl:when test="PAY_TYPE = '1'">
					<!-- ���� -->
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:when test="PAY_TYPE = '6'">
					<!-- ����ɷ� -->
					<PayEndYearFlag>A</PayEndYearFlag>
					<PayEndYear>106</PayEndYear>
				</xsl:when>
				<xsl:otherwise>
					<!-- �����ɷ����� -->
					<PayEndYearFlag>
						<xsl:apply-templates select="PAY_TYPE" />
					</PayEndYearFlag>
					<PayEndYear>
						<xsl:value-of select="PAY_YEAR" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>

			<!-- ������ȡ��ʽ -->
			<BonusGetMode>
				<xsl:apply-templates select="../../MAIN/DVDMETHOD" />
			</BonusGetMode>
			<!-- ������ȡ����ȡ��ʽ -->
			<FullBonusGetMode />
			<!-- ��ȡ�������ڱ�־ -->
			<GetYearFlag></GetYearFlag>
			<!-- ��ȡ���� -->
			<GetYear>
				<xsl:value-of select="../../REC_YEAR_NO" />
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
				<xsl:apply-templates select="../../ALFLAG" />
			</AutoPayFlag>
		</Risk>
	</xsl:template>
	
	
		
	<!-- ��Ʒ��ϴ��� -->
	<xsl:template name="tran_contPlancode">
		<xsl:param name="contPlancode" />
		<xsl:choose>
			<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,122048 - ����������������գ������ͣ� -->
			<xsl:when test="$contPlancode=50002">50015</xsl:when>
			<!-- add by duanjz 2015-6-17  ���Ӱ���ٰ���5�ű��ռƻ�50012  begin -->
			<!-- 50012-����ٰ���5�ű��ռƻ�:���գ�L12070 - ����ٰ���5�������,�����գ�L12071 - ����ӳ�������5����ȫ���գ������ͣ� -->
			<xsl:when test="$contPlancode=50012">50012</xsl:when>
			<!-- add by duanjz 2015-6-17  ���Ӱ���ٰ���5�ű��ռƻ�50012  end -->
			<!-- add by duanjz 2015-7-3 PBKINSR-737  ���Ӱ���ٰ���3�ű��ռƻ�50011  begin -->
			<!-- 50011-����ٰ���3�ű��ռƻ�:���գ�L12068 - ����ٰ���3�������,�����գ�L12069 - ����ӳ�������3����ȫ���գ������ͣ� -->
			<xsl:when test="$contPlancode=50011">50011</xsl:when>
			<!-- add by duanjz 2015-7-3 PBKINSR-737  ���Ӱ���ٰ���3�ű��ռƻ�50011  end -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122012'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<!-- <xsl:when test="$riskcode='122010'">L12078</xsl:when> -->	<!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:when test="$riskcode='50002'">50015</xsl:when>
			<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,122048 - ����������������գ������ͣ� -->
			<!-- add by duanjz 2015-6-17  ���Ӱ���ٰ���5�ű��ռƻ�50012 begin -->
			<xsl:when test="$riskcode='L12070'">L12070</xsl:when>	<!-- ����ٰ���5������� -->
			<xsl:when test="$riskcode='L12071'">L12071</xsl:when>	<!-- ����ӳ�������5����ȫ���գ������ͣ� -->
			<xsl:when test="$riskcode='50012'">50012</xsl:when>
			<!-- add by duanjz 2015-6-17  ���Ӱ���ٰ���5�ű��ռƻ�50012  end -->
			<!-- add by duanjz 2015-7-3 PBKINSR-737  ���Ӱ���ٰ���3�ű��ռƻ�50011 begin -->
			<xsl:when test="$riskcode='L12068'">L12068</xsl:when>	<!-- ����ٰ���3������� -->
			<xsl:when test="$riskcode='L12069'">L12069</xsl:when>	<!-- ����ӳ�������3����ȫ���գ������ͣ� -->
			<xsl:when test="$riskcode='50011'">50011</xsl:when><!-- ����ٰ���3�ű��ռƻ� -->
			<!-- add by duanjz 2015-7-3 PBKINSR-737  ���Ӱ���ٰ���3�ű��ռƻ�50011 end -->
            <xsl:when test="$riskcode='L12087'">L12087</xsl:when>      <!-- ����5����ȫ���գ������ͣ� ���� -->
            <xsl:when test="$riskcode='L12085'">L12085</xsl:when>      <!-- ����2����ȫ���գ������ͣ� ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�Ƶ�� -->
	<!-- ���У�0 �����ڣ�1 �꽻��2 ���꽻��3 ������4 �½���5 ���� -->
	<!-- <xsl:template match="PAYMETHOD"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='0'">-1</xsl:when> --><!-- �����ڽ� -->
	<!-- 		<xsl:when test=".='1'">12</xsl:when> --><!-- ��� -->
	<!-- 		<xsl:when test=".='2'">6</xsl:when> --><!-- ���꽻 -->
	<!-- 		<xsl:when test=".='3'">3</xsl:when> --><!-- ����-->
	<!-- 		<xsl:when test=".='4'">1</xsl:when> --><!-- �½� -->
	<!-- 		<xsl:when test=".='5'">0</xsl:when> --><!-- ���� -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<!-- ���У�6 �����ڣ�2 �꽻��3 ���꽻��4 ������5 �½���1 ���� -->
	<xsl:template match="PAYMETHOD">
		<xsl:choose>
			<xsl:when test=".='6'">-1</xsl:when><!-- �����ڽ� -->
			<xsl:when test=".='2'">12</xsl:when><!-- ��� -->
			<xsl:when test=".='3'">6</xsl:when><!-- ���꽻 -->
			<xsl:when test=".='4'">3</xsl:when><!-- ����-->
			<xsl:when test=".='5'">1</xsl:when><!-- �½� -->
			<xsl:when test=".='1'">0</xsl:when><!-- ���� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ������������ -->
	<!-- ���У�0 �޹أ�1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<!-- <xsl:template match="COVERAGE_PERIOD"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='1'">A</xsl:when> --><!-- ���� -->
	<!-- 		<xsl:when test=".='2'">Y</xsl:when> --><!-- ���� -->
	<!-- 		<xsl:when test=".='3'">A</xsl:when> --><!-- ����ĳ���� -->
	<!-- 		<xsl:when test=".='4'">M</xsl:when> --><!-- ���� -->
	<!-- 		<xsl:when test=".='5'">D</xsl:when> --><!-- ���� -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<!-- ���У�6 �޹أ�3 ������1 �����ޱ���2 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='3'">A</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">Y</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">A</xsl:when><!-- ����ĳ���� -->
			<xsl:when test=".='4'">M</xsl:when><!-- ���� -->
			<xsl:when test=".='5'">D</xsl:when><!-- ���� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ����������־ -->
	<!-- ���У�3 ����ĳȷ�����䣬4 �����ɷѣ�7 �����޽ɣ� 8 �����޽ɣ�9 ��� 10 ���� -->
	<!-- <xsl:template match="PAY_TYPE"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='3'">A</xsl:when> --><!-- ����ĳȷ������ -->
	<!-- 		<xsl:when test=".='4'">A</xsl:when> --><!-- �����ɷ� -->
	<!-- 		<xsl:when test=".='7'">M</xsl:when> --><!-- �����޽� -->
	<!-- 		<xsl:when test=".='8'">D</xsl:when> --><!-- �����޽� -->
	<!-- 		<xsl:when test=".='9'">Y</xsl:when> --><!-- ��� -->
	<!-- 		<xsl:when test=".='10'">Y</xsl:when> --><!-- ���� -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<!-- ���У�0 ����ĳȷ�����䣬6 �����ɷѣ�5 �����޽ɣ� 8 �����޽ɣ�2 ��� 1 ���� -->
	<xsl:template match="PAY_TYPE">
		<xsl:choose>
			<xsl:when test=".='0'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='6'">A</xsl:when><!-- �����ɷ� -->
			<xsl:when test=".='5'">M</xsl:when><!-- �����޽� -->
			<xsl:when test=".='8'">D</xsl:when><!-- �����޽� -->
			<xsl:when test=".='2'">Y</xsl:when><!-- ��� -->
			<xsl:when test=".='1'">Y</xsl:when><!-- ���� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- FIXME ������ȷ��һ�� ������ȡ��ʽ -->
	<!-- ���У�1	�ۻ���Ϣ,2 �ֽ���ȡ,3 �ֽɱ���,4	����,5 �����,6 �޺��� -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- �ۼ���Ϣ -->
			<xsl:when test=".='2'">4</xsl:when><!-- ֱ�Ӹ���  -->
			<xsl:when test=".='3'">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test=".='5'">5</xsl:when><!-- ����� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ��ȡ��ʽ -->
	<!-- ���У�0	�޹�,1 ����,2 ������,3	����,4 ����,5 һ������ȡ,6 ����ȷ������,7	����,8 ��������,9 ���� -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='4'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">12</xsl:when><!--���� -->
			<xsl:when test=".='5'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='3'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">6</xsl:when><!-- ������ -->
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

   
	<!-- �Ա𣬺��ģ�0=���ԣ�1=Ů�ԣ����У�1 �У�2 Ů��3 ��ȷ�� -->
	<xsl:template match="TBR_SEX|BBR_SEX|SYR_SEX">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">1</xsl:when><!-- Ů�� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤������ת�� -->
	<xsl:template name="tran_IDType">
	<xsl:param name="idtype">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$idtype='01'">0</xsl:when><!-- �������֤ -->
			<xsl:when test="$idtype='02'">8</xsl:when><!-- ��ʱ���֤ -->
			<xsl:when test="$idtype='03'">5</xsl:when><!-- ���ڲ� -->
			<xsl:when test="$idtype='04'">2</xsl:when><!-- �������֤ -->
			<xsl:when test="$idtype='05'">8</xsl:when><!-- �侯֤ -->
			<xsl:when test="$idtype='06'">8</xsl:when><!-- ʿ��֤ -->
			<xsl:when test="$idtype='07'">8</xsl:when><!-- ��ְ�ɲ�֤ -->
			<xsl:when test="$idtype='08'">1</xsl:when><!-- ������� -->
			<xsl:when test="$idtype='09'">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test="$idtype='10'">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test="$idtype='11'">7</xsl:when><!-- ̨�����������½ͨ��֤ -->
			<xsl:when test="$idtype='12'">8</xsl:when><!-- ��������֤ -->
			<xsl:when test="$idtype='13'">1</xsl:when><!-- �й����� -->
			<xsl:when test="$idtype='14'">8</xsl:when><!-- ��������þ���֤ -->
			<xsl:when test="$idtype='15'">8</xsl:when><!-- ����ѧԱ֤ -->
			<xsl:when test="$idtype='16'">8</xsl:when><!-- ����ѧԱ֤ -->
			<xsl:when test="$idtype='17'">8</xsl:when><!-- ������뾳ͨ��֤ -->
			<xsl:when test="$idtype='18'">8</xsl:when><!-- ����ίԱ��֤�� -->
			<xsl:when test="$idtype='19'">8</xsl:when><!-- ѧ��֤ -->
			<xsl:when test="$idtype='20'">8</xsl:when><!-- ���� -->
			<xsl:when test="$idtype='21'">1</xsl:when><!-- ���� -->
			<xsl:when test="$idtype='22'">8</xsl:when><!-- �۰�̨ͬ������֤ -->
		</xsl:choose>
	</xsl:template>
	
	<!-- Ͷ���˾������� -->
	<xsl:template match="TBR_RESIDENTS">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">2</xsl:when><!-- ũ�� -->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="RISKRATING">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- �� -->
			<xsl:when test=".='0'">N</xsl:when><!-- �� -->
		</xsl:choose>
	</xsl:template>
	
	
	<!-- ����ת�� -->
	<xsl:template match="TBR_COUNTRY_CODE | BBR_COUNTRY_CODE | SYR_COUNTRY_CODE">
		<xsl:choose>
			<xsl:when test=".='0'">OTH</xsl:when><!--	����     -->
			<xsl:when test=".='1'">CHN</xsl:when><!--	�й�     -->
			<xsl:when test=".='2'">CHN</xsl:when><!--	���     -->
			<xsl:when test=".='3'">CHN</xsl:when><!--	����     -->
			<xsl:when test=".='4'">CHN</xsl:when><!--	̨��     -->
			<xsl:when test=".='5'">US</xsl:when><!--	����     -->
			<xsl:when test=".='6'">GB</xsl:when><!--	Ӣ��     -->
			<xsl:when test=".='7'">FR</xsl:when><!--	����     -->
			<xsl:when test=".='8'">DE</xsl:when><!--	�¹�     -->
			<xsl:when test=".='9'">JP</xsl:when><!--	�ձ�     -->
			<xsl:when test=".='10'">KR</xsl:when><!--	����     -->
			<xsl:when test=".='11'">SG</xsl:when><!--	�¼���   -->
			<xsl:when test=".='12'">MY</xsl:when><!--	�������� -->
			<xsl:when test=".='13'">CA</xsl:when><!--	���ô�   -->
			<xsl:when test=".='14'">AU</xsl:when><!--	�Ĵ����� -->
			<xsl:when test=".='15'">IN</xsl:when><!--  ӡ��      -->
			<xsl:when test=".='16'">TH</xsl:when><!--	̩��     -->
			<xsl:when test=".='17'">RU</xsl:when><!--	����˹   -->
			<xsl:when test=".='18'">ID</xsl:when><!--	ӡ�������� -->
			<xsl:when test=".='19'">IT</xsl:when><!--	�����   -->
			<xsl:otherwise>OTH</xsl:otherwise><!--	����     -->
		</xsl:choose>
	</xsl:template>
	
	<!-- Ͷ���ˡ������˹�ϵ�������ˡ������˹�ϵ -->
	<!-- ���ģ�00 ����,01 ��ĸ,02 ��ż,03 ��Ů,04 ����,05 ��Ӷ,06 ����,07 ����,08 ���� -->	
	<!--<xsl:template match="TBR_BBR_RELA|SYR_BBR_RELA"> -->
	<!--	<xsl:choose> -->
	<!--		<xsl:when test=".='01'">00</xsl:when> --><!-- ���� -->
	<!--		<xsl:when test=".='02'">01</xsl:when> --><!-- ���� -->
	<!--		<xsl:when test=".='03'">01</xsl:when> --><!-- ĸ�� -->
	<!--		<xsl:when test=".='06'">02</xsl:when> --><!-- �ɷ� -->
	<!--		<xsl:when test=".='07'">02</xsl:when> --><!-- ���� -->
	<!--		<xsl:when test=".='04'">03</xsl:when> --><!-- ���� -->
	<!--		<xsl:when test=".='05'">03</xsl:when> --><!-- Ů�� -->
	<!--		<xsl:when test=".='30'">04</xsl:when> --><!-- ���� -->
	<!--		<xsl:when test=".='37'">04</xsl:when> --><!-- �������� -->
	
	<!--		<xsl:otherwise>04</xsl:otherwise> --><!-- ���� -->
	<!--	</xsl:choose> -->
	<!--</xsl:template> -->
	<!-- ���ģ�00 ����,01 ��ĸ,02 ��ż,03 ��Ů,04 ����,05 ��Ӷ,06 ����,07 ����,08 ���� -->	
	<xsl:template match="TBR_BBR_RELA|SYR_BBR_RELA">
		<xsl:choose>
			<xsl:when test=".='01'">00</xsl:when><!-- ���� -->
			<xsl:when test=".='02'">01</xsl:when><!-- ���� -->
			<xsl:when test=".='03'">01</xsl:when><!-- ĸ�� -->
			<xsl:when test=".='06'">02</xsl:when><!-- �ɷ� -->
			<xsl:when test=".='07'">02</xsl:when><!-- ���� -->
			<xsl:when test=".='04'">03</xsl:when><!-- ���� -->
			<xsl:when test=".='05'">03</xsl:when><!-- Ů�� -->
			<xsl:when test=".='30'">04</xsl:when><!-- ����-���� -->
			<xsl:when test=".='38'">04</xsl:when><!-- ͬ��-���� -->
			<xsl:when test=".='44'">04</xsl:when><!-- ����-���� -->
			<xsl:otherwise>04</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

