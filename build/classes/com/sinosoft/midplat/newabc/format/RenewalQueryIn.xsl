<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="ABCB2I">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="Header" />
			<Body>
				<!-- 报文体 -->
				<xsl:apply-templates select="App/Req" />
			</Body>
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

		<PubEdorInfo>
			<!-- 申请退保日期[yyyy-MM-dd]--><!--必填项-->
			<EdorAppDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
			</EdorAppDate>
			<!-- 申请人姓名--><!--必填项-->
			<EdorAppName></EdorAppName>
			<Certify>
				<!-- 单证类型( 1-保全申请书 9-其它) --><!--确认交易时为必填项-->
				<CertifyType></CertifyType>
				<!-- 单证名称(保全申请书号码) --><!--确认交易时为必填项-->
				<CertifyName></CertifyName>
				<!-- 单证印刷号(1-保全申请书号码)--><!--确认交易时为必填项-->
				<CertifyCode>000000</CertifyCode>
			</Certify>
		</PubEdorInfo>

		<EdorXQInfo>
			<!-- 金额 -->
			<GrossAmt></GrossAmt>
			<!-- 应收日期[yyyyMMdd] -->
			<FinEffDate></FinEffDate>
		</EdorXQInfo>

		<PubContInfo>
			<!-- 银行交易渠道(柜台/网银)-->
			<SourceType></SourceType>
			<!-- 重送标志:0否，1是--><!--必填项-->
			<RepeatType></RepeatType>
			<!-- 保险单号码 --><!--必填项 -->
			<ContNo>
				<xsl:value-of select="PolicyNo" />
			</ContNo>
			<!-- 投保单印刷号码 -->
			<PrtNo></PrtNo>
			<!-- 保单密码 -->
			<ContNoPSW></ContNoPSW>
			<!-- 保险产品代码 （主险）-->
			<RiskCode></RiskCode>
			<!-- 投保人证件类型 -->
			<AppntIDType></AppntIDType>
			<!-- 投保人证件号码 -->
			<AppntIDNo></AppntIDNo>
			<!-- 投保人姓名 -->
			<AppntName></AppntName>
			<!-- 投保人证件有效截止日期 -->
			<AppntIdTypeEndDate></AppntIdTypeEndDate>
			<!-- 投保人住宅电话 (投保人联系电话) -->
			<AppntPhone></AppntPhone>
			<!-- 被保人证件类型 -->
			<InsuredIDType></InsuredIDType>
			<!-- 被保人证件号码 -->
			<InsuredIDNo></InsuredIDNo>
			<!-- 被保人姓名 -->
			<InsuredName></InsuredName>
			<!-- 被保人证件有效截止日期 -->
			<InsuredIdTypeEndDate></InsuredIdTypeEndDate>
			<!-- 被保人住宅电话 (投保人联系电话) -->
			<InsuredPhone></InsuredPhone>
			<!-- 投保人关系代码 -->
			<RelationRoleCode1></RelationRoleCode1>
			<!-- 投保人关系 -->
			<RelationRoleName1></RelationRoleName1>
			<!-- 被保人关系代码 -->
			<RelationRoleCode2></RelationRoleCode2>
			<!-- 被保人关系 -->
			<RelationRoleName2></RelationRoleName2>
			<!-- 收付费方式(09-无卡支付) 默认为7，银行代扣--><!--确认交易时为必填项-->
			<PayMode>7</PayMode>
			<!-- 收付费银行编号--><!--确认交易时为必填项-->
			<PayGetBankCode></PayGetBankCode>
			<!-- 收付费银行名称  省 市 银行--><!--确认交易时为必填项-->
			<BankName></BankName>
			<!-- 补退费帐户帐号--><!--确认交易时为必填项-->
			<BankAccNo></BankAccNo>
			<!-- 补退费帐户户名--><!--确认交易时为必填项-->
			<BankAccName></BankAccName>
		</PubContInfo>
	</xsl:template>
</xsl:stylesheet>