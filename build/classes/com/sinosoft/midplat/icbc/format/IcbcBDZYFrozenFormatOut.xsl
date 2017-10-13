<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID>
					<xsl:value-of select="TranNo" />
				</TransRefGUID>
				<TransType>1008</TransType>
				<TransSubType>2</TransSubType>
				<TransExeDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" />
				</TransExeTime>

				<!-- 展现返回的结果 -->
				<xsl:apply-templates select="TranData/Body" />

				<!-- 交易代码	TODO 需要确认是否需要这个节点 -->
				<OLifEExtension VendorCode="1">
					<TransNo>1008</TransNo>
				</OLifEExtension>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLifE" match="Body">
		<OLifE>
			<!-- 保单数据 -->
			<Holding id="Holding_1">
				<Policy>
					<!--保单号-->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!--保单状态-->
					<PolicyStatus>
						<xsl:value-of
							select="PubEdorQuery/PolicyStatus" />
					</PolicyStatus>
					<!--  银行帐户  -->
					<AccountNumber>
						<xsl:value-of select="PubContInfo/BankAccNo" />
					</AccountNumber>
					<Life>
						<CashValueAmt><xsl:value-of select="//Risk/GetMoney" /></CashValueAmt>
						<!-- 保单可质押金额 -->
					</Life>
				</Policy>
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
				</Person>
			</Party>
			<Relation OriginatingObjectID="Holding_1"
				RelatedObjectID="Party_1" id="Relation_2">
				<OriginatingObjectType tc="4"> 
				</OriginatingObjectType>
				<RelatedObjectType tc="6">Party</RelatedObjectType>
				<RelationRoleCode tc="80">Owner</RelationRoleCode>
				<!-- 投保人关系 -->
			</Relation>

			<!-- 单证信息 -->
			<FormInstance id="Form_1">
				<!-- 单证名称 -->
				<FormName>
					<xsl:value-of select="PubEdorConfirm/FormName"></xsl:value-of>
				</FormName>
				<!-- 批单号 -->
				<DocumentControlNumber>
					<xsl:value-of select="PubEdorConfirm/FormNumber"></xsl:value-of>
				</DocumentControlNumber>
				<!-- 批单信息区 -->
				<Attachment id="Attachment_Form_1">
					<Description></Description>
					<!-- 批单内容 -->
					<AttachmentData>content</AttachmentData>
					<AttachmentType tc="2147483647">Other</AttachmentType>
					<AttachmentLocation tc="1">In Line</AttachmentLocation>
				</Attachment>
			</FormInstance>
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
			<xsl:when test=".='122046'">013</xsl:when><!-- 安邦长寿稳赢：122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、L12081-安邦长寿添利终身寿险（万能型）组成  -->
			<xsl:when test=".=122038">014</xsl:when>
			<!-- 安邦价值增长8号终身寿险（分红型）A款 -->
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
			<xsl:when test=".='L12079'">008</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12078'">009</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='L12100'">009</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='L12074'">014</xsl:when><!-- 安邦盛世9号终身寿险（万能型）  -->
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
			<!-- PBKINSR-923 工行银保通上线新产品（安邦汇赢2号年金保险A款） -->
			<xsl:when test=".='L12084'">015</xsl:when><!-- 安邦汇赢2号年金保险A款  -->
			<xsl:when test=".='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
			<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 证件类型 -->
	<xsl:template name="tran_idtype" match="AppntIDType">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when><!-- 身份证 -->
			<xsl:when test=".=1">1</xsl:when><!-- 护照 -->
			<xsl:when test=".=2">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".=3">2</xsl:when><!-- 士兵证 -->
			<xsl:when test=".=5">0</xsl:when><!-- 临时身份证 -->
			<xsl:when test=".=6">5</xsl:when><!-- 户口本  -->
			<xsl:when test=".=9">2</xsl:when><!-- 警官证  -->
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
</xsl:stylesheet>
