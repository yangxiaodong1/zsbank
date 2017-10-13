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
                 <SUBJECT>2</SUBJECT>
                 <TRANS></TRANS>
                 <CONTENT>
                    <!-- 拒保原因代码,正常为0000 -->
                    <REJECT_CODE>0000</REJECT_CODE>
                    <!-- 拒保原因说明 -->
                    <REJECT_DESC>交易成功</REJECT_DESC>
                    <!-- 投保单号 -->
                    <APPNO><xsl:value-of select="Body/ProposalPrtNo"/></APPNO>
                    <!-- 保单号 -->
                    <POL><xsl:value-of select="Body/ContNo"/></POL>
                    <MAIN>
                       <!-- 首期保费(大写) -->
                       <PREMC><xsl:value-of select="Body/ActSumPremText"/></PREMC>
                       <!-- 首期保费 -->
                       <PREM><xsl:value-of select="Body/ActSumPrem"/></PREM>
                    </MAIN>
                    <!-- 险种信息 -->
                    <xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
                    <PTS>
                       <PT>
                         <xsl:if test="Body/ContPlan/ContPlanCode = ''">
                            <!-- 险种代码 -->
                            <ID>
                              <xsl:call-template name="tran_riskcode">
			                      <xsl:with-param name="riskcode" select="$MainRisk/RiskCode" />
		                      </xsl:call-template>
                            </ID>
                            <!-- 险种名称 -->
                            <NAME><xsl:value-of select="$MainRisk/RiskName"/></NAME> 
                            <!-- 投保份数 -->
                            <UNIT><xsl:value-of select="$MainRisk/Mult"/></UNIT>
                         </xsl:if>
                         <xsl:if test="Body/ContPlan/ContPlanCode != ''">
                            <!-- 险种代码 -->
                            <ID>
                              <xsl:call-template name="tran_riskcode">
			                      <xsl:with-param name="riskcode" select="Body/ContPlan/ContPlanCode" />
		                      </xsl:call-template>
                            </ID>
                            <!-- 险种名称 -->
                            <NAME><xsl:value-of select="Body/ContPlan/ContPlanName"/></NAME> 
                            <!-- 投保份数 -->
                            <UNIT><xsl:value-of select="Body/ContPlan/ContPlanMult"/></UNIT>
                         </xsl:if>
                         <xsl:choose>
                            <!-- 缴费年期类型 -->
                            <xsl:when test="($MainRisk/PayEndYearFlag = 'Y') and ($MainRisk/PayEndYear = 1000)">
					           <!-- 趸交 -->
					           <CRG>1</CRG>
				            </xsl:when>
				            <xsl:when test="($MainRisk/PayEndYearFlag = 'Y') and ($MainRisk/PayEndYear != 1000)">
					           <!-- 年缴 -->
					           <CRG>2</CRG>
				            </xsl:when>
				            <xsl:when test="($MainRisk/PayEndYearFlag = 'A') and ($MainRisk/PayEndYear != 106)">
					           <!-- 缴至某确定年龄 -->
					           <CRG>6</CRG>
				            </xsl:when>
				            <xsl:when test="($MainRisk/PayEndYearFlag = 'A') and ($MainRisk/PayEndYear = 106)">
					           <!-- 终身 -->
					           <CRG>7</CRG>
				            </xsl:when>
				            <xsl:otherwise>
				               <CRG>
                                  <xsl:call-template name="tran_PayEndYearFlag">
			                         <xsl:with-param name="payendyearflag" select="$MainRisk/PayEndYearFlag" />
		                          </xsl:call-template>
                               </CRG>
				            </xsl:otherwise>
				         </xsl:choose>                        
                         <!-- 保障年期 -->
                         <xsl:choose>
                             <xsl:when test="Body/ContPlan/ContPlanCode = '50015'">
					            <!-- 终身 -->
					            <PERIOD>1</PERIOD>
				             </xsl:when>
                             <xsl:when test="($MainRisk/InsuYearFlag = 'A') and ($MainRisk/InsuYear = 106)">
					            <!-- 终身 -->
					            <PERIOD>1</PERIOD>
				             </xsl:when>
				             <xsl:otherwise>
				                 <PERIOD>
                                    <xsl:call-template name="tran_InsuYearFlag">
			                           <xsl:with-param name="insuyearflag" select="$MainRisk/InsuYearFlag" />
		                            </xsl:call-template>
                                 </PERIOD>
				             </xsl:otherwise>
                         </xsl:choose>
                         <!-- 年金起领年龄 -->
                         <DRAW_T></DRAW_T>
                         <!-- 保险金额 -->
                         <AMT><xsl:value-of select="Body/Amnt"/></AMT>
                         <!-- 投保金额 -->
                         <PREM><xsl:value-of select="Body/ActSumPrem"/></PREM>
                       </PT>
                    </PTS>
                    <!-- 现金价值表 -->
                    <xsl:choose>
                     <xsl:when test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
                       <VT>
                         <xsl:for-each select="$MainRisk/CashValues/CashValue">
                            <VTI>
                            <!-- 生存年金 -->
                            <LIVE></LIVE>
                            <!-- 疾病身故保险金 -->
                            <ILL></ILL>
                            <!-- 年份 -->
                            <YEAR></YEAR>
                            <!-- 年末 -->
                            <END><xsl:value-of select="EndYear"/>年末</END>
                            <!-- 年末现金价值 -->
                            <CASH><xsl:value-of select="Cash"/></CASH>
                            <!-- 意外身故保险金 -->
                            <ACI></ACI>
                        </VTI>
                         </xsl:for-each>
                       </VT>
                    </xsl:when>
                    <xsl:otherwise> <!-- 没有现金价值 -->
                       <VT>
                         <VTI>
                            <!-- 生存年金 -->
                            <LIVE></LIVE>
                            <!-- 疾病身故保险金 -->
                            <ILL></ILL>
                            <!-- 年份 -->
                            <YEAR></YEAR>
                            <!-- 年末 -->
                            <END></END>
                            <!-- 年末现金价值 -->
                            <CASH></CASH>
                            <!-- 意外身故保险金 -->
                            <ACI></ACI>
                        </VTI>
                      </VT>
                     </xsl:otherwise>
                   </xsl:choose> 
                 </CONTENT>
               </BUSI>		   
		    </xsl:if>
		    <xsl:if test="Head/Flag!='0'">
		       <ACKSTS>0</ACKSTS>
		       <STSDESC>正常</STSDESC>
		       <BUSI>
                 <SUBJECT>2</SUBJECT>
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
	<!-- 险种代码 -->
	<xsl:template name="tran_riskcode">
       <xsl:param name="riskcode" />
       <xsl:choose>
	     <xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- 安邦盛世2号终身寿险（万能型） -->
	     <xsl:when test="$riskcode='50015'">53000001</xsl:when>	<!-- 安邦长寿稳赢1号两全保险组合 -->	
	     <!-- guning -->
	      <xsl:when test="$riskcode='L12074'">53000002</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->	
	     <xsl:otherwise>--</xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    <!-- 缴费年期年龄标志 -->
    <xsl:template name="tran_PayEndYearFlag">
       <xsl:param name="payendyearflag" />
       <xsl:choose>
	     <xsl:when test="$payendyearflag='Y'">1</xsl:when>	<!-- 趸缴 -->
	     <xsl:when test="$payendyearflag='Y'">2</xsl:when>	<!-- 按年 -->
	     <xsl:when test="$payendyearflag='M'">5</xsl:when>	<!-- 按月 -->
	     <xsl:when test="$payendyearflag='A'">6</xsl:when>    <!-- 到某确定年龄 -->
	     <xsl:when test="$payendyearflag='A'">7</xsl:when>    <!-- 终身 -->
	     <xsl:otherwise>--</xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    <!-- 保险年龄年期标志 -->
    <xsl:template name="tran_InsuYearFlag">
      <xsl:param name="insuyearflag" />
      <xsl:choose>
	     <xsl:when test="$insuyearflag='D'">5</xsl:when>	<!-- 按日 -->
	     <xsl:when test="$insuyearflag='M'">4</xsl:when>	<!-- 按月 -->
	     <xsl:when test="$insuyearflag='Y'">2</xsl:when>	<!-- 按年 -->
	     <xsl:when test="$insuyearflag='A'">1</xsl:when>   <!-- 终身 -->
	     <xsl:when test="$insuyearflag='A'">3</xsl:when>   <!-- 到某确定年龄 -->
	     <xsl:otherwise>--</xsl:otherwise>
      </xsl:choose>
    </xsl:template>
</xsl:stylesheet>