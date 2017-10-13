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
	    <xsl:variable name="CashValueCount" select="count(//CashValue)"/>
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
					<xsl:apply-templates select="//Risk" />
				</PCCategory>
			</PClist>
		</PlanCodeInfo>
		<SpecialAgreement />
		<PolBenefitCount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillWith0($CashValueCount,2)" /></PolBenefitCount>
		<xsl:if test="$CashValueCount > 0">
			<xsl:apply-templates select="//CashValue" />
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
				<xsl:variable name="SumPremYuan" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
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
				<Context><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></Context>
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
				<Context><xsl:text>����������������������������              �����ڼ�    ��������    �������ս��    ���շ�      ����Ƶ��</xsl:text></Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<xsl:for-each select="Risk">
				<xsl:variable name="PayIntv" select="PayIntv"/>
				<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
				<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
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
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 12)"/>
											</xsl:when>
											<xsl:when test="PayEndYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 12)"/>
											</xsl:when>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',16)"/>
											</xsl:when>
											<xsl:when test="$ProductCode = '122019'">
												<!--��ũ2�űȽ�����-->
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',16)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,16)"/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Prem,14)"/>
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
				</xsl:for-each>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>���������շѺϼƣ�<xsl:value-of select="PremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>Ԫ����</Context>
				<Context>��</Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context>������------------------------------------------------------------------------------------------------</Context>
				<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
				<Context>���������յ��ر�Լ����<xsl:choose>
										<xsl:when test="$SpecContent=''">
											<xsl:text>���ޣ�</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$SpecContent"/>
										</xsl:otherwise>
									</xsl:choose></Context>
				<Context>��</Context>
				<Context>������-------------------------------------------------------------------------------------------------</Context>
				<Context>
					<xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</Context>
				<Context>��</Context>
				<Context>��</Context>
				<Context><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></Context>
				<Context>��</Context>
				<Context><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></Context>
				<Context>��</Context>
				<Context><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></Context>
				<Context>��</Context>
				<Context><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></Context>
				<Context><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Context>
				<Context>��</Context>
				<Context><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>ҵ�����֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode,0)"/></Context>
				<Context><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></Context>
			</SList>
			
			<xsl:if test="$CashValueCount > 0">
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
				<Context>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </Context>
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
					<xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Context>
				<Context><xsl:text/>�������������ĩ<xsl:text>                                        </xsl:text>
						   <xsl:text>�ֽ��ֵ</xsl:text></Context>
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
			<PCType></PCType>
			<PCNumber>
				<xsl:value-of select="Mult" />
			</PCNumber>
			<Amnt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
			</Amnt>
			<Premium>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
			</Premium>
			<OthAmnt></OthAmnt>
			<OthPremium></OthPremium>
			<StableBenifit></StableBenifit>
			<InitFeeRate></InitFeeRate>
			<Rate></Rate>
			<BonusPayMode></BonusPayMode>
			<BonusAmnt></BonusAmnt>
			<PayTermType></PayTermType>
			<PayPeriodType></PayPeriodType>
			<LoanTerm></LoanTerm>
			<InsuranceTerm></InsuranceTerm>
			<PayYear></PayYear>
			<CovPeriodType></CovPeriodType>
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
		<xsl:otherwise>--  </xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122018'">000406</xsl:when>
			<!-- �����ũ1 -->
			<xsl:when test="$riskcode='122019'">000407</xsl:when>
			<!-- �����ũ2  -->
			<xsl:when test="$riskcode='L12079'">000408</xsl:when>
			<!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test="$riskcode='L12078'">000409</xsl:when>
			<!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test="$riskcode='122009'">000410</xsl:when>
			<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
