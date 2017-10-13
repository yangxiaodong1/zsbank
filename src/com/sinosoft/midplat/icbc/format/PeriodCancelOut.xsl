<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID />
				<TransType>1004</TransType>
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
	<xsl:template name="OLifE" match="TranData/Body">
		<OLifE>
			<FormInstance id="Form_1">
				<FormName>3</FormName>
				<DocumentControlNumber>
					<xsl:value-of select="CertifyCode" />
				</DocumentControlNumber>
				<Attachment id="Attachment_1">
					<AttachmentData>

					</AttachmentData>
				</Attachment>
				<Attachment id="Attachment_2">
					<AttachmentData>
										��<xsl:value-of select="AppntName" />���룬�ҹ�˾���ͬ�⣬��<xsl:value-of select="ContNo" />�ű�����������ע��
					     </AttachmentData>
				</Attachment>
				<Attachment id="Attachment_3">
					<AttachmentData>
						         �����Ŀ�������ͬ
					     </AttachmentData>
				</Attachment>
				<Attachment id="Attachment_4">
					<AttachmentData>
						        ������ݣ�
					     </AttachmentData>
				</Attachment>
				<Attachment id="Attachment_5">
					<AttachmentData><xsl:text>�������������������ơ���������                 ��������                             Ӧ�˽��</xsl:text>
				    </AttachmentData>
				</Attachment>
					<Attachment id="Attachment_6">
					<xsl:apply-templates select="Risk" />
				</Attachment>
				<Attachment id="Attachment_7">
					<AttachmentData>
						<BkDetail1>
							<xsl:text>������������ʵ�˽�����������</xsl:text>
							<xsl:value-of select="GetMoney" />
						</BkDetail1>
					</AttachmentData>
				</Attachment>
			</FormInstance>
		</OLifE>
	</xsl:template>
	<!-- ������Ϣ -->
	<xsl:template name="AttachmentData" match="Risk">
		<AttachmentData>
		<xsl:if test="MainRiskIndicator = '1'">
		    <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 48)"/>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 37)"/>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Prem,10)"/>
		</xsl:if>
		<xsl:if test="MainRiskIndicator = '0'">
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 48)"/>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('������', 37)"/>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Prem,10)"/>
		</xsl:if>
	</AttachmentData>
	</xsl:template>
</xsl:stylesheet>
