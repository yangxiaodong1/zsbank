<?xml version="1.0" encoding="GBK"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

   <xsl:template match="/">
       <TranData>
	      <xsl:copy-of select="TranData/Head" />
	      <Body>
	         <xsl:if test="TranData/Head/Flag!='0'">
	             <!-- �������� -->
                 <ContNo></ContNo>
                 <!-- ���� -->
                 <AppntName></AppntName>
                 <!-- ֤������ -->
                 <AppntIDType></AppntIDType>
                 <!-- ֤������ -->
                 <AppntIDNo></AppntIDNo>
                 <!-- ������� -->
	             <ActSumPrem></ActSumPrem>
	             <!-- ���ɽ��� -->
	             <MaxLoanMoney></MaxLoanMoney>
	             <!-- ������Ч�� -->
	             <POLICYSTARTDATE></POLICYSTARTDATE>
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
   
       <!-- �������� -->
       <ContNo><xsl:value-of select="ContNo" /></ContNo>
       <!-- ���� -->
       <AppntName><xsl:value-of select="Appnt/Name" /></AppntName>
       <!-- ֤������ -->
       <AppntIDType><xsl:apply-templates select="Appnt/IDType" /></AppntIDType>
       <!-- ֤������ -->
       <AppntIDNo><xsl:value-of select="Appnt/IDNo" /></AppntIDNo>
       <!-- ������� -->
	   <!-- <ActSumPrem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></ActSumPrem> -->
	   <ActSumPrem><xsl:value-of select="ActSumPrem" /></ActSumPrem>
	   <!-- ���ɽ��� -->
	   <!-- 
	   <xsl:if test="MaxLoanMoney='0.0'">
	      <MaxLoanMoney>0.00</MaxLoanMoney>
	   </xsl:if>
	   <xsl:if test="MaxLoanMoney!=''">
	      <MaxLoanMoney><xsl:value-of select ="format-number(MaxLoanMoney, '#.00')"/></MaxLoanMoney>
	   </xsl:if>
	   <xsl:if test="MaxLoanMoney=''">
	      <MaxLoanMoney>0.00</MaxLoanMoney>
	   </xsl:if>
	    -->
	    <xsl:choose>
	    	<xsl:when test="MaxLoanMoney='0.0'">
	    		<MaxLoanMoney>0</MaxLoanMoney>
	    	</xsl:when>
	    	<xsl:when test="MaxLoanMoney='-1.0'">
	    		<MaxLoanMoney>0</MaxLoanMoney>
	    	</xsl:when>
	    	<xsl:when test="MaxLoanMoney!=''">
	    		<MaxLoanMoney><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(MaxLoanMoney)" /></MaxLoanMoney>
	    	</xsl:when>
	    	<xsl:when test="MaxLoanMoney=''">
	    		<MaxLoanMoney>0</MaxLoanMoney>
	    	</xsl:when>
	    	<xsl:otherwise>
	    		<MaxLoanMoney>0</MaxLoanMoney>
	    	</xsl:otherwise>
	    </xsl:choose>
	   <POLICYSTARTDATE><xsl:value-of select="Risk[RiskCode=MainRiskCode]/CValiDate" /></POLICYSTARTDATE>
	   <NOTE1></NOTE1>
	   <NOTE2></NOTE2>
	   <NOTE3></NOTE3>
	   <NOTE4></NOTE4>
	   <NOTE5></NOTE5>
   </xsl:template>
   
   <!-- ֤������ -->
   <!-- �㷢��1 ���֤��2 ����֤��3 ���գ�4 ����֤��5 ���� -->
   <!-- ���ģ�0	�������֤,1 ����,2 ����֤,3 ����,4 ����֤��,5	���ڲ�,8	����,9	�쳣���֤ -->
   <xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- ���֤ -->
			<xsl:when test=".='2'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='1'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='4'">4</xsl:when><!-- ����֤ -->
			<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>
   
</xsl:stylesheet>