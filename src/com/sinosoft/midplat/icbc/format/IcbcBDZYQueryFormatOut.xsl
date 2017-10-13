<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife> 			
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>				
				<TransRefGUID>
				<xsl:value-of select="TranNo" />
				</TransRefGUID>
				<TransType>1007</TransType>
				<TransSubType>2</TransSubType>
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
					<TransNo>1007</TransNo>			
				</OLifEExtension>						
				</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="OLifE" match="Body">		
		<OLifE>
			<!-- 保单数据 -->
			<Holding id="Holding_1">
				<Policy>
					<PolNumber><xsl:value-of select="ContNo"/></PolNumber>
					<!--保单号--> 
					<PlanName><xsl:value-of select="Risk/RiskName" /></PlanName>
					<!-- 险种名称 -->					
					<ProductCode><xsl:apply-templates select="//Risk/RiskCode"/></ProductCode>
					<!-- 险种代码 -->
					<PolicyStatus><xsl:value-of select="//EdorInfo/EdorState"/></PolicyStatus>
					<!--保单状态-->
					<!--<MortStatu><xsl:apply-templates select="MortStatu"/></MortStatu>-->
					<!--保单质押状态-->
					<Life>
					    <CashValueAmt><xsl:value-of select="//Surr/LoanMoney"/></CashValueAmt>
						<!-- 保单可质押金额 -->
					</Life>
					<!--申请信息-->
					<ApplicationInfo>
						<!--投保书号-->
						<HOAppFormNumber>
							<xsl:value-of select="ProposalPrtNo"/>
						</HOAppFormNumber>
						<!-- 投保日期 -->
						<SubmissionDate>
							<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Risk/PolApplyDate)"/>
						</SubmissionDate>						
					</ApplicationInfo>
				</Policy>
				<Loan>
					<LastActivityDate><xsl:apply-templates select="//Risk/InsuEndDate"/></LastActivityDate>
					<!-- 保单终止日期 -->
				</Loan>
				<OLifEExtension VendorCode="3">
					<!--钞汇标志-->
					<CashEXF>0</CashEXF>
				</OLifEExtension>
			</Holding>
				<!--投保人信息-->
			<Party id="Party_1">
				<PartyKey>1</PartyKey>
				<FullName>
					<xsl:value-of select="Appnt/Name" />
				</FullName>
				<!-- 投保人姓名 -->
				<GovtID>
					<xsl:value-of select="Appnt/IDNo" />
				</GovtID>
				<!-- 投保人证件号码 -->
				<GovtIDTC tc="1">
					<xsl:apply-templates select="Appnt/IDType" />
				</GovtIDTC>
				<!-- 投保人证件类型 -->
				<Person>
					<Gender>
						<xsl:apply-templates select="Appnt/Sex" />
					</Gender>
					<!-- 投保人性别 -->
					<BirthDate>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Appnt/Birthday)" />
					</BirthDate>
					<!-- 投保人出生日期 -->
					<OccupationType tc="1" />
					<!-- 投保人职业类别 -->
				</Person>
				<Address id="Address_1">
					<AddressTypeCode tc="17">17</AddressTypeCode>
					<Line1>
						<xsl:value-of select="Appnt/Address" />
					</Line1>
					<Zip>
						<xsl:value-of select="Appnt/ZipCode" />
					</Zip>
				</Address>
				<!-- 家庭电话 -->
				<Phone>
					<PhoneTypeCode tc="1">1</PhoneTypeCode>
					<DialNumber>
						<xsl:value-of select="Appnt/Phone" />
					</DialNumber>
				</Phone>
				<!-- 移动电话 -->
				<Phone>
					<PhoneTypeCode tc="3">3</PhoneTypeCode>
					<DialNumber>
						<xsl:value-of select="Appnt/Mobile" />
					</DialNumber>
				</Phone>
			</Party>
			<Relation OriginatingObjectID="Holding_1" RelatedObjectID="Party_1" id="Relation_2">
				<OriginatingObjectType tc="4">4</OriginatingObjectType>
				<RelatedObjectType tc="6">6</RelatedObjectType>
				<RelationRoleCode tc="80">80</RelationRoleCode>
				<!-- 投保人关系 -->
			</Relation>
			
			<!-- 被保人信息 -->
		<Party id="Party_2">
				<PartyKey>1</PartyKey>
				<FullName>
					<xsl:value-of select="Insured/Name" />
				</FullName>
				<!-- 投保人姓名 -->
				<GovtID>
					<xsl:value-of select="Insured/IDNo" />
				</GovtID>
				<!-- 投保人证件号码 -->
				<GovtIDTC tc="1">
					<xsl:apply-templates select="Insured/IDType" />
				</GovtIDTC>
				<!-- 投保人证件类型 -->
				<Person>
					<Gender>
						<xsl:apply-templates select="Insured/Sex" />
					</Gender>
					<!-- 投保人性别 -->
					<BirthDate>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Insured/Birthday)" />
					</BirthDate>
					<!-- 投保人出生日期 -->
					<OccupationType tc="1" />
					<!-- 投保人职业类别 -->
				</Person>
				<Address id="Address_1">
					<AddressTypeCode tc="17">17</AddressTypeCode>
					<Line1>
						<xsl:value-of select="Insured/Address" />
					</Line1>
					<Zip>
						<xsl:value-of select="Insured/ZipCode" />
					</Zip>
				</Address>
				<!-- 家庭电话 -->
				<Phone>
					<PhoneTypeCode tc="1">1</PhoneTypeCode>
					<DialNumber>
						<xsl:value-of select="Insured/Phone" />
					</DialNumber>
				</Phone>
				<!-- 移动电话 -->
				<Phone>
					<PhoneTypeCode tc="3">3</PhoneTypeCode>
					<DialNumber>
						<xsl:value-of select="Insured/Mobile" />
					</DialNumber>
				</Phone>
			</Party>
			<Relation OriginatingObjectID="Holding_1" RelatedObjectID="Party_2" id="Relation_3">
				<OriginatingObjectType tc="4">4</OriginatingObjectType>
				<RelatedObjectType tc="6">6</RelatedObjectType>
				<RelationRoleCode tc="80">80</RelationRoleCode>
				<!-- 被保人关系 -->
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
			<xsl:when test=".='L12086'">018</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
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
	
	<!-- 性别 -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 男 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 女 -->
			<xsl:when test=".='2'">3</xsl:when><!-- 其他 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 保单质押状态 -->
	<xsl:template name="tran_MortStatu" match="MortStatu">
		<xsl:choose>
			<xsl:when test=".='0'">未质押</xsl:when>
			<xsl:when test=".='1'">质押</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
