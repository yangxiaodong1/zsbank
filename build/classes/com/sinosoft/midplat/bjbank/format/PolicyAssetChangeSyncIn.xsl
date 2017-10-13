<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TranData/BaseInfo" />
			<Body>
				<BusinessTypes>			
				    <!-- 续期 -->
					<BusinessType>RENEW</BusinessType>
					<!-- 理赔-->
         			<BusinessType>CLAIM</BusinessType>
					<!-- 个人增加保额-->
                    <BusinessType>AA</BusinessType>
                    <!-- 个人减少保额-->
         			<BusinessType>PT</BusinessType>
					<!-- 退保-->
         			<BusinessType>CT</BusinessType>
					<!-- 犹退 -->
					<BusinessType>WT</BusinessType>
					<!-- 满期-->
         			<BusinessType>MQ</BusinessType>
					<!-- 协议退保-->
         			<BusinessType>XT</BusinessType>
				</BusinessTypes>
				<EdorCTDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(TranData/BaseInfo/BankDate)" /></EdorCTDate>
			</Body>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Head" match="BaseInfo">
       <Head>
	      <TranDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(BankDate)"/></TranDate>
	      <xsl:variable name ="time" select ="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
	      <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6($time)"/></TranTime>
	      <TellerNo><xsl:value-of select="TellerNo"/></TellerNo>
	      <TranNo><xsl:value-of select="TransrNo"/></TranNo>
	      <NodeNo>
		     <xsl:value-of select="ZoneNo"/>
		     <xsl:value-of select="BrNo"/>
	      </NodeNo>
	      <xsl:copy-of select="../Head/*"/>
	      <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
      </Head>
    </xsl:template>
</xsl:stylesheet>
