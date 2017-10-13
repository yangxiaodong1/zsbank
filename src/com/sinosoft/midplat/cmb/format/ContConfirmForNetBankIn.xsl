<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />

			<Body>
				<ContNo></ContNo>
				<!-- 投保单号 -->
				<ProposalPrtNo>
					<xsl:value-of select="//ApplicationInfo/HOAppFormNumber" />
				</ProposalPrtNo>
				<!-- 保单合同印刷号 -->
				<ContPrtNo>
					<xsl:value-of select="//FormInstance[FormName='PolicyPrintNumber']/ProviderFormNumber" />
				</ContPrtNo>
				
				<!-- 账户名 -->
				<xsl:copy-of select="//OLife/Holding/Policy/AcctHolderName" />
				<!-- 账户号 -->
				<xsl:copy-of select="//OLife/Holding/Policy/AccountNumber" />
				
				<!-- 银行推荐人员（网银） -->
				<BankSaler><xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='001']/TellContent" /></BankSaler>
				<!-- 销售员工号 -->
				<SellerNo>
					<xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='001']/TellContent" />
				</SellerNo>
				<!-- 销售员工姓名 -->
				<TellerName>
					<xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='002']/TellContent" />
				</TellerName>
				<!-- 销售员工资质 -->
				<TellerCertiCode>
					<xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='003']/TellContent" />
				</TellerCertiCode>
				<!-- 网点名称 -->
				<AgentComName>
					<xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='004']/TellContent" />
				</AgentComName>
			</Body>

		</TranData>
	</xsl:template>

	<!-- 报文头结点 -->
	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TransExeTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TellerCode" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
			<SourceType>
				<xsl:apply-templates select="OLifeExtension/TransChannel" />
			</SourceType>
		</Head>
	</xsl:template>
	
	<!-- 银行保单销售渠道: 0=柜面，1=网银，8=自助终端 -->
	<xsl:template match="TransChannel">
		<xsl:choose>
			<xsl:when test=".='DSK'">0</xsl:when><!--	银保通柜面 -->
			<xsl:when test=".='INT'">1</xsl:when><!--	网银 -->
			<xsl:when test=".='IEX'">1</xsl:when><!--	网银 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>