<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<!-- 业务类型-->
				<BusinessTypes>
					<!-- 续期
					<BusinessType>RENEW</BusinessType>-->
					<!-- 理赔
					<BusinessType>CLAIM</BusinessType>-->
					<!-- 个人增加保额
					<BusinessType>AA</BusinessType>-->
					<!-- 万能追加保费
					<BusinessType>UP</BusinessType>-->
					<!-- 万能追加保费(双帐户)
					<BusinessType>ZP</BusinessType>-->
					<!-- 退保-->
					<BusinessType>CT</BusinessType>
					<!-- 犹退-->
					<BusinessType>WT</BusinessType>
					<!-- 满期-->
					<BusinessType>MQ</BusinessType>
					<!--签单
					<BusinessType>NEWCONT</BusinessType>-->
					<!--待签单
					<BusinessType>WAITSIGN</BusinessType>-->
					<!--拒保
					<BusinessType>REFUSE</BusinessType>-->
					<!-- 协议退保 
					<BusinessType>XT</BusinessType>-->
				</BusinessTypes>
				<EdorCTDate>
					<xsl:value-of select="TranData/Head/TranDate" />
				</EdorCTDate>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>
