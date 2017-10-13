<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/TXLifeRequest" />

			<Body>
				<xsl:apply-templates
					select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date10to8(TransExeDate)" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TransExeTime)" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OLifEExtension/Teller" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="OLifEExtension/RegionCode" />
				<xsl:value-of select="OLifEExtension/Branch" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<xsl:template name="Body" match="Policy">
		<!--������ ע����ֶκ�Ͷ���������ֶο϶���һ�� -->
		<ContNo><xsl:value-of select="PolNumber" /></ContNo>
		<Appnt>
			<xsl:variable name="AppntPartyID" select="../../Relation[RelationRoleCode='80']/@RelatedObjectID" />				
			<xsl:variable name="AppntPartyNode" select="../../Party[@id=$AppntPartyID]" />
			<!--Ͷ��������-->
			<Name><xsl:value-of select="$AppntPartyNode/FullName" /></Name>			
			<!--�Ա� ��ѡ�� ȡֵ�ɿͷ�ϵͳ����-->
			<Sex></Sex>
			<!--�������� ��ѡ�� -->
			<Birthday></Birthday>
			<!--֤������ ��ѡ��  ȡֵ�ɿͷ�ϵͳ����-->
			<IDType>0</IDType>
			<!--֤���� ��ѡ��  -->
			<IDNo><xsl:value-of select="$AppntPartyNode/GovtID" /></IDNo>
		</Appnt>
		<Query>
			<!--��ѯ��ʼ���� ��ѡ��  -->
			<QueryBeginDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(OLifEExtension/QueryBeginDate)" /></QueryBeginDate>
			<!--��ѯ��ֹ���� ��ѡ��  -->
			<QueryEndDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(OLifEExtension/QueryEndDate)" /></QueryEndDate>
			<!--��ѯ��ʼ���� ���һҳ1+��ѯ��ȡ������0���ڶ�ҳ1+��ѯ��ȡ������1������ҳ1+��ѯ��ȡ������2-->
			<RecordBeginNum><xsl:value-of select="OLifEExtension/QueryBeginNum" /></RecordBeginNum>
			<!--��ѯ��ȡ����-->
			<RecordFetchNum><xsl:value-of select="OLifEExtension/QueryFetchNum" /></RecordFetchNum>
		</Query>
	</xsl:template>

</xsl:stylesheet>