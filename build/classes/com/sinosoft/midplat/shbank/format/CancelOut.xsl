<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<RETURN>
		    <xsl:if test="Head/Flag='0'">
		       <ACKSTS>0</ACKSTS>
		       <STSDESC>正常</STSDESC>
		       <BUSI>
                 <SUBJECT>2</SUBJECT>
                 <TRANS></TRANS>
                 <CONTENT>
                    <!-- 拒保原因代码,正常为0000 -->
                    <REJECT_CODE>0000</REJECT_CODE>
                    <!-- 拒保原因说明 -->
                    <REJECT_DESC>交易成功</REJECT_DESC>
                    <!-- 保险方流水号 -->
                    <INSU_TRANS></INSU_TRANS>
                    <!-- 保单号 -->
                    <APPNO></APPNO>
                 </CONTENT>
               </BUSI>		   
		    </xsl:if>
		    <xsl:if test="Head/Flag!='0'">
		       <ACKSTS>0</ACKSTS>
		       <STSDESC>正常</STSDESC>
		       <BUSI>
                 <SUBJECT>2</SUBJECT>
                 <TRANS></TRANS>
                 <CONTENT>
                    <!-- 拒保原因代码,正常为0000 -->
                    <REJECT_CODE>0001</REJECT_CODE>
                    <!-- 拒保原因说明 -->
                    <REJECT_DESC><xsl:value-of select="Head/Desc"/></REJECT_DESC>
		         </CONTENT>
		        </BUSI>	   
		    </xsl:if>		
		</RETURN>
	</xsl:template>
	
</xsl:stylesheet>