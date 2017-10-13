<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="Transaction">
		<TranData>
			<xsl:apply-templates select="Transaction_Header"/>

			<Body>
			    <!-- 保全公共 -->	
				<PubEdorInfo>  
		           <!-- 申请退保日期[yyyy-MM-dd]-->		  <!--必填项-->
		           <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></EdorAppDate>                
   	 	           <NonAppNoFlag>1</NonAppNoFlag> <!-- 不校验保全申请书号,此处也需要确认是否不校验保全申请书号呢？？？？？ -->
   	 	           <!-- 申请人姓名-->			          <!--必填项-->
   	 	           <EdorAppName></EdorAppName>                             		
		           <Certify>
				      <!-- 单证类型( 1-保全申请书 9-其它) -->	<!--确认交易时为必填项-->
				      <CertifyType></CertifyType>                        	
				      <!-- 单证名称(保全申请书号码) -->	    	<!--确认交易时为必填项-->
				      <CertifyName></CertifyName>           	
				      <!-- 单证印刷号(1-保全申请书号码)-->		<!--确认交易时为必填项-->
				      <CertifyCode></CertifyCode>             	
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
	          <!--  公共 -->
	          <PubContInfo>
			      <!-- 银行交易渠道(柜台/网银),0=银保通，1=网银，8=自助终端,核心默认为0-->
			      <SourceType>0</SourceType>
			      <!-- 重送标志:0否，1是--><!--必填项-->
			      <RepeatType></RepeatType>
			      <!-- 保险单号码 --><!--必填项 -->
			      <ContNo><xsl:value-of select="Transaction_Body/PbInsuSlipNo" /></ContNo>
			      <!-- 投保单印刷号码 -->
			      <PrtNo></PrtNo>
			      <!-- 保单密码 -->
			      <ContNoPSW></ContNoPSW>
			      <!-- 保险产品代码 （主险）-->
			      <RiskCode></RiskCode>
			      <!-- 投保人证件类型 -->
			      <AppntIDType>
			          <xsl:call-template name="tran_idtype">
					    <xsl:with-param name="idtype">
						   <xsl:value-of select="Transaction_Body/LiRcgnIdType" />
					    </xsl:with-param>
				      </xsl:call-template>
			      </AppntIDType>
			      <!-- 投保人证件号码 -->
			      <AppntIDNo><xsl:value-of select="Transaction_Body/LiRcgnId" /></AppntIDNo>
			      <!-- 投保人姓名 -->
			      <AppntName><xsl:value-of select="Transaction_Body/PbInsuName" /></AppntName>
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
			      <BankAccNo><xsl:value-of select="Transaction_Body/stdpriacno" /></BankAccNo>
			      <!-- 补退费帐户户名--><!--确认交易时为必填项-->
			      <BankAccName><xsl:value-of select="Transaction_Body/PbInsuName" /></BankAccName>
				  <!-- 保全交易类型 -->
	              <EdorType>ZL</EdorType>
	              <!-- 查询=1，确认=2标志 -->
	              <EdorFlag>2</EdorFlag>
	              <!-- 人工审批标志，人工审批=1，直接生效=0，确认时给1，查询时给0 -->
	              <!-- 目前招行仅支持网银退保传影像，犹退不传影像，直接生效 -->
	              <ExamFlag>0</ExamFlag>
		      </PubContInfo>
		      <EdorZLInfo>
                 <LoanMoney><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Transaction_Body/PbInsuAmt)"/></LoanMoney>
              </EdorZLInfo>
		   </Body>
		</TranData>
	</xsl:template>

    <xsl:template name="Head" match="Transaction_Header">
       <Head>
	      <TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	      <TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
          <NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	      <TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	      <TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	      <xsl:copy-of select="../Head/*"/>
	      <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
      </Head>
    </xsl:template>
    <!-- 证件类型 -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
		   <xsl:when test="$idtype='A'">0</xsl:when>	<!-- 身份证 -->
	       <xsl:when test="$idtype='B'">2</xsl:when>	<!-- 军官证 -->
	       <xsl:when test="$idtype='F'">5</xsl:when>	<!-- 户口薄 -->
	       <xsl:when test="$idtype='I'">1</xsl:when>	<!-- （外国） 护照-->
	       <xsl:when test="$idtype='8'">7</xsl:when>	<!-- 台湾居民来往大陆通行证-->
	       <xsl:when test="$idtype='G'">6</xsl:when>   <!-- 港澳回乡证 -->
	       <xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>