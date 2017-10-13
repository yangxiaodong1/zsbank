<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
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
				<EdorCTDate><xsl:value-of select="TranData/Body/EdorCTDate"/></EdorCTDate>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>
