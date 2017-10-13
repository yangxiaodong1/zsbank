<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/Transaction">
		<TranData>
			<xsl:apply-templates select="TransHeader" />
			<Body>
				<xsl:apply-templates select="TransBody/Request" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="TransHeader">
		<Head>
			<TranDate><xsl:value-of select="TransDate"/></TranDate>
		    <TranTime><xsl:value-of select="TransTime"/></TranTime>
		    <TellerNo><xsl:value-of select="../TransBody/Request/UserNo"/></TellerNo>
		    <TranNo><xsl:value-of select="XDSerialNo"/></TranNo>
		    <!-- <NodeNo><xsl:value-of select="../TransBody/Request/OrgNo"/></NodeNo> -->
		    <NodeNo>02100000</NodeNo>
		    <xsl:copy-of select="../Head/*"/>
		    <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
	<!--  保单信息 -->
	<xsl:template name="Request" match="Request">
		<PubContInfo>
			<!-- 银行交易渠道(0-传统银保通、1-网银、8-自助终端、17-手机、z-直销银行)，银行暂时未提供-->
			<SourceType>z</SourceType>
			<!-- 重送标志:0否，1是--><!--必填项-->
			<RepeatType></RepeatType>
			<!-- 保险单号码 --><!--必填项 -->
			<ContNo>
				<xsl:value-of select="InsurNo" />
			</ContNo>
			<!-- 保单印刷号码 -->
			<PrtNo></PrtNo>
			<!-- 可质押金额 -->
			<PledgeAmt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amount)" />
			</PledgeAmt>
			<!-- 贷款额度 -->
			<GrossAmt></GrossAmt>

			<!-- 借款比例 -->
			<BorrowRate></BorrowRate>

			<ContNoPSW></ContNoPSW>
			<!-- 投保人姓名 -->
			<AppntName>
				<xsl:value-of select="CustName" />
			</AppntName>
			<!-- 投保人证件号码 -->
			<AppntIDNo>
				<xsl:value-of select="CertID" />
			</AppntIDNo>
			<!-- 投保人证件类型 -->
			<AppntIDType>
				<xsl:apply-templates select="CertIDType" />
			</AppntIDType>
			<Sex></Sex>
			<Birthday></Birthday>
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
			<!-- 收付费方式(09-无卡支付) 默认为7=银行转账(制返盘)--><!-- 确认交易时为必填项 -->
			<PayMode>7</PayMode>
			<!-- 收付费银行编号--><!-- 确认交易时为必填项 -->
			<PayGetBankCode></PayGetBankCode>
			<!-- 收付费银行名称  省 市 银行--><!-- 确认交易时为必填项 -->
			<BankName></BankName>
			<!-- 补退费帐户帐号--><!-- 确认交易时为必填项 -->
			<BankAccNo></BankAccNo>
			<!-- 补退费帐户户名--><!-- 确认交易时为必填项 -->
			<BankAccName></BankAccName>
			<!--领款人证件类型 -->
			<BankAccIDType></BankAccIDType>
			<!--领款人证件号 -->
			<BankAccIDNo></BankAccIDNo>
			<!-- 业务类型: CT=退保，WT=犹退，CA=修改客户信息，MQ=满期，XQ=续期 BL-保单质押，BD-保单质押解除 -->
			<EdorType>BL</EdorType>
			<!-- 查询=1;确认=2 -->
			<EdorFlag>2</EdorFlag>
		</PubContInfo>

    <!-- 保全信息公共节点 -->
		<PubEdorInfo>
			<!-- 申请退保日期[yyyy-MM-dd] -->
			<EdorAppDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
			</EdorAppDate>
			<!--如果传值为1则，则核心不校验保全申请书号为必填项 -->
			<NonAppNoFlag>1</NonAppNoFlag>
			<!-- 申请人姓名-->
			<EdorAppName><xsl:value-of select="CustName" /></EdorAppName>
			<Certify>
				<!-- 单证类型( 1-保全申请书 9-其它) --><!-- 确认交易时为必填项 -->
				<CertifyType></CertifyType>
				<!-- 单证名称(保全申请书号码) --><!-- 确认交易时为必填项 -->
				<CertifyName></CertifyName>
				<!-- 单证印刷号(1-保全申请书号码)--><!-- 确认交易时为必填项 -->
				<CertifyCode></CertifyCode>
			</Certify>
		</PubEdorInfo>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template name="CertIDType" match="CertIDType">
		<xsl:choose>
			<xsl:when test=".='01'">0</xsl:when><!-- 身份证 -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>





