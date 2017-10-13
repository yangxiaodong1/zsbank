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
					<!-- 成功时才返回  -->
					<xsl:call-template name="OLife" />
				</xsl:if>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLife">
		<OLife>
			<OLifeExtension>
				<!-- 告知列表  -->
				<TellInfos>
					<TellInfo>
						<!-- 文件名告知信息  -->
						<TellCode>001</TellCode>
						<!-- 告知编码：保单回传文件1 -->
						<xsl:variable name="today" select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()"/>
						<TellContent><xsl:value-of select="concat('BDZT141', $today, '01.txt')"/></TellContent>
						<!-- 告知内容 -->
					</TellInfo>
				</TellInfos>
			</OLifeExtension>
		</OLife>
	</xsl:template>


</xsl:stylesheet>
