<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<Body>
				<!--汇总信息-->
				<Detail>
					<!--公司代码-->
					<Column>0032</Column>
					<!--银行代码-->
					<Column>17</Column>
					<!--总笔数-->
					<Column>
						<xsl:value-of select="count(TranData/Body/Detail)" />
					</Column>
					<!--总金额-->
					<Column>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(TranData/Body/Detail/ActPrem))" />
					</Column>
				</Detail>
				<xsl:for-each select="TranData/Body/Detail">
					<Detail>
						<!--产品代码-->
						<Column>
							<xsl:call-template name="tran_RiskCode">
								<xsl:with-param name="riskCode">
									<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskCode" />
								</xsl:with-param>
							</xsl:call-template>
						</Column>
						<!--投保单号-->
						<Column>
							<xsl:value-of select="ProposalPrtNo" />
						</Column>
						<!--投保人证件号码-->
						<Column>
							<xsl:value-of select="Appnt/IDNo" />
						</Column>
						<!--生效日期-->
						<Column>
							<xsl:value-of select="ValiDate" />
						</Column>
						<!--保单状态-->
						<Column>
							<xsl:value-of select="ContState" />
						</Column>
						<!--核保信息-->
						<Column>
							<xsl:value-of select="UWReasonContent" />
						</Column>
						<!--保单号-->
						<Column>
							<xsl:value-of select="ContNo" />
						</Column>
						<!--保险费用-->
						<Column>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
						</Column>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<xsl:when test="$riskCode='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
			<!-- 过度期，会有险种编码并存的情况。 -->
			<xsl:when test="$riskCode='122010'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskCode='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskCode='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskCode='122036'">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款 -->
			<!-- 50002变为50015，因银行编码没变，且核心的主线代码没有变化，所以此次不用修改。 -->
			<xsl:when test="$riskCode='122046'">50002</xsl:when><!-- 安邦长寿稳赢保险组合计划 -->
			
			<xsl:when test="$riskCode='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型） -->
			<xsl:when test="$riskCode='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型） -->
			<xsl:when test="$riskCode='L12088'">L12088</xsl:when><!-- 安邦东风9号两全保险（万能型） -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
