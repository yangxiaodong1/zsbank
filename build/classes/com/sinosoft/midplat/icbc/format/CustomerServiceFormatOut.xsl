<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID />
				<TransType>1032</TransType>
				<TransExeDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" />
				</TransExeTime>
				<xsl:apply-templates select="TranData/Body" />
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="OLifE" match="Body">
		<OLifE>
			<!-- ��ѯ�ܼ�¼�� -->
			<QueryTotalNum><xsl:value-of select="RecordTotalNum" /></QueryTotalNum>			
			<!-- ��ѯ���ؼ�¼�� -->
			<QueryReturnNum><xsl:value-of select="RecordFetchNum" /></QueryReturnNum>	
			<!-- ��ѯ���,��������ѭ�� -->
			<BusinessLoop>
				<xsl:variable name="count" select ="RecordFetchNum" />
				<xsl:if test="$count!=0">
				<xsl:for-each select="Records/Record">
					<xsl:variable name="idtype" select ="Appnt/IDType" />
					<Business >
						<!--��������-->
						<AcceptanceDate><xsl:value-of
							select="java:com.sinosoft.midplat.common.DateUtil.date8to10(TranDate)" /></AcceptanceDate>
						<!--���չ�˾������ϯ���-->							
						<AcceptanceId><xsl:value-of select="AcceptanceId" /></AcceptanceId>
						<!-- �ͻ����� -->
						<FullName><xsl:value-of select="Appnt/Name" /></FullName>
						<!-- �ͻ�֤������ -->
						<GovtID><xsl:value-of select="Appnt/IDNo" /></GovtID>
						<!-- �ͻ�֤������,Ŀǰ�ͷ�ϵͳֻ֧�����֤��������ʱд�� -->
						<GovtIDTC tc="0">0</GovtIDTC>
						<!-- ҵ������ -->			
						<BusinessType tc="1"><xsl:value-of select="BusinessType" /></BusinessType>
						<!-- ������ -->
						<PolNumber><xsl:value-of select="ContNo" /></PolNumber>
						<!-- ҵ���������� -->
						<BusinessTypeDesc><xsl:value-of select="BusinessTypeDesc" /></BusinessTypeDesc>
						<!-- ������ -->
						<DealFlag tc="1"><xsl:value-of select="DealFlag" /></DealFlag>
						<!-- ���������� -->
						<DealFlagDesc><xsl:value-of select="DealFlagDesc" /></DealFlagDesc>
						<!-- ��ע -->
						<Remark><xsl:value-of select="Remark" /></Remark>
					</Business>
					
				</xsl:for-each>
				</xsl:if>
			</BusinessLoop>
		</OLifE>
	</xsl:template>
</xsl:stylesheet>