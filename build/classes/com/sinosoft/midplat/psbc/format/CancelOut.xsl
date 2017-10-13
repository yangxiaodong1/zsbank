<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	<xsl:apply-templates select="TranData"/>
</xsl:template>

<xsl:template match="TranData">
<RETURN>
    <MAIN>
	    <xsl:if test="Head/Flag='0'">
	        <!--错误码-->
		    <RESULTCODE>0000</RESULTCODE>
		    <!--错误描述-->
		    <ERR_INFO>交易成功</ERR_INFO>		
	     </xsl:if>
	     <xsl:if test="Head/Flag !='0'">
	         <!--错误码-->
		     <RESULTCODE>0001</RESULTCODE>
		     <!--错误描述-->
		     <ERR_INFO>
			     <xsl:value-of select="Head/Desc"/>
		     </ERR_INFO>		
	     </xsl:if>
    </MAIN>
</RETURN>
</xsl:template>  
</xsl:stylesheet>