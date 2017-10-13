<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
			<SourceType>
				<xsl:apply-templates select="TX/TX_BODY/ENTITY/COM_ENTITY/TXN_ITT_CHNL_CGY_CODE" />
			</SourceType>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<!-- Ͷ������ -->
	<ProposalPrtNo><xsl:value-of select="Ins_BillNo" /></ProposalPrtNo>
	<!-- ������ -->
	<ContNo />
	<!-- ������ͬӡˢ�� -->
	<ContPrtNo />
	<AccName><xsl:value-of select="Plchd_Nm" /></AccName> <!-- ���ڱ����˻���-->
	<AccNo><xsl:value-of select="CCB_AccNo" /></AccNo> <!-- ���ڱ����˻���-->
	
	<!-- ���չ�˾��ˮ�� -->
	<OldLogNo><xsl:value-of select="Ins_Co_Jrnl_No"/></OldLogNo>
</xsl:template>
    <!-- ���б�����������: 10010003=��ҵ������10010001=����������10010002=˽�������������� 10030006���ֻ�����-->
	<xsl:template match="TXN_ITT_CHNL_CGY_CODE">
		<xsl:choose>
			<xsl:when test=".='10010003'">1</xsl:when><!-- ��ҵ����:���� -->
			<xsl:when test=".='10010001'">1</xsl:when><!-- ��������:���� -->
			<xsl:when test=".='10010002'">1</xsl:when><!-- ˽��������������:���� -->
			<xsl:when test=".='10030006'">17</xsl:when><!-- �ֻ����� -->
			<xsl:when test=".='10110109'">8</xsl:when><!-- �����ն� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
