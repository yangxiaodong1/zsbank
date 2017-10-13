<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID />
				<TransType>1032</TransType>
				<TransExeDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" />
				</TransExeTime>
				<xsl:apply-templates select="TranData/Body" />
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="OLifE" match="Body">
		<OLifE>
			<!-- 查询总记录数 -->
			<QueryTotalNum><xsl:value-of select="RecordTotalNum" /></QueryTotalNum>			
			<!-- 查询返回记录数 -->
			<QueryReturnNum><xsl:value-of select="RecordFetchNum" /></QueryReturnNum>	
			<!-- 查询结果,多个结果的循环 -->
			<BusinessLoop>
				<xsl:variable name="count" select ="RecordFetchNum" />
				<xsl:if test="$count!=0">
				<xsl:for-each select="Records/Record">
					<xsl:variable name="idtype" select ="Appnt/IDType" />
					<Business >
						<!--受理日期-->
						<AcceptanceDate><xsl:value-of
							select="java:com.sinosoft.midplat.common.DateUtil.date8to10(TranDate)" /></AcceptanceDate>
						<!--保险公司受理坐席编号-->							
						<AcceptanceId><xsl:value-of select="AcceptanceId" /></AcceptanceId>
						<!-- 客户姓名 -->
						<FullName><xsl:value-of select="Appnt/Name" /></FullName>
						<!-- 客户证件号码 -->
						<GovtID><xsl:value-of select="Appnt/IDNo" /></GovtID>
						<!-- 客户证件类型,目前客服系统只支持身份证，所以暂时写死 -->
						<GovtIDTC tc="0">0</GovtIDTC>
						<!-- 业务类型 -->			
						<BusinessType tc="1"><xsl:value-of select="BusinessType" /></BusinessType>
						<!-- 保单号 -->
						<PolNumber><xsl:value-of select="ContNo" /></PolNumber>
						<!-- 业务类型描述 -->
						<BusinessTypeDesc><xsl:value-of select="BusinessTypeDesc" /></BusinessTypeDesc>
						<!-- 处理结果 -->
						<DealFlag tc="1"><xsl:value-of select="DealFlag" /></DealFlag>
						<!-- 处理结果描述 -->
						<DealFlagDesc><xsl:value-of select="DealFlagDesc" /></DealFlagDesc>
						<!-- 备注 -->
						<Remark><xsl:value-of select="Remark" /></Remark>
					</Business>
					
				</xsl:for-each>
				</xsl:if>
			</BusinessLoop>
		</OLifE>
	</xsl:template>
</xsl:stylesheet>