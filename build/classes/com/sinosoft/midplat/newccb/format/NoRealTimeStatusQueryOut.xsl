<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

<xsl:template match="/TranData">
	<TX>
		<xsl:copy-of select="Head" />
		<TX_BODY>
			<ENTITY>
				<xsl:apply-templates select="Body" />
			</ENTITY>
		</TX_BODY>
	</TX>
</xsl:template>

<xsl:template match="Body">
	<APP_ENTITY>
		<NRlTmInsPlyDtlTot_Num>
			<xsl:value-of select="Count" />
		</NRlTmInsPlyDtlTot_Num>
		<Detail_List>
			<xsl:for-each select="Detail">
				<Detail>
					<Cvr_ID>
						<xsl:apply-templates select="RiskCode" />
					</Cvr_ID>
					<Ins_BillNo>
						<xsl:value-of select="ProposalPrtNo" />
					</Ins_BillNo>
					
					<!-- 代理保险合约状态代码 -->
					
					<AcIsAR_StCd>
						<xsl:if test="NonRTContState='-1' or NonRTContState='06'">
							<xsl:call-template name="tran_State">
								<xsl:with-param name="contState">
									<xsl:value-of select="ContState" />
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="NonRTContState!='-1' and NonRTContState!='06'">
							<xsl:call-template name="tran_nonRTContState">
								<xsl:with-param name="nonRTContState">
									<xsl:value-of select="NonRTContState" />
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					<!-- 
						<xsl:call-template name="tran_State">
							<xsl:with-param name="contState">
								<xsl:value-of select="ContState" />
							</xsl:with-param>
							<xsl:with-param name="nonRTContState">
								<xsl:value-of select="NonRTContState" />
							</xsl:with-param>
						</xsl:call-template>
					-->
					</AcIsAR_StCd>
					 
					<Uwrt_Inf><xsl:value-of select="UWReasonContent" /></Uwrt_Inf>
					<Tot_InsPrem_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" /></Tot_InsPrem_Amt>
					<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" /></Ins_PyF_Amt>
					<!-- 缴费截止日期 该字段需要开发，目前核心没有该字段 -->
					<PyF_CODt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(NonRTPayEndDate)"/></PyF_CODt>
					<!-- add 20150820 新一代2.2版本增加  保险年期类别代码 -->
					<xsl:if test="RiskCode='122009'" ><Ins_Yr_Prd_CgyCd>03</Ins_Yr_Prd_CgyCd></xsl:if>
					<!-- 东风5号 -->
					<xsl:if test="RiskCode='L12087'" ><Ins_Yr_Prd_CgyCd>03</Ins_Yr_Prd_CgyCd></xsl:if>
					<xsl:if test="RiskCode!='122009' and RiskCode!='L12087'" >
					   <Ins_Yr_Prd_CgyCd>					
					     <xsl:call-template name="tran_PayEndYearFlag">
					       <xsl:with-param name="payEndYear" select="PayEndYear" />
					       <xsl:with-param name="payEndYearFlag" select="PayEndYearFlag" />
				         </xsl:call-template>
					   </Ins_Yr_Prd_CgyCd>
					</xsl:if>		
					<!-- add 20150820 新一代2.2版本增加  保险期限 -->
					<Ins_Ddln>
					   <xsl:if test="RiskCode='122046'" >999</xsl:if>
					   <xsl:if test="RiskCode!='122046'" >
					       <xsl:if test="InsuYearFlag='A'">999</xsl:if>
					        <xsl:if test="InsuYearFlag!='A'"><xsl:value-of select="InsuYear" /></xsl:if>  
					   </xsl:if>
					</Ins_Ddln>
					<!-- add 20150820 新一代2.2版本增加  保险周期代码 -->
					<Ins_Cyc_Cd><xsl:apply-templates select="InsuYearFlag" /></Ins_Cyc_Cd>
					<!-- add 20150820 新一代2.2版本增加  保费缴费方式代码 -->
					<InsPrem_PyF_MtdCd><xsl:apply-templates select="Payintv" mode="payintv"/></InsPrem_PyF_MtdCd>
					<!-- add 20150820 新一代2.2版本增加  保费缴费期数 -->
					<InsPrem_PyF_Prd_Num>
					    <xsl:if test="InsuYearFlag!='A'">
					       <xsl:if test="PayEndYear = '1000'">
					        <xsl:if test="Payintv = '0'">1</xsl:if>
					        <xsl:if test="Payintv != '0'"><xsl:value-of select="PayEndYear" /></xsl:if>      
					    </xsl:if>
					    <xsl:if test="PayEndYear != '1000'">
					       <xsl:value-of select="PayEndYear" />    
					    </xsl:if>
					    <!-- 
					    <xsl:choose>
							<xsl:when test="PayEndYear = '1000'">1</xsl:when>
							<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
						</xsl:choose>
					     -->
					    </xsl:if>
					    <xsl:if test="RiskCode='L12078'" >1</xsl:if>
					    <xsl:if test="RiskCode='L12100'" >1</xsl:if>
					    <xsl:if test="RiskCode='122010'" >1</xsl:if>
					    <xsl:if test="RiskCode='L12089'" >1</xsl:if>
					</InsPrem_PyF_Prd_Num>
					<!-- add 20150820 新一代2.2版本增加  保费缴费周期代码 -->
					<InsPrem_PyF_Cyc_Cd><xsl:apply-templates select="Payintv" mode="zhouqi"/></InsPrem_PyF_Cyc_Cd>
				</Detail>
			</xsl:for-each>
		</Detail_List>
	</APP_ENTITY>
</xsl:template>

<!-- 保单合约状态 FIXME 这部分需要与核心沟通确认码表映射关系 -->
<xsl:template name="tran_State">
	<xsl:param name="contState"></xsl:param>
	<xsl:choose><!-- 我司名称=银行名称 -->
		<xsl:when test="$contState='00'">076012</xsl:when>		<!-- 签单已回执=保单已有效，客户已签收 -->
		<xsl:when test="$contState='A'">076016</xsl:when>		<!-- 拒保、撤单=保险公司拒保(核保未通过) -->
		<xsl:when test="$contState='B'">076036</xsl:when>		<!-- 非实时保单已缴费待获取保单 -->
		<xsl:when test="$contState='C'">076023</xsl:when>		<!-- 当日撤单=当日撤单作废 -->
		<xsl:when test="$contState='WT'">076024</xsl:when>		<!-- 犹豫期内退保终止=犹豫期退保作废 -->
		<xsl:when test="$contState='02'">076025</xsl:when>		<!-- 退保终止=非犹豫期退保作废 -->
		<xsl:when test="$contState='01'">076030</xsl:when>		<!-- 满期终止=满期已给付 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="tran_nonRTContState">
	<xsl:param name="nonRTContState"></xsl:param>
	<xsl:choose><!-- 我司名称=银行名称 -->
		<xsl:when test="$nonRTContState='08'">076011</xsl:when>	<!-- 签单未回执=保单已有效，客户未签收 -->
		<xsl:when test="$nonRTContState='06'">076012</xsl:when>	<!-- 签单已回执=保单已有效，客户已签收 -->
		<xsl:when test="$nonRTContState='00'">076014</xsl:when>	<!-- 未处理=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='01'">076014</xsl:when>	<!-- 录入中=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='02'">076014</xsl:when>	<!-- 核保中=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='03'">076014</xsl:when>	<!-- 通知书待回复=保险公司已接收非实时核保信息 -->
		<xsl:when test="$nonRTContState='07'">076015</xsl:when>	<!-- 契撤=银行契撤作废 -->
		<xsl:when test="$nonRTContState='05'">076016</xsl:when>	<!-- 拒保、撤单=保险公司拒保(核保未通过) -->
		<xsl:when test="$nonRTContState='04'">076019</xsl:when>	<!-- 核保通过=非实时保单保险公司核保通过待缴费 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template match="RiskCode">
	<xsl:choose>
		<xsl:when test=".='122001'">122001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
		<xsl:when test=".='122002'">122002</xsl:when> <!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test=".='122003'">122003</xsl:when> <!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
		<xsl:when test=".='122004'">122004</xsl:when> <!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
		<xsl:when test=".='122005'">122005</xsl:when> <!-- 安邦黄金鼎3号两全保险（分红型）A款 -->
		<xsl:when test=".='122006'">122006</xsl:when> <!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
		<xsl:when test=".='122008'">122008</xsl:when> <!-- 安邦白玉樽1号终身寿险（万能型） -->
		<xsl:when test=".='122009'">122009</xsl:when> <!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
		<xsl:when test=".='L12079'">L12079</xsl:when> <!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test=".='L12078'">122010</xsl:when> <!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test=".='L12100'">122010</xsl:when> <!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test=".='L12074'">122035</xsl:when> <!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test=".='50015'">50002</xsl:when>   <!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test=".='122046'">50002</xsl:when>  <!-- 安邦长寿稳赢保险计划 -->
		<xsl:when test=".='L12052'">L12052</xsl:when> <!-- 安邦长寿智赢1号年金保险 -->
		<!-- add by duanz 2015-7-6 PBKINSR-694 增加安享5号产品  begin -->
		<xsl:when test=".='L12070'">50012</xsl:when>  <!-- 安邦长寿安享5号保险计划 -->
		<xsl:when test=".='50012'">50012</xsl:when>  <!-- 安邦长寿安享5号保险计划 -->
		<!-- add by duanz 2015-7-6 PBKINSR-694 增加安享5号产品  end -->
		<xsl:when test=".='L12089'">L12089</xsl:when>  <!-- 盛世1号B款 -->
		
		<!-- 新旧险种代码并存 -->
		<xsl:when test=".='122010'">122010</xsl:when> <!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test=".='122035'">122035</xsl:when> <!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test=".='50002'">50002</xsl:when>   <!-- 安邦长寿稳赢保险计划 -->
		
		<xsl:when test=".='L12087'">L12087</xsl:when> <!-- 安邦东风5号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>
<!-- 保单的缴费间隔/频次 -->
<xsl:template match="Payintv" mode="payintv">
	<xsl:choose>
		<xsl:when test=".='0'">02</xsl:when><!--	趸交 -->
		<xsl:when test=".='12'">03</xsl:when><!-- 年交 -->
		<xsl:when test=".='1'">03</xsl:when><!--	月交 -->
		<xsl:when test=".='3'">03</xsl:when><!--	季交 -->
		<xsl:when test=".='6'">03</xsl:when><!--	半年交 -->
		<xsl:when test=".='-1'">01</xsl:when><!-- 不定期交 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<xsl:template name="tran_PayEndYearFlag">
	<xsl:param name="payEndYear" />
	<xsl:param name="payEndYearFlag" />
	<xsl:choose>
		<xsl:when test="$payEndYearFlag='Y' and $payEndYear!='1000'">03</xsl:when><!--按周期 -->
		<xsl:when test="$payEndYearFlag='M'">03</xsl:when><!--按周期 -->
		<xsl:when test="$payEndYearFlag='D'">03</xsl:when><!--按周期 -->
		<xsl:when test="$payEndYearFlag='A'">05</xsl:when><!--终身 -->
		<xsl:when test="$payEndYearFlag='Y' and $payEndYear ='1000'">05</xsl:when><!--终身 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 缴费年期类型 -->
<xsl:template match="Payintv" mode="zhouqi">
	<xsl:choose>
		<xsl:when test=".='3'">0201</xsl:when><!--	季缴 -->
		<xsl:when test=".='6'">0202</xsl:when><!--	半年缴 -->
		<xsl:when test=".='12'">0203</xsl:when><!--	年缴 -->
		<xsl:when test=".='1'">0204</xsl:when><!--	月缴 -->
		<xsl:when test=".='0'">0100</xsl:when><!--	趸缴 -->
		<xsl:otherwise></xsl:otherwise><!--	其他 -->
	</xsl:choose>
</xsl:template>

<!-- 保险年期类型 -->
<xsl:template match="InsuYearFlag">
	<xsl:choose>
		<xsl:when test=".='Y'">03</xsl:when><!-- 按年 -->
		<xsl:when test=".='M'">04</xsl:when><!-- 按月 -->
		<xsl:when test=".='D'">05</xsl:when><!-- 按天 -->
		<xsl:when test=".='A'">03</xsl:when><!-- 按年 -->
		<xsl:otherwise>99</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
