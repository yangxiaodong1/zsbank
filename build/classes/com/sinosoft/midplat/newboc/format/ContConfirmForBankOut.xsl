<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<InsuRet>
		   <Main>
		      <xsl:if test="Head/Flag='0'">
		        <ResultCode>0000</ResultCode>
		        <ResultInfo><xsl:value-of select="Head/Desc"/></ResultInfo>	   
		      </xsl:if>
		      <xsl:if test="Head/Flag!='0'">
		        <ResultCode>0001</ResultCode>
		        <ResultInfo><xsl:value-of select="Head/Desc"/></ResultInfo>	   
		      </xsl:if>
		   </Main>
		   <xsl:if test="Head/Flag='0'">
		      <xsl:apply-templates select="Body" />	   
		   </xsl:if>
		</InsuRet>
	</xsl:template>
	
	<xsl:template name="Base" match="Body">
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />		
			<!--保单信息-->	
			<Policy>
				<!-- 投保单号 -->
				<ApplyNo><xsl:value-of select ="ProposalPrtNo"/></ApplyNo>
				<!-- 保单号 -->
				<PolicyNo><xsl:value-of select ="ContNo"/></PolicyNo>
				<!-- 保单印刷号 -->
				<PrintNo><xsl:value-of select="ContPrtNo"/></PrintNo>
				<!-- 投保日期 -->
				<ApplyDate><xsl:value-of select="$MainRisk/PolApplyDate"/></ApplyDate>
				<!-- 首期总保费 -->
				<TotalPrem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></TotalPrem>
				<!-- 主险保额 -->
				<InsuAmount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/Amnt)"/></InsuAmount>
				<!-- 缴费终止日期 -->
				<PayEndDate><xsl:value-of select="$MainRisk/PayEndDate"/></PayEndDate>
				<!-- 保单生效日期 -->
				<PolEffDate><xsl:value-of select="$MainRisk/CValiDate"/></PolEffDate>
				<!-- 保单终止日期 -->
				<xsl:choose>
	               <xsl:when test="($MainRisk/InsuYear = 106) and ($MainRisk/InsuYearFlag = 'A')">
	                   <PolEndDate>99999999</PolEndDate>
	               </xsl:when>
	               <xsl:otherwise>
	                   <PolEndDate><xsl:value-of select="$MainRisk/InsuEndDate"/></PolEndDate>
	               </xsl:otherwise>
				</xsl:choose>
			</Policy>
			
			<Print>
				<!-- 凭证类型个数 -->
				<PaperTypeCount>1</PaperTypeCount>
          		<Paper>
          			<!-- 凭证类型 1:保单-->
          			<PaperType>1</PaperType>
					<!-- 打印凭证说明 -->
          			<PaperTitle>安邦人寿保险股份有限公司保单</PaperTitle>
          			<!-- 凭证页数 -->
          			<PageCount>1</PageCount>
          			<PageContent>
          				<!-- 凭证每页行数 自动计算-->
          				<RowCount></RowCount>
          				<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
          				<xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>	
			   			<Details>
					      <Row></Row>
                          <Row></Row>
                          <Row></Row>
                          <Row></Row>
                          <Row></Row>
                          <Row></Row>
                          <Row></Row>
                          <Row></Row>
                          <Row><xsl:text>　　　      保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001～</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" /><xsl:text>                                                    币值单位：人民币元</xsl:text></Row>
                          <Row>　　　      ------------------------------------------------------------------------------------------------</Row>
                          <Row>
                             <xsl:text>　　　      投保人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
                             <xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Appnt/IDType" />
                             <xsl:text>      证件号码：</xsl:text><xsl:value-of select="Appnt/IDNo" />
                          </Row>
                          <Row>
                             <xsl:text>　　　      被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
                             <xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Insured/IDType" />
                             <xsl:text>      证件号码：</xsl:text><xsl:value-of select="Insured/IDNo" />
                          </Row>
                          <Row></Row>
                          <Row>　　　      ------------------------------------------------------------------------------------------------</Row>
                          <Row>　　　      ------------------------------------------------------------------------------------------------</Row>
                          <xsl:if test="count(Bnf) = 0">
	                        <Row><xsl:text>　　　      身故受益人：法定                </xsl:text>
	                            <xsl:text>受益顺序：1                   </xsl:text>
	                            <xsl:text>受益比例：100%</xsl:text></Row>
                          </xsl:if>
                          <xsl:if test="count(Bnf)>0">
	                         <xsl:for-each select="Bnf">
		                        <Row>
		                          <xsl:text>　　　      身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
		                          <xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
		                          <xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
		                        </Row>
	                         </xsl:for-each>
                          </xsl:if>
                          <Row>　　　      ------------------------------------------------------------------------------------------------</Row>
                          <Row></Row>
                          <Row>　　　      险种资料</Row>
                          <Row>　　　      ------------------------------------------------------------------------------------------------</Row>
                          <Row><xsl:text>　　　　　　　                                                         基本保险金额\</xsl:text></Row>
                          <Row><xsl:text>　　　　　　　　　　      险种名称               保险期间    交费年期    日津贴额\      保险费    交费频率</xsl:text></Row>
                          <Row><xsl:text>　　　　　　　                                                           份数\档次</xsl:text></Row>
                          <Row>　　　      ------------------------------------------------------------------------------------------------</Row>
                          <xsl:for-each select="Risk">
	                      <xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
	                      <xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
	                      <Row><xsl:text>　　　      </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
	                                        <xsl:choose>
	                                            <xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 9)"/>
	                                            </xsl:when>
	                                            <xsl:when test="InsuYearFlag = 'Y'">
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 9)"/>
	                                            </xsl:when>
	                                            <xsl:otherwise>
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 9)"/>
	                                                <xsl:text></xsl:text>
	                                            </xsl:otherwise>
	                                        </xsl:choose>
	                                        <xsl:choose>
	                                            <xsl:when test="PayIntv = 0">
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次交清', 12)"/>
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
	                      </Row>
                          </xsl:for-each>
                          <Row>　　　      ------------------------------------------------------------------------------------------------</Row>
                          <Row>　　　      保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</Row>
                          <Row>　　　      ------------------------------------------------------------------------------------------------</Row>
                          <Row>　　　      ------------------------------------------------------------------------------------------------</Row>
                          <xsl:variable name="SpecContent" select="$MainRisk/SpecContent"/>
                          <Row>　　　      保险单特别约定：<xsl:choose>
                                        <xsl:when test="$SpecContent=''">
                                            <xsl:text>（无）</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <Row>　　　    您购买的保险产品为《安邦长寿稳赢保险计划》。若您在保险合同生效两年内退保，本公司仅退还主险的</Row>
											<Row>　　　现金价值。</Row>
											<Row>　　　    当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同同时终止。不</Row>
											<Row>　　　低于主险合同及附加险合同项下满期保险金之和的104%的金额将自动转入安邦长寿添利终身寿险（万能型）的</Row>
											<Row>　　　个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</Row>
                                        </xsl:otherwise>
                                    </xsl:choose></Row>
                          <Row></Row>
                          <Row></Row>
                          <Row>　　　      -------------------------------------------------------------------------------------------------</Row>
                          <Row><xsl:text>　　　      保险合同成立日期：</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy年MM月dd日')"/><xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy年MM月dd日')"/></Row>
                          <Row></Row>
                          <Row><xsl:text>　　　      营业机构：</xsl:text><xsl:value-of select="ComName" /></Row>
                          <Row><xsl:text>　　　      营业地址：</xsl:text><xsl:value-of select="ComLocation" /></Row>
                          <Row><xsl:text>　　　      客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></Row>
                          <Row></Row>
                          <Row><xsl:text>　　　      为确保您的保单权益，请及时拔打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></Row>
                          <Row><xsl:text>　　　      限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></Row>
                          <Row/>
                          <Row><xsl:text>　　　      银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 45)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 20)"/></Row>
                          <Row><xsl:text>　　　      银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 45)"/><xsl:text>从业资格证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 20)"/></Row>
	   				   </Details>
	   				   <xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
						<xsl:variable name="RiskCount" select="count(Risk)"/>
						<xsl:variable name="printmult1" select="concat('-(00001～',$ContPlanMultWith0)"/>
	 	        		<xsl:variable name="printmult2" select="concat($printmult1,')')"/>
					    <Details>
							<Row/>
							<Row/>
							<Row/>
							<Row/>
							<Row/>
							<Row/>
							<Row/>
							<Row/>
							<Row><xsl:text>　　　                                        </xsl:text>现金价值表</Row>
							<Row/>
							<Row>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>币值单位：人民币元 </Row>
							<Row>　　　------------------------------------------------------------------------------------------------</Row>
							<Row>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></Row>
	                			<xsl:if test="$RiskCount=1">
			        		<Row>
				    		<xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Row>
			        		<Row><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
					   			<xsl:text>现金价值</xsl:text></Row>
			   	       			<xsl:variable name="EndYear" select="EndYear"/>
			       		 	<xsl:for-each select="$MainRisk/CashValues/CashValue">
				    		<xsl:variable name="EndYear" select="EndYear"/>
				   			<Row><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</Row>
				    		</xsl:for-each>
		            		</xsl:if>
		 
		            		<xsl:if test="$RiskCount!=1">
		 	        		<Row>
				    		<xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Row>
			       			<Row><xsl:text/>　　　保单年度末<xsl:text>                 </xsl:text>
					   			<xsl:text>现金价值                                现金价值</xsl:text></Row>
			   	       			<xsl:variable name="EndYear" select="EndYear"/>
			        		<xsl:for-each select="$MainRisk/CashValues/CashValue">
				    		<xsl:variable name="EndYear" select="EndYear"/>
				    		<Row>
						 		<xsl:text/><xsl:text>　　　　　</xsl:text>
						 		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
						 		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
						 		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</Row>
				    		</xsl:for-each>
		            		</xsl:if>
							<Row>　　　------------------------------------------------------------------------------------------------</Row>
							<Row/>
							<Row>　　　备注：</Row>
							<Row>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</Row>
							<Row>　　　------------------------------------------------------------------------------------------------</Row>
						</Details>
						</xsl:if>
        			</PageContent>
        		</Paper>
			</Print>
	</xsl:template>	

	<!--证件类型  -->
	<xsl:template name="tran_IDType" match="IDType">
	<xsl:choose>
		<xsl:when test=".=0">身份证    </xsl:when>	<!-- 身份证 -->
		<xsl:when test=".=1">护照      </xsl:when>	<!-- 护照   -->
		<xsl:when test=".=2">军官证    </xsl:when>	<!-- 军官证 -->
		<xsl:when test=".=8">其他      </xsl:when>	<!-- 其他   -->
		<xsl:when test=".=5">户口簿    </xsl:when>	<!-- 户口簿 -->
		<xsl:when test=".=6">港澳回乡证</xsl:when>	<!-- 港澳回乡证 -->
		<xsl:when test=".=7">台胞证	 </xsl:when>	<!-- 台胞证 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!-- 性别 -->
	<xsl:template name="tran_sex" match="Sex">
	<xsl:choose>      
		<xsl:when test=".=0">男  </xsl:when>	<!-- 男 -->
		<xsl:when test=".=1">女  </xsl:when>	<!-- 女 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	</xsl:template> 
	
	<xsl:template match="InsuYearFlag">
	<xsl:choose>
	    <xsl:when test=".= 'Y'">年</xsl:when>
		<xsl:when test=".= 'A'">岁</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="InsuYearFlag"/>
		</xsl:otherwise>
	</xsl:choose>
 </xsl:template>
</xsl:stylesheet>