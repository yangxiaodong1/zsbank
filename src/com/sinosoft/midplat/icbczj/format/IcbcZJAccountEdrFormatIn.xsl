<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
<xsl:template match="/">

	<xsl:apply-templates select="package/req" />

</xsl:template>


<xsl:template match="package/req">
 <TranData>
 	<Head>
		<TranDate><xsl:value-of select="transexedate"/></TranDate>
		<TranTime><xsl:value-of select="transexetime"/></TranTime>
		<TellerNo><xsl:value-of select="teller"/></TellerNo>
		<TranNo><xsl:value-of select="transrefguid"/></TranNo>
		<NodeNo>
			<xsl:value-of select="regioncode"/>
			<xsl:value-of select="branch"/>
		</NodeNo>
		<xsl:copy-of select="../Head/*"/>
		<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	</Head>
	
	<Body>
		<!-- 保单信息公共节点 -->
		<PubContInfo>
			<!-- 银行交易渠道(0-传统银保通、1-网银、8-自助终端、17-手机)，银行暂时未提供-->
			<SourceType><xsl:apply-templates select="../pub/txchan" /></SourceType>
			<!-- 重送标志:0否，1是--><!--必填项-->
			<RepeatType></RepeatType>
			<!-- 保险单号码 --><!--必填项 -->
			<ContNo><xsl:value-of select="polnumber" /></ContNo>
			<!-- 保单印刷号码 -->
			<PrtNo></PrtNo>
			<!-- 保单密码 -->
			<ContNoPSW></ContNoPSW>
			<!-- 保险产品代码 （主险）-->
			<RiskCode><xsl:apply-templates select="productcode" /></RiskCode>
			<!-- 投保人证件类型 -->
			<AppntIDType><xsl:apply-templates select="govtidtc" /></AppntIDType>
			<!-- 投保人证件号码 -->
			<AppntIDNo><xsl:value-of select="govtid" /></AppntIDNo>
			 <!-- 投保人姓名 -->
			<AppntName><xsl:value-of select="fullname" /></AppntName>
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
			<!-- 业务类型: CT=退保，WT=犹退，CA=修改客户信息，MQ=满期，XQ=续期 -->
			<EdorType>CA</EdorType>
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
			<EdorAppName><xsl:value-of select="fullname" /></EdorAppName>
			<Certify>
				<!-- 单证类型( 1-保全申请书 9-其它) -->	<!-- 确认交易时为必填项 -->
				<CertifyType>1</CertifyType>                        	
				<!-- 单证名称(保全申请书号码) -->	    	<!-- 确认交易时为必填项 -->
				<CertifyName></CertifyName>           	
				<!-- 单证印刷号(1-保全申请书号码)-->		<!-- 确认交易时为必填项 -->
				<CertifyCode></CertifyCode>
			</Certify>
		</PubEdorInfo>
		
		<EdorCAInfo> 
			<!-- 此处需要注意，核心的处理方式为：传‘’表示清空，传null表示银行不做变更 -->
			<!--  投保人地址 -->
			<AppntPostalAddress>NULL</AppntPostalAddress>
			<!-- 投保人邮编 -->     
			<AppntZipCode>NULL</AppntZipCode>
			<!-- 投保人电话（座机） -->   
			<AppntPhone>NULL</AppntPhone>
			<!-- 投保人移动电话 -->
			<xsl:choose>
				<xsl:when test="dialnumber=''">
					<AppntMobile>NULL</AppntMobile>
				</xsl:when>
				<xsl:otherwise>
					<AppntMobile><xsl:value-of select="dialnumber" /></AppntMobile>
				</xsl:otherwise>
			</xsl:choose>
			<!-- 账户 -->
			<xsl:choose>
				<xsl:when test="accountnumber=''">
					<AccNo>NULL</AccNo>
				</xsl:when>
				<xsl:otherwise>
					<AccNo><xsl:value-of select="accountnumber" /></AccNo>
				</xsl:otherwise>
			</xsl:choose>
			<!--联行行号  -->
			<!-- <xsl:choose>
				<xsl:when test="uniquebankno=''">
					<BankCode>NULL</BankCode>
				</xsl:when>
				<xsl:otherwise>
					<BankCode><xsl:value-of select="uniquebankno" /></BankCode>
				</xsl:otherwise>
			</xsl:choose>    -->
			<BankCode>NULL</BankCode>
		</EdorCAInfo> 
	</Body>
</TranData>
</xsl:template>
<!-- 险种代码-->
	<xsl:template match="productcode">
		<xsl:choose>
			<xsl:when test=".='008'">L12077</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型）  -->
			<!-- PBKINSR-1327 浙江工行日日升C款（盛世9号）项目 2016-06-18  -->
		    <xsl:when test=".='014'">L12102</xsl:when>	<!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型-->
	<xsl:template match="govtidtc">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when>	<!-- 身份证 -->
			<xsl:when test=".=1">1</xsl:when>	<!-- 护照 -->
			<xsl:when test=".=2">2</xsl:when>	<!-- 军官证 -->
			<xsl:when test=".=3">2</xsl:when>	<!-- 士兵证 -->
			<xsl:when test=".=5">0</xsl:when>	<!-- 临时身份证 -->
			<xsl:when test=".=6">5</xsl:when>	<!-- 户口本  -->
			<xsl:when test=".=9">2</xsl:when>	<!-- 警官证  -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 渠道代码:交易渠道(0-传统银保通、1-网银、8-自助终端、17-手机)-->	
	<xsl:template match="txchan">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when>	<!-- 银保通 -->
			<xsl:when test=".=1">1</xsl:when>	<!-- 网银 -->
			<xsl:when test=".=8">8</xsl:when>	<!-- 自助终端 -->
			<!-- 浙江工行手机渠道采用的是网银渠道出单，此处不需要增加手机渠道 -->
			<!-- <xsl:when test=".=5">17</xsl:when> -->	<!-- 手机银行 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
