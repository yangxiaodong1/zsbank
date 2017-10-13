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
    
    <!-- 文件的一条记录 -->
	<xsl:template match="Detail">
	   <SurrDetail>
	   		<!-- 保单号-->
	        <ContNo><xsl:value-of select="ContNo" /></ContNo>
	        <!-- 投保单号-->
	        <ProposalNo><xsl:value-of select="ProposalPrtNo" /></ProposalNo>
	        <!-- 投保人姓名-->
	        <AppntName><xsl:value-of select="AppntName" /></AppntName>
	        <!-- 投保人证件类型-->
	        <AppntIDType><xsl:value-of select="AppntIDType" /></AppntIDType>
	        <!-- 投保人证件号-->
	        <AppntIDNo><xsl:value-of select="AppntIDNo" /></AppntIDNo>
	        <!-- 业务类型-->
	        <!-- <BusiType><xsl:value-of select="BusinessType" /></BusiType> -->
	        <BusiType><xsl:apply-templates select="BusinessType" /></BusiType>
	        <!-- 业务确认日期-->
	        <BusiDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(EdorCTDate)" /></BusiDate>
	        <!-- 保单状态-->
	        <!-- <Flag><xsl:value-of select="ContState" /></Flag> -->
	        <Flag><xsl:apply-templates select="ContState" /></Flag>
	        <!-- 总保费-->
	        <Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(SumPrem)" /></Prem>
	        <!-- 险种代码-->
	        <RiskCode><xsl:value-of select="RiskCode" /></RiskCode>
	        <!-- 险种名称-->
	        <!-- <RiskName><xsl:value-of select="" /></RiskName> -->
	        <!-- 险种对应保费-->
	        <RiskPrem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(SumPrem)" /></RiskPrem>
	   </SurrDetail>
	</xsl:template>
	<!-- 业务类型-->
	<xsl:template match="BusinessType">
		<xsl:choose>
			<xsl:when test=".='RENEW'">01</xsl:when><!--	续期 -->
			<xsl:when test=".='CLAIM'">06</xsl:when><!--	理赔 -->
			<xsl:when test=".='AA'">02</xsl:when><!--	个人增加保额 -->
			<xsl:when test=".='PT'">02</xsl:when><!--	个人减少保额 -->
			<xsl:when test=".='CT'">04</xsl:when><!--	退保 -->
			<xsl:when test=".='WT'">03</xsl:when><!--	犹豫期退保 -->
			<xsl:when test=".='MQ'">05</xsl:when><!--	满期给付 -->
			<xsl:when test=".='XT'">06</xsl:when><!--	协议退保 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 保单状态-->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">4</xsl:when><!--	保单有效 -->
			<xsl:when test=".='01'">7</xsl:when><!--	满期终止 -->
			<xsl:when test=".='02'">6</xsl:when><!--	退保终止 -->
			<xsl:when test=".='04'">8</xsl:when><!--	理赔终止 -->
			<xsl:when test=".='WT'">5</xsl:when><!--	犹退终止 -->
			<xsl:when test=".='B'">3</xsl:when><!--	待签单 -->
			<xsl:otherwise>8</xsl:otherwise><!--	终止 -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
