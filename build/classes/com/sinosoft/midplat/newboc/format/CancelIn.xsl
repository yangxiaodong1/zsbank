<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:java="http://xml.apache.org/xslt/java"
    exclude-result-prefixes="java">

    <xsl:template match="InsuReq">
        <TranData>
            <xsl:apply-templates select="Main" />
            <Body>
                <!-- 保险单号 -->
		        <ContNo><xsl:value-of select="Main/PolicyNo" /></ContNo>
		        <!-- 投保单号 -->
		        <ProposalPrtNo></ProposalPrtNo>
		        <!-- 保单合同印刷号 -->
		        <ContPrtNo></ContPrtNo>
		        <OldLogNo><xsl:value-of select="Main/OriginTransNo" /></OldLogNo>
           </Body>
        </TranData>
    </xsl:template>

    <!-- 报文头信息 -->
    <xsl:template name="Head" match="Main">
        <Head>
            <!-- 交易日期[yyyyMMdd] -->
            <TranDate>
                <xsl:value-of select="TranDate" />
            </TranDate>
            <!-- 交易时间[hhmmss] -->
            <TranTime>
                <xsl:value-of select="TranTime" />
            </TranTime>
            <!-- 柜员代码 -->
            <TellerNo>
                <xsl:value-of select="TellerNo" />
            </TellerNo>
            <!-- 交易流水号 -->
            <TranNo>
                <xsl:value-of select="TransNo" />
            </TranNo>
            <!-- 地区码+网点码 -->
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