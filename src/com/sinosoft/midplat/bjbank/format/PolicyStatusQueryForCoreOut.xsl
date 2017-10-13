<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
    
	<xsl:template match="/">
	   <TranDatas>
	      <!--<PolCount></PolCount>-->
	      <!--<FileName></FileName>-->
	      <AllNum><xsl:value-of select="count(TranData/Body/Detail)" /></AllNum>
          <xsl:apply-templates select="TranData/Body/Detail" />
       </TranDatas>
	</xsl:template>
    
    <!-- 文件的一条记录 -->
	<xsl:template match="Detail">
	   <TranData>
	        <ContNo><xsl:value-of select="ContNo" /></ContNo>
	        <ProposalContNo><xsl:value-of select="ProposalPrtNo" /></ProposalContNo>
	        <GetSurrDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(EdorCTDate)" /></GetSurrDate>
	   </TranData>
	</xsl:template>

</xsl:stylesheet>
