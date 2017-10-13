<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="Head" />
			<!-- ������ -->
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Transaction_Body" match="Body">
		<MAIN>
			<TRANSRNO></TRANSRNO><!-- ������ˮ�� -->
			<TRANSRDATE></TRANSRDATE><!-- �������� -->
			<INSUID></INSUID><!-- ���չ�˾���� -->
		 	<!--Ͷ������-->
		 	<APPLNO>
		 		<xsl:value-of select="ProposalPrtNo" />
		 	</APPLNO>
		 	<!--Ͷ������-->
		 	<ACCEPT_DATE>
		 		<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
		 	</ACCEPT_DATE>
		 	<!-- Ͷ�����뽻����ˮ�� -->
		 	<REQSRNO></REQSRNO>
		 	<!-- ���յ���  -->
		 	<POLICYNO><xsl:value-of select="ContNo" /></POLICYNO>
		 	<!-- �������ص�ַ -->
		 	<POLICYADDR></POLICYADDR>
		 </MAIN>
	
	</xsl:template>
 
</xsl:stylesheet>
