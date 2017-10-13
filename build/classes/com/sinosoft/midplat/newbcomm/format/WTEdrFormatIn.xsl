<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="Req">
		<TranData>
			<xsl:apply-templates select="Head/Sender" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>
	<xsl:template name="Head" match="Sender">
		<Head>
			<TranDate>
				<xsl:value-of select="BusDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="BrchId" /><xsl:value-of select="SubBrchId" />
			</NodeNo>
			<BankCode><xsl:value-of select="../TranCom/@outcode"/></BankCode>		
			<xsl:copy-of select="../ClientIp" />
			<xsl:copy-of select="../FuncFlag" />
			<xsl:copy-of select="../TranCom" />
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		<!-- 保单信息公共节点 -->
      <PubContInfo>
      	 <!--银行交易渠道(0-柜台、1-网银、8-自助终端) -->
         <SourceType><xsl:apply-templates select="../Head/Sender/ChanNo" /></SourceType>
         <RepeatType />
         <!-- 保单号 -->
         <ContNo><xsl:value-of select="PolItem/PolNo" /></ContNo>
         <!-- 保单印刷号 -->
         <PrtNo />
         <ContNoPSW />
         <!-- 险种代码 -->
         <RiskCode></RiskCode>
         <!-- 投保人证件类型 -->
         <AppntIDType><xsl:apply-templates select="AppItem/CusItem/IdType" /></AppntIDType>
         <!-- 投保人证件号 -->
         <AppntIDNo><xsl:value-of select="AppItem/CusItem/IdNo" /></AppntIDNo>
         <!-- 投保人姓名 -->
         <AppntName><xsl:value-of select="AppItem/CusItem/Name" /></AppntName>
         <!-- 投保人证件有效期 -->
         <AppntIdTypeEndDate />
         <AppntPhone />
         <!-- 被保人证件类型 -->
         <InsuredIDType></InsuredIDType>
         <!-- 被保人证件号 -->
         <InsuredIDNo></InsuredIDNo>
         <!-- 被保人姓名 -->
         <InsuredName></InsuredName>
         <!-- 被保人证件有效期 -->
         <InsuredIdTypeEndDate />
         <InsuredPhone />
         <RelationRoleCode1></RelationRoleCode1>
         <RelationRoleName1 />
         <RelationRoleCode2></RelationRoleCode2>
         <RelationRoleName2 />
         <PayMode>7</PayMode>
         <PayGetBankCode />
         <BankName />
         <!-- 退保账户 -->
         <BankAccNo><xsl:value-of select="PolItem/CusActItem/ActNo" /></BankAccNo>
         <!-- 退保账户名 -->
         <BankAccName><xsl:value-of select="PolItem/CusActItem/ActName" /></BankAccName>
         <!--领款人证件类型 -->
		 <BankAccIDType></BankAccIDType>
         <!--领款人证件号 -->
   	 	 <BankAccIDNo></BankAccIDNo>
         <!-- 保全交易类型 -->
         <EdorType>WT</EdorType>
         <!-- 查询=1，确认=2标志 -->
         <EdorFlag>2</EdorFlag>
		 <!-- 人工审批标志，人工审批=1，直接生效=0 -->
	     <ExamFlag>0</ExamFlag>
      </PubContInfo>
      <!-- 保全信息公共节点 -->
      <PubEdorInfo>
      	 <!-- 申请日期 (yyyy-mm-dd)-->
         <EdorAppDate><xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
		</EdorAppDate>
         <!-- 申请人 -->
         <EdorAppName></EdorAppName>
         <Certify>
			<!-- 单证类型( 1-保全申请书， 9-其它) -->
            <CertifyType>1</CertifyType>
			<!--保全名称-->
            <CertifyName />
			<!--保全申请单号-->
            <CertifyCode></CertifyCode>
         </Certify>
      </PubEdorInfo>
	  <EdorCTInfo>
         <EdorReasonCode />
		 <!--保全申请原因-->
         <EdorReason />
         <CertificateIndicator />
         <LostVoucherIndicator />
      </EdorCTInfo>		
	</xsl:template>
	<!-- 渠道 -->
	<xsl:template name="ChanNo" match="ChanNo">
		<xsl:choose>
			<xsl:when test=".=00">0</xsl:when>	<!-- 柜面 -->
			<xsl:when test=".=21">1</xsl:when>	<!-- 个人网银 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 证件类型 -->
	<xsl:template name="IdType" match="IdType">
		<xsl:choose>
			<xsl:when test=".='0101'">0</xsl:when> <!-- 身份证 -->
			<xsl:when test=".='0102'">0</xsl:when> <!-- 身份证 -->
			<xsl:when test=".='0200'">0</xsl:when> <!-- 身份证 -->
			<xsl:when test=".='0300'">5</xsl:when> <!-- 户口簿 -->
			<xsl:when test=".='0301'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='0400'">5</xsl:when> <!-- 户口簿 -->
			<xsl:when test=".='0601'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='0604'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='0700'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='0701'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='0800'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test=".='1000'">1</xsl:when> <!-- 护照 -->
			<xsl:when test=".='1100'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1110'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1111'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1112'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1113'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1114'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1120'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='1121'">6</xsl:when> <!-- 港澳居民来往内地通行证 -->
			<xsl:when test=".='1122'">6</xsl:when> <!-- 港澳居民来往内地通行证 -->
			<xsl:when test=".='1123'">7</xsl:when> <!-- 台湾居民来往大陆通行证 -->
			<xsl:when test=".='1300'">8</xsl:when> <!-- 其它 -->
			<xsl:when test=".='9999'">8</xsl:when> <!-- 其它 -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>