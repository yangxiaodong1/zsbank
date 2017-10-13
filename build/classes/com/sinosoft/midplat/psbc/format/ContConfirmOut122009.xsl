<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
<RETURN>
	 <MAIN>
	 	<!--错误码-->
	 	<RESULTCODE>
	 		<xsl:apply-templates select="Head/Flag" />
	 	</RESULTCODE>
	 	<!--错误描述-->
	 	<ERR_INFO>
	 		<xsl:value-of select="Head/Desc" />
	 	</ERR_INFO>
	 	<!-- 如果交易成功，才返回下面的结点 -->
		<xsl:if test="Head/Flag='0'">
	 	<!--投保单号-->
	 	<APPLNO>
	 		<xsl:value-of select="Body/ProposalPrtNo" />
	 	</APPLNO>
	 	<!--保单号( 主险保险合同号)-->
	 	<POLICY>
	 		<xsl:value-of select="Body/ContNo" />
	 	</POLICY>
	 	<!--投保日期（CD01）-->
	 	<ACCEPT>
	 		<xsl:value-of select="Body/Risk/PolApplyDate" />
	 	</ACCEPT>
	 	<!--首期保费（CD23）-->
	 	<PREM>
	 		<xsl:value-of select="Body/Prem" />
	 	</PREM>
	 	<!--首期保费大写-->
	 	<xsl:variable name="SumPremYuan"
	 		select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" />
	 	<PREMC>
	 		<xsl:value-of
	 			select="java:com.sinosoft.midplat.common.NumberUtil.money2CN(Body/Prem)" />
	 	</PREMC>
	 	<!--保单生效日期（CD01）-->
	 	<VALIDATE>
	 		<xsl:value-of select="Body/Risk/CValiDate" />
	 	</VALIDATE>
	 	<!--投保人姓名-->
	 	<TBR_NAME>
	 		<xsl:value-of select="Body/Appnt/Name" />
	 	</TBR_NAME>
	 	<!--投保人客户号-->
	 	<TBRPATRON>
	 		<xsl:value-of select="Body/Appnt/CustomerNo" />
	 	</TBRPATRON>
	 	<!--被保人姓名-->
	 	<BBR_NAME>
	 		<xsl:value-of select="Body/Insured/Name" />
	 	</BBR_NAME>
	 	<!--被保人客户号-->
	 	<BBRPATRON>
	 		<xsl:value-of select="Body/Insured/CustomerNo" />
	 	</BBRPATRON>
	 	<!--缴费方式（CD24）-->
	 	<xsl:variable name="PayIntv"
	 		select="Body/Risk[RiskCode=MainRiskCode]/PayIntv" />
	 	<PAYMETHOD>
	 		<xsl:call-template name="tran_PayIntv">
	 			<xsl:with-param name="PayIntv">
	 				<xsl:value-of select="$PayIntv" />
	 			</xsl:with-param>
	 		</xsl:call-template>
	 	</PAYMETHOD>
	 	<!--缴费方式(汉字)-->
	 	<PAY_METHOD>
	 		<xsl:apply-templates select="$PayIntv" />
	 	</PAY_METHOD>
	 	<!--缴费日期（CD01）-->
	 	<PAYDATE>
	 		<xsl:value-of select="Body/Risk/PolApplyDate" />
	 	</PAYDATE>
	 	<!--承保公司名称-->
	 	<ORGAN>
	 		<xsl:value-of select="Body/ComName" />
	 	</ORGAN>
	 	<!--承保公司地址-->
	 	<LOC>
	 		<xsl:value-of select="Body/ComLocation" />
	 	</LOC>
	 	<!--承保公司电话-->
	 	<TEL>
	 		<xsl:value-of select="Body/ComPhone" />
	 	</TEL>
	 	<!--特别约定打印标志（CD25）-->
	 	<ASSUM>0</ASSUM>
	 	<!--投保人客户号生成日期（CD01）-->
	 	<TBR_OAC_DATE></TBR_OAC_DATE>
	 	<!--被保人客户号生成日期（CD01）-->
	 	<BBR_OAC_DATE></BBR_OAC_DATE>
	 	<!--承保公司代码-->
	 	<ORGANCODE>
	 		<xsl:value-of select="Body/ComCode" />
	 	</ORGANCODE>
	 	<!--续期缴费日期（汉字描述）-->
	 	<PAYDATECHN></PAYDATECHN>
	 	<!--缴费起止日期（汉字描述）-->
	 	<PAYSEDATECHN></PAYSEDATECHN>
	 	<!--缴费年期-->
	 	<PAYYEAR></PAYYEAR>
	 	</xsl:if>
	 </MAIN>
	<!-- 如果交易成功，才返回下面的结点 -->
	<xsl:if test="Head/Flag='0'">
	 <!--险种信息-->
	<PTS>
	    <PT_COUNT><xsl:value-of select="count(Body/Risk)"/></PT_COUNT>
	    <xsl:for-each select= "Body/Risk">
	    <PT>
	        <xsl:variable name="ContEndDateText" select="java:com.sinosoft.midplat.common.DateUtil.formatTrans(InsuEndDate, 'yyyyMMdd', 'yyyy年MM月dd日')"/>
	        <xsl:variable name="RiskCode" select="RiskCode"/>
	        <xsl:variable name="MainRiskCode" select="MainRiskCode"/>
	        <POLICY><xsl:value-of select="../ContNo"/></POLICY>
	        <UNIT><xsl:value-of select="Mult"/></UNIT>
	        <xsl:if test="$RiskCode = $MainRiskCode">
		        <MAINSUBFLG>1</MAINSUBFLG>
		    </xsl:if>
	        <xsl:if test="$RiskCode != $MainRiskCode">
		        <MAINSUBFLG>0</MAINSUBFLG>
			</xsl:if>
	        <AMT><xsl:value-of select="Amnt"/></AMT>
	        <PREM><xsl:value-of select="Prem"/></PREM>
	        <NAME><xsl:value-of select="RiskName"/></NAME>
	        <PERIOD><xsl:value-of select="$ContEndDateText"/></PERIOD>
	        <INSUENDDATE><xsl:value-of select="$ContEndDateText"/></INSUENDDATE>
	        <INSUENDDATE_CPAI><xsl:value-of select="InsuEndDate"/></INSUENDDATE_CPAI>
	        <PAYENDDATE><xsl:value-of select="PayEndDate"/></PAYENDDATE>
	        <CHARGE_PERIOD>
	        	<xsl:call-template name="tran_PayEndYearFlag">
	        		<xsl:with-param name="payendyearflag">
	        			<xsl:value-of select="PayEndYearFlag" />
	        		</xsl:with-param>
	        		<xsl:with-param name="payendyear">
	        			<xsl:value-of select="PayEndYear" />
	        		</xsl:with-param>
	        	</xsl:call-template>
	        </CHARGE_PERIOD>
	        <CHARGE_YEAR><xsl:value-of select="PayEndYear"/></CHARGE_YEAR>
	    </PT>
	    </xsl:for-each>  
	</PTS>
	
	<!-- 打印信息 -->
	<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]" />
	<xsl:variable name="ProductCode" select="$MainRisk/RiskCode" />
	<PRT>
		<PRT_NUM>2</PRT_NUM>
	    <PRTS>
		<xsl:variable name="SumPremYuan" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/>
		<PRT_TYPE>1</PRT_TYPE>
	    <PRT_REC_NUM>0</PRT_REC_NUM>
	    <PRT_DETAIL>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="Body/ContNo" /><xsl:text>                                                    币值单位：人民币元</xsl:text></PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE>
				<xsl:text>　　　投保人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Appnt/Name, 33)" />
				<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Body/Appnt/IDType" />
				<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Body/Appnt/IDNo" />
			</PRT_LINE>
			<PRT_LINE>
				<xsl:text>　　　被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Insured/Name, 31)" />
				<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Body/Insured/IDType" />
				<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Body/Insured/IDNo" />
			</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<xsl:if test="count(Body/Bnf) = 0">
			<PRT_LINE><xsl:text>　　　身故受益人：法定                </xsl:text>
					   <xsl:text>受益顺序：1                   </xsl:text>
					   <xsl:text>受益比例：100%</xsl:text></PRT_LINE>
			</xsl:if>
			<xsl:if test="count(Body/Bnf)>0">
			<xsl:for-each select="Body/Bnf">
			<PRT_LINE>
				<xsl:text>　　　身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
				<xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
				<xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
			</PRT_LINE>
			</xsl:for-each>
			</xsl:if>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>　　　险种资料</PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE><xsl:text>　　　　　　　　　　                                            基本保险金额\</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>　　　　　　　　　　险种名称              保险期间    交费年期    日津贴额\      保险费    交费频率</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>　　　　　　　　　　                                              份数\档次</xsl:text></PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<xsl:for-each select="Body/Risk">
			<xsl:variable name="PayIntv" select="PayIntv"/>
			<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
			<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
			<PRT_LINE><xsl:text>　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
									<xsl:choose>
										<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
										</xsl:when>
										<xsl:when test="InsuYearFlag = 'Y'">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 11)"/>
											<xsl:text></xsl:text>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="PayIntv = 0">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次性', 10)"/>
										</xsl:when>
										<xsl:when test="PayEndYearFlag = 'Y'">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 10)"/>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('保单帐户价值',15)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Prem,13)"/>
									<xsl:choose>
										<xsl:when test="PayIntv = 0">
											<xsl:text>趸缴</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = 12">
											<xsl:text>年缴</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = 6">
											<xsl:text>半年缴</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = 3">
											<xsl:text>季缴</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = 1">
											<xsl:text>月缴</xsl:text>
										</xsl:when>
										<xsl:when test="PayIntv = -1">
											<xsl:text>不定期缴</xsl:text>
										</xsl:when>
									</xsl:choose>
			</PRT_LINE>
			</xsl:for-each>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>　　　保险费合计：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/>元（小写）</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>　　　<xsl:if test="Body/Risk[RiskCode=MainRiskCode]/RiskType=2">分红保险红利领取方式：累积生息</xsl:if></PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<xsl:variable name="SpecContent" select="Body/Risk[RiskCode=MainRiskCode]/SpecContent"/>
			<PRT_LINE>　　　保险单特别约定：<xsl:choose>
									<xsl:when test="$SpecContent=''">
										<xsl:text>（无）</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$SpecContent"/>
									</xsl:otherwise>
								</xsl:choose></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE>
				<xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="Body/ComName" /></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="Body/ComLocation" /></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　客户服务热线：95569          网址：http://www.anbang-life.com          官方微信号：anbanglife</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站、微信或到柜台进行查询，核实保单信息（对</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>　　　于保险期限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/AgentComName, 49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/SellerNo, 0)"/></PRT_LINE>
		</PRT_DETAIL>
    </PRTS>
    <PRTS>
        <PRT_TYPE>2</PRT_TYPE>
        <PRT_REC_NUM>0</PRT_REC_NUM>
        <PRT_DETAIL>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　保单利益概述：（具体内容请参见保险条款）</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　    等待期：保险合同生效（或最后复效）之日起180日（这180日的时间称为等待期）内被保险人因疾病身</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>　　　故或全残，返还所交保费的105%，保险合同终止。被保险人因意外伤害导致身故或全残，无等待期，按照下</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>　　　述“身故或全残保险金”或“公共交通意外身故或全残保险金”的约定给予赔付。</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　    身故或全残保险金：按照保险合同约定的基本保险金额给付，保险合同终止。</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　    公共交通意外身故或全残保险金：按照保险合同约定的基本保险金额的3倍（最高不超过已交保险费和200万</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>　　　元之和）给付，保险合同终止。</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　    满期保险金：按照保险合同约定的基本保险金额给付，保险合同终止。</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>　　　    每个保单年度可分享公司的经营成果，享有保单红利。具体的分红情况可从安邦人寿每个保单年度寄送</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>　　　的红利通知书、官网（http://www.anbang-life.com）或官方微信（微信号:anbanglife）中查询。</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE><xsl:text>　　　                                        </xsl:text>保单利益表</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/ContNo, 60)"/>币值单位：人民币元 </PRT_LINE>
			
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE>　　　被保险人姓名：<xsl:value-of select="Body/Insured/Name"/></PRT_LINE>
		    <PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE><xsl:text>　　　产品名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRT_LINE>
			<PRT_LINE><xsl:text/>　　　保单年度末<xsl:text>                       </xsl:text><xsl:text>保单利益</xsl:text></PRT_LINE>
			   <xsl:for-each select="$MainRisk/CashValues/CashValue">
				 <xsl:variable name="EndYear" select="EndYear"/>
				   <PRT_LINE><xsl:text/><xsl:text>　　　　　</xsl:text>
											<xsl:choose>
												<xsl:when test="$EndYear &lt; 5">
													<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,18)"/>
													<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),20)"/>
												</xsl:when>
												<xsl:when test="$EndYear = 5">
													<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,18)"/>
													<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(//Body/EFMoney), '元'),20)"/>
												</xsl:when>
												<xsl:otherwise></xsl:otherwise>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="$EndYear=2">保单红利:</xsl:when>
												<xsl:when test="$EndYear=3">除所列保单利益外，您每个保单年度还可分享公司的经营成</xsl:when>
												<xsl:when test="$EndYear=4">果，享有保单红利。</xsl:when>
												<xsl:otherwise></xsl:otherwise>
											</xsl:choose></PRT_LINE>
		       </xsl:for-each>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>　　　备注：</PRT_LINE>
			<PRT_LINE>　　　1.第1-4个保单年度末所列保单利益数值为保单的现金价值，是对应保单年度末的值，保单年度内的现金价</PRT_LINE>
			<PRT_LINE>　　　值，您可以向本公司咨询。</PRT_LINE>
			<PRT_LINE>　　　2.第5个保单年度末所列保单利益数值为保单的“满期保险金”，为保险合同约定的基本保险金额。</PRT_LINE>
			<PRT_LINE>　　　----------------------------------------------------------------------------------------------</PRT_LINE>
		</PRT_DETAIL>	
    </PRTS>
    </PRT>
    </xsl:if>
</RETURN>
</xsl:template>
 


<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">身份证</xsl:when>
	<xsl:when test=".=1">护照  </xsl:when>
	<xsl:when test=".=2">军官证</xsl:when>
	<xsl:when test=".=3">驾照  </xsl:when>
	<xsl:when test=".=5">户口簿</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 缴费间隔  -->
<xsl:template match="PayIntv">
<xsl:choose>
	<xsl:when test=".=0">趸缴</xsl:when>		
	<xsl:when test=".=1">月缴</xsl:when>
	<xsl:when test=".=3">季缴</xsl:when>
	<xsl:when test=".=6">半年缴</xsl:when>
	<xsl:when test=".=12">年缴</xsl:when>
	<xsl:when test=".=-1">不定期缴</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
 
 <!-- 性别【注意：“男     ”空格排版用的，不能去掉】-->
<xsl:template match="Sex">
<xsl:choose>
	<xsl:when test=".=0">男  </xsl:when>		
	<xsl:when test=".=1">女  </xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 红利领取  -->
<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
<xsl:choose>
	<xsl:when test=".=1">累计生息</xsl:when>
	<xsl:when test=".=2">领取现金</xsl:when>
	<xsl:when test=".=3">抵缴保费</xsl:when>
	<xsl:when test=".=5">增额交清</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 返回缴费方式 -->
<xsl:template name="tran_PayIntv">
    <xsl:param name="PayIntv">0</xsl:param>
	<xsl:choose>
	    <xsl:when test="$PayIntv = 0">W</xsl:when>
		<xsl:when test="$PayIntv = 12">Y</xsl:when>
		<xsl:when test="$PayIntv = 1">M</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$PayIntv"/>
		</xsl:otherwise>
	</xsl:choose>
 </xsl:template>
 
<xsl:template match="Head/Flag">
<xsl:choose>
	<xsl:when test=".='0'">0000</xsl:when>
	<xsl:when test=".='1'">0001</xsl:when>
	<xsl:otherwise>
	    <xsl:value-of select="Head/Flag"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

	<!-- 缴费年期年龄标志 -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="payendyearflag" />
		<xsl:param name="payendyear" />
		<xsl:choose>
			<xsl:when test="$payendyearflag='Y' and $payendyear=1000">1</xsl:when><!-- 趸交 -->
			<xsl:when test="$payendyearflag='Y'">2</xsl:when><!-- 按年 -->
			<xsl:when test="$payendyearflag='A'">4</xsl:when><!-- 终生缴费 -->
			<xsl:when test="$payendyearflag='A'">3</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
