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
				    <!-- 退保 -->
					<BusinessType>CT</BusinessType>
					<!-- 犹退 -->
					<BusinessType>WT</BusinessType>
					<!-- 满期-->
         			<BusinessType>MQ</BusinessType>
				</BusinessTypes>
				<!-- 数据类型：02:银代手工单；08:银保通柜面；12:网银；16:自助终端；17：手机银行； --> 
				<SellTypes>
                   <SellType>02</SellType>
                </SellTypes>
				<EdorCTDate><xsl:value-of select="TranData/Head/TranDate"/></EdorCTDate>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>
