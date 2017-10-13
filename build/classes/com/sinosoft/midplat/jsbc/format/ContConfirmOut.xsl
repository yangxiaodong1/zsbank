<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
<xsl:template match="/TranData">
		<RETURN>
			<xsl:copy-of select="Head" />
			<MAIN>
				<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]" />
				<!-- �˺Ŵ��� -->
				<ACC_CODE></ACC_CODE>
				<!-- Ͷ������ -->
				<APPLNO><xsl:value-of select ="Body/ProposalPrtNo"/></APPLNO>
				<!-- ���յ��� -->
				<POLICY><xsl:value-of select ="Body/ContNo"/></POLICY>
				<!-- Ͷ������ -->
				<ACCEPT><xsl:value-of select ="$MainRisk/PolApplyDate"/></ACCEPT>
				<!-- ���ڱ��Ѵ�д -->
				<PREMC><xsl:value-of select ="Body/ActSumPremText"/></PREMC>
				<!-- ���ڱ��� -->
				<PREM><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)"/></PREM>
				<!-- ������Ч���� -->
				<VALIDATE><xsl:value-of select ="$MainRisk/CValiDate"/></VALIDATE>
				<!-- Ͷ�������� -->
				<TBR_NAME><xsl:value-of select ="Body/Appnt/Name"/></TBR_NAME>
				<!-- �����˿ͻ��� -->
				<TBRPATRON />
				<!-- ���������� -->
				<BBR_NAME><xsl:value-of select ="Body/Insured/Name"/></BBR_NAME>
				<!-- �����˿ͻ��� -->
				<BBRPATRON></BBRPATRON>
				<!-- ���ѷ�ʽ -->
				<PAYMETHOD><xsl:apply-templates select ="$MainRisk/PayIntv"/></PAYMETHOD>
				<!-- ���ѷ�ʽ�������� -->
				<PAY_METHOD>
					<xsl:call-template name="tran_PayIntv">
						 <xsl:with-param name="payIntv">
						 	<xsl:value-of select="$MainRisk/PayIntv"/>
					     </xsl:with-param>
					 </xsl:call-template>
				</PAY_METHOD>
				<!-- �������� -->
				<PAYDATE><xsl:value-of select ="$MainRisk/PolApplyDate"/></PAYDATE>
				<!-- �б���˾���� -->
				<ORGAN><xsl:value-of select ="Body/ComName"/></ORGAN>
				<!-- �б���˾��ַ -->
				<LOC><xsl:value-of select ="Body/ComLocation"/></LOC>
				<!-- �б���˾��ַ -->
				<TEL><xsl:value-of select ="Body/ComPhone"/></TEL>
				<!-- 0������ӡ�ر�Լ����5����ɫ�Ӵ����ֲ��ִ�ӡ5��10����ɫ�Ӵ����ֲ��ִ�ӡ10 -->
				<ASSUM>0</ASSUM>
				<!-- �б���˾������ -->
				<ORGANCODE><xsl:value-of select ="Body/ComCode"/></ORGANCODE>
				<!-- ���ڽ������ں������� -->
				<PAYDATECHN></PAYDATECHN>
				<!-- ������ֹ���ں������� -->
				<PAYSEDATECHN></PAYSEDATECHN>
				<!-- �����ڼ� -->
				<PAYYEAR><xsl:value-of select ="$MainRisk/PayEndYear"/></PAYYEAR>
				<!-- ����������� -->
				<AGENT_CODE></AGENT_CODE>
				<!-- ר��Ա -->
				<AGENT_PSN_NAME></AGENT_PSN_NAME>
			</MAIN>
			
			<!-- ������Ϣ -->
			<PTS>
				<xsl:apply-templates select="Body/Risk[RiskCode=MainRiskCode]"/>
			</PTS>
			<!-- ��ӡ��Ϣ�б� -->
			<xsl:apply-templates select="Body"/>
			
		</RETURN>
	</xsl:template>
	
	
	<!-- ������Ϣ -->
	<xsl:template name="PT" match="Risk">
		<xsl:variable name="Prem" select="../ActSumPrem"/>
		<xsl:variable name="Amnt" select="../Amnt"/>
		<PT>
			<!-- ������ -->
			<POLICY><xsl:value-of select ="//Body/ContNo"/></POLICY>
			<UNIT><xsl:value-of select ="Mult"/></UNIT>
			<xsl:choose>
				<xsl:when test="RiskCode=MainRiskCode">
					<MAINSUBFLG>1</MAINSUBFLG>
				</xsl:when>
				<xsl:otherwise>
					<MAINSUBFLG>0</MAINSUBFLG>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- FIXME ������ȷ�Ͻӿ��ĵ� ���� -->
			<AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/></AMT>
			<!-- FIXME ������ȷ�Ͻӿ��ĵ� ���ս�� -->
			<PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/></PREM>
			<!-- ���ִ��� -->
			<POL_CODE>
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="RiskCode" />
				</xsl:call-template>
			</POL_CODE>
			<!-- �������� -->
			<NAME><xsl:value-of select ="RiskName"/></NAME>
			<!-- �����ڼ����� -->
			<xsl:choose>
				<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
					<!-- ����:0 �޹أ�1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣  -->
					<PERIOD>1</PERIOD>
				</xsl:when>
				<xsl:otherwise>
					<!-- �����ɷ����� -->
					<PERIOD><xsl:apply-templates  select ="InsuYearFlag"/></PERIOD>
				</xsl:otherwise>
			</xsl:choose>
			<!-- �����ڼ� -->
			<INSU_DUR><xsl:value-of select ="InsuYear"/></INSU_DUR>
			<!-- ������������ -->
			<PAYENDDATE><xsl:value-of select ="PayEndDate"/></PAYENDDATE>
			<xsl:choose>
				<xsl:when test="PayEndYearFlag='Y' and PayEndYear='1000'" >
					<!-- ���������� -->
					<CHARGE_PERIOD>1</CHARGE_PERIOD>
					<CHARGE_YEAR>1000</CHARGE_YEAR>
				</xsl:when>
				<!-- ���У�0 �޹أ�1 ������2 �����޽���3 ����ĳȷ�����䣬4 �������ѣ�5 �����ڽ�  -->
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
					<!-- ������������ -->
					<CHARGE_PERIOD>4</CHARGE_PERIOD>
					<!-- �����ڼ� -->
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear != 1000)">
					<!-- ��� -->
					<CHARGE_PERIOD>2</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear != 106)">
					<!-- ����ĳȷ������ -->
					<CHARGE_PERIOD>3</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
			</xsl:choose>
		</PT>
	</xsl:template>
	
	<xsl:template name="PRTS" match="Body">
		<PRTS>
			<!-- ��ӡ��Ϣ -->
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<PRT_DETAIL>
				<PRT_LINE/>			
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>������Ͷ����������</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</PRT_LINE>
				<PRT_LINE>
					<xsl:text>�������������ˣ�</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:if test="count(Bnf) = 0">
				<PRT_LINE><xsl:text>��������������ˣ�����                </xsl:text>
				   <xsl:text>����˳��1                   </xsl:text>
				   <xsl:text>���������100%</xsl:text></PRT_LINE>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<PRT_LINE>
							<xsl:text>��������������ˣ�</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>����˳��</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>���������</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</PRT_LINE>
					</xsl:for-each>
				</xsl:if>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>��������������</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>�������������������������������������������������������������������������ս��\</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
					<xsl:text>����������������������������               �����ڼ�    ��������     �ս�����\     ���շ�     ����Ƶ��</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
					<xsl:text>������������������������������������������������������������������������\����</xsl:text>
				</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
					<PRT_LINE>
						<xsl:text>������</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
							</xsl:when>
							<xsl:when test="InsuYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
								<xsl:text/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PayIntv = 0">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 11)"/>
							</xsl:when>
							<xsl:when test="PayEndYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 11)"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',14)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
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
					</PRT_LINE>
				</xsl:for-each>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
				<PRT_LINE>���������յ��ر�Լ����<xsl:choose>
						<xsl:when test="$SpecContent=''">
							<xsl:text>���ޣ�</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$SpecContent"/>
						</xsl:otherwise>
					</xsl:choose>
				</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE>������-------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></PRT_LINE>
				<PRT_LINE><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></PRT_LINE>
				<PRT_LINE><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></PRT_LINE>
				<PRT_LINE><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></PRT_LINE>
				<PRT_LINE><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/></PRT_LINE>
				<PRT_LINE><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,20)"/></PRT_LINE>
			</PRT_DETAIL>
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<xsl:choose>
				<xsl:when test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
					<PRT_DETAIL>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE/>
						<PRT_LINE><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</PRT_LINE>
						<PRT_LINE/>
						<PRT_LINE>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </PRT_LINE>
						<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
						<PRT_LINE>��������������������<xsl:value-of select="Insured/Name"/></PRT_LINE>
		                <xsl:if test="$RiskCount=1">
				        <PRT_LINE>
					    <xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRT_LINE>
				        <PRT_LINE><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
						   <xsl:text>�ֽ��ֵ</xsl:text></PRT_LINE>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <PRT_LINE><xsl:text/><xsl:text>����������</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</PRT_LINE>
					    </xsl:for-each>
			            </xsl:if>
			 
			            <xsl:if test="$RiskCount!=1">
			 	        <PRT_LINE>
					    <xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></PRT_LINE>
				        <PRT_LINE><xsl:text/>�������������ĩ<xsl:text>                 </xsl:text>
						   <xsl:text>�ֽ��ֵ                                �ֽ��ֵ</xsl:text></PRT_LINE>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <PRT_LINE>
							 <xsl:text/><xsl:text>����������</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</PRT_LINE>
					    </xsl:for-each>
			            </xsl:if>
						<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
						<PRT_LINE/>
						<PRT_LINE>��������ע��</PRT_LINE>
						<PRT_LINE>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</PRT_LINE>
						<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
					</PRT_DETAIL>
				</xsl:when>
			</xsl:choose>
			
		</PRTS>
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
	
	
	<!-- ������������:0 �޹أ�1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- �����ޱ� -->
			<xsl:when test=".='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='M'">4</xsl:when><!-- ���±� -->
			<xsl:when test=".='D'">5</xsl:when><!-- ���챣 -->
		</xsl:choose>
	</xsl:template>
	
	
	<!-- �ɷѼ��1���ɣ�5�½ɣ�4���ɣ�3����ɣ�2��� -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='0'">5</xsl:when><!-- ���� -->
			<xsl:when test=".='12'">1</xsl:when><!-- ��� -->
			<xsl:when test=".='6'">2</xsl:when><!-- ����� -->
			<xsl:when test=".='3'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">4</xsl:when><!-- �½� -->
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="tran_PayIntv">
		<xsl:param name="payIntv" />
		<xsl:choose>
			<xsl:when test="$payIntv='0'">����</xsl:when>
			<xsl:when test="$payIntv='12'">���</xsl:when>
			<xsl:when test="$payIntv='6'">�����</xsl:when>
			<xsl:when test="$payIntv='3'">����</xsl:when>
			<xsl:when test="$payIntv='1'">�½�</xsl:when>
			<xsl:otherwise>--</xsl:otherwise><!-- ��ȷ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
