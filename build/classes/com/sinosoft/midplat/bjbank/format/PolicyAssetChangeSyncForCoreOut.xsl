<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
    
	<xsl:template match="/">
	   <TranData>
	      <PolCount></PolCount>
	      <FileName></FileName>
	      <SurrDetails>
             <xsl:apply-templates select="TranData/Body/Detail" />
          </SurrDetails>
       </TranData>
	</xsl:template>
    
    <!-- �ļ���һ����¼ -->
	<xsl:template match="Detail">
	   <SurrDetail>
	   		<!-- ������-->
	        <ContNo><xsl:value-of select="ContNo" /></ContNo>
	        <!-- Ͷ������-->
	        <ProposalNo><xsl:value-of select="ProposalPrtNo" /></ProposalNo>
	        <!-- Ͷ��������-->
	        <AppntName><xsl:value-of select="AppntName" /></AppntName>
	        <!-- Ͷ����֤������-->
	        <AppntIDType><xsl:value-of select="AppntIDType" /></AppntIDType>
	        <!-- Ͷ����֤����-->
	        <AppntIDNo><xsl:value-of select="AppntIDNo" /></AppntIDNo>
	        <!-- ҵ������-->
	        <!-- <BusiType><xsl:value-of select="BusinessType" /></BusiType> -->
	        <BusiType><xsl:apply-templates select="BusinessType" /></BusiType>
	        <!-- ҵ��ȷ������-->
	        <BusiDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(EdorCTDate)" /></BusiDate>
	        <!-- ����״̬-->
	        <!-- <Flag><xsl:value-of select="ContState" /></Flag> -->
	        <Flag><xsl:apply-templates select="ContState" /></Flag>
	        <!-- �ܱ���-->
	        <Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(SumPrem)" /></Prem>
	        <!-- ���ִ���-->
	        <RiskCode><xsl:value-of select="RiskCode" /></RiskCode>
	        <!-- ��������-->
	        <!-- <RiskName><xsl:value-of select="" /></RiskName> -->
	        <!-- ���ֶ�Ӧ����-->
	        <RiskPrem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(SumPrem)" /></RiskPrem>
	   </SurrDetail>
	</xsl:template>
	<!-- ҵ������-->
	<xsl:template match="BusinessType">
		<xsl:choose>
			<xsl:when test=".='RENEW'">01</xsl:when><!--	���� -->
			<xsl:when test=".='CLAIM'">06</xsl:when><!--	���� -->
			<xsl:when test=".='AA'">02</xsl:when><!--	�������ӱ��� -->
			<xsl:when test=".='PT'">02</xsl:when><!--	���˼��ٱ��� -->
			<xsl:when test=".='CT'">04</xsl:when><!--	�˱� -->
			<xsl:when test=".='WT'">03</xsl:when><!--	��ԥ���˱� -->
			<xsl:when test=".='MQ'">05</xsl:when><!--	���ڸ��� -->
			<xsl:when test=".='XT'">06</xsl:when><!--	Э���˱� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ����״̬-->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">4</xsl:when><!--	������Ч -->
			<xsl:when test=".='01'">7</xsl:when><!--	������ֹ -->
			<xsl:when test=".='02'">6</xsl:when><!--	�˱���ֹ -->
			<xsl:when test=".='04'">8</xsl:when><!--	������ֹ -->
			<xsl:when test=".='WT'">5</xsl:when><!--	������ֹ -->
			<xsl:when test=".='B'">3</xsl:when><!--	��ǩ�� -->
			<xsl:otherwise>8</xsl:otherwise><!--	��ֹ -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
