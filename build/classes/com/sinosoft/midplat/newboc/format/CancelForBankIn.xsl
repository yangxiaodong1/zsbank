<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:java="http://xml.apache.org/xslt/java"
    exclude-result-prefixes="java">

    <xsl:template match="InsuReq">
        <TranData>
            <xsl:apply-templates select="Main" />
            <Body>
                <!-- ���յ��� -->
		        <ContNo><xsl:value-of select="Main/PolicyNo" /></ContNo>
		        <!-- Ͷ������ -->
		        <ProposalPrtNo></ProposalPrtNo>
		        <!-- ������ͬӡˢ�� -->
		        <ContPrtNo></ContPrtNo>
		        <OldLogNo><xsl:value-of select="Main/OriginTransNo" /></OldLogNo>
           </Body>
        </TranData>
    </xsl:template>

    <!-- ����ͷ��Ϣ -->
    <xsl:template name="Head" match="Main">
        <Head>
            <!-- ��������[yyyyMMdd] -->
            <TranDate>
                <xsl:value-of select="TranDate" />
            </TranDate>
            <!-- ����ʱ��[hhmmss] -->
            <TranTime>
                <xsl:value-of select="TranTime" />
            </TranTime>
            <!-- ��Ա���� -->
            <TellerNo>
                <xsl:value-of select="TellerNo" />
            </TellerNo>
            <!-- ������ˮ�� -->
            <TranNo>
                <xsl:value-of select="TransNo" />
            </TranNo>
            <!-- ������+������ -->
            <NodeNo>
                <xsl:value-of select="ZoneNo" />
                <xsl:value-of select="BrNo" />
            </NodeNo>
            <xsl:copy-of select="../Head/*" />
            <BankCode>
                <xsl:value-of select="../Head/TranCom/@outcode" />
            </BankCode>
        </Head>
    </xsl:template>
    
</xsl:stylesheet>