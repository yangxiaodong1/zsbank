<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<!-- 报文头 -->
			<Head>
				<xsl:apply-templates select="Head" />
            </Head>
			<!-- 报文体 -->
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头信息 -->
	<xsl:template name="Head" match="Head">
		<!-- 报文头 -->
	   <!-- 交易日期[yyyyMMdd] -->
          <TranDate>
             <xsl:value-of select="TranDate" />
          </TranDate>
          <!-- 交易时间[hhmmss] -->
          <TranTime>
             <xsl:value-of select="TranTime" />
          </TranTime>
          <!-- 地区代码（银行为空不传值）-->
          <ZoneNo>
             <xsl:value-of select="ZoneNo" />
          </ZoneNo>
          <!-- 银行网点 -->
          <NodeNo>
              <xsl:value-of select="NodeNo" />
          </NodeNo>
          <!-- 柜员代码 -->
          <TellerNo>
              <xsl:value-of select="TellerNo" />
          </TellerNo>
          <!-- 交易流水号 -->
          <TranNo>
              <xsl:value-of select="TranNo" />
          </TranNo>
          <!-- 交易渠道：0-柜面 1- 网银 17-手机银行 --> 
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

	<!-- 报文体 -->
	<xsl:template name="Body" match="Body">
		<!-- 保险单号 -->
		<ContNo>
			<xsl:value-of select="ContNo" />
		</ContNo>
		<!-- 投保单号 -->
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		<!-- 保单合同印刷号 -->
		<ContPrtNo>
			<xsl:value-of select="ContPrtNo" />
		</ContPrtNo>
	</xsl:template>
</xsl:stylesheet>