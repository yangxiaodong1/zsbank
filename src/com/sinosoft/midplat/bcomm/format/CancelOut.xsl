<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<RMBP>
			<xsl:copy-of select="TranData/Head" />

			<K_TrList>
				<!--保险分公司编码	Char(10)		可空-->
				<KR_BankCode />
				<!--投保书号			Char(35)		可空-->
				<KR_Idx></KR_Idx>
				<!--保单号			Char(35)		非空-->
				<KR_Idx1></KR_Idx1>
				<!--实际撤销金额		Dec(15,0)	非空-->
				<KR_Amt></KR_Amt>
			</K_TrList>
			<K_BI>
				<!--投保信息节点-->
				<Info>
					<!--私有节点-->
					<Private>
						<!--批单号			Char(35)		可空-->
						<InvNo></InvNo>
					</Private>
				</Info>
			</K_BI>
		</RMBP>
	</xsl:template>

</xsl:stylesheet>