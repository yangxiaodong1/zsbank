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
		<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
        <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

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
						<xsl:apply-templates select="ContPlan/ContPlanCode" />
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
			
			<FormInstance id="Form_1">
				<FormName>����ӡˢ��</FormName>
				<ProviderFormNumber><xsl:value-of select="ContPrtNo" /></ProviderFormNumber>
			</FormInstance>
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
				<xsl:apply-templates select="../ContPlan/ContPlanCode" />
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
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../Amnt)" />
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

	<!-- ���ִ��� -->
	<xsl:template match="ContPlanCode" >
		<xsl:choose>
			<xsl:when test=".='50015'">50002</xsl:when><!-- �������Ӯ1����ȫ����-->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>