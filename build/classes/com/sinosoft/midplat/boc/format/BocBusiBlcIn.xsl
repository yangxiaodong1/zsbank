<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
	<xsl:output indent="yes"/>
	
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
		    <TranDate><xsl:value-of select="TranDate"/></TranDate><!-- 交易日期[yyyyMMdd] -->
            <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TranTime)" /></TranTime><!-- 交易时间[hhmmss] -->
            <TranCom outcode="08"><xsl:value-of select="TranCom"/></TranCom><!-- 交易单位(银行/农信社/经代公司) -->            
            <NodeNo><xsl:value-of select="ZoneNo"/><xsl:value-of select="NodeNo"/></NodeNo><!-- 地区代码 +银行网点 -->
            <TellerNo>bocBusiBlc</TellerNo><!-- 柜员代码 -->
            <TranNo><xsl:value-of select="TranNo"/></TranNo><!-- 交易流水号 -->
            <FuncFlag><xsl:value-of select="FuncFlag"/></FuncFlag><!-- 交易类型 -->
			<BankCode><xsl:value-of select="TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<Count>0</Count>
			<Prem>0</Prem>
			<xsl:for-each select="Detail">
				<xsl:if test="State = 'S'">
					<!--保单状态（S：生效；W：撤单）-->
					<Detail>
						<ContNo>
							<xsl:value-of select="ContNo"/>
						</ContNo>
						<!-- 保险单号-->
						<Prem>
						    <xsl:value-of select="Prem"/>							
						</Prem>
						<!-- 保费(分)  注意：中行在新单的时候银行是以元为单位，对账时是以分为单位-->
						<NodeNo>
							<xsl:value-of select="NodeNo"/>
						</NodeNo>
						<!-- 银行网点-->
						<ProposalPrtNo>
							<xsl:value-of select="ProposalPrtNo"/>
						</ProposalPrtNo>
						<!-- 投保单(印刷)号-->
						<AppntName>
							<xsl:value-of select="AppntName"/>
						</AppntName>
						<!-- 投保人姓名-->
					</Detail>
				</xsl:if>
			</xsl:for-each>
		</Body>
	</xsl:template>
</xsl:stylesheet>
