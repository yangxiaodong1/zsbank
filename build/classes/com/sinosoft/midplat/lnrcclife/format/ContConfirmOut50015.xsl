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
	    <xsl:variable name="CashValueCount" select="count(Risk[RiskCode=MainRiskCode]//CashValue)"/>
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
		<SpecialAgreement />
		<PolBenefitCount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillWith0($CashValueCount,2)" /></PolBenefitCount>
		<xsl:if test="$CashValueCount > 0">
			<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]//CashValue" />
		</xsl:if>
		<!-- û���ֽ��ֵ�� -->
		<xsl:if test="$CashValueCount = 0">
			<PolBenefitInfoList>
				<YeadEnd />
				<CashValue />
			</PolBenefitInfoList>
		</xsl:if>
		<IsUseAutoDefPrtFmt>Y</IsUseAutoDefPrtFmt>
		<!-- ��ӡ��Ϣ -->
		<StrAutoDefPrtFmt>
		    <xsl:variable name="RiskCount" select="count(Risk)"/>
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
			<xsl:variable name="ProductCode" select="$MainRisk/RiskCode" />
			<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
            <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

			
			<xsl:choose>
				<xsl:when test="$CashValueCount > 0">
					<SCount>2</SCount>
				</xsl:when>
				<xsl:otherwise>
					<SCount>1</SCount>
				</xsl:otherwise>
			</xsl:choose>
			<!--ҳ��-->
			<SList>
				<xsl:variable name="SumPremYuan" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>
				<!--��ҳѭ��-->
				<!--���д�ӡ����.��ҳ�ɴ�ӡ�������봫�������б���Ϊ�գ��磺��ҳ�ɴ�60�У��ڸ�SList���봫60��Context-->
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
				<xsl:text>                                      ��ֵ��λ�������Ԫ</xsl:text></Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context>
					<xsl:text>������Ͷ����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
					<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Appnt/IDType" />
					<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
				</Context>
				<Context>
					<xsl:text>�������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
					<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Insured/IDType" />
					<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
				</Context>
				<Context>��</Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<xsl:if test="count(Bnf) = 0">
				<Context><xsl:text>��������������ˣ�����                </xsl:text>
						   <xsl:text>����˳��1                   </xsl:text>
						   <xsl:text>���������100%</xsl:text></Context>
				</xsl:if>
				<xsl:if test="count(Bnf)>0">
				<xsl:for-each select="Bnf">
				<Context>
					<xsl:text>��������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
					<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
					<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
				</Context>
				</xsl:for-each>
				</xsl:if>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context>��</Context>
				<Context>��������������</Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context><xsl:text>�������������������������������������������������������������������������ս��\</xsl:text></Context>
				<Context><xsl:text>����������������������������              �����ڼ�    ��������      �ս�����\    ���շ�      ����Ƶ��</xsl:text></Context>
				<Context><xsl:text>������������������������������������������������������������������������\����</xsl:text></Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<xsl:for-each select="Risk">
				<xsl:variable name="PayIntv" select="PayIntv"/>
				<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
				<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
				
				<xsl:choose>
					<xsl:when test="RiskCode='L12081'">
						<Context><xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 9)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 9)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 9)"/>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 14)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 14)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',14)"/>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:text>-</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 12">
										<xsl:text>���</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 6">
										<xsl:text>�����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 3">
										<xsl:text>����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 1">
										<xsl:text>�½�</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = -1">
										<xsl:text>�����ڽ�</xsl:text>
									</xsl:when>
								</xsl:choose>
						</Context>
					</xsl:when>
					<xsl:otherwise>
						<Context><xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
							<xsl:choose>
								<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 9)"/>
								</xsl:when>
								<xsl:when test="InsuYearFlag = 'Y'">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 9)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 9)"/>
									<xsl:text></xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="PayIntv = 0">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ�ν���', 14)"/>
								</xsl:when>
								<xsl:when test="PayEndYearFlag = 'Y'">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 14)"/>
								</xsl:when>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',13)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,14)"/>
							<xsl:choose>
								<xsl:when test="PayIntv = 0">
									<xsl:text>����</xsl:text>
								</xsl:when>
								<xsl:when test="PayIntv = 12">
									<xsl:text>���</xsl:text>
								</xsl:when>
								<xsl:when test="PayIntv = 6">
									<xsl:text>�����</xsl:text>
								</xsl:when>
								<xsl:when test="PayIntv = 3">
									<xsl:text>����</xsl:text>
								</xsl:when>
								<xsl:when test="PayIntv = 1">
									<xsl:text>�½�</xsl:text>
								</xsl:when>
								<xsl:when test="PayIntv = -1">
									<xsl:text>�����ڽ�</xsl:text>
								</xsl:when>
							</xsl:choose>
						</Context>
					</xsl:otherwise>
				</xsl:choose>
				
				</xsl:for-each>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context>��</Context>
				<Context>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</Context>
				<Context>��</Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<Context>���������յ��ر�Լ����</Context>
			
				<xsl:choose>
					<xsl:when test="$SpecContent=''">
						<Context><xsl:text>���ޣ�</xsl:text></Context>
					</xsl:when>
					<xsl:otherwise>
						<Context>������    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</Context>
						<Context>�������ֽ��ֵ��</Context>
						<Context>������    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</Context>
						<Context>�������������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ�</Context>
						<Context>�������ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</Context>
					</xsl:otherwise>
				</xsl:choose>
				<Context>������-------------------------------------------------------------------------------------------------</Context>
				<Context>
					<xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</Context>
				<Context><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></Context>
				<Context><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></Context>
				<Context><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></Context>
				<Context>��</Context>
				<Context><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></Context>
				<Context><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Context>
				<Context>��</Context>
				<Context><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>ҵ�����֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode,0)"/></Context>
				<Context><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></Context>
			</SList>
			
			<xsl:if test="$CashValueCount > 0">
			
            <xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
			<SList>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</Context>
				<Context>��</Context>
				<Context>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context>��������������������<xsl:value-of select="Insured/Name"/></Context>
			    <xsl:if test="$RiskCount=1">
				<Context>
				    <xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Context>
				<Context><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
						   <xsl:text>�ֽ��ֵ</xsl:text></Context>
				   	<xsl:variable name="EndYear" select="EndYear"/>
				   <xsl:for-each select="$MainRisk/CashValues/CashValue">
					 <xsl:variable name="EndYear" select="EndYear"/>
					   <Context><xsl:text/><xsl:text>����������</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</Context>
			       </xsl:for-each>
			    </xsl:if>
			 
			    <xsl:if test="$RiskCount!=1">
			 	<Context>
					<xsl:text>�������������ƣ�              </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Context>
				<Context><xsl:text/>�������������ĩ<xsl:text>                      </xsl:text>
						   <xsl:text>�ֽ��ֵ                                �ֽ��ֵ</xsl:text></Context>
				   	<xsl:variable name="EndYear" select="EndYear"/>
				   <xsl:for-each select="$MainRisk/CashValues/CashValue">
					 <xsl:variable name="EndYear" select="EndYear"/>
					   <Context>
							  <xsl:text/><xsl:text>����������</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</Context>
					</xsl:for-each>
			    </xsl:if>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context>��</Context>
				<Context>��������ע��</Context>
				<Context>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ�� </Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>			
			</SList>
			</xsl:if>
		</StrAutoDefPrtFmt>
	</xsl:template>

	<!-- ������Ϣ -->
	<xsl:template name="Risk" match="Risk">
		<PCInfo>
			<PCIsMajor>
				<xsl:if test="RiskCode != MainRiskCode">N</xsl:if>
				<xsl:if test="RiskCode = MainRiskCode">Y</xsl:if>
			</PCIsMajor>
			<BelongMajor>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="MainRiskCode" />
				</xsl:call-template>
			</BelongMajor>
			<PCCode>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="RiskCode" />
				</xsl:call-template>
			</PCCode>
			<PCType>
			    <xsl:call-template name="tran_riskType">
					<xsl:with-param name="pcType" select="RiskType" />
				</xsl:call-template>
			</PCType>
			<PCNumber>
				<xsl:value-of select="..//ContPlan/ContPlanMult" />
			</PCNumber>
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
			</Amnt>
			<Premium>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
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
			<PayPeriodType></PayPeriodType>
			<LoanTerm></LoanTerm>
			<InsuranceTerm></InsuranceTerm>
			<!-- ������������ -->
			<xsl:if test = "..//ContPlan/ContPlanCode = '50015'">
			    <CovPeriodType>1</CovPeriodType>			
			</xsl:if>
			<xsl:if test = "..//ContPlan/ContPlanCode != '50015'">
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
			</xsl:if>
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
			<xsl:when test="$riskcode='122046'">LNABZX02</xsl:when>
			<!-- 50002(50015)-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,122048 - ����������������գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �������� -->
	<xsl:template name="tran_riskType">
		<xsl:param name="pcType" />
		<xsl:choose>
			<xsl:when test="$pcType='1'">0</xsl:when><!-- ��ͳ�� -->
			<xsl:when test="$pcType='2'">1</xsl:when><!-- �ֺ� -->
			<xsl:when test="$pcType='3'">2</xsl:when><!-- Ͷ�� -->
			<xsl:when test="$pcType='4'">3</xsl:when><!-- ���� -->
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
</xsl:stylesheet>
