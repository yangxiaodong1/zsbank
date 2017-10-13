<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Head" match="Head">
		<Head>
			<!-- 0��ʾ�ɹ���1��ʾʧ�� -->
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag>
			<!-- ʧ��ʱ�����ش�����Ϣ -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc>
		</Head>
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
				<xsl:value-of select="Prem"/>
			</Prem>
			<!-- �ܱ���(��) -->
			<PremText>
				<xsl:value-of select="PremText"/>
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
			<!-- �б���˾�绰 --><!-- ���չ�˾���ߣ��̶�ֵ95569�� -->
			<CAppNme>
				<xsl:value-of select="Appnt/Name"/>
			</CAppNme>
			<!-- Ͷ�������� -->
			<CProdNme>
				<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskName"/>
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
			<CBankSellerCode>
				<xsl:value-of select="CBankSellerCode"/>
			</CBankSellerCode>
			<!-- ���й�Ա�� -->
			<PRINT_NUM/>
			<!-- ��ӡҳ�� -->
			
			<!-- ��ӡ��Ϣ -->
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<!--��PRINT��ҳ��ÿһ��PRINT�ڵ�ѭ������һҳ -->
			<PRINT>
				<!-- ���д�ӡPRINT_LINE��Ϣ -->
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
				<PRINT_LINE><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></PRINT_LINE>
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
				<PRINT_LINE/>
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
					<xsl:text>����������������������������               �����ڼ�    ��������    �������ս��    ���շ�    ����Ƶ��</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
					<PRINT_LINE>
						<xsl:text>������</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 9)"/>
							</xsl:when>
							<xsl:when test="InsuYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 9)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 9)"/>
								<xsl:text/>
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
					</PRINT_LINE>
				</xsl:for-each>
				<PRINT_LINE/>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE>���������շѺϼƣ�<xsl:value-of select="PremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>Ԫ����</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
				<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
				<PRINT_LINE>���������յ��ر�Լ����<xsl:choose>
						<xsl:when test="$SpecContent=''">
							<xsl:text>���ޣ�</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$SpecContent"/>
						</xsl:otherwise>
					</xsl:choose>
				</PRINT_LINE>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE/>
				<PRINT_LINE>������-------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</PRINT_LINE>
			</PRINT>
			
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- ���ֽ��ֵ�ģ���ӡ�ڶ�ҳ�����ֽ��ֵ�Ĳ���ӡ��ҳ-->
			<xsl:variable name="RiskCount" select="count(Risk)"/>
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
				<PRINT_LINE>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </PRINT_LINE>
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
		        <PRINT_LINE><xsl:text/>�������������ĩ<xsl:text>                                        </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text></PRINT_LINE>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <PRINT_LINE>
					 <xsl:text/><xsl:text>����������</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
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
