<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/Req">
	  <!--由农行非标准报文转换为中科软标准报文-->
	  <TranData>
	  	<!--基本信息-->
	 <Head>
	    <TranDate><xsl:value-of select="BankDate"/></TranDate>
	    <TranTime><xsl:value-of select="BankTime"/></TranTime>
	    <TellerNo><xsl:value-of select="TellerNo"/></TellerNo>
	    <TranNo><xsl:value-of select="TransrNo"/></TranNo>
	    <NodeNo><xsl:value-of select="ZoneNo"/><xsl:value-of select="BrNo"/></NodeNo>
	    <xsl:copy-of select="Head/*"/>
	    <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
     </Head>
	  	
    <Body>
		<ProposalPrtNo><xsl:value-of select ="Base/ProposalContNo"/></ProposalPrtNo> <!-- 投保单(印刷)号 -->
        <ContPrtNo><xsl:value-of select="Base/PrtNo"/></ContPrtNo> <!-- 保单合同印刷号 -->
        <PolApplyDate><xsl:value-of select ="Base/PolApplyDate"/></PolApplyDate> <!-- 投保日期 -->
        <AccName><xsl:value-of select ="Base/AccName"/></AccName> <!-- 账户姓名 -->
        <AccNo><xsl:value-of select ="Base/BankAccNo"/></AccNo> <!-- 银行账户 -->
        <GetPolMode></GetPolMode> <!-- 保单递送方式 -->
        <JobNotice></JobNotice> <!-- 职业告知(N/Y) -->
        <HealthNotice>        	
        	<xsl:call-template name="tran_healthnotice">
		          <xsl:with-param name="healthnotice" select="Risks/Risk/HealthFlag" />
	      </xsl:call-template>
	    </HealthNotice> <!-- 健康告知(N/Y)  -->        
        <PolicyIndicator></PolicyIndicator><!--未成年被保险人是否在其他保险公司投保身故保险 Y是N否-->
        <InsuredTotalFaceAmount></InsuredTotalFaceAmount><!--累计投保身故保额-->
        
        <!-- 组合产品份数 -->
		<xsl:variable name="ContPlanMult"><xsl:value-of select="Risks/Risk[Code=MainRiskCode]/Mult" /></xsl:variable>
		<!-- 险种,此处是产品组合编码 -->
		<xsl:variable name="ContPlanCode">
			<xsl:call-template name="tran_ContPlanCode">
				<xsl:with-param name="contPlanCode" select="Risks/Risk[Code=MainRiskCode]/MainRiskCode" />
			</xsl:call-template>
		</xsl:variable>

		<!-- 产品组合 -->
		<ContPlan>
			<!-- 产品组合编码 -->
			<ContPlanCode><xsl:value-of select="$ContPlanCode" /></ContPlanCode>
			<!-- 产品组合份数 -->
			<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
		</ContPlan>
	<Appnt>	
        <Name><xsl:value-of select ="Appl/Name"/></Name> <!-- 姓名 -->
        <Sex><xsl:value-of select ="Appl/Sex"/></Sex> <!-- 性别 -->
        <Birthday><xsl:value-of select ="Appl/Birthday"/></Birthday> <!-- 出生日期(yyyyMMdd) -->
        <IDType>
         <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype">
						<xsl:value-of select ="Appl/IDType"/>
					</xsl:with-param>
		</xsl:call-template>
		</IDType> <!-- 证件类型 -->
        <IDNo><xsl:value-of select ="Appl/IDNo"/></IDNo> <!-- 证件号码 -->
        <IDTypeStartDate></IDTypeStartDate > <!-- 证件有效起期 -->
        <IDTypeEndDate><xsl:value-of select ="Appl/ValidYear"/></IDTypeEndDate > <!-- 证件有效止期yyyyMMdd -->
        <JobCode>
          <xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode">
						<xsl:value-of select="Appl/JobCode" />
					</xsl:with-param>
		  </xsl:call-template>
		</JobCode> <!-- 职业代码 -->
        <Nationality>
		<xsl:call-template name="tran_Nationality">
		  <xsl:with-param name="nationality">
		 	<xsl:value-of select="Appl/Country"/>
	      </xsl:with-param>
	    </xsl:call-template>
	    </Nationality> <!-- 国籍 -->
        <Stature></Stature> <!-- 身高(cm) -->
        <Weight></Weight> <!-- 体重(g) -->
        <MaritalStatus></MaritalStatus> <!-- 婚否(N/Y) -->
        <Address><xsl:value-of select ="Appl/Address"/></Address> <!-- 地址 -->
        <ZipCode><xsl:value-of select ="Appl/ZipCode"/></ZipCode> <!-- 邮编 -->
        <Mobile><xsl:value-of select ="Appl/Mobile"/></Mobile> <!-- 移动电话 -->
        <Phone><xsl:value-of select ="Appl/Phone"/></Phone> <!-- 固定电话 -->
        <Email><xsl:value-of select ="Appl/Email"/></Email> <!-- 电子邮件-->
        <RelaToInsured>
         	<xsl:call-template name="tran_RelationRoleCode">
					<xsl:with-param name="relaToInsured">
						<xsl:value-of select="Appl/RelaToInsured"/>
					</xsl:with-param>
		   </xsl:call-template>
        </RelaToInsured> <!-- 与被保人关系 -->
    </Appnt>
		

   <Insured>
      <Name><xsl:value-of select="Insu/Name"/></Name> <!-- 姓名 -->
      <Sex><xsl:value-of select="Insu/Sex"/></Sex> <!-- 性别 -->
      <Birthday><xsl:value-of select="Insu/Birthday"/></Birthday> <!-- 出生日期(yyyyMMdd) -->
      <IDType>
      <xsl:call-template name="tran_IDType">
		 <xsl:with-param name="idtype">
		 	<xsl:value-of select="Insu/IDType"/>
	     </xsl:with-param>
	  </xsl:call-template>
      </IDType> <!-- 证件类型 -->
      <IDNo><xsl:value-of select="Insu/IDNo"/></IDNo> <!-- 证件号码 -->
      <IDTypeStartDate></IDTypeStartDate > <!-- 证件有效起期 -->
      <IDTypeEndDate><xsl:value-of select="Insu/ValidYear"/></IDTypeEndDate > <!-- 证件有效止期 -->
      <JobCode>
       <xsl:call-template name="tran_jobcode">
		  <xsl:with-param name="jobcode">
			 <xsl:value-of select="Insu/JobCode" />
		  </xsl:with-param>
      </xsl:call-template>
      </JobCode> <!-- 职业代码 -->
      <Stature></Stature> <!-- 身高(cm)-->	
      <Nationality>
      <xsl:call-template name="tran_Nationality">
		 <xsl:with-param name="nationality">
		 	<xsl:value-of select="Insu/Country"/>
	     </xsl:with-param>
	  </xsl:call-template>
	  </Nationality> <!-- 国籍 -->
      <Weight></Weight> <!-- 体重(g) -->
      <MaritalStatus></MaritalStatus> <!-- 婚否(N/Y) -->
  	  <Address><xsl:value-of select="Insu/Address"/></Address>
	  <ZipCode><xsl:value-of select="Insu/ZipCode"/></ZipCode>
	  <Mobile><xsl:value-of select="Insu/Mobile"/></Mobile>
	  <Phone><xsl:value-of select="Insu/Phone"/></Phone>
	  <Email><xsl:value-of select="Insu/Email"/></Email>
   </Insured>
   
   <xsl:variable name ="count" select ="Bnfs/Count"/>
		<xsl:if test="$count!=0">
			<xsl:for-each select="Bnfs/Bnf">
			<!-- 受益人 -->
				<Bnf>
					<Type><xsl:value-of select="Type"/></Type>
					<Grade><xsl:value-of select="BnfGrade"/></Grade>
					<Name><xsl:value-of select="Name"/></Name>
					<Sex><xsl:value-of select="Sex"/></Sex>
					<Birthday><xsl:value-of select="Birthday"/></Birthday>
					<IDType>
						<xsl:call-template name="tran_IDType">
							<xsl:with-param name="idtype">
								<xsl:value-of select="IDType"/>
							</xsl:with-param>
						</xsl:call-template>
					</IDType>
					<IDNo><xsl:value-of select="IDNo"/></IDNo>
					<RelaToInsured>
					<xsl:call-template name="tran_RelationRoleCode">
					<xsl:with-param name="relaToInsured">
						<xsl:value-of select="RelationToInsured"/>
					</xsl:with-param>
				 </xsl:call-template></RelaToInsured>
					<Lot><xsl:value-of select="BnfLot"/></Lot>
				</Bnf>
			</xsl:for-each>
		</xsl:if>
		
		<xsl:for-each select="Risks/Risk">
			<!-- 险种 -->
			<Risk>
				<RiskCode><xsl:value-of select="Code"/></RiskCode>
				<MainRiskCode><xsl:value-of select="MainRiskCode"/></MainRiskCode>
				<RiskType></RiskType>
				<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)"/></Amnt>
				
				<xsl:choose>
					<xsl:when test="Prem=''">
						<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($ContPlanMult*1000)"/></Prem>
					</xsl:when>
					<xsl:otherwise>
						<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)"/></Prem>						
					</xsl:otherwise>
				</xsl:choose>
				
				<Mult><xsl:value-of select="Mult"/></Mult>
				<PayIntv>
					<xsl:call-template name="tran_PayIntv">
						<xsl:with-param name="payintv">
							<xsl:value-of select="PayIntv"/>
						</xsl:with-param>
					</xsl:call-template>
				</PayIntv>
				<PayMode></PayMode>
				<CostIntv></CostIntv>
				<CostDate></CostDate>
				<Years><xsl:value-of select="Years"/></Years>
				<InsuYearFlag>
					<xsl:call-template name="tran_YearFlag">
						<xsl:with-param name="YearFlag">
							<xsl:value-of
								select="InsuYearFlag" />
						</xsl:with-param>
					</xsl:call-template>
				</InsuYearFlag>
				<InsuYear><!-- 保终身 -->
		            <xsl:if test="InsuYearFlag=5">106</xsl:if>
		            <xsl:if test="InsuYearFlag!=5"><xsl:value-of select="InsuYear" /></xsl:if>
	            </InsuYear>
				<xsl:if test="PayIntv = 1">
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:if>
				<xsl:if test="PayIntv != 1">
					<PayEndYearFlag>
						<xsl:call-template name="tran_YearFlag">
							<xsl:with-param name="YearFlag">
								<xsl:value-of
									select="PayEndYearFlag" />
							</xsl:with-param>
						</xsl:call-template>
					</PayEndYearFlag>
					<PayEndYear><xsl:value-of select="PayEndYear"/></PayEndYear>
				</xsl:if>
				<GetYearFlag>
					<xsl:call-template name="tran_YearFlag">
						<xsl:with-param name="YearFlag">
							<xsl:value-of
								select="GetYearFlag" />
						</xsl:with-param>
					</xsl:call-template>
				</GetYearFlag>
				<GetYear><xsl:value-of select="GetYear"/></GetYear>
				<GetIntv></GetIntv>
				<GetBankCode></GetBankCode>
				<GetBankAccNo></GetBankAccNo>
				<GetAccName></GetAccName>
				<AutoPayFlag><xsl:value-of select="IsCashAutoPay"/></AutoPayFlag>
				<BonusPayMode><xsl:value-of select="BonusPayMode"/></BonusPayMode>
				<SubFlag><xsl:value-of select="SubFlag"/></SubFlag>
				<!-- 处理农行红利领取方式 -->
				<BonusGetMode><xsl:value-of select="BonusGetMode"/></BonusGetMode>
				<FullBonusGetMode><xsl:value-of select="FullBonusGetMode"/></FullBonusGetMode>
			</Risk>
		</xsl:for-each>
		</Body>
	</TranData>
</xsl:template>


<!-- 产品组合代码 -->
<xsl:template name="tran_ContPlanCode">
<xsl:param name="contPlanCode" />
<xsl:choose>
	<!-- 50001-安邦长寿稳赢1号两全保险组合:主险：122046 - 安邦长寿稳赢1号两全保险,附加险：122047 - 安邦附加长寿稳赢两全保险 -->
	<xsl:when test="$contPlanCode=122046">50001</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template name="tran_YearFlag">
	<xsl:param name="YearFlag">Y</xsl:param>
	<xsl:if test="$YearFlag = 1">A</xsl:if>
	<xsl:if test="$YearFlag = 2">M</xsl:if>
	<xsl:if test="$YearFlag = 3">D</xsl:if>
	<xsl:if test="$YearFlag = 4">Y</xsl:if>
	<xsl:if test="$YearFlag = 5">A</xsl:if>
</xsl:template>
	
	
<!-- 缴费频次  银行: 1：趸交  2：月交     3：季交    4：半年交    5：年交             6：不定期
                   核心:  0：一次交清/趸交 1:月交  3:季交   6:半年交	   12：年交          -1:不定期交 -->
<xsl:template name="tran_PayIntv">
	<xsl:param name="payintv">0</xsl:param>
	<xsl:if test="$payintv = '1'">0</xsl:if>
	<xsl:if test="$payintv = '2'">1</xsl:if>
	<xsl:if test="$payintv = '3'">3</xsl:if>
	<xsl:if test="$payintv = '4'">6</xsl:if>
	<xsl:if test="$payintv = '5'">12</xsl:if>
	<xsl:if test="$payintv = '6'">-1</xsl:if>
</xsl:template>
	
<!-- 证件类型 -->
<xsl:template name="tran_IDType">
<xsl:param name="idtype">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$idtype = 110001">0</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype = 110002">9</xsl:when>	<!-- 重号居民身份证 -->
		<xsl:when test="$idtype = 110003">0</xsl:when>	<!-- 临时身份证 -->
		<xsl:when test="$idtype = 110004">9</xsl:when>	<!-- 重号临时居民身份证 -->
		<xsl:when test="$idtype = 110005">5</xsl:when>	<!-- 户口簿 -->
		<xsl:when test="$idtype = 110023">1</xsl:when>	<!-- 中华人民共和国护照 -->
		<xsl:when test="$idtype = 110025">1</xsl:when>	<!-- 外国护照 -->
		<xsl:when test="$idtype = 110027">2</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype = 110031">2</xsl:when>	<!-- 警官证 -->
		<xsl:when test="$idtype = 110033">2</xsl:when>	<!-- 军人士兵证 -->
		<xsl:when test="$idtype = 110035">2</xsl:when>	<!-- 武警士兵证 -->
		<xsl:otherwise>8</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
<!-- 职业代码 -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode='01'">4030111</xsl:when>	<!-- 国家机关、党群组织、企业、事业单位人员 -->
		<xsl:when test="$jobcode='02'">2050101</xsl:when>	<!-- 卫生专业技术人员 -->
		<xsl:when test="$jobcode='03'">2070109</xsl:when>	<!-- 金融业务人员 -->
		<xsl:when test="$jobcode='04'">2080103</xsl:when>	<!-- 法律专业人员 -->
		<xsl:when test="$jobcode='05'">2090104</xsl:when>	<!-- 教学人员 -->
		<xsl:when test="$jobcode='06'">2100106</xsl:when>	<!-- 新闻出版及文学艺术工作人员 -->
		<xsl:when test="$jobcode='07'">2130101</xsl:when>	<!-- 宗教职业者 -->
		<xsl:when test="$jobcode='08'">3030101</xsl:when>	<!-- 邮政和电信业务人员 -->
		<xsl:when test="$jobcode='09'">4010101</xsl:when>	<!-- 商业、服务业人员 -->
		<xsl:when test="$jobcode='10'">5010107</xsl:when>	<!-- 农、林、牧、渔、水利业生产人员 -->
		<xsl:when test="$jobcode='11'">6240105</xsl:when>	<!-- 运输人员 -->
		<xsl:when test="$jobcode='12'">2020103</xsl:when>	<!-- 地址勘探人员 -->
		<xsl:when test="$jobcode='13'">2020906</xsl:when>	<!-- 工程施工人员 -->
		<xsl:when test="$jobcode='14'">6050611</xsl:when>	<!-- 加工制造、检验及计量人员 -->
		<xsl:when test="$jobcode='15'">7010103</xsl:when>	<!-- 军人 -->
		<xsl:when test="$jobcode='16'">8010101</xsl:when>	<!-- 无业 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
    
<!-- 关系 -->		
<xsl:template name="tran_RelationRoleCode">
    <xsl:param name="relaToInsured">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$relaToInsured='2'">02</xsl:when>
		<xsl:when test="$relaToInsured='3'">02</xsl:when>
		<!-- 配偶 -->
		<xsl:when test="$relaToInsured='4'">01</xsl:when>
		<xsl:when test="$relaToInsured='5'">01</xsl:when>
		<!-- 父母 -->
		<xsl:when test="$relaToInsured='6'">03</xsl:when>
		<xsl:when test="$relaToInsured='7'">03</xsl:when>
		<xsl:when test="$relaToInsured='1'">00</xsl:when>
		<!-- 本人 -->
		<xsl:otherwise>04</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 国籍转换 -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$nationality = '036'">AU</xsl:when>  <!-- 澳大利亚 -->
		<xsl:when test="$nationality = '156'">CHN</xsl:when> <!-- 中国  -->
		<xsl:when test="$nationality = '826'">GB</xsl:when>  <!-- 英国  -->
		<xsl:when test="$nationality = '392'">JP</xsl:when>  <!-- 日本  -->
		<xsl:when test="$nationality = '643'">RU</xsl:when>  <!-- 俄罗斯  -->
		<xsl:when test="$nationality = '840'">US</xsl:when>  <!-- 美国  -->
		<xsl:otherwise>OTH</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 健康告知  -->
<xsl:template name="tran_healthnotice">
<xsl:param name="healthnotice" />
<xsl:choose>
	<xsl:when test="$healthnotice=0">N</xsl:when>	<!-- 无健康告知 -->
	<xsl:when test="$healthnotice=1">Y</xsl:when>	<!-- 有健康告知 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
		
</xsl:stylesheet>