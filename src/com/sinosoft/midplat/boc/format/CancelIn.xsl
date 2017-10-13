<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
	<xsl:output indent="yes"/>
	
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
		    <TranDate><xsl:value-of select="TranDate"/></TranDate><!-- ��������[yyyyMMdd] -->
            <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TranTime)" /></TranTime><!-- ����ʱ��[hhmmss] -->            <TranCom outcode="08"><xsl:value-of select="TranCom"/></TranCom><!-- ���׵�λ(����/ũ����/������˾) -->            
            <NodeNo><xsl:value-of select="ZoneNo"/><xsl:value-of select="NodeNo"/></NodeNo><!-- �������� +�������� -->
            <TellerNo><xsl:value-of select="TellerNo"/></TellerNo><!-- ��Ա���� -->
            <TranNo><xsl:value-of select="TranNo"/></TranNo><!-- ������ˮ�� -->
            <FuncFlag><xsl:value-of select="FuncFlag"/></FuncFlag><!-- �������� -->
			<BankCode><xsl:value-of select="TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<ContNo>
				<xsl:value-of select="ContNo"/>
			</ContNo>
			<!-- ������ -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo"/>
			</ProposalPrtNo>
			<!-- Ͷ����(ӡˢ)�� -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo"/>
			</ContPrtNo>
			<!-- ������ͬӡˢ�� -->
		</Body>
	</xsl:template>
</xsl:stylesheet>
