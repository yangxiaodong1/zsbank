<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<Rsp>
			<xsl:apply-templates select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</Rsp>
	</xsl:template>

	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0��ʾ�ɹ���1��ʾʧ�� ��3ת��ʵʱ-->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- ʧ��ʱ�����ش�����Ϣ -->
		</Head>
	</xsl:template>

	<xsl:template name="Body" match="Body">
	 <Body>
	 	<PolItem>	 		
			<!-- Ͷ������ -->
			<ApplyNo><xsl:value-of select="ProposalPrtNo" /></ApplyNo>
		 </PolItem>
		 <!-- ��ʽ���Ĵ�ӡ��Ϣ������ӡ�� -->
		 <PrtList/>
      </Body>
	</xsl:template>

</xsl:stylesheet>
