<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/REQUEST">
<TranData>
	<Head>
	    <!-- �������� -->
	    <TranDate><xsl:value-of select="BUSI/TRSDATE"/></TranDate>
	    <!-- ����ʱ�� -->
        <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
        <!-- ��Ա���� -->
        <TellerNo><xsl:value-of select="DIST/TELLER"/></TellerNo>
        <!-- ������ˮ�� -->
        <TranNo><xsl:value-of select="BUSI/TRANS"/></TranNo>
        <!-- ������+������� -->
        <NodeNo>
             <xsl:value-of select="DIST/ZONE"/><xsl:value-of select="DIST/DEPT"/>
        </NodeNo>
   
     <xsl:copy-of select="Head/*"/>
        <!-- ���׵�λ -->
        <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
    </Head>
	
	<Body>		
		<ContNo></ContNo> <!-- ��������  -->
		<ProposalPrtNo><xsl:value-of select="BUSI/CONTENT/APPNO"/></ProposalPrtNo> <!-- Ͷ����(ӡˢ)��  -->
		<ContPrtNo><xsl:value-of select="BUSI/CONTENT/BILL_USED"/></ContPrtNo> <!-- ������ͬӡˢ�� -->
	</Body>
</TranData>
</xsl:template>

</xsl:stylesheet>
