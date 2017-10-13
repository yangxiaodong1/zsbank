<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<xsl:if test="TranData/Head/Flag='0'">
					<xsl:apply-templates select="TranData/Body" />
				</xsl:if>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLife" match="Body">
		<OLife>
			<Holding id="Holding_1">
				<!-- 保单信息 -->
				<Policy>
					<!-- 保单号ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!-- 保单状态 -->
					<PolicyStatus><xsl:apply-templates select="ContState" /></PolicyStatus>
					<!-- 当前保单价值（13位整数2位小数，数字类型，不能为空） -->
					<PolicyValue><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueD)" /></PolicyValue>
					<Life>
						<!-- 万能险必须返回，投连险不必须返回 -->
						<xsl:choose>
							<xsl:when test="Life/CurrIntRate!=''">
								<xsl:variable name="Rate" select="number(Life/CurrIntRate)" />
								<CurrIntRate><xsl:value-of select="format-number($Rate*100, '#.0000')" /></CurrIntRate>
							</xsl:when>
							<xsl:otherwise>
								<CurrIntRate>0</CurrIntRate>
							</xsl:otherwise>
						</xsl:choose>
						<!-- 当前结算利率（单位，万分之，小数点后四位） -->
						<xsl:choose>
							<xsl:when test="Life/CurrIntRateDate!=''">
								<CurrIntRateDate><xsl:apply-templates select="Life/CurrIntRateDate" /></CurrIntRateDate>
							</xsl:when>
							<xsl:otherwise>
								<CurrIntRateDate>0</CurrIntRateDate>
							</xsl:otherwise>
						</xsl:choose>
						<!-- 利率开始日期 （8位数字格式YYYYMMDD，不能为空）-->
					</Life>
					<!-- 投连险必须返回，万能险不必须返回 -->
					<!-- <Investment></Investment>  -->
				</Policy>
			</Holding>
		</OLife>
	</xsl:template>

	<!-- 保单状态 -->
	<!-- 招行状态保单状态A:正常；C:退保；R:拒保；S:犹豫期撤单；F：满期给付；L：失效；J：理赔  -->
	<!-- 核心状态：00:保单有效,01:满期终止,02:退保终止,04:理赔终止,WT:犹豫期退保终止,A:拒保,B:待签单,C:失效 -->
	<xsl:template name="tran_contstate" match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">A</xsl:when>
			<xsl:when test=".='01'">F</xsl:when>
			<xsl:when test=".='02'">C</xsl:when>
			<xsl:when test=".='04'">J</xsl:when>
			<xsl:when test=".='WT'">S</xsl:when>
			<xsl:when test=".='A'">R</xsl:when>
			<xsl:when test=".='C'">L</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
