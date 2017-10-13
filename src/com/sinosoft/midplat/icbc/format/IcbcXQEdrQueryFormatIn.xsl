<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />								
				
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE" />
				
			    <xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy/FinancialActivity" />
																
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date10to8(TransExeDate)" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TransExeTime)" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OLifEExtension/Teller" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="OLifEExtension/RegionCode" />
				<xsl:value-of select="OLifEExtension/Branch" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>
	
	<xsl:template name="PubEdorInfo" match="OLifE" >	
	
		<xsl:variable name="AppntPartyID" select="Relation[RelationRoleCode='80']/@RelatedObjectID" />				
		<xsl:variable name="AppntPartyNode" select="Party[@id=$AppntPartyID]" />
		<PubEdorInfo>  
		  <!-- 申请退保日期[yyyy-MM-dd]-->		  <!--必填项-->
		  <EdorAppDate>	
				 <xsl:value-of
          			  select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />       	
		  </EdorAppDate>                   
   	 	  <!-- 申请人姓名-->			              <!--必填项-->
   	 	  <EdorAppName>   	 	  	
   	 	  </EdorAppName>                             		
		    <Certify>
				<!-- 单证类型( 1-保全申请书 9-其它) -->	<!--确认交易时为必填项-->
				<CertifyType></CertifyType>                        	
				<!-- 单证名称(保全申请书号码) -->	    	<!--确认交易时为必填项-->
				<CertifyName></CertifyName>           	
				<!-- 单证印刷号(1-保全申请书号码)-->		<!--确认交易时为必填项-->
				<CertifyCode>000000</CertifyCode>             	
   		  </Certify>
   	  </PubEdorInfo>
	</xsl:template>
		
	<!-- 续期特有字段 -->
	<xsl:template name="EdorXQInfo" match="FinancialActivity" >
		<EdorXQInfo> 
		   <!-- 金额 -->
   		  <GrossAmt><xsl:value-of select="FinActivityGrossAmt" /></GrossAmt>                       
   		   <!-- 应收日期[yyyyMMdd] --> 	     
   		  <FinEffDate>
   		  <xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date10to8(FinEffDate)" />
   		  </FinEffDate>               
	    </EdorXQInfo> 
	</xsl:template>
	
	<!--  公共 -->
	<xsl:template name="PubContInfo" match="Policy" >				
		<PubContInfo>
			<!-- 银行交易渠道(柜台/网银)-->
			<SourceType>0</SourceType>
			<!-- 重送标志:0否，1是--><!--必填项-->
			<RepeatType></RepeatType>                              
			<!-- 保险单号码 --><!--必填项 -->
			<ContNo><xsl:value-of select="PolNumber" /></ContNo> 
			<!-- 投保单印刷号码 -->					  	 	  														  
  	 	 	<PrtNo></PrtNo>		
  	 	 	<!-- 保单密码 -->									
  	 	 	<ContNoPSW><xsl:value-of select="OLifEExtension/Password" /></ContNoPSW>   
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
   	 	    <BankAccNo><xsl:apply-templates select="../../Holding/Banking/AccountNumber" /></BankAccNo>       
   	 	    <!-- 补退费帐户户名--><!--确认交易时为必填项-->                   	
   	 	    <BankAccName><xsl:apply-templates select="../../Holding/Banking/AcctHolderName" /></BankAccName>                  			
	  </PubContInfo>
	</xsl:template>				
</xsl:stylesheet>


	

