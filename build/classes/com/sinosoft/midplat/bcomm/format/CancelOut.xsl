<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<RMBP>
			<xsl:copy-of select="TranData/Head" />

			<K_TrList>
				<!--���շֹ�˾����	Char(10)		�ɿ�-->
				<KR_BankCode />
				<!--Ͷ�����			Char(35)		�ɿ�-->
				<KR_Idx></KR_Idx>
				<!--������			Char(35)		�ǿ�-->
				<KR_Idx1></KR_Idx1>
				<!--ʵ�ʳ������		Dec(15,0)	�ǿ�-->
				<KR_Amt></KR_Amt>
			</K_TrList>
			<K_BI>
				<!--Ͷ����Ϣ�ڵ�-->
				<Info>
					<!--˽�нڵ�-->
					<Private>
						<!--������			Char(35)		�ɿ�-->
						<InvNo></InvNo>
					</Private>
				</Info>
			</K_BI>
		</RMBP>
	</xsl:template>

</xsl:stylesheet>