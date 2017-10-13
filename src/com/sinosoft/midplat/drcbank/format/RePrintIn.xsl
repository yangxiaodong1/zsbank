<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="TranData">
		<TranData>
			<xsl:apply-templates select="Head" />
			<Body>
				<ContNo>
					<xsl:value-of select="Body/ContNo" />
				</ContNo>
				<ProposalPrtNo>
					<xsl:value-of select="Body/ProposalPrtNo" />
				</ProposalPrtNo>
				<ContPrtNo>
					<xsl:value-of select="Body/ContPrtNo" />
				</ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����ͷ��Ϣ -->
    <xsl:template name="Head" match="Head">
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
                <xsl:value-of select="TranNo" />
            </TranNo>
            <!-- �������� ����û�е����� -->
            <NodeNo>
                <xsl:value-of select="ZoneNo" /><xsl:value-of select="NodeNo" />
            </NodeNo>
            <xsl:copy-of select="FuncFlag" />
            <xsl:copy-of select="ClientIp" />
            <xsl:copy-of select="TranCom" />
            <BankCode>
                <xsl:value-of select="TranCom/@outcode" />
            </BankCode>
        </Head>
    </xsl:template>
</xsl:stylesheet>
