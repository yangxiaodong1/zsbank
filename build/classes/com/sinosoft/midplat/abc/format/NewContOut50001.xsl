<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">
	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
	  <Ret>
	  	<RetData>
	  		<Flag>
	  		  <xsl:if test="Head/Flag='0'">1</xsl:if>
	  		  <xsl:if test="Head/Flag='1'">0</xsl:if>
	  		</Flag>
	  		<Mesg><xsl:value-of select ="Head/Desc"/></Mesg>
	  	</RetData>
		<!-- 如果交易成功，才返回下面的结点 -->
	   <xsl:if test="Head/Flag='0'">
			<Base>
				<ProposalContNo><xsl:value-of select ="Body/ProposalPrtNo"/></ProposalContNo>
				<Prem><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)"/></Prem>
                <ReqsrNo></ReqsrNo>
			</Base>
		</xsl:if> <!-- 如果交易成功，才返回上面的结点 -->
	  </Ret>
	</xsl:template>
</xsl:stylesheet>