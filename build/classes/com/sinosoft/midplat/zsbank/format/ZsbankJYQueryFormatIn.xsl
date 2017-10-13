<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
		    <Head>
				<xsl:apply-templates select="TXLife/TXLifeRequest" />
			</Head>
			<Body>
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" /> 												
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="TXLifeRequest">
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
	 
	 
	<!--  公共 -->
	<xsl:template name="Body" match="Policy" >				
		<!-- 保险单号 ,必输项-->
		<ContNo>
			<xsl:value-of select="ContNo" />
		</ContNo>
		<!-- 投保单(印刷)号，非必输项 -->
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		<!-- 投保人姓名,必输项 -->
		<AppntName>
			<xsl:value-of select="AppntName" />
		</AppntName> 
		<!-- 证件类型,必输项 -->
		<AppntIDType>
			<xsl:apply-templates select="IDType"/>
		</AppntIDType >
		<!-- 证件号码,必输项 -->
		<AppntIDNo>
			<xsl:value-of select="AppntIDNo" />
		</AppntIDNo > 		 
	</xsl:template>	
	
	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">身份证    </xsl:when>
			<xsl:when test=".=1">护照      </xsl:when>
			<xsl:when test=".=2">军官证    </xsl:when>
			<xsl:when test=".=3">驾照      </xsl:when>
			<xsl:when test=".=4">出生证明  </xsl:when>
			<xsl:when test=".=5">户口簿    </xsl:when>
			<xsl:when test=".=8">其他      </xsl:when>
			<xsl:when test=".=9">异常身份证</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>				
</xsl:stylesheet>


	

