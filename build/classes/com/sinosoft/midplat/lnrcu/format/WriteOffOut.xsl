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
		<!-- 原交易农信社流水号 -->
		<OldTransRefGUID></OldTransRefGUID>
		<!-- 原交易的保险流水号 -->
		<OldTransCpicID></OldTransCpicID>
		<!-- 原交易的代码 -->
		<OldTransNo></OldTransNo>
		<!-- 原交易日期 -->
		<OldTransExeDate></OldTransExeDate>
		<!-- 原交易时间 -->
		<OldTransExeTime></OldTransExeTime>
		<!--保单号-->
		<PolNumber></PolNumber>
		<!-- 金额(保费) -->
		<Amount></Amount>
		<!-- 备用 -->
		<BeiYong></BeiYong>
	</TXLife>
	</xsl:template>
</xsl:stylesheet>