<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<!-- 保单状态A:正常；C:退保；R:拒保；S:犹豫期撤单；F：满期给付；L：失效；J：理赔 --> 
				<BusinessTypes>
				      <!-- 续期-->
                      <BusinessType>RENEW</BusinessType>
                      <!-- 万能追加保费-->
                      <BusinessType>UP</BusinessType>
                      <!-- 万能追加保费(双帐户)-->
                      <BusinessType>ZP</BusinessType>
                      <!-- 退保-->
                      <BusinessType>CT</BusinessType>
                      <!-- 犹退-->
                      <BusinessType>WT</BusinessType>
                      <!-- 满期-->
                      <BusinessType>MQ</BusinessType>
                      <!--签单-->
                      <BusinessType>NEWCONT</BusinessType>
                      <!--待签单-->
                      <BusinessType>WAITSIGN</BusinessType>
                      <!--万能部分领取-->
                      <BusinessType>OP</BusinessType>
                      <!--万能险部分领取（双帐户）-->
                      <BusinessType>PD</BusinessType>
                      <!--投连部分领取-->
                      <BusinessType>AR</BusinessType>
                      <!--保单基本信息变更-->
                      <BusinessType>CA</BusinessType>
				</BusinessTypes>
				<EdorCTDate><xsl:value-of select="TranData/Head/TranDate"/></EdorCTDate>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>