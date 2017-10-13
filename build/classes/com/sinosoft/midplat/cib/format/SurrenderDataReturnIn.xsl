<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<!-- ҵ������-->
				<BusinessTypes>
					<!-- ����
					<BusinessType>RENEW</BusinessType>-->
					<!-- ����
					<BusinessType>CLAIM</BusinessType>-->
					<!-- �������ӱ���
					<BusinessType>AA</BusinessType>-->
					<!-- ����׷�ӱ���
					<BusinessType>UP</BusinessType>-->
					<!-- ����׷�ӱ���(˫�ʻ�)
					<BusinessType>ZP</BusinessType>-->
					<!-- �˱�-->
					<BusinessType>CT</BusinessType>
					<!-- ����-->
					<BusinessType>WT</BusinessType>
					<!-- ����-->
					<BusinessType>MQ</BusinessType>
					<!--ǩ��
					<BusinessType>NEWCONT</BusinessType>-->
					<!--��ǩ��
					<BusinessType>WAITSIGN</BusinessType>-->
					<!--�ܱ�
					<BusinessType>REFUSE</BusinessType>-->
					<!-- Э���˱� 
					<BusinessType>XT</BusinessType>-->
				</BusinessTypes>
				<EdorCTDate>
					<xsl:value-of select="TranData/Head/TranDate" />
				</EdorCTDate>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>
