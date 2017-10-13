<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Rsp>
	<xsl:apply-templates select="TranData/Head"/>
	<xsl:apply-templates select="TranData/Body"/>
</Rsp>
</xsl:template>

<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0表示成功，1表示失败 ，3转非实时-->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- 失败时，返回错误信息 -->
		</Head>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
<Body>
	<PolItem>
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<!-- 保单号 -->
		<PolNo><xsl:value-of select="ContNo" /></PolNo>
		<!-- 保单状态:已缴费并核保 -->
		<PolStat>1</PolStat>
		<!-- 缴费金额 -->
		<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PayAmt>
		<!-- 承保日期 -->
		<AcceptDate><xsl:value-of select="$MainRisk/PolApplyDate" /></AcceptDate>
		<!-- 生效日期 -->
		<ValiDate><xsl:value-of select="$MainRisk/CValiDate" /></ValiDate>
		<!-- 终止日期 -->
		<xsl:choose>
			<xsl:when test="$MainRisk/InsuYearFlag='A' and $MainRisk/InsuYear=106">
				<InvaliDate>99991231</InvaliDate>
			</xsl:when>
			<xsl:otherwise>
				<InvaliDate><xsl:value-of select="$MainRisk/InsuEndDate" /></InvaliDate>
			</xsl:otherwise>
		</xsl:choose>	
		<!-- 续期缴费日期 -->
		<TermDate></TermDate>				
	</PolItem>
	<NoteList>
		
		<Count>4</Count>
		<NoteItem>
			<RowId>1</RowId>
			<xsl:choose>
				<xsl:when test="ContPlan/ContPlanCode=''">
					<xsl:variable name="RiskName" select="Risk[RiskCode=MainRiskCode]/RiskName" />
					<RowNote>　　您已购买由安邦人寿保险有限公司提供的“<xsl:value-of select="$RiskName" />”保险产品，并成功缴费，您的</RowNote>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="RiskName" select="ContPlan/ContPlanName" />
					<RowNote>　　您已购买由安邦人寿保险有限公司提供的“<xsl:value-of select="$RiskName" />”保险产品，并成功缴费，您的</RowNote>
				</xsl:otherwise>
			</xsl:choose>
			<Remark></Remark>
		</NoteItem>
		<NoteItem>
			<RowId>2</RowId>
			<RowNote>保险产品将在保险公司承保后予以生效，保单生效日为投保日的次日零时。您可于一个工作日后，凭保单号及身份证</RowNote>
			<Remark></Remark>
		</NoteItem>
		<NoteItem>
			<RowId>3</RowId>
			<RowNote>号码登陆安邦人寿官方网站http://www.anbang-life.com查询保单信息，并请登录http://www.ab95569.com下载电</RowNote>
			<Remark></Remark>
		</NoteItem>
		<NoteItem>
			<RowId>4</RowId>
			<RowNote>子保单。如有问题可致电安邦人寿的客服热线95569。</RowNote>
			<Remark></Remark>
		</NoteItem>
	</NoteList>
	<PrtList />
</Body>
</xsl:template>
</xsl:stylesheet>