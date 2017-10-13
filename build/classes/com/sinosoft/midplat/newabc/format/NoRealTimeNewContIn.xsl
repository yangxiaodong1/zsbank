<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="ABCB2I">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="Header" />

			<!-- 报文体 -->
			<xsl:apply-templates select="App/Req" />

		</TranData>
	</xsl:template>

	<!--报文头信息-->
	<xsl:template match="Header">
		<!--基本信息-->
		<Head>
			<!-- 银行交易日期 -->
			<TranDate>
				<xsl:value-of select="TransDate" />
			</TranDate>
			<!-- 交易时间 农行不传交易时间 取系统当前时间 -->
			<TranTime>
				<xsl:value-of select="TransTime" />
			</TranTime>
			<!-- 柜员代码 -->
			<TellerNo>
				<xsl:value-of select="Tlid" />
			</TellerNo>
			<!-- 银行交易流水号 -->
			<TranNo>
				<xsl:value-of select="SerialNo" />
			</TranNo>
			<!-- 地区码+网点码 -->
			<NodeNo>
				<xsl:value-of select="ProvCode" />
				<xsl:value-of select="BranchNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<!-- YBT组织的节点信息 -->
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

	<!--报文体信息-->
	<xsl:template match="App/Req">
		<Body>
			<ProposalPrtNo>
				<xsl:value-of select="PolicyApplyNo" />
			</ProposalPrtNo><!-- 投保单(印刷)号 -->
			<PolApplyDate>
				<xsl:value-of select="../../Header/TransDate" />
			</PolApplyDate><!-- 投保日期 -->
			<AgentComName>
				<xsl:value-of select="Base/BranchName" />
			</AgentComName><!--出单网点名称-->
			<AgentComCertiCode>
				<xsl:value-of select="Base/BranchCertNo" />
			</AgentComCertiCode><!--出单网点资格证-->
			<TellerName>
				<xsl:value-of select="Base/Saler" />
			</TellerName><!--银行销售人员名称-->
			<TellerCertiCode>
				<xsl:value-of select="Base/SalerCertNo" />
			</TellerCertiCode><!--银行销售人员资格证-->
			<AccName></AccName><!-- 账户姓名 -->
			<AccNo>
				<xsl:value-of select="AccNo" />
			</AccNo><!-- 银行账户 -->
			<!-- 产品组合 -->
			<ContPlan>
				<!-- 产品组合编码 -->
				<ContPlanCode>
					<xsl:apply-templates select="RiskCode" mode="contplan" />
				</ContPlanCode>
			</ContPlan>
			<!-- 投保人 -->
			<xsl:apply-templates select="Appl" />
			<!-- 险种 -->
			<Risk>
				<!-- 险种号 -->
				<RiskCode>
					<xsl:apply-templates select="RiskCode" mode="risk" />
				</RiskCode>
				<!-- 主险号 -->
				<MainRiskCode>
					<xsl:apply-templates select="RiskCode" mode="risk" />
				</MainRiskCode>
				<!-- 保费（农行 元） -->
				<Prem>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)" />
				</Prem>
				<Amnt></Amnt>
				<Mult></Mult><!-- 投保份数 -->
				<PayIntv></PayIntv><!-- 缴费频次 -->
				<InsuYearFlag></InsuYearFlag><!-- 保险年期年龄标志 -->
				<InsuYear></InsuYear><!-- 保险年期年龄 保终身写死106-->
				<PayEndYearFlag></PayEndYearFlag><!-- 缴费年期年龄标志 -->
				<PayEndYear></PayEndYear><!-- 缴费年期年龄 趸交写死1000-->
			</Risk>
		</Body>
	</xsl:template>

	<!--投保人信息-->
	<xsl:template match="Appl">
		<Appnt>
			<!-- 姓名 -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- 性别 -->
			<Sex></Sex>
			<!-- 出生日期(yyyyMMdd) -->
			<Birthday></Birthday>
			<!-- 证件类型 -->
			<IDType>
				<xsl:apply-templates select="IDKind" />
			</IDType>
			<!-- 证件号码 -->
			<IDNo>
				<xsl:value-of select="IDCode" />
			</IDNo>
			<!-- 投保人所属区域-->
			<LiveZone>
				<xsl:apply-templates select="CustSource" />
			</LiveZone>
			<!-- 地址 -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- 邮编 -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- 移动电话 -->
			<Mobile>
				<xsl:value-of select="CellPhone" />
			</Mobile>
			<!-- 固定电话 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
		</Appnt>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template match="IDKind">
		<xsl:choose>
			<xsl:when test=".='110001'">0</xsl:when><!--居民身份证                -->
			<xsl:when test=".='110002'">0</xsl:when><!--重号居民身份证            -->
			<xsl:when test=".='110003'">0</xsl:when><!--临时居民身份证            -->
			<xsl:when test=".='110004'">0</xsl:when><!--重号临时居民身份证        -->
			<xsl:when test=".='110005'">5</xsl:when><!--户口簿                    -->
			<xsl:when test=".='110006'">5</xsl:when><!--重号户口簿                -->
			<xsl:when test=".='110023'">1</xsl:when><!--中华人民共和国护照        -->
			<xsl:when test=".='110024'">1</xsl:when><!--重号中华人民共和国护照    -->
			<xsl:when test=".='110025'">1</xsl:when><!--外国护照                  -->
			<xsl:when test=".='110026'">1</xsl:when><!--重号外国护照              -->
			<xsl:when test=".='110027'">2</xsl:when><!--军官证                    -->
			<xsl:when test=".='110028'">2</xsl:when><!--重号军官证                -->
			<xsl:when test=".='110029'">2</xsl:when><!--文职干部证                -->
			<xsl:when test=".='110030'">2</xsl:when><!--重号文职干部证            -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--客户来源 -->
	<xsl:template match="CustSource">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 城镇 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 农村 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 险种代码 -->
	<xsl:template match="RiskCode" mode="risk">
		<xsl:choose>
			<xsl:when test=".='122046'">50001</xsl:when><!-- 长寿稳赢1号套餐 -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- 长寿稳赢保险套餐计划 -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<!-- <xsl:when test=".='122010'">122010</xsl:when> --> <!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号两全保险（万能型）B款  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号两全保险（万能型）  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型）  -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- 长寿稳赢保险套餐计划 -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更start -->
			<!-- <xsl:when test=".='L12078'">L12078</xsl:when> --><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='L12078'">L12100</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更end -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款  -->

			<xsl:when test=".='122006'">122006</xsl:when><!-- 安邦聚宝盆2号两全保险（分红型）A款  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- 安邦白玉樽1号终身寿险(万能型)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- 安邦黄金鼎2号两全保险(分红型)A款  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- 安邦黄金鼎3号两全保险(分红型)A款  -->
			
			<xsl:when test=".='50012'">50012</xsl:when><!-- 安邦长寿安享5号保险计划50012 -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型）  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 套餐代码 -->
	<xsl:template match="RiskCode" mode="contplan">
		<xsl:choose>
			<xsl:when test=".='122046'">50001</xsl:when><!-- 长寿 套餐 -->
			<!-- 万能险改造，险种改代码调整涉及盛世、稳赢系列，银行不变保险公司核心险种代码变化 -->
			<xsl:when test=".='50002'">50015</xsl:when><!-- 长寿稳赢保险套餐计划 -->
			
			<!-- 安邦长寿安享5号保险计划50012,安邦长寿安享5号年金保险L12070,安邦附加长寿添利5号两全保险（万能型）L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>