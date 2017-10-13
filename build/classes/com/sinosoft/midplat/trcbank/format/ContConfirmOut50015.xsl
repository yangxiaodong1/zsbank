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
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<!-- ���ղ�Ʒ��Ϣ -->	
			<PlanCodeInfo>	
				<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />			
			</PlanCodeInfo>
			<SpecialAgreement></SpecialAgreement><!-- ���չ�˾�ر�Լ�� -->
			<PolBenefitCount>00</PolBenefitCount>
			<PolBenefitInfoList>
				<YeadEnd></YeadEnd>
				<CashValue></CashValue>
			</PolBenefitInfoList>
			<IsUseAutoDefPrtFmt>Y</IsUseAutoDefPrtFmt><!-- Y/N �Ƿ�ʹ�ñ��չ�˾�Զ����ӡģʽ -->
			<DesignPrtFmt></DesignPrtFmt><!-- �״�ģ�� -->
			
			
			<!-- ��ӡ��Ϣ -->
			
			<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
            <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

			<StrAutoDefPrtFmt>
				<SCount>2</SCount><!-- ҳ�� -->
				<SList>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A<xsl:text>�����յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
	<xsl:text>               ��ֵ��λ�������Ԫ</xsl:text></Context>
					<Context>A��-------------------------------------------------------------------------------------</Context>
					<Context>A<xsl:text>��Ͷ����������</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 19)"/>
						<xsl:text>֤�����ͣ�</xsl:text>
						<xsl:apply-templates select="Appnt/IDType"/>
						<xsl:text>      ֤�����룺</xsl:text>
						<xsl:value-of select="Appnt/IDNo"/>
					</Context>
					<Context>A<xsl:text>���������ˣ�</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 21)"/>
						<xsl:text>֤�����ͣ�</xsl:text>
						<xsl:apply-templates select="Insured/IDType"/>
						<xsl:text>      ֤�����룺</xsl:text>
						<xsl:value-of select="Insured/IDNo"/>
					</Context>
					<Context>A</Context>
					<Context>A��-------------------------------------------------------------------------------------</Context>
					<Context>A��-------------------------------------------------------------------------------------</Context>
					<xsl:if test="count(Bnf) = 0">
					<Context>A<xsl:text>����������ˣ�����                </xsl:text>
					   <xsl:text>����˳��1                   </xsl:text>
					   <xsl:text>���������100%</xsl:text></Context>
			        </xsl:if>
					<xsl:if test="count(Bnf)>0">
						<xsl:for-each select="Bnf">
							<Context>A
								<xsl:text>����������ˣ�</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
								<xsl:text>����˳��</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
								<xsl:text>���������</xsl:text>
								<xsl:value-of select="Lot"/>
								<xsl:text>%</xsl:text>
							</Context>
						</xsl:for-each>
					</xsl:if>
					<Context>A</Context>
					<Context>A��-------------------------------------------------------------------------------------</Context>
					
					<Context>A����������</Context>
					<Context>A��-------------------------------------------------------------------------------------</Context>
					<Context>
						<xsl:text>A�����������������������������������������������������������ս��\</xsl:text>
					</Context>
					<Context>
						<xsl:text>A����������������               �����ڼ�   ��������    �ս�����\     ���շ�     ����Ƶ��</xsl:text>
					</Context>
					<Context>
						<xsl:text>A����������������������������������������������������������\����</xsl:text>
					</Context>
					<Context>A��-------------------------------------------------------------------------------------</Context>
					<xsl:for-each select="Risk">
						<xsl:variable name="PayIntv" select="PayIntv"/>
						<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
						<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
						
						<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
							<Context>A<xsl:text>��</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 31)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 9)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 9)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 9)"/>
										<xsl:text/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 11)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 11)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',14)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
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
						<Context>A<xsl:text>��</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 31)"/>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 9)"/>
							</xsl:when>
							<xsl:when test="InsuYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 9)"/>
							</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 9)"/>
										<xsl:text/>
								</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PayIntv = 0">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ�ν���', 11)"/>
							</xsl:when>
							<xsl:when test="PayEndYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 11)"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',14)"/>
							</xsl:when>
						    <xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
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
					<Context>A��--------------------------------------------------------------------------------------</Context>
					<Context>A</Context>
					<Context>A�����շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A��--------------------------------------------------------------------------------------</Context>
					<Context>A</Context>
					<Context>A��--------------------------------------------------------------------------------------</Context>
					<xsl:variable name="SpecContent" select="SpecContent"/>
					<Context>A�����յ��ر�Լ����</Context>
						<xsl:choose>
							<xsl:when test="$SpecContent=''">
								<Context>A<xsl:text>���ޣ�</xsl:text></Context>
							</xsl:when>
							<xsl:otherwise>
								<Context>A������  ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾</Context>
								<Context>A�����˻����յ��ֽ��ֵ��</Context>
								<Context>A������  ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬ</Context>
								<Context>A��ͬʱ��ֹ�����������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��</Context>
								<Context>A�����������������գ������ͣ��ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</Context>
							</xsl:otherwise>
						</xsl:choose>
					<Context>A��---------------------------------------------------------------------------------------</Context>
					<Context>A<xsl:text>�����պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                    ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</Context>
					<Context>A<xsl:text>��Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></Context>
				
					<Context>A<xsl:text>��Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></Context>					
					<Context>A<xsl:text>���ͻ��������ߣ�95569                                 ��ַ��http://www.anbang-life.com</xsl:text></Context>
					<Context>A<xsl:text>��Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ����</xsl:text></Context>
					<Context>A<xsl:text>���ڱ�������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Context>
					<Context>A</Context>
					<Context>A<xsl:text>�������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 31)"/><xsl:text>���������˹��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 20)"/></Context>
					<Context>A<xsl:text>������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 31)"/><xsl:text>��ҵ�ʸ�֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 20)"/></Context>
				</SList>
				
				<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
				<xsl:variable name="RiskCount" select="count(Risk)"/>
				<xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
	 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
				<SList>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A</Context>
					<Context>A<xsl:text>������                                      </xsl:text>�ֽ��ֵ��</Context>
					<Context>A</Context>
					<Context>A�����յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 50)"/>��ֵ��λ�������Ԫ </Context>
					<Context>A��---------------------------------------------------------------------------------------</Context>
					<Context>A����������������<xsl:value-of select="Insured/Name"/></Context>
	                <xsl:if test="$RiskCount=1">
			        <Context>A<xsl:text>���������ƣ�                 </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Context>
			        <Context>A<xsl:text/>���������ĩ<xsl:text>                              </xsl:text>
					   <xsl:text>�ֽ��ֵ</xsl:text></Context>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <Context>A<xsl:text/><xsl:text>������</xsl:text>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</Context>
				    </xsl:for-each>
		            </xsl:if>
		 
		            <xsl:if test="$RiskCount!=1">
		 	        <Context>A<xsl:text>���������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Context>
			        <Context>A<xsl:text/>���������ĩ<xsl:text>                 </xsl:text>
					   <xsl:text>�ֽ��ֵ                                �ֽ��ֵ</xsl:text></Context>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <Context>A<xsl:text/><xsl:text>������</xsl:text>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</Context>
				    </xsl:for-each>
		            </xsl:if>
					<Context>A��---------------------------------------------------------------------------------------</Context>
					<Context>A</Context>
					<Context>A����ע��</Context>
					<Context>A�������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</Context>
					<Context>A��---------------------------------------------------------------------------------------</Context>
				</SList>
				</xsl:if>
			</StrAutoDefPrtFmt>
		</Body>
	</xsl:template>
	<!-- ������Ϣ -->
	<xsl:template name="Risk" match="Risk">
		<GetBankInfo><!-- ������ȡ��Ϣ -->
			<GetBankCode><xsl:value-of select="GetBankCode "/></GetBankCode><!-- ������ȡ���л����� -->
			<GetBankAccNo><xsl:value-of select="GetBankAccNo "/></GetBankAccNo><!-- ������ȡ�����˻� -->
			<GetAccName><xsl:value-of select="GetAccName "/></GetAccName><!-- ������ȡ�˻����� -->
			<!-- <InsureDate></InsureDate> Ͷ�����ڣ�ֻ�ޱ�����ѯ�����ã� -->
			<!-- <TotlePremium></TotlePremium> �������ѣ�ֻ�ޱ�����ѯ�����ã� -->
			<!-- <TotleAmnt></TotleAmnt> �������ֻ�ޱ�����ѯ�����ã� -->
			<!-- <Assumpsit></Assumpsit> �ر�Լ��?(ֻ�ޱ�����ѯ������) -->
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
					<!-- <Address></Address> ���ղƲ������ַ(ֻ���չ�Ӯ3�Ų�Ʒ����������) -->
					<!-- <PostCode></PostCode> ���ղƲ������ַ�ʱ�(ֻ���չ�Ӯ3�Ų�Ʒ����������) -->
					<!-- <HouseStru></HouseStru> ���ݽṹ(ֻ���չ�Ӯ3�Ų�Ʒ����������) -->
					<!-- <HousePurp></HousePurp> ������; -->
				</PCInfo>
			</PCCategory>
		</PClist>
	</xsl:template>
	
	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">���֤    </xsl:when>
			<xsl:when test=".=1">����      </xsl:when>
			<xsl:when test=".=2">����֤    </xsl:when>
			<xsl:when test=".=3">����      </xsl:when>
			<xsl:when test=".=4">����֤��  </xsl:when>
			<xsl:when test=".=5">���ڲ�    </xsl:when>
			<xsl:when test=".=8">����      </xsl:when>
			<xsl:when test=".=9">�쳣���֤</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �ɷѼ��  -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=0">һ�ν���</xsl:when>
			<xsl:when test=".=1">�½�</xsl:when>
			<xsl:when test=".=3">����</xsl:when>
			<xsl:when test=".=6">���꽻</xsl:when>
			<xsl:when test=".=12">�꽻</xsl:when>
			<xsl:when test=".=-1">�����ڽ�</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �Ա�ע�⣺����     ���ո��Ű��õģ�����ȥ����-->
	<xsl:template match="Sex">
		<xsl:choose>
			<xsl:when test=".=0">��</xsl:when>
			<xsl:when test=".=1">Ů</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode"/>
		<xsl:choose>
			<xsl:when test="$riskcode='50015'">50015</xsl:when>
			<!-- ��ϲ�Ʒ 50015-�������Ӯ���ռƻ�: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ������ȡ  -->
	<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">�ۼ���Ϣ</xsl:when>
			<xsl:when test=".=2">��ȡ�ֽ�</xsl:when>
			<xsl:when test=".=3">�ֽɱ���</xsl:when>
			<xsl:when test=".=5">�����</xsl:when>
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
</xsl:stylesheet>
