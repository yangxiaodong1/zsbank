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
				<!-- �������� -->
				<InsuName><xsl:apply-templates select="PubContInfo" /></InsuName>
				<!-- ������ -->
				<PolicyNo><xsl:value-of select="PubContInfo/ContNo" /></PolicyNo>
				<!-- ����ȡ��� -->
				<OccurBala><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></OccurBala>
				<!-- ������Ч�� -->
				<ValidDate><xsl:value-of select="PubContInfo/ContValidDate" /></ValidDate>
				<!-- ���������� -->
				<ExpireDate><xsl:value-of select="PubContInfo/ContExpireDate" /></ExpireDate>
				<!-- ���д�ӡ����,���д�ӡ����n��Ŀǰ֧��n<=5 -->
				<PrntCount>0</PrntCount>
				<Prnt1></Prnt1>
				<Prnt2></Prnt2>
				<Prnt3></Prnt3>
				<Prnt4></Prnt4>
				<Prnt5></Prnt5>
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

