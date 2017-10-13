<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife> 		
			<xsl:copy-of select="TranData/Head" /><!-- icbcNetImpl类会根据这个head来解析返回节点 -->				
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
			<!-- 保单数据 -->
			 <Holding id="HLD_1">
				<Policy>
					<!--保单号-->
			 		<PolNumber><xsl:value-of select="PubContInfo/ContNo" /></PolNumber>					
				</Policy>
			</Holding>
		</OLifE>
		<OLifEExtension VendorCode="11">
			<TransNo>1001</TransNo>
			<!-- 交易代码 -->
		</OLifEExtension>	
	</xsl:template>
</xsl:stylesheet>
