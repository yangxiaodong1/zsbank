<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID>
					<xsl:value-of select="TranNo" />
				</TransRefGUID>
				<TransType>1018</TransType>
				<TransSubType>2</TransSubType>
				<TransExeDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" />
				</TransExeTime>

				<!-- չ�ַ��صĽ�� -->
				<xsl:apply-templates select="TranData/Body" />

				<!-- ԭʼ���״��� -->
				<OLifEExtension VendorCode="1">
					<TransNo><xsl:value-of select="OldTranNo" /></TransNo>
				</OLifEExtension>
			<!-- ƽ��ǰ����ˮ�� -->  
				<RcptId></RcptId>			
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLifE" match="Body">
		<OLifE>
			<!-- �������� -->
			<Holding id="Holding_1">
				<Policy>
					<!--������-->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>


				</Policy>
				
				<Arrangement>
					<ArrType tc="36" />
					<!-- Account Value Adjustment ���� -->
					<ArrDestination HoldingID="Acct_1" />
				</Arrangement>
				
			</Holding>
				<Holding id="Acct_1">
					<Banking>
					<!-- �����˺� -->
					<AccountNumber>
						<xsl:value-of select="//PubContInfo/BankAccNo" />
					</AccountNumber>
				
				</Banking>
				
			</Holding>	
			
			<!-- ��֤��Ϣ -->
			<FormInstance id="Form_1">
				<!-- ��֤���� -->
				<FormName>����</FormName>
				<!-- ������ -->
				<DocumentControlNumber>
					<xsl:value-of select="PubEdorConfirm/FormNumber"></xsl:value-of>
				</DocumentControlNumber>
				<!-- ������Ϣ�� -->
				<Attachment id="Attachment_Form_1">
					<Description>
						Document content attachment
					</Description>
					<!-- �������� -->
					<AttachmentData>content</AttachmentData>
					<AttachmentType tc="2147483647">
						Other
					</AttachmentType>
					<AttachmentLocation tc="1">
						In Line
					</AttachmentLocation>
				</Attachment>
			</FormInstance>
				<FormInstance id="Form_2">
				<!-- ��֤���� -->
				<FormName>�վ�</FormName>
				<!-- �վݺ� -->
				<DocumentControlNumber>
					<xsl:value-of select="PubEdorConfirm/FormNumber"></xsl:value-of>
				</DocumentControlNumber>
			</FormInstance>
		</OLifE>
	</xsl:template>

 
	<!-- �Ա� -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- �� -->
			<xsl:when test=".='1'">2</xsl:when><!-- Ů -->
			<xsl:when test=".='2'">3</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
