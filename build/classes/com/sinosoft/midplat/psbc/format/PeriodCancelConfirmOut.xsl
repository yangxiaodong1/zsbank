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
		    <ATTACHMENTCOUNT>0</ATTACHMENTCOUNT>	
		    <!--批单内容(备用)-->
		    <ATTACHMENTDATA></ATTACHMENTDATA>
		    <PRT>
		       <PRT_NUM>1</PRT_NUM>
		       <PRTS>
		          <PRT_TYPE>1</PRT_TYPE>
		          <PRT_REC_NUM>1</PRT_REC_NUM>
		          <PRT_DETAIL>
                    <PRT_LINE><xsl:text>您好！您</xsl:text><xsl:value-of select="Body/PubContInfo/ContNo" /><xsl:text>号保单于</xsl:text><xsl:value-of  select="substring(Body/PubContInfo/TransExeDate,1,4)"/>年<xsl:value-of  select="substring(Body/PubContInfo/TransExeDate,6,2)"/>月<xsl:value-of  select="substring(Body/PubContInfo/TransExeDate,9,2)"/><xsl:text>日申请的犹豫期退保业务，已受理成功。</xsl:text></PRT_LINE>
                  </PRT_DETAIL>          
		        </PRTS>
		    </PRT>
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
		     <ATTACHMENTCOUNT>0</ATTACHMENTCOUNT>	
		     <!--批单内容(备用)-->
		     <ATTACHMENTDATA></ATTACHMENTDATA>
		     <PRT/>	
	     </xsl:if>
    </MAIN>
</RETURN>
</xsl:template>  
</xsl:stylesheet>