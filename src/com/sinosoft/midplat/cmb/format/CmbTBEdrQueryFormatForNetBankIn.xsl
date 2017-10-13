<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- head -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<!-- PubContInfo -->
				<xsl:apply-templates
					select="TXLife/TXLifeRequest/OLife/Holding/Policy" />
				<!-- PubEdorInfo -->
				<xsl:apply-templates
					select="TXLife/TXLifeRequest/OLife" />
				<!-- EdorCTInfo -->
				<xsl:apply-templates
					select="TXLife/TXLifeRequest/OLifeExtension" />
			</Body>
		</TranData>
	</xsl:template>


	<!-- 报文头结点 -->
	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TransExeTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TellerCode" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

	<!-- 保全公共 -->
	<xsl:template name="PubEdorInfo" match="OLife">
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
				<CertifyType>
					<xsl:apply-templates select="FormName" />
				</CertifyType>
				<!-- 单证名称(保全申请书号码) --><!--确认交易时为必填项-->
				<CertifyName></CertifyName>
				<!-- 单证印刷号(1-保全申请书号码)-->
				<!--确认交易时为必填项，此处为查询交易，由于招行在退保查询时不提供保全申请书号，仅在退保确认时提供，所以此处临时用保单号替代-->
				<CertifyCode></CertifyCode>
			</Certify>
		</PubEdorInfo>
	</xsl:template>

	<!-- 退保特有字段 -->
	<xsl:template name="EdorCTInfo" match="OLifeExtension">
		<EdorCTInfo>
			<!-- 退保原因代码 -->
			<EdorReasonCode></EdorReasonCode>
			<!-- 退保原因 -->
			<EdorReason></EdorReason>
			<!-- 是否提交《中华人民共和国残疾人证》或《最低生活保障金领取证》Y是N否 -->
			<CertificateIndicator></CertificateIndicator>
			<!-- 首期保险费发票丢失 Y是N否 -->
			<LostVoucherIndicator></LostVoucherIndicator>
		</EdorCTInfo>
	</xsl:template>

	<!--  公共 -->
	<xsl:template name="PubContInfo" match="Policy">
		<PubContInfo>
			<!-- 银行交易渠道(柜台/网银),0=银保通，1=网银，8=自助终端,核心默认为0-->
			<SourceType>1</SourceType>
			<!-- 重送标志:0否，1是--><!--必填项-->
			<RepeatType></RepeatType>
			<!-- 保险单号码 --><!--必填项 -->
			<ContNo>
				<xsl:value-of select="PolNumber" />
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
			<PayMode>7</PayMode><!-- TODO 需要跟郝庆涛确认是否应该是核心默认 -->

			<!-- 收付费银行编号--><!--确认交易时为必填项-->
			<PayGetBankCode></PayGetBankCode>
			<!-- 收付费银行名称  省 市 银行--><!--确认交易时为必填项-->
			<BankName></BankName>
			<!-- 补退费帐户帐号--><!--确认交易时为必填项-->
			<BankAccNo>
				<xsl:value-of select="AccountNumber" />
			</BankAccNo>
			<!-- 补退费帐户户名--><!--确认交易时为必填项-->
			<BankAccName>
				<xsl:value-of select="AcctHolderName" />
			</BankAccName>
			<!-- 保全交易类型 -->
	        <EdorType>CT</EdorType>
	        <!-- 查询=1，确认=2标志 -->
	        <EdorFlag>1</EdorFlag>
	         <!-- 人工审批标志，人工审批=1，直接生效=0，确认时给1，查询时给0 -->
	        <ExamFlag>0</ExamFlag>
		</PubContInfo>
	</xsl:template>

</xsl:stylesheet>




