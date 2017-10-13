<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<RETURN>
		    <xsl:if test="Head/Flag='0'">
		       <ACKSTS>0</ACKSTS>
		       <STSDESC>正常</STSDESC>
		       <BUSI>
                 <SUBJECT>1</SUBJECT>
                 <TRANS></TRANS>
                 <PRINT>
                   <xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
                   <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Body/ContPlan/ContPlanMult,5,$leftPadFlag)"/>
                   <xsl:variable name="printmult1" select="concat('-(00001～',$ContPlanMultWith0)"/>
 	               <xsl:variable name="printmult2" select="concat($printmult1,')')"/>				   				
				    <PRINT_LINE/>
				    <PRINT_LINE/>
				    <PRINT_LINE><xsl:text>保险单号码：</xsl:text><xsl:value-of select="Body/ContNo" /><xsl:text>-(00001～</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
				    <xsl:text>                                  币值单位：人民币元</xsl:text></PRINT_LINE>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>投保人姓名：</xsl:text>
					   <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Appnt/Name, 29)"/>
					   <xsl:text>证件类型：</xsl:text>
					   <xsl:call-template name="tran_idtype">
							<xsl:with-param name="idtype">
								<xsl:value-of select="Body/Appnt/IDType"/>
							</xsl:with-param>
						</xsl:call-template>
					   <!--  <xsl:apply-templates select="Body/Appnt/IDType"/> -->
					   <xsl:text>       证件号码：</xsl:text>
					   <xsl:value-of select="Body/Appnt/IDNo"/>
				    </PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>被保险人：</xsl:text>
					   <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Insured/Name, 31)"/>
					   <xsl:text>证件类型：</xsl:text>
					   <xsl:call-template name="tran_idtype">
							<xsl:with-param name="idtype">
								<xsl:value-of select="Body/Insured/IDType"/>
							</xsl:with-param>
						</xsl:call-template>
					  <!--   <xsl:apply-templates select="Body/Insured/IDType"/>-->
					   <xsl:text>       证件号码：</xsl:text>
					   <xsl:value-of select="Body/Insured/IDNo"/>
				    </PRINT_LINE>
				    <PRINT_LINE/>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <xsl:if test="count(Body/Bnf) = 0">
				    <PRINT_LINE><xsl:text>身故受益人：法定                </xsl:text>
				       <xsl:text>受益顺序：1                   </xsl:text>
				       <xsl:text>受益比例：100%</xsl:text></PRINT_LINE>
		            </xsl:if>
				    <xsl:if test="count(Body/Bnf)>0">
					   <xsl:for-each select="Body/Bnf">
						  <PRINT_LINE>
							<xsl:text>身故受益人：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>受益顺序：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>受益比例：</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						 </PRINT_LINE>
					   </xsl:for-each>
				    </xsl:if>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				
				    <PRINT_LINE>险种资料</PRINT_LINE>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　基本保险金额\</xsl:text>
				    </PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>　　　　　　　险种名称               保险期间    交费年期     日津贴额\     保险费     交费频率</xsl:text>
				    </PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　份数\档次</xsl:text>
				    </PRINT_LINE>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <xsl:for-each select="Body/Risk">
					   <xsl:variable name="PayIntv" select="PayIntv"/>
					   <xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					   <xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
					   <xsl:choose>
						  <xsl:when test="RiskCode='L12081'">
						      <PRINT_LINE>
								<xsl:text>　　　</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 11)"/>
										<xsl:text/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 11)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 11)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',14)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:text>-</xsl:text>
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
							</PRINT_LINE>
						  </xsl:when>
						  <xsl:otherwise>
						     <PRINT_LINE>
						  <xsl:text></xsl:text>
						  <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
						  <xsl:choose>
							 <xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
							 </xsl:when>
							 <xsl:when test="InsuYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
							 </xsl:when>
							 <xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 11)"/>
								<xsl:text/>
							 </xsl:otherwise>
						  </xsl:choose>
						  <xsl:choose>
							 <xsl:when test="PayIntv = 0">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次交清', 10)"/>
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
					  </PRINT_LINE>
					      </xsl:otherwise>
					   </xsl:choose> 
				   </xsl:for-each>
				   <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				   <PRINT_LINE/>
				   <PRINT_LINE>保险费合计：<xsl:value-of select="Body/ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)"/>元整）</PRINT_LINE>
				   <PRINT_LINE/>
				   <PRINT_LINE/>
				   <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				   <PRINT_LINE/>	 
				   <PRINT_LINE>　　　<xsl:if test="Body/Risk[RiskCode=MainRiskCode]/RiskType='2'">分红保险红利领取方式：累积生息</xsl:if></PRINT_LINE>
				   <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				 	<PRINT_LINE>保险单特别约定：</PRINT_LINE>
					<PRINT_LINE>您购买的保险产品为《安邦长寿稳赢保险计划》。若您在保险合同生效两年内退保，本公司仅退还主险的</PRINT_LINE>
					<PRINT_LINE>现金价值。</PRINT_LINE>
					<PRINT_LINE>当安邦长寿稳赢1号两全保险到达合同约定的满期日时，该主险合同效力终止，附加险合同同时终止。不</PRINT_LINE>
					<PRINT_LINE>低于主险合同及附加险合同项下满期保险金之和的101.5%的金额将自动转入安邦长寿添利终身寿险（万能型）</PRINT_LINE>
					<PRINT_LINE>的个人账户中，该万能险合同自上述款项自动转入次日零时起生效。</PRINT_LINE>
					<PRINT_LINE/>
				   <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				   <PRINT_LINE><xsl:text>保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</PRINT_LINE>
				   <PRINT_LINE></PRINT_LINE>
				   <PRINT_LINE><xsl:text>营业机构：</xsl:text><xsl:value-of select="Body/ComName" /></PRINT_LINE>
				
				   <PRINT_LINE><xsl:text>营业地址：</xsl:text><xsl:value-of select="Body/ComLocation" /></PRINT_LINE>
				
				   <PRINT_LINE><xsl:text>客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></PRINT_LINE>
				   <PRINT_LINE></PRINT_LINE>
				   <PRINT_LINE><xsl:text>为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></PRINT_LINE>
				   <PRINT_LINE><xsl:text>限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></PRINT_LINE>
				   <PRINT_LINE></PRINT_LINE>
				   <PRINT_LINE><xsl:text>银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/AgentComName, 49)"/><xsl:text>银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/TellerName, 49)"/></PRINT_LINE>
                   <xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
                   <xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->	

                  <xsl:variable name="RiskCount" select="count(Risk)"/>				
				   <PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE><xsl:text>　　　                                        </xsl:text>现金价值表</PRINT_LINE>
					<PRINT_LINE/>
					<PRINT_LINE>保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(Body/ContNo,$printmult2), 60)"/>币值单位：人民币元 </PRINT_LINE>
					<PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
					<PRINT_LINE>被保险人姓名：<xsl:value-of select="Body/Insured/Name"/></PRINT_LINE>
	                <xsl:if test="$RiskCount=1">
			        <PRINT_LINE>
				    <xsl:text>险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRINT_LINE>
			        <PRINT_LINE><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
					   <xsl:text>现金价值</xsl:text></PRINT_LINE>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <PRINT_LINE><xsl:text/><xsl:text>　　</xsl:text>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</PRINT_LINE>
				    </xsl:for-each>
		            </xsl:if>
		 
		            <xsl:if test="$RiskCount!=1">
		 	        <PRINT_LINE>
				    <xsl:text>险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Body/Risk[RiskCode!=MainRiskCode]/RiskName"/></PRINT_LINE>
			        <PRINT_LINE><xsl:text/>保单年度末<xsl:text>                 </xsl:text>
					   <xsl:text>现金价值                                现金价值</xsl:text></PRINT_LINE>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <PRINT_LINE>
						 <xsl:text/><xsl:text>　　</xsl:text>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</PRINT_LINE>
				    </xsl:for-each>
		            </xsl:if>
					<PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
					<PRINT_LINE/>
					<PRINT_LINE>备注：</PRINT_LINE>
					<PRINT_LINE>所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</PRINT_LINE>
					<PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
			</xsl:if>
                 </PRINT>
               </BUSI>		   
		    </xsl:if>
		    <xsl:if test="Head/Flag!='0'">
		       <ACKSTS>0</ACKSTS>
		       <STSDESC>正常</STSDESC>
		       <BUSI>
                 <SUBJECT>1</SUBJECT>
                 <TRANS></TRANS>
                 <CONTENT>
                    <!-- 拒保原因代码,正常为0000 -->
                    <REJECT_CODE>0001</REJECT_CODE>
                    <!-- 拒保原因说明 -->
                    <REJECT_DESC><xsl:value-of select="Head/Desc"/></REJECT_DESC>
		         </CONTENT>
		        </BUSI>	        
		    </xsl:if>		
		</RETURN>
				
	</xsl:template>
	
<!-- 证件类型 -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype" />
<xsl:choose>
	<xsl:when test="$idtype='0'">身份证</xsl:when>	<!-- 身份证 -->
	<xsl:when test="$idtype='1'">护照</xsl:when>	<!-- 护照 -->
	<xsl:when test="$idtype='2'">军官证</xsl:when>	<!-- 军官证 -->
	<xsl:when test="$idtype='2'">武警证</xsl:when>	<!-- 武警证-军官证 -->
	<xsl:when test="$idtype='6'">港澳居民来往内地通行证</xsl:when>	<!-- 港澳居民来往内地通行证 -->
	<xsl:when test="$idtype='5'">户口簿</xsl:when>	<!-- 户口簿 -->
	<xsl:when test="$idtype='8'">其它</xsl:when>	<!-- 其它 -->
	<xsl:when test="$idtype='2'">警官证</xsl:when>	<!-- 警官证-军官证 -->
	<xsl:when test="$idtype='8'">执行公务证</xsl:when>	<!-- 执行公务证-其它 -->	
	<xsl:when test="$idtype='8'">士兵证</xsl:when>	<!-- 士兵证-其它 -->
	<xsl:when test="$idtype='7'">台湾居民来往大陆通行证</xsl:when>	<!-- 台湾居民来往大陆通行证 -->
	<xsl:when test="$idtype='0'">临时身份证</xsl:when>	<!-- 临时身份证-身份证 -->
	<xsl:when test="$idtype='8'">外国人居留证</xsl:when>	<!-- 外国人居留证-其它 -->
	<xsl:otherwise>7</xsl:otherwise>
</xsl:choose>
</xsl:template>
	
</xsl:stylesheet>