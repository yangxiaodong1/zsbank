<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/">
		<TranData>
			<Body>
				<!-- 新契约对账 -->
				<NewCont>
					<TranData>
						<!-- 报文头 -->
						<xsl:copy-of select="TranData/Head" />
						<Body>
							<!-- 成功的新契约交易 -->
							<Count>
								<xsl:value-of select="count(//Detail[position()>1 and Column[7]='01' and Column[8]='01'])" />
							</Count>
							<Prem>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[position()>1 and Column[7]='01' and Column[8]='01']/Column[6]))" />
							</Prem>
							<xsl:for-each
								select="//Detail[position()>1 and Column[7]='01' and Column[8]='01']">
								<xsl:call-template
									name="common_newcont" />
							</xsl:for-each>
						</Body>
					</TranData>
				</NewCont>
				<!-- 续期缴费对账 -->
				<XQ>
					<TranData>
						<!-- 报文头 -->
						<xsl:copy-of select="TranData/Head" />
						<Body>
							<!-- 保全对账公共标示部分 -->
							<PubContInfo>
								<!-- 对账标示 -->
								<EdorFlag>8</EdorFlag>
								<!-- 退保对账 -->
								<CTBlcType>0</CTBlcType>
								<!-- 犹退对账 -->
								<WTBlcType>0</WTBlcType>
								<!-- 满期对账 -->
								<MQBlcType>0</MQBlcType>
								<!-- 续期对账 -->
								<XQBlcType>1</XQBlcType>
							</PubContInfo>
							<xsl:for-each
								select="//Detail[position()>1 and Column[7]='03']">
								<xsl:call-template name="common_xq" />
							</xsl:for-each>
						</Body>
					</TranData>
				</XQ>
			</Body>
		</TranData>
	</xsl:template>

	<!-- 新契约对账 -->
	<xsl:template name="common_newcont">
		<Detail>
			<!--  交易日期（10位数字格式YYYYMMDD，不能为空） -->
			<TranDate>
				<xsl:value-of select="Column[1]" />
			</TranDate>
			<!--  银行网点代码  (地区码+网点码)-->
			<NodeNo>
				<xsl:value-of select="Column[3]" />
				<xsl:value-of select="Column[4]" />
			</NodeNo>
			<!--  交易流水号  -->
			<TranNo>
				<xsl:value-of select="Column[2]" />
			</TranNo>
			<!--  保险合同号/保单号  -->
			<ContNo>
				<xsl:value-of select="Column[5]" />
			</ContNo>
			<!--  交易实收金额 -->
			<Prem>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[6])" />
			</Prem>
			<SourceType>0</SourceType>
		</Detail>
	</xsl:template>

	<!-- 新契约对账 -->
	<xsl:template name="common_xq">
		<Detail>
			<!--  银行编号  -->
			<BankCode>05</BankCode>
			<!--  保全类型  -->
			<EdorType>XQ</EdorType>
			<!--  保全受理号  -->
			<EdorAppNo/>
			<!--  保全-->
			<EdorNo />
			<!-- 交易日期  -->
			<EdorAppDate>
				<xsl:value-of select="Column[1]" />
			</EdorAppDate>
			<!--  保险合同号/保单号  -->
			<ContNo>
				<xsl:value-of select="Column[5]" />
			</ContNo>
			<!-- 保费金额 -->
			<TranMoney>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[6])" />
			</TranMoney>
			<!-- 账户号 -->
			<AccNo/>
			<!-- 账户名称 -->
			<AccName/>
			<RCode>0</RCode>
		</Detail>
	</xsl:template>
</xsl:stylesheet>