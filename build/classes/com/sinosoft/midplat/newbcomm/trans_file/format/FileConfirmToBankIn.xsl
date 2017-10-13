<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<Req>
			<!--基本信息-->
			<Head>
				<!-- 交易码 -->
				<TrCode>I60911</TrCode>
				<!-- 交易请求方 -->
				<Sender>
					<!-- 机构类型:若交易请求方为保险，则固定填写“I” -->
					<OrgType>I</OrgType>
					<!-- 机构ID -->
					<OrgId>IF10039</OrgId>
					<!-- 分支机构 -->
					<BrchId></BrchId>
					<!-- 网点代码 -->
					<SubBrchId></SubBrchId>
					<!-- 交易终端号 -->
					<TermId></TermId>
					<!-- 交易柜员号 -->
					<TrOper>sys</TrOper>
					<!-- 交易柜员名称 -->
					<TrOperName>sys</TrOperName>
					<!-- 交易渠道 -->
					<ChanNo>93</ChanNo>
					<!-- 原业务日期 -->
					<OriBusDate></OriBusDate>
					<!-- 原交易流水号 -->
					<OriSeqNo></OriSeqNo>
					<!-- 业务日期 -->
					<BusDate></BusDate>
					<!-- 交易流水号 -->
					<SeqNo></SeqNo>
					<!-- 交易日期 -->
					<TrDate><xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></TrDate>
					<!-- 交易时间 -->
					<TrTime><xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" /></TrTime>					
				</Sender>
				<Recver>
					<!-- 机构类型:若交易应答方为银行，则固定填写“B” -->
					<OrgType>B</OrgType>
					<!-- 机构ID -->
					<OrgId>3012900</OrgId>
					<!-- 分支机构 -->
					<BrchId></BrchId>
					<!-- 网点代码 -->
					<SubBrchId></SubBrchId>
				</Recver>				
			</Head>
			<Body>
				<!-- 文件名-->
				<FileName></FileName>
				<!-- 总笔数 -->
				<TotalNum></TotalNum>
				<!-- 总金额 -->
				<TotalAmt></TotalAmt>
				<!-- 创建方批次号 -->
				<BatNo></BatNo>
			</Body>
		</Req>
	</xsl:template>
</xsl:stylesheet>