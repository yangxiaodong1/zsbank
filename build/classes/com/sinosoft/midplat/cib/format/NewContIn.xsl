<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="INSU">
		<TranData>
			<!-- 报文头 -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/BANK_DATE"/></TranDate>
				<xsl:variable name ="time" select ="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6($time)"/></TranTime>
				<TellerNo><xsl:value-of select="MAIN/TELLERNO"/></TellerNo>
				<TranNo><xsl:value-of select="MAIN/TRANSRNO"/></TranNo>
				<NodeNo>
					<xsl:value-of select="MAIN/ZONENO"/>
					<xsl:value-of select="MAIN/BRNO"/>
				</NodeNo>
				<xsl:copy-of select="Head/*"/>
				<BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
			</Head>
			<Body>
				<xsl:apply-templates select="MAIN" />
				<!-- 投保人信息 -->
				<xsl:apply-templates select="TBR" />
				<!-- 被保险人信息 -->
				<xsl:apply-templates select="BBR" />
				<!-- 受益人信息 -->
				<xsl:apply-templates select="SYRS/SYR" />
				<!-- 险种信息 -->
				<xsl:apply-templates select="PRODUCTS/PRODUCT[PRODUCTID=MAINPRODUCTID]" />
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- 报文体 -->
	<xsl:template name="Body" match="MAIN">
		<xsl:variable name="MainRisk" select="../PRODUCTS/PRODUCT[PRODUCTID=MAINPRODUCTID]" />
		<ProposalPrtNo><xsl:value-of select="APPLYNO" /></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="BD_PRINT_NO" /></ContPrtNo>
		<PolApplyDate><xsl:value-of select="TB_DATE" /></PolApplyDate>
		<AccName><xsl:value-of select="PAYNAME" /></AccName>
		<AccNo><xsl:value-of select="PAYACC" /></AccNo>
		<GetPolMode></GetPolMode>
		<JobNotice><xsl:value-of select="../BBR/BBR_METIERDANGERINF" /></JobNotice>
		<HealthNotice><xsl:value-of select="../HEALTH_NOTICE/NOTICE_ITEM" /></HealthNotice>
		<PolicyIndicator></PolicyIndicator>
		<AgentComName><xsl:value-of select="BRNONAME" /></AgentComName>
		<AgentComCertiCode><xsl:value-of select="BRNOCERTCODE" /></AgentComCertiCode>
		<SellerNo><xsl:value-of select="MARKETER_ID" /></SellerNo>
		<TellerName><xsl:value-of select="MARKETER_NAME" /></TellerName>
		<TellerCertiCode><xsl:value-of select="MARKETER_CERTCODE" /></TellerCertiCode>
		<!-- 产品组合 -->
        <ContPlan>
			<ContPlanCode>
				<xsl:call-template name="tran_contPlancode">
					<xsl:with-param name="contPlancode">
						<xsl:value-of select="$MainRisk/MAINPRODUCTID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			
			<!-- 产品组合份数 -->
			<ContPlanMult>
				<xsl:if test="$MainRisk/MAINPRODUCTID = 50002">
					<xsl:value-of select="format-number($MainRisk/AMT_UNIT,'#')" />
				</xsl:if>
			</ContPlanMult>
        </ContPlan>
   </xsl:template>
   <!-- 投保人信息 -->
   <xsl:template name="Appnt" match="TBR">
	<Appnt>
		<Name><xsl:value-of select="TBR_NAME" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				 <xsl:with-param name="sex">
				 	<xsl:value-of select="TBR_SEX"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="TBR_BIRTH" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				 <xsl:with-param name="idtype">
				 	<xsl:value-of select="TBR_IDTYPE"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</IDType>
		<IDNo><xsl:apply-templates select="TBR_IDNO" /></IDNo>	
		<IDTypeStartDate><xsl:value-of select="TBR_IDEFFSTARTDATE" /></IDTypeStartDate>	
		<IDTypeEndDate><xsl:value-of select="TBR_IDEFFENDDATE" /></IDTypeEndDate>
		
		<JobCode><xsl:value-of select="TBR_OCCUTYPE" /></JobCode>
		<Nationality><xsl:value-of select="TBR_NATIVEPLACE"/></Nationality>
		<Stature></Stature>
		<Weight></Weight>
		<!-- 投保人年收入(银行元) -->
		<xsl:choose>
			<xsl:when test="TBR_REVENUE=''">
				<Salary />
			</xsl:when>
			<xsl:otherwise>
				<Salary>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_REVENUE)" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- 1.城镇，2.农村 -->
		<LiveZone><xsl:apply-templates select="TBR_RESIDENTS" /></LiveZone>
		<Address><xsl:value-of select="TBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="TBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="TBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="TBR_TEL" /></Phone>
		<RelaToInsured>
			<xsl:call-template name="tran_RelaToInsured">
				 <xsl:with-param name="relaToInsured">
				 	<xsl:value-of select="TBR_BBR_RELA"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</RelaToInsured>	
	</Appnt>
   </xsl:template>
    
    <!-- 被保险人信息 -->
    <xsl:template name="Insured" match="BBR">
    <Insured>
    	<Name><xsl:value-of select="BBR_NAME" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				 <xsl:with-param name="sex">
				 	<xsl:value-of select="BBR_SEX"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="BBR_BIRTH" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				 <xsl:with-param name="idtype">
				 	<xsl:value-of select="BBR_IDTYPE"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="BBR_IDNO" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="BBR_IDEFFSTARTDATE" /></IDTypeStartDate>	
		<IDTypeEndDate><xsl:value-of select="BBR_IDEFFENDDATE" /></IDTypeEndDate>
		<JobCode><xsl:value-of select="BBR_OCCUTYPE" /></JobCode>
		<Nationality><xsl:value-of  select="BBR_NATIVEPLACE" /></Nationality>
		<Stature></Stature>
		<Weight></Weight>
		<MaritalStatus></MaritalStatus>
		<Address><xsl:value-of select="BBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="BBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="BBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="BBR_TEL" /></Phone>
		<Email></Email>
    </Insured>
    </xsl:template>  
     <!-- 受益人信息 -->
    <xsl:template name="Bnf" match="SYRS/SYR">
    	<xsl:if test="SYR_BBR_RELA!=0">
    		<Bnf>
       		<!-- 默认为“1-身故受益人” -->
       		<Type>1</Type>
       		<Grade><xsl:value-of select="SYR_TEMP" /></Grade>
       		<Name><xsl:value-of select="SYR_NAME" /></Name>
       		<Sex>
       		<xsl:call-template name="tran_Sex">
				 <xsl:with-param name="sex">
				 	<xsl:value-of select="SYR_SEX"/>
			     </xsl:with-param>
			 </xsl:call-template>
       		</Sex>
       		<Birthday><xsl:value-of select="SYR_BIRTH" /></Birthday>
       		<IDType>
       		<xsl:call-template name="tran_IDType">
				 <xsl:with-param name="idtype">
				 	<xsl:value-of select="SYR_IDTYPE"/>
			     </xsl:with-param>
			 </xsl:call-template>
       		</IDType>
       		<IDNo><xsl:value-of select="SYR_IDNO" /></IDNo>
       		<IDTypeStartDate><xsl:value-of select="SYR_IDEFFSTARTDATE" /></IDTypeStartDate>	
       		<IDTypeEndDate><xsl:value-of select="SYR_IDEFFENDDATE" /></IDTypeEndDate>
       		<Nationality><xsl:value-of select="SYR_NATIVEPLACE" /></Nationality>
       		<RelaToInsured>
       		<xsl:call-template name="tran_RelaToInsured">
				 <xsl:with-param name="relaToInsured">
				 	<xsl:value-of select="SYR_BBR_RELA"/>
			     </xsl:with-param>
			 </xsl:call-template>
       		</RelaToInsured>
       		<Lot><xsl:value-of select="SYR_PCT" /></Lot>
       	</Bnf>
    	</xsl:if>
    </xsl:template>  
    <xsl:template name="Risk" match="PRODUCTS/PRODUCT[PRODUCTID=MAINPRODUCTID]">   
       <Risk>
       		<RiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
       		</RiskCode>
       		<MainRiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="MAINPRODUCTID" />
				</xsl:call-template>
       		</MainRiskCode>
       		<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMNT)" /></Amnt>
       		<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIUM)" /></Prem>
       		<Mult><xsl:value-of select="format-number(AMT_UNIT,'#')" /></Mult>
       		<PayMode><xsl:apply-templates select="//MAIN/PAYMODE" /></PayMode>
       		<PayIntv><xsl:apply-templates select="//MAIN/PAYMETHOD" /></PayIntv>
       		<InsuYearFlag><xsl:apply-templates select="COVERAGE_PERIOD" /></InsuYearFlag>
       		<!-- 保险年期年龄 -->
			<InsuYear>
				<xsl:if test="COVERAGE_PERIOD = '1'">106</xsl:if><!-- 保终身 -->
				<xsl:if test="COVERAGE_PERIOD != '1'">
					<xsl:value-of select="COVERAGE_YEAR" />
				</xsl:if>
			</InsuYear>
       		<!-- 缴费年期年龄标志 -->
			<xsl:choose>
				<xsl:when
					test="CHARGE_PERIOD = '1'">
					<!-- 趸交或交终身 -->
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:otherwise>
					<!-- 其他缴费年期 -->
					<PayEndYearFlag>
						<xsl:apply-templates select="CHARGE_PERIOD" />
					</PayEndYearFlag>
					<PayEndYear>
						<xsl:value-of select="CHARGE_YEAR" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>
       		<BonusGetMode><xsl:apply-templates select="DVDMETHOD" /></BonusGetMode>
       		<FullBonusGetMode></FullBonusGetMode>
       		<GetYearFlag></GetYearFlag>
       		<GetYear><xsl:value-of select="REVAGE" /></GetYear>
       		<GetIntv><xsl:apply-templates select="REVMETHOD" /></GetIntv>
       		<GetBankCode></GetBankCode>
       		<GetBankAccNo></GetBankAccNo>
       		<GetAccName></GetAccName>
       		<AutoPayFlag><xsl:value-of select="ALFLAG" /></AutoPayFlag>
       	</Risk>
	</xsl:template>
	<!-- 性别 -->
	<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$sex='1'">0</xsl:when><!-- 男 -->
			<xsl:when test="$sex='2'">1</xsl:when><!-- 女 -->
			<xsl:otherwise>-</xsl:otherwise><!-- 不确定 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型 -->
	<xsl:template name="tran_IDType">
	<xsl:param name="idtype">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$idtype='0'">0</xsl:when><!-- 居民身份证或临时身份证 -->
			<xsl:when test="$idtype='1'">8</xsl:when><!-- 企业客户营业执照 -->
			<xsl:when test="$idtype='2'">8</xsl:when><!-- 企业代码证 -->
			<xsl:when test="$idtype='3'">8</xsl:when><!-- 企业客户其他有效证件 -->
			<xsl:when test="$idtype='4'">2</xsl:when><!-- 军人身份证 -->
			<xsl:when test="$idtype='5'">8</xsl:when><!-- 武警身份证 -->
			<xsl:when test="$idtype='6'">8</xsl:when><!-- 港澳台居民有效身份证 -->
			<xsl:when test="$idtype='7'">1</xsl:when><!-- 外国护照 -->
			<xsl:when test="$idtype='8'">8</xsl:when><!-- 个人客户其他有效证件 -->
			<xsl:when test="$idtype='9'">1</xsl:when><!-- 中国护照 -->
			<xsl:when test="$idtype='A'">6</xsl:when><!-- 港澳居民来往内地通行证 -->
			<xsl:when test="$idtype='B'">7</xsl:when><!-- 台湾居民来往大陆通行证 -->
			<xsl:when test="$idtype='C'">8</xsl:when><!-- 外国人永久居留证 -->
		</xsl:choose>
	</xsl:template>
	<!-- 与被保险人关系 -->
	<xsl:template name="tran_RelaToInsured">
	<xsl:param name="relaToInsured" />
		<xsl:choose>
			<xsl:when test="$relaToInsured='0'"></xsl:when><!-- 法定 -->
			<xsl:when test="$relaToInsured='1'">00</xsl:when><!-- 本人 -->
			<xsl:when test="$relaToInsured='2'">02</xsl:when><!-- 配偶 -->
			<xsl:when test="$relaToInsured='3'">01</xsl:when><!-- 父母 -->
			<xsl:when test="$relaToInsured='4'">03</xsl:when><!-- 子女 -->
			<xsl:when test="$relaToInsured='5'">04</xsl:when><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	<!-- 投保人居民类型 -->
	<xsl:template match="TBR_RESIDENTS">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 城镇 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 农村 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费年期类型 -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 年缴 -->
			<xsl:when test=".='3'"></xsl:when><!-- 半年缴 -->
			<xsl:when test=".='4'"></xsl:when><!-- 季缴 -->
			<xsl:when test=".='5'">M</xsl:when><!-- 月缴 -->
			<xsl:when test=".='6'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='7'">A</xsl:when><!-- 终身缴费 -->
			<xsl:when test=".='8'"></xsl:when><!-- 不定期缴 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 保障年期类型1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">A</xsl:when><!-- 保终身 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 按年限保 -->
			<xsl:when test=".='3'">A</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test=".='4'">M</xsl:when><!-- 按月保 -->
			<xsl:when test=".='5'">D</xsl:when><!-- 按天保 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 领取方式 -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 月领 -->
			<xsl:when test=".='2'">12</xsl:when><!-- 年领 -->
			<xsl:when test=".='3'">0</xsl:when><!-- 趸领（一次性领取） -->
			<xsl:when test=".='4'"></xsl:when><!-- 固定期限平准式年领 -->
			<xsl:when test=".='5'"></xsl:when><!-- 6％算术递增式年领 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 红利领取方式 -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 累积生息 -->
			<xsl:when test=".='2'">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test=".='3'"></xsl:when><!-- 增额交清 -->
			<xsl:when test=".='4'"></xsl:when><!-- 现金领取 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费形式 -->
	<xsl:template match="PAYMODE">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 现金 -->
			<xsl:when test=".='1'">7</xsl:when><!-- 转帐 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费间隔1趸缴，5月缴，4季缴，3半年缴，2年缴 -->
	<xsl:template match="PAYMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='2'">12</xsl:when><!-- 年缴 -->
			<xsl:when test=".='3'">6</xsl:when><!-- 半年缴 -->
			<xsl:when test=".='4'">3</xsl:when><!-- 季缴 -->
			<xsl:when test=".='5'">1</xsl:when><!-- 月缴 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<!-- 盛世3号产品代码变更start -->
			<!-- PBKINSR-626 兴业银行银保通上线新产品（盛世3号） -->
			<!-- <xsl:when test="$riskcode='122010'">L12078</xsl:when> --><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
			<!-- 盛世3号产品代码变更end -->
			<!-- PBKINSR-909 兴业银行银保通增加产品—盛世2号 -->
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test="$riskcode='50002'">50015</xsl:when>
			<!-- 50002-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,122048 - 安邦长寿添利终身寿险（万能型） -->
			<!-- 50015-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,L12081 - 安邦长寿添利终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- 安邦盛世1号B款终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
			<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- 安邦东风3号两全保险（万能型） -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- 安邦东风2号两全保险（万能型） -->
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when>	<!-- 安邦东风9号两全保险（万能型） -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 产品组合代码 -->
	<xsl:template name="tran_contPlancode">
		<xsl:param name="contPlancode" />
		<xsl:choose>
			<!-- 50015-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,L12081 - 安邦长寿添利终身寿险（万能型） -->
			<xsl:when test="$contPlancode=50002">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
