<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<!-- 报文体 -->
			<Body>
				<PubContInfo>
					 <!--对账-->
			         <EdorFlag>8</EdorFlag>
					   <!-- 退保，对账：1=对账，0=不对账-->
			         <CTBlcType>0</CTBlcType>
					   <!--  犹退，退对账：1=对账，0=不对账-->
			         <WTBlcType>1</WTBlcType>
					   <!--  满期，对账：1=对账，0=不对账-->
			         <MQBlcType>0</MQBlcType>
					   <!--  续期，对账：1=对账，0=不对账-->
			         <XQBlcType>0</XQBlcType>
					 <!--  修改客户信息，对账：1=对账，0=不对账-->
					 <CABlcType>0</CABlcType>
					 <!--  提现，对账：1=对账，0=不对账-->
			       	 <PNBlcType>0</PNBlcType>
      			</PubContInfo>			
				<!-- 去掉首行：首行为汇总行 -->
				<xsl:for-each
					select="//Detail[LineNum !='0']">
					<Detail>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="Column[8]" />
						</TranNo>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="Column[3]" /><xsl:value-of select="Column[4]" />
						</NodeNo>
						<BankCode>12</BankCode> <!-- 银行代码 --> 
						<EdorType>
							<xsl:call-template name="tran_edorType">
								<xsl:with-param name="edorType" select="Column[2]" />
							</xsl:call-template>
						</EdorType>  <!-- 保全交易类型 -->
						<EdorAppNo></EdorAppNo> <!-- 保全申请书号码 -->
						<EdorNo><xsl:value-of select="Column[15]" /></EdorNo> <!-- 保全批单号码[非必须] -->
						<EdorAppDate><xsl:value-of select="Column[5]" /></EdorAppDate> <!-- 保全批改申请日期 YYYYMMDD-->
						<ContNo><xsl:value-of select="Column[14]" /></ContNo> <!-- 保单号 -->
						<RiskCode></RiskCode> <!-- 险种代码[非必须]，如果有是主险的 -->
						<TranMoney>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[23])" />
						</TranMoney> <!-- 交易金额 单位（分）1000000分代表10000元-->
						<AccNo><xsl:value-of select="Column[20]" /></AccNo> <!-- 银行账户[非必须] -->
						<AccName><xsl:value-of select="Column[16]" /></AccName> <!-- 账户姓名[非必须] -->
						<RCode>0</RCode> <!-- 响应码 0成功，1失败-->
						<SourceType>
							<xsl:call-template name="tran_sourceType">
								<xsl:with-param name="sourceType" select="Column[24]" />
							</xsl:call-template>
						</SourceType>							
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	<!-- 渠道 -->
	<xsl:template name="tran_sourceType">
		<xsl:param name="sourceType" />
		<xsl:choose>
			<xsl:when test="$sourceType='00'">0</xsl:when> <!-- 柜面 -->
			<xsl:when test="$sourceType='21'">1</xsl:when> <!-- 网银 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 交易类型 -->
	<xsl:template name="tran_edorType">
		<xsl:param name="edorType" />
		<xsl:choose>
			<xsl:when test="$edorType='B00404'">WT</xsl:when> <!-- 犹退 -->			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>