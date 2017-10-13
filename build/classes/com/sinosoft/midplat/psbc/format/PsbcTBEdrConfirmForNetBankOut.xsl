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
		    <RESULTINFODESC>交易成功</RESULTINFODESC>
		    <!--单证名称(CD55)(备用) --> 
		    <FORMNAME></FORMNAME>
		    <!--单证号码(备用)-->
		    <DOCUMENTCONTROLNUMBER></DOCUMENTCONTROLNUMBER>
		    <!--批单批文数量(备用)-->
		    <ATTACHMENTCOUNT></ATTACHMENTCOUNT>	
		    <!--批单内容(备用)-->
		    <ATTACHMENTDATA></ATTACHMENTDATA>
	     </xsl:if>
	     <xsl:if test="Head/Flag !='0'">
	         <!--错误码-->
		     <RESULTCODE>0001</RESULTCODE>
		     <!--错误描述-->
		     <RESULTINFODESC>保险公司返回：<xsl:value-of select="Head/Desc"/></RESULTINFODESC>
		     <!--单证名称(CD55)(备用) --> 
		     <FORMNAME></FORMNAME>
		     <!--单证号码(备用)-->
		     <DOCUMENTCONTROLNUMBER></DOCUMENTCONTROLNUMBER>
		     <!--批单批文数量(备用)-->
		     <ATTACHMENTCOUNT></ATTACHMENTCOUNT>	
		     <!--批单内容(备用)-->
		     <ATTACHMENTDATA></ATTACHMENTDATA>	
	     </xsl:if>
    </MAIN>
</RETURN>
</xsl:template>  
</xsl:stylesheet>