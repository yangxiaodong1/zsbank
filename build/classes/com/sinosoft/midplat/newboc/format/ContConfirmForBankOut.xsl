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
			<!--������Ϣ-->	
			<Policy>
				<!-- Ͷ������ -->
				<ApplyNo><xsl:value-of select ="ProposalPrtNo"/></ApplyNo>
				<!-- ������ -->
				<PolicyNo><xsl:value-of select ="ContNo"/></PolicyNo>
				<!-- ����ӡˢ�� -->
				<PrintNo><xsl:value-of select="ContPrtNo"/></PrintNo>
				<!-- Ͷ������ -->
				<ApplyDate><xsl:value-of select="$MainRisk/PolApplyDate"/></ApplyDate>
				<!-- �����ܱ��� -->
				<TotalPrem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></TotalPrem>
				<!-- ���ձ��� -->
				<InsuAmount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/Amnt)"/></InsuAmount>
				<!-- �ɷ���ֹ���� -->
				<PayEndDate><xsl:value-of select="$MainRisk/PayEndDate"/></PayEndDate>
				<!-- ������Ч���� -->
				<PolEffDate><xsl:value-of select="$MainRisk/CValiDate"/></PolEffDate>
				<!-- ������ֹ���� -->
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
				<!-- ƾ֤���͸��� -->
				<PaperTypeCount>1</PaperTypeCount>
          		<Paper>
          			<!-- ƾ֤���� 1:����-->
          			<PaperType>1</PaperType>
					<!-- ��ӡƾ֤˵�� -->
          			<PaperTitle>�������ٱ��չɷ����޹�˾����</PaperTitle>
          			<!-- ƾ֤ҳ�� -->
          			<PageCount>1</PageCount>
          			<PageContent>
          				<!-- ƾ֤ÿҳ���� �Զ�����-->
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
                          <Row><xsl:text>������      ���յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></Row>
                          <Row>������      ------------------------------------------------------------------------------------------------</Row>
                          <Row>
                             <xsl:text>������      Ͷ����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
                             <xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Appnt/IDType" />
                             <xsl:text>      ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
                          </Row>
                          <Row>
                             <xsl:text>������      �������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
                             <xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Insured/IDType" />
                             <xsl:text>      ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
                          </Row>
                          <Row></Row>
                          <Row>������      ------------------------------------------------------------------------------------------------</Row>
                          <Row>������      ------------------------------------------------------------------------------------------------</Row>
                          <xsl:if test="count(Bnf) = 0">
	                        <Row><xsl:text>������      ��������ˣ�����                </xsl:text>
	                            <xsl:text>����˳��1                   </xsl:text>
	                            <xsl:text>���������100%</xsl:text></Row>
                          </xsl:if>
                          <xsl:if test="count(Bnf)>0">
	                         <xsl:for-each select="Bnf">
		                        <Row>
		                          <xsl:text>������      ��������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
		                          <xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
		                          <xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
		                        </Row>
	                         </xsl:for-each>
                          </xsl:if>
                          <Row>������      ------------------------------------------------------------------------------------------------</Row>
                          <Row></Row>
                          <Row>������      ��������</Row>
                          <Row>������      ------------------------------------------------------------------------------------------------</Row>
                          <Row><xsl:text>��������������                                                         �������ս��\</xsl:text></Row>
                          <Row><xsl:text>��������������������      ��������               �����ڼ�    ��������    �ս�����\      ���շ�    ����Ƶ��</xsl:text></Row>
                          <Row><xsl:text>��������������                                                           ����\����</xsl:text></Row>
                          <Row>������      ------------------------------------------------------------------------------------------------</Row>
                          <xsl:for-each select="Risk">
	                      <xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
	                      <xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
	                      <Row><xsl:text>������      </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
	                                        <xsl:choose>
	                                            <xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 9)"/>
	                                            </xsl:when>
	                                            <xsl:when test="InsuYearFlag = 'Y'">
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 9)"/>
	                                            </xsl:when>
	                                            <xsl:otherwise>
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 9)"/>
	                                                <xsl:text></xsl:text>
	                                            </xsl:otherwise>
	                                        </xsl:choose>
	                                        <xsl:choose>
	                                            <xsl:when test="PayIntv = 0">
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ�ν���', 12)"/>
	                                            </xsl:when>
	                                            <xsl:when test="PayEndYearFlag = 'Y'">
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 10)"/>
	                                            </xsl:when>
	                                        </xsl:choose>
	                                        <xsl:choose>
	                                            <xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',15)"/>
	                                            </xsl:when>
	                                            <xsl:otherwise>
	                                                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
	                                            </xsl:otherwise>
	                                        </xsl:choose>
	                                        <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
	                                        <xsl:choose>
	                                            <xsl:when test="PayIntv = 0">
	                                                <xsl:text>����</xsl:text>
	                                            </xsl:when>
	                                            <xsl:when test="PayIntv = 12">
	                                                <xsl:text>���</xsl:text>
	                                            </xsl:when>
	                                            <xsl:when test="PayIntv = 6">
	                                                <xsl:text>�����</xsl:text>
	                                            </xsl:when>
	                                            <xsl:when test="PayIntv = 3">
	                                                <xsl:text>����</xsl:text>
	                                            </xsl:when>
	                                            <xsl:when test="PayIntv = 1">
	                                                <xsl:text>�½�</xsl:text>
	                                            </xsl:when>
	                                            <xsl:when test="PayIntv = -1">
	                                                <xsl:text>�����ڽ�</xsl:text>
	                                            </xsl:when>
	                                        </xsl:choose>
	                      </Row>
                          </xsl:for-each>
                          <Row>������      ------------------------------------------------------------------------------------------------</Row>
                          <Row>������      ���շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</Row>
                          <Row>������      ------------------------------------------------------------------------------------------------</Row>
                          <Row>������      ------------------------------------------------------------------------------------------------</Row>
                          <xsl:variable name="SpecContent" select="$MainRisk/SpecContent"/>
                          <Row>������      ���յ��ر�Լ����<xsl:choose>
                                        <xsl:when test="$SpecContent=''">
                                            <xsl:text>���ޣ�</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <Row>������    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</Row>
											<Row>�������ֽ��ֵ��</Row>
											<Row>������    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</Row>
											<Row>�������������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�104%�Ľ��Զ�ת�밲��������������գ������ͣ���</Row>
											<Row>�����������˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</Row>
                                        </xsl:otherwise>
                                    </xsl:choose></Row>
                          <Row></Row>
                          <Row></Row>
                          <Row>������      -------------------------------------------------------------------------------------------------</Row>
                          <Row><xsl:text>������      ���պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy��MM��dd��')"/><xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy��MM��dd��')"/></Row>
                          <Row></Row>
                          <Row><xsl:text>������      Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></Row>
                          <Row><xsl:text>������      Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></Row>
                          <Row><xsl:text>������      �ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></Row>
                          <Row></Row>
                          <Row><xsl:text>������      Ϊȷ�����ı���Ȩ�棬�뼰ʱ�δ��ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></Row>
                          <Row><xsl:text>������      ��һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Row>
                          <Row/>
                          <Row><xsl:text>������      �����������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 45)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 20)"/></Row>
                          <Row><xsl:text>������      ����������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 45)"/><xsl:text>��ҵ�ʸ�֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 20)"/></Row>
	   				   </Details>
	   				   <xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
						<xsl:variable name="RiskCount" select="count(Risk)"/>
						<xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
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
							<Row><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</Row>
							<Row/>
							<Row>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </Row>
							<Row>������------------------------------------------------------------------------------------------------</Row>
							<Row>��������������������<xsl:value-of select="Insured/Name"/></Row>
	                			<xsl:if test="$RiskCount=1">
			        		<Row>
				    		<xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Row>
			        		<Row><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
					   			<xsl:text>�ֽ��ֵ</xsl:text></Row>
			   	       			<xsl:variable name="EndYear" select="EndYear"/>
			       		 	<xsl:for-each select="$MainRisk/CashValues/CashValue">
				    		<xsl:variable name="EndYear" select="EndYear"/>
				   			<Row><xsl:text/><xsl:text>����������</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</Row>
				    		</xsl:for-each>
		            		</xsl:if>
		 
		            		<xsl:if test="$RiskCount!=1">
		 	        		<Row>
				    		<xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Row>
			       			<Row><xsl:text/>�������������ĩ<xsl:text>                 </xsl:text>
					   			<xsl:text>�ֽ��ֵ                                �ֽ��ֵ</xsl:text></Row>
			   	       			<xsl:variable name="EndYear" select="EndYear"/>
			        		<xsl:for-each select="$MainRisk/CashValues/CashValue">
				    		<xsl:variable name="EndYear" select="EndYear"/>
				    		<Row>
						 		<xsl:text/><xsl:text>����������</xsl:text>
						 		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
						 		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
						 		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</Row>
				    		</xsl:for-each>
		            		</xsl:if>
							<Row>������------------------------------------------------------------------------------------------------</Row>
							<Row/>
							<Row>��������ע��</Row>
							<Row>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</Row>
							<Row>������------------------------------------------------------------------------------------------------</Row>
						</Details>
						</xsl:if>
        			</PageContent>
        		</Paper>
			</Print>
	</xsl:template>	

	<!--֤������  -->
	<xsl:template name="tran_IDType" match="IDType">
	<xsl:choose>
		<xsl:when test=".=0">���֤    </xsl:when>	<!-- ���֤ -->
		<xsl:when test=".=1">����      </xsl:when>	<!-- ����   -->
		<xsl:when test=".=2">����֤    </xsl:when>	<!-- ����֤ -->
		<xsl:when test=".=8">����      </xsl:when>	<!-- ����   -->
		<xsl:when test=".=5">���ڲ�    </xsl:when>	<!-- ���ڲ� -->
		<xsl:when test=".=6">�۰Ļ���֤</xsl:when>	<!-- �۰Ļ���֤ -->
		<xsl:when test=".=7">̨��֤	 </xsl:when>	<!-- ̨��֤ -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!-- �Ա� -->
	<xsl:template name="tran_sex" match="Sex">
	<xsl:choose>      
		<xsl:when test=".=0">��  </xsl:when>	<!-- �� -->
		<xsl:when test=".=1">Ů  </xsl:when>	<!-- Ů -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	</xsl:template> 
	
	<xsl:template match="InsuYearFlag">
	<xsl:choose>
	    <xsl:when test=".= 'Y'">��</xsl:when>
		<xsl:when test=".= 'A'">��</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="InsuYearFlag"/>
		</xsl:otherwise>
	</xsl:choose>
 </xsl:template>
</xsl:stylesheet>