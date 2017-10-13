<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="TranData/BaseInfo" />
	
	<Body>
		<xsl:apply-templates select="TranData/LCCont" />
		
		<!-- 投保人 -->
		<xsl:apply-templates select="TranData/LCCont/LCAppnt" />
		
		<!-- 被保人(1人) -->
		<xsl:apply-templates select="TranData/LCCont/LCInsureds/LCInsured" />
		
		<xsl:variable name ="count" select ="TranData/LCCont/LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/LCBnfs/LCBnfCount"/>
		<xsl:if test="$count!=0">
			<xsl:for-each select="TranData/LCCont/LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/LCBnfs/LCBnf">
					<!-- 受益人 -->
				<Bnf>
					<Type><xsl:value-of select="BnfType" /></Type>	
					<Grade><xsl:value-of select="BnfGrade" /></Grade>
					<Name><xsl:value-of select="Name" /></Name>
					<Sex><xsl:value-of select="Sex" /></Sex>
					<Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Birthday)" /></Birthday>
					<IDType><xsl:call-template name="tran_IDType">
						 <xsl:with-param name="idtype">
						 	<xsl:value-of select="IDType"/>
					     </xsl:with-param>
					  </xsl:call-template></IDType>
					<IDNo><xsl:value-of select="IDNo" /></IDNo>
					<Lot><xsl:value-of select="BnfLot" /></Lot>	
					<RelaToInsured>
						<xsl:call-template name="tran_RelationToInsured">
							<xsl:with-param name="relationToInsured">
								<xsl:value-of select="RelationToInsured"/>
							</xsl:with-param>
				   </xsl:call-template>
					</RelaToInsured>
				</Bnf>
		</xsl:for-each>
		</xsl:if>
		
		<!-- 险种 -->
		
		<xsl:for-each select="TranData/LCCont/LCInsureds/LCInsured/Risks/Risk">
		<Risk>
			<RiskCode>
			<xsl:call-template name="tran_RiskCode">
				<xsl:with-param name="riskCode">
					<xsl:value-of select="RiskCode" />
				</xsl:with-param>
			</xsl:call-template>
			<!-- <xsl:apply-templates select="RiskCode" />  -->
			</RiskCode>
			<MainRiskCode>
			<xsl:call-template name="tran_RiskCode">
				<xsl:with-param name="riskCode">
					<xsl:value-of select="MainRiskCode" />
				</xsl:with-param>
			</xsl:call-template>
			<!-- <xsl:apply-templates select="MainRiskCode" />  -->
			</MainRiskCode>
			<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)" /></Amnt>
			<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)" /></Prem>
		    <Mult>
		    	<xsl:value-of select="format-number(Mult,'#')" />
		   </Mult>
			<PayMode>
			<xsl:call-template name="tran_PayMode">
							<xsl:with-param name="payMode">
								<xsl:value-of select="PayMode"/>
							</xsl:with-param>
				   </xsl:call-template>
			</PayMode>
			<PayIntv><xsl:apply-templates select="PayIntv" /></PayIntv>
			<PayEndYearFlag><xsl:apply-templates select="PayEndYearFlag" /></PayEndYearFlag>
			<PayEndYear>
				<xsl:variable name ="payIntv" select ="PayIntv"/>
				<xsl:choose>
					<xsl:when test="$payIntv = 0">1000</xsl:when>
					<xsl:otherwise><xsl:apply-templates select="PayEndYear" /></xsl:otherwise>
				</xsl:choose>
			
			</PayEndYear>
			<InsuYearFlag><xsl:apply-templates select="InsuYearFlag" /></InsuYearFlag>
			<InsuYear><xsl:apply-templates select="InsuYear" /></InsuYear>
			<BonusGetMode><xsl:apply-templates select="BonusGetMode" /></BonusGetMode>
			<FullBonusGetMode><xsl:apply-templates select="FullBonusGetMode" /></FullBonusGetMode>
			<GetYearFlag><xsl:apply-templates select="GetYearFlag" /></GetYearFlag>
			<GetYear><xsl:apply-templates select="GetYear" /></GetYear>
			<GetIntv><xsl:apply-templates select="GetIntv" /></GetIntv>
			<GetBankCode><xsl:apply-templates select="GetBankCode" /></GetBankCode>
			<GetBankAccNo><xsl:apply-templates select="GetBankAccNo" /></GetBankAccNo>
			<GetAccName><xsl:apply-templates select="GetAccName" /></GetAccName>
			<AutoPayFlag><xsl:apply-templates select="AutoPayFlag" /></AutoPayFlag>
		</Risk>
		</xsl:for-each>
	
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="BaseInfo">
<Head>
	<TranDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(BankDate)"/></TranDate>
	<xsl:variable name ="time" select ="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
	<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6($time)"/></TranTime>
	<TellerNo><xsl:value-of select="TellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="TransrNo"/></TranNo>
	<NodeNo>
		<xsl:value-of select="ZoneNo"/>
		<xsl:value-of select="BrNo"/>
	</NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<xsl:template name="Body" match="LCCont">
	<!-- 投保单号 -->
	<ProposalPrtNo><xsl:value-of select="ProposalContNo" /></ProposalPrtNo>
	<!-- 保单合同印刷号 -->
	<ContPrtNo><xsl:value-of select="PrtNo" /></ContPrtNo>
	<!-- 投保日期 -->
	<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(PolApplyDate)"/></PolApplyDate>
	<!-- 网点分管代理保险业务负责人编号 -->
	<ManagerNo></ManagerNo>
	<!-- 网点分管代理保险业务负责人姓名 -->
	<ManagerName></ManagerName>
	<!-- 银行销售人员工号，保监会3号文增加该字段 -->
	<SellerNo><xsl:value-of select="BankAgentCode" /></SellerNo>
	<!-- 出单网点名称 -->
	<AgentComName><xsl:value-of select="../BaseInfo/BrName" /></AgentComName>
	<!-- 出单网点资格证 -->
	<AgentComCertiCode></AgentComCertiCode>
	<!-- 销售员工姓名 -->
	<TellerName><xsl:value-of select="BankAgentName" /></TellerName>
	<!--银行销售人员资格证-->
	<TellerCertiCode></TellerCertiCode> 
	
	<!-- 账户姓名，银行默认投保人姓名即为账户姓名 -->
	<AccName><xsl:value-of select="LCAppnt/AppntName" /></AccName>
	<!-- 银行账户 -->
	<AccNo><xsl:value-of select="BankAccNo" /></AccNo>
	<!-- 保单递送方式 -->
	<GetPolMode><xsl:value-of select="GetPolMode" /></GetPolMode>
	<!-- 职业告知(N/Y) -->
	<JobNotice/>
	<!-- 健康告知(N/Y)  -->
	<HealthNotice><xsl:value-of select="LCInsureds/LCInsured/TellInfos/HealthFlag" /></HealthNotice>
	<!-- 产品组合 -->
        <ContPlan>
        	<!-- 产品组合编码 -->
        	<xsl:variable name="mainRiskCode" select="LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/RiskCode"/>
			<ContPlanCode>
				<xsl:call-template name="tran_ContPlanCode">
					<xsl:with-param name="contPlanCode">
						<xsl:value-of select="$mainRiskCode" />
					</xsl:with-param>
				</xsl:call-template>
			<!-- 	<xsl:if test="$mainRiskCode = 50002">
					<xsl:value-of select="$mainRiskCode" />
				</xsl:if>   -->
			</ContPlanCode>
			
			<!-- 产品组合份数 -->
			<ContPlanMult>
				<xsl:value-of select="format-number(LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/Mult,'#')" />
			<!-- 	<xsl:if test="$mainRiskCode = 50002">
					<xsl:value-of select="format-number(LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/Mult,'#')" />
					
				</xsl:if>   -->
			</ContPlanMult>
        </ContPlan>
</xsl:template>

<!-- 投保人 -->
<xsl:template name="Appnt" match="LCAppnt">

<Appnt>
	<Name><xsl:value-of select="AppntName" /></Name>
	<Sex><xsl:value-of select="AppntSex" /></Sex>
	<Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(AppntBirthday)" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype">
						<xsl:value-of select ="AppntIDType"/>
					</xsl:with-param>
		</xsl:call-template></IDType>
	<IDNo><xsl:value-of select="AppntIDNo" /></IDNo>
	<IDTypeStartDate/>
	<IDTypeEndDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(AppntIDEndDate)" /></IDTypeEndDate>	
	<JobCode>
	<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode">
						<xsl:value-of select ="AppntJobCode"/>
					</xsl:with-param>
		</xsl:call-template>
	</JobCode>
	<!-- 投保人年收入，银行方单位:分，核心端单位：分 -->
	<xsl:choose>
		<xsl:when test="AppntWage=''">
			<Salary />
		</xsl:when>
		<xsl:otherwise>
			<Salary>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AppntWage)" />
			</Salary>
		</xsl:otherwise>
	</xsl:choose>
	<!-- 投保人家庭年收入，银行方单位:分，核心端单位：分 -->	
	<FamilySalary></FamilySalary>
	<!-- 投保人所属区域 1：城镇，2：农村-->
	<LiveZone>
	<xsl:call-template name="tran_livezone">
					<xsl:with-param name="livezone">
						<xsl:value-of select ="CityType"/>
					</xsl:with-param>
		</xsl:call-template>
	</LiveZone>
	<!-- 国籍 -->
	<Nationality>
	<xsl:call-template name="tran_nationality">
					<xsl:with-param name="nationality">
						<xsl:value-of select ="AppntNativePlace"/>
					</xsl:with-param>
		</xsl:call-template>
	</Nationality>
	<!-- 身高cm -->
	<Stature>
	
	<xsl:value-of	select="AppntStature" /></Stature>
	<!-- 体重kg -->
	<Weight><xsl:value-of	select="AppntAvoirdupois" /></Weight>
	
	<Address><xsl:value-of	select="MailAddress" /></Address>
    <ZipCode><xsl:value-of	select="MailZipCode" /></ZipCode>
    <Mobile><xsl:value-of select="AppntMobile" /></Mobile>
    <Phone><xsl:value-of select="AppntOfficePhone" /></Phone>
    <Email><xsl:value-of select="AppntEmail" /></Email>
  <!--   <RelaToInsured>00</RelaToInsured>  -->
    <RelaToInsured>
		<xsl:call-template name="tran_RelationRoleCode">
			<xsl:with-param name="relationRoleCode">
				<xsl:value-of select="../LCInsureds/LCInsured/RelaToAppnt"/>
			</xsl:with-param>
   		</xsl:call-template>
	</RelaToInsured>
</Appnt>
</xsl:template>

<!-- 被保人 -->
<xsl:template name="Insured" match="LCInsured">
<Insured>
	<Name><xsl:value-of select="Name"/></Name> <!-- 姓名 -->
      <Sex><xsl:value-of select="Sex"/></Sex> <!-- 性别 -->
      <Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Birthday)" /></Birthday>
      <IDType>
      <xsl:call-template name="tran_IDType">
		 <xsl:with-param name="idtype">
		 	<xsl:value-of select="IDType"/>
	     </xsl:with-param>
	  </xsl:call-template>
      </IDType> <!-- 证件类型 -->
      <IDNo><xsl:value-of select="IDNo"/></IDNo> <!-- 证件号码 -->
      <IDTypeStartDate></IDTypeStartDate > <!-- 证件有效起期 -->
      <IDTypeEndDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(IDEndDate)" /></IDTypeEndDate>
      <!-- 国籍 -->
	<Nationality>
	<xsl:call-template name="tran_nationality">
					<xsl:with-param name="nationality">
						<xsl:value-of select ="NativePlace"/>
					</xsl:with-param>
		</xsl:call-template>
	</Nationality>
	<MaritalStatus></MaritalStatus> <!-- 婚否(N/Y) -->
	<!-- 身高cm -->
	<Stature>
		<xsl:variable name ="stature" select ="Stature"/>
		<xsl:choose>
			<xsl:when test="$stature = 0.0"></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="Stature" /></xsl:otherwise>
		</xsl:choose>
	</Stature>
	<!-- 体重kg -->
	<Weight>
		<xsl:variable name ="avoirdupois" select ="Avoirdupois"/>
		<xsl:choose>
			<xsl:when test="$avoirdupois = 0.0"></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="Avoirdupois" /></xsl:otherwise>
		</xsl:choose></Weight>
      <JobCode>
       <xsl:call-template name="tran_jobcode">
		  <xsl:with-param name="jobcode">
			 <xsl:value-of select="JobCode" />
		  </xsl:with-param>
      </xsl:call-template>
      </JobCode> <!-- 职业代码 -->
  	  <Address><xsl:value-of select="MailAddress"/></Address>
	  <ZipCode><xsl:value-of select="MailZipCode"/></ZipCode>
	  <Mobile><xsl:value-of select="Mobile"/></Mobile>
	  <Phone><xsl:value-of select="Phone"/></Phone>
	  <Email><xsl:value-of select="Email"/></Email>
</Insured>
</xsl:template>

 <!-- 产品组合代码 -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<!-- PBKINSR-673 北京银行盛2、盛3、50002产品升级 -->
		<!-- 50002-安邦长寿稳赢保险计划:主险：122046 - 安邦长寿稳赢1号两全保险, 附加险：122047 - 安邦附加长寿稳赢两全保险 , 122048-安邦长寿添利终身寿险（万能型）-->
		<xsl:when test="$contPlanCode='50002'">50015</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 险种代码，该文件并未使用转换，只是记录以上线的险种 -->
<xsl:template name="tran_RiskCode">
	<xsl:param name="riskCode" />
	<xsl:choose>
		<!-- PBKINSR-673 北京银行盛2、盛3、50002产品升级 -->
		<xsl:when test="$riskCode='50002'">50015</xsl:when><!-- 安邦长寿稳赢保险计划 -->			
		<xsl:when test="$riskCode='122010'">L12100</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskCode='122012'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
		
		<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型） -->
		<xsl:when test="$riskCode='L12074'">L12074</xsl:when><!-- 安邦盛世9号两全保险（万能型） -->
		<xsl:when test="$riskCode='L12091'">L12091</xsl:when><!-- 安邦汇赢1号年金保险A款 -->
		<!-- <xsl:when test="$riskCode='L12085'">L12085</xsl:when> --><!-- 安邦东风2号两全保险（万能型） -->
		<!-- <xsl:when test="$riskCode='L12086'">L12086</xsl:when> --><!-- 安邦东风3号两全保险（万能型） -->
		<!-- <xsl:when test="$riskCode='L12088'">L12088</xsl:when> --><!-- 安邦东风9号两全保险（万能型） -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 证件类型 -->

<!-- 核心：0	居民身份证,1 护照,2 军官证,3 驾照,4 出生证明,5	户口簿,8	其他,9	异常身份证 -->
<xsl:template name="tran_IDType">
<xsl:param name="idtype">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$idtype='0'">0</xsl:when><!-- 身份证 -->
		<xsl:when test="$idtype='1'">1</xsl:when><!-- 护照 -->
		<xsl:when test="$idtype='2'">2</xsl:when><!-- 军官证 -->
		<xsl:when test="$idtype='3'">5</xsl:when><!-- 户口簿 -->
		<xsl:when test="$idtype='4'">8</xsl:when><!-- 港澳台通行证 -->
		<xsl:when test="$idtype='5'">8</xsl:when><!-- 武警身份证 -->
		<xsl:when test="$idtype='6'">8</xsl:when><!-- 边民出入境通行证 -->
	</xsl:choose>
</xsl:template>

<!-- 职业代码 -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode= '001'">1010106</xsl:when><!-- 国家机关、党群组织、企业、事业单位人员-->
		<xsl:when test="$jobcode= '002'">2050601</xsl:when><!-- 卫生专业技术人员                      -->
		<xsl:when test="$jobcode= '003'">2070502</xsl:when><!-- 金融业务人员???                       -->
		<xsl:when test="$jobcode= '004'">2080103</xsl:when><!-- 法律专业人员                          -->
		<xsl:when test="$jobcode= '005'">2090101</xsl:when><!-- 教学人员                              -->
		<xsl:when test="$jobcode= '006'">2120109</xsl:when><!-- 新闻出版及文学艺术工作人员            -->
		<xsl:when test="$jobcode= '007'">2130101</xsl:when><!-- 宗教职业者                            -->
		<xsl:when test="$jobcode= '008'">3030101</xsl:when><!-- 邮政和电信业务人员                    -->
		<xsl:when test="$jobcode= '009'">9210102</xsl:when><!-- 商业、服务业人员                      -->
		<xsl:when test="$jobcode= '010'">5050104</xsl:when><!-- 农、林、牧、渔、水利业生产人员        -->
		<xsl:when test="$jobcode= '011'">6240107</xsl:when><!-- 运输人员??                            -->
		<xsl:when test="$jobcode= '012'">2020101</xsl:when><!-- 地质勘测人员                          -->
		<xsl:when test="$jobcode= '013'">6230911</xsl:when><!-- 工程施工人员?                         -->
		<xsl:when test="$jobcode= '014'">6050908</xsl:when><!-- 加工制造、检验及计量人员              -->
		<xsl:when test="$jobcode= '015'">7010121</xsl:when><!-- 军人                                  -->
		<xsl:when test="$jobcode= '016'">8010101</xsl:when><!-- 无业                                  -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 投保人城乡类型 TBR_LIVEZONE -->
<xsl:template name="tran_livezone">
<xsl:param name="livezone" />
<xsl:choose>
	<xsl:when test="$livezone=0">1</xsl:when>	<!-- 城镇居民 -->
	<xsl:when test="$livezone=1">2</xsl:when>	<!-- 农村居民 -->
</xsl:choose>
</xsl:template>
<!-- 国籍 -->
<xsl:template name="tran_nationality">
<xsl:param name="nationality" />
<xsl:choose>
		<xsl:when test="$nationality='ABW'">AW</xsl:when><!--  阿鲁巴                    			-->	
		<xsl:when test="$nationality='AFG'">AF</xsl:when><!--  阿富汗                         -->
		<xsl:when test="$nationality='AGO'">AO</xsl:when><!--  安哥拉                         -->
		<xsl:when test="$nationality='AIA'">AI</xsl:when><!--  安圭拉                         -->
		<xsl:when test="$nationality='ALB'">AL</xsl:when><!--  阿尔巴尼亚                     -->
		<xsl:when test="$nationality='AND'">AD</xsl:when><!--  安道尔                         -->
		<xsl:when test="$nationality='ANT'">AN</xsl:when><!--  荷属安的列斯                   -->
		<xsl:when test="$nationality='ARE'">AE</xsl:when><!--  阿联酋                         -->
		<xsl:when test="$nationality='ARG'">AR</xsl:when><!--  阿根廷                         -->
		<xsl:when test="$nationality='ARM'">AM</xsl:when><!--  亚美尼亚                       -->
		<xsl:when test="$nationality='ASM'">AS</xsl:when><!--  美属萨摩亚                     -->
		<xsl:when test="$nationality='ATA'">OTH</xsl:when><!-- 南极洲                         -->
		<xsl:when test="$nationality='ATF'">OTH</xsl:when><!-- 法属南部领土                   -->
		<xsl:when test="$nationality='ATG'">AG</xsl:when><!--  安提瓜和巴布达                 -->
		<xsl:when test="$nationality='AUS'">AU</xsl:when><!--  澳大利亚                       -->
		<xsl:when test="$nationality='AUT'">AT</xsl:when><!--  奥地利                         -->
		<xsl:when test="$nationality='AZE'">AZ</xsl:when><!--	 阿塞拜疆                 	    -->
		<xsl:when test="$nationality='BDI'">BI</xsl:when><!--  布隆迪                         -->
		<xsl:when test="$nationality='BEL'">BE</xsl:when><!--  比利时                         -->
		<xsl:when test="$nationality='BEN'">BJ</xsl:when><!--  贝宁                           -->
		<xsl:when test="$nationality='BFA'">BF</xsl:when><!--  布基纳法索                     -->
		<xsl:when test="$nationality='BGD'">BD</xsl:when><!--  孟加拉国                       -->
		<xsl:when test="$nationality='BGR'">BG</xsl:when><!--  保加利亚                       -->
		<xsl:when test="$nationality='BHR'">BH</xsl:when><!--  巴林                           -->
		<xsl:when test="$nationality='BHS'">BS</xsl:when><!--  巴哈马                         -->
		<xsl:when test="$nationality='BIH'">BA</xsl:when><!--  波斯尼亚和黑塞哥维那           -->
		<xsl:when test="$nationality='BLR'">BY</xsl:when><!--  白俄罗斯                       -->
		<xsl:when test="$nationality='BLZ'">BZ</xsl:when><!--  伯利兹                         -->
		<xsl:when test="$nationality='BMU'">BM</xsl:when><!--  百慕大                         -->
		<xsl:when test="$nationality='BOL'">BO</xsl:when><!--  玻利维亚                       -->
		<xsl:when test="$nationality='BRA'">BR</xsl:when><!--  巴西                           -->
		<xsl:when test="$nationality='BRB'">BB</xsl:when><!--  巴巴多斯                       -->
		<xsl:when test="$nationality='BRN'">BN</xsl:when><!--  文莱                           -->
		<xsl:when test="$nationality='BTN'">BT</xsl:when><!--  不丹                           -->
		<xsl:when test="$nationality='BVT'">OTH</xsl:when><!-- 布维岛                         -->
		<xsl:when test="$nationality='BWA'">BW</xsl:when><!--  博茨瓦纳                       -->
		<xsl:when test="$nationality='CAF'">CF</xsl:when><!--  中非                           -->
		<xsl:when test="$nationality='CAN'">CA</xsl:when><!--  加拿大                         -->
		<xsl:when test="$nationality='CCK'">OTH</xsl:when><!-- 科科斯基林群岛                 -->
		<xsl:when test="$nationality='CHE'">CH</xsl:when><!--  瑞士                           -->
		<xsl:when test="$nationality='CHL'">CL</xsl:when><!--  智利                           -->
		<xsl:when test="$nationality='CHN'">CHN</xsl:when><!-- 中国                           -->
		<xsl:when test="$nationality='CIV'">CI</xsl:when><!--  科特迪瓦                       -->
		<xsl:when test="$nationality='CMR'">CM</xsl:when><!--  喀麦隆                         -->
		<xsl:when test="$nationality='COD'">CG</xsl:when><!--  刚果金                         -->
		<xsl:when test="$nationality='COG'">ZR</xsl:when><!--  刚果布                         -->
		<xsl:when test="$nationality='COK'">CK</xsl:when><!--  库克群岛                       -->
		<xsl:when test="$nationality='COL'">CO</xsl:when><!--  哥伦比亚                       -->
		<xsl:when test="$nationality='COM'">KM</xsl:when><!--  科摩罗                         -->
	  <xsl:when test="$nationality='CPV'">CV</xsl:when><!--      佛得角                         -->
	  <xsl:when test="$nationality='CRI'">CR</xsl:when><!--      哥斯达黎加                     -->
	  <xsl:when test="$nationality='CUB'">CU</xsl:when><!--      古巴                           -->
	  <xsl:when test="$nationality='CXR'">OTH</xsl:when><!--     圣诞岛                         -->
	  <xsl:when test="$nationality='CYM'">KY</xsl:when><!--      开曼群岛                       -->
	  <xsl:when test="$nationality='CYP'">CY</xsl:when><!--      塞浦路斯                       -->
	  <xsl:when test="$nationality='CZE'">CZ</xsl:when><!--      捷克                           -->
	  <xsl:when test="$nationality='DEU'">DE</xsl:when><!--      德国                           -->
	  <xsl:when test="$nationality='DJI'">DJ</xsl:when><!--      吉布提                         -->
	  <xsl:when test="$nationality='DMA'">DM</xsl:when><!--      多米尼克                       -->
	  <xsl:when test="$nationality='DNK'">DK</xsl:when><!--      丹麦                           -->
	  <xsl:when test="$nationality='DOM'">DO</xsl:when><!--      多米尼加共和国                 -->
	  <xsl:when test="$nationality='DZA'">DZ</xsl:when><!--      阿尔及利亚                     -->
	  <xsl:when test="$nationality='ECU'">EC</xsl:when><!--      厄瓜多尔                       -->
	  <xsl:when test="$nationality='EGY'">EG</xsl:when><!--      埃及                           -->
	  <xsl:when test="$nationality='ERI'">ER</xsl:when><!--      厄立特里亚                     -->
	  <xsl:when test="$nationality='ESH'">OTH</xsl:when><!--     西撒哈拉                       -->
	  <xsl:when test="$nationality='ESP'">ES</xsl:when><!--      西班牙                         -->
	  <xsl:when test="$nationality='EST'">EE</xsl:when><!--      爱沙尼亚                       -->
	  <xsl:when test="$nationality='ETH'">ET</xsl:when><!--      埃塞俄比亚                     -->
	  <xsl:when test="$nationality='FIN'">FI</xsl:when><!--      芬兰                           -->
	  <xsl:when test="$nationality='FJI'">FJ</xsl:when><!--      斐济                           -->
	  <xsl:when test="$nationality='FLK'">OTH</xsl:when><!--     马尔维纳斯群岛福克兰群岛       -->
	  <xsl:when test="$nationality='FRA'">FR</xsl:when><!--      法国                           -->
	  <xsl:when test="$nationality='FRO'">FO</xsl:when><!--      法罗群岛                       -->
	  <xsl:when test="$nationality='FSM'">OTH</xsl:when><!--     密克罗尼西亚                   -->
	  <xsl:when test="$nationality='GAB'">GA</xsl:when><!--      加蓬                           -->
	  <xsl:when test="$nationality='GBR'">GB</xsl:when><!--      英国                           -->
	  <xsl:when test="$nationality='GEO'">GE</xsl:when><!--      格鲁吉亚                       -->
	  <xsl:when test="$nationality='GHA'">GH</xsl:when><!--      加纳                           -->
	  <xsl:when test="$nationality='GIB'">GI</xsl:when><!--      直布罗陀                       -->
	  <xsl:when test="$nationality='GIN'">GN</xsl:when><!--      几内亚                         -->
	  <xsl:when test="$nationality='GLP'">GP</xsl:when><!--      瓜德罗普                       -->
	  <xsl:when test="$nationality='GMB'">GM</xsl:when><!--      冈比亚                         -->
	  <xsl:when test="$nationality='GNB'">GW</xsl:when><!--      几内亚比绍                     -->
	  <xsl:when test="$nationality='GNQ'">GQ</xsl:when><!--      赤道几内亚                     -->
	  <xsl:when test="$nationality='GRC'">GR</xsl:when><!--      希腊                           -->
	  <xsl:when test="$nationality='GRD'">GD</xsl:when><!--      格林纳达                       -->
	  <xsl:when test="$nationality='GRL'">GL</xsl:when><!--      格陵兰                         -->
	  <xsl:when test="$nationality='GTM'">GT</xsl:when><!--      危地马拉                       -->
	  <xsl:when test="$nationality='GUF'">GF</xsl:when><!--      法属圭亚那                     -->
	  <xsl:when test="$nationality='GUM'">GU</xsl:when><!--      关岛                           -->
	  <xsl:when test="$nationality='GUY'">GY</xsl:when><!--      圭亚那                         -->
	  <xsl:when test="$nationality='HKG'">CHN</xsl:when><!--     香港                           -->
	  <xsl:when test="$nationality='HMD'">OTH</xsl:when><!--     赫德岛和麦克唐纳岛             -->
	  <xsl:when test="$nationality='HND'">HN</xsl:when><!--      洪都拉斯                       -->
	  <xsl:when test="$nationality='HRV'">HR</xsl:when><!--      克罗地亚                       -->
	  <xsl:when test="$nationality='HTI'">HT</xsl:when><!--      海地                           -->
	  <xsl:when test="$nationality='HUN'">HU</xsl:when><!--      匈牙利                         -->
	  <xsl:when test="$nationality='IDN'">ID</xsl:when><!--      印度尼西亚                     -->
	  <xsl:when test="$nationality='IND'">IN</xsl:when><!--      印度                           -->
	  <xsl:when test="$nationality='IOT'">OTH</xsl:when><!--     英属印度洋领土                 -->
	  <xsl:when test="$nationality='IRL'">IE</xsl:when><!--      爱尔兰                         -->
	  <xsl:when test="$nationality='IRN'">IR</xsl:when><!--      伊朗                           -->
	  <xsl:when test="$nationality='IRQ'">IQ</xsl:when><!--      伊拉克                         -->
	  <xsl:when test="$nationality='ISL'">IS</xsl:when><!--      冰岛                           -->
	  <xsl:when test="$nationality='ISR'">IL</xsl:when><!--      以色列                         -->
	  <xsl:when test="$nationality='ITA'">IT</xsl:when><!--      意大利                         -->
	  <xsl:when test="$nationality='JAM'">JM</xsl:when><!--      牙买加                         -->
	  <xsl:when test="$nationality='JOR'">JO</xsl:when><!--      约旦                           -->
	  <xsl:when test="$nationality='JPN'">JP</xsl:when><!--      日本                           -->
	  <xsl:when test="$nationality='KAZ'">KZ</xsl:when><!--      哈萨克斯坦                     -->
	  <xsl:when test="$nationality='KEN'">KE</xsl:when><!--      肯尼亚                         -->
	  <xsl:when test="$nationality='KGZ'">KG</xsl:when><!--      吉尔吉斯斯坦                   -->
	  <xsl:when test="$nationality='KHM'">KH</xsl:when><!--      柬埔寨                         -->
	  <xsl:when test="$nationality='KIR'">KT</xsl:when><!--      基里巴斯                       -->
	  <xsl:when test="$nationality='KNA'">SX</xsl:when><!--      圣基茨和尼维斯                 -->
	  <xsl:when test="$nationality='KOR'">KR</xsl:when><!--      韩国                           -->
	  <xsl:when test="$nationality='KWT'">KW</xsl:when><!--      科威特                         -->
	  <xsl:when test="$nationality='LAO'">LA</xsl:when><!--      老挝                           -->
	  <xsl:when test="$nationality='LBN'">LB</xsl:when><!--      黎巴嫩                         -->
	  <xsl:when test="$nationality='LBR'">LR</xsl:when><!--      利比里亚                       -->
	  <xsl:when test="$nationality='LBY'">LY</xsl:when><!--      利比亚                         -->
	  <xsl:when test="$nationality='LCA'">SQ</xsl:when><!--      圣卢西亚                       -->
	  <xsl:when test="$nationality='LIE'">LI</xsl:when><!--      列支敦士登                     -->
	  <xsl:when test="$nationality='LKA'">LK</xsl:when><!--      斯里兰卡                       -->
	  <xsl:when test="$nationality='LSO'">LS</xsl:when><!--      莱索托                         -->
	  <xsl:when test="$nationality='LTU'">LT</xsl:when><!--      立陶宛                         -->
	  <xsl:when test="$nationality='LUX'">LU</xsl:when><!--      卢森堡                         -->
	  <xsl:when test="$nationality='LVA'">LV</xsl:when><!--      拉脱维亚                       -->
	  <xsl:when test="$nationality='MAC'">CHN</xsl:when><!--     澳门                           -->
	  <xsl:when test="$nationality='MAR'">MA</xsl:when><!--      摩洛哥                         -->
	  <xsl:when test="$nationality='MCO'">MC</xsl:when><!--      摩纳哥                         -->
	  <xsl:when test="$nationality='MDA'">MD</xsl:when><!--      摩尔多瓦                       -->
	  <xsl:when test="$nationality='MDG'">MG</xsl:when><!--      马达加斯加                     -->
	  <xsl:when test="$nationality='MDV'">MV</xsl:when><!--      马尔代夫                       -->
	  <xsl:when test="$nationality='MEX'">MX</xsl:when><!--      墨西哥                         -->
	  <xsl:when test="$nationality='MHL'">MH</xsl:when><!--      马绍尔群岛                     -->
	  <xsl:when test="$nationality='MKD'">MK</xsl:when><!--      马斯顿                         -->
	  <xsl:when test="$nationality='MLI'">ML</xsl:when><!--      马里                           -->
	  <xsl:when test="$nationality='MLT'">MT</xsl:when><!--      马耳他                         -->
	  <xsl:when test="$nationality='MMR'">MM</xsl:when><!--      缅甸                           -->
	  <xsl:when test="$nationality='MNG'">MN</xsl:when><!--      蒙古                           -->
	  <xsl:when test="$nationality='MNP'">MP</xsl:when><!--      北马里亚纳                     -->
	  <xsl:when test="$nationality='MOZ'">MZ</xsl:when><!--      莫桑比克                       -->
	  <xsl:when test="$nationality='MRT'">MR</xsl:when><!--      毛里塔尼亚                     -->
	  <xsl:when test="$nationality='MSR'">MS</xsl:when><!--      蒙特塞拉特                     -->
	  <xsl:when test="$nationality='MTQ'">MQ</xsl:when><!--      马提尼克                       -->
	  <xsl:when test="$nationality='MUS'">MU</xsl:when><!--      毛里求斯                       -->
	  <xsl:when test="$nationality='MWI'">MW</xsl:when><!--      马拉维                         -->
	  <xsl:when test="$nationality='MYS'">MY</xsl:when><!--      马来西亚                       -->
	  <xsl:when test="$nationality='MYT'">YT</xsl:when><!--      马约特                         -->
	  <xsl:when test="$nationality='NAM'">NA</xsl:when><!--      纳米比亚                       -->
	  <xsl:when test="$nationality='NCL'">NC</xsl:when><!--      新喀里多尼亚                   -->
	  <xsl:when test="$nationality='NER'">NE</xsl:when><!--      尼日尔                         -->
	  <xsl:when test="$nationality='NFK'">NF</xsl:when><!--      诺福克岛                       -->
	  <xsl:when test="$nationality='NGA'">NG</xsl:when><!--      尼日利亚                       -->
	  <xsl:when test="$nationality='NIC'">NI</xsl:when><!--      尼加拉瓜                       -->
	  <xsl:when test="$nationality='NIU'">NU</xsl:when><!--      纽埃                           -->
	  <xsl:when test="$nationality='NLD'">NL</xsl:when><!--      荷兰                           -->
	  <xsl:when test="$nationality='NOR'">NO</xsl:when><!--      挪威                           -->
	  <xsl:when test="$nationality='NPL'">NP</xsl:when><!--      尼泊尔                         -->
	  <xsl:when test="$nationality='NRU'">NR</xsl:when><!--      瑙鲁                           -->
	  <xsl:when test="$nationality='NZL'">NZ</xsl:when><!--      新西兰                         -->
	  <xsl:when test="$nationality='OMN'">OM</xsl:when><!--      阿曼                           -->
	  <xsl:when test="$nationality='PAK'">PK</xsl:when><!--      巴基斯坦                       -->
	  <xsl:when test="$nationality='PAN'">PA</xsl:when><!--      巴拿马                         -->
	  <xsl:when test="$nationality='PCN'">OTH</xsl:when><!--     皮特凯恩群岛                   -->
	  <xsl:when test="$nationality='PER'">PE</xsl:when><!--      秘鲁                           -->
	  <xsl:when test="$nationality='PHL'">PH</xsl:when><!--      菲律宾                         -->
	  <xsl:when test="$nationality='PLW'">PW</xsl:when><!--      帕劳                           -->
	  <xsl:when test="$nationality='PNG'">PG</xsl:when><!--      巴布亚新几内亚                 -->
	  <xsl:when test="$nationality='POL'">PL</xsl:when><!--      波兰                           -->
	  <xsl:when test="$nationality='PRI'">PR</xsl:when><!--      波多黎各                       -->
	  <xsl:when test="$nationality='PRK'">KP</xsl:when><!--      朝鲜                           -->
	  <xsl:when test="$nationality='PRT'">PT</xsl:when><!--      葡萄牙                         -->
	  <xsl:when test="$nationality='PRY'">PY</xsl:when><!--      巴拉圭                         -->
	  <xsl:when test="$nationality='PSE'">OTH</xsl:when><!--     巴勒斯坦                       -->
	  <xsl:when test="$nationality='PYF'">PF</xsl:when><!--      法属波利尼西亚                 -->
	  <xsl:when test="$nationality='QAT'">QA</xsl:when><!--      卡塔尔                         -->
	  <xsl:when test="$nationality='REU'">RE</xsl:when><!--      留尼汪                         -->
	  <xsl:when test="$nationality='ROM'">RO</xsl:when><!--      罗马尼亚                       -->
	  <xsl:when test="$nationality='RUS'">RU</xsl:when><!--      俄罗斯                         -->
	  <xsl:when test="$nationality='RWA'">RW</xsl:when><!--      卢旺达                         -->
	  <xsl:when test="$nationality='SAU'">SA</xsl:when><!--      沙特阿拉伯                     -->
	  <xsl:when test="$nationality='SCG'">OTH</xsl:when><!--     塞尔维亚和黑山                 -->
	  <xsl:when test="$nationality='SDN'">SD</xsl:when><!--      苏丹                           -->
	  <xsl:when test="$nationality='SEN'">SN</xsl:when><!--      塞内加尔                       -->
	  <xsl:when test="$nationality='SGP'">SG</xsl:when><!--      新加坡                         -->
	  <xsl:when test="$nationality='SGS'">OTH</xsl:when><!--     南乔治亚岛和南桑德韦奇岛       -->
	  <xsl:when test="$nationality='SHN'">OTH</xsl:when><!--     圣赫勒拿                       -->
	  <xsl:when test="$nationality='SJM'">OTH</xsl:when><!--     斯瓦尔巴群岛和扬马群岛         -->
	  <xsl:when test="$nationality='SLB'">SB</xsl:when><!--      所罗门群岛                     -->
	  <xsl:when test="$nationality='SLE'">SL</xsl:when><!--      塞拉利昂                       -->
	  <xsl:when test="$nationality='SLV'">SV</xsl:when><!--      萨尔瓦多                       -->
	  <xsl:when test="$nationality='SMR'">SM</xsl:when><!--      圣马力诺                       -->
	  <xsl:when test="$nationality='SOM'">SO</xsl:when><!--      索马里                         -->
	  <xsl:when test="$nationality='SPM'">OTH</xsl:when><!--     圣皮埃尔和密克隆               -->
	  <xsl:when test="$nationality='STP'">ST</xsl:when><!--      圣多美和普林西比               -->
	  <xsl:when test="$nationality='SUR'">SR</xsl:when><!--      苏里南                         -->
	  <xsl:when test="$nationality='SVK'">SK</xsl:when><!--      斯洛伐克                       -->
	  <xsl:when test="$nationality='SVN'">SI</xsl:when><!--      斯洛文尼亚                     -->
	  <xsl:when test="$nationality='SWE'">SE</xsl:when><!--      瑞典                           -->
	  <xsl:when test="$nationality='SWZ'">SZ</xsl:when><!--      斯威士兰                       -->
	  <xsl:when test="$nationality='SYC'">SC</xsl:when><!--      塞舌尔                         -->
	  <xsl:when test="$nationality='SYR'">SY</xsl:when><!--      叙利亚                         -->
	  <xsl:when test="$nationality='TCA'">TC</xsl:when><!--      特克斯和凯科斯群岛             -->
	  <xsl:when test="$nationality='TCD'">TD</xsl:when><!--      乍得                           -->
	  <xsl:when test="$nationality='TGO'">TG</xsl:when><!--      多哥                           -->
	  <xsl:when test="$nationality='THA'">TH</xsl:when><!--      泰国                           -->
	  <xsl:when test="$nationality='TJK'">TJ</xsl:when><!--      塔吉克斯坦                     -->
	  <xsl:when test="$nationality='TKL'">OTH</xsl:when><!--     托克劳                         -->
	  <xsl:when test="$nationality='TKM'">TM</xsl:when><!--      土库曼斯坦                     -->
	  <xsl:when test="$nationality='TMP'">OTH</xsl:when><!--     东帝汶                         -->
	  <xsl:when test="$nationality='TON'">TO</xsl:when><!--      汤加                           -->
	  <xsl:when test="$nationality='TTO'">TT</xsl:when><!--      特立尼达和多巴哥               -->
	  <xsl:when test="$nationality='TUN'">TN</xsl:when><!--      突尼斯                         -->
	  <xsl:when test="$nationality='TUR'">TR</xsl:when><!--      土耳其                         -->
	  <xsl:when test="$nationality='TUV'">TV</xsl:when><!--      图瓦卢                         -->
	  <xsl:when test="$nationality='TWN'">CHN</xsl:when><!--     中国台湾                       -->
	  <xsl:when test="$nationality='TZA'">TZ</xsl:when><!--      坦桑尼亚                       -->
	  <xsl:when test="$nationality='UGA'">UG</xsl:when><!--      乌干达                         -->
	  <xsl:when test="$nationality='UKR'">UA</xsl:when><!--      乌克兰                         -->
	  <xsl:when test="$nationality='UMI'">OTH</xsl:when><!--     美属本土外小岛屿               -->
	  <xsl:when test="$nationality='URY'">UY</xsl:when><!--      乌拉圭                         -->
	  <xsl:when test="$nationality='USA'">US</xsl:when><!--      美国                           -->
	  <xsl:when test="$nationality='UZB'">UZ</xsl:when><!--      乌兹别克斯坦                   -->
	  <xsl:when test="$nationality='VAT'">OTH</xsl:when><!--     梵蒂冈                         -->
	  <xsl:when test="$nationality='VCT'">VC</xsl:when><!--      圣文森特和格林纳丁斯           -->
	  <xsl:when test="$nationality='VEN'">VE</xsl:when><!--      委内瑞拉                       -->
	  <xsl:when test="$nationality='VGB'">VG</xsl:when><!--      英属维尔京群岛                 -->
	  <xsl:when test="$nationality='VIR'">VI</xsl:when><!--      美属维尔京群岛                 -->
	  <xsl:when test="$nationality='VNM'">VN</xsl:when><!--      越南                           -->
	  <xsl:when test="$nationality='VUT'">VU</xsl:when><!--      瓦努阿图                       -->
	  <xsl:when test="$nationality='WLF'">OTH</xsl:when><!--     瓦利斯和富图纳群岛             -->
	  <xsl:when test="$nationality='WSM'">WS</xsl:when><!--      西萨摩亚                       -->
	  <xsl:when test="$nationality='YEM'">YE</xsl:when><!--      也门                           -->
	  <xsl:when test="$nationality='ZAF'">ZA</xsl:when><!--      南非                           -->
	  <xsl:when test="$nationality='ZAR'">OTH</xsl:when><!--     扎伊尔                         -->
	  <xsl:when test="$nationality='ZMB'">ZM</xsl:when><!--      赞比亚                         -->
	  <xsl:when test="$nationality='ZWE'">ZW</xsl:when><!--      津巴布韦                       -->
	  <xsl:when test="$nationality='OTH'">OTH</xsl:when><!--    其他                            -->
</xsl:choose>
</xsl:template>
<!-- 关系 -->
<xsl:template name="tran_RelationRoleCode">
<xsl:param name="relationRoleCode" />
<xsl:choose>
	<xsl:when test="$relationRoleCode=00">00</xsl:when>	<!-- 本人 -->
	<xsl:when test="$relationRoleCode=01">03</xsl:when>	<!-- 父母 -->
	<xsl:when test="$relationRoleCode=02">01</xsl:when>	<!-- 子女 -->
	<xsl:when test="$relationRoleCode=03">02</xsl:when>	<!-- 配偶 -->  
	<xsl:when test="$relationRoleCode=04">04</xsl:when>	<!-- 其他 -->
</xsl:choose>
</xsl:template>
<!-- paymode -->
<xsl:template name="tran_PayMode">
<xsl:param name="payMode" />
<xsl:choose>
	<xsl:when test="$payMode=1">1</xsl:when>	<!-- 现金 -->
	<xsl:when test="$payMode=2">7</xsl:when>	<!-- 银行转账 -->
	
</xsl:choose>
</xsl:template>
<!-- 受益人关系 -->
<xsl:template name="tran_RelationToInsured">
<xsl:param name="relationToInsured" />
<xsl:choose>
	<xsl:when test="$relationToInsured=0"></xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=1">01</xsl:when> <!-- 父母（先这么处理，在程序里判断） -->
	<xsl:when test="$relationToInsured=2">01</xsl:when> <!-- 父母（先这么处理，在程序里判断） -->
	<xsl:when test="$relationToInsured=3">01</xsl:when> <!-- 父母（先这么处理，在程序里判断） -->
	<xsl:when test="$relationToInsured=4">01</xsl:when> <!-- 父母（先这么处理，在程序里判断） -->
	<xsl:when test="$relationToInsured=5">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=00">00</xsl:when> <!-- 本人 -->
	<xsl:when test="$relationToInsured=7">02</xsl:when> <!-- 配偶 -->
	<xsl:when test="$relationToInsured=8">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=9">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=10">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=11">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=12">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=13">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=14">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=15">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=16">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=17">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=18">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=19">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=20">04</xsl:when> <!-- 其他 -->
	<xsl:when test="$relationToInsured=21">05</xsl:when> <!-- 雇佣 -->
	<xsl:when test="$relationToInsured=22">04</xsl:when> <!-- 其他 -->
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
