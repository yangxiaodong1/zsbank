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
		<xsl:variable name="ContPlan" select="ContPlan" />
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<OLife>
			<Holding id="cont">
				<!-- ������Ϣ -->
				<Policy>
					<!-- ������ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!-- ���մ��� -->
					<ProductCode>
						<xsl:value-of select="$ContPlan/ContPlanCode" />
					</ProductCode>
					<!--  ����״̬  -->
					<PolicyStatus>A</PolicyStatus>
					<!--  �����ֽ��ֵ��Ԥ������ȡ����ֵ�뷵���㣩  -->
					<PolicyValue>0.00</PolicyValue>
					<!--  ���ѷ�ʽ  -->
					<PaymentMode>
						<xsl:apply-templates select="$MainRisk/PayIntv" />
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
					<!--  ���и����˻�  -->
					<AccountNumber></AccountNumber>
					<!--  ����  -->
					<AcctHolderName></AcctHolderName>
					<Life>
						<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />
					</Life>
					<ApplicationInfo>
						<!--  Ͷ������  -->
						<HOAppFormNumber>
							<xsl:value-of select="ProposalPrtNo" />
						</HOAppFormNumber>
						<!--  Ͷ�����ڣ�8λ���ָ�ʽYYYYMMDD������Ϊ�գ�  -->
						<SubmissionDate>
							<xsl:value-of select="$MainRisk/PolApplyDate" />
						</SubmissionDate>
					</ApplicationInfo>
					<OLifeExtension>
						<!--  �������Ƿ�Ϊ������־  -->
						<BeneficiaryIndicator>
							<xsl:choose>
								<xsl:when test="count(Bnf) = 0">Y</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</BeneficiaryIndicator>
						<!--  Ͷ��ʱ��ѡ��Ԥ����  -->
						<InvestDateInd />
					</OLifeExtension>
				</Policy>
			</Holding>

			<!--  Ͷ������Ϣ  -->
			<xsl:apply-templates select="Appnt" />

			<!--  ��������Ϣ  -->
			<xsl:apply-templates select="Insured" />

			<!--  ��������Ϣ  -->
			<xsl:apply-templates select="Bnf" />

		</OLife>
	</xsl:template>

	<!-- ������Ϣ -->
	<xsl:template name="Coverage" match="Risk">
		<xsl:variable name="ContPlan" select="../ContPlan" />
		<xsl:variable name="RiskId" select="concat('Cov_', string(position()))" />
		<Coverage>
			<xsl:attribute name="id"><xsl:value-of select="$RiskId" /></xsl:attribute>
			<!-- �������� -->
			<PlanName>
				<!-- 
				<xsl:value-of select="RiskName" />
				 -->
				<xsl:value-of select="$ContPlan/ContPlanName" />
			</PlanName>
			<!-- ���ִ��� -->
			<ProductCode>
				<!-- 
				<xsl:value-of select="RiskCode" />
				 -->
				<xsl:value-of select="$ContPlan/ContPlanCode" />
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
				<xsl:apply-templates select="PayIntv" />
			</PaymentMode>
			<!-- Ͷ����� -->
			<InitCovAmt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
			</InitCovAmt>
			<!-- Ͷ���ݶ� -->
			<IntialNumberOfUnits>
				<!-- 
				<xsl:value-of select="Mult" />
				 -->
				<xsl:value-of select="$ContPlan/ContPlanMult" />
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

				<!-- �����ڼ� ��Ҫ����ת��-->
				<!-- ������-->
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


	<xsl:template match="Insured">
		<!-- ������ -->
		<Party id="insured">
			<!-- Ͷ��������10�ֽ� -->
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<!-- Ͷ����֤������1�ֽ� -->
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<!-- �Ա� -->
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<!-- �������� YYYYMMDD-->
				<BirthDate>
					<xsl:value-of select="Birthday" />
				</BirthDate>
				<MarStat />
				<!--  �����˻���״�� -->
				<Citizenship>
					<xsl:apply-templates select="Nationality" />
				</Citizenship>
				<!--  ���� -->
				<VisaExpDate>0</VisaExpDate>
				<!--  ǩ֤�����գ�8λ���ָ�ʽYYYYMMDD������Ϊ�գ� -->
			</Person>
			<Address  id="Address_Insured">
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<Phone  id="Phone_Insured_Home"><!-- ��ͥ�绰 -->
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<Phone  id="Phone_Insured_Mobile"><!-- �ƶ��绰 -->
				<PhoneTypeCode tc="12">12</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
			<EMailAddress id="EMailAddress_Insured">
				<AddrLine />
				<!--  �����˵����ʼ���ַ  -->
			</EMailAddress>
		</Party>

		<!-- �����˹�ϵ -->
		<Relation OriginatingObjectID="cont" RelatedObjectID="insured"
			id="r_cont_insured">
			<OriginatingObjectType tc="4">4</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode tc="32">32</RelationRoleCode>
		</Relation>
	</xsl:template>

	<xsl:template match="Appnt">
		<!-- Ͷ������Ϣ -->
		<Party id="appnt">
			<!-- Ͷ��������10�ֽ� -->
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<!-- Ͷ����֤������1�ֽ� -->
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<!-- �Ա� -->
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<!-- �������� YYYYMMDD-->
				<BirthDate>
					<xsl:value-of select="Birthday" />
				</BirthDate>
				<MarStat />
				<!--  �����˻���״�� -->
				<Citizenship>
					<xsl:apply-templates select="Nationality" />
				</Citizenship>
				<!--  ���� -->
				<VisaExpDate>0</VisaExpDate>
				<!--  ǩ֤�����գ�8λ���ָ�ʽYYYYMMDD������Ϊ�գ� -->
			</Person>
			<Address  id="Address_Appnt">
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<Phone  id="Phone_Appnt_Home"><!-- ��ͥ�绰 -->
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<Phone  id="Phone_Appnt_Mobile"><!-- �ƶ��绰 -->
				<PhoneTypeCode tc="12">12</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
			<EMailAddress id="EMailAddress_Appnt">
				<AddrLine />
				<!--  �����˵����ʼ���ַ  -->
			</EMailAddress>
		</Party>

		<!-- Ͷ���˹�ϵ -->
		<Relation OriginatingObjectID="cont" RelatedObjectID="appnt"
			id="r_cont_appnt">
			<OriginatingObjectType tc="4">4</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode tc="25">25</RelationRoleCode>
		</Relation>

		<!-- Ͷ�����뱻���˵Ĺ�ϵ -->
		<Relation OriginatingObjectID="appnt" RelatedObjectID="insured"
			id="r_insured_appnt">
			<OriginatingObjectType tc="6">6</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode>
				<xsl:call-template name="tran_RelaToInsured">
					<xsl:with-param name="rela">
						<xsl:value-of select="RelaToInsured" />
					</xsl:with-param>
				</xsl:call-template>
			</RelationRoleCode>
		</Relation>
	</xsl:template>


	<xsl:template match="Bnf">
		<xsl:variable name="BnfId"
			select="concat('bnf_', string(position()))" />
		<!-- ��������Ϣ -->
		<Party>
			<xsl:attribute name="id"><xsl:value-of select="$BnfId" />
			</xsl:attribute>
			<!-- Ͷ��������10�ֽ� -->
			<FullName>
				<xsl:value-of select="Name" />
			</FullName>
			<!-- Ͷ����֤������1�ֽ� -->
			<GovtIDTC>
				<xsl:apply-templates select="IDType" />
			</GovtIDTC>
			<GovtID>
				<xsl:value-of select="IDNo" />
			</GovtID>
			<Person>
				<!-- �Ա� -->
				<Gender>
					<xsl:apply-templates select="Sex" />
				</Gender>
				<!-- �������� YYYYMMDD Ĭ��Ϊ0-->
				<BirthDate>0</BirthDate>
				<MarStat />
				<!--  �����˻���״�� -->
				<Citizenship>
					<xsl:apply-templates select="Nationality" />
				</Citizenship>
				<!--  ���� -->
				<VisaExpDate>0</VisaExpDate>
				<!--  ǩ֤�����գ�8λ���ָ�ʽYYYYMMDD������Ϊ�գ� -->
			</Person>
			<Address>
				<xsl:attribute name="id"><xsl:value-of
						select="concat('Address_', $BnfId)" />
			</xsl:attribute>
				<AddressTypeCode tc="1">1</AddressTypeCode>
				<Line1>
					<xsl:value-of select="Address" />
				</Line1>
				<Zip>
					<xsl:value-of select="ZipCode" />
				</Zip>
			</Address>
			<Phone><!-- ��ͥ�绰 -->
				<xsl:attribute name="id"><xsl:value-of
						select="concat('Phone_Home_', $BnfId)" />
			</xsl:attribute>
				<PhoneTypeCode tc="1">1</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Phone" />
				</DialNumber>
			</Phone>
			<Phone><!-- �ƶ��绰 -->
				<xsl:attribute name="id"><xsl:value-of
						select="concat('Phone_Mobile_', $BnfId)" />
			</xsl:attribute>
				<PhoneTypeCode tc="12">12</PhoneTypeCode>
				<DialNumber>
					<xsl:value-of select="Mobile" />
				</DialNumber>
			</Phone>
			<EMailAddress>
				<xsl:attribute name="id"><xsl:value-of
						select="concat('EMailAddress_', $BnfId)" />
			</xsl:attribute>
				<AddrLine>
					<xsl:value-of select="Email" />
				</AddrLine>
				<!--  �����˵����ʼ���ַ  -->
			</EMailAddress>
		</Party>

		<!-- �����˹�ϵ -->
		<Relation OriginatingObjectID="cont">
			<xsl:attribute name="RelatedObjectID"><xsl:value-of
					select="$BnfId" />
			</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of
					select="concat('r_cont_', $BnfId)" />
			</xsl:attribute>
			<OriginatingObjectType tc="4">4</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode tc="34">34</RelationRoleCode>
			<Sequence>
				<xsl:value-of select="Grade" />
			</Sequence>
			<InterestPercent>
				<xsl:value-of select="Lot" />
			</InterestPercent>
		</Relation>

		<!-- �������뱻���˹�ϵ -->
		<Relation OriginatingObjectID="insured">
			<xsl:attribute name="RelatedObjectID"><xsl:value-of
					select="$BnfId" />
			</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of
					select="concat('r_insured_', $BnfId)" />
			</xsl:attribute>
			<OriginatingObjectType tc="6">6</OriginatingObjectType>
			<RelatedObjectType tc="6">6</RelatedObjectType>
			<RelationRoleCode>
				<xsl:call-template name="tran_BnfRelaToInsured">
					<xsl:with-param name="rela">
						<xsl:value-of select="RelaToInsured" />
					</xsl:with-param>
				</xsl:call-template>
			</RelationRoleCode>
		</Relation>

	</xsl:template>

	<!-- ���ؽɷѷ�ʽ -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">12</xsl:when><!-- ��� -->
			<xsl:when test=".='1'">1</xsl:when><!-- �½� -->
			<xsl:when test=".='0'">0</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�����/�������� -->
	<xsl:template name="tran_payendyearflag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- �� -->
			<xsl:when test=".='M'">M</xsl:when><!-- �� -->
			<xsl:when test=".='D'">D</xsl:when><!-- �� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �����������ڱ�־ -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- �걣 -->
			<xsl:when test=".='M'">M</xsl:when><!-- �±� -->
			<xsl:when test=".='D'">D</xsl:when><!-- �ձ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">P01</xsl:when><!-- ���֤ -->
			<xsl:when test=".='9'">P03</xsl:when><!-- ��ʱ���֤  -->
			<xsl:when test=".='2'">P04</xsl:when><!-- ����֤ -->
			<xsl:when test=".='5'">P16</xsl:when><!-- ���ڱ�  -->
			<xsl:when test=".='1'">P31</xsl:when><!-- ���� -->
		<!-- PBKINSR-506 ��������ͨ����������֤������ -->
			<xsl:when test=".='6'">P20</xsl:when><!-- �۰Ļ���֤ -->
			<xsl:when test=".='7'">P21</xsl:when><!-- ̨��֤ -->
		<!-- PBKINSR-506 ��������ͨ����������֤������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �Ա� -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">M</xsl:when><!-- �� -->
			<xsl:when test=".='1'">F</xsl:when><!-- Ů -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ��ϵ �����Ǳ���������Ͷ���˵�ĳĳ-->
	<xsl:template name="tran_RelaToInsured">
		<xsl:param name="rela" />
		<xsl:choose>
			<xsl:when test="$rela='00'">1</xsl:when><!-- ���� -->
			<xsl:when test="$rela='01'">4</xsl:when><!-- ���ĸ�ĸ ������Ů-->
			<xsl:when test="$rela='02'">3</xsl:when><!-- ��ż -->
			<xsl:when test="$rela='03'">2</xsl:when><!-- ������Ů ���и�ĸ-->
			<xsl:when test="$rela='04'">5</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>

	<!-- �������뱻�����˵Ĺ�ϵ-->
	<xsl:template name="tran_BnfRelaToInsured">
		<xsl:param name="rela" />
		<xsl:choose>
			<xsl:when test="$rela='01'">2</xsl:when><!-- ��ĸ -->
			<xsl:when test="$rela='02'">3</xsl:when><!-- ��ż -->
			<xsl:when test="$rela='03'">4</xsl:when><!-- ��Ů -->
			<xsl:when test="$rela='04'">5</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ����ת�� -->
	<xsl:template match="Nationality">
		<xsl:choose>
			<xsl:when test=".='HU'">HUN</xsl:when><!--	������     -->
			<xsl:when test=".='US'">USA</xsl:when><!--	����     -->
			<xsl:when test=".='TH'">THA</xsl:when><!--	̩��     -->
			<xsl:when test=".='SG'">SGP</xsl:when><!--	�¼���   -->
			<xsl:when test=".='IN'">IND</xsl:when><!--  ӡ��   -->
			<xsl:when test=".='BE'">BEL</xsl:when><!--	����ʱ     -->
			<xsl:when test=".='NL'">NLD</xsl:when><!--	����     -->
			<xsl:when test=".='MY'">MYS</xsl:when><!--	�������� -->
			<xsl:when test=".='KR'">KOR</xsl:when><!--	����     -->
			<xsl:when test=".='JP'">JPN</xsl:when><!--	�ձ�     -->
			<xsl:when test=".='AT'">AUT</xsl:when><!--	�µ���   -->
			<xsl:when test=".='FR'">FRA</xsl:when><!--	����     -->
			<xsl:when test=".='ES'">ESP</xsl:when><!--	������   -->
			<xsl:when test=".='GB'">GBR</xsl:when><!--	Ӣ��     -->
			<xsl:when test=".='CA'">CAN</xsl:when><!--	���ô�   -->
			<xsl:when test=".='AU'">AUS</xsl:when><!--	�Ĵ����� -->
			<xsl:when test=".='CHN'">CHN</xsl:when><!--	�й�     -->
			<xsl:otherwise></xsl:otherwise><!--	����     -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
