<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="INSUREQ">
		<TranData>
			<!-- 报文头 -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/TRANSRDATE"/></TranDate>
				<TranTime><xsl:value-of select="MAIN/TRANSRTIME"/></TranTime>
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
				<xsl:apply-templates select="PRODUCTS/PRODUCT" />
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- 报文体 -->
	<xsl:template name="Body" match="MAIN">
		<ProposalPrtNo><xsl:value-of select="APPLNO" /></ProposalPrtNo>
		<ContPrtNo></ContPrtNo>	<!-- 印刷号在签单确认时银行传递 -->
		<PolApplyDate><xsl:value-of select="TB_DATE" /></PolApplyDate>
		<AccName><xsl:value-of select="../ACCOUNT_INFO/PAY_IN_ACC_NAME" /></AccName>
		<AccNo><xsl:value-of select="../ACCOUNT_INFO/PAY_IN_ACC" /></AccNo>
		<GetPolMode><xsl:apply-templates select="SENDMETHOD" /></GetPolMode>
		<JobNotice></JobNotice>
		<HealthNotice><xsl:value-of select="../HEALTH_NOTICE/NOTICE_ITEM" /></HealthNotice>
		<PolicyIndicator></PolicyIndicator>
		<AgentComName><xsl:value-of select="BRNA_NAME" /></AgentComName>
		<!--代理许可证-->
		<AgentComCertiCode><xsl:value-of select="AGENTCODE" /></AgentComCertiCode>
		<!--银行销售人员工号，保监会3号文增加该字段-->
		<SellerNo><xsl:value-of select="SELLERCODE" /></SellerNo>
		<!--银行销售人员名称-->
		<TellerName><xsl:value-of select="SELLERNAME" /></TellerName>
		<!-- 保险代理从业证书编号 -->
		<TellerCertiCode><xsl:value-of select="AGENTNO" /></TellerCertiCode>
		<!-- 产品组合 -->
        <ContPlan>
			<ContPlanCode>
				<xsl:call-template name="tran_contPlancode">
					<xsl:with-param name="contPlancode">
						<xsl:value-of select="../PRODUCTS/PRODUCT/PRODUCTID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			<!-- 产品组合份数 -->
			<ContPlanMult>
				<xsl:value-of select="format-number(../PRODUCTS/PRODUCT/AMT_UNIT,'#')" />
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
		<IDTypeStartDate></IDTypeStartDate>	
		<IDTypeEndDate></IDTypeEndDate>
		<JobCode>
			<xsl:call-template name="tran_JobCode">
				 <xsl:with-param name="jobCode">
				 	<xsl:value-of select="TBR_WORKCODE"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</JobCode>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				 <xsl:with-param name="nationality">
				 	<xsl:value-of select="TBR_NATION"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</Nationality>
		<Stature></Stature>
		<Weight></Weight>
		<!-- 投保人年收入(银行元) -->
		<xsl:choose>
			<xsl:when test="TBR_AVR_SALARY=''">
				<Salary />
			</xsl:when>
			<xsl:otherwise>
				<Salary>
					<xsl:value-of
						select="TBR_AVR_SALARY" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- 1.城镇，2.农村 -->
		<LiveZone><xsl:apply-templates select="TBR_RESEDTYPE" /></LiveZone>
		<Address><xsl:value-of select="TBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="TBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="TBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="TBR_TEL" /></Phone>
		<Email><xsl:value-of select="TBR_EMAIL" /></Email>
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
		<IDTypeStartDate></IDTypeStartDate>	
		<IDTypeEndDate></IDTypeEndDate>
		<JobCode>
			<xsl:call-template name="tran_JobCode">
				 <xsl:with-param name="jobCode">
				 	<xsl:value-of select="BBR_WORKCODE"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</JobCode>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				 <xsl:with-param name="nationality">
				 	<xsl:value-of select="BBR_NATION"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</Nationality>
		<Stature></Stature>
		<Weight></Weight>
		<MaritalStatus></MaritalStatus>
		<Address><xsl:value-of select="BBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="BBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="BBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="BBR_TEL" /></Phone>
		<Email><xsl:value-of select="BBR_EMAIL" /></Email>
		<Email></Email>
    </Insured>
    </xsl:template>  
     <!-- 受益人信息 -->
    <xsl:template name="Bnf" match="SYRS/SYR">
    <xsl:if test="SYR_BBR_RELA != '5'"><!-- 受益人为法人 -->
       	<Bnf>
       		<!-- 默认为“1-身故受益人” -->
       		<Type>1</Type>
       		<Grade><xsl:value-of select="SYR_ORDER" /></Grade>
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
       		<IDTypeStartDate></IDTypeStartDate>	
       		<IDTypeEndDate></IDTypeEndDate>
       		<Nationality></Nationality>
       		<RelaToInsured>
       		<xsl:call-template name="tran_RelaToInsured">
				 <xsl:with-param name="relaToInsured">
				 	<xsl:value-of select="SYR_BBR_RELA"/>
			     </xsl:with-param>
			 </xsl:call-template>
       		</RelaToInsured>
       		<Lot><xsl:value-of select="BNFT_PROFIT_PCENT" /></Lot>
       	</Bnf>
       	</xsl:if>
    </xsl:template>  
    <xsl:template name="Risk" match="PRODUCTS/PRODUCT">   
       <Risk>
       		<RiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
       		</RiskCode>
       		<MainRiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
       		</MainRiskCode>
       		<Amnt></Amnt>
       		<Prem><xsl:value-of select="PREMIUM" /></Prem>
       		<Mult><xsl:value-of select="format-number(AMT_UNIT,'#')" /></Mult>
       		<PayMode></PayMode>
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
  			<GetBankCode><xsl:value-of select="../ACCOUNT_INFO/PAY_OUT_ACC_BANK" /></GetBankCode>
      		<GetBankAccNo><xsl:value-of select="../ACCOUNT_INFO/PAY_OUT_ACC" /></GetBankAccNo>
      		<GetAccName><xsl:value-of select="../ACCOUNT_INFO/PAY_OUT_ACC_NAME" /></GetAccName>
       		<AutoPayFlag><xsl:value-of select="ALFLAG" /></AutoPayFlag>
       	</Risk>
	</xsl:template>
	<!-- 性别 -->
	<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$sex='1'">0</xsl:when><!-- 男 -->
			<xsl:when test="$sex='2'">1</xsl:when><!-- 女 -->
			<xsl:otherwise>--</xsl:otherwise><!-- 不确定 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 证件类型 -->
	<xsl:template name="tran_IDType">
	<xsl:param name="idtype">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$idtype='1'">0</xsl:when><!-- 居民身份证或临时身份证 -->
			<xsl:when test="$idtype='2'">2</xsl:when><!-- 军官证 -->
			<xsl:when test="$idtype='3'">1</xsl:when><!-- 护照 -->
			<xsl:when test="$idtype='4'">4</xsl:when><!-- 出生证 -->
			<xsl:when test="$idtype='5'">8</xsl:when><!-- 其它 -->
		</xsl:choose>
	</xsl:template>
	<!-- 国籍 -->
	<xsl:template name="tran_Nationality">
	<xsl:param name="nationality" />
		<xsl:choose>
			<xsl:when test="$nationality='0'">CHN</xsl:when><!-- 中国     -->
			<xsl:when test="$nationality='1'">AU</xsl:when><!-- 澳大利亚 -->
			<xsl:when test="$nationality='2'">GB</xsl:when><!-- 英国     -->
			<xsl:when test="$nationality='3'">JP</xsl:when><!-- 日本     -->
			<xsl:when test="$nationality='4'">US</xsl:when><!-- 美国     -->
			<xsl:when test="$nationality='5'">RU</xsl:when><!-- 俄罗斯   -->
			<xsl:when test="$nationality='6'">OTH</xsl:when><!-- 其他     -->  
		</xsl:choose>
	</xsl:template>
	
	<!-- 职业 -->
	<xsl:template name="tran_JobCode">
	<xsl:param name="jobCode" />
		<xsl:choose>
			<xsl:when test="$jobCode='4000001'">4010101</xsl:when><!-- 商业、服务人员              -->
			<xsl:when test="$jobCode='2000002'">2090104</xsl:when><!-- 教学人员                    -->
			<xsl:when test="$jobCode='2000003'">2080103</xsl:when><!-- 法律专业人员                -->
			<xsl:when test="$jobCode='2000004'">2070109</xsl:when><!-- 金融专业人员                -->
			<xsl:when test="$jobCode='4000005'">4030111</xsl:when><!-- 国家机关、事业、企业单位人员-->
			<xsl:when test="$jobCode='2000006'">2100106</xsl:when><!-- 新闻文学艺术工作人员        -->
			<xsl:when test="$jobCode='2000007'">2130101</xsl:when><!-- 宗教职业者                  -->  
			<xsl:when test="$jobCode='7000008'">7010103</xsl:when><!-- 军人                        -->
			<xsl:when test="$jobCode='2000009'">2090114</xsl:when><!-- 学生                        -->
			<xsl:when test="$jobCode='8000010'"></xsl:when><!-- 其它（待确认）                        -->			
		</xsl:choose>
	</xsl:template>
	
	<!-- 与被保险人关系 -->
	<xsl:template name="tran_RelaToInsured">
	<xsl:param name="relaToInsured" />
		<xsl:choose>
			<xsl:when test="$relaToInsured='1'">02</xsl:when><!-- 配偶 -->
			<xsl:when test="$relaToInsured='2'">01</xsl:when><!-- 父母 -->
			<xsl:when test="$relaToInsured='3'">03</xsl:when><!-- 子女 -->
			<xsl:when test="$relaToInsured='4'">04</xsl:when><!-- 亲属 -->
			<xsl:when test="$relaToInsured='5'">00</xsl:when><!-- 本人 -->
			<xsl:when test="$relaToInsured='6'">04</xsl:when><!-- 其他 -->
		</xsl:choose>
	</xsl:template>
	<!-- 投保人居民类型 -->
	<xsl:template match="TBR_RESEDTYPE">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 城镇 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 农村 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费年期类型0 无关，1 趸交，2 按年限交，3 交至某确定年龄，4 终生交费，5 不定期交 -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='0'"></xsl:when><!-- 无关 -->
			<xsl:when test=".='1'">Y</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 年缴 -->
			<xsl:when test=".='3'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='4'">A</xsl:when><!-- 终身缴费 -->
			<xsl:when test=".='5'"></xsl:when><!-- 不定期缴 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 保障年期类型0 无关，1 保终身，2 按年限保，3 保至某确定年龄，4 按月保，5 按天保 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='0'"></xsl:when><!-- 无关 -->
			<xsl:when test=".='1'">A</xsl:when><!-- 保终身 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 按年限保 -->
			<xsl:when test=".='3'">A</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test=".='4'">M</xsl:when><!-- 按月保 -->
			<xsl:when test=".='5'">D</xsl:when><!-- 按天保 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 领取方式1 月领 ，  2 年领 ，  3 趸领 -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 月领 -->
			<xsl:when test=".='2'">12</xsl:when><!-- 年领 -->
			<xsl:when test=".='3'">0</xsl:when><!-- 趸领（一次性领取） -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 红利领取方式0 现金给付 ，1抵交保费 ， 2累计生息 -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='0'"></xsl:when><!-- 现金领取 -->
			<xsl:when test=".='1'">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 累积生息 -->			
		</xsl:choose>
	</xsl:template>
	<!-- 保单递送方式 1 部门发送，2 邮寄，3 上门递送，4 银行柜台  -->
	<xsl:template match="SENDMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'"></xsl:when><!-- 部门发送 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 邮寄 -->
			<xsl:when test=".='3'"></xsl:when><!-- 上门递送 -->
			<xsl:when test=".='4'">2</xsl:when><!-- 银行柜台 -->				
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费方式Y：年交，M：月交，W：趸交 -->
	<xsl:template match="PAYMETHOD">
		<xsl:choose>
			<xsl:when test=".='Y'">12</xsl:when><!-- 年缴 -->
			<xsl:when test=".='M'">1</xsl:when><!-- 月缴 -->
			<xsl:when test=".='W'">0</xsl:when><!-- 趸缴 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode=50002">50015</xsl:when>
			<!-- 50002-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,122048 - 安邦长寿添利终身寿险（万能型） -->
			<!-- PBKINSR-785 江西农商银行，银保通这，新盛2、新盛3、鼎5新产品开发 -->
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when> 	<!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12078'">L12078</xsl:when> 	<!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12089'">L12089</xsl:when> 	<!-- 安邦盛世1号终身寿险（万能型）B款 -->
			<xsl:when test="$riskcode='122009'">122009</xsl:when> 	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
			<!-- PBKINSR-785 江西农商银行，银保通这，新盛2、新盛3、鼎5新产品开发 -->
			
			<!-- guoxl 2016.6.15 开始 -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when> 	<!-- 安邦东风5号两全保险（万能型） -->
			<!-- guoxl 2016.6.15 结束 -->
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 产品组合代码 -->
	<xsl:template name="tran_contPlancode">
		<xsl:param name="contPlancode" />
		<xsl:choose>
			<!-- 50002-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险,122048 - 安邦长寿添利终身寿险（万能型） -->
			<xsl:when test="$contPlancode=50002">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
