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
			         <WTBlcType>0</WTBlcType>
					   <!--  满期，对账：1=对账，0=不对账-->
			         <MQBlcType>0</MQBlcType>
					   <!--  续期，对账：1=对账，0=不对账-->
			         <XQBlcType>0</XQBlcType>
					 <!--  修改客户信息，对账：1=对账，0=不对账-->
					 <CABlcType>0</CABlcType>
					 <!--  提现，对账：1=对账，0=不对账-->
			       	 <PNBlcType>0</PNBlcType>
			       	 <!-- 质押贷款(冻结)，对账：1=对账，0=不对账 -->
					 <BLBlcType>1</BLBlcType>
					 <!-- 质押贷款(解冻)，对账：1=对账，0=不对账 -->
					 <BDBlcType>1</BDBlcType>
      			</PubContInfo>			
				<xsl:for-each
					select="//Detail[Column[6] ='01']"><!-- 取处理成功的数据 -->
					<Detail>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="Column[3]" />
						</TranNo>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="Column[9]" /><xsl:value-of select="Column[10]" />
						</NodeNo>
						<BankCode>15</BankCode> <!-- 银行代码 --> 
						<EdorType>
							<xsl:call-template name="tran_edorType">
								<xsl:with-param name="edorType" select="Column[5]" />
							</xsl:call-template>
						</EdorType>  <!-- 保全交易类型 -->
						<EdorAppNo></EdorAppNo> <!-- 保全申请书号码 -->
						<EdorNo></EdorNo> <!-- 保全批单号码[非必须] -->
						<EdorAppDate><xsl:value-of select="Column[1]" /></EdorAppDate> <!-- 保全批改申请日期 YYYYMMDD-->
						<ContNo><xsl:value-of select="Column[2]" /></ContNo> <!-- 保单号 -->
						<RiskCode></RiskCode> <!-- 险种代码[非必须]，如果有是主险的 -->
						<TranMoney></TranMoney> <!-- 交易金额 单位（分）1000000分代表10000元-->
						<AccNo><xsl:value-of select="Column[7]" /></AccNo> <!-- 银行账户[非必须] -->
						<AccName><xsl:value-of select="Column[8]" /></AccName> <!-- 账户姓名[非必须] -->
						<RCode>0</RCode> <!-- 响应码 0成功，1失败-->
						<SourceType>z</SourceType><!-- z-直销银行 -->							
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	<!-- 交易类型 -->
	<xsl:template name="tran_edorType">
		<xsl:param name="edorType" />
		<xsl:choose>
			<xsl:when test="$edorType='1'">BL</xsl:when> <!-- 冻结 -->
			<xsl:when test="$edorType='2'">BD</xsl:when> <!-- 解冻 -->			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>