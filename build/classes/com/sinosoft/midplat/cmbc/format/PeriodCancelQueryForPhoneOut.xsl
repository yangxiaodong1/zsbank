<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	<xsl:apply-templates select="TranData"/>
</xsl:template>

<xsl:template match="TranData">
<RETURN>
    <xsl:copy-of select="Head" />
    <MAIN>
	     <xsl:if test="Head/Flag='0'">        
	        <!--���չ�˾����-->
	        <COMP_CODE></COMP_CODE>
		    <!--������ --> 
		    <POLICY_NO><xsl:value-of select="Body/PubContInfo/ContNo"/></POLICY_NO>
		    <!--����״̬-->
		    <POLICY_STATUS>P</POLICY_STATUS>
		    <!--�˱����-->
		    <INIT_PREM_AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/PubContInfo/FinActivityGrossAmt)" /></INIT_PREM_AMT>	
	     </xsl:if>
	     <xsl:if test="Head/Flag !='0'">	       
	        <!--���չ�˾����-->
	        <COMP_CODE></COMP_CODE>
		    <!--������ --> 
		    <POLICY_NO></POLICY_NO>
		    <!--����״̬-->
		    <POLICY_STATUS></POLICY_STATUS>
		    <!--�˱����-->
		    <INIT_PREM_AMT></INIT_PREM_AMT>	
	     </xsl:if>
    </MAIN>
</RETURN>
</xsl:template>  
</xsl:stylesheet>