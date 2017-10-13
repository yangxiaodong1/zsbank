<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>

	<xsl:template match="Body">
		<xsl:variable name="MainRisk"
			select="Risk[RiskCode=MainRiskCode]" />
		<App>
			<Ret>
				<!-- 保单号码 -->
				<PolicyNo>
					<xsl:value-of select="ContNo" />
				</PolicyNo>
				<!-- 保单印刷号 -->
				<VchNo>
					<xsl:value-of select="ProposalPrtNo" />
				</VchNo>
				
				<xsl:choose>
					<xsl:when test="ContPlan/ContPlanCode=''">
						<!-- 按险种出单 -->
						<!--险种编号 -->
						<RiskCode>
							<xsl:apply-templates select="$MainRisk/RiskCode"  mode="risk"/>
						</RiskCode>
						<!-- 险种名称 -->
						<RiskName>
							<xsl:value-of select="$MainRisk/RiskName" />
						</RiskName>
					</xsl:when>
					<xsl:otherwise>
						<!-- 按套餐出单 -->
						<!--套餐编号 -->
						<RiskCode>
							<xsl:apply-templates select="ContPlan/ContPlanCode" mode="contplan"/>
						</RiskCode>
						<!-- 套餐名称 -->
						<RiskName>
							<xsl:value-of select="ContPlan/ContPlanName" />
						</RiskName>
					</xsl:otherwise>
				</xsl:choose>

				<!-- 保单状态 -->
				<PolicyStatus>
					<xsl:apply-templates select="ContState" />
				</PolicyStatus>
				<!-- 保单质押状态 -->
				<PolicyPledge>
					<xsl:apply-templates select="MortStatu" />
				</PolicyPledge>
				<!-- 受理日期 -->
				<AcceptDate>
					<xsl:value-of select="$MainRisk/PolApplyDate" />
				</AcceptDate>
				<!-- 保单生效日期 -->
				<PolicyBgnDate>
					<xsl:value-of select="$MainRisk/CValiDate" />
				</PolicyBgnDate>
				<!-- 保单到期日-->
				<PolicyEndDate>
					<xsl:value-of select="$MainRisk/InsuEndDate" />
				</PolicyEndDate>
				<!-- 投保份数 -->
				<PolicyAmmount>
					<xsl:value-of select="$MainRisk/Mult" />
				</PolicyAmmount>
				<!-- 保费 -->
				<Amt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
				</Amt>
				<!-- 保额 -->
				<Beamt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
				</Beamt>
				<!-- 保单价值 -->
				<PolicyValue>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueD)" />
				</PolicyValue>
				
				
				<!-- 当前账户价值 -->
				<AccountValue>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueIntD)" />
				</AccountValue>
				<!-- 保险期间 -->
				<InsuDueDate>
					<!-- <xsl:value-of select="$MainRisk/Years" /> -->
					<xsl:choose>
						<xsl:when test="$MainRisk/InsuYearFlag='A' and $MainRisk/InsuYear='106'">终身</xsl:when>
						<xsl:otherwise><xsl:value-of select="$MainRisk/Years" /></xsl:otherwise>
					</xsl:choose>
				</InsuDueDate>
				<!-- 缴费方式 -->
				<PayType>
					<xsl:apply-templates select="$MainRisk/PayIntv" mode="PayType"/>
				</PayType>
				<!-- 缴费金额 -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
				</Prem>
				<!-- 缴费账户 -->
				<PayAccount>
					<xsl:value-of select="Account/AccNo" />
				</PayAccount>
				
				<!-- 投保人 -->
				<xsl:apply-templates select="Appnt" />
				<!-- 被保人 -->
				<xsl:apply-templates select="Insured" />
				<!-- 受益人 -->
				<xsl:for-each select="Bnf">
					<Bnfs>
						<!-- 受益人类型 -->
						<Type>
							<xsl:value-of select="Type" />
						</Type>
						<!-- 受益人姓名 -->
						<Name>
							<xsl:value-of select="Name" />
						</Name>
						<!-- 受益人性别 -->
						<Sex>
							<xsl:value-of select="Sex" />
						</Sex>
						<!-- 受益人证件类型 -->
						<IDKind>
							<xsl:apply-templates select="IDType" />
						</IDKind>
						<!-- 受益人证件号码 -->
						<IDCode>
							<xsl:value-of select="IDNo" />
						</IDCode>
						<!-- 与被保人关系 -->
						<RelaToInsured>
							<xsl:value-of select="RelaToInsured"/>
						</RelaToInsured>
						<!-- 受益人受益顺序 -->
						<Sequence>
							<xsl:value-of select="Grade" />
						</Sequence>
						<!-- 受益人受益比例 -->
						<Prop>
							<xsl:value-of select="Lot" />
						</Prop>
						</Bnfs>
				</xsl:for-each>
				<!-- 附加记录个数 (盛2没有附加险， 直接为0)-->
				<PrntCount>0</PrntCount>
			</Ret>
		</App>
	</xsl:template>
	
	<!-- 投保人 -->
	<xsl:template match="Appnt">
		<Appl>
			<!-- 投保人证件类型 -->
			<IDKind>
				<xsl:apply-templates select="IDType" />
			</IDKind>
			<!-- 投保人证件号码 -->
			<IDCode>
				<xsl:value-of select="IDNo" />
			</IDCode>
			<!-- 投保人名称 -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- 投保人性别 -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- 投保人出生日期 -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<!-- 投保人通讯地址 -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- 投保人邮政编码 -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- 投保人电子邮箱 -->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
			<!-- 投保人固定电话 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- 投保人移动电话 -->
			<Mobile>
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- 投保人年收入 -->
			<AnnualIncome>
				<xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Salary)"/>
			</AnnualIncome>
			<!-- 投保人与被保险人关系 -->
			<xsl:choose>
				<xsl:when test="Sex='0'">
					<RelaToInsured>
						<xsl:apply-templates select="RelaToInsured" mode="sale" />
					</RelaToInsured>
				</xsl:when>
				<xsl:otherwise>
					<RelaToInsured>
						<xsl:apply-templates select="RelaToInsured" mode="tain" />
					</RelaToInsured>
				</xsl:otherwise>
			</xsl:choose>
		</Appl>
	</xsl:template>
	<!-- 被保人 -->
	<xsl:template match="Insured">
		<Insu>
			<!-- 被保人姓名 -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- 被保人性别 -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- 被保人证件类型 -->
			<IDKind>
				<xsl:apply-templates select="IDType" />
			</IDKind>
			<!-- 被保人证件号码 -->
			<IDCode>
				<xsl:value-of select="IDNo" />
			</IDCode>
			<!-- 被保人出生日期 -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
		</Insu>
	</xsl:template>
	<!-- 关系 -->
	<xsl:template match="RelaToInsured" mode="sale">
		<xsl:choose>
				<xsl:when test=".='00'">01</xsl:when><!-- 本人 -->
				<xsl:when test=".='02'">02</xsl:when><!-- 丈夫 -->
				<xsl:when test=".='01'">04</xsl:when><!-- 父亲 -->
				<xsl:when test=".='03'">06</xsl:when><!-- 儿子 -->
				<xsl:otherwise>30</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	<!-- 关系 -->
	<xsl:template match="RelaToInsured" mode="tain">
		<xsl:choose>
				<xsl:when test=".='00'">01</xsl:when><!-- 本人 -->
				<xsl:when test=".='02'">03</xsl:when><!-- 妻子 -->
				<xsl:when test=".='01'">05</xsl:when><!-- 母亲 -->
				<xsl:when test=".='03'">07</xsl:when><!-- 女儿 -->
				
				<xsl:otherwise>30</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 保单状态 核心轉給銀行-->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">00</xsl:when><!-- 保单有效  -->
			<xsl:when test=".='01'">04</xsl:when><!-- 满期终止 -->
			<xsl:when test=".='02'">01</xsl:when><!-- 退保终止-->
			<xsl:when test=".='04'">07</xsl:when><!-- 理赔终止-->
			<xsl:when test=".='WT'">03</xsl:when><!-- 犹豫期内退保终止-->
			<xsl:when test=".='B'">08</xsl:when><!-- 待签单-->
			<xsl:when test=".='C'">02</xsl:when><!-- 当日撤单-->
			<xsl:otherwise>05</xsl:otherwise><!-- 对于银行是状态不明确 -->
		</xsl:choose>
	</xsl:template>
	<!-- 证件类型 -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">110001</xsl:when><!--居民身份证                -->
			<xsl:when test=".='5'">110005</xsl:when><!--户口簿                    -->		
			<xsl:when test=".='1'">110023</xsl:when><!--中华人民共和国护照        -->
			<xsl:when test=".='2'">110027</xsl:when><!--军官证                    -->
            <xsl:otherwise>119999</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 缴费方式（频次） -->
	<xsl:template match="PayIntv" mode="PayType">
		<xsl:choose>
		    <xsl:when test=".='-1'">0</xsl:when><!--  不定期 -->
			<xsl:when test=".='0'">1</xsl:when><!-- 趸交 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 月交 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季交 -->
			<xsl:when test=".='6'">4</xsl:when><!-- 半年交 -->
			<xsl:when test=".='12'">5</xsl:when><!-- 年交 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 保单状态 -->
	<xsl:template match="MortStatu">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when><!-- 未质押 -->
			<xsl:when test=".=1">1</xsl:when><!-- 质押 -->
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template  match="RiskCode"  mode="risk">
		<xsl:choose>
			<!-- 上线后会存储在险种代码并存情况。 -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			<!-- guning -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
			<!-- guning -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型）） -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更end -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 套餐代码 -->
	<xsl:template  match="ContPlanCode" mode="contplan">
		<xsl:choose>
			<!-- 50001-安邦长寿稳赢1号两全保险组合:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险 -->
			<xsl:when test=".='50001'">122046</xsl:when>
			<!-- 50002(50015): 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048(L12081)-安邦长寿添利终身寿险（万能型）组成 -->
			<xsl:when test=".='50015'">50002</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

</xsl:stylesheet>
