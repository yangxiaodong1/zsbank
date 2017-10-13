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
	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
    <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

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
	 			<PREM><xsl:value-of select="ActSumPrem" /></PREM>
	 			<!--������Ч���� -->
	 			<VALIDATE><xsl:value-of select="$MainRisk/CValiDate" /></VALIDATE>
	 			<!--��ͬ��������-->
	 			<CONTRACT_DATE><xsl:value-of select="$MainRisk/SignDate" /></CONTRACT_DATE>
	 			<LIFE>
		 			<!--����ѭ������-->
	 				<PRODUCT_COUNT>1</PRODUCT_COUNT>
		 			<!--���ֽڵ�-->
 					<COVERAGE>
			 			<!--��������� 0-���գ�1-������-->
	 					<MAINSUBFLG>0</MAINSUBFLG>
			 			<!--��������-->
			 			<INSURNAME><xsl:value-of select="ContPlan/ContPlanName" /></INSURNAME>
			 			<!-- ���ִ��� -->
			 			<PRODUCTID><xsl:apply-templates select="ContPlan/ContPlanCode" /></PRODUCTID>
			 			<!-- �ɷѷ�ʽ -->
 						<PAYMETHOD><xsl:apply-templates select="$MainRisk/PayIntv"/></PAYMETHOD>
 						<!--���ֱ���-->
 						<PRODUCT_AMT><xsl:value-of select="sum(Risk/Amnt)"/></PRODUCT_AMT>
 						<!--���ֱ���-->
 						<PREMIUM><xsl:value-of select="sum(Risk/ActPrem)"/></PREMIUM>
 						<!--������-->
 						<POLICY_DATE><xsl:value-of select="$MainRisk/CValiDate"/></POLICY_DATE>
 						<!--�������� 1:����-->
 						<INSUR_TYPE_COD>1</INSUR_TYPE_COD>
 						<!--Ͷ������-->
 						<AMT_UNIT><xsl:value-of select="$MainRisk/Mult"/></AMT_UNIT>
 						<!--������ʼ����-->
 						<START_PAY_DATE></START_PAY_DATE>
 						<!--�ɷ���ֹ����-->
 						<END_PAY_DATE></END_PAY_DATE>
 						<OLIFE_EXTENSION>
 							<!--�ɷ����������ֶ����⴦��-->
 							<CHARGE_PERIOD>1</CHARGE_PERIOD>
 							<CHARGE_YEAR>0</CHARGE_YEAR>
 							<!--������-->
 							<COVERAGE_PERIOD>1</COVERAGE_PERIOD>
 							<COVERAGE_YEAR>999</COVERAGE_YEAR>
 						</OLIFE_EXTENSION>
 					</COVERAGE>
	 			</LIFE>
	 			<OLIFE_EXTENSION>
	 				<SPECIAL_CLAUSE></SPECIAL_CLAUSE>
	 				<TEL>95569</TEL>
	 			</OLIFE_EXTENSION>
	 		</POLICYINFO>
	 	</HOLDING>
	 </OLIFE>
	
	<!-- ��ӡ��Ϣ -->
	<PRINT>
		<VOUCHER_NUM>2</VOUCHER_NUM>
	    <SUB_VOUCHER>
		<VOUCHER_TYPE>3</VOUCHER_TYPE>
	    <PAGE_TOTAL>1</PAGE_TOTAL>
	    <TEXT>
	    	<PAGE_NUM>1</PAGE_NUM>
	    	<ROW_TOTAL></ROW_TOTAL>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" /><xsl:text>                                     ��ֵ��λ�������Ԫ</xsl:text></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>������Ͷ����������</xsl:text>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 28)"/>
				<xsl:text>֤�����ͣ�</xsl:text>
				<xsl:apply-templates select="Appnt/IDType"/>
				<xsl:text>        ֤�����룺</xsl:text>
				<xsl:value-of select="Appnt/IDNo"/>
			</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>�������������ˣ�</xsl:text>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 30)"/>
				<xsl:text>֤�����ͣ�</xsl:text>
				<xsl:apply-templates select="Insured/IDType"/>
				<xsl:text>        ֤�����룺</xsl:text>
				<xsl:value-of select="Insured/IDNo"/>
			</TEXT_ROW_CONTEXT>
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
						<xsl:text>��������������ˣ�</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
						<xsl:text>����˳��</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
						<xsl:text>���������</xsl:text>
						<xsl:value-of select="Lot"/>
						<xsl:text>%</xsl:text>
					</TEXT_ROW_CONTEXT>
				</xsl:for-each>
			</xsl:if>
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>��������������</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>��������������������                                              �������ս��\</xsl:text>
			</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>����������������������������               �����ڼ�    ��������     �ս�����\    ���շ�      ����Ƶ��</xsl:text>
			</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>��������������������                                                ����\����</xsl:text>
			</TEXT_ROW_CONTEXT>					
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<xsl:for-each select="Risk">
				<xsl:variable name="PayIntv" select="PayIntv"/>
				<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
				<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
				<xsl:choose>
					<xsl:when test="RiskCode='L12081'">
					<!-- ����������������գ������ͣ� -->
						<TEXT_ROW_CONTEXT>
							<xsl:text>������</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 10)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',15)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
							<xsl:text>-</xsl:text>
						</TEXT_ROW_CONTEXT>
					</xsl:when>
					<xsl:otherwise>
						<TEXT_ROW_CONTEXT>
							<xsl:text>������</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 10)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
							<xsl:text>����</xsl:text>
						</TEXT_ROW_CONTEXT>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<xsl:variable name="SpecContent" select="SpecContent"/>
			<TEXT_ROW_CONTEXT>
				<xsl:text>���������յ��ر�Լ����</xsl:text>
			</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>������    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</xsl:text>
			</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>�������ֽ��ֵ��</xsl:text>
			</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>������    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</xsl:text>
			</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>�������������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ�</xsl:text>
			</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>
				<xsl:text>�������ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</xsl:text>
			</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT>������-------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy��MM��dd��')"/><xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy��MM��dd��')"/></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 0)"/></TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></TEXT_ROW_CONTEXT>
		</TEXT>
    </SUB_VOUCHER>
    <SUB_VOUCHER>
	    <xsl:variable name="fRisk" select="Risk[RiskCode!=MainRiskCode and CashValues/CashValue !='' ]" />
	    <xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	    <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
		<VOUCHER_TYPE>4</VOUCHER_TYPE>
	    <PAGE_TOTAL>1</PAGE_TOTAL>
        <TEXT>
        	<PAGE_NUM>1</PAGE_NUM>
        	<ROW_TOTAL></ROW_TOTAL>
		    <TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>��������������������<xsl:value-of select="Insured/Name"/></TEXT_ROW_CONTEXT>
 	        <TEXT_ROW_CONTEXT>
		    <xsl:text>�������������ƣ�              </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="$fRisk/RiskName"/></TEXT_ROW_CONTEXT>
	        <TEXT_ROW_CONTEXT><xsl:text/>�������������ĩ<xsl:text>                      </xsl:text>
			   <xsl:text>�ֽ��ֵ                                </xsl:text><xsl:text>�ֽ��ֵ</xsl:text></TEXT_ROW_CONTEXT>
	   	       <xsl:variable name="EndYear" select="EndYear"/>
	        <xsl:for-each select="$MainRisk/CashValues/CashValue">
		    <xsl:variable name="EndYear" select="EndYear"/>
		    <TEXT_ROW_CONTEXT>
				 <xsl:text/><xsl:text>����������</xsl:text>
				 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
				 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
				 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($fRisk/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</TEXT_ROW_CONTEXT>
		    </xsl:for-each>
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT/>
			<TEXT_ROW_CONTEXT>��������ע��</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</TEXT_ROW_CONTEXT>
			<TEXT_ROW_CONTEXT>������------------------------------------------------------------------------------------------------</TEXT_ROW_CONTEXT>	
		</TEXT>	
    </SUB_VOUCHER>
    </PRINT>
</xsl:template>

	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">���֤</xsl:when>
			<xsl:when test=".='1'">����</xsl:when>
			<xsl:when test=".='2'">����֤</xsl:when>
			<xsl:when test=".='3'">����</xsl:when>
			<xsl:when test=".='4'">����֤��</xsl:when>
			<xsl:when test=".='5'">���ڲ�</xsl:when>
			<xsl:otherwise>����</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�Ƶ�� -->
	<xsl:template match="PayIntv">
		<xsl:if test=".='12'">1</xsl:if><!-- ��� -->
		<xsl:if test=".='6'">2</xsl:if><!-- ���꽻 -->
		<xsl:if test=".='3'">3</xsl:if><!-- ����-->
		<xsl:if test=".='1'">4</xsl:if><!-- �½� -->
		<xsl:if test=".='0'">5</xsl:if><!-- ���� -->
	</xsl:template>

	<!-- �����������ڱ�־ -->
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
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- �����޽� -->
			<xsl:when test=".='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template match="ContPlanCode">
		<xsl:choose>
			<xsl:when test=".='50015'">50002</xsl:when>
			<!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
