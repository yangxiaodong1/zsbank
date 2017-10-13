<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<xsl:copy-of select="Head" />

			<Body>
				<!-- ������ -->
				<ContNo></ContNo>
				<!-- ���չ�˾�������� -->
				<EdorAppDate><xsl:value-of select="Body/EdorAppDate" /></EdorAppDate>
				<!-- �����,���Ľ��ĵ�λ�Ƿ֣����еĽ�λ��Ԫ -->
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
