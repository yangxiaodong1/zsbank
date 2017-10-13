<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<!-- 汇总行信息 -->
				<Detail>
					<count>
						<xsl:value-of select="count(//Detail[ContState='3'])" />
					</count>
					<ActSumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail[ContState='3']/ActPrem))" />
					</ActSumPrem>
					<remark />
				</Detail>

				<!-- 明细信息 -->
				<xsl:for-each select="//Detail[ContState='3']">
					<xsl:variable name="mainRisk" select="Risk[RiskCode=MainRiskCode]" />
					<Detail>
						<!-- 原申请日期(yyyyMMdd)-->
						<PolApplyDate>
							<xsl:value-of select="ApplyDate" />
						</PolApplyDate>
						<!-- 银行方请求流水号 -->
						<TranNo>
							<xsl:value-of select="TranNo" />
						</TranNo>
						<AppntName>
							<xsl:value-of select="Appnt/Name" />
						</AppntName>
						<!-- 投保人证件类型-->
						<AppntIDType>
							<xsl:call-template name="IDKind">
								<xsl:with-param name="value" select="Appnt/IDType" />
							</xsl:call-template>
						</AppntIDType>
						<!-- 投保人证件号-->
						<AppntIDNo>
							<xsl:value-of select="Appnt/IDNo" />
						</AppntIDNo>
						<RiskCode>
							<xsl:if test="ContPlanCode!=''">
								<xsl:apply-templates select="ContPlanCode" />
							</xsl:if>
							<xsl:if test="ContPlanCode=''">
								<xsl:apply-templates select="$mainRisk/RiskCode" />
							</xsl:if>
						</RiskCode>
						<ProdCode></ProdCode>
						<!--保单号-->
						<ContNo>
							<xsl:value-of select="ContNo" />
						</ContNo>
						<!-- 承保日期(yyyyMMdd) -->
						<SignDate>
							<xsl:value-of select="$mainRisk/SignDate" />
						</SignDate>
						<!-- 与被保人关系 -->
						<RelaToInsured>
							<xsl:call-template name="tran_relation">
								<xsl:with-param name="relation" select="//Appnt/RelaToInsured" />
								<xsl:with-param name="sex" select="//Appnt/sex" />
							</xsl:call-template>
						</RelaToInsured>
						<!-- 被保人姓名 -->
						<InsuredName>
							<xsl:value-of select="Insured/Name" />
						</InsuredName>
						<!-- 被保人证件类型-->
						<InsuredIDType>
							<xsl:call-template name="IDKind">
								<xsl:with-param name="value" select="Insured/IDType" />
							</xsl:call-template>
						</InsuredIDType>
						<!-- 被保人证件号-->
						<InsuredIDNo>
							<xsl:value-of select="Insured/IDNo" />
						</InsuredIDNo>
						<!--首期总保费-->
						<Prem>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
						</Prem>
						<!--总保额，等于个risk下的amnt之和-->
						<Amnt>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
						</Amnt>
						<!-- 缴费账户 -->
						<AccNo>
							<xsl:value-of select="AccNo" />
						</AccNo>
						<!-- 缴费方式 -->
						<PayIntv>
							<xsl:apply-templates select="$mainRisk/PayIntv" />
						</PayIntv>
						<!-- 缴费期限 -->
						<PayEndYear></PayEndYear>
						<!-- 保险责任终止日期-->
						<InsuEndDate>
							<xsl:value-of select="$mainRisk/InsuEndDate" />
						</InsuEndDate>
						<!--份数-->
						<Mult>
							<xsl:value-of select="$mainRisk/Mult" />
						</Mult>
						<!-- 个性化费率 -->
						<Rate></Rate>
						<!-- 保单印刷号 -->
						<ContPrtNo></ContPrtNo>
						<remark></remark>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template name="IDKind">
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$value='0'">110001</xsl:when><!--居民身份证                -->
			<xsl:when test="$value='5'">110005</xsl:when><!--户口簿                    -->
			<xsl:when test="$value='1'">110023</xsl:when><!--中华人民共和国护照        -->
			<xsl:when test="$value='2'">110027</xsl:when><!--军官证                    -->
			<xsl:otherwise>119999</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>

	<!-- 与被保人关系 -->
	<xsl:template name="tran_relation">
		<xsl:param name="relation" />
		<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$relation=00">01</xsl:when><!-- 本人 -->
			<xsl:when test="$relation=01"><!-- 父母 -->
				<xsl:choose>
					<xsl:when test="$sex=0">04</xsl:when>
					<xsl:otherwise>05</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=02"><!-- 配偶 -->
				<xsl:choose>
					<xsl:when test="$sex=0">02</xsl:when>
					<xsl:otherwise>03</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=03"><!-- 儿女 -->
				<xsl:choose>
					<xsl:when test="$sex=0">06</xsl:when>
					<xsl:otherwise>07</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=04">30</xsl:when><!-- 其他 -->
			<xsl:otherwise>30</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费频次 -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='-1'">0</xsl:when><!--  不定期 -->
			<xsl:when test=".='0'">1</xsl:when><!--  趸交 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 月交 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季交 -->
			<xsl:when test=".='6'">4</xsl:when><!-- 半年交 -->
			<xsl:when test=".='12'">5</xsl:when><!-- 年交 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template match="RiskCode | ContPlanCode">
		<xsl:choose>
			<xsl:when test=".='50001'">122046</xsl:when><!-- 长寿稳赢1号套餐 -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- 长寿稳赢保险计划套餐 -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更end -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号两全保险（万能型）B款  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号两全保险（万能型）  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型）  -->
			
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款  -->
			<xsl:when test=".='122006'">122006</xsl:when><!-- 安邦聚宝盆2号两全保险（分红型）A款  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- 安邦白玉樽1号终身寿险(万能型)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- 安邦黄金鼎2号两全保险(分红型)A款  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- 安邦黄金鼎3号两全保险(分红型)A款  -->
			
			<!-- 上线后，会存在险种代码并存的情况。 -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- 长寿稳赢保险计划套餐 -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			
			<!-- 安邦长寿安享5号保险计划50012,安邦长寿安享5号年金保险L12070,安邦附加长寿添利5号两全保险（万能型）L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>