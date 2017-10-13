<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="TranData/Head" />
			<!-- ������ -->
			<xsl:apply-templates select="TranData/Body" />
			
		</TranData>
	</xsl:template>

	<!-- ������ -->
	<xsl:template match="Body">
		<Body>
			<Detail>
				<!--���չ�˾����-->
				<Column>0026</Column>
				<!--���д���-->
				<Column>0501</Column>
				<!--�ܼ�¼��-->
                <Column><xsl:value-of select="count(DetailList/Detail)" /></Column>
                <!--�ܽ��-->
                <Column><xsl:value-of select="Amount" /></Column>
                <!--����ժҪ-->
                <Column></Column>
             </Detail>
             
             <xsl:apply-templates select="Detail" />
             </Body>
             </xsl:template>
             
    <!--Detail��ת��  -->
	<xsl:template match="Detail">
		<Detail>
			<!--��������-->
			<Column></Column>
		    <!--��ϸ˳���-->
			<Column><xsl:value-of select="DetailSerialNo" /></Column>
			<!--�ͻ��˺�-->
			<Column><xsl:value-of select="AccNo" /></Column>
			<!-- �ͻ�����-->
			<Column><xsl:value-of select="AccName" /></Column>
			<!-- ֤������-->
			<Column><xsl:value-of select="IDType" /></Column>
			<!--֤������-->
			<Column><xsl:value-of select="IDNo" /></Column>
			<!--������-->
			<Column><xsl:value-of select="ContNo" /></Column>
			<!--�˻�ʡ�д���-->
			<Column></Column>
			<!--����-->
			<Column>01</Column>
			<!--���׽��-->
			<Column><xsl:value-of select="Amount" /></Column>
	    </Detail>

    </xsl:template>
</xsl:stylesheet>
