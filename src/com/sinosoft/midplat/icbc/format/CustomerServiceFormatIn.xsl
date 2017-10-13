<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/TXLifeRequest" />

			<Body>
				<xsl:apply-templates
					select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />
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

	<xsl:template name="Body" match="Policy">
		<!--保单号 注意此字段和投保人姓名字段肯定传一个 -->
		<ContNo><xsl:value-of select="PolNumber" /></ContNo>
		<Appnt>
			<xsl:variable name="AppntPartyID" select="../../Relation[RelationRoleCode='80']/@RelatedObjectID" />				
			<xsl:variable name="AppntPartyNode" select="../../Party[@id=$AppntPartyID]" />
			<!--投保人姓名-->
			<Name><xsl:value-of select="$AppntPartyNode/FullName" /></Name>			
			<!--性别 可选项 取值由客服系统定义-->
			<Sex></Sex>
			<!--出生日期 可选项 -->
			<Birthday></Birthday>
			<!--证件类型 可选项  取值由客服系统定义-->
			<IDType>0</IDType>
			<!--证件号 可选项  -->
			<IDNo><xsl:value-of select="$AppntPartyNode/GovtID" /></IDNo>
		</Appnt>
		<Query>
			<!--查询起始日期 可选项  -->
			<QueryBeginDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(OLifEExtension/QueryBeginDate)" /></QueryBeginDate>
			<!--查询截止日期 可选项  -->
			<QueryEndDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(OLifEExtension/QueryEndDate)" /></QueryEndDate>
			<!--查询起始条数 如第一页1+查询获取条数×0，第二页1+查询获取条数×1，第三页1+查询获取条数×2-->
			<RecordBeginNum><xsl:value-of select="OLifEExtension/QueryBeginNum" /></RecordBeginNum>
			<!--查询获取条数-->
			<RecordFetchNum><xsl:value-of select="OLifEExtension/QueryFetchNum" /></RecordFetchNum>
		</Query>
	</xsl:template>

</xsl:stylesheet>