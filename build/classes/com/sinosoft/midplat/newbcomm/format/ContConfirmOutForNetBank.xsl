<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Rsp>
	<xsl:apply-templates select="TranData/Head"/>
	<xsl:apply-templates select="TranData/Body"/>
</Rsp>
</xsl:template>

<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0��ʾ�ɹ���1��ʾʧ�� ��3ת��ʵʱ-->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- ʧ��ʱ�����ش�����Ϣ -->
		</Head>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
<Body>
	<PolItem>
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<!-- ������ -->
		<PolNo><xsl:value-of select="ContNo" /></PolNo>
		<!-- ����״̬:�ѽɷѲ��˱� -->
		<PolStat>1</PolStat>
		<!-- �ɷѽ�� -->
		<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PayAmt>
		<!-- �б����� -->
		<AcceptDate><xsl:value-of select="$MainRisk/PolApplyDate" /></AcceptDate>
		<!-- ��Ч���� -->
		<ValiDate><xsl:value-of select="$MainRisk/CValiDate" /></ValiDate>
		<!-- ��ֹ���� -->
		<xsl:choose>
			<xsl:when test="$MainRisk/InsuYearFlag='A' and $MainRisk/InsuYear=106">
				<InvaliDate>99991231</InvaliDate>
			</xsl:when>
			<xsl:otherwise>
				<InvaliDate><xsl:value-of select="$MainRisk/InsuEndDate" /></InvaliDate>
			</xsl:otherwise>
		</xsl:choose>	
		<!-- ���ڽɷ����� -->
		<TermDate></TermDate>				
	</PolItem>
	<NoteList>
		
		<Count>4</Count>
		<NoteItem>
			<RowId>1</RowId>
			<xsl:choose>
				<xsl:when test="ContPlan/ContPlanCode=''">
					<xsl:variable name="RiskName" select="Risk[RiskCode=MainRiskCode]/RiskName" />
					<RowNote>�������ѹ����ɰ������ٱ������޹�˾�ṩ�ġ�<xsl:value-of select="$RiskName" />�����ղ�Ʒ�����ɹ��ɷѣ�����</RowNote>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="RiskName" select="ContPlan/ContPlanName" />
					<RowNote>�������ѹ����ɰ������ٱ������޹�˾�ṩ�ġ�<xsl:value-of select="$RiskName" />�����ղ�Ʒ�����ɹ��ɷѣ�����</RowNote>
				</xsl:otherwise>
			</xsl:choose>
			<Remark></Remark>
		</NoteItem>
		<NoteItem>
			<RowId>2</RowId>
			<RowNote>���ղ�Ʒ���ڱ��չ�˾�б���������Ч��������Ч��ΪͶ���յĴ�����ʱ��������һ�������պ�ƾ�����ż����֤</RowNote>
			<Remark></Remark>
		</NoteItem>
		<NoteItem>
			<RowId>3</RowId>
			<RowNote>�����½�������ٹٷ���վhttp://www.anbang-life.com��ѯ������Ϣ�������¼http://www.ab95569.com���ص�</RowNote>
			<Remark></Remark>
		</NoteItem>
		<NoteItem>
			<RowId>4</RowId>
			<RowNote>�ӱ���������������µ簲�����ٵĿͷ�����95569��</RowNote>
			<Remark></Remark>
		</NoteItem>
	</NoteList>
	<PrtList />
</Body>
</xsl:template>
</xsl:stylesheet>