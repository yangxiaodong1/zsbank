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
				<!-- չ�ַ��صĽ�� -->
				<xsl:apply-templates select="TranData/Body"/>
			</TXLifeResponse>
</TXLife>
</xsl:template>

<xsl:template name="OLifE" match="Body">		
		<OLifE>
			<FormInstance id="Form_1">
				<!-- ��֤���� -->
				<FormName>3</FormName>
				<!-- ������ -->
				<DocumentControlNumber>123456123</DocumentControlNumber>
				<!-- ���ģ����ظ��� -->
				<Attachment id="Attachment_1">
					<!-- ��������1����һ�У� -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
				<Attachment id="Attachment_2">
					<!-- ��������2���ڶ��У� -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
				<Attachment id="Attachment_3">
					<!-- ��������3�������У� -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
			</FormInstance>
		</OLifE>
		<OLifEExtension VendorCode="1">
			<TransNo></TransNo>
			<!-- ���״��� -->
			<RcptId></RcptId>
			<!-- ƽ��ǰ����ˮ�� -->
		</OLifEExtension>
	</xsl:template>
</xsl:stylesheet>