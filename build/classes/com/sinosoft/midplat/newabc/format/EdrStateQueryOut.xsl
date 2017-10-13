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
				<!-- ���ִ��� -->
				<RiskCode></RiskCode>
				<!-- ������ -->
				<PolicyNo><xsl:value-of select="ContNo" /></PolicyNo>
				<!-- ����״̬ -->
				<PolicyStatus><xsl:apply-templates select="ContState" /></PolicyStatus>
				<!-- ��ȫ����״̬ -->
				<BQStatus><xsl:apply-templates select="EdorInfos/EdorInfo/EdorState" /></BQStatus>
				<!-- �������� -->
				<ApplyDate><xsl:value-of select="EdorInfos/EdorInfo/EdorAppDate" /></ApplyDate>
				<!-- ��Ч����,����ȫ����״̬ΪS-�ɹ�ʱ���� -->
				<ValidDate><xsl:value-of select="EdorInfos/EdorInfo/EdorValidDate" /></ValidDate>
				<!-- ҵ����� -->
				<BusinType><xsl:apply-templates select="EdorInfos/EdorInfo/EdorType" /></BusinType>
			</Ret>
		</App>
	</xsl:template>
	
	<!-- ����״̬ -->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">00</xsl:when><!-- ��Ч -->
			<xsl:when test=".='02'">01</xsl:when><!-- �˱� -->
			<xsl:when test=".='C'">02</xsl:when><!-- ���ճ��� -->
			<xsl:when test=".='WT'">03</xsl:when><!-- �̳� -->
			<xsl:when test=".='01'">04</xsl:when><!-- ���ڸ��� -->
			<xsl:when test=".='04'">07</xsl:when><!-- ������ֹ -->
		</xsl:choose>	
	</xsl:template>

	<!-- ��ȫ״̬ -->
	<!-- ���ж��壺S-�ɹ���ȷ����Ч,Fʧ�ܣ�������ֹ��������ֹ���˱���ֹ,D-�����У������ľ�Ϊ������ -->
	<!-- ���պ��ĵı�ȫ״̬�ֵ����£�0 - ȷ����Ч,1 - ¼�����,2 - ����ȷ��,3 - �ȴ�¼��,4 - ������ֹ,
	5 - �����޸�,6 - ȷ��δ��Ч,7 - ��ȫ����,8 - �˱���ֹ,9 - ������ֹ,a - ����ͨ��,b - ��ȫ����,	-->
	<xsl:template match="EdorState">
		<xsl:choose>
			<xsl:when test=".='0'">S</xsl:when><!-- �ɹ����ѱ�ȫȷ�ϵı�ȫ -->
			<xsl:when test=".='4'">F</xsl:when><!-- ʧ�� -->
			<xsl:when test=".='8'">F</xsl:when><!-- ʧ�� -->
			<xsl:when test=".='9'">F</xsl:when><!-- ʧ�� -->
			<xsl:otherwise>D</xsl:otherwise><!-- ������ -->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EdorType">
		<xsl:choose>
			<xsl:when test=".='WT'">01</xsl:when>	<!-- ��ԥ���˱� -->
			<xsl:when test=".='MQ'">02</xsl:when>	<!-- ���ڸ��� -->
			<xsl:when test=".='CT'">03</xsl:when>	<!-- �˱� -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

