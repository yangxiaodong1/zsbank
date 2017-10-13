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
				<!-- 保单信息 -->
				<Policy>
					<!-- 保单号ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!-- 主险代码 -->
					<ProductCode>
						<xsl:apply-templates select="$MainRisk/RiskCode" />
					</ProductCode>
					<!--  交费方式  -->
					<PaymentMode>
						<xsl:call-template name="tran_PayIntv">
							<xsl:with-param name="PayIntv">
								<xsl:value-of select="$MainRisk/PayIntv" />
							</xsl:with-param>
						</xsl:call-template>
					</PaymentMode>
					<!-- 保险合同生效日期 -->
					<EffDate>
						<xsl:value-of select="$MainRisk/CValiDate" />
					</EffDate>
					<!-- 承保日期 -->
					<IssueDate>
						<xsl:value-of select="$MainRisk/SignDate" />
					</IssueDate>
					<!--  中止日期  -->
					<TermDate>
						<xsl:value-of select="$MainRisk/InsuEndDate" />
					</TermDate>
					<!--  交费终止日期  -->
					<FinalPaymentDate>
						<xsl:value-of select="$MainRisk/PayEndDate" />
					</FinalPaymentDate>
					<!--首期保费-->
					<PaymentAmt>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
					</PaymentAmt>
					<!--  交费形式（T：转账）  -->
					<PaymentMethod tc="T">T</PaymentMethod>
					<Life>
						<xsl:apply-templates select="Risk" />
					</Life>
					
					<ApplicationInfo>
						<HOAppFormNumber><xsl:value-of select="ProposalPrtNo" /></HOAppFormNumber>
						<!--  投保单号  -->
						<SubmissionDate><xsl:value-of select="$MainRisk/PolApplyDate" /></SubmissionDate>
						<!--  投保日期（8位数字格式YYYYMMDD，不能为空）  -->
					</ApplicationInfo>
				</Policy>
			</Holding>

			<Party id="CAR_PTY_1">
				<FullName>安邦人寿保险股份有限公司</FullName>
				<!--  保险公司名称  -->
			</Party>

			<Relation OriginatingObjectID="Holding_1"
				RelatedObjectID="CAR_PTY_1" id="RLN_HLDP_1C">
				<OriginatingObjectType tc="4">4</OriginatingObjectType>
				<RelatedObjectType tc="6">6</RelatedObjectType>
				<RelationRoleCode tc="87">87</RelationRoleCode>
				<!--  承保公司关系  -->
			</Relation>

			<FormInstance id="Form_1">
				<FormName>保单印刷号</FormName>
				<ProviderFormNumber><xsl:value-of select="ContPrtNo" /></ProviderFormNumber>
			</FormInstance>
		</OLife>
	</xsl:template>

	<!-- 险种信息 -->
	<xsl:template name="Coverage" match="Risk">
		<xsl:variable name="RiskId" select="concat('Cov_', string(position()))" />
		<Coverage>
			<xsl:attribute name="id"><xsl:value-of select="$RiskId" />
			</xsl:attribute>
			<!-- 险种名称 -->
			<PlanName>
				<xsl:value-of select="RiskName" />
			</PlanName>
			<!-- 险种代码 -->
			<ProductCode>
				<xsl:apply-templates select="RiskCode" />
			</ProductCode>
			<!-- 主副险标志 -->
			<xsl:choose>
				<xsl:when test="RiskCode=MainRiskCode">
					<IndicatorCode tc="1">1</IndicatorCode>
				</xsl:when><!-- 主险标志 -->
				<xsl:otherwise>
					<IndicatorCode tc="2">2</IndicatorCode>
				</xsl:otherwise><!-- 副险标志 -->
			</xsl:choose>
			<!-- 缴费方式 频次 -->
			<PaymentMode>
				<xsl:call-template name="tran_PayIntv">
					<xsl:with-param name="PayIntv">
						<xsl:value-of select="PayIntv" />
					</xsl:with-param>
				</xsl:call-template>
			</PaymentMode>
			<!-- 投保金额 -->
			<InitCovAmt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
			</InitCovAmt>
			<!-- 投保份额 -->
			<IntialNumberOfUnits>
				<xsl:value-of select="Mult" />
			</IntialNumberOfUnits>
			<!-- 险种保费 -->
			<ChargeTotalAmt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
			</ChargeTotalAmt>
			<OLifeExtension>
				<!--  交费年期/年龄类型  -->
				<!--  交费年期/年龄（数字类型，不能为空）  -->
				<xsl:choose>
					<xsl:when test="PayIntv = '0'">
						<PaymentDurationMode>Y</PaymentDurationMode>
						<PaymentDuration>0</PaymentDuration>
					</xsl:when><!--  趸交  -->
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

				<!-- 保险期间 需要特殊转换-->
				<xsl:choose>
					<xsl:when
						test="InsuYearFlag = 'A' and InsuYear=106">
						<DurationMode>Y</DurationMode>
						<Duration>100</Duration>
					</xsl:when><!-- 保终身-->
					<xsl:otherwise>
						<DurationMode>
							<xsl:call-template
								name="tran_InsuYearFlag">
								<xsl:with-param name="InsuYearFlag">
									<xsl:value-of select="InsuYearFlag" />
								</xsl:with-param>
							</xsl:call-template>
						</DurationMode>
						<Duration>
							<xsl:value-of select="InsuYear" />
						</Duration>
					</xsl:otherwise>
				</xsl:choose>
				<!--  领取年期/年龄类型  -->
				<PayoutDurationMode></PayoutDurationMode>
				<!--  领取年期/年龄（数字类型，不能为空）  -->
				<PayoutDuration>0</PayoutDuration>
				<!--  领取起始年龄（数字类型，不能为空） -->
				<PayoutStart>0</PayoutStart>
				<!--  领取终止年龄（数字类型，不能为空） -->
				<PayoutEnd>0</PayoutEnd>

				<!-- 现金价值表（没有的话整个节点不返回） -->
				<xsl:if test="count(CashValues/CashValue) > 0">
					<CashValues>
						<xsl:for-each select="CashValues/CashValue">
							<CashValue>
								<!-- 年末（数字类型，不能为空） -->
								<End>
									<xsl:value-of select="EndYear" />
								</End>
								<!-- 年末现金价值（数字类型，不能为空） -->
								<Cash>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)" />
								</Cash>
							</CashValue>
						</xsl:for-each>
					</CashValues>
				</xsl:if>
				
			</OLifeExtension>
		</Coverage>
	</xsl:template>

	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">身份证    </xsl:when>
			<xsl:when test=".=1">护照      </xsl:when>
			<xsl:when test=".=2">军官证    </xsl:when>
			<xsl:when test=".=3">驾照      </xsl:when>
			<xsl:when test=".=4">出生证明  </xsl:when>
			<xsl:when test=".=5">户口簿    </xsl:when>
			<xsl:when test=".=8">其他      </xsl:when>
			<xsl:when test=".=9">异常身份证</xsl:when>
		<!-- PBKINSR-506 招行银保通、网银新增证件类型 -->
			<xsl:when test=".=6">港澳回乡证</xsl:when>
			<xsl:when test=".=7">台胞证    </xsl:when>
		<!-- PBKINSR-506 招行银保通、网银新增证件类型 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 返回缴费方式 -->
	<xsl:template name="tran_PayIntv">
		<xsl:param name="PayIntv"></xsl:param>
		<xsl:choose>
			<xsl:when test="$PayIntv='12'">12</xsl:when><!-- 年缴 -->
			<xsl:when test="$PayIntv='1'">1</xsl:when><!-- 月缴 -->
			<xsl:when test="$PayIntv='0'">0</xsl:when><!-- 趸缴 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期/年龄类型 -->
	<xsl:template name="tran_payendyearflag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- 年 -->
			<xsl:when test=".='M'">M</xsl:when><!-- 月 -->
			<xsl:when test=".='D'">D</xsl:when><!-- 日 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年龄年期标志 -->
	<xsl:template name="tran_InsuYearFlag">
		<xsl:param name="InsuYearFlag"></xsl:param>
		<xsl:choose>
			<xsl:when test="$InsuYearFlag='A'">A</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test="$InsuYearFlag='Y'">Y</xsl:when><!-- 年保 -->
			<xsl:when test="$InsuYearFlag='M'">M</xsl:when><!-- 月保 -->
			<xsl:when test="$InsuYearFlag='D'">D</xsl:when><!-- 日保 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".= 'Y'">年</xsl:when>
			<xsl:when test=".= 'A'">岁</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="InsuYearFlag" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template match="RiskCode">
		<xsl:choose>
		
		<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号终身寿险（万能型）B款  -->		
		<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
		
			<xsl:when test=".='L12079'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
		<!-- PBKINSR-518 招行网银上线黄金鼎5号产品，暂不上线 -->
		<!-- 暂不上线	<xsl:when test=".='122009'">122009</xsl:when>--><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->	
		<!-- PBKINSR-518 招行网银上线黄金鼎5号产品 -->	
		<!-- PBKINSR-517 招行网银开发盛9 -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型） -->
		<!-- PBKINSR-517 招行网银开发盛9 -->
		<!-- PBKINSR-514 招行网银开发盛3 -->
			<xsl:when test=".='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
		<!-- PBKINSR-514 招行网银开发盛3 -->
		
		<!-- PBKINSR-1358 zx add -->
		<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型）-->
		<!-- PBKINSR- zx add -->
		<xsl:when test=".='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型）-->
		<!-- PBKINSR-1531 招行网银东风9号 L12088 zx add 20160805 -->
		<xsl:when test=".='L12088'">L12088</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
