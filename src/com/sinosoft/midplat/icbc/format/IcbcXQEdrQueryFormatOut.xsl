<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife> 			
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>				
				<TransRefGUID/>
				<TransType></TransType>
				<TransExeDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()"/>
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				</TransExeTime>							
				
				<!-- 展现返回的结果 -->
				<xsl:apply-templates select="TranData/Body"/>	
				
				<!-- 交易代码	TODO 需要确认是否需要这个节点 -->
				<OLifEExtension VendorCode="1">			
					<TransNo>1000</TransNo>			
				</OLifEExtension>						
				</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="OLifE" match="Body">		
		<OLifE>
			<!-- 保单数据 -->
			<Holding id="Holding_1">
				<Policy>
					<PolNumber><xsl:value-of select="PubContInfo/ContNo"/></PolNumber>
					<!--保单号-->
					<Life>
						<!--  险种数目   --> 
  					<CoverageCount><xsl:value-of select="EdorXQInfo/CoverageCount"/></CoverageCount> 
						<!-- Optional repeating -->
						<xsl:for-each select="EdorXQInfo/Risk">						
						<Coverage>
							<!-- 循环节点,返回时按应交序号顺序递增返回 -->
							<PlanName><xsl:value-of select="RiskName"/></PlanName>
							<!-- 险种名称 -->
							<ProductCode><xsl:apply-templates select="RiskCode"/></ProductCode>
							<!-- 险种代码 -->
							<OLifEExtension VendorCode="10">
								<!-- 应交序号,返回时按顺序递增 -->
								<PaymentOrder><xsl:value-of select="PayExtension/PaymentOrder"/></PaymentOrder>
								<!-- 缴费金额 -->
								<NextPayAmt><xsl:value-of select="PayExtension/NextPayAmt"/></NextPayAmt>
								<!-- 应收日期-->
								<PaymentDate><xsl:value-of select="PayExtension/PaymentDate"/></PaymentDate>
								<!-- 应交记录状态-->
								<PaymentState>可以续期缴费</PaymentState>
								<!-- 提示信息-->
								<Remark><xsl:value-of select="Remark"/></Remark>			
							</OLifEExtension>
						</Coverage>
						</xsl:for-each>
					</Life>
				</Policy>
				<FinancialActivity>
					<!--应收金额-->
					<FinActivityGrossAmt><xsl:value-of select="EdorXQInfo/FinActivityGrossAmt" /></FinActivityGrossAmt>
					<!-- 应收日期（国寿）  --> 
					<FinEffDate>
						<xsl:value-of select="EdorXQInfo/FinEffDate"/>
					</FinEffDate> 	
					<!--  缴费年期   -->	
					<OLifEExtension VendorCode="9">						 
  						<PaymentYears><xsl:value-of select="EdorXQInfo/PaymentYears"/></PaymentYears> 
						<!-- 收费项目-->
						<PayItm><xsl:value-of select="EdorXQInfo/PayItm"/></PayItm>					
						<!-- 应缴期数 -->
						<PaymentTimes><xsl:value-of select="EdorXQInfo/PaymentTimes"/></PaymentTimes>
						<!-- 已缴期数 -->
						<PayedTimes><xsl:value-of select="EdorXQInfo/PayedTimes"/></PayedTimes>
						<PaymentStartDate>
							<xsl:value-of select="EdorXQInfo/PaymentStartDate"/>
						</PaymentStartDate>
						<!-- 缴费起始日期 -->
						<PaymentEndDate>
							<xsl:value-of select="EdorXQInfo/PaymentEndDate"/>
						</PaymentEndDate>
						<!-- 缴费终止日期 -->
						<ACCCODE><xsl:value-of select="EdorXQInfo/ACCCODE"/></ACCCODE>
						<!-- for中国人寿，账户代码 -->
					</OLifEExtension>
				</FinancialActivity>
			</Holding>
			<Party id="Party_1">
				<FullName><xsl:value-of select="PubContInfo/AppntName" /></FullName>
				<!-- 投保人姓名 -->
				<GovtID><xsl:value-of select="PubContInfo/AppntIDNo" /></GovtID>
				<!-- 投保人证件号码 -->
				<GovtIDTC tc="1"><xsl:apply-templates select="PubContInfo/AppntIDType" /></GovtIDTC>
				<!-- 投保人证件类型 -->				
			</Party>
			<Relation OriginatingObjectID="Holding_1" RelatedObjectID="Party_1" id="Relation_1">
				<OriginatingObjectType tc="4">4</OriginatingObjectType>
				<RelatedObjectType tc="6">6</RelatedObjectType>
				<RelationRoleCode tc="80">80</RelationRoleCode>
				<!-- 投保人关系 -->
			</Relation>
		</OLifE>					
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template name="tran_ProductCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".=122001">001</xsl:when>
			<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
			<xsl:when test=".=122002">002</xsl:when>
			<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
			<xsl:when test=".=122003">003</xsl:when>
			<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
			<xsl:when test=".=122004">101</xsl:when>
			<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->			
			<xsl:when test=".=122006">004</xsl:when>
			<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
			<xsl:when test=".=122008">005</xsl:when>
			<!-- 安邦白玉樽1号终身寿险（万能型） -->
			<xsl:when test=".=122009">006</xsl:when>
			<!-- 安邦黄金鼎5号两全保险（分红型）A款  -->			
			<xsl:when test=".=122011">007</xsl:when>
			<!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test=".=122012">008</xsl:when>
			<!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test=".=122010">009</xsl:when>
			<!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".=122029">010</xsl:when>
			<!-- 安邦盛世5号终身寿险（万能型）  -->
			<xsl:when test=".=122020">011</xsl:when>
			<!-- 安邦长寿6号两全保险（分红型）  -->
			<xsl:when test=".=122036">012</xsl:when>
			<!-- 安邦黄金鼎6号两全保险（分红型）A款  -->
			<xsl:when test=".='122046'">013</xsl:when>	<!-- 安邦长寿稳赢：122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成  -->
			<xsl:when test=".=122038">014</xsl:when>
			<!-- 安邦价值增长8号终身寿险（分红型）A款 -->
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->	
			<xsl:when test=".='L12079'">008</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12078'">009</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='L12100'">009</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='L12074'">014</xsl:when>	<!-- 安邦盛世9号终身寿险（万能型）  -->
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
			<!-- PBKINSR-923 工行银保通上线新产品（安邦汇赢2号年金保险A款） -->
			<xsl:when test=".='L12084'">015</xsl:when>	<!-- 安邦汇赢2号年金保险A款  -->
			<xsl:when test=".='L12093'">017</xsl:when>	<!-- 安邦盛世9号两全保险B款（万能型）  -->
			<xsl:when test=".='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
			<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 证件类型 -->
	<xsl:template name="tran_idtype" match="AppntIDType">
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
</xsl:stylesheet>
