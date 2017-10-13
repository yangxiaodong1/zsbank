<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
<xsl:template match="/">

  <TranData>
	 <xsl:apply-templates select="TranData/Head" />
	 <xsl:apply-templates select="TranData/Body" /> 												
  </TranData>

</xsl:template>

	<!-- 报文头 -->
	<xsl:template name="Head" match="Head">
		<Head>
			<!-- 交易日期（yyyymmdd） -->
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<!-- 交易时间 （hhmmss）-->
			<TranTime>
				<xsl:value-of select="TRANSRTIME" />
			</TranTime>
			<!-- 柜员-->
			<TellerNo>sys</TellerNo>
			<!-- 流水号-->
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<!-- 地区码+网点码-->
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<!-- 银行编号（核心定义）-->
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<SourceType>1</SourceType><!-- 0=银保通柜面、1=网银、8=自助终端 -->
			<xsl:copy-of select="../Head/*" />
		</Head>
</xsl:template>	


<xsl:template name="Body" match="Body" >
	<Body>
		<!-- 保单信息公共节点 -->
		<PubContInfo>
			<!-- 银行交易渠道(0-传统银保通、1-网银、8-自助终端、17-手机)，银行暂时未提供-->
			<SourceType>1</SourceType>
			<!-- 重送标志:0否，1是--><!--必填项-->
			<RepeatType></RepeatType>
			<!-- 保险单号码 --><!--必填项 -->
			<ContNo><xsl:value-of select="ContNo" /></ContNo>
			<!-- 保单印刷号码 -->
			<PrtNo></PrtNo>
			<!-- 保单密码 -->
			<ContNoPSW></ContNoPSW>
			<!-- 保险产品代码 （主险）-->
			<RiskCode><xsl:apply-templates select="RiskCode" /></RiskCode>
			<!-- 投保人证件类型 -->
			<AppntIDType><xsl:apply-templates select="AppntIDType" /></AppntIDType>
			<!-- 投保人证件号码 -->
			<AppntIDNo><xsl:value-of select="AppntIDNo" /></AppntIDNo>
			 <!-- 投保人姓名 -->
			<AppntName><xsl:value-of select="AppntName" /></AppntName>
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
			<!-- 收付费方式(09-无卡支付) 默认为7=银行转账(制返盘) --><!-- 确认交易时为必填项 -->
			<PayMode>7</PayMode>
			<!-- 收付费银行编号--><!-- 确认交易时为必填项 -->
			<PayGetBankCode></PayGetBankCode>
			<!-- 收付费银行名称  省 市 银行--><!-- 确认交易时为必填项 -->
			<BankName></BankName>
			<!-- 补退费帐户帐号--><!-- 确认交易时为必填项 -->
			<BankAccNo><xsl:value-of select="BankAccNo" /></BankAccNo>
			<!-- 补退费帐户户名--><!-- 确认交易时为必填项 -->
			<BankAccName><xsl:value-of select="BankAccName" /></BankAccName>
			<!--领款人证件类型 -->
			<BankAccIDType></BankAccIDType>
			<!--领款人证件号 -->
			<BankAccIDNo></BankAccIDNo>
			<!-- 业务类型: CT=退保，WT=犹退，CA=修改客户信息，MQ=满期，XQ=续期, PJ=提款 -->
			<EdorType>PJ</EdorType>
			<!-- 查询=1;确认=2 -->
			<EdorFlag>2</EdorFlag>
		</PubContInfo>
		
		<!-- 保全信息公共节点 -->
		<PubEdorInfo>
			<!-- 申请退保日期[yyyy-MM-dd] -->
			<EdorAppDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
			</EdorAppDate>
			<!-- 申请人姓名-->
			<EdorAppName><xsl:value-of select="AppntName" /></EdorAppName>
			<Certify>
				<!-- 单证类型( 1-保全申请书 9-其它) -->	<!-- 确认交易时为必填项 -->
				<CertifyType>1</CertifyType>                        	
				<!-- 单证名称(保全申请书号码) -->	    	<!-- 确认交易时为必填项 -->
				<CertifyName></CertifyName>           	
				<!-- 单证印刷号(1-保全申请书号码)-->		<!-- 确认交易时为必填项 -->
				<CertifyCode></CertifyCode>
			</Certify>
		</PubEdorInfo>
		
		<!-- 体现保全项 -->
		<EdorPJInfo>
			<!-- 提款金额,核心金额的单位是分，银行的金额单位是元 -->
			<LoanMoney><xsl:value-of select="LoanMoney" /></LoanMoney>
		</EdorPJInfo>
	</Body>
</xsl:template>


<!-- 险种代码-->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='L12079'">L12098</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型），该产品代码只针对辽宁广发的盛2  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型-->
	<xsl:template match="AppntIDType">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when>	<!-- 身份证 -->
			<xsl:when test=".=1">1</xsl:when>	<!-- 护照 -->
			<xsl:when test=".=2">2</xsl:when>	<!-- 军官证 -->
			<xsl:when test=".=3">3</xsl:when>	<!-- 驾照 -->
			<xsl:when test=".=4">4</xsl:when>	<!-- 出生证明 -->
			<xsl:when test=".=5">5</xsl:when>	<!-- 户口簿  -->
			<xsl:when test=".=9">9</xsl:when>	<!-- 异常身份证  -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
