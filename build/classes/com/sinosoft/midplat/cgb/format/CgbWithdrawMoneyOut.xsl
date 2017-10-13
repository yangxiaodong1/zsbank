<?xml version="1.0" encoding="GBK"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

   <xsl:template match="/">
       <TranData>
	      <xsl:copy-of select="TranData/Head" />
	      <Body>
	         <xsl:if test="TranData/Head/Flag!='0'">
	             <!-- �����Ч�� -->
                 <EdorValidDate></EdorValidDate>
                 <!-- ������ -->
                 <EdorNo></EdorNo>
                 <!-- ������λ�Ƿ� -->
                 <LoanMoney></LoanMoney>
                 <NOTE1></NOTE1>
	             <NOTE2></NOTE2>
	             <NOTE3></NOTE3>
	             <NOTE4></NOTE4>
	             <NOTE5></NOTE5>
	         </xsl:if>
	         <xsl:if test="TranData/Head/Flag='0'">
		        <xsl:apply-templates select="TranData/Body" />
		     </xsl:if>
	      </Body>
	   </TranData>
   </xsl:template>

   <xsl:template name="Transaction_Body" match="Body"> 
       <!-- �����Ч�� -->
       <EdorValidDate><xsl:value-of select="PubContInfo/EdorValidDate" /></EdorValidDate>
       <!-- ������ -->
       <EdorNo><xsl:value-of select="Body/PubEdorConfirm/FormNumber" /></EdorNo>
       <!-- ������λ�Ƿ� -->
       <LoanMoney><xsl:value-of select="Body/PubContInfo/FinActivityGrossAmt" /></LoanMoney>
       <NOTE1></NOTE1>
	   <NOTE2></NOTE2>
	   <NOTE3></NOTE3>
	   <NOTE4></NOTE4>
	   <NOTE5></NOTE5>
   </xsl:template>
</xsl:stylesheet>