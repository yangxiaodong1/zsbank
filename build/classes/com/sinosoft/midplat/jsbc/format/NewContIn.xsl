<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
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
				<xsl:apply-templates select="PRODUCTS/PRODUCT[MAINSUBFLG=1]" />
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- 报文体 -->
	<xsl:template name="Body" match="MAIN">
		<ProposalPrtNo><xsl:value-of select="APPLNO" /></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="BD_PRINT_NO" /></ContPrtNo>
		<PolApplyDate><xsl:value-of select="TB_DATE" /></PolApplyDate>
		<AccName><xsl:value-of select="../TBR/TBR_NAME" /></AccName>
		<AccNo><xsl:value-of select="PAYACC" /></AccNo>
		<!-- 保单获取方式 -->
		<GetPolMode><xsl:apply-templates select="SENDMETHOD" /></GetPolMode>
		<JobNotice></JobNotice>
		<HealthNotice><xsl:value-of select="../HEALTH_NOTICE/NOTICE_ITEM" /></HealthNotice>
		<!-- 未成年被保险人是否在其他保险公司投保身故保险 Y是N否 -->
		<PolicyIndicator>
			<xsl:if test="../ADD_AMOUNT = '' or ../ADD_AMOUNT = '0'">N</xsl:if>
			<xsl:if test="../ADD_AMOUNT != '' and ../ADD_AMOUNT != '0'">Y</xsl:if>
		</PolicyIndicator>
		<!--累计未成年人投保身故保额 这个金额字段比较特殊，单位是百元-->
		<xsl:choose>
			<xsl:when test="../ADD_AMOUNT=''">
				<InsuredTotalFaceAmount />
			</xsl:when>
			<xsl:when test="../ADD_AMOUNT=0">
				<InsuredTotalFaceAmount>
					<xsl:value-of select="../ADD_AMOUNT" />
				</InsuredTotalFaceAmount>
			</xsl:when>
			<xsl:otherwise>
				<InsuredTotalFaceAmount>
					<xsl:value-of select="../ADD_AMOUNT*0.01" />
				</InsuredTotalFaceAmount>
			</xsl:otherwise>
		</xsl:choose>
		<AgentComName><xsl:value-of select="BRNAME" /></AgentComName>
		<!-- 网点销售资格证号 -->
		<AgentComCertiCode></AgentComCertiCode>
		<!-- 销售人员工号 -->
		<SellerNo><xsl:value-of select="FINANCIALNO" /></SellerNo>
		<TellerName><xsl:value-of select="FINANCIALNAME " /></TellerName>
		<!-- 销售人员资格证号 -->
		<TellerCertiCode></TellerCertiCode>
		<!-- 产品组合 -->
        <ContPlan>
			<ContPlanCode>
			</ContPlanCode>
			<!-- 产品组合份数 -->
			<ContPlanMult>
			</ContPlanMult>
        </ContPlan>
   </xsl:template>
   
   <!-- 投保人信息 -->
   <xsl:template name="Appnt" match="TBR">
	<Appnt>
		<Name><xsl:value-of select="TBR_NAME" /></Name>
		<Sex>
			<xsl:apply-templates select="TBR_SEX" />			
		</Sex>
		<Birthday><xsl:value-of select="TBR_BIRTH" /></Birthday>
		<IDType>
			<xsl:apply-templates select="TBR_IDTYPE"/>
		</IDType>
		<IDNo><xsl:apply-templates select="TBR_IDNO" /></IDNo>	
		<IDTypeStartDate><xsl:value-of select="TBR_IDEFFSTARTDATE" /></IDTypeStartDate>	
		<IDTypeEndDate><xsl:value-of select="TBR_IDEFFENDDATE" /></IDTypeEndDate>
		<JobCode>
			<xsl:apply-templates select="TBR_WORKCODE"/>
		</JobCode>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality">
					<xsl:value-of select="TBR_NATIVEPLACE"/>
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
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_AVR_SALARY)" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- 投保人家庭收入(银行元) -->
		<xsl:choose>
			<xsl:when test="TBR_HOMEAVR_SALARY=''">
				<FamilySalary />
			</xsl:when>
			<xsl:otherwise>
				<FamilySalary>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_HOMEAVR_SALARY)" />
				</FamilySalary>
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- 1.城镇，2.农村 -->
		<LiveZone><xsl:apply-templates select="TBR_ZONE" /></LiveZone>
		<Address><xsl:value-of select="TBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="TBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="TBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="TBR_FTEL" /></Phone>
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
			<xsl:apply-templates select="BBR_SEX" />			
		</Sex>
		<Birthday><xsl:value-of select="BBR_BIRTH" /></Birthday>
		<IDType>
			<xsl:apply-templates select="BBR_IDTYPE"/>
		</IDType>
		<IDNo><xsl:value-of select="BBR_IDNO" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="BBR_IDEFFSTARTDATE" /></IDTypeStartDate>	
		<IDTypeEndDate><xsl:value-of select="BBR_IDEFFENDDATE" /></IDTypeEndDate>
		<JobCode>
			<xsl:apply-templates select="BBR_WORKCODE" />
		</JobCode>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				<xsl:with-param name="nationality">
					<xsl:value-of select="BBR_NATIVEPLACE"/>
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
    </Insured>
    </xsl:template>
    
	<!-- 受益人信息 -->
	<xsl:template name="Bnf" match="SYRS/SYR">
    	<xsl:if test="SYR_BBR_RELA!=0">
    		<Bnf>
       		<!-- 默认为“1-身故受益人” -->
       		<Type>1</Type>
       		<Grade><xsl:value-of select="SYR_ORDER" /></Grade>
       		<Name><xsl:value-of select="SYR_NAME" /></Name>
       		<Sex>
				<xsl:apply-templates select="SYR_SEX" />			
			</Sex>
       		<Birthday><xsl:value-of select="SYR_BIRTH" /></Birthday>
       		<IDType>
	       		<xsl:apply-templates select="SYR_IDTYPE"/>
       		</IDType>
       		<IDNo><xsl:value-of select="SYR_IDNO" /></IDNo>
       		<IDTypeStartDate><xsl:value-of select="SYR_IDEFFSTARTDATE" /></IDTypeStartDate>	
       		<IDTypeEndDate><xsl:value-of select="SYR_IDEFFENDDATE" /></IDTypeEndDate>
       		<Nationality>
				<xsl:call-template name="tran_Nationality">
					<xsl:with-param name="nationality">
						<xsl:value-of select="SYR_NATIVEPLACE"/>
					</xsl:with-param>
				</xsl:call-template>
			</Nationality>
       		<RelaToInsured>
	       		<xsl:call-template name="tran_RelaToInsured">
					 <xsl:with-param name="relaToInsured">
					 	<xsl:value-of select="SYR_BBR_RELA"/>
				     </xsl:with-param>
				 </xsl:call-template>
       		</RelaToInsured>
       		<Lot><xsl:value-of select="BNFT_PROFIT_PCENT" /></Lot>
       		<Address><xsl:value-of select="SYR_ADDRESS" /></Address>
       	</Bnf>
    	</xsl:if>
    </xsl:template>
    
    <!-- 险种信息 -->
    <xsl:template name="Risk" match="PRODUCTS/PRODUCT[MAINSUBFLG=1]">   
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
       		<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMOUNT)" /></Amnt>
       		<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIUM)" /></Prem>
       		<Mult><xsl:value-of select="format-number(AMT_UNIT,'#')" /></Mult>
       		<!-- 交费形式:现金缴费，银行转账 -->
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
				<xsl:when test="CHARGE_PERIOD = '1'">
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
	<xsl:template match="TBR_SEX|BBR_SEX|SYR_SEX">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- 男性 -->
			<xsl:when test=".='2'">1</xsl:when><!-- 女性 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 证件类型 -->
	<!-- 银行证件类型：1 身份证，2 军人证，3 护照，5 其它  -->
	<xsl:template match="TBR_IDTYPE|BBR_IDTYPE|SYR_IDTYPE">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- 居民身份证或临时身份证 -->
			<xsl:when test=".='2'">2</xsl:when><!-- 军人身份证 -->
			<xsl:when test=".='3'">1</xsl:when><!-- 护照 -->
			<xsl:when test=".='5'">8</xsl:when><!-- 其他 -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 与被保险人关系 -->
	<xsl:template name="tran_RelaToInsured">
	<xsl:param name="relaToInsured" />
		<xsl:choose>
			<xsl:when test="$relaToInsured='7'"></xsl:when><!-- 法定 -->
			<xsl:when test="$relaToInsured='5'">00</xsl:when><!-- 本人 -->
			<xsl:when test="$relaToInsured='1'">02</xsl:when><!-- 配偶 -->
			<xsl:when test="$relaToInsured='2'">01</xsl:when><!-- 父母 -->
			<xsl:when test="$relaToInsured='3'">03</xsl:when><!-- 子女 -->
			<xsl:when test="$relaToInsured='4'">04</xsl:when><!-- 其他 -->
			<xsl:otherwise>04</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 投保人居民类型 -->
	<xsl:template match="TBR_ZONE">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- 城镇 -->
			<xsl:when test=".='2'">2</xsl:when><!-- 农村 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 缴费年期类型 -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='2'">Y</xsl:when><!-- 年缴 -->
			<xsl:when test=".='3'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='4'">A</xsl:when><!-- 终身缴费 -->
			<xsl:when test=".='5'"></xsl:when><!-- 不定期缴 -->
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
		</xsl:choose>
	</xsl:template>
	
	<!-- FIXME 该部分银行字典有问题，需要和银行确认 -->
	<!-- 红利领取方式 -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='2'">1</xsl:when><!-- 累积生息 -->
			<xsl:when test=".='1'">3</xsl:when><!-- 抵交保费 -->
			<xsl:when test=".='3'">4</xsl:when><!-- 现金领取 -->
			<xsl:when test=".='0'">4</xsl:when><!-- 现金领取 -->
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
			<xsl:when test=".='5'">0</xsl:when><!-- 趸缴 -->
			<xsl:when test=".='1'">12</xsl:when><!-- 年缴 -->
			<xsl:when test=".='2'">6</xsl:when><!-- 半年缴 -->
			<xsl:when test=".='3'">3</xsl:when><!-- 季缴 -->
			<xsl:when test=".='4'">1</xsl:when><!-- 月缴 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 保单递送方式 -->
	<!-- 银行：1 部门发送，2 邮寄，3 上门递送，4 银行柜台 -->
	<!-- 核心：1	邮寄，2	银行柜面领取 -->
	<xsl:template match="SENDMETHOD">
		<xsl:choose>
		    <xsl:when test=".=2">1</xsl:when>	  <!-- 邮寄 -->
			<xsl:when test=".=4">2</xsl:when>	  <!-- 银行柜面领取 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 职业代码 -->
	<!-- 银行职业代码：A-国家机关、党群组织、企业、事业单位人员
		B-卫生专业技术人员
		C-金融业务人员
		D-法律专业人员
		E-教学人员
		F-新闻出版及文学艺术工作人员
		G-宗教职业者
		H-邮政和电信业务人员
		I-商业、服务业人员
		J-农、林、牧、渔、水利业生产人员
		K-运输人员 
		L-地质勘测人员
		M-工程施工人员
		N-加工制造、检验及计量人员
		O-军人
		P-无业
	 -->
	<xsl:template match="TBR_WORKCODE|BBR_WORKCODE">
		<xsl:choose>
		    <xsl:when test=".='A'">4030111</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位人员 -->
			<xsl:when test=".='B'">2050101</xsl:when>	<!-- 卫生专业技术人员 -->
			<xsl:when test=".='C'">2070109</xsl:when>	<!-- 金融业务人员 -->
			<xsl:when test=".='D'">2080103</xsl:when>	<!-- 法律专业人员 -->
			<xsl:when test=".='E'">2090104</xsl:when>	<!-- 教学人员 -->
			<xsl:when test=".='F'">2100106</xsl:when>	<!-- 新闻出版及文学艺术工作人员 -->
			<xsl:when test=".='G'">2130101</xsl:when>	<!-- 宗教职业者 -->
			<xsl:when test=".='H'">3030101</xsl:when>	<!-- 邮政和电信业务人员 -->
			<xsl:when test=".='I'">4010101</xsl:when>	<!-- 商业、服务业人员 -->
			<xsl:when test=".='J'">5010107</xsl:when>	<!-- 农、林、牧、渔、水利业生产人员 -->
			<xsl:when test=".='K'">6240105</xsl:when>	<!-- 运输人员 -->
			<xsl:when test=".='L'">2020103</xsl:when>	<!-- 地址勘探人员 -->
			<xsl:when test=".='M'">2020906</xsl:when>	<!-- 工程施工人员 -->
			<xsl:when test=".='N'">6050611</xsl:when>	<!-- 加工制造、检验及计量人员 -->
			<xsl:when test=".='O'">7010103</xsl:when>	<!-- 军人 -->
			<xsl:when test=".='P'">8010101</xsl:when>	<!-- 无业 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 国籍转换 -->
	<xsl:template name="tran_Nationality">
		<xsl:param name="nationality">0</xsl:param>
		<xsl:choose>		
			<xsl:when test="$nationality = '1'">CHN</xsl:when> <!-- 中国  -->
			<xsl:when test="$nationality = '2'">OTH</xsl:when> <!-- 其他  -->
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
