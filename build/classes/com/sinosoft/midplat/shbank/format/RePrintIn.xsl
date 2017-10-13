<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/REQUEST">
<TranData>
	<Head>
	    <!-- 交易日期 -->
	    <TranDate><xsl:value-of select="BUSI/TRSDATE"/></TranDate>
	    <!-- 交易时间 -->
        <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
        <!-- 柜员代码 -->
        <TellerNo><xsl:value-of select="DIST/TELLER"/></TellerNo>
        <!-- 交易流水号 -->
        <TranNo><xsl:value-of select="BUSI/TRANS"/></TranNo>
        <!-- 地区码+网点代码 -->
        <NodeNo>
             <xsl:value-of select="DIST/ZONE"/><xsl:value-of select="DIST/DEPT"/>
        </NodeNo>
   
     <xsl:copy-of select="Head/*"/>
        <!-- 交易单位 -->
        <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
    </Head>
	
	<Body>		
		<ContNo></ContNo> <!-- 保单号码  -->
		<ProposalPrtNo><xsl:value-of select="BUSI/CONTENT/APPNO"/></ProposalPrtNo> <!-- 投保单(印刷)号  -->
		<ContPrtNo><xsl:value-of select="BUSI/CONTENT/BILL_USED"/></ContPrtNo> <!-- 保单合同印刷号 -->
	</Body>
</TranData>
</xsl:template>

</xsl:stylesheet>
