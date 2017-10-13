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
	        <!--������-->
		    <RESULTCODE>0000</RESULTCODE>
		    <!--��������-->
		    <RESULTINFODESC>���׳ɹ�</RESULTINFODESC>
		    <!--��������-->
		    <POLNUMBER><xsl:value-of select="Body/PubContInfo/ContNo"/></POLNUMBER>
		    <!--����״̬-->
		    <POLICYSTATUS>1</POLICYSTATUS>
		    <!--��ȡ���/ʵ�˽��-->
		    <FINACTIVITYGROSSAMT><xsl:value-of select="Body/PubContInfo/FinActivityGrossAmt" /></FINACTIVITYGROSSAMT>	
		    <!--������ʽ(CD53)-->
		    <BENEFITMODE>3</BENEFITMODE>
		    <!--�ۼƺ���-->
		    <BONUSAMNT></BONUSAMNT>
	     </xsl:if>
	     <xsl:if test="Head/Flag !='0'">
	         <!--������-->
		     <RESULTCODE>0001</RESULTCODE>
		     <!--��������-->
		     <RESULTINFODESC><xsl:value-of select="Head/Desc"/></RESULTINFODESC>
		     <!--��������-->
		    <POLNUMBER></POLNUMBER>
		    <!--����״̬-->
		    <POLICYSTATUS></POLICYSTATUS>
		    <!--��ȡ���/ʵ�˽��-->
		    <FINACTIVITYGROSSAMT></FINACTIVITYGROSSAMT>	
		    <!--������ʽ(CD53)-->
		    <BENEFITMODE></BENEFITMODE>
		    <!--�ۼƺ���-->
		    <BONUSAMNT></BONUSAMNT>		
	     </xsl:if>
    </MAIN>
</RETURN>
</xsl:template>  
</xsl:stylesheet>