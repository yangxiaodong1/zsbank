<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

<xsl:template match="ABCB2I">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="Header" />
			
			<!-- 报文体 -->
			<Body>
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
		  <!-- 申请退保日期[yyyy-MM-dd]-->		  <!--必填项-->
		  <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></EdorAppDate>                   
   	 	  <!-- 申请人姓名-->			              <!--必填项-->
   	 	  <EdorAppName></EdorAppName>                             		
		    <Certify>
				<!-- 单证类型( 1-保全申请书 9-其它) -->	<!--确认交易时为必填项-->
				<CertifyType></CertifyType>                        	
				<!-- 单证名称(保全申请书号码) -->	    	<!--确认交易时为必填项-->
				<CertifyName></CertifyName>           	
				<!-- 单证印刷号(1-保全申请书号码)-->		<!--确认交易时为必填项-->
				<CertifyCode>000000</CertifyCode>             	
   		  </Certify>
   	  </PubEdorInfo>
 
		<EdorXQInfo> 
		   <!-- 金额 -->
   		  <GrossAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PayAmt)" /></GrossAmt>                       
   		   <!-- 应收日期[yyyyMMdd] --> 	     
   		  <FinEffDate></FinEffDate>               
	    </EdorXQInfo> 
			
		<PubContInfo>
			<!-- 银行交易渠道(柜台/网银)-->
			<SourceType>0</SourceType>
			<!-- 重送标志:0否，1是--><!--必填项-->
			<RepeatType></RepeatType>                              
			<!-- 保险单号码 --><!--必填项 -->
			<ContNo><xsl:value-of select="PolicyNo" /></ContNo> 
			<!-- 投保单印刷号码 -->					  	 	  														  
  	 	 	<PrtNo></PrtNo>		
  	 	 	<!-- 保单密码 -->									
  	 	 	<ContNoPSW></ContNoPSW>   
  	 	 	<!-- 保险产品代码 （主险）-->                 
  	 		<RiskCode><xsl:apply-templates select="RiskCode"  mode="risk"/></RiskCode>
  	 		<!-- 投保人证件类型 -->
			<AppntIDType><xsl:apply-templates select="Appl/IDKind" /></AppntIDType>
			<!-- 投保人证件号码 -->					   			            	
	   	 	<AppntIDNo><xsl:value-of select="Appl/IDCode" /></AppntIDNo>                    
	   	 	 <!-- 投保人姓名 --> 	
	   	 	<AppntName><xsl:value-of select="Appl/Name" /></AppntName>  
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
   	 	    <BankAccNo><xsl:value-of select="PayAcc" /></BankAccNo>       
   	 	    <!-- 补退费帐户户名--><!--确认交易时为必填项-->                   	
   	 	    <BankAccName><xsl:value-of select="Appl/Name" /></BankAccName>                  			
	  </PubContInfo>
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
	
	<!-- 险种代码 -->
	<xsl:template  match="RiskCode"  mode="risk">
		<xsl:choose>
			<xsl:when test=".='122046'">50001</xsl:when><!-- 长寿稳赢1号套餐 -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- 长寿稳赢保险计划 -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<!-- <xsl:when test=".='122010'">122010</xsl:when>  --><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号两全保险（万能型）B款  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号两全保险（万能型）  -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- 长寿稳赢保险计划 -->
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
			
			<!-- 安邦长寿安享5号保险计划50012,安邦长寿安享5号年金保险L12070,安邦附加长寿添利5号两全保险（万能型）L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			
			<!-- 安邦东风3号两全保险（万能型）L12086 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>