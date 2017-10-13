<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<!-- ����ͷ -->
			<Head>
				<xsl:apply-templates select="Head" />
            </Head>
			<!-- ������ -->
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����ͷ��Ϣ -->
	<xsl:template name="Head" match="Head">
		<!-- ����ͷ -->
	   <!-- ��������[yyyyMMdd] -->
          <TranDate>
             <xsl:value-of select="TranDate" />
          </TranDate>
          <!-- ����ʱ��[hhmmss] -->
          <TranTime>
             <xsl:value-of select="TranTime" />
          </TranTime>
          <!-- �������루����Ϊ�ղ���ֵ��-->
          <ZoneNo>
             <xsl:value-of select="ZoneNo" />
          </ZoneNo>
          <!-- �������� -->
          <NodeNo>
              <xsl:value-of select="NodeNo" />
          </NodeNo>
          <!-- ��Ա���� -->
          <TellerNo>
              <xsl:value-of select="TellerNo" />
          </TellerNo>
          <!-- ������ˮ�� -->
          <TranNo>
              <xsl:value-of select="TranNo" />
          </TranNo>
          <!-- ����������0-���� 1- ���� 17-�ֻ����� --> 
          <SourceType >
             <xsl:value-of select="SourceType" />
          </SourceType>
		  <xsl:copy-of select="FuncFlag" />
	      <xsl:copy-of select="ClientIp" />
	      <xsl:copy-of select="TranCom" />
	      <BankCode>
              <xsl:value-of select="TranCom/@outcode" />
          </BankCode>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Body" match="Body">
		<!-- ���յ��� -->
		<ContNo>
			<xsl:value-of select="ContNo" />
		</ContNo>
		<!-- Ͷ������ -->
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		<!-- ������ͬӡˢ�� -->
		<ContPrtNo>
			<xsl:value-of select="ContPrtNo" />
		</ContPrtNo>
	</xsl:template>
</xsl:stylesheet>