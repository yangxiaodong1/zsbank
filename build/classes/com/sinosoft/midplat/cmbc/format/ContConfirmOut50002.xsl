<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:variable name="InsuredSex" select="/TranData/Insured/Sex"/>
	<xsl:template match="/TranData">
		<RETURN>
			<!-- ����ͷ -->
			<xsl:copy-of select="Head" />
			
			<!-- ������ -->
			<xsl:if test="Head/Flag='0'">
				<xsl:apply-templates select="Body" />
			</xsl:if>
			<xsl:if test="Head/Flag='1'">
				<MAIN />
			</xsl:if>
		</RETURN>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="TRAN_BODY" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<MAIN>
			
			<!-- ���յ��� -->
			<POLICY_NO><xsl:value-of select="ContNo" /></POLICY_NO>
			<TOT_PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></TOT_PREM>
			<!-- ���ڱ��� -->
			<INIT_PREM_AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></INIT_PREM_AMT>
			<!-- ���ڱ���, ��д -->
			<INIT_PREM_TXT><xsl:value-of select="ActSumPremText" /></INIT_PREM_TXT>
			<!-- ��Ч���� -->
			<VALIDATE><xsl:value-of select="$MainRisk/CValiDate" /></VALIDATE>
			<CONTENDDATE><xsl:value-of select="$MainRisk/PolApplyDate" /></CONTENDDATE>
			<!-- �б���˾ -->
			<ORGAN><xsl:value-of select="ComName" /></ORGAN>
			<!-- ��˾��ַ -->
			<LOC><xsl:value-of select="ComLocation" /></LOC>
			<!-- ��˾�绰 -->
			<TEL>95569</TEL>
			<!-- ҳ�� -->
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- ������ֽ��ֵ��ʾ2ҳ -->
				<TOTALPAGE>2</TOTALPAGE>
			</xsl:if>
			<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- ���û���ֽ��ֵ��ʾ1ҳ -->
				<TOTALPAGE>1</TOTALPAGE>
			</xsl:if>
		</MAIN>

		<xsl:variable name="RiskCount" select="count(Risk)"/>
		<xsl:variable name="ProductCode" select="$MainRisk/RiskCode" />
		<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
        <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>
			
		<Prnts>
			<Type>8</Type>	<!-- ���յ�  ��ӡ���ͽڵ㣬����Type=8���ֽ��ֵType=9-->
			<Count></Count>
			<Page>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value><xsl:text>���յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" /><xsl:text>                                        ��ֵ��λ�������Ԫ</xsl:text></Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>
					<xsl:text>Ͷ����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
					<xsl:text>֤�����ͣ�</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Appnt/IDType" /></xsl:call-template>
					<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
				</Value></Prnt>
				<Prnt><Value>
					<xsl:text>�������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
					<xsl:text>֤�����ͣ�</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Insured/IDType" /></xsl:call-template>
					<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
				</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<xsl:if test="count(Bnf) = 0">
				<Prnt><Value><xsl:text>��������ˣ�����                </xsl:text>
						   <xsl:text>����˳��1                   </xsl:text>
						   <xsl:text>���������100%</xsl:text></Value></Prnt>
				</xsl:if>
				<xsl:if test="count(Bnf)>0">
				<xsl:for-each select="Bnf">
				<Prnt><Value>
					<xsl:text>��������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
					<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
					<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
				</Value></Prnt>
				</xsl:for-each>
				</xsl:if>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��������</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value><xsl:text>�������������������������������������������������������������������ս��\</xsl:text></Value></Prnt>
				<Prnt><Value><xsl:text>����������������������               �����ڼ�    ��������     �ս�����\     ���շ�     ����Ƶ��</xsl:text></Value></Prnt>
				<Prnt><Value><xsl:text>������������������������������������������������������������������\����</xsl:text></Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
				
					<xsl:choose>
					<!-- PBKINSR-682 ��������ʢ2��ʢ3��50002��Ʒ���� -->
						<xsl:when test="RiskCode='L12081'">
							<Prnt><Value><xsl:text></xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
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
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 14)"/>
										</xsl:when>
										<xsl:when test="PayEndYearFlag = 'Y'">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 14)"/>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',14)"/>
									<xsl:choose>
										<xsl:when test="PayIntv = 0">
											<xsl:text>-</xsl:text>
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
							</Value></Prnt>
						</xsl:when>
						<xsl:otherwise>
							<Prnt><Value><xsl:text></xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
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
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ�ν���', 14)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 14)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',14)"/>
									</xsl:when>
									<xsl:when test="$ProductCode = '122019'">
										<!--��ũ2�űȽ�����-->
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',14)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,14)"/>
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
							</Value></Prnt>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>���շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<Prnt><Value>���յ��ر�Լ����</Value></Prnt>
				<xsl:choose>
					<xsl:when test="$SpecContent=''">
						<Prnt><Value><xsl:text>���ޣ�</xsl:text></Value></Prnt>
					</xsl:when>
					<xsl:otherwise>
						<Prnt><Value>    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻���</Value></Prnt>
						<Prnt><Value>�յ��ֽ��ֵ��</Value></Prnt>
						<Prnt><Value>    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ��</Value></Prnt>
						<Prnt><Value>���������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲���������������</Value></Prnt>
						<Prnt><Value>�������ͣ��ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</Value></Prnt>
					</xsl:otherwise>
				</xsl:choose>
				<Prnt><Value>--------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value><xsl:text>���պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy��MM��dd��')"/><xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy��MM��dd��')"/></Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value><xsl:text>Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></Value></Prnt>
			
				<Prnt><Value><xsl:text>Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></Value></Prnt>
				
				<Prnt><Value><xsl:text>�ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value><xsl:text>Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ���</xsl:text></Value></Prnt>
				<Prnt><Value><xsl:text>����һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Value></Prnt>
				<Prnt/>
				<Prnt><Value><xsl:text>�����������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>ҵ�����֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode,0)"/></Value></Prnt>
				<Prnt><Value><xsl:text>����������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,48)"/><xsl:text>��ҵ�ʸ�֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode,0)"/></Value></Prnt>
				<Prnt><Value><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></Value></Prnt>
				
			</Page>
		</Prnts>
		<!-- �ֽ��ֵҳ��ӡ -->
		<xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	    <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
		<Messages>
			<Type>9</Type>  <!-- �ֽ��ֵ��   ��ӡ���ͽڵ㣬����Type=8���ֽ��ֵType=9 -->
			<Count></Count>
			<Page>
				<Message><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</Message>
				<Message><Value>��</Value></Message>
				<Message><Value>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </Value></Message>
				<Message><Value>������-------------------------------------------------------------------------------------------------------------------------</Value></Message>
				<Message><Value>��������������������<xsl:value-of select="Insured/Name"/></Value></Message>
                <xsl:if test="$RiskCount=1">
		        <Message><Value>
			    <xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Value></Message>
		        <Message><Value><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text></Value></Message>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <Message><Value><xsl:text/><xsl:text>����������</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</Value></Message>
			    </xsl:for-each>
	            </xsl:if>
	 
	            <xsl:if test="$RiskCount!=1">
	 	        <Message><Value>
			    <xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Value></Message>
		        <Message><Value><xsl:text/>�������������ĩ<xsl:text>                 </xsl:text>
				   <xsl:text>�ֽ��ֵ                                �ֽ��ֵ</xsl:text></Value></Message>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <Message><Value>
					 <xsl:text/><xsl:text>����������</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</Value></Message>
			    </xsl:for-each>
	            </xsl:if>
				<Message><Value>������-------------------------------------------------------------------------------------------------------------------------</Value></Message>
				<Message><Value>��</Value></Message>
				<Message><Value>��������ע��</Value></Message>
				<Message><Value>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</Value></Message>
				<Message><Value>������-------------------------------------------------------------------------------------------------------------------------</Value></Message>
			</Page>
		
		</Messages>
		
	</xsl:template>

	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template name="tran_IDName">
		<xsl:param name="idName" />
		<xsl:choose>
			<xsl:when test="$idName='0'">���֤  </xsl:when>
			<xsl:when test="$idName='1'">����    </xsl:when>
			<xsl:when test="$idName='2'">����֤  </xsl:when>
			<xsl:when test="$idName='3'">����    </xsl:when>
			<xsl:when test="$idName='4'">����֤��</xsl:when>
			<xsl:when test="$idName='5'">���ڲ�  </xsl:when>
			<xsl:when test="$idName='6'">�۰Ļ���֤</xsl:when>
			<xsl:when test="$idName='7'">̨��֤  </xsl:when>
			<xsl:when test="$idName='8'">����    </xsl:when>
			<xsl:when test="$idName='9'">�쳣���֤</xsl:when>
			<xsl:otherwise>����    </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>


