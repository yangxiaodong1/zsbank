<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife> 		
			<xsl:copy-of select="TranData/Head" /><!-- icbcNetImpl���������head���������ؽڵ� -->				
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
			<!-- �������� -->
			 <Holding id="HLD_1">
				<Policy>
					<!--������-->
			 		<PolNumber><xsl:value-of select="PubContInfo/ContNo" /></PolNumber>					
				</Policy>
			</Holding>
		</OLifE>
		<OLifEExtension VendorCode="11">
			<TransNo>1001</TransNo>
			<!-- ���״��� -->
		</OLifEExtension>	
	</xsl:template>
</xsl:stylesheet>