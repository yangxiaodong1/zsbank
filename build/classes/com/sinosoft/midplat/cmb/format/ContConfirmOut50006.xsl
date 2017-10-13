<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<xsl:if test="TranData/Head/Flag='0'">
					<xsl:apply-templates select="TranData/Body" />
				</xsl:if>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
 
	<xsl:template name="OLife" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<OLife>
			<Holding id="Holding_1">
				<!-- ������Ϣ -->
				<Policy>
					<!-- ������ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!-- ���մ��� -->
					<ProductCode>
						<xsl:value-of select="ContPlan/ContPlanCode" />
					</ProductCode>
					<!--  ���ѷ�ʽ  -->
					<PaymentMode>
						<xsl:call-template name="tran_PayIntv">
							<xsl:with-param name="PayIntv">
								<xsl:value-of select="$MainRisk/PayIntv" />
							</xsl:with-param>
						</xsl:call-template>
					</PaymentMode>
					<!-- ���պ�ͬ��Ч���� -->
					<EffDate>
						<xsl:value-of select="$MainRisk/CValiDate" />
					</EffDate>
					<!-- �б����� -->
					<IssueDate>
						<xsl:value-of select="$MainRisk/SignDate" />
					</IssueDate>
					<!--  ��ֹ����  -->
					<TermDate>
						<xsl:value-of select="$MainRisk/InsuEndDate" />
					</TermDate>
					<!--  ������ֹ����  -->
					<FinalPaymentDate>
						<xsl:value-of select="$MainRisk/PayEndDate" />
					</FinalPaymentDate>
					<!--���ڱ���-->
					<PaymentAmt>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
					</PaymentAmt>
					<!--  ������ʽ��T��ת�ˣ�  -->
					<PaymentMethod tc="T">T</PaymentMethod>
					<Life>
						<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />
					</Life>
				</Policy>
			</Holding>

			<Party id="CAR_PTY_1">
				<FullName>�������ٱ��չɷ����޹�˾</FullName>
				<!--  ���չ�˾����  -->
			</Party>

			<Relation OriginatingObjectID="Holding_1"
				RelatedObjectID="CAR_PTY_1" id="RLN_HLDP_1C">
				<OriginatingObjectType tc="4">4</OriginatingObjectType>
				<RelatedObjectType tc="6">6</RelatedObjectType>
				<RelationRoleCode tc="87">87</RelationRoleCode>
				<!--  �б���˾��ϵ  -->
			</Relation>


			<!--�������д�ӡ�ӿ�-->
			<OLifeExtension>
				<BasePlanPrintInfos id="BaseInfos">
				<ContPrint>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></PrintInfo>
					<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo>
						<xsl:text>������Ͷ����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
						<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Appnt/IDType" />
						<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
					</PrintInfo>
					<PrintInfo>
						<xsl:text>�������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
						<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Insured/IDType" />
						<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
					</PrintInfo>
					<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
					<xsl:if test="count(Bnf) = 0">
					<PrintInfo><xsl:text>��������������ˣ�����                </xsl:text>
							   <xsl:text>����˳��1                   </xsl:text>
							   <xsl:text>���������100%</xsl:text></PrintInfo>
					</xsl:if>
					<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
					<PrintInfo>
						<xsl:text>��������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
						<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
						<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
					</PrintInfo>
					</xsl:for-each>
					</xsl:if>
					<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo>��������������</PrintInfo>
					<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo><xsl:text>�������������������������������������������������������������������������ս��\</xsl:text></PrintInfo>
					<PrintInfo><xsl:text>����������������������������              �����ڼ�    ��������      �ս�����\     ���շ�     ����Ƶ��</xsl:text></PrintInfo>
					<PrintInfo><xsl:text>������������������������������������������������������������������  ����\����</xsl:text></PrintInfo>
					<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
					<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
			
					<PrintInfo><xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
			  								  <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
										<xsl:choose>
											<xsl:when test="PayIntv = 0">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('1��', 10)"/>
											</xsl:when>
											<xsl:when test="PayEndYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 10)"/>
											</xsl:when>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',16)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,16)"/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
										<xsl:choose>
											<xsl:when test="PayIntv = 0">
												<xsl:text>����</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = 12">
												<xsl:text>�꽻</xsl:text>
											</xsl:when>
										</xsl:choose>
						</PrintInfo>
						
					</xsl:for-each>
					<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
					<xsl:variable name="SpecContent" select="SpecContent"/>
					<PrintInfo>���������յ��ر�Լ����</PrintInfo>
					<PrintInfo><xsl:text>������    ������ı��ղ�ƷΪ���������Ӯ1������ռƻ���������ӳ�����Ӯ�����գ������ͣ�Ϊ����˾</xsl:text></PrintInfo>
					<PrintInfo><xsl:text>���������ͱ��գ���������ȡ���շѡ������ڸø����պ�ͬ��Ч���������˱�������˾���˻��ø����պ�ͬ���µ���</xsl:text></PrintInfo>
					<PrintInfo><xsl:text>���������ֵ����ֵ���������ڱ��շ�5%�Ľ��ڸ�������Ч��һ�������ĩ���һ��24ʱע�븽���������˻���</xsl:text></PrintInfo>
					<!-- PBKINSR-506 ��������ͨ����������֤������ -->
					<xsl:variable name="AppIDType" select="Appnt/IDType"/>
					<xsl:variable name="InsIDType" select="Insured/IDType"/>
					<xsl:choose>
						<xsl:when test="$AppIDType='6' or $AppIDType='7' or $InsIDType='6' or $InsIDType='7'">
							<PrintInfo>
								<xsl:text>������    ����ͬ���ᵽ�ġ��۰Ļ���֤��Ϊ���۰ľ���������½ͨ��֤����ƣ�����ͬ���ᵽ�ġ�̨��֤��Ϊ��̨</xsl:text>									
							</PrintInfo>
							<PrintInfo>
								<xsl:text>�����������������½ͨ��֤����ơ�</xsl:text>
							</PrintInfo>
						</xsl:when>
						<xsl:otherwise>
							<PrintInfo/>
							<PrintInfo/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- PBKINSR-506 ��������ͨ����������֤������ -->
					<PrintInfo>������-------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo>
						<xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></PrintInfo>
					<PrintInfo><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></PrintInfo>
					<PrintInfo><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/><xsl:text>��ҵ�ʸ�֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 0)"/></PrintInfo>
				</ContPrint>
				<CashValue>
				 	<!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
					<xsl:if test="$MainRisk/CashValues/CashValue != ''">
						<xsl:variable name="RiskCount" select="count(Risk)"/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</PrintInfo>
						<PrintInfo/>
						<PrintInfo>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </PrintInfo>
						<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
						<PrintInfo>��������������������<xsl:value-of select="Insured/Name"/></PrintInfo>
				        <PrintInfo>
					    <xsl:text>�������������ƣ�                  </xsl:text><xsl:text>                    </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PrintInfo>
				        <PrintInfo><xsl:text/>�������������ĩ<xsl:text>                                              </xsl:text><xsl:text>�ֽ��ֵ</xsl:text></PrintInfo>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <PrintInfo><xsl:text/><xsl:text>����������</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,37)"/>
												<xsl:text>               </xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</PrintInfo>
					    </xsl:for-each>
			            </xsl:if>
			 
						<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>
						<PrintInfo/>
						<PrintInfo>��������ע��</PrintInfo>
						<PrintInfo>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</PrintInfo>
						<PrintInfo>������------------------------------------------------------------------------------------------------</PrintInfo>	
				</CashValue>				
				</BasePlanPrintInfos>
			</OLifeExtension>
		</OLife>
	</xsl:template>

	<!-- ������Ϣ -->
	<xsl:template name="Coverage" match="Risk">
			<xsl:variable name="RiskId" select="concat('Cov_', string(position()))" />
		<Coverage>
			<xsl:attribute name="id"><xsl:value-of select="$RiskId" /></xsl:attribute>
			<!-- �������� -->
			<PlanName>
				<xsl:value-of select="../ContPlan/ContPlanName" />
			</PlanName>
			<!-- ���ִ��� -->
			<ProductCode>
				<xsl:value-of select="../ContPlan/ContPlanCode" />
			</ProductCode>
			<!-- �����ձ�־ -->
			<xsl:choose>
				<xsl:when test="RiskCode=MainRiskCode">
					<IndicatorCode tc="1">1</IndicatorCode>
				</xsl:when><!-- ���ձ�־ -->
				<xsl:otherwise>
					<IndicatorCode tc="2">2</IndicatorCode>
				</xsl:otherwise><!-- ���ձ�־ -->
			</xsl:choose>
			<!-- �ɷѷ�ʽ Ƶ�� -->
			<PaymentMode>
				<xsl:call-template name="tran_PayIntv">
					<xsl:with-param name="PayIntv">
						<xsl:value-of select="PayIntv" />
					</xsl:with-param>
				</xsl:call-template>
			</PaymentMode>
			<!-- Ͷ����� -->
			<InitCovAmt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
			</InitCovAmt>
			<!-- Ͷ���ݶ� -->
			<IntialNumberOfUnits>
				<xsl:value-of select="../ContPlan/ContPlanMult" />
			</IntialNumberOfUnits>
			<!-- ���ֱ��� -->
			<ChargeTotalAmt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../ActSumPrem)" />
			</ChargeTotalAmt>
			<OLifeExtension>
				<!--  ��������/��������  -->
				<!--  ��������/���䣨�������ͣ�����Ϊ�գ�  -->
				<xsl:choose>
					<xsl:when test="PayIntv = '0'">
						<PaymentDurationMode>Y</PaymentDurationMode>
						<PaymentDuration>0</PaymentDuration>
					</xsl:when><!--  ����  -->
					<xsl:otherwise>
						<PaymentDurationMode>
							<xsl:apply-templates
								select="PayEndYearFlag" />
						</PaymentDurationMode>
						<PaymentDuration>
							<xsl:value-of select="PayEndYear" />
						</PaymentDuration>
					</xsl:otherwise>
				</xsl:choose>

				<!-- �����ڼ� ��Ҫ����ת��,����ط���Ҫת����ת�������Ͽɵı�����-->
				<DurationMode>Y</DurationMode>
				<Duration>100</Duration>
				<!--  ��ȡ����/��������  -->
				<PayoutDurationMode></PayoutDurationMode>
				<!--  ��ȡ����/���䣨�������ͣ�����Ϊ�գ�  -->
				<PayoutDuration>0</PayoutDuration>
				<!--  ��ȡ��ʼ���䣨�������ͣ�����Ϊ�գ� -->
				<PayoutStart>0</PayoutStart>
				<!--  ��ȡ��ֹ���䣨�������ͣ�����Ϊ�գ� -->
				<PayoutEnd>0</PayoutEnd>

				<!-- �ֽ��ֵ��û�еĻ������ڵ㲻���أ� -->
				<xsl:if test="count(CashValues/CashValue) > 0">
					<CashValues>
						<xsl:for-each select="CashValues/CashValue">
							<CashValue>
								<!-- ��ĩ���������ͣ�����Ϊ�գ� -->
								<End>
									<xsl:value-of select="EndYear" />
								</End>
								<!-- ��ĩ�ֽ��ֵ���������ͣ�����Ϊ�գ� -->
								<Cash>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)" />
								</Cash>
							</CashValue>
						</xsl:for-each>
					</CashValues>
				</xsl:if>

				<!-- ������������ĩ�ֽ��ֵ��û�еĻ������ڵ㲻���أ� -->
				<xsl:if test="count(BonusValues/BonusValue) > 0">
					<BonusValues>
						<xsl:for-each select="BonusValues/BonusValue">
							<BonusValue>
								<!-- ��ĩ���������ͣ�����Ϊ�գ� -->
								<End>
									<xsl:value-of select="EndYear" />
								</End>
								<!-- ��ĩ�ֽ��ֵ���������ͣ�����Ϊ�գ� -->
								<Cash>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EndYearCash)" />
								</Cash>
							</BonusValue>
						</xsl:for-each>
					</BonusValues>
				</xsl:if>
			</OLifeExtension>
		</Coverage>
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
		<!-- PBKINSR-506 ��������ͨ����������֤������ -->
			<xsl:when test=".=6">�۰Ļ���֤</xsl:when>
			<xsl:when test=".=7">̨��֤    </xsl:when>
		<!-- PBKINSR-506 ��������ͨ����������֤������ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ؽɷѷ�ʽ -->
	<xsl:template name="tran_PayIntv">
		<xsl:param name="PayIntv"></xsl:param>
		<xsl:choose>
			<xsl:when test="$PayIntv='12'">12</xsl:when><!-- ��� -->
			<xsl:when test="$PayIntv='1'">1</xsl:when><!-- �½� -->
			<xsl:when test="$PayIntv='0'">0</xsl:when><!-- ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�����/�������� -->
	<xsl:template name="tran_payendyearflag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- �� -->
			<xsl:when test=".='M'">M</xsl:when><!-- �� -->
			<xsl:when test=".='D'">D</xsl:when><!-- �� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �����������ڱ�־ -->
	<xsl:template name="tran_InsuYearFlag">
		<xsl:param name="InsuYearFlag"></xsl:param>
		<xsl:choose>
			<xsl:when test="$InsuYearFlag='A'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test="$InsuYearFlag='Y'">Y</xsl:when><!-- �걣 -->
			<xsl:when test="$InsuYearFlag='M'">M</xsl:when><!-- �±� -->
			<xsl:when test="$InsuYearFlag='D'">D</xsl:when><!-- �ձ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".= 'Y'">��</xsl:when>
			<xsl:when test=".= 'A'">��</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="InsuYearFlag" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
