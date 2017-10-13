<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<xsl:copy-of select="Head" />

			<Body>
				<!-- 保单号 -->
				<ContNo></ContNo>
				<!-- 保险公司交易日期 -->
				<EdorAppDate><xsl:value-of select="Body/EdorAppDate" /></EdorAppDate>
				<!-- 提款金额,核心金额的单位是分，银行的金额单位是元 -->
				<LoanMoney><xsl:value-of select="Body/TranMoney" /></LoanMoney>	
				<NOTE1></NOTE1>
	            <NOTE2></NOTE2>
	            <NOTE3></NOTE3>
	            <NOTE4></NOTE4>
	            <NOTE5></NOTE5>			
			</Body>
		</TranData>
	</xsl:template>

</xsl:stylesheet>
