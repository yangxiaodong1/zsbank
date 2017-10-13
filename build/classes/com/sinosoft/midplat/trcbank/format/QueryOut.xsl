<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<TXLife>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="Head" match="Head">
		<Head>
			<xsl:copy-of select="./*"/>
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		<Body>
			<!-- ������ -->
			<PolicyNo>
				<xsl:value-of select="ContNo"/>
			</PolicyNo>
			<!-- ���ղ�Ʒ��Ϣ -->	
			<PlanCodeInfo>	
				<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />			
			</PlanCodeInfo>
			<AccStat><xsl:apply-templates select="ContState" /></AccStat><!-- ����״̬��Ϣ -->
			
		</Body>
	</xsl:template>
	<!-- ������Ϣ -->
	<xsl:template name="Risk" match="Risk">
		<GetBankInfo><!-- ������ȡ��Ϣ -->
			<GetBankCode><xsl:value-of select="GetBankCode "/></GetBankCode><!-- ������ȡ���л����� -->
			<GetBankAccNo><xsl:value-of select="GetBankAccNo "/></GetBankAccNo><!-- ������ȡ�����˻� -->
			<GetAccName><xsl:value-of select="GetAccName "/></GetAccName><!-- ������ȡ�˻����� -->
			<InsureDate><xsl:value-of select="PolApplyDate "/></InsureDate><!-- Ͷ�����ڣ�ֻ�ޱ�����ѯ�����ã� -->
			<TotlePremium><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)"/></TotlePremium><!-- �������ѣ�ֻ�ޱ�����ѯ�����ã� -->
			<TotleAmnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)"/></TotleAmnt><!-- �������ֻ�ޱ�����ѯ�����ã� -->
			<Assumpsit><xsl:value-of select="SpecContent  "/></Assumpsit><!-- �ر�Լ��?(ֻ�ޱ�����ѯ������) -->
		</GetBankInfo>
		<MCount>1</MCount>
		<PClist>
			<PCCategory>
				<PCInfo>
					<PCIsMajor>Y</PCIsMajor><!-- �Ƿ����գ�Y/N�� -->
					<xsl:choose>
						<xsl:when test="../ContPlan/ContPlanCode=''">
							<BelongMajor>
								<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="RiskCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </BelongMajor><!-- �������մ��� -->
			                <PCCode>
			                	<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="RiskCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </PCCode><!-- ���ִ���  -->
			                <PCName><xsl:value-of select="RiskName"/></PCName><!-- �������� -->
			                <PCNumber><xsl:value-of select="Mult"/></PCNumber><!-- Ͷ������ -->
						</xsl:when>
						<xsl:otherwise>
							<BelongMajor>
								<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="../ContPlan/ContPlanCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </BelongMajor><!-- �������մ��� -->
			                <PCCode>
			                	<xsl:call-template name="tran_riskcode">
				                    <xsl:with-param name="riskcode">
				                        <xsl:value-of select="../ContPlan/ContPlanCode" />			                        
				                    </xsl:with-param>
				                </xsl:call-template>
			                </PCCode><!-- ���ִ���  -->
			                <PCName><xsl:value-of select="../ContPlan/ContPlanName"/></PCName><!-- �������� -->
			                <PCNumber><xsl:value-of select="../ContPlan/ContPlanMult"/></PCNumber><!-- Ͷ������ -->
						</xsl:otherwise>
					</xsl:choose>
					<PCType></PCType><!-- �������� 0 ��ͳ�� 1 �ֺ��� 2 Ͷ���� 3 ������ -->	
					<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)"/></Amnt><!-- ���ս���� -->
					<Premium><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)"/></Premium><!-- �������� -->
					<OthAmnt></OthAmnt><!-- ���Ᵽ�� -->
					<OthPremium></OthPremium><!-- ���Ᵽ�� -->
					<StableBenifit></StableBenifit><!-- ���ڷ��ع̶����� -->
					<InitFeeRate></InitFeeRate><!-- ��ʼ���ñ��� -->
					<Rate></Rate><!-- ���ʻ�ɷѱ�׼����ȷ��%�ź���λ�� -->
					<BonusPayMode></BonusPayMode><!-- �������䷽ʽ -->
					<BonusAmnt></BonusAmnt><!-- �ۼƺ��� -->
					<xsl:choose>
						<xsl:when test="PayEndYearFlag='Y' and PayEndYear='1000'">
							<PayTermType>1</PayTermType><!-- �ɷ��������� -->
							<PayYear>0</PayYear><!-- �ɷ�����(����ʱ����ֶ���0) -->
						</xsl:when>
						<xsl:when test="PayEndYearFlag='A' and PayEndYear='106'">
							<PayTermType>4</PayTermType><!-- �ɷ��������� -->
							<PayYear>0</PayYear><!-- �ɷ�����(����ʱ����ֶ���0) -->
						</xsl:when>
						<xsl:otherwise>
							<PayTermType><xsl:apply-templates select="PayEndYearFlag"/></PayTermType><!-- �ɷ��������� -->
							<PayYear><xsl:value-of select="PayEndYear"/></PayYear><!-- �ɷ�����(����ʱ����ֶ���0) -->
						</xsl:otherwise>
					</xsl:choose>
					<PayPeriodType></PayPeriodType><!-- �ɷ��������� -->
					<FIRST_PAYWAY></FIRST_PAYWAY><!-- ���ڽ�����ʽ -->
					<NEXT_PAYWAY></NEXT_PAYWAY><!-- ���ڽ�����ʽ -->
					<LoanTerm></LoanTerm><!-- �����ڼ� -->
					<InsuranceTerm></InsuranceTerm><!-- �����ڼ� -->
					<xsl:choose>
						<xsl:when test="InsuYearFlag ='A' and InsuYear ='106'">
							<CovPeriodType>1</CovPeriodType><!-- �����������ڱ�־ -->
							<InsuYear>0</InsuYear><!-- ������������ -->
						</xsl:when>
						<xsl:otherwise>
							<CovPeriodType><xsl:apply-templates select="InsuYearFlag"/></CovPeriodType><!-- �����������ڱ�־ -->
							<InsuYear><xsl:value-of select="InsuYear "/></InsuYear><!-- ������������ -->
						</xsl:otherwise>
					</xsl:choose>
					<FullBonusGetFlag></FullBonusGetFlag><!-- ������ȡ���ս��ǣ��Ƿ��ܹ���ȡ���ս���ͬ������Y/N�� -->
					<FullBonusGetMode></FullBonusGetMode><!-- ������ȡ����ȡ��ʽ -->
					<FullBonusPeriod></FullBonusPeriod><!-- ������ȡ��������(0-99) -->
					<RenteGetMode></RenteGetMode><!-- �����ȡ��ʽ -->
					<RentePeriod></RentePeriod><!-- �����ȡ��������(0-99) -->
					<SurBnGetMode></SurBnGetMode><!-- �������ȡ��ʽ -->
					<SurBnPeriod></SurBnPeriod><!-- �������ȡ��������(0-99) -->
					<AutoPayFlag></AutoPayFlag><!-- �Զ��潻��ǣ�Y/N�� -->
					<SubFlag></SubFlag><!-- ��������ǣ�Y/N�� -->
					<Address></Address><!-- ���ղƲ������ַ(ֻ���չ�Ӯ3�Ų�Ʒ����������) -->
					<PostCode></PostCode><!-- ���ղƲ������ַ�ʱ�(ֻ���չ�Ӯ3�Ų�Ʒ����������) -->
					<HouseStru></HouseStru><!-- ���ݽṹ(ֻ���չ�Ӯ3�Ų�Ʒ����������) -->
					<HousePurp></HousePurp><!-- ������; -->
				</PCInfo>
			</PCCategory>
		</PClist>
	</xsl:template>
	
	
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode"/>
		<xsl:choose>
			<xsl:when test="$riskcode='50015'">50015</xsl:when>
			<!-- ��ϲ�Ʒ 50015-�������Ӯ���ռƻ�: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ���� -->
			
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when> <!-- �����9����ȫ���գ������ͣ� -->
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- PayEndYearFlag�ɷ�����  -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- ���� -->
			<xsl:when test=".='A'">3</xsl:when><!-- ����ĳ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ContState ����״̬ -->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='B'">2</xsl:when><!-- �ѳб�δ��Ч -->
			<xsl:when test=".='00'">3</xsl:when><!-- �ѳб�����Ч -->
			<xsl:when test=".='C'">5</xsl:when><!-- �ѳ��� -->
			<xsl:when test=".='01'">6</xsl:when><!-- ������ -->
			<xsl:when test=".='04'">7</xsl:when><!-- ������ֹ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
