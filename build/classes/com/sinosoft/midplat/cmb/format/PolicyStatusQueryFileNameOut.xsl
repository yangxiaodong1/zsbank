<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<xsl:if test="TranData/Head/Flag='0'">
					<!-- �ɹ�ʱ�ŷ���  -->
					<xsl:call-template name="OLife" />
				</xsl:if>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLife">
		<OLife>
			<OLifeExtension>
				<!-- ��֪�б�  -->
				<TellInfos>
					<TellInfo>
						<!-- �ļ�����֪��Ϣ  -->
						<TellCode>001</TellCode>
						<!-- ��֪���룺�����ش��ļ�1 -->
						<xsl:variable name="today" select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()"/>
						<TellContent><xsl:value-of select="concat('BDZT141', $today, '01.txt')"/></TellContent>
						<!-- ��֪���� -->
					</TellInfo>
				</TellInfos>
			</OLifeExtension>
		</OLife>
	</xsl:template>


</xsl:stylesheet>
