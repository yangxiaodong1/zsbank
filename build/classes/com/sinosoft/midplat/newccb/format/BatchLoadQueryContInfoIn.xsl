<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TranData/Head/*"/>
		</Head>
		<Body>
			<QueryFlag>2</QueryFlag>  <!-- 1�������е���״̬�仯�ı���������, 2�������е���״̬�仯�ı�����Ϣ ���� -->
			<EdorCTDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></EdorCTDate> <!-- ��ѯ���� ���� -->
			<BusinessTypes><!-- ��ѯ��ȫ���� -->
				<BusinessType>CT</BusinessType><!-- �˱� Ŀǰ����֧�� -->
				<BusinessType>WT</BusinessType><!-- ���� Ŀǰ����֧�� -->
				<BusinessType>CA</BusinessType><!-- ���� Ŀǰ����֧�� -->
			</BusinessTypes>
		</Body>
	</TranData>
</xsl:template>


</xsl:stylesheet>
