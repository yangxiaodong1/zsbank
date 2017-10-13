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
		 		<xsl:value-of select="Body/ActSumPrem" />
		 	</PREM>
		 	<!--首期保费大写-->
		 	<xsl:variable name="SumPremYuan"
		 		select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)" />
		 	<PREMC>
		 		<xsl:value-of
		 			select="java:com.sinosoft.midplat.common.NumberUtil.money2CN(Body/ActSumPrem)" />
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
 		<xsl:apply-templates select="Body" />
 	</xsl:if>
</RETURN>
</xsl:template>

<xsl:template  match="Body">
	 <!--险种信息-->
	<PTS>
	    <PT_COUNT>1</PT_COUNT>
	    <xsl:for-each select= "Risk[RiskCode=MainRiskCode]">
	    <PT>
	        <xsl:variable name="ContEndDateText" select="java:com.sinosoft.midplat.common.DateUtil.formatTrans(InsuEndDate, 'yyyyMMdd', 'yyyy年MM月dd日')"/>
	        <POLICY><xsl:value-of select="../ContNo"/></POLICY>
	        <UNIT><xsl:value-of select="Mult"/></UNIT>
	        <MAINSUBFLG>1</MAINSUBFLG>
	        <AMT><xsl:value-of select="sum(../Risk/Amnt)"/></AMT>
	        <PREM><xsl:value-of select="sum(../Risk/ActPrem)"/></PREM>
	        <NAME><xsl:value-of select="../ContPlan/ContPlanName"/></NAME>
	        <PERIOD><xsl:value-of select="$ContEndDateText"/></PERIOD>
	        <INSUENDDATE><xsl:value-of select="$ContEndDateText"/></INSUENDDATE>
	        <INSUENDDATE_CPAI><xsl:value-of select="InsuEndDate"/></INSUENDDATE_CPAI>
	        <PAYENDDATE><xsl:value-of select="PayEndDate"/></PAYENDDATE>
	        <CHARGE_PERIOD>1</CHARGE_PERIOD>
	        <CHARGE_YEAR>1000</CHARGE_YEAR>
	    </PT>
	    </xsl:for-each>  
	</PTS>
	<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
    <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

	
	<!-- 打印信息 -->
	<PRT>
		<PRT_NUM>2</PRT_NUM>
	    <PRTS>
			<PRT_TYPE>1</PRT_TYPE>
		    <PRT_REC_NUM>0</PRT_REC_NUM>
		    <PRT_DETAIL>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001～</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
				<xsl:text>                                      币值单位：人民币元</xsl:text></PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>　　　投保人姓名：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 28)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</PRT_LINE>
				<PRT_LINE>
					<xsl:text>　　　被保险人：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 30)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:if test="count(Bnf) = 0">
				<PRT_LINE><xsl:text>　　　身故受益人：法定                </xsl:text>
				   <xsl:text>受益顺序：1                   </xsl:text>
				   <xsl:text>受益比例：100%</xsl:text></PRT_LINE>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<PRT_LINE>
							<xsl:text>　　　身故受益人：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>受益顺序：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>受益比例：</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</PRT_LINE>
					</xsl:for-each>
				</xsl:if>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>　　　险种资料</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>　　　　　　　　　　险种名称               保险期间    交费年期    基本保险金额    保险费     交费频率</xsl:text>
				</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:for-each select="Risk">
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
						<!-- 安邦长寿添利终身寿险（万能型） -->
							<PRT_LINE>
								<xsl:text>　　　</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 10)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',16)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
								<xsl:text>-</xsl:text>
							</PRT_LINE>
						</xsl:when>
						<xsl:otherwise>
							<PRT_LINE>
								<xsl:text>　　　</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次性', 10)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,16)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
								<xsl:text>趸缴</xsl:text>
							</PRT_LINE>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>　　　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>      </xsl:text>
					<xsl:text>保险单特别约定：</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>    您购买的保险产品为《安邦长寿利丰保险计划》。若您在保险合同生效两年内退保，本公司仅退还主险的</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>现金价值。</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>    当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同同时终止。不</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>低于主险合同及附加险合同项下满期保险金之和的104%的金额将自动转入安邦长寿添利终身寿险（万能型）的</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</xsl:text>
				</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></PRT_LINE>
				<PRT_LINE><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 0)"/></PRT_LINE>
			</PRT_DETAIL>
	    </PRTS>
	    <PRTS>
	    	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	    	<xsl:variable name="fRisk" select="Risk[RiskCode!=MainRiskCode and CashValues/CashValue !='' ]" />
	    	<xsl:variable name="printmult1" select="concat('-(00001～',$ContPlanMultWith0)"/>
 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
	        <PRT_TYPE>2</PRT_TYPE>
	        <PRT_REC_NUM>0</PRT_REC_NUM>
	        <PRT_DETAIL>
			    <PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE><xsl:text>　　　                                        </xsl:text>现金价值表</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>币值单位：人民币元 </PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></PRT_LINE>
	 	        <PRT_LINE>
			    <xsl:text>　　　险种名称：              </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="$fRisk/RiskName"/></PRT_LINE>
		        <PRT_LINE><xsl:text/>　　　保单年度末<xsl:text>                      </xsl:text>
				   <xsl:text>现金价值                              </xsl:text><xsl:text>现金价值</xsl:text></PRT_LINE>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <PRT_LINE>
					 <xsl:text/><xsl:text>　　　　　</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),38)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($fRisk/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</PRT_LINE>
			    </xsl:for-each>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>　　　备注：</PRT_LINE>
				<PRT_LINE>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</PRT_LINE>
				<PRT_LINE>　　　------------------------------------------------------------------------------------------------</PRT_LINE>	
			</PRT_DETAIL>	
	    </PRTS>
    </PRT>
</xsl:template> 


<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">身份证  </xsl:when>
	<xsl:when test=".=1">护照    </xsl:when>
	<xsl:when test=".=2">军官证  </xsl:when>
	<xsl:when test=".=3">驾照    </xsl:when>
	<xsl:when test=".=4">出生证明</xsl:when>
	<xsl:when test=".=5">户口簿  </xsl:when>
	<xsl:otherwise>--      </xsl:otherwise>
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
