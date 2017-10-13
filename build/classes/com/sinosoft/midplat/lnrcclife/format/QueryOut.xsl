<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<xsl:apply-templates select="TranData/Body" />
			</Body>
		</TXLife>
	</xsl:template>

	<!-- ����Ϣ -->
	<xsl:template name="MAIN" match="Body">
		<!--������-->
		<PolicyNo>
			<xsl:value-of select="ContNo" />
		</PolicyNo>
		<PlanCodeInfo>
			<GetBankInfo>
				<GetBankCode />
				<GetBankAccNo />
				<GetAccName />
			</GetBankInfo>
			<MCount>1</MCount>
			<PClist>
				<PCCategory>
					<xsl:apply-templates select="//Risk[RiskCode=MainRiskCode]" />
				</PCCategory>
			</PClist>
		</PlanCodeInfo>
		<AccStat>
		   <xsl:if test="AppFlag ='1'">001</xsl:if>
		   <xsl:if test="AppFlag !='1'">002</xsl:if>
		</AccStat>
	</xsl:template>

	<!-- ������Ϣ -->
	<xsl:template name="Risk" match="Risk">
		<PCInfo>
			<PCIsMajor>
				<xsl:if test="RiskCode != MainRiskCode">N</xsl:if>
				<xsl:if test="RiskCode = MainRiskCode">Y</xsl:if>
			</PCIsMajor>
			<xsl:choose>
				<xsl:when test="../ContPlan/ContPlanCode!=''">
					<PCCode>
						<xsl:call-template name="tran_riskcode">
							<xsl:with-param name="riskcode" select="../ContPlan/ContPlanCode" />
						</xsl:call-template>
					</PCCode>
					<BelongMajor>
						<xsl:call-template name="tran_riskcode">
							<xsl:with-param name="riskcode" select="../ContPlan/ContPlanCode" />
						</xsl:call-template>
					</BelongMajor>
					<PCType>3</PCType>
					<PCNumber>
						<xsl:value-of select="../ContPlan/ContPlanMult" />
					</PCNumber>							
				</xsl:when>
				<xsl:otherwise>
					<PCCode>
						<xsl:call-template name="tran_riskcode">
							<xsl:with-param name="riskcode" select="RiskCode" />
						</xsl:call-template>
					</PCCode>
					<BelongMajor>
						<xsl:call-template name="tran_riskcode">
							<xsl:with-param name="riskcode" select="MainRiskCode" />
						</xsl:call-template>
					</BelongMajor>
					<PCType>3</PCType>
					<PCNumber>
						<xsl:value-of select="Mult" />
					</PCNumber>						
				</xsl:otherwise>
			</xsl:choose>	
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)" />
			</Amnt>
			<Premium>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)" />
			</Premium>
			<OthAmnt></OthAmnt>
			<OthPremium></OthPremium>
			<StableBenifit></StableBenifit>
			<InitFeeRate></InitFeeRate>
			<Rate></Rate>
			<BonusPayMode></BonusPayMode>
			<BonusAmnt></BonusAmnt>
			<!-- �ɷ��������� -->
			<xsl:choose>
				<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear = 1000)">
					<!-- ���������� -->
					<PayTermType>1</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear != 1000)">
					<!-- ��� -->
					<PayTermType>2</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear != 106)">
					<!-- ����ĳȷ������ -->
					<PayTermType>3</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
					<!-- ���� -->
					<PayTermType>4</PayTermType>
					<PayYear></PayYear>
				</xsl:when>
			</xsl:choose>
			<PayPeriodType>
			    <xsl:apply-templates  select ="PayIntv"/>
			</PayPeriodType>
			<LoanTerm></LoanTerm>
			<InsuranceTerm></InsuranceTerm>
			<!-- ������������ -->
			<xsl:choose>
				<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
					<!-- ���� -->
					<CovPeriodType>1</CovPeriodType>
				</xsl:when>
				<xsl:otherwise>
					<!-- ������������ -->
					<CovPeriodType><xsl:apply-templates  select ="InsuYearFlag"/></CovPeriodType>
				</xsl:otherwise>
			</xsl:choose>
			<InsuYear></InsuYear>
			<FullBonusGetFlag></FullBonusGetFlag>
			<FullBonusGetMode></FullBonusGetMode>
			<FullBonusPeriod></FullBonusPeriod>
			<RenteGetMode></RenteGetMode>
			<RentePeriod></RentePeriod>
			<SurBnGetMode></SurBnGetMode>
			<SurBnPeriod></SurBnPeriod>
			<AutoPayFlag></AutoPayFlag>
			<SubFlag></SubFlag>
		</PCInfo>
	</xsl:template>

	<!-- �ֽ��ֵ��Ϣ -->
	<xsl:template name="CashValue" match="CashValue">
		<PolBenefitInfoList>
			<YeadEnd><xsl:value-of select="EndYear" /></YeadEnd>
			<CashValue><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)" /></CashValue>
		</PolBenefitInfoList>
	</xsl:template>
	
	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".=0">���֤</xsl:when>
		<xsl:when test=".=1">����  </xsl:when>
		<xsl:when test=".=2">����֤</xsl:when>
		<xsl:when test=".=3">����  </xsl:when>
		<xsl:when test=".=5">���ڲ�</xsl:when>
		<xsl:when test=".=6">�۰�̨ͨ��֤</xsl:when>
		<xsl:when test=".=9">��ʱ���֤</xsl:when>
		<xsl:otherwise>--  </xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='50015'">LNABZX02</xsl:when>
			<xsl:when test="$riskcode='L12079'">LNABZX01</xsl:when>
			<!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when>
			<!-- �����2����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ������������0 �޹أ�1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- �����ޱ� -->
			<xsl:when test=".='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='M'">4</xsl:when><!-- ���±� -->
			<xsl:when test=".='D'">5</xsl:when><!-- ���챣 -->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">0</xsl:when><!-- ��� -->
			<xsl:when test=".='6'">1</xsl:when><!-- ���꽻 -->
			<xsl:when test=".='3'">2</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">3</xsl:when><!-- �½� -->
			<xsl:when test=".='0'">4</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
