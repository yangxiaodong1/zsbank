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
		    <!--保单号码-->
		    <POLNUMBER><xsl:value-of select="Body/PubContInfo/ContNo"/></POLNUMBER>
		    <!--保单状态-->
		    <POLICYSTATUS>1</POLICYSTATUS>
		    <!--领取金额/实退金额-->
		    <FINACTIVITYGROSSAMT><xsl:value-of select="Body/PubContInfo/FinActivityGrossAmt" /></FINACTIVITYGROSSAMT>	
		    <!--给付方式(CD53)-->
		    <BENEFITMODE>3</BENEFITMODE>
		    <!--累计红利-->
		    <BONUSAMNT></BONUSAMNT>
	     </xsl:if>
	     <xsl:if test="Head/Flag !='0'">
	         <!--错误码-->
		     <RESULTCODE>0001</RESULTCODE>
		     <!--错误描述-->
		     <RESULTINFODESC><xsl:value-of select="Head/Desc"/></RESULTINFODESC>
		     <!--保单号码-->
		    <POLNUMBER></POLNUMBER>
		    <!--保单状态-->
		    <POLICYSTATUS></POLICYSTATUS>
		    <!--领取金额/实退金额-->
		    <FINACTIVITYGROSSAMT></FINACTIVITYGROSSAMT>	
		    <!--给付方式(CD53)-->
		    <BENEFITMODE></BENEFITMODE>
		    <!--累计红利-->
		    <BONUSAMNT></BONUSAMNT>		
	     </xsl:if>
    </MAIN>
</RETURN>
</xsl:template>  
</xsl:stylesheet>