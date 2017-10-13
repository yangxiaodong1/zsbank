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
				<TransCode>1017</TransCode>
				<!-- 保险公司流水号 在程序中赋值-->
				<InsuSerial></InsuSerial>
				<!-- 银行代码 -->
				<BankCode>00</BankCode>
				<!-- 保险公司代码 -->
				<CorpNo>3048</CorpNo>
				<!-- 交易发起方 -->
				<TransSide>0</TransSide>
				<!-- 委托方式 -->
				<EntrustWay></EntrustWay>
			</Header>
			<App>
				<!-- 模版中的赋值为下载证书文件的值-->
				<Req>
					<!-- 传送方式 0: 上传 1: 下载 在程序中赋值-->
					<TransFlag>1</TransFlag>
					<!-- 文件类型 01: 证书文件 02: 对账文件 在程序中赋值-->
					<FileType>01</FileType>
					<!-- 文件名称 在程序中赋值-->
					<FileName>cacert.crt</FileName>
					<!-- 文件长度 在程序中赋值-->
					<FileLen>00000000</FileLen>
					<!-- 文件修改时间戳 yyyy-MM-dd HH:mm:ss.SSS-->
					<FileTimeStamp>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCurDate('yyyy-MM-dd HH:mm:ss.SSS')" />
					</FileTimeStamp>
				</Req>
			</App>
		</ABCB2I>
	</xsl:template>
</xsl:stylesheet>
