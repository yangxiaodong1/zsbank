<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
     <Transaction_Body>
		<xsl:apply-templates select="TranData/Body" />
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>

<PbInsuType>
	<xsl:call-template name="tran_ContPlanCode">
		<xsl:with-param name="contPlanCode" select="$MainRisk/MainRiskCode" />
	</xsl:call-template>
</PbInsuType>	
<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate" /></PiEndDate>

<PbFinishDate></PbFinishDate>
<LiDrawstring></LiDrawstring>
<LiCashValueCount>0</LiCashValueCount>	<!-- 中信并不取此处的现价和红利，直接置0 疑问点 -->
<LiBonusValueCount>0</LiBonusValueCount><!-- 中信并不取此处的现价和红利，直接置0 疑问点 -->
<PbInsuSlipNo><xsl:value-of select="ContNo" /></PbInsuSlipNo>
<BkTotAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></BkTotAmt>
<LiSureRate></LiSureRate>
<PbBrokId></PbBrokId>
<LiBrokName></LiBrokName>
<LiBrokGroupNo></LiBrokGroupNo>
<BkOthName></BkOthName>
<BkOthAddr></BkOthAddr>
<PiCpicZipcode></PiCpicZipcode>
<PiCpicTelno></PiCpicTelno>
<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- 如果有现金价值显示2页 -->
<BkFileNum>2</BkFileNum>
</xsl:if>
<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- 如果没有现金价值显示1页 -->
<BkFileNum>1</BkFileNum>
</xsl:if>
<Detail_List>
	<BkFileDesc>保单正面</BkFileDesc>
	<BkType1>010058000001</BkType1>	<!-- 重空类型 -->
	<BkVchNo><xsl:value-of select="ContPrtNo" /></BkVchNo>
	<BkRecNum></BkRecNum>	<!-- 此文本的打印行数 【传空，在外面赋值】 -->
	<Detail>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    币值单位：人民币元</xsl:text></BkDetail1>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>
			<xsl:text>　　　　　投保人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 33)" />
			<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Appnt/IDType" />
			<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Appnt/IDNo" />
		</BkDetail1>
		<BkDetail1>
			<xsl:text>　　　　　被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
			<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Insured/IDType" />
			<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Insured/IDNo" />
		</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:if test="count(Bnf) = 0">
		<BkDetail1><xsl:text>　　　　　身故受益人：法定                </xsl:text>
				   <xsl:text>受益顺序：1                   </xsl:text>
				   <xsl:text>受益比例：100%</xsl:text></BkDetail1>
		</xsl:if>
		<xsl:if test="count(Bnf)>0">
		<xsl:for-each select="Bnf">
		<BkDetail1>
			<xsl:text>　　　　　身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
			<xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
			<xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
		</BkDetail1>
		</xsl:for-each>
		</xsl:if>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>　　　　　险种资料</BkDetail1>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1><xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　    基本保险金额\</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>　　　　　　　　　　　　险种名称              保险期间      交费年期    日津贴额\    保险费      交费频率</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>　　　　　　　　　　　　                                                份数\档次</xsl:text></BkDetail1>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:for-each select="Risk">
		<xsl:variable name="PayIntv" select="PayIntv"/>
		<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
		<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
				<BkDetail1><xsl:text>　　　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 12)"/>
					</xsl:when>
					<xsl:when test="InsuYearFlag = 'Y'">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 12)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 12)"/>
						<xsl:text></xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="PayIntv = 0">
					    <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(' 1年', 11)"/>
					</xsl:when>
					<xsl:when test="PayEndYearFlag = 'Y'">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 11)"/>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('保单帐户价值',14)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
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
			</BkDetail1>
		</xsl:for-each>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　　　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</BkDetail1>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:variable name="SpecContent" select="SpecContent"/>
		
		<BkDetail1>　　　　　保险单特别约定：</BkDetail1>
		<xsl:choose>
			<xsl:when test="$SpecContent=''">
				<BkDetail1><xsl:text>（无）</xsl:text></BkDetail1>
			</xsl:when>
			<xsl:otherwise>
				<BkDetail1><xsl:text>　　　　　    《安邦长寿安享3号年金保险计划》由主险《安邦长寿安享3号年金保险》及附加险《安邦附加长寿添</xsl:text></BkDetail1>
				<BkDetail1><xsl:text>　　　　　利3号两全保险（万能型）》组成。经生存年金受益人同意后，主险产品的生存年金，在年金给付日自动</xsl:text></BkDetail1>
				<BkDetail1><xsl:text>　　　　　转入附加险万能账户中，享受日日复利，月月结息的资金增值服务。</xsl:text></BkDetail1>
			</xsl:otherwise>
		</xsl:choose>
		<BkDetail1>　　　　　-------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>
			<xsl:text>　　　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</BkDetail1>
		<!--  -->
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></BkDetail1>
     
		<BkDetail1><xsl:text>　　　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></BkDetail1>

		<BkDetail1><xsl:text>　　　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>　　　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName,49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 0)"/></BkDetail1>	
	</Detail>
</Detail_List>
<xsl:if test="$MainRisk/CashValues/CashValue != ''">
<xsl:variable name="RiskCount" select="count(Risk)"/>
		<xsl:variable name="CashValueCount" select="count($MainRisk/CashValues/CashValue)"/>
	    <xsl:variable name="CashValueDiv" select="$CashValueCount div 2"/>
		<xsl:variable name="CashValueDiv2">
		    <xsl:if test="floor($CashValueDiv)=$CashValueDiv">
		        <xsl:value-of select="floor($CashValueDiv)+1" />
		    </xsl:if>
		    <xsl:if test="floor($CashValueDiv)!=$CashValueDiv">
		        <xsl:value-of select="floor($CashValueDiv)+2" />
		    </xsl:if>
		 </xsl:variable>
 <Detail_List>
 	<BkFileDesc>保单背面</BkFileDesc>
	<BkType1>010058000001</BkType1>	<!-- 重空类型 -->
	<BkVchNo><xsl:value-of select="ContPrtNo" /></BkVchNo>
	<BkRecNum></BkRecNum>	<!-- 此文本的打印行数 【传空，在外面赋值】 -->
	<Detail>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　                                        </xsl:text>现金价值表</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </BkDetail1>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1><xsl:text>　　　　　被保险人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name,49)"/><xsl:text>险种名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName, 0)"/></BkDetail1>	
		<BkDetail1><xsl:text/>　　　　　保单年度末<xsl:text>       </xsl:text>
				   <xsl:text>       现金价值</xsl:text><xsl:text/>　　　　　       保单年度末<xsl:text>    </xsl:text>
				   <xsl:text>       现金价值</xsl:text></BkDetail1>
		   	<xsl:variable name="EndYear" select="EndYear"/>
						  <xsl:variable name='n' select='$CashValueDiv2'/>
			            <xsl:for-each select='$MainRisk/CashValues/CashValue'>
			            <xsl:variable name='n2' select='position()+($CashValueDiv2)-1'/>
                        <xsl:if test='position() &lt; $n'>
                            <BkDetail1><xsl:text/><xsl:text>　　　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(position(),''),8)"/><xsl:text>　　　　　 </xsl:text>
                            <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(./Cash), '元'),32)"/>   
                            <xsl:if test='../CashValue[$n2]/Cash &gt; 0  or ../CashValue[$n2]/Cash = 0'><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($n2,''),8)"/><xsl:text>　　　　 </xsl:text>
                            <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../CashValue[$n2]/Cash), '元'),0)"/></xsl:if></BkDetail1>
                        </xsl:if>
						</xsl:for-each>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　　　备注：</BkDetail1>
		<BkDetail1>　　　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。 </BkDetail1>
		<BkDetail1>　　　　　------------------------------------------------------------------------------------------------</BkDetail1>
    </Detail>
</Detail_List>
</xsl:if>
</xsl:template>

<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 --><!-- 疑问点 中信银行的身份证的名字：公民身份证号码，军官证为：军人（武警）身份证件等等 -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">身份证</xsl:when>
	<xsl:when test=".=1">护照  </xsl:when>
	<xsl:when test=".=2">军官证</xsl:when>
	<xsl:when test=".=3">驾照  </xsl:when>
	<xsl:when test=".=5">户口簿</xsl:when>
	<xsl:when test=".=7">台胞证</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 缴费间隔  -->
<xsl:template match="PayIntv">
<xsl:choose>
	<xsl:when test=".=0">一次交清</xsl:when>		
	<xsl:when test=".=1">月交</xsl:when>
	<xsl:when test=".=3">季交</xsl:when>
	<xsl:when test=".=6">半年交</xsl:when>
	<xsl:when test=".=12">年交</xsl:when>
	<xsl:when test=".=-1">不定期交</xsl:when>
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

<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='L12079'">122012</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	<xsl:when test="$riskcode='L12073'">122029</xsl:when>	<!-- 安邦盛世5号终身寿险（万能型） -->
	
	<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122036'">122036</xsl:when>	<!-- 安邦黄金鼎6号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
	
	<!-- 50002-安邦长寿稳赢2号两全保险组合: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成 -->
	<xsl:when test="$riskcode='122046'">122046</xsl:when>	<!-- 安邦长寿稳赢1号两全保险 -->
	<xsl:when test="$riskcode='122047'">122047</xsl:when>	<!-- 安邦附加长寿稳赢两全保险 -->
	<xsl:when test="$riskcode='122048'">122048</xsl:when>	<!-- 安邦长寿添利终身寿险（万能型） -->
	
	<!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 begin -->
	<xsl:when test="$riskcode='L12070'">L12070</xsl:when>	<!-- 安邦长寿安享5号年金保险 -->
	<xsl:when test="$riskcode='L12071'">L12071</xsl:when>	<!-- 安邦附加长寿添利5号两全保险（万能型） -->
	<!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 end -->
	
	<!-- add by duanjz 2015-10-20 增加安邦长寿安享3号保险计划50011 begin -->
	<xsl:when test="$riskcode='L12068'">L12068</xsl:when>	<!-- 安邦长寿安享3号年金保险 -->
	<xsl:when test="$riskcode='L12069'">L12069</xsl:when>	<!-- 安邦附加长寿添利3号两全保险（万能型） -->
	<!-- add by duanjz 2015-10-20 增加安邦长寿安享3号保险计划50011 end -->
	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 产品组合编码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />

	<xsl:choose>
		<!-- 50002-安邦长寿稳赢2号两全保险组合: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成 -->
		<xsl:when test="$contPlanCode='122046'">50002</xsl:when>
	    <!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 begin -->
	    <xsl:when test="$contPlanCode='L12070'">50012</xsl:when>
	    <!-- add by duanjz 2015-6-18 增加安邦长寿安享5号保险计划50012 end -->
	    <!-- add by duanjz 2015-10-20 增加安邦长寿安享3号保险计划50012 begin -->
	    <xsl:when test="$contPlanCode='L12068'">50011</xsl:when>
	    <!-- add by duanjz 2015-10-20 增加安邦长寿安享3号保险计划50012 end -->
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
</xsl:stylesheet>
