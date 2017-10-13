<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="TranData/Head" />
			<!-- 报文体 -->
			<Body>
				<xsl:apply-templates select="TranData/Body/Detail" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 文件的一条记录 -->
	<xsl:template match="Detail">
		<Detail>
			<TXLife>
				<TXLifeResponse>
					<!-- 交易流水号 -->
					<TransRefGUID>0000000001</TransRefGUID>
					<!--  交易码/处理标志: 保单查询  -->
					<TransType>63</TransType>
					<!--  银行交易日期-->
					<TransExeDate>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
					</TransExeDate>
					<!--  银行交易时间 -->
					<TransExeTime>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
					</TransExeTime>
					<!--  保险公司代码（招行定义）  -->
					<CarrierCode>141</CarrierCode>
					<!-- 银行代码 -->
					<BankCode>06</BankCode>
					<!-- 地区代码（预留） -->
					<RegionCode>0000</RegionCode>
					<!-- 网点代码（预留） -->
					<BranchCode>100999</BranchCode>
					<!-- 柜员代码（预留） -->
					<TellerCode>K03378</TellerCode>
					<OLife>
						<Holding id="Holding_1">
							<Policy>
								<!--保单号-->
								<PolNumber>
									<xsl:value-of select="ContNo" />
								</PolNumber>
								<!-- 主险代码 -->
								<ProductCode>
									<xsl:apply-templates select="RiskCode" />
								</ProductCode>
								<!--  保单状态  -->
								<PolicyStatus>
									<xsl:apply-templates select="ContState" />
								</PolicyStatus>
								<!--  犹豫期截止日期-->
								<xsl:choose>
									<xsl:when test="HesitateEndDate=''">
										<!-- 默认传0 -->
										<GracePeriodEndDate>0</GracePeriodEndDate>
									</xsl:when>
									<xsl:otherwise>
										<!--  犹豫期截止日期-->
										<GracePeriodEndDate>
											<xsl:value-of select="HesitateEndDate" />
										</GracePeriodEndDate>
									</xsl:otherwise>
								</xsl:choose>
								<!--  首期(每期)总保费  -->
								<PaymentAmt>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(SumPrem)" />
								</PaymentAmt>
								<!-- 银行付款帐户 -->
								<AccountNumber>
									<xsl:value-of select="AccNo" />
								</AccountNumber>
								<!-- 帐户姓名(姓名不传，由我方根据卡号取出) -->
								<AcctHolderName></AcctHolderName>
								<ApplicationInfo>
									<!-- 投保书号 -->
									<HOAppFormNumber>
										<xsl:value-of select="ProposalPrtNo" />
									</HOAppFormNumber>
									<!--  状态变更日期  -->
									<xsl:choose>
										<xsl:when test="ContState='00'">
											<!--  签单状态  -->
											<SubmissionDate>
												<xsl:value-of select="SignDate" />
											</SubmissionDate>
										</xsl:when>
										<xsl:otherwise>
											<!--  其他状态  -->
											<SubmissionDate>
												<xsl:value-of select="EdorCTDate" />
											</SubmissionDate>
										</xsl:otherwise>
									</xsl:choose>
								</ApplicationInfo>
							</Policy>
							<OLifeExtension>
								<!-- 告知列表  -->
								<TellInfos>
									<TellInfo>
										<!-- 告知编码：犹豫期开始日期 -->
										<TellCode>001</TellCode>
										<!-- 告知内容 -->
										<xsl:choose>
											<xsl:when test="HesitateStartDate=''">
												<!-- 默认传0 -->
												<TellContent>0</TellContent>
											</xsl:when>
											<xsl:otherwise>
												<!-- 犹豫期开始日期 -->
												<TellContent>
													<xsl:value-of select="HesitateStartDate" />
												</TellContent>
											</xsl:otherwise>
										</xsl:choose>
									</TellInfo>
									<TellInfo>
										<TellCode>002</TellCode>
										<!-- 告知编码：回访标志 -->
										<!-- 告知内容 Y：已回访，N，未回访/回访失败-->
										<TellContent>
											<xsl:apply-templates select="CallVisitFlag" />
										</TellContent>
									</TellInfo>
									<TellInfo>
										<TellCode>003</TellCode>
										<!-- 告知内容 最大11位整数2为小数共13位，为空或者为0表示该保单没有进行质押贷款，如果有质押贷款请标示贷款的金额，如客户贷款已还款，请返回还宽后的质押贷款金额，还清的话返回0-->
										<!-- 告知编码：质押贷款金额 -->
										<TellContent>0</TellContent>
									</TellInfo>
								</TellInfos>
							</OLifeExtension>
						</Holding>
					</OLife>
				</TXLifeResponse>
			</TXLife>
		</Detail>
	</xsl:template>


	<!-- 保单状态 -->
	<!-- 招行状态保单状态A:正常；C:退保；R:拒保；S:犹豫期撤单；F：满期给付；L：失效；J：理赔  -->
	<!-- 核心状态：00:保单有效,01:满期终止,02:退保终止,04:理赔终止,WT:犹豫期退保终止,A:拒保,B:待签单,C:失效 -->
	<xsl:template name="tran_contstate" match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">A</xsl:when>
			<xsl:when test=".='01'">F</xsl:when>
			<xsl:when test=".='02'">C</xsl:when>
			<xsl:when test=".='04'">J</xsl:when>
			<xsl:when test=".='WT'">S</xsl:when>
			<xsl:when test=".='A'">R</xsl:when>
			<xsl:when test=".='C'">L</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 回访标准 -->
	<!-- 招行状态：Y：已回访，N，未回访/回访失败 -->
	<!-- 核心状态：0:成功,1:失败, -->
	<xsl:template match="CallVisitFlag">
		<xsl:choose>
			<xsl:when test=".='0'">Y</xsl:when>
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<!-- PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级 -->
			<xsl:when test=".='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12073'">122029</xsl:when><!-- 安邦盛世5号终身寿险（万能型）  -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型） -->
			<!-- PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级 -->
			<xsl:when test=".='122046'">50002</xsl:when><!--  安邦长寿稳赢1号两全保险 -->
			<!-- 安邦长寿智赢1号年金保险计划,2014-08-29停售
			<xsl:when test=".='L12052'">50006</xsl:when>
			-->
			
			<!-- 安邦长寿安享3号保险计划=50011,L12068=安邦长寿安享3号年金保险,L12069=安邦附加长寿添利3号两全保险（万能型） -->
			<xsl:when test=".='L12068'">50011</xsl:when><!-- 安邦长寿安享3号保险计划 -->
			
			<xsl:when test=".='L12052'">L12052</xsl:when><!-- 安邦长寿智赢1号年金保险 -->
			
			<!-- 存在新旧产品代码共存的情况，在返回银行时，两种情况均需要映射 -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122029'">122029</xsl:when><!-- 安邦盛世5号终身寿险（万能型）  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型） -->
			<!-- 存在新旧产品代码共存的情况，在返回银行时，两种情况均需要映射 -->
			<!-- add 20151229 PBKINSR-1010 招行新产品盛世1号需求  begin -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<!-- add 20151229 PBKINSR-1010 招行新产品盛世1号需求  end -->
			<!-- add 20150222 PBKINSR-1071 招行新产品盛世1号B款需求  begin -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号终身寿险（万能型） B款 -->
			<!-- add 20150222 PBKINSR-1071 招行新产品盛世1号B款需求  end -->
			<!-- PBKINSR-1444 招行柜面东风3号 L12086  zx add 20160805 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<!-- PBKINSR-1530 招行柜面东风9号 L12088 zx add 20160805 -->
			<xsl:when test=".='L12088'">L12088</xsl:when>
			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
