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
				<!-- 保单质押标记 -->
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
				<!-- 自动转账授权账号-->
				<AutoTransferAccNo />
			</Ret>
		</App>
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
			<xsl:when test=".='122046'">122046</xsl:when><!-- 长寿稳赢1号套餐 -->
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款  -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更end -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号两全保险（万能型）B款  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号两全保险（万能型）  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型）  -->
			<xsl:when test=".='122006'">122006</xsl:when><!-- 安邦聚宝盆2号两全保险（分红型）A款  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- 安邦白玉樽1号终身寿险(万能型)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- 安邦黄金鼎2号两全保险(分红型)A款  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- 安邦黄金鼎3号两全保险(分红型)A款  -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 套餐代码 -->
	<xsl:template  match="ContPlanCode" mode="contplan">
		<xsl:choose>
			<!-- 50001-安邦长寿稳赢1号两全保险组合:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险 -->
			<xsl:when test=".='50001'">122046</xsl:when>
			<!-- 50002(50015): 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048(L12081)-安邦长寿添利终身寿险（万能型）组成 -->
			<xsl:when test=".='50015'">50015</xsl:when>
			<xsl:when test=".='50002'">50002</xsl:when>
			<!-- 安邦长寿安享5号保险计划50012,安邦长寿安享5号年金保险L12070,安邦附加长寿添利5号两全保险（万能型）L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			<!-- 上线后会存储在险种代码并存情况。 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

</xsl:stylesheet>
