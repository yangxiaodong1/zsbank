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
		    <!--��֤����(CD55)(����) --> 
		    <FORMNAME></FORMNAME>
		    <!--��֤����(����)-->
		    <DOCUMENTCONTROLNUMBER></DOCUMENTCONTROLNUMBER>
		    <!--������������(����)-->
		    <ATTACHMENTCOUNT>0</ATTACHMENTCOUNT>	
		    <!--��������(����)-->
		    <ATTACHMENTDATA></ATTACHMENTDATA>
		    <PRT>
		       <PRT_NUM>1</PRT_NUM>
		       <PRTS>
		          <PRT_TYPE>1</PRT_TYPE>
		          <PRT_REC_NUM>1</PRT_REC_NUM>
		          <PRT_DETAIL>
                    <PRT_LINE><xsl:text>���ã���</xsl:text><xsl:value-of select="Body/PubContInfo/ContNo" /><xsl:text>�ű�����</xsl:text><xsl:value-of  select="substring(Body/PubContInfo/TransExeDate,1,4)"/>��<xsl:value-of  select="substring(Body/PubContInfo/TransExeDate,6,2)"/>��<xsl:value-of  select="substring(Body/PubContInfo/TransExeDate,9,2)"/><xsl:text>���������ԥ���˱�ҵ��������ɹ���</xsl:text></PRT_LINE>
                  </PRT_DETAIL>          
		        </PRTS>
		    </PRT>
	     </xsl:if>
	     <xsl:if test="Head/Flag !='0'">
	         <!--������-->
		     <RESULTCODE>0001</RESULTCODE>
		     <!--��������-->
		     <RESULTINFODESC>���չ�˾���أ�<xsl:value-of select="Head/Desc"/></RESULTINFODESC>
		     <!--��֤����(CD55)(����) --> 
		     <FORMNAME></FORMNAME>
		     <!--��֤����(����)-->
		     <DOCUMENTCONTROLNUMBER></DOCUMENTCONTROLNUMBER>
		     <!--������������(����)-->
		     <ATTACHMENTCOUNT>0</ATTACHMENTCOUNT>	
		     <!--��������(����)-->
		     <ATTACHMENTDATA></ATTACHMENTDATA>
		     <PRT/>	
	     </xsl:if>
    </MAIN>
</RETURN>
</xsl:template>  
</xsl:stylesheet>