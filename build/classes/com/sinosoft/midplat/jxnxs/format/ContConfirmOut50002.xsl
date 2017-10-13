<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<RETURN>
			<xsl:variable name ="flag" select ="Head/Flag"/>
			<MAIN>
			<TRANSRNO></TRANSRNO>
			<!-- ���չ�˾1ʧ�ܣ�0�ɹ� -->
			<RESULTCODE><xsl:apply-templates select="Head/Flag" /></RESULTCODE><!-- 1 �ɹ���0 ʧ�� -->
			<ERR_INFO><xsl:value-of select ="Head/Desc"/></ERR_INFO>
				<xsl:choose>
					<!-- ���չ�˾1ʧ�ܣ�0�ɹ� -->
					<xsl:when test="$flag=0">
						<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]" />
						<ACC_CODE><xsl:value-of select ="Body/AccNo"/></ACC_CODE>
						<APPLNO><xsl:value-of select ="Body/ProposalPrtNo"/></APPLNO>
						<POLICY><xsl:value-of select ="Body/ContNo"/></POLICY>
						<ACCEPT><xsl:value-of select ="$MainRisk/SignDate"/></ACCEPT>
						<AGENT_PSN_NAME><xsl:value-of select ="Body/AgentName"/></AGENT_PSN_NAME>
						<SALES_NO><xsl:value-of select ="Body/AgentCode"/></SALES_NO>
						<AGENT_CODE><xsl:value-of select ="Body/AgentCom"/></AGENT_CODE>
						<PREM><xsl:value-of select ="Body/ActSumPrem"/></PREM>
						<PREMC><xsl:value-of select ="Body/ActSumPremText"/></PREMC>
						<VALIDATE><xsl:value-of select ="$MainRisk/CValiDate"/></VALIDATE><!-- ������Ч���� -->
						<CONTRACT_DATE><xsl:value-of select ="$MainRisk/PolApplyDate"/></CONTRACT_DATE><!-- ��ͬ�������� -->
						<TBR_NAME><xsl:value-of select ="Body/Appnt/Name"/></TBR_NAME>
						<TBRPATRON><xsl:value-of select ="Body/Appnt/CustomerNo"/></TBRPATRON>
						<BBR_NAME><xsl:value-of select ="Body/Insured/Name"/></BBR_NAME>
						<BBRPATRON><xsl:value-of select ="Body/Insured/CustomerNo"/></BBRPATRON>
						<!-- �����˾�һ���� -->
						<xsl:choose>
							<xsl:when test="Body/Bnf/Name != ''">
								<SERNAME><xsl:value-of select ="Body/Bnf/Name"/></SERNAME>
								<SERRELATION><xsl:apply-templates select ="Body/Bnf/RelaToInsured"/></SERRELATION>
								<SERORDER><xsl:value-of select ="Body/Bnf/Grade"/></SERORDER>
							</xsl:when>
							<xsl:otherwise>
								<SERNAME><xsl:text>����</xsl:text></SERNAME>
								<SERRELATION><xsl:text>5</xsl:text></SERRELATION>
								<SERORDER><xsl:text>1</xsl:text></SERORDER>
								
							</xsl:otherwise>
						</xsl:choose>
						
						<PAYMETHOD><xsl:apply-templates select ="$MainRisk/PayIntv"/></PAYMETHOD>
						<PAYDATE><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($MainRisk/StartPayDate)"/></PAYDATE>																<!-- �ɷ����ڸ���θ��� -->
						<RECEIPT_NO></RECEIPT_NO>														<!-- �վݱ�Ÿ���θ��� -->
						<ORGAN><xsl:value-of select ="Body/ComName"/></ORGAN>
						<LOC><xsl:value-of select ="Body/ComLocation"/></LOC>
						<TEL><xsl:value-of select ="Body/ComPhone"/></TEL>
						<ASSUM></ASSUM>																		<!-- �ر�Լ����ӡ��־����θ��� -->
						<TBR_OAC_DATE></TBR_OAC_DATE><!-- Ͷ���˿ͻ����������� -->
						<BBR_OAC_DATE></BBR_OAC_DATE><!-- �����˿ͻ����������� -->
						<PAYDATECHN></PAYDATECHN><!-- ���ڽɷ����ڣ����������� -->
						<PAYSEDATECHN></PAYSEDATECHN><!-- �ɷ���ֹ���ڣ����������� -->
						<!-- �ɷѼ��  -->
						<PAY_METHOD>
							<xsl:choose>
									<xsl:when test="$MainRisk/PayIntv = 0">
										<xsl:text>����</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = 12">
										<xsl:text>���</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = 6">
										<xsl:text>�����</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = 3">
										<xsl:text>����</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = 1">
										<xsl:text>�½�</xsl:text>
									</xsl:when>
									<xsl:when test="$MainRisk/PayIntv = -1">
										<xsl:text>�����ڽ�</xsl:text>
									</xsl:when>
								</xsl:choose>
						</PAY_METHOD><!-- �ɷѷ�ʽ(����)���д��룺1 �꽻��2 ���꽻��3 ������4 �½���5 ����  -->
						<PAYYEAR><xsl:value-of select ="$MainRisk/PayEndYear"/></PAYYEAR><!-- �ɷ�����/�����ڼ� -->
						<ORGANCODE><xsl:value-of select ="Body/ComCode"/></ORGANCODE>
					</xsl:when>
				</xsl:choose>
			</MAIN>
			<xsl:choose>
				<xsl:when test="$flag=0">
					<!-- ������Ϣ -->
					<PTS>
						<xsl:apply-templates select="Body/Risk"/>
					</PTS>
					<!-- �ֽ��ֵ��Ϣ -->
					<VT>
						<!--�������ձ�־-->
						<MAINSUBFLG>0</MAINSUBFLG>
						<!--�����˱�����-->
						<FIRST_RETPCT></FIRST_RETPCT>
						<!--�ڶ����˱�����-->
						<SECOND_RETPCT></SECOND_RETPCT>
						<xsl:apply-templates select="Body/Risk/CashValues/CashValue"/>
					</VT>
				</xsl:when>
			</xsl:choose>
		</RETURN>
	</xsl:template>
	<!-- ������Ϣ -->
	<xsl:template name="PT" match="Risk">
		<PT>
		<xsl:variable name="MainRisk" select="MainRiskCode" />
		<xsl:variable name="Risk" select="RiskCode" />
		<!-- L12081���ֵ���ʾ��Ϣ������ -->
		<xsl:choose>
			<xsl:when test="$Risk='L12081'">
				<!-- ���ִ��� -->
				<POL_CODE><xsl:apply-templates select ="RiskCode"/></POL_CODE>
				<!--���յ���-->
				<POLICY><xsl:value-of select ="../ContNo"/></POLICY>
				<!--Ͷ������-->
				<UNIT><xsl:value-of select ="Mult"/></UNIT>
				<!--�������ձ�־-->
				<xsl:choose>
					<xsl:when test="$MainRisk = $Risk">
						<MAINSUBFLG>0</MAINSUBFLG><!-- ���� -->
					</xsl:when>
					<xsl:otherwise>
						<MAINSUBFLG>1</MAINSUBFLG><!-- ������ -->
					</xsl:otherwise>
				</xsl:choose>
				<!--����-->
				<PREM>-</PREM>
				<!--Ͷ�����-->
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<AMT>-</AMT>
					</xsl:when>
					<xsl:otherwise>
						<AMT><xsl:value-of select="Amnt"/></AMT>
					</xsl:otherwise>
				</xsl:choose>
				<!--��������-->
				<NAME><xsl:value-of select="RiskName"/></NAME>
				<!--������������-->
				<xsl:choose>
					<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
						<!-- ���� -->
						<PERIOD>1</PERIOD>
					</xsl:when>
					<xsl:otherwise>
						<!-- ������������ -->
						<PERIOD><xsl:apply-templates  select ="InsuYearFlag"/></PERIOD>
					</xsl:otherwise>
				</xsl:choose>
				<!-- ������������(����) -->
				<xsl:choose>
					<xsl:when test="InsuEndDate != ''">
						<INSUENDDATE><xsl:value-of  select="substring(InsuEndDate,1,4)"/>��<xsl:value-of  select="substring(InsuEndDate,5,2)"/>��<xsl:value-of  select="substring(InsuEndDate,7,2)"/>��</INSUENDDATE>
					</xsl:when>
					<xsl:otherwise>
						<INSUENDDATE></INSUENDDATE>
					</xsl:otherwise>
				</xsl:choose>
				<!--�����ڼ�-->
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<INSU_DUR>1000</INSU_DUR>
					</xsl:when>
					<xsl:otherwise>
						<INSU_DUR><xsl:value-of select ="InsuYear"/></INSU_DUR>
					</xsl:otherwise>
				</xsl:choose>
				<!--�ɷ���������-->
				<PAYENDDATE><xsl:value-of select ="PayEndDate"/></PAYENDDATE>
				
				<!--�ɷ���������-->
				<xsl:choose>
					<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear = 1000)">
						<!-- ���������� -->
						<CHARGE_PERIOD>1</CHARGE_PERIOD>
						<CHARGE_YEAR>1000</CHARGE_YEAR>
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
					<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
						<!-- ���� -->
						<CHARGE_PERIOD>4</CHARGE_PERIOD>
						<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<!-- ��122048���ֵ���ʾ��Ϣ -->
			<xsl:otherwise>
				<!-- ���ִ��� -->
				<POL_CODE><xsl:apply-templates select ="RiskCode"/></POL_CODE>
				<!--���յ���-->
				<POLICY><xsl:value-of select ="../ContNo"/></POLICY>
				<!--Ͷ������-->
				<UNIT><xsl:value-of select ="Mult"/></UNIT>
				<!--�������ձ�־-->
				<xsl:choose>
					<xsl:when test="$MainRisk = $Risk">
						<MAINSUBFLG>0</MAINSUBFLG><!-- ���� -->
					</xsl:when>
					<xsl:otherwise>
						<MAINSUBFLG>1</MAINSUBFLG><!-- ������ -->
					</xsl:otherwise>
				</xsl:choose>
				<!--����-->
				<PREM><xsl:value-of select="ActPrem"/></PREM>
				<!--Ͷ�����-->
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<AMT>�����ʻ���ֵ</AMT>
					</xsl:when>
					<xsl:otherwise>
						<AMT><xsl:value-of select="Amnt"/></AMT>
					</xsl:otherwise>
				</xsl:choose>
				<!--��������-->
				<NAME><xsl:value-of select="RiskName"/></NAME>
				<!--������������-->
				<xsl:choose>
					<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
						<!-- ���� -->
						<PERIOD>1</PERIOD>
					</xsl:when>
					<xsl:otherwise>
						<!-- ������������ -->
						<PERIOD><xsl:apply-templates  select ="InsuYearFlag"/></PERIOD>
					</xsl:otherwise>
				</xsl:choose>
				<!-- ������������(����) -->
				<xsl:choose>
					<xsl:when test="InsuEndDate != ''">
						<INSUENDDATE><xsl:value-of  select="substring(InsuEndDate,1,4)"/>��<xsl:value-of  select="substring(InsuEndDate,5,2)"/>��<xsl:value-of  select="substring(InsuEndDate,7,2)"/>��</INSUENDDATE>
					</xsl:when>
					<xsl:otherwise>
						<INSUENDDATE></INSUENDDATE>
					</xsl:otherwise>
				</xsl:choose>
				
				<!--�����ڼ�-->
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<INSU_DUR>1000</INSU_DUR>
					</xsl:when>
					<xsl:otherwise>
						<INSU_DUR><xsl:value-of select ="InsuYear"/></INSU_DUR>
					</xsl:otherwise>
				</xsl:choose>
				<!--�ɷ���������-->
				<PAYENDDATE><xsl:value-of select ="PayEndDate"/></PAYENDDATE>
				
				<!--�ɷ���������-->
				<xsl:choose>
					<xsl:when test="(PayEndYearFlag = 'Y') and (PayEndYear = 1000)">
						<!-- ���������� -->
						<CHARGE_PERIOD>1</CHARGE_PERIOD>
						<CHARGE_YEAR>1000</CHARGE_YEAR>
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
					<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
						<!-- ���� -->
						<CHARGE_PERIOD>4</CHARGE_PERIOD>
						<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		</PT>
	</xsl:template>
	
	<!--  -->
	<!-- ������Ϣ -->
	<xsl:template name="VTI" match="CashValue">
		<VTI>	
			
			<!--�������-->
			<LIVE></LIVE>                                                            
			<!--������ʱ��ս�-->
			<ILL></ILL>                                                              
			<!--���-->
			<YEAR></YEAR>                                                             
			<!--���ĩ������������-->
			<END><xsl:value-of select ="EndYear"/></END>  
			<!--���ĩ�ֽ��ֵ-->
			<CASH><xsl:value-of select ="Cash"/></CASH>                                                             
			<!--������ʱ��ս�-->
			<ACI></ACI>
		</VTI>
	</xsl:template>
	<!-- �ɷѼ��Y���꽻��M���½���W������ -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">Y</xsl:when><!-- ��� -->
			<xsl:when test=".='1'">M</xsl:when><!-- �½� -->
			<xsl:when test=".='0'">W</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- ������������0 �޹أ�1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- �����ޱ� -->
			<xsl:when test=".='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='M'">4</xsl:when><!-- ���±� -->
			<xsl:when test=".='D'">5</xsl:when><!-- ���챣 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɹ���־λ -->
	<xsl:template match="Flag">
		<xsl:choose>
			<xsl:when test=".='0'">0000</xsl:when><!-- ���гɹ� -->
			<xsl:when test=".='1'">1111</xsl:when><!-- ����ʧ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �������뱻�����˹�ϵ -->
	<xsl:template match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".='02'">1</xsl:when><!-- ��ż -->
			<xsl:when test=".='01'">2</xsl:when><!-- ��ĸ -->
			<xsl:when test=".='03'">3</xsl:when><!-- ��Ů -->
			<xsl:when test=".='00'">5</xsl:when><!-- ���� -->
			<xsl:when test=".='04'">6</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- ���ִ��� -->
	<xsl:template match="RiskCode" >
		<xsl:choose>
			<!-- ��ӡ�Ű����ɽ���ũ�������д�����˾��Ҫ����50015��Ʒ�����������б� -->
			<xsl:when test=".='122046'">122046</xsl:when><!-- �������Ӯ1����ȫ����-->
			<xsl:when test=".='122047'">122047</xsl:when><!-- ����ӳ�����Ӯ��ȫ���� -->
			<xsl:when test=".='L12081'">122048</xsl:when>	<!-- ����������������գ������� -->
			
			<!-- guoxl 2016.6.15 ��ʼ -->
			<xsl:when test=".='L12087'">L12087</xsl:when> 	<!-- �����5����ȫ���գ������ͣ� -->
			<!-- guoxl 2016.6.15 ���� -->
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
