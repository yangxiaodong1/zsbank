<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<ABCB2I>
			<Header>
				<!-- 交易日期 -->
				<TransDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
				</TransDate>
				<!-- 交易时间 -->
				<TransTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
				</TransTime>
				<!-- 交易码 -->
				<TransCode>1001</TransCode>
				<!-- 保险公司流水号 在程序中赋值-->
				<InsuSerial></InsuSerial>
				<!-- 银行代码 -->
				<BankCode>00</BankCode>
				<!-- 保险公司代码 -->
				<CorpNo>3002</CorpNo>
				<!-- 交易发起方 -->
				<TransSide>0</TransSide>
				<!-- 委托方式 -->
				<EntrustWay>20</EntrustWay>
			</Header>
			<App>
				<Req>
					<!-- 加密方式 01: 默认方式RSA+AES方式-->
					<EncType>01</EncType>
					<!-- 新密钥-->
					<PriKey>01</PriKey>
					<!-- 原密钥-->
					<OrgKey>cacert.crt</OrgKey>
				</Req>
			</App>
		</ABCB2I>
	</xsl:template>
</xsl:stylesheet>
