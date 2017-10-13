<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<RETURN>
		    <xsl:if test="Head/Flag='0'">
		       <ACKSTS>0</ACKSTS>
		       <STSDESC>����</STSDESC>
		       <BUSI>
                 <SUBJECT>2</SUBJECT>
                 <TRANS></TRANS>
                 <CONTENT>
                    <!-- �ܱ�ԭ�����,����Ϊ0000 -->
                    <REJECT_CODE>0000</REJECT_CODE>
                    <!-- �ܱ�ԭ��˵�� -->
                    <REJECT_DESC>���׳ɹ�</REJECT_DESC>
                    <!-- Ͷ������ -->
                    <APPNO><xsl:value-of select="Body/ProposalPrtNo"/></APPNO>
                    <!-- ������ -->
                    <POL><xsl:value-of select="Body/ContNo"/></POL>
                    <MAIN>
                       <!-- ���ڱ���(��д) -->
                       <PREMC><xsl:value-of select="Body/ActSumPremText"/></PREMC>
                       <!-- ���ڱ��� -->
                       <PREM><xsl:value-of select="Body/ActSumPrem"/></PREM>
                    </MAIN>
                    <!-- ������Ϣ -->
                    <xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
                    <PTS>
                       <PT>
                         <xsl:if test="Body/ContPlan/ContPlanCode = ''">
                            <!-- ���ִ��� -->
                            <ID>
                              <xsl:call-template name="tran_riskcode">
			                      <xsl:with-param name="riskcode" select="$MainRisk/RiskCode" />
		                      </xsl:call-template>
                            </ID>
                            <!-- �������� -->
                            <NAME><xsl:value-of select="$MainRisk/RiskName"/></NAME> 
                            <!-- Ͷ������ -->
                            <UNIT><xsl:value-of select="$MainRisk/Mult"/></UNIT>
                         </xsl:if>
                         <xsl:if test="Body/ContPlan/ContPlanCode != ''">
                            <!-- ���ִ��� -->
                            <ID>
                              <xsl:call-template name="tran_riskcode">
			                      <xsl:with-param name="riskcode" select="Body/ContPlan/ContPlanCode" />
		                      </xsl:call-template>
                            </ID>
                            <!-- �������� -->
                            <NAME><xsl:value-of select="Body/ContPlan/ContPlanName"/></NAME> 
                            <!-- Ͷ������ -->
                            <UNIT><xsl:value-of select="Body/ContPlan/ContPlanMult"/></UNIT>
                         </xsl:if>
                         <xsl:choose>
                            <!-- �ɷ��������� -->
                            <xsl:when test="($MainRisk/PayEndYearFlag = 'Y') and ($MainRisk/PayEndYear = 1000)">
					           <!-- ���� -->
					           <CRG>1</CRG>
				            </xsl:when>
				            <xsl:when test="($MainRisk/PayEndYearFlag = 'Y') and ($MainRisk/PayEndYear != 1000)">
					           <!-- ��� -->
					           <CRG>2</CRG>
				            </xsl:when>
				            <xsl:when test="($MainRisk/PayEndYearFlag = 'A') and ($MainRisk/PayEndYear != 106)">
					           <!-- ����ĳȷ������ -->
					           <CRG>6</CRG>
				            </xsl:when>
				            <xsl:when test="($MainRisk/PayEndYearFlag = 'A') and ($MainRisk/PayEndYear = 106)">
					           <!-- ���� -->
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
                         <!-- �������� -->
                         <xsl:choose>
                             <xsl:when test="Body/ContPlan/ContPlanCode = '50015'">
					            <!-- ���� -->
					            <PERIOD>1</PERIOD>
				             </xsl:when>
                             <xsl:when test="($MainRisk/InsuYearFlag = 'A') and ($MainRisk/InsuYear = 106)">
					            <!-- ���� -->
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
                         <!-- ����������� -->
                         <DRAW_T></DRAW_T>
                         <!-- ���ս�� -->
                         <AMT><xsl:value-of select="Body/Amnt"/></AMT>
                         <!-- Ͷ����� -->
                         <PREM><xsl:value-of select="Body/ActSumPrem"/></PREM>
                       </PT>
                    </PTS>
                    <!-- �ֽ��ֵ�� -->
                    <xsl:choose>
                     <xsl:when test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
                       <VT>
                         <xsl:for-each select="$MainRisk/CashValues/CashValue">
                            <VTI>
                            <!-- ������� -->
                            <LIVE></LIVE>
                            <!-- ������ʱ��ս� -->
                            <ILL></ILL>
                            <!-- ��� -->
                            <YEAR></YEAR>
                            <!-- ��ĩ -->
                            <END><xsl:value-of select="EndYear"/>��ĩ</END>
                            <!-- ��ĩ�ֽ��ֵ -->
                            <CASH><xsl:value-of select="Cash"/></CASH>
                            <!-- ������ʱ��ս� -->
                            <ACI></ACI>
                        </VTI>
                         </xsl:for-each>
                       </VT>
                    </xsl:when>
                    <xsl:otherwise> <!-- û���ֽ��ֵ -->
                       <VT>
                         <VTI>
                            <!-- ������� -->
                            <LIVE></LIVE>
                            <!-- ������ʱ��ս� -->
                            <ILL></ILL>
                            <!-- ��� -->
                            <YEAR></YEAR>
                            <!-- ��ĩ -->
                            <END></END>
                            <!-- ��ĩ�ֽ��ֵ -->
                            <CASH></CASH>
                            <!-- ������ʱ��ս� -->
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
		       <STSDESC>����</STSDESC>
		       <BUSI>
                 <SUBJECT>2</SUBJECT>
                 <TRANS></TRANS>
                 <CONTENT>
                    <!-- �ܱ�ԭ�����,����Ϊ0000 -->
                    <REJECT_CODE>0001</REJECT_CODE>
                    <!-- �ܱ�ԭ��˵�� -->
                    <REJECT_DESC><xsl:value-of select="Head/Desc"/></REJECT_DESC>
		         </CONTENT>
		        </BUSI>	   
		    </xsl:if>		
		</RETURN>
	</xsl:template>
	<!-- ���ִ��� -->
	<xsl:template name="tran_riskcode">
       <xsl:param name="riskcode" />
       <xsl:choose>
	     <xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	     <xsl:when test="$riskcode='50015'">53000001</xsl:when>	<!-- �������Ӯ1����ȫ������� -->	
	     <!-- guning -->
	      <xsl:when test="$riskcode='L12074'">53000002</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->	
	     <xsl:otherwise>--</xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    <!-- �ɷ����������־ -->
    <xsl:template name="tran_PayEndYearFlag">
       <xsl:param name="payendyearflag" />
       <xsl:choose>
	     <xsl:when test="$payendyearflag='Y'">1</xsl:when>	<!-- ���� -->
	     <xsl:when test="$payendyearflag='Y'">2</xsl:when>	<!-- ���� -->
	     <xsl:when test="$payendyearflag='M'">5</xsl:when>	<!-- ���� -->
	     <xsl:when test="$payendyearflag='A'">6</xsl:when>    <!-- ��ĳȷ������ -->
	     <xsl:when test="$payendyearflag='A'">7</xsl:when>    <!-- ���� -->
	     <xsl:otherwise>--</xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    <!-- �����������ڱ�־ -->
    <xsl:template name="tran_InsuYearFlag">
      <xsl:param name="insuyearflag" />
      <xsl:choose>
	     <xsl:when test="$insuyearflag='D'">5</xsl:when>	<!-- ���� -->
	     <xsl:when test="$insuyearflag='M'">4</xsl:when>	<!-- ���� -->
	     <xsl:when test="$insuyearflag='Y'">2</xsl:when>	<!-- ���� -->
	     <xsl:when test="$insuyearflag='A'">1</xsl:when>   <!-- ���� -->
	     <xsl:when test="$insuyearflag='A'">3</xsl:when>   <!-- ��ĳȷ������ -->
	     <xsl:otherwise>--</xsl:otherwise>
      </xsl:choose>
    </xsl:template>
</xsl:stylesheet>