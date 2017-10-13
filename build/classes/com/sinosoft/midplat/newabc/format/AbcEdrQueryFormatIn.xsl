<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">


	<xsl:template match="ABCB2I">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="Header" />

			<!-- 报文体 -->
			<xsl:apply-templates select="App/Req" />
		</TranData>
	</xsl:template>


	<!-- Head Info -->
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
				<xsl:value-of select="ProvCode" /><xsl:value-of select="BranchNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<!-- YBT组织的节点信息 -->
			<xsl:copy-of select="../Head/*" />
			</Head>
	</xsl:template>
	
	<!-- Body Info -->
	<xsl:template match="App/Req">
		<Body>
		
			<!-- 保单信息公共节点 -->
			<PubContInfo>
				<!-- 银行交易渠道(0-传统银保通、1-网银、8-自助终端)-->
				<SourceType></SourceType>
				<!-- 重送标志:0否，1是--><!--必填项-->
				<RepeatType></RepeatType>
				<!-- 保险单号码 --><!--必填项 -->
				<ContNo><xsl:value-of select="PolicyNo" /></ContNo>
				<!-- 保单印刷号码 -->
				<PrtNo><xsl:value-of select="PrintCode" /></PrtNo>
				<!-- 保单密码 -->
				<ContNoPSW><xsl:value-of select="PolicyPwd" /></ContNoPSW>
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
				<!-- 收付费方式(09-无卡支付) 默认为7=银行转账(制返盘)--><!--确认交易时为必填项-->
				<PayMode>7</PayMode>
				<!-- 收付费银行编号--><!--确认交易时为必填项-->
				<PayGetBankCode></PayGetBankCode>
				<!-- 收付费银行名称  省 市 银行--><!--确认交易时为必填项-->
				<BankName></BankName>
				<!-- 补退费帐户帐号--><!--确认交易时为必填项-->
				<BankAccNo><xsl:value-of select="PayAcc" /></BankAccNo>
				<!-- 补退费帐户户名--><!--确认交易时为必填项-->
				<BankAccName><xsl:value-of select="PayeetName" /></BankAccName>
				<!--领款人证件类型 -->
				<BankAccIDType>
					<xsl:call-template name="tran_IDKind">
						<xsl:with-param name="idKind" select="PayeeIdKind" />
					</xsl:call-template>
				</BankAccIDType>
				<!--领款人证件号 -->
				<BankAccIDNo><xsl:value-of select="PayeeIdCode" /></BankAccIDNo>
				<!-- 业务类型 -->
				<EdorType><xsl:apply-templates select="BusiType" /></EdorType>
				<!-- 查询=1;确认=2 -->
				<EdorFlag>1</EdorFlag>
			</PubContInfo>
			
			<!-- 保全信息公共节点 -->
			<PubEdorInfo>
				<!-- 申请退保日期[yyyy-MM-dd]-->
				<EdorAppDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</EdorAppDate>
				<!-- 申请人姓名-->
				<EdorAppName><xsl:value-of select="ClientName" /></EdorAppName>
				<Certify>
					<!-- 单证类型( 1-保全申请书 9-其它) -->	<!--确认交易时为必填项-->
					<CertifyType></CertifyType>                        	
					<!-- 单证名称(保全申请书号码) -->	    	<!--确认交易时为必填项-->
					<CertifyName></CertifyName>           	
					<!-- 单证印刷号(1-保全申请书号码)-->		<!--确认交易时为必填项-->
					<CertifyCode />
				</Certify>
			</PubEdorInfo>
			
			<!-- 退保特有字段 -->
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
		</Body>
	</xsl:template>
		
	
	<!-- 业务类型转换 -->
	<xsl:template name="tran_BusiType" match="BusiType">
		<xsl:choose>
			<xsl:when test=".='01'">WT</xsl:when>	<!-- 犹豫期退保 -->
			<xsl:when test=".='02'">MQ</xsl:when>	<!-- 满期给付 -->
			<xsl:when test=".='03'">CT</xsl:when>	<!-- 退保 -->
		</xsl:choose>
	</xsl:template>
	
		<!-- 证件类型 -->
	<xsl:template name="tran_IDKind">
		<xsl:param name="idKind" />
		<xsl:choose>
			<xsl:when test="$idKind='110001'">0</xsl:when><!--居民身份证                -->
			<xsl:when test="$idKind='110002'">0</xsl:when><!--重号居民身份证            -->
			<xsl:when test="$idKind='110003'">0</xsl:when><!--临时居民身份证            -->
			<xsl:when test="$idKind='110004'">0</xsl:when><!--重号临时居民身份证        -->
			<xsl:when test="$idKind='110005'">5</xsl:when><!--户口簿                    -->
			<xsl:when test="$idKind='110006'">5</xsl:when><!--重号户口簿                -->			
			<xsl:when test="$idKind='110023'">1</xsl:when><!--中华人民共和国护照        -->
			<xsl:when test="$idKind='110024'">1</xsl:when><!--重号中华人民共和国护照    -->
			<xsl:when test="$idKind='110025'">1</xsl:when><!--外国护照                  -->
			<xsl:when test="$idKind='110026'">1</xsl:when><!--重号外国护照              -->
			<xsl:when test="$idKind='110027'">2</xsl:when><!--军官证                    -->
			<xsl:when test="$idKind='110028'">2</xsl:when><!--重号军官证                -->
			<xsl:when test="$idKind='110029'">2</xsl:when><!--文职干部证                -->
			<xsl:when test="$idKind='110030'">2</xsl:when><!--重号文职干部证            -->
            <xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>


	

