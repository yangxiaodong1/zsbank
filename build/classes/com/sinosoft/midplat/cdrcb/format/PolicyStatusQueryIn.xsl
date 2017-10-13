<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<!-- ����״̬A:������C:�˱���R:�ܱ���S:��ԥ�ڳ�����F�����ڸ�����L��ʧЧ��J������ --> 
				<BusinessTypes>					
				    <!-- �˱� -->
					<BusinessType>CT</BusinessType>
					<!-- ���� -->
					<BusinessType>WT</BusinessType>
					<!-- ����-->
         			<BusinessType>MQ</BusinessType>
         			<!-- Э���˱�-->
         			<BusinessType>XT</BusinessType>
				</BusinessTypes>
				<EdorCTDate><xsl:value-of select="TranData/Head/TranDate"/></EdorCTDate>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>
