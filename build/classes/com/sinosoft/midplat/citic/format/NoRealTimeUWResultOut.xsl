<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<Body>
				<xsl:for-each select="TranData/Body/Detail">
					<xsl:variable name="ContPlanCode" select="ContPlanCode" />
					<xsl:variable name="ContPlanMult" select="ContPlanMult" />
					<Detail>
						<!--地区码,截取nodeno的前四位-->
						<Column>
							<xsl:value-of select="substring(NodeNo,0,5)" />
						</Column>
						<!--保险公司代码-->
						<Column>161</Column>
						<!--对应新单银行端流水号-->
						<Column>
							<xsl:value-of select="TranNo" />
						</Column>
						<!-- 银行交易日期 -->
						<Column>
							<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(TranDate)" />
						</Column>
						<!--投保单号-->
						<Column>
							<xsl:value-of select="ProposalPrtNo" />
						</Column>
						<!--保单号-->
						<Column>
							<xsl:value-of select="ContNo" />
						</Column>
						<!--核保结论-->
						<Column>
							<xsl:apply-templates select="UWResult" mode="uwresult" />
						</Column>
						<!--备注-->
						<Column>
							<xsl:value-of select="ReMark" />
						</Column>
						<!--首期总保费（分）-->
						<Column>
							<xsl:value-of select="ActPrem" />
						</Column>
						<!--被保人姓名-->
						<Column>
							<xsl:value-of select="Insured/Name" />
						</Column>
						<!--被保人证件类型-->
						<Column>
							<xsl:apply-templates select="Insured/IDType" />
						</Column>
						<!--被保人证件号-->
						<Column>
							<xsl:value-of select="Insured/IDNo" />
						</Column>
						
						<xsl:choose>
							<xsl:when test="$ContPlanCode=''">
								<!-- 非组合产品 -->
								<!--主险险种信息-->
								<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]"/>
						
								<!--附加险种信息-->
								<xsl:apply-templates select="Risk[RiskCode!=MainRiskCode]" />
		
								<!--补上缺少的附加险种信息-->
								<xsl:call-template name="lessRisk">
									<xsl:with-param name="riskcount">
										<xsl:value-of select="count(Risk[RiskCode!=MainRiskCode])"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<!-- 组合产品 -->
								<!--主险险种信息，组合产品信息-->
								<!--险种代码，组合产品代码-->
								<Column>
									<xsl:apply-templates select="$ContPlanCode" />
								</Column>
								<!--核保结论状态-->
								<Column>
									<xsl:apply-templates select="UWResult" mode="uwresultstatus" />
								</Column>
								<!--份数-->
								<Column>
									<xsl:value-of select="$ContPlanMult" />
								</Column>
								<!--保费（分）-->
								<Column>
									<xsl:value-of select="ActPrem" />
								</Column>
								<!--保额（分）-->
								<Column>
									<xsl:value-of select="Amnt" />
								</Column>
						
								<!--保险年期的特殊转换-->
								<xsl:choose>
									<xsl:when test="($ContPlanCode=50015) or ($ContPlanCode=50002)">
												<!--保险年期类型-->
												<Column>1</Column>
												<!--保险年期-->
												<Column>999</Column>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="(Risk[RiskCode=MainRiskCode]/InsuYear= 106) and (Risk[RiskCode=MainRiskCode]/InsuYearFlag = 'A')">
												<!--保险年期类型-->
												<Column>1</Column>
												<!--保险年期-->
												<Column>999</Column>
											</xsl:when>
											<xsl:otherwise>
												<!--保险年期类型-->
												<Column>
													<xsl:call-template name="tran_InsuYearFlag">
														<xsl:with-param name="InsuYearFlag">
															<xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuYearFlag" />
														</xsl:with-param>
													</xsl:call-template>
												</Column>
												<!--保险年期-->
												<Column>
													<xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuYear" />
												</Column>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
								<!--缴费方式-->
								<xsl:choose>
							  		<xsl:when test="Risk[RiskCode=MainRiskCode]">
							  			<Column>
											<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]/PayIntv" />
										</Column>		
									</xsl:when>
							  		<xsl:otherwise></xsl:otherwise>
							  	</xsl:choose>
						
								<!--缴费年期的特殊转换-->
								<xsl:choose>
									<xsl:when test="Risk[RiskCode=MainRiskCode]/PayIntv = '0'">
										<!--缴费年期类型:1趸交-->
										<Column>1</Column>
										<!--缴费年期-->
										<Column>0</Column>
									</xsl:when>
									<xsl:otherwise>
										<!--缴费年期类型-->
										<Column>
											<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]/PayEndYearFlag" />
										</Column>
										<!--缴费年期-->
										<Column>
											<xsl:value-of select="Risk[RiskCode=MainRiskCode]/PayEndYear" />
										</Column>
									</xsl:otherwise>
								</xsl:choose>
								
								<!--补上缺少的附加险种信息，组合产品-->
								<xsl:call-template name="lessRisk">
									<xsl:with-param name="riskcount">0</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
						
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>


	<!-- 险种信息 -->
	<xsl:template name="risk" match="Risk">
		<!--险种代码-->
		<Column>
			<xsl:apply-templates select="RiskCode" />
		</Column>
		
		<!--核保结论状态-->
		<Column>
			<xsl:apply-templates select="../UWResult" mode="uwresultstatus" />
		</Column>
		<!--份数-->
		<Column>
			<xsl:value-of select="Mult" />
		</Column>
		<!--保费（分）-->
		<Column>
			<xsl:value-of select="RiskActPrem" />
		</Column>
		<!--保额（分）-->
		<Column>
			<xsl:value-of select="Amnt" />
		</Column>

		<!--保险年期的特殊转换-->
		<xsl:choose>
			<xsl:when test="(InsuYear= 106) and (InsuYearFlag = 'A')">
				<!--保险年期类型-->
				<Column>5</Column>
				<!--保险年期-->
				<Column>999</Column>
			</xsl:when>
			<xsl:otherwise>
				<!--保险年期类型-->
				<Column>
					<xsl:call-template name="tran_InsuYearFlag">
						<xsl:with-param name="InsuYearFlag">
							<xsl:value-of select="InsuYearFlag" />
						</xsl:with-param>
					</xsl:call-template>
				</Column>
				<!--保险年期-->
				<Column>
					<xsl:value-of select="InsuYear" />
				</Column>
			</xsl:otherwise>
		</xsl:choose>
		<!--缴费方式-->
		<xsl:choose>
	  		<xsl:when test="RiskCode=MainRiskCode">
	  			<Column>
					<xsl:apply-templates select="PayIntv" />
				</Column>		
			</xsl:when>
	  		<xsl:otherwise></xsl:otherwise>
	  	</xsl:choose>

		<!--缴费年期的特殊转换-->
		<xsl:choose>
			<xsl:when test="PayIntv = '0'">
				<!--缴费年期类型:1趸交-->
				<Column>1</Column>
				<!--缴费年期-->
				<Column>0</Column>
			</xsl:when>
			<xsl:otherwise>
				<!--缴费年期类型-->
				<Column>
					<xsl:apply-templates select="PayEndYearFlag" />
				</Column>
				<!--缴费年期-->
				<Column>
					<xsl:value-of select="PayEndYear" />
				</Column>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 空占位符 -->
	<xsl:template name="lessRisk">
		<xsl:param name="riskcount"/>
		<xsl:if test="4 - $riskcount > 0">
			<!--险种代码-->
			<Column></Column>
			<!--核保结论状态-->
			<Column></Column>
			<!--份数-->
			<Column></Column>
			<!--保费（分）-->
			<Column></Column>
			<!--保额（分）-->
			<Column></Column>
			<Column></Column>
			<!--保险年期-->
			<Column></Column>
			<!--缴费年期类型-->
			<Column></Column>
			<!--缴费年期-->
			<Column></Column>
		</xsl:if>
		<xsl:if test="3 - $riskcount > 0">
			<!--险种代码-->
			<Column></Column>
			<!--核保结论状态-->
			<Column></Column>
			<!--份数-->
			<Column></Column>
			<!--保费（分）-->
			<Column></Column>
			<!--保额（分）-->
			<Column></Column>
			<Column></Column>
			<!--保险年期-->
			<Column></Column>
			<!--缴费年期类型-->
			<Column></Column>
			<!--缴费年期-->
			<Column></Column>
		</xsl:if>
		<xsl:if test="2 - $riskcount > 0">
			<!--险种代码-->
			<Column></Column>
			<!--核保结论状态-->
			<Column></Column>
			<!--份数-->
			<Column></Column>
			<!--保费（分）-->
			<Column></Column>
			<!--保额（分）-->
			<Column></Column>
			<Column></Column>
			<!--保险年期-->
			<Column></Column>
			<!--缴费年期类型-->
			<Column></Column>
			<!--缴费年期-->
			<Column></Column>
		</xsl:if>
		<xsl:if test="1 - $riskcount > 0">
			<!--险种代码-->
			<Column></Column>
			<!--核保结论状态-->
			<Column></Column>
			<!--份数-->
			<Column></Column>
			<!--保费（分）-->
			<Column></Column>
			<!--保额（分）-->
			<Column></Column>
			<Column></Column>
			<!--保险年期-->
			<Column></Column>
			<!--缴费年期类型-->
			<Column></Column>
			<!--缴费年期-->
			<Column></Column>
		</xsl:if>
	</xsl:template>

	<!-- 证件类型 -->
	<!-- 银行：0公民身份证号码、1军官证、8(港澳)回乡证及通行证、a其它、b户口簿、I护照  c-台胞证 8-港澳通行证-->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 身份证 -->
			<xsl:when test=".='1'">I</xsl:when><!-- 护照 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 军官证 -->
			<xsl:when test=".='5'">b</xsl:when><!-- 户口簿 -->
			<xsl:when test=".='7'">c</xsl:when><!-- 台胞证 -->
			<xsl:when test=".='6'">8</xsl:when><!-- 港澳回乡证 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 核保结论 -->
	<xsl:template  match="UWResult" mode="uwresult">
		<xsl:choose>
			<xsl:when test=".='9'">0</xsl:when><!-- 标体承保 -->
			<xsl:when test=".='4'">2</xsl:when><!-- 其他承保 -->
			<xsl:when test=".='1'">3</xsl:when><!-- 拒保 -->
			<xsl:when test=".='a'">4</xsl:when><!-- 客户取消投保  -->
			<xsl:when test=".='2'">5</xsl:when><!-- 延期 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 核保结论状态,核心不传UWResultStatus，取UWResult -->
	<xsl:template  match="UWResult" mode="uwresultstatus">
		<xsl:choose>
			<xsl:when test=".='9'">01</xsl:when><!-- 标体通过 -->
			<xsl:when test=".='4'">55</xsl:when><!-- 其他承保 -->
			<xsl:when test=".='1'">56</xsl:when><!-- 拒保 -->
			<xsl:when test=".='a'">57</xsl:when><!-- 客户取消投保  -->
			<xsl:when test=".='2'">58</xsl:when><!-- 延期 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费方式 银行方："0=无关或者不确定"；"1=年缴"；"2=半年缴"；"3=季缴"；"4=月缴"；"5=趸缴"；"6=不定期缴"；"7=趸缴按月付款"；"0=无关" -->
	<xsl:template name="tran_payintv" match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">1</xsl:when><!-- 年缴 -->
			<xsl:when test=".='1'">4</xsl:when><!-- 月缴 -->
			<xsl:when test=".='6'">2</xsl:when><!-- 半年缴 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季缴 -->
			<xsl:when test=".='0'">5</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='-1'">6</xsl:when><!-- 不定期 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期标志,银行方：0无关，1趸交，2年缴，3缴至某确定年龄，4终身缴费，5不定期缴，6月缴，7半年缴 -->
	<xsl:template name="tran_PayEndYearFlag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'">0</xsl:when><!-- 日 -->
			<xsl:when test=".='M'">6</xsl:when><!-- 月 -->
			<xsl:when test=".='Y'">2</xsl:when><!-- 年 -->
			<xsl:when test=".='A'">3</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年期标志 -->
	<xsl:template name="tran_InsuYearFlag">
		<xsl:param name="InsuYearFlag"></xsl:param>
		<xsl:choose>
			<xsl:when test="$InsuYearFlag = 'A'">6</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test="$InsuYearFlag = 'Y'">2</xsl:when><!-- 年保 -->
			<xsl:when test="$InsuYearFlag = 'M'">4</xsl:when><!-- 月保 -->
			<xsl:when test="$InsuYearFlag = 'D'">5</xsl:when><!-- 日保 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 主险映射 -->
	<xsl:template name="tran_MainRiskCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号终身寿险（万能型）B款 -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test=".='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12073'">122029</xsl:when><!-- 安邦盛世5号终身寿险（万能型） -->
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
			<xsl:when test=".='122036'">122036</xsl:when>	<!-- 安邦黄金鼎6号两全保险（分红型）A款 -->
			<xsl:when test=".='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
			
			<!-- 组合产品不用进行转换，此处写出是为了查询有哪些组合产品已经上线 -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='122029'">122029</xsl:when><!-- 安邦盛世5号终身寿险（万能型） -->
			<xsl:when test=".='122035'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
			<xsl:when test=".='50015'">50002</xsl:when>	<!-- 长寿稳赢组合产品 -->
			<xsl:when test=".='50002'">50002</xsl:when>	<!-- 长寿稳赢组合产品 -->
			<xsl:when test=".='50006'">50006</xsl:when>	<!-- 长寿智赢组合产品 -->
			<!-- add by duanjz 2015-6-24 增加安享5号    begin -->
			<xsl:when test=".='50012'">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
			<xsl:when test=".='L12070'">L12070</xsl:when>	<!-- 安邦长寿安享5号年金保险 -->
			<xsl:when test=".='L12071'">L12071</xsl:when>	<!-- 安邦附加长寿添利5号两全保险（万能型） -->
			<!-- add by duanjz 2015-6-24 增加安享5号    begin -->
			<!-- add by duanjz 2015-10-20 增加安享3号    begin -->
			<xsl:when test=".='50011'">50011</xsl:when>	<!-- 安邦长寿安享3号保险计划 -->
			<xsl:when test=".='L12068'">L12068</xsl:when>	<!-- 安邦长寿安享3号年金保险 -->
			<xsl:when test=".='L12069'">L12069</xsl:when>	<!-- 安邦附加长寿添利3号两全保险（万能型） -->
			<!-- add by duanjz 2015-10-20 增加安享3号    begin -->
			
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型）-->
			<xsl:when test=".='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型）-->
			
			<!-- PBKINSR-1469 中信柜面东风9号 L12088 zx add 20160808 -->
			<xsl:when test=".='L12088'">L12088</xsl:when>
			<!-- PBKINSR-1458 中信柜面东风2号 L12085 zx add 20160808 -->
			<xsl:when test=".='L12085'">L12085</xsl:when>
			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="tran_ContPlanCode" match="ContPlanCode">
		<xsl:choose>
			<!-- 因过度期间会存在50002，50015并存的情况，需要留意。 -->
			<xsl:when test=".='50015'">50002</xsl:when>	<!-- 长寿稳赢组合产品 -->
			<xsl:when test=".='50002'">50002</xsl:when>	<!-- 长寿稳赢组合产品 -->
			<xsl:when test=".='50006'">50006</xsl:when>	<!-- 长寿智赢组合产品 -->
			<!-- add by duanjz 2015-6-24 增加安享5号    begin -->
			<xsl:when test=".='50012'">50012</xsl:when>	<!-- 安邦长寿安享5号保险计划 -->
			<!-- add by duanjz 2015-6-24 增加安享5号    begin -->
			<!-- add by duanjz 2015-10-20 增加安享3号    begin -->
			<xsl:when test=".='50011'">50011</xsl:when>	<!-- 安邦长寿安享3号保险计划 -->
			<!-- add by duanjz 2015-10-20 增加安享5号    begin -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
