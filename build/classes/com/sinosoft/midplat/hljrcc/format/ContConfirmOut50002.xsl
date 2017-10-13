<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="Head" />
			<!-- ������ -->
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<!-- ��������Ϣ -->
			<ContNo>
				<xsl:value-of select="ContNo"/>
			</ContNo>
			<!-- ���յ��� -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo"/>
			</ProposalPrtNo>
			<!-- Ͷ����(ӡˢ)�� -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo"/>
			</ContPrtNo>
			<!-- ������ͬӡˢ�� -->
			<Prem>
				<xsl:value-of select="ActSumPrem"/>
			</Prem>
			<!-- �ܱ��� -->
			<PremText>
				<xsl:value-of select="ActSumPremText"/>
			</PremText>
			<!-- �ܱ��Ѵ�д -->
			<AgentCode>
				<xsl:value-of select="AgentCode"/>
			</AgentCode>
			<!-- �����˱��� -->
			<AgentName>
				<xsl:value-of select="AgentName"/>
			</AgentName>
			<!-- ���������� -->
			<AgentGrpCode>
				<xsl:value-of select="AgentGrpCode"/>
			</AgentGrpCode>
			<!-- ������������ -->
			<AgentGrpName>
				<xsl:value-of select="AgentGrpName"/>
			</AgentGrpName>
			<!-- ��������� -->
			<AgentCom>
				<xsl:value-of select="AgentCom"/>
			</AgentCom>
			<!-- ����������� -->
			<AgentComName>
				<xsl:value-of select="AgentComName"/>
			</AgentComName>
			<!-- ����������� -->
			<ComCode>
				<xsl:value-of select="ComCode"/>
			</ComCode>
			<!-- �б���˾���� -->
			<ComLocation>
				<xsl:value-of select="ComLocation"/>
			</ComLocation>
			<!-- �б���˾��ַ -->
			<ComName>
				<xsl:value-of select="ComName"/>
			</ComName>
			<!-- �б���˾���� -->
			<ComZipCode>
				<xsl:value-of select="ComZipCode"/>
			</ComZipCode>
			<!-- �б���˾�ʱ� -->
			<ComPhone>95569</ComPhone>
			<!-- �б���˾�绰 -->
			<CAppNme>
				<xsl:value-of select="Appnt/Name"/>
			</CAppNme>
			<!-- Ͷ�������� -->
			<CProdNme>
				<xsl:value-of select="ContPlan/ContPlanName"/>
			</CProdNme>
			<!-- �������� -->
			<TInsrncBgnTm>
				<xsl:value-of select="Risk[RiskCode=MainRiskCode]/CValiDate"/>
			</TInsrncBgnTm>
			<!-- ��������(yyyyMMdd)  -->
			<TInsrncEndTm>
				<xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuEndDate"/>
			</TInsrncEndTm>
			<!-- ����ֹ��(yyyyMMdd)  -->
			<PayToDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Risk[RiskCode=MainRiskCode]/PayToDate)"/>
			</PayToDate>
			<!-- ��������(yyyyMMdd)  -->
			<CBankSellerCode/>
			<!-- ���й�Ա�� -->
			<PRINT_NUM/>
			<!-- ��ӡҳ�� -->
			
			<!-- ��ӡ��Ϣ -->
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
            <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

			
			<PRINT>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
<xsl:text>                                     ��ֵ��λ�������Ԫ</xsl:text></PRINT_LINE>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>������Ͷ����������</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>�������������ˣ�</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<xsl:if test="count(Bnf) = 0">
				<PRINT_LINE><xsl:text>��������������ˣ�����                </xsl:text>
				   <xsl:text>����˳��1                   </xsl:text>
				   <xsl:text>���������100%</xsl:text></PRINT_LINE>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<PRINT_LINE>
							<xsl:text>��������������ˣ�</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>����˳��</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>���������</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</PRINT_LINE>
					</xsl:for-each>
				</xsl:if>
				<PRINT_LINE/>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>��������������</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>��������������������                                               �������ս��</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>����������������������������               �����ڼ�    ��������      �ս�����\    ���շ�    ����Ƶ��</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>��������������������                                                 ����\����</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
						<PRINT_LINE>
							<xsl:text>������</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 12)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',15)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
							<xsl:text>-</xsl:text>
						</PRINT_LINE>
						</xsl:when>
						<xsl:otherwise>
						<PRINT_LINE>
							<xsl:text>������</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 12)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
							<xsl:text>����</xsl:text>
						</PRINT_LINE>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<PRINT_LINE/>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<PRINT_LINE>���������յ��ر�Լ����</PRINT_LINE>
				<xsl:choose>
					<xsl:when test="$SpecContent=''">
						<xsl:text>���ޣ�</xsl:text>
					</xsl:when>
					<xsl:otherwise>
					<PRINT_LINE><xsl:text>������    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</xsl:text></PRINT_LINE>
					<PRINT_LINE><xsl:text>�������ֽ��ֵ��</xsl:text></PRINT_LINE>
					<PRINT_LINE><xsl:text>������    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</xsl:text></PRINT_LINE>
					<PRINT_LINE><xsl:text>�������������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ�</xsl:text></PRINT_LINE>
					<PRINT_LINE><xsl:text>�������ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</xsl:text></PRINT_LINE>
					</xsl:otherwise>
				</xsl:choose>
				<PRINT_LINE/>
				<PRINT_LINE>������-------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></PRINT_LINE>
				<PRINT_LINE></PRINT_LINE>
				<PRINT_LINE><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></PRINT_LINE>
				<PRINT_LINE><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></PRINT_LINE>
				<PRINT_LINE><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/></PRINT_LINE>
				<PRINT_LINE><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 20)"/></PRINT_LINE>
			</PRINT>
			
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
			<PRINT>
			    <PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </PRINT_LINE>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE>��������������������<xsl:value-of select="Insured/Name"/></PRINT_LINE>
                <xsl:if test="$RiskCount=1">
		        <PRINT_LINE>
			    <xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRINT_LINE>
		        <PRINT_LINE><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text></PRINT_LINE>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <PRINT_LINE><xsl:text/><xsl:text>����������</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</PRINT_LINE>
			    </xsl:for-each>
	            </xsl:if>
	 
	            <xsl:if test="$RiskCount!=1">
	 	        <PRINT_LINE>
			    <xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></PRINT_LINE>
		        <PRINT_LINE><xsl:text/>�������������ĩ<xsl:text>               </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text><xsl:text>                                </xsl:text><xsl:text>�ֽ��ֵ</xsl:text></PRINT_LINE>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <PRINT_LINE>
					 <xsl:text/><xsl:text>����������</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,21)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</PRINT_LINE>
			    </xsl:for-each>
	            </xsl:if>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>��������ע��</PRINT_LINE>
				<PRINT_LINE>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</PRINT_LINE>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
			</PRINT>
			</xsl:if>
		</Body>
	</xsl:template>
	
	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">���֤    </xsl:when>
			<xsl:when test=".=1">����      </xsl:when>
			<xsl:when test=".=2">����֤    </xsl:when>
			<xsl:when test=".=3">����      </xsl:when>
			<xsl:when test=".=4">����֤��  </xsl:when>
			<xsl:when test=".=5">���ڲ�    </xsl:when>
			<xsl:when test=".=8">����      </xsl:when>
			<xsl:when test=".=9">�쳣���֤</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
