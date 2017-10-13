<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
	  <!--由中科软标准报文转换为农行非标准报文-->
	  <Ret>
	  	<!-- 返回数据包 -->
	  <RetData>
	  		<Flag>
	  		  <xsl:if test="Head/Flag='0'">1</xsl:if>
	  		  <xsl:if test="Head/Flag='1'">0</xsl:if>
	  		</Flag>
	  		<Mesg><xsl:value-of select ="Head/Desc"/></Mesg>
	  	</RetData>
		<!-- 如果交易成功，才返回下面的结点 -->
		<xsl:if test="Head/Flag='0'">
			<!--投保信息-->
			<Base>
				<ContNo><xsl:value-of select ="Body/ContNo"/></ContNo>
				<ProposalContNo><xsl:value-of select ="Body/ProposalPrtNo"/></ProposalContNo>
				<SignDate><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/SignDate"/></SignDate>
				<RiskName><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/RiskName"/></RiskName>
				<BankAccName><xsl:value-of select ="Body/BankAccName"/></BankAccName>
				<AgentCode><xsl:value-of select ="Body/AgentCode"/></AgentCode>
		    	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/></Prem>
		    	<ContBgnDate><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/CValiDate"/></ContBgnDate>
		    	<ContEndDate><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/InsuEndDate"/></ContEndDate>
				<ComPhone>95569</ComPhone>
			</Base>
			<!-- 险种列表 -->
			<Risks>
				<Count><xsl:value-of select="count(Body/Risk)"/></Count>
				<xsl:for-each select="Body/Risk">
					<!-- 险种 -->
					<Risk>
						<Name><xsl:value-of select="RiskName"/></Name>
						<Mult><xsl:value-of select="Mult"/></Mult>
						<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/></Prem>
						<PayEndYear><xsl:value-of select="PayEndYear"/></PayEndYear>
						<PayIntv><xsl:call-template name="tran_PayIntv">
								<xsl:with-param name="payIntv">
									<xsl:value-of select="PayIntv"/>
								</xsl:with-param>
							</xsl:call-template>
						</PayIntv>
					</Risk>
				</xsl:for-each>
			</Risks>
		<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
        <!-- 险种打印列表 -->
        <Prnts>
        	<Count></Count>
        	<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
            <Prnt>
              <Value>保险单号码：<xsl:value-of select="Body/ContNo"/>                                                    币值单位：人民币元</Value>
            </Prnt>
            <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
            <Prnt>
              <Value>投保人姓名：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Appnt/Name, 29)"/>证件类型：<xsl:call-template name="tran_IDType"><xsl:with-param name="idtype"><xsl:value-of select ="Body/Appnt/IDType"/></xsl:with-param></xsl:call-template>    证件号码：<xsl:value-of select="Body/Appnt/IDNo"/></Value>
            </Prnt>
            <Prnt>
              <Value>被保险人：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Insured/Name, 31)"/>证件类型：<xsl:call-template name="tran_IDType"><xsl:with-param name="idtype"><xsl:value-of select ="Body/Insured/IDType"/></xsl:with-param></xsl:call-template>    证件号码：<xsl:value-of select="Body/Insured/IDNo"/></Value>
            </Prnt>
            <Prnt>
            	<Value />
            </Prnt>
            <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <xsl:if test="count(Body/Bnf)=0">
		    	<Prnt>
		    		<Value><xsl:text>身故受益人：法定                </xsl:text>
		    				<xsl:text>受益顺序：1                   </xsl:text>
		    				<xsl:text>受益比例：100%</xsl:text></Value>
		    	</Prnt>
            </xsl:if>
            <xsl:if test="count(Body/Bnf)!=0">
            	<xsl:for-each select="Body/Bnf">
            		<Prnt>
            			<Value>身故受益人：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>受益顺序：<xsl:value-of select="Grade"/>                受益比例：<xsl:value-of select="Lot"/>%</Value> 
            		</Prnt>
            	</xsl:for-each>
            </xsl:if>
            <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
		    	<Value />
            </Prnt>
		    <Prnt>
            	<Value>险种资料</Value>
		    </Prnt>
		    <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
		    	<Value><xsl:text>　　　　　　　　　　                                        基本保险金额\</xsl:text></Value>
            </Prnt>
		    <Prnt>
		    	<Value><xsl:text>　　　　　　　险种名称                保险期间    交费年期    日津贴额\      保险费     交费频率</xsl:text></Value>
		    	
            </Prnt>
            <Prnt>
            	<Value><xsl:text>　　　　　　　　　　                                        份数\档次</xsl:text></Value>
            </Prnt>
            <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <xsl:for-each select="Body/Risk">
		    	<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
		    	<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
		    	<xsl:variable name="Falseflag" select="java:java.lang.Boolean.parseBoolean('true')"/>
		    	<Prnt>
		    		<Value><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
		    		<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 11)"/>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次性', 10)"/>
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
								</xsl:choose></Value>
				</Prnt>
			</xsl:for-each>
			<Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
				<Value><xsl:text/>保险费合计：<xsl:value-of select="Body/PremText"/>（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/>元整）</Value>
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
		    	<Prnt>
	        		<Value>分红保险红利领取方式：累积生息</Value>
				</Prnt>
		    </xsl:if>
		    <xsl:if test="$MainRisk/CashValues = ''"> <!-- 当无现金价值时，打印“此页空白” -->
			    <Prnt>
	        		<Value />
				</Prnt>
		    </xsl:if>
		    
			<Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
		    	<Value>保险单特别约定：<xsl:choose>
								<xsl:when test="Body/Risk[RiskCode=MainRiskCode]/SpecContent = ''">
									<xsl:text>（无）</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="Body/Risk[RiskCode=MainRiskCode]/SpecContent"/>
								</xsl:otherwise>
							</xsl:choose></Value>
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
		    	<Value><xsl:text>保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/SignDate,1,4)"/>年<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/SignDate,5,2)"/>月<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/SignDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</Value>
		    </Prnt>
		    <!--  -->
		    <Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
		    <Prnt>
		    	<Value><xsl:text>营业机构：</xsl:text><xsl:value-of select="Body/ComName" /></Value>
		    </Prnt>
		    <Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value><xsl:text>营业地址：</xsl:text><xsl:value-of select="Body/ComLocation" /></Value>
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value><xsl:text>客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></Value>
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value><xsl:text>为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></Value>
			</Prnt>
			<Prnt>
        		<Value><xsl:text>限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></Value>
			</Prnt>
	</Prnts>

<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->	
<Messages>
	<Count></Count>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
    <Message>
       <Value><xsl:text>　　　                                        </xsl:text>现金价值表</Value>
    </Message>
     <Message>
       <Value>保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/ContNo, 60)"/>币值单位：人民币元</Value>
    </Message>
    <Message>
    	<Value>------------------------------------------------------------------------------------------------</Value> 
    </Message>
    <Message>
    	<Value>被保险人姓名：<xsl:value-of select="Body/Insured/Name"/></Value>
    </Message>
    <xsl:variable name="RiskCount" select="count(Body/Risk)"/>
    <xsl:if test="$RiskCount=1">
    	<Message>
    		<Value><xsl:text>险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Value>
    	</Message>
    	<Message>
    		<Value><xsl:text>保单年度末                              现金价值</xsl:text></Value>
    	</Message>
    	<xsl:for-each select="$MainRisk/CashValues/CashValue">
    		<Message>
    			<Value><xsl:text>　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</Value>
    		</Message>
    	</xsl:for-each>
    </xsl:if>
    <xsl:if test="$RiskCount!=1">
    	<Message>
    		<Value><xsl:text>险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Body/Risk[RiskCode!=MainRiskCode]/RiskName"/></Value>
    	</Message>
    	<Message>
    		<Value><xsl:text>保单年度末                                        现金价值</xsl:text></Value>
    	</Message>
    	<xsl:for-each select="$MainRisk/CashValues/CashValue">
    		<xsl:variable name="EndYear" select="EndYear"/>
    		<Message>
    			<Value><xsl:text>　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</Value>
    		</Message>
    	</xsl:for-each>
    </xsl:if>
    <Message>
    	<Value>------------------------------------------------------------------------------------------------</Value> 
    </Message>
    <Message>
		<Value />
	</Message>
	<Message>
		<Value>备注:</Value>
	</Message>
	<Message>
		<Value>所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</Value>
	</Message>
	<Message>
    	<Value>------------------------------------------------------------------------------------------------</Value> 
    </Message>
</Messages>
</xsl:if>

<xsl:if test="$MainRisk/CashValues = ''"> <!-- 当无现金价值时，打印“此页空白” -->
<Messages>
	<Count>0</Count>  
</Messages>
</xsl:if>

 </xsl:if> <!-- 如果交易成功，才返回上面的结点 -->		
 					  
 </Ret>
	</xsl:template>
	
	<!-- 缴费频次  银行: 1：趸交  2：月交     3：季交    4：半年交    5：年交             6：不定期
                    核心:  0：一次交清/趸交 1:月交  3:季交   6:半年交	   12：年交          -1:不定期交 -->
	<xsl:template name="tran_PayIntv">
		<xsl:param name="payIntv">0</xsl:param>
		<xsl:if test="$payIntv = '0'">1</xsl:if>
		<xsl:if test="$payIntv = '1'">2</xsl:if>
		<xsl:if test="$payIntv = '3'">3</xsl:if>
		<xsl:if test="$payIntv = '6'">4</xsl:if>
		<xsl:if test="$payIntv = '12'">5</xsl:if>
		<xsl:if test="$payIntv = '-1'">6</xsl:if>
	</xsl:template>
	
    <xsl:template name="tran_PayIntvCha">
		<xsl:param name="payIntv">0</xsl:param>
		<xsl:if test="$payIntv = '0'">趸交</xsl:if>
		<xsl:if test="$payIntv = '1'">月交</xsl:if>
		<xsl:if test="$payIntv = '3'">季交</xsl:if>
		<xsl:if test="$payIntv = '6'">半年交</xsl:if>
		<xsl:if test="$payIntv = '12'">年交</xsl:if>
		<xsl:if test="$payIntv = '-1'">不定期交</xsl:if>
	</xsl:template>
	   <xsl:template name="tran_IDType">
		<xsl:param name="idtype">身份证</xsl:param>
		<xsl:if test="$idtype = '0'">身份证    </xsl:if>
		<xsl:if test="$idtype = '1'">护照      </xsl:if>
		<xsl:if test="$idtype = '2'">军官证    </xsl:if>
		<xsl:if test="$idtype = '5'">户口簿    </xsl:if>
		<xsl:if test="$idtype = '9'">异常身份证</xsl:if>
		<xsl:if test="$idtype = '8'">其他      </xsl:if>
	</xsl:template>
</xsl:stylesheet>