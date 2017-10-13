<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<!--基本信息-->
			<Head>
				<!-- 银行交易日期 -->
				<TranDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
				</TranDate>
				<!-- 交易时间 农行不传交易时间 取系统当前时间 -->
				<TranTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
				</TranTime>
				<!-- 柜员代码 -->
				<TellerNo>sys</TellerNo>
				<!-- 银行交易流水号 -->
				<TranNo>cacert.crt</TranNo>
				<!-- 地区码+网点码 -->
				<NodeNo>05001</NodeNo>
				<BankCode></BankCode>
			</Head>
			<Body>
				<!-- 旧密钥 -->
				<OldLogNo></OldLogNo>
				<!-- 新密钥 -->
				<ContPrtNo></ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>