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
						<xsl:apply-templates
							select="TXLife/TXLifeRequest" />
						<Body>
							<Count>
								<xsl:value-of
									select="count(//JournalEntry[ResultCode=1 and TransType='01'])" />
							</Count>
							<Prem>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//JournalEntry[ResultCode=1 and TransType='01']/PaymentAmount))" />
							</Prem>
							<!-- 成功的新契约交易 -->
							<xsl:for-each
								select="//JournalEntry[ResultCode=1 and TransType='01']">
								<xsl:call-template
									name="common_newcont" />
							</xsl:for-each>
						</Body>
					</TranData>
				</NewCont>
				<!-- 犹豫期退保对账 -->
				<WT>
					<TranData>
						<!-- 报文头 -->
						<xsl:apply-templates
							select="TXLife/TXLifeRequest" />
						<Body>
							<PubContInfo>
								<EdorFlag>8</EdorFlag>
								<CTBlcType>1</CTBlcType>
								<WTBlcType>1</WTBlcType>
								<MQBlcType>0</MQBlcType>
								<XQBlcType>0</XQBlcType>
							</PubContInfo>
							<!-- 成功的犹豫期退保交易 -->
							<!-- PBKINSR-834 招行银保通上线新功能（退保） -->
							<xsl:for-each
								select="//JournalEntry[ResultCode=1 and (TransType='05' or TransType='06')]">
								<xsl:call-template name="common_wt" />
							</xsl:for-each>
						</Body>
					</TranData>
					<Count></Count>
				</WT>
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头结点 -->
	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TransExeTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TellerCode" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>


	<!-- 新契约对账 -->
	<xsl:template name="common_newcont">
		<Detail>
			<!--  交易日期（8位数字格式YYYYMMDD，不能为空） -->
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<!--  银行地区代码网点代码  -->
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="Branch" />
			</NodeNo>
			<!--  交易流水号  -->
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<!--  保险合同号/保单号  -->
			<ContNo>
				<xsl:value-of select="PolicyNO" />
			</ContNo>
			<!--  交易实收金额 -->
			<Prem>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PaymentAmount)" />
			</Prem>
			<!-- 交易渠道：0-柜面，1-网银，8自助终端,默认为0，招行过来的对账报文不区分，需要处理 -->
			<SourceType>0</SourceType>
		</Detail>
	</xsl:template>

	<!-- 犹退对账 -->
	<xsl:template name="common_wt">
		<Detail>
			<!--  保险合同号/保单号  -->
			<ContNo>
				<xsl:value-of select="PolicyNO" />
			</ContNo>
			<!--  交易日期（8位数字格式YYYYMMDD，不能为空） -->
			<EdorAppDate>
				<xsl:value-of select="TransExeDate" />
			</EdorAppDate>
			<!--  交易实付金额 -->
			<TranMoney>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PayoutAmount)" />
			</TranMoney>
			<!--  保全类型 wt 犹退 -->
			<EdorType><xsl:apply-templates select="TransType" /></EdorType>
			<EdorAppNo></EdorAppNo>
			<EdorNo></EdorNo>
			<BankCode></BankCode>
			<AccNo></AccNo>
			<AccName></AccName>
			<RCode></RCode>
		</Detail>
	</xsl:template>
	<!-- 业务类型-->
	<xsl:template match="TransType">
		<xsl:choose>
			<xsl:when test=".='05'">WT</xsl:when>	<!-- 犹退  -->
			<xsl:when test=".='06'">CT</xsl:when>	<!-- 退保  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>