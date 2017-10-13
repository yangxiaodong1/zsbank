<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />

			<Body>
				<ContNo></ContNo>
				<!-- Ͷ������ -->
				<ProposalPrtNo>
					<xsl:value-of select="//ApplicationInfo/HOAppFormNumber" />
				</ProposalPrtNo>
				<!-- ������ͬӡˢ�� -->
				<ContPrtNo>
					<xsl:value-of select="//FormInstance[FormName='PolicyPrintNumber']/ProviderFormNumber" />
				</ContPrtNo>
				
				<!-- �˻��� -->
				<xsl:copy-of select="//OLife/Holding/Policy/AcctHolderName" />
				<!-- �˻��� -->
				<xsl:copy-of select="//OLife/Holding/Policy/AccountNumber" />
				
				<!-- �����Ƽ���Ա�������� -->
				<BankSaler><xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='001']/TellContent" /></BankSaler>
				<!-- ����Ա���� -->
				<SellerNo>
					<xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='001']/TellContent" />
				</SellerNo>
				<!-- ����Ա������ -->
				<TellerName>
					<xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='002']/TellContent" />
				</TellerName>
				<!-- ����Ա������ -->
				<TellerCertiCode>
					<xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='003']/TellContent" />
				</TellerCertiCode>
				<!-- �������� -->
				<AgentComName>
					<xsl:value-of select="//OLifeExtension/TellInfos/TellInfo[@TellInfoKey='BIL' and TellCode='004']/TellContent" />
				</AgentComName>
			</Body>

		</TranData>
	</xsl:template>

	<!-- ����ͷ��� -->
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
	
	<!-- ���б�����������: 0=���棬1=������8=�����ն� -->
	<xsl:template match="TransChannel">
		<xsl:choose>
			<xsl:when test=".='DSK'">0</xsl:when><!--	����ͨ���� -->
			<xsl:when test=".='INT'">1</xsl:when><!--	���� -->
			<xsl:when test=".='IEX'">1</xsl:when><!--	���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>