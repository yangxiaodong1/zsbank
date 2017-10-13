<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- head -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<!-- PubContInfo -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />								
				<!-- PubEdorInfo -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE" />								
   	  			<!-- EdorCTInfo -->
			    <xsl:apply-templates select="TXLife/TXLifeRequest/OLifEExtension" mode="EdorCTInfo" />
			    <!-- EdorXTInfo -->
			    <xsl:apply-templates select="TXLife/TXLifeRequest/OLifEExtension" mode="EdorXTInfo" />															
			</Body>
		</TranData>
	</xsl:template>
	<!-- head -->
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
	
	<!-- 保全公共 -->	
	<xsl:template name="PubEdorInfo" match="OLifE" >	
		<PubEdorInfo>  
		
		  <!-- 申请退保日期[yyyy-MM-dd]-->		  <!--必填项-->
		  <EdorAppDate>
		 	 <xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
		  </EdorAppDate>                   
   	 	  <!-- 申请人姓名-->			              <!--必填项-->
   	 	  <EdorAppName></EdorAppName>                             		
		    <Certify>
				<!-- 单证类型( 1-保全申请书 9-其它) -->	<!--确认交易时为必填项-->
				<CertifyType>
					<xsl:apply-templates select="FormName" />
				</CertifyType>                        	
				<!-- 单证名称(保全申请书号码) -->	    	<!--确认交易时为必填项-->
				<CertifyName></CertifyName>           	
				<!-- 单证印刷号(1-保全申请书号码)-->		<!--确认交易时为必填项-->
				<CertifyCode>
					<xsl:apply-templates select="FormInstance/ProviderFormNumber" />  
				</CertifyCode>             	
   		  </Certify>
   	  </PubEdorInfo>
	</xsl:template>
		
	<!-- 退保特有字段 -->
	<xsl:template name="EdorCTInfo" match="OLifEExtension" mode="EdorCTInfo" >
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
	
	<!-- 协议退保特有字段 -->
	<xsl:template name="EdorXTInfo" match="OLifEExtension" mode="EdorXTInfo" >
		<EdorXTInfo> 
		  <!-- 退保原因代码 -->
   		  <EdorReasonCode></EdorReasonCode>        
   		  <!-- 退保原因 -->             
   		  <EdorReason></EdorReason>               
   		  <!-- 是否提交《中华人民共和国残疾人证》或《最低生活保障金领取证》Y是N否 -->        
   		  <CertificateIndicator></CertificateIndicator>          
   		  <!-- 首期保险费发票丢失 Y是N否 -->
   		  <LostVoucherIndicator></LostVoucherIndicator>         
	  </EdorXTInfo> 
	</xsl:template>
	
	<!--  公共 -->
	<xsl:template name="PubContInfo" match="Policy" >				
		<PubContInfo>
			<!-- 银行交易渠道(柜台/网银),0-柜面，1-网银，8-自助终端 -->
			<SourceType>1</SourceType><!-- TODO 核心需要这个值为1 ，不然无法做冲正交易，已经跟郝庆涛确认过 -->
			<!-- 重送标志:0否，1是--><!--必填项-->
			<RepeatType><xsl:apply-templates select="../../../RepeatType" /></RepeatType>                              
			<!-- 保险单号码 --><!--必填项 -->
			<ContNo><xsl:value-of select="PolNumber" /></ContNo> 
			<!-- 投保单印刷号码 -->					  	 	  														  
  	 	 	<PrtNo></PrtNo>		
  	 	 	<!-- 保单密码 -->									
  	 	 	<ContNoPSW><xsl:value-of select="OLifEExtension/Password" /></ContNoPSW>   
  	 	 	<!-- 保险产品代码 （主险）-->                 
  	 		<!-- PBKINSR-818 浙江工行专项产品项目（一期） -->
			<xsl:variable name="RegionCode" select="../../../OLifEExtension/RegionCode" />
			<xsl:variable name="Teller" select="../../../OLifEExtension/Teller" />
			<xsl:variable name="SpecialProduct"  select="java:com.sinosoft.midplat.icbc.IcbcUtil.zjCheck($RegionCode,$Teller)"/>
			<!-- PBKINSR-818 浙江工行专项产品项目（一期） -->
			<xsl:choose>
				<xsl:when test="$SpecialProduct=1">	<!-- 浙江工行专属产品 -->
					<RiskCode><xsl:apply-templates select="ProductCode" mode="SpecialProduct" /></RiskCode> 
				</xsl:when>
				<xsl:otherwise>	<!-- 其他 -->
					<RiskCode><xsl:apply-templates select="ProductCode" mode="NoSpecialProduct" /></RiskCode> 
				</xsl:otherwise>
			</xsl:choose> 		  	 		   	 		   	 		  	 		
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
   	 	    <BankAccNo><xsl:apply-templates select="../../Holding/Banking/AccountNumber" /></BankAccNo>       
   	 	    <!-- 补退费帐户户名--><!--确认交易时为必填项-->                   	
   	 	    <BankAccName><xsl:apply-templates select="../../Holding/Banking/AcctHolderName" /></BankAccName>                  			
	  </PubContInfo>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_RiskCode" match="ProductCode" mode = "NoSpecialProduct">
	<xsl:choose>
		<xsl:when test=".=001">122001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
		<xsl:when test=".=002">122002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test=".=101">122004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test=".=003">122003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
		<xsl:when test=".=004">122006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
		<xsl:when test=".=005">122008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
		<xsl:when test=".=006">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
		<xsl:when test=".=007">122011</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型）  -->
		<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
		<xsl:when test=".=008">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型）  -->
		<xsl:when test=".=009">L12100</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型）  -->
		<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
		<xsl:when test=".=010">122029</xsl:when>	<!-- 安邦盛世5号终身寿险（万能型）  -->
		<xsl:when test=".=011">122020</xsl:when>	<!-- 安邦长寿6号两全保险（分红型）  -->
		<xsl:when test=".=012">122036</xsl:when>	<!-- 安邦黄金鼎6号两全保险（分红型）A款  -->
		<!-- 因保全交易核心只关心contno，riskcode不关心；前五年50002这款产品的主险为122046，五年后这款主险的产品为122048,如果5年后做退保时核心传的主险险种便成了122048 -->
		<xsl:when test=".=013">122046</xsl:when>	<!-- 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成  -->
		<!-- <xsl:when test=".=014">122038</xsl:when> -->	<!-- 安邦价值增长8号终身寿险（分红型）A款 -->
		<!-- PBKINSR-787 工行，银保通开发盛世9号新产品项目 -->
		<xsl:when test=".=014">L12074</xsl:when>	<!-- 安邦盛世9号两全保险（万能型）  -->
		<!-- PBKINSR-787 工行，银保通开发盛世9号新产品项目 -->
		<!-- PBKINSR-924 工行网银上线新产品（安邦汇赢2号年金保险A款）-->
		<xsl:when test=".=015">L12084</xsl:when>	<!-- 安邦汇赢2号年金保险A款  -->
		<xsl:when test=".=016">L12089</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型）B款  -->
		<xsl:when test=".=017">L12093</xsl:when>	<!-- 安邦盛世9号两全保险B款（万能型）  -->
		<xsl:when test=".=018">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
		<xsl:when test=".=L12088">L12088</xsl:when>	<!-- 安邦东风9号两全保险（万能型） -->
		<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
		<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	</xsl:template>	
	
	<!-- 浙江工行专属险种代码 -->
	<xsl:template name="tran_RiskCode1" match="ProductCode" mode = "SpecialProduct">
	<xsl:choose>
		<xsl:when test=".=008">L12077</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型）  -->
		<!-- PBKINSR-1327 浙江工行日日升C款（盛世9号）项目 2016-06-18  -->
		<xsl:when test=".=014">L12102</xsl:when>	<!-- 安邦盛世9号两全保险（万能型）  -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	</xsl:template>	
	
	<!-- 渠道类型 -->
	<xsl:template match="SourceType">
	<xsl:choose>
		<xsl:when test=".=0">0</xsl:when>	<!-- 银保通 -->
		<xsl:when test=".=1">1</xsl:when>	<!-- 网银 -->
		<xsl:when test=".=8">8</xsl:when>	<!-- 自助终端 -->
		<!-- 浙江工行手机渠道采用的是网银渠道出单，此处不需要增加手机渠道 -->
		<!-- <xsl:when test=".=5">17</xsl:when>  -->	<!-- 手机银行 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	</xsl:template>	
	
</xsl:stylesheet>


	

