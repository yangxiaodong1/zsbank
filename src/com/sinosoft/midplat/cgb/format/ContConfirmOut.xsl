<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="Head" />
			<!-- ������ -->
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Transaction_Body" match="Body">
		<MAIN>
		 	<!--Ͷ������-->
		 	<APPLNO>
		 		<xsl:value-of select="ProposalPrtNo" />
		 	</APPLNO>
		 	<!--Ͷ������-->
		 	<ACCEPT_DATE >
		 		<xsl:value-of select="Risk/PolApplyDate" />
		 	</ACCEPT_DATE >
		 	<!--�����������-->
		 	<AGENT_CODE>
		 		<xsl:value-of select="AgentCom" />
		 	</AGENT_CODE>
		 	<!--ר��Ա-->
		 	<AGENT_PSN_NAME>
		 		<xsl:value-of select="AgentCode" />
		 	</AGENT_PSN_NAME>
		 	<!--Ͷ��������-->
		 	<TBR_NAME>
		 		<xsl:value-of select="Appnt/Name" />
		 	</TBR_NAME>
		 	<!--Ͷ���˿ͻ���-->
		 	<TBRPATRON>
		 		<xsl:value-of select="Appnt/CustomerNo" />
		 	</TBRPATRON>
		 	<!--����������-->
		 	<BBR_NAME>
		 		<xsl:value-of select="Insured/Name" />
		 	</BBR_NAME>
		 	<!--�����˿ͻ���-->
		 	<BBRPATRON>
		 		<xsl:value-of select="Insured/CustomerNo" />
		 	</BBRPATRON>
		 </MAIN>
	
		 <!--������Ϣ-->
		 <OLIFE>
		 	<HOLDING>
		 		<POLICYINFO>
		 			<!--���պ�ͬ��-->
		 			<POLICYNO>
		 				<xsl:value-of select="ContNo" />
		 			</POLICYNO>
		 			<!--����״̬-->
		 			<POLICYSTATUS></POLICYSTATUS>
		 			<!--���ڱ���-->
		 			<PREM><xsl:value-of select="Prem" /></PREM>
		 			<!--������Ч���� -->
		 			<VALIDATE><xsl:value-of select="Risk[RiskCode=MainRiskCode]/CValiDate" /></VALIDATE>
		 			<!--��ͬ��������-->
		 			<CONTRACT_DATE><xsl:value-of select="Risk[RiskCode=MainRiskCode]/SignDate" /></CONTRACT_DATE>
		 			<LIFE>
			 			<!--����ѭ������-->
		 				<PRODUCT_COUNT><xsl:value-of select="count(Risk)" /></PRODUCT_COUNT>
		 				<xsl:for-each select="Risk">
				 			<!--���ֽڵ�-->
		 					<COVERAGE>
					 			<!--��������� 0-���գ�1-������-->
					 			<xsl:choose>
					 				<xsl:when test="RiskCode=MainRiskCode">
					 					<MAINSUBFLG>0</MAINSUBFLG>
					 				</xsl:when>
					 				<xsl:otherwise>
					 					<MAINSUBFLG>1</MAINSUBFLG>
					 				</xsl:otherwise>
					 			</xsl:choose>
					 			<!--��������-->
					 			<INSURNAME><xsl:value-of select="RiskName" /></INSURNAME>
					 			<!-- ���ִ��� -->
					 			<PRODUCTID><xsl:apply-templates select="RiskCode"/></PRODUCTID>
					 			<!-- �ɷѷ�ʽ -->
		 						<PAYMETHOD><xsl:apply-templates select="PayIntv"/></PAYMETHOD>
		 						<!--���ֱ���-->
		 						<PRODUCT_AMT><xsl:value-of select="Amnt"/></PRODUCT_AMT>
		 						<!--���ֱ���-->
		 						<PREMIUM><xsl:value-of select="Prem"/></PREMIUM>
		 						<!--������-->
		 						<POLICY_DATE><xsl:value-of select="CValiDate"/></POLICY_DATE>
		 						<!--�������� 1:����-->
		 						<INSUR_TYPE_COD>1</INSUR_TYPE_COD>
		 						<!--Ͷ������-->
		 						<AMT_UNIT><xsl:value-of select="Mult"/></AMT_UNIT>
		 						<!--������ʼ����-->
		 						<START_PAY_DATE></START_PAY_DATE>
		 						<!--�ɷ���ֹ����-->
		 						<END_PAY_DATE></END_PAY_DATE>
		 						<OLIFE_EXTENSION>
		 							<!--�ɷ����������ֶ����⴦��-->
		 							<xsl:choose>
		 								<xsl:when	test="PayEndYearFlag='Y' and PayEndYear='1000'">
		 									<!--����-->
		 									<CHARGE_PERIOD>1</CHARGE_PERIOD>
		 									<CHARGE_YEAR>0</CHARGE_YEAR>
		 								</xsl:when>
		 								<xsl:otherwise>
		 									<!--�����ɷ���ʽ-->
		 									<CHARGE_PERIOD>
		 										<xsl:apply-templates	select="PayEndYearFlag" />
		 									</CHARGE_PERIOD>
		 									<CHARGE_YEAR>
		 										<xsl:value-of	select="PayEndYear" />
		 									</CHARGE_YEAR>
		 								</xsl:otherwise>
		 							</xsl:choose>
		 							
		 							<!--�������������ֶ����⴦��-->
		 							<xsl:choose>
		 								<xsl:when	test="InsuYearFlag='A' and InsuYear='106'">
		 									<!--������-->
		 									<COVERAGE_PERIOD>1</COVERAGE_PERIOD>
		 									<COVERAGE_YEAR>999</COVERAGE_YEAR>
		 								</xsl:when>
		 								<xsl:otherwise>
		 									<!--������������-->
		 									<COVERAGE_PERIOD>
		 										<xsl:apply-templates	select="InsuYearFlag" />
		 									</COVERAGE_PERIOD>
		 									<COVERAGE_YEAR>
		 										<xsl:value-of	select="InsuYear" />
		 									</COVERAGE_YEAR>
		 								</xsl:otherwise>
		 							</xsl:choose>
		 						</OLIFE_EXTENSION>
		 					</COVERAGE>
		 				</xsl:for-each>
		 			</LIFE>
		 			<OLIFE_EXTENSION>
		 				<SPECIAL_CLAUSE></SPECIAL_CLAUSE>
		 				<TEL>95569</TEL>
		 			</OLIFE_EXTENSION>
		 		</POLICYINFO>
		 	</HOLDING>
		 </OLIFE>
		
		<!-- ��ӡ��Ϣ -->
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<xsl:variable name="ProductCode" select="$MainRisk/RiskCode" />
		<PRINT>
		    <xsl:choose>
				<xsl:when test="$MainRisk/CashValues/CashValue/EndYear != ''">
					<VOUCHER_NUM>2</VOUCHER_NUM>
				</xsl:when>
				<xsl:otherwise>
					<VOUCHER_NUM>1</VOUCHER_NUM>
				</xsl:otherwise>
			</xsl:choose>
		    <SUB_VOUCHER>
			<xsl:variable name="SumPremYuan" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
			<VOUCHER_TYPE>3</VOUCHER_TYPE>
		    <PAGE_TOTAL>1</PAGE_TOTAL>
		    <TEXT>
		    	<PAGE_NUM>1</PAGE_NUM>
		    	<ROW_TOTAL></ROW_TOTAL>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>
					<xsl:text>������Ͷ����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
					<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Appnt/IDType" />
					<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
				</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>
					<xsl:text>�������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
					<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Insured/IDType" />
					<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
				</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<xsl:if test="count(Bnf) = 0">
				<TEXT_ROW_CONTEXT><xsl:text>��������������ˣ�����                </xsl:text>
						   <xsl:text>����˳��1                   </xsl:text>
						   <xsl:text>���������100%</xsl:text></TEXT_ROW_CONTEXT>
				</xsl:if>
				<xsl:if test="count(Bnf)>0">
				<xsl:for-each select="Bnf">
				<TEXT_ROW_CONTEXT>
					<xsl:text>��������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
					<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
					<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
				</TEXT_ROW_CONTEXT>
				</xsl:for-each>
				</xsl:if>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>��������������</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>��������������������                                             �������ս��\</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>����������������������������               �����ڼ�    ��������    �ս�����\      ���շ�    ����Ƶ��</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>��������������������                                               ����\����</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<xsl:for-each select="Risk">
				<xsl:variable name="PayIntv" select="PayIntv"/>
				<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
				<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
				<TEXT_ROW_CONTEXT><xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
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
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 12)"/>
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
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Prem,13)"/>
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
				</TEXT_ROW_CONTEXT>
				</xsl:for-each>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>���������շѺϼƣ�<xsl:value-of select="PremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>Ԫ����</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
				<TEXT_ROW_CONTEXT>���������յ��ر�Լ����<xsl:choose>
										<xsl:when test="$SpecContent=''">
											<xsl:text>���ޣ�</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$SpecContent"/>
										</xsl:otherwise>
									</xsl:choose></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������-------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy��MM��dd��')"/><xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy��MM��dd��')"/></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>�������ͻ��������ߣ�95569                                              ��ַ��http://www.anbang-life.com</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT/>
				<TEXT_ROW_CONTEXT><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 0)"/></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></TEXT_ROW_CONTEXT>
			</TEXT>
	    </SUB_VOUCHER>
	    <xsl:if test="$MainRisk/CashValues/CashValue/EndYear != ''">
	    <SUB_VOUCHER>
	    <xsl:variable name="RiskCount" select="count(Risk)"/>
			<VOUCHER_TYPE>4</VOUCHER_TYPE>
		    <PAGE_TOTAL>1</PAGE_TOTAL>
	        <TEXT>
	        	<PAGE_NUM>1</PAGE_NUM>
	        	<ROW_TOTAL></ROW_TOTAL>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>��������������������<xsl:value-of select="Insured/Name"/></TEXT_ROW_CONTEXT>
			    <xsl:if test="$RiskCount=1">
				<TEXT_ROW_CONTEXT>
				    <xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
						   <xsl:text>�ֽ��ֵ</xsl:text></TEXT_ROW_CONTEXT>
				   	<xsl:variable name="EndYear" select="EndYear"/>
				   <xsl:for-each select="$MainRisk/CashValues/CashValue">
					 <xsl:variable name="EndYear" select="EndYear"/>
					   <TEXT_ROW_CONTEXT><xsl:text/><xsl:text>����������</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</TEXT_ROW_CONTEXT>
			       </xsl:for-each>
			    </xsl:if>
			 
			    <xsl:if test="$RiskCount!=1">
			 	<TEXT_ROW_CONTEXT>
					<xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT><xsl:text/>�������������ĩ<xsl:text>                                        </xsl:text>
						   <xsl:text>�ֽ��ֵ</xsl:text></TEXT_ROW_CONTEXT>
				   	<xsl:variable name="EndYear" select="EndYear"/>
				   <xsl:for-each select="$MainRisk/CashValues/CashValue">
					 <xsl:variable name="EndYear" select="EndYear"/>
					   <TEXT_ROW_CONTEXT>
							  <xsl:text/><xsl:text>����������</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</TEXT_ROW_CONTEXT>
					</xsl:for-each>
			    </xsl:if>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>��������ע��</TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ�� </TEXT_ROW_CONTEXT>
				<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			</TEXT>	
	    </SUB_VOUCHER>
	    </xsl:if>
    	</PRINT>
	</xsl:template>
 


	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<!-- �㷢��1 ���֤��2 ����֤��3 ���գ�4 ����֤��5 ���� -->
	<!-- ���ģ�0	�������֤,1 ����,2 ����֤,3 ����,4 ����֤��,5	���ڲ�,8	����,9	�쳣���֤ -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">���֤  </xsl:when>
			<xsl:when test=".='1'">����    </xsl:when>
			<xsl:when test=".='2'">����֤  </xsl:when>
			<xsl:when test=".='3'">����    </xsl:when>
			<xsl:when test=".='4'">����֤��</xsl:when>
			<xsl:when test=".='5'">���ڲ�  </xsl:when>
			<xsl:otherwise>����    </xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�Ƶ�� -->
	<!-- �㷢��1 �꽻��2 ���꽻��3 ������4 �½���5 ���� -->
	<xsl:template match="PayIntv">
		<xsl:if test=".='12'">1</xsl:if><!-- ��� -->
		<xsl:if test=".='6'">2</xsl:if><!-- ���꽻 -->
		<xsl:if test=".='3'">3</xsl:if><!-- ����-->
		<xsl:if test=".='1'">4</xsl:if><!-- �½� -->
		<xsl:if test=".='0'">5</xsl:if><!-- ���� -->
	</xsl:template>

	<!-- �����������ڱ�־ -->
	<!-- �㷢��0 �޹أ�1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'">5</xsl:when><!-- ���� -->
			<xsl:when test=".='M'">4</xsl:when><!-- ���� -->
			<xsl:when test=".='Y'">2</xsl:when><!-- ���� -->
			<xsl:when test=".='A'">3</xsl:when><!-- ����ĳ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ����������־ -->
	<!-- �㷢��0 �޹أ�1 ������2 �����޽���3 ����ĳȷ�����䣬4 �������ѣ�5 �����ڽ� -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- �����޽� -->
			<xsl:when test=".='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='L12078'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='L12080'">L12080</xsl:when>  <!-- ����ʢ��1���������գ������ͣ� -->
			<xsl:when test=".='L12089'">L12089</xsl:when>  <!-- ����ʢ��1���������գ������ͣ�B�� -->
			<xsl:when test=".='L12074'">L12074</xsl:when>  <!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ� ���� -->
            <xsl:when test=".='L12088'">L12088</xsl:when><!-- �����9����ȫ���գ������ͣ� ���� -->
            <xsl:when test=".='L12091'">L12091</xsl:when><!-- �����Ӯ1�������A��-->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
