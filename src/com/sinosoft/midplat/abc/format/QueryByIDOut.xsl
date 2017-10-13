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
	  	<xsl:if test="Head/Flag='0'">
	  	 <Base>
	  	   <Num><xsl:value-of select="count(Body/Cont)"/></Num>
	  	   <xsl:for-each select="Body/Cont">
	  	   <Policy>
	  	     <ProposalContNo><xsl:value-of select="ContNo"/></ProposalContNo>
             <Status1><xsl:value-of select="Status1"/></Status1>
             <RiskCode><xsl:value-of select="RiskCode"/></RiskCode>
             <Status2><xsl:value-of select="Status2"/></Status2>
	  	 </Policy>
	  	 </xsl:for-each>
	  	 </Base>
	  	</xsl:if>
	  </Ret>
	</xsl:template>
</xsl:stylesheet>