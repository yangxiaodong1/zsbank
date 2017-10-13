<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="Transaction">
		<TranData>
			<xsl:apply-templates select="Transaction_Header"/>
			<Body>
			    <ContNo><xsl:value-of select="Transaction_Body/PbInsuSlipNo" /></ContNo> <!-- ��������  -->
		        <ProposalPrtNo></ProposalPrtNo> <!-- Ͷ����(ӡˢ)��  -->
		        <LoanQuery>1</LoanQuery><!-- �Ƿ�ش��ɴ����� -->
		   </Body>
		</TranData>
	</xsl:template>

    <xsl:template name="Head" match="Transaction_Header">
       <Head>
	      <TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	      <TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
          <NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	      <TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	      <TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	      <xsl:copy-of select="../Head/*"/>
	      <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
      </Head>
    </xsl:template>

	<!-- ֤������ -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
		   <xsl:when test="$idtype='A'">0</xsl:when>	<!-- ���֤ -->
	       <xsl:when test="$idtype='B'">2</xsl:when>	<!-- ����֤ -->
	       <xsl:when test="$idtype='F'">5</xsl:when>	<!-- ���ڱ� -->
	       <xsl:when test="$idtype='I'">1</xsl:when>	<!-- ������� ����-->
	       <xsl:when test="$idtype='8'">7</xsl:when>	<!-- ̨�����������½ͨ��֤-->
	       <xsl:when test="$idtype='G'">6</xsl:when>   <!-- �۰Ļ���֤ -->
	       <xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>