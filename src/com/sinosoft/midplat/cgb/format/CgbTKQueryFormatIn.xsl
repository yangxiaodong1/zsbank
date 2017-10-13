<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TranData/Head" />
			<Body>
				<xsl:apply-templates select="TranData/Body" /> 												
			</Body>
		</TranData>
	</xsl:template>

    <!-- ����ͷ -->
	<xsl:template name="Head" match="Head">
		<Head>
			<!-- �������ڣ�yyyymmdd�� -->
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<!-- ����ʱ�� ��hhmmss��-->
			<TranTime>
				<xsl:value-of select="TRANSRTIME" />
			</TranTime>
			<!-- ��Ա-->
			<TellerNo>sys</TellerNo>
			<!-- ��ˮ��-->
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<!-- ������+������-->
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<!-- ���б�ţ����Ķ��壩-->
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<SourceType>1</SourceType><!-- 0=����ͨ���桢1=������8=�����ն� -->
			<xsl:copy-of select="../Head/*" />
		</Head>
     </xsl:template>	
	 
	 
	<!--  ���� -->
	<xsl:template name="Body" match="Body" >
							 
		    <!-- ���յ����� --><!--������ -->
			<ContNo><xsl:value-of select="ContNo" /></ContNo>  
  	 	  	<LoanQuery>1</LoanQuery>
	</xsl:template>				
</xsl:stylesheet>