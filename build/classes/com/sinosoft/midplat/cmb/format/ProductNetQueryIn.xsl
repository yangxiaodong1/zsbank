<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<!-- ��Ʒ���������� --> 
				<RateDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></RateDate> 
				<!-- ���ִ��룬�˴���Ҫ������ȷ�����������ǵ�������������ִ����ѯ�����ԡ������ָ� -->
				<RiskCode>122009,L12078,L12100,L12079,L12073,L12074,122028,122041,122042,122043,122044,L12052,L12068,L12069,122046,122047,L12081,L12080,L12087,L12086,L12088</RiskCode> 
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>
