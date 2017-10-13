<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>

	<xsl:template match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<App>
			<Ret>
				<!-- 退保可返还金额 -->
				<Amt>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/GetMoney)" />
				</Amt>
				<!-- 退保手续费 -->
				<FeeAmt>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/GetCharge)" />
				</FeeAmt>
				<!-- 保单到期日 -->
				<ExpireDate>
					<xsl:value-of
						select="$MainRisk/InsuEndDate" />
				</ExpireDate>
				<!-- 现金价值打印行数 java中动态赋值-->
				<PrntCount></PrntCount>
				<xsl:if test="$MainRisk/CashValues/CashValue != ''"> 
					<!-- 当有现金价值时，打印现金价值 -->	
					<xsl:variable name="RiskCount" select="count(Risk)"/>
				    <Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt><xsl:text>　　　                                        </xsl:text>现金价值表</Prnt>
					<Prnt/>
					<Prnt>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </Prnt>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></Prnt>
	                <xsl:if test="$RiskCount=1">
				        <Prnt>
					    <xsl:text>　　　险种名称：                   </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Prnt>
				        <Prnt><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
						   <xsl:text>现金价值</xsl:text></Prnt>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <Prnt><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</Prnt>
					    </xsl:for-each>
		            </xsl:if>
		 
		            <xsl:if test="$RiskCount!=1">
			 	        <Prnt>
					    <xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,40)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Prnt>
				        <Prnt><xsl:text/>　　　保单年度末<xsl:text>                                        </xsl:text>
						   <xsl:text>现金价值</xsl:text></Prnt>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <Prnt>
							 <xsl:text/><xsl:text>　　　　　</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,24)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</Prnt>
					    </xsl:for-each>
		            </xsl:if>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>
					<Prnt/>
					<Prnt>　　　备注：</Prnt>
					<Prnt>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</Prnt>
					<Prnt>　　　------------------------------------------------------------------------------------------------</Prnt>		
				</xsl:if>
			</Ret>
		</App>
	</xsl:template>
</xsl:stylesheet>
