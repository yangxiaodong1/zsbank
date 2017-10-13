<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<Rsp>			
			<xsl:apply-templates select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</Rsp>
	</xsl:template>
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0表示成功，1表示失败 -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- 失败时，返回错误信息 -->
		</Head>
	</xsl:template>
	<xsl:template name="Body" match="Body">
	 <Body>
		 <PolItem>
		 	<!-- 保单号 -->
			<PolNo><xsl:value-of select="PubContInfo/ContNo" /></PolNo>
			<!-- 批单号 -->
			<EdmNo><xsl:value-of select="PubEdorConfirm/FormNumber" /></EdmNo>
			<!-- 批单生效日期 -->
			<InvValiDate>
				<xsl:value-of
					select="PubContInfo/EdorValidDate" />
			</InvValiDate>
			<!-- 退款金额 -->
			<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></PayAmt>
			<!-- 保单状态 -->
			<PolStat>3</PolStat>
		 </PolItem>
		 <!-- 格式化的打印信息 -->
		<PrtList />	
      </Body>
	</xsl:template>
</xsl:stylesheet>