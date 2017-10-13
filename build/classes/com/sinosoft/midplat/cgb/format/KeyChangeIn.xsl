<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="DESKEYNOTIFYREQ">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*" />
				<TranDate>
					<xsl:value-of select="TRANSRDATE" />
				</TranDate>
				<TranTime>
					<xsl:value-of select="TRANSRTIME" />
				</TranTime>
				<NodeNo>460101</NodeNo>
				<TellerNo>cgb</TellerNo>
				<TranNo>
					<xsl:value-of select="TRANSRNO" />
				</TranNo>
				<BankCode>
					<xsl:value-of select="Head/TranCom/@outcode" />
				</BankCode>
			</Head>

			<Body>
				<!-- 新密钥 -->
				<DesKey>
					<xsl:value-of select="DESKEY" />
				</DesKey>
			</Body>
		</TranData>
	</xsl:template>

</xsl:stylesheet>