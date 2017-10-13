<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">
		<xsl:output indent='yes' />
		
	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>
	
	<xsl:template match="Body">
		<App>
			<Ret>
				<xsl:variable name="appDate"><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PubContInfo/EdorAppDate, 'yyyy-MM-dd'),'yyyy��MM��dd��')" /></xsl:variable>
				<!-- �������� -->
				<InsuName><xsl:apply-templates select="PubContInfo" /></InsuName>
				<!-- ������ -->
				<PolicyNo><xsl:value-of select="PubContInfo/ContNo" /></PolicyNo>
				<!-- ����ȡ��� -->
				<OccurBala><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></OccurBala>
				<!-- ��ȫ��Ч�� -->
				<BQValidDate><xsl:value-of select="PubContInfo/EdorValidDate" /></BQValidDate>
				<!-- ���д�ӡ����,���д�ӡ����n��Ŀǰ֧��n<=5 -->
				<PrntCount>5</PrntCount>
				<Prnt1>���������ڽ���������ִ</Prnt1>
                <!-- <Prnt2>���������յ��ţ�<xsl:value-of select="PubContInfo/ContNo" />    �������ڣ�<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PubContInfo/EdorAppDate, 'yyyy-MM-dd'),'yyyy/MM/dd')" /></Prnt2> -->
                <Prnt2>��������Ͷ����<xsl:value-of select="PubContInfo/AppntName" />���룬��<xsl:value-of select="$appDate" />��<xsl:value-of select="PubContInfo/ContNo" />�ű��պ�ͬЧ����ֹ��</Prnt2>
                <Prnt3>�������˱����<xsl:value-of select="$appDate" />����Ч���˷ѽ�������������ڵ��ˣ������Բ�Ʒ������н��飬�ɲ���95569��ͨ���ٷ�΢��</Prnt3>
                <Prnt4>������Anbanglife������ѯ��</Prnt4>
                <Prnt5>���������죺                    <xsl:value-of select="$appDate" /></Prnt5>
			</Ret>
		</App>
	</xsl:template>
	
	
	<!-- ������Ϣ -->
	<xsl:template name="PubContInfo" match="PubContInfo">
		<xsl:if test="ContPlanCode!=''">
			<xsl:value-of select="ContPlanName" />
		</xsl:if>
		<xsl:if test="ContPlanCode=''">
			<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskName" />
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>

