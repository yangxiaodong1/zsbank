<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
	<TXLife>
		<ResultCode>
		      <xsl:if test="Head/Flag='0'">00</xsl:if>
	  		  <xsl:if test="Head/Flag='1'">99</xsl:if>
	    </ResultCode>
		<ResultInfoDesc><xsl:value-of select ="Head/Desc"/></ResultInfoDesc>
		<!-- ԭ����ũ������ˮ�� -->
		<OldTransRefGUID></OldTransRefGUID>
		<!-- ԭ���׵ı�����ˮ�� -->
		<OldTransCpicID></OldTransCpicID>
		<!-- ԭ���׵Ĵ��� -->
		<OldTransNo></OldTransNo>
		<!-- ԭ�������� -->
		<OldTransExeDate></OldTransExeDate>
		<!-- ԭ����ʱ�� -->
		<OldTransExeTime></OldTransExeTime>
		<!--������-->
		<PolNumber></PolNumber>
		<!-- ���(����) -->
		<Amount></Amount>
		<!-- ���� -->
		<BeiYong></BeiYong>
	</TXLife>
	</xsl:template>
</xsl:stylesheet>