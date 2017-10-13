<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

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
			</TXLifeResponse>
</TXLife>
</xsl:template>

<xsl:template name="OLifE" match="Body">		
		<OLifE>
			<FormInstance id="Form_1">
				<!-- 单证名称 -->
				<FormName>3</FormName>
				<!-- 批单号 -->
				<DocumentControlNumber>123456123</DocumentControlNumber>
				<!-- 批文（可重复） -->
				<Attachment id="Attachment_1">
					<!-- 批文内容1（第一行） -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
				<Attachment id="Attachment_2">
					<!-- 批文内容2（第二行） -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
				<Attachment id="Attachment_3">
					<!-- 批文内容3（第三行） -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
			</FormInstance>
		</OLifE>
		<OLifEExtension VendorCode="1">
			<TransNo></TransNo>
			<!-- 交易代码 -->
			<RcptId></RcptId>
			<!-- 平保前置流水号 -->
		</OLifEExtension>
	</xsl:template>
</xsl:stylesheet>