<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<GetStartDate><xsl:value-of select="TranData/Body/GetStartDate"/></GetStartDate>
                <GetEndDate><xsl:value-of select="TranData/Body/GetEndDate"/></GetEndDate>
                <ProposalPrtNos></ProposalPrtNos>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>