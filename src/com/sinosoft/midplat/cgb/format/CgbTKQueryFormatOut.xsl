<?xml version="1.0" encoding="GBK"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

   <xsl:template match="/">
       <TranData>
	      <xsl:copy-of select="TranData/Head" />
	      <Body>
	         <xsl:if test="TranData/Head/Flag!='0'">
	             <!-- 保单号码 -->
                 <ContNo></ContNo>
                 <!-- 姓名 -->
                 <AppntName></AppntName>
                 <!-- 证件类型 -->
                 <AppntIDType></AppntIDType>
                 <!-- 证件号码 -->
                 <AppntIDNo></AppntIDNo>
                 <!-- 保单金额 -->
	             <ActSumPrem></ActSumPrem>
	             <!-- 最大可借金额 -->
	             <MaxLoanMoney></MaxLoanMoney>
	             <!-- 保单生效日 -->
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
   
       <!-- 保单号码 -->
       <ContNo><xsl:value-of select="ContNo" /></ContNo>
       <!-- 姓名 -->
       <AppntName><xsl:value-of select="Appnt/Name" /></AppntName>
       <!-- 证件类型 -->
       <AppntIDType><xsl:apply-templates select="Appnt/IDType" /></AppntIDType>
       <!-- 证件号码 -->
       <AppntIDNo><xsl:value-of select="Appnt/IDNo" /></AppntIDNo>
       <!-- 保单金额 -->
	   <!-- <ActSumPrem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></ActSumPrem> -->
	   <ActSumPrem><xsl:value-of select="ActSumPrem" /></ActSumPrem>
	   <!-- 最大可借金额 -->
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
   
   <!-- 证件类型 -->
   <!-- 广发：1 身份证，2 军人证，3 护照，4 出生证，5 其它 -->
   <!-- 核心：0	居民身份证,1 护照,2 军官证,3 驾照,4 出生证明,5	户口簿,8	其他,9	异常身份证 -->
   <xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 身份证 -->
			<xsl:when test=".='2'">2</xsl:when><!-- 军官证 -->
			<xsl:when test=".='1'">3</xsl:when><!-- 护照 -->
			<xsl:when test=".='4'">4</xsl:when><!-- 出生证 -->
			<xsl:otherwise>8</xsl:otherwise><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
   
</xsl:stylesheet>