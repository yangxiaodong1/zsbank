<?xml version="1.0" encoding="GBK"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

   <xsl:template match="/">
       <Transaction>
	      <xsl:copy-of select="TranData/Head" />
	      <Transaction_Body>
	         <xsl:if test="TranData/Head/Flag!='0'">
	             <!-- �������� -->
                 <PbInsuSlipNo></PbInsuSlipNo>
                 <!-- ���� -->
                 <PbInsuName></PbInsuName>
                 <!-- ֤������ -->
                 <LiRcgnIdType></LiRcgnIdType>
                 <!-- ֤������ -->
                 <LiRcgnId></LiRcgnId>
                 <!-- ������� -->
	             <PbInsuExp></PbInsuExp>
	             <!-- ���ɽ��� -->
	             <Pbmaxamt></Pbmaxamt>
	         </xsl:if>
	         <xsl:if test="TranData/Head/Flag='0'">
		        <xsl:apply-templates select="TranData/Body" />
		     </xsl:if>
	      </Transaction_Body>
	   </Transaction>
   </xsl:template>

   <xsl:template name="Transaction_Body" match="Body">
   
       <!-- �������� -->
       <PbInsuSlipNo></PbInsuSlipNo>
       <!-- ���� -->
       <PbInsuName></PbInsuName>
       <!-- ֤������ -->
       <LiRcgnIdType></LiRcgnIdType>
       <!-- ֤������ -->
       <LiRcgnId></LiRcgnId>
       <!-- ������� -->
	   <PbInsuExp><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></PbInsuExp>
	   <!-- ���ɽ��� -->
	   <xsl:if test="MaxLoanMoney = '0.0'">
	      <Pbmaxamt>0.00</Pbmaxamt>
	   </xsl:if>
	   <xsl:if test="MaxLoanMoney != ''">
	      <Pbmaxamt><xsl:value-of select ="format-number(MaxLoanMoney, '#.00')"/></Pbmaxamt>
	   </xsl:if>
	   <xsl:if test="MaxLoanMoney = ''">
	      <Pbmaxamt>0.00</Pbmaxamt>
	   </xsl:if>
   </xsl:template>
</xsl:stylesheet>
