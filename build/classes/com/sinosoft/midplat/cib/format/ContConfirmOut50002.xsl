<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<RETURN>
			<xsl:variable name ="flag" select ="Head/Flag"/>
			<MAIN>
				<xsl:choose>
					<xsl:when test="$flag=1">
						<!-- ���չ�˾1ʧ�ܣ�0�ɹ� -->
						<APP><xsl:value-of select ="Body/ProposalPrtNo"/></APP>
						<OKFLAG><xsl:apply-templates select="Head/Flag" /></OKFLAG><!-- 1 �ɹ���0 ʧ�� -->
						<!-- �µ��ش򣬽���ʧ������FAILDETAIL -->
						<FAILDETAIL><xsl:value-of select ="Head/Desc"/></FAILDETAIL>
						<!-- �µ���ӡ������ʧ������REJECTNO -->
						<REJECTNO><xsl:value-of select ="Head/Desc"/></REJECTNO>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]" />
						<POLICY><xsl:value-of select ="Body/ContNo"/></POLICY>
						<APP><xsl:value-of select ="Body/ProposalPrtNo"/></APP>
						<ACCEPT><xsl:value-of select ="$MainRisk/SignDate"/></ACCEPT>
						<OKFLAG><xsl:apply-templates select="Head/Flag" /></OKFLAG><!-- 1 �ɹ���0 ʧ�� -->
						<PREMC><xsl:value-of select ="Body/ActSumPremText"/></PREMC>
						<PREM><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)"/></PREM>
						<VALIDATE><xsl:value-of select ="$MainRisk/CValiDate"/></VALIDATE>
						<INVALIDATE><xsl:value-of select ="$MainRisk/InsuEndDate"/></INVALIDATE>
						<FIRSTPAYDATE></FIRSTPAYDATE>
						<PAYDATECHN><xsl:value-of select ="$MainRisk/PayEndDate"/></PAYDATECHN>
						<PAYSEDATECHN></PAYSEDATECHN>
						<PAYYEAR><xsl:value-of select ="$MainRisk/PayEndYear"/></PAYYEAR>
						<ORGAN><xsl:value-of select ="Body/ComName"/></ORGAN>
						<ORGANCODE><xsl:value-of select ="Body/ComCode"/></ORGANCODE>
						<LOC><xsl:value-of select ="Body/ComLocation"/></LOC>
						<TEL><xsl:value-of select ="Body/ComPhone"/></TEL>
						<INSU_SPEC><xsl:value-of select ="Body/SpecContent"/></INSU_SPEC>
						<ZGYNO><xsl:value-of select ="Body/SellerNo"/></ZGYNO>
						<ZGYNAME><xsl:value-of select ="Body/TellerName"/></ZGYNAME>
						<ACC_CODE><xsl:value-of select ="Body/AccNo"/></ACC_CODE>
						<REVMETHOD><xsl:value-of select ="$MainRisk/GetIntv"/></REVMETHOD>
						<REVAGE><xsl:value-of select ="$MainRisk/GetYear"/></REVAGE>
						<TEMP></TEMP>
						<REMARK></REMARK>
					</xsl:otherwise>
				</xsl:choose>
			</MAIN>
			<!-- Ͷ������Ϣ -->
			<xsl:apply-templates select="Body/Appnt"/>
			<!-- ����������Ϣ -->
			<xsl:apply-templates select="Body/Insured"/>
			
			<xsl:choose>
				<xsl:when test="$flag=0">
					<!-- ��������Ϣ -->
					<SYRS>
						<xsl:apply-templates select="Body/Bnf"/>
					</SYRS>
					
					<!-- ������Ϣ -->
					<PTS>
						<xsl:apply-templates select="Body/Risk[RiskCode=MainRiskCode]"/>
					</PTS>
				</xsl:when>
			</xsl:choose>
			<!-- ��ӡ��Ϣ�б� -->
			<xsl:apply-templates select="Body"/>
		</RETURN>
	</xsl:template>
	<!-- Ͷ������Ϣ -->
	<xsl:template name="TBR" match="Appnt">
		<TBR>
			<TBR_NAME><xsl:value-of select ="Name"/></TBR_NAME>
			<TBR_SEX>
				<xsl:call-template name="tran_Sex">
					 <xsl:with-param name="sex">
					 	<xsl:value-of select="Sex"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</TBR_SEX>
			<TBR_BIRTH><xsl:value-of select ="Birthday"/></TBR_BIRTH>
			<TBR_IDTYPE>
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="IDType"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</TBR_IDTYPE>
			<TBR_IDNO><xsl:value-of select ="IDNo"/></TBR_IDNO>
			<TBR_IDEFFSTARTDATE></TBR_IDEFFSTARTDATE>
			<TBR_IDEFFENDDATE></TBR_IDEFFENDDATE>
			<TBR_ADDR><xsl:value-of select ="Address"/></TBR_ADDR>
			<TBR_POSTCODE><xsl:value-of select ="ZipCode"/></TBR_POSTCODE>
			<TBR_TEL><xsl:value-of select ="Phone"/></TBR_TEL>
			<TBR_MOBILE><xsl:value-of select ="Mobile"/></TBR_MOBILE>
			<TBR_BBR_RELA>
				<xsl:call-template name="tran_RelaToInsured">
					 <xsl:with-param name="relaToInsured">
					 	<xsl:value-of select="RelaToInsured"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</TBR_BBR_RELA>
			<TBR_OCCUTYPE><xsl:value-of select ="JobCode"/></TBR_OCCUTYPE>
			<TBR_NATIVEPLACE><xsl:value-of select ="Nationality"/></TBR_NATIVEPLACE>
			<TBR_TEMP></TBR_TEMP>
			<TBR_REMARK></TBR_REMARK>		
		</TBR>
		<TBR_TELLERS>  <!--Ͷ���˸�֪-->       
		   <TBR_TELLER>
		      <TELLER_VER></TELLER_VER>             <!--��֪���-->
		      <TELLER_CODE></TELLER_CODE>           <!--��֪����-->
		      <TELLER_CONT></TELLER_CONT>           <!--��֪����-->
		      <TELLER_REMARK></TELLER_REMARK>       <!--��֪��ע-->
		    </TBR_TELLER>
		 </TBR_TELLERS>  
	</xsl:template>
	
	<!-- ����������Ϣ -->
	<xsl:template name="BBR" match="Insured">
		<BBR>
			<BBR_NAME><xsl:value-of select ="Name"/></BBR_NAME>
			<BBR_SEX>
				<xsl:call-template name="tran_Sex">
					 <xsl:with-param name="sex">
					 	<xsl:value-of select="Sex"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</BBR_SEX>
			<BBR_BIRTH><xsl:value-of select ="Birthday"/></BBR_BIRTH>
			<BBR_IDTYPE>
				<xsl:call-template name="tran_IDType">
					 <xsl:with-param name="idtype">
					 	<xsl:value-of select="IDType"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</BBR_IDTYPE>
			<BBR_IDNO><xsl:value-of select ="IDNo"/></BBR_IDNO>
			<BBR_IDEFFSTARTDATE></BBR_IDEFFSTARTDATE>
			<BBR_IDEFFENDDATE></BBR_IDEFFENDDATE>
			<BBR_ADDR><xsl:value-of select ="Address"/></BBR_ADDR>
			<BBR_POSTCODE><xsl:value-of select ="ZipCode"/></BBR_POSTCODE>
			<BBR_TEL><xsl:value-of select ="Phone"/></BBR_TEL>
			<BBR_MOBILE><xsl:value-of select ="Mobile"/></BBR_MOBILE>
			<BBR_OCCUTYPE><xsl:value-of select ="JobCode"/></BBR_OCCUTYPE>
			<BBR_AGE></BBR_AGE>
			<BBR_NATIVEPLACE><xsl:value-of select ="Nationality"/></BBR_NATIVEPLACE>
			<BBR_HEALTHINF></BBR_HEALTHINF>
			<BBR_METIERDANGERINF></BBR_METIERDANGERINF>
			<BBR_TEMP></BBR_TEMP>
			<BBR_REMARK></BBR_REMARK>	
		</BBR>	
		<BBR_TELLERS>  <!--�����˸�֪-->   
		    <BBR_TELLER>
		      <TELLER_VER></TELLER_VER>             <!--��֪���-->
		      <TELLER_CODE></TELLER_CODE>           <!--��֪����-->
		      <TELLER_CONT></TELLER_CONT>           <!--��֪����-->
		      <TELLER_REMARK></TELLER_REMARK>       <!--��֪��ע-->
		    </BBR_TELLER>
		 </BBR_TELLERS>	
	</xsl:template>
	<!-- ��������Ϣ -->
	<xsl:template name="SYR" match="Bnf">
			<SYR>
				<SYR_NAME><xsl:value-of select ="Name"/></SYR_NAME>
				<SYR_SEX>
					<xsl:call-template name="tran_Sex">
					 <xsl:with-param name="sex">
					 	<xsl:value-of select="Sex"/>
				     </xsl:with-param>
				 </xsl:call-template>
				</SYR_SEX>
				<SYR_PCT><xsl:value-of select ="Lot"/></SYR_PCT>
				<SYR_BBR_RELA>
					<xsl:call-template name="tran_RelaToInsured">
					 <xsl:with-param name="relaToInsured">
					 	<xsl:value-of select="RelaToInsured"/>
				     </xsl:with-param>
				 </xsl:call-template>
				</SYR_BBR_RELA>
				<SYR_BIRTH><xsl:value-of select ="Birthday"/></SYR_BIRTH>
				<SYR_IDTYPE>
					<xsl:call-template name="tran_IDType">
						 <xsl:with-param name="idtype">
						 	<xsl:value-of select="IDType"/>
					     </xsl:with-param>
					 </xsl:call-template>
				</SYR_IDTYPE>
				<SYR_IDNO><xsl:value-of select ="IDNo"/></SYR_IDNO>
				<SYR_IDEFFSTARTDATE></SYR_IDEFFSTARTDATE>
				<SYR_IDEFFENDDATE></SYR_IDEFFENDDATE>
				<SYR_NATIVEPLACE></SYR_NATIVEPLACE>
				<SYR_TEMP></SYR_TEMP>
				<SYR_REMARK></SYR_REMARK>
			</SYR>
	</xsl:template>
	<!-- ������Ϣ -->
	<xsl:template name="PT" match="Risk">
		<xsl:variable name="RiskCode" select="../ContPlan/ContPlanCode"/>
		<xsl:variable name="RiskName" select="../ContPlan/ContPlanName"/>
		<xsl:variable name="RiskMult" select="../ContPlan/ContPlanMult"/>
		<xsl:variable name="Prem" select="../ActSumPrem"/>
		<xsl:variable name="Amnt" select="../Amnt"/>
		
		<PT>
			<PAYENDDATE><xsl:value-of select ="PayEndDate"/></PAYENDDATE>
			<UNIT><xsl:value-of select ="$RiskMult"/></UNIT>
			<AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($Amnt)"/></AMT>
			<PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($Prem)"/></PREM>
			<ID>
				<xsl:call-template name="tran_RiskCode">
					 <xsl:with-param name="riskCode">
					 	<xsl:value-of select="$RiskCode"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</ID>
			<MAINID>
				<xsl:call-template name="tran_RiskCode">
					 <xsl:with-param name="riskCode">
					 	<xsl:value-of select="$RiskCode"/>
				     </xsl:with-param>
				 </xsl:call-template>
			</MAINID>
			<NAME><xsl:value-of select ="$RiskName"/></NAME>
			<xsl:choose>
				<xsl:when test="(InsuYearFlag = 'A') and (InsuYear = 106)">
					<!-- ���� -->
					<PERIOD>1</PERIOD>
				</xsl:when>
				<xsl:otherwise>
					<!-- �����ɷ����� -->
					<PERIOD><xsl:apply-templates  select ="InsuYearFlag"/></PERIOD>
				</xsl:otherwise>
			</xsl:choose>
			
			<COVERAGE_YEAR><xsl:value-of select ="InsuYear"/></COVERAGE_YEAR>
			<COVERAGE_YEAR_DESC></COVERAGE_YEAR_DESC>
			<PAYMETHOD><xsl:value-of select ="PayIntv"/></PAYMETHOD>
			
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
				<xsl:when test="(PayEndYearFlag = 'M')">
					<!-- �½� -->
					<CHARGE_PERIOD>5</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear = 106)">
					<!-- ���� -->
					<CHARGE_PERIOD>7</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:when test="(PayEndYearFlag = 'A') and (PayEndYear != 106)">
					<!-- ����ĳȷ������ -->
					<CHARGE_PERIOD>6</CHARGE_PERIOD>
					<CHARGE_YEAR><xsl:value-of select="PayEndYear" /></CHARGE_YEAR>
				</xsl:when>
				<xsl:otherwise>
					<!-- �����ɷ����� -->
					<CHARGE_PERIOD>
						<xsl:value-of select="PayEndYearFlag" />
					</CHARGE_PERIOD>
					<CHARGE_YEAR>
						<xsl:value-of select="PayEndYear" />
					</CHARGE_YEAR>
				</xsl:otherwise>
			</xsl:choose>
			<PAYTODATE></PAYTODATE>
			<MULTIYEARFLAG></MULTIYEARFLAG>
			<YEARTYPE></YEARTYPE>
			<MULTIYEARS><xsl:value-of select ="PayNum"/></MULTIYEARS>
			<PT_TEMP></PT_TEMP>
			<PT_REMARK></PT_REMARK>
			<!-- �ֽ��ֵ -->
			<VT>
				<FIRST_RETPCT></FIRST_RETPCT>
				<SECOND_RETPCT></SECOND_RETPCT>
				<VTICOUNT><xsl:value-of select="count(CashValues/CashValue)"/></VTICOUNT>
				<xsl:for-each select="CashValues/CashValue">
					<VTI> 
						<LIVE></LIVE>
						<ILL></ILL>
						<YEAR><xsl:value-of select ="EndYear"/></YEAR>
						<END></END>
						<CASH><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/></CASH>
						<ACI></ACI>
					</VTI>
				</xsl:for-each>
			</VT>
			<!-- ������������ĩ�ֽ��ֵ�� -->
			<CONP>
				<CONICOUNT><xsl:value-of select="count(BonusValues/BonusValue)"/></CONICOUNT>
				<xsl:for-each select="BonusValues/BonusValue">
					<CONI>
						<END><xsl:value-of select ="EndYear"/></END>
						<CON><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EndYearCash)"/></CON>
					</CONI>
				</xsl:for-each>
			</CONP>
		</PT>
	</xsl:template>
	<xsl:template name="DETAIL_LIST" match="Body">
		<DETAIL_LIST>
			<LIST_COUNT>1</LIST_COUNT>
			<LIST_REMARK></LIST_REMARK>
			<LIST_TEMP></LIST_TEMP>
			<!-- ��ӡ��Ϣ -->
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
            <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

			<DETAIL>
				<PRNT_COUNT></PRNT_COUNT>	<!-- ��ֵ��ContConfirm.java�ж�̬���� -->
				<DETAIL_TEMP/>			
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" /><xsl:text>                                      ��ֵ��λ�������Ԫ</xsl:text></DETAIL_PRNT>
				<DETAIL_PRNT>������------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>������Ͷ����������</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>�������������ˣ�</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</DETAIL_PRNT>
				<DETAIL_PRNT/>
				<DETAIL_PRNT>������------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT>������------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<xsl:if test="count(Bnf) = 0">
				<DETAIL_PRNT><xsl:text>��������������ˣ�����                </xsl:text>
				   <xsl:text>����˳��1                   </xsl:text>
				   <xsl:text>���������100%</xsl:text></DETAIL_PRNT>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<DETAIL_PRNT>
							<xsl:text>��������������ˣ�</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>����˳��</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>���������</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</DETAIL_PRNT>
					</xsl:for-each>
				</xsl:if>
				<DETAIL_PRNT>������------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT>��������������</DETAIL_PRNT>
				<DETAIL_PRNT>������------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>�������������������������������������������������������������������������ս��\</xsl:text>
				</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>����������������������������               �����ڼ�    ��������     �ս�����\     ���շ�     ����Ƶ��</xsl:text>
				</DETAIL_PRNT>
				<DETAIL_PRNT>
					<xsl:text>������������������������������������������������������������������������\����</xsl:text>
				</DETAIL_PRNT>
				<DETAIL_PRNT>������------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
							<DETAIL_PRNT>
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
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 11)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 11)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',14)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
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
							</DETAIL_PRNT>
						</xsl:when>
						<xsl:otherwise>
							<DETAIL_PRNT>
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
							</DETAIL_PRNT>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<DETAIL_PRNT>������------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT/>
				<DETAIL_PRNT>���������շѺϼƣ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ��Сд��</DETAIL_PRNT>
				<DETAIL_PRNT>������------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT/>
				<DETAIL_PRNT>������------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<DETAIL_PRNT/>
				<DETAIL_PRNT>���������յ��ر�Լ����</DETAIL_PRNT>
					<xsl:choose>
						<xsl:when test="$SpecContent=''">
							<DETAIL_PRNT><xsl:text>���ޣ�</xsl:text></DETAIL_PRNT>
						</xsl:when>
						<xsl:otherwise>
							<DETAIL_PRNT>������    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</DETAIL_PRNT>
							<DETAIL_PRNT>�������ֽ��ֵ��</DETAIL_PRNT>
							<DETAIL_PRNT>������    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</DETAIL_PRNT>
							<DETAIL_PRNT>�������������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ�</DETAIL_PRNT>
							<DETAIL_PRNT>�������ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</DETAIL_PRNT>
						</xsl:otherwise>
					</xsl:choose>
				<DETAIL_PRNT>������-------------------------------------------------------------------------------------------------</DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</DETAIL_PRNT>
				<DETAIL_PRNT></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></DETAIL_PRNT>
				<DETAIL_PRNT></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></DETAIL_PRNT>
				<DETAIL_PRNT><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/></DETAIL_PRNT>
			</DETAIL>
			<CLASS_COUNT>1</CLASS_COUNT>
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
			<MSG>
				<MSG_COUNT></MSG_COUNT><!-- ��ֵ��ContConfirm.java�ж�̬���� -->
				<DETAIL_TEMP/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG/>
				<DETAIL_MSG><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</DETAIL_MSG>
				<DETAIL_MSG/>
				<DETAIL_MSG>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </DETAIL_MSG>
				<DETAIL_MSG>������------------------------------------------------------------------------------------------------</DETAIL_MSG>
				<DETAIL_MSG>��������������������<xsl:value-of select="Insured/Name"/></DETAIL_MSG>
                <xsl:if test="$RiskCount=1">
		        <DETAIL_MSG>
			    <xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></DETAIL_MSG>
		        <DETAIL_MSG><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text></DETAIL_MSG>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <DETAIL_MSG><xsl:text/><xsl:text>����������</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</DETAIL_MSG>
			    </xsl:for-each>
	            </xsl:if>
	 
	            <xsl:if test="$RiskCount!=1">
	 	        <DETAIL_MSG>
			    <xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></DETAIL_MSG>
		        <DETAIL_MSG><xsl:text/>�������������ĩ<xsl:text>                 </xsl:text>
				   <xsl:text>�ֽ��ֵ                                �ֽ��ֵ</xsl:text></DETAIL_MSG>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <DETAIL_MSG>
					 <xsl:text/><xsl:text>����������</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</DETAIL_MSG>
			    </xsl:for-each>
	            </xsl:if>
				<DETAIL_MSG>������------------------------------------------------------------------------------------------------</DETAIL_MSG>
				<DETAIL_MSG/>
				<DETAIL_MSG>��������ע��</DETAIL_MSG>
				<DETAIL_MSG>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</DETAIL_MSG>
				<DETAIL_MSG>������------------------------------------------------------------------------------------------------</DETAIL_MSG>
			</MSG>
			</xsl:if>
			<PRTS>
				<PRT_REC_NUM>0</PRT_REC_NUM>
			</PRTS>
			<TITLE>
				<PRT_TITLE_NUM/>
				<TITLE_DETAIL/>
			</TITLE>
		</DETAIL_LIST>
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
			<xsl:when test=".=6">�۰Ļ���֤</xsl:when>
			<xsl:when test=".=7">̨��֤    </xsl:when>
			<xsl:when test=".=8">����      </xsl:when>
			<xsl:when test=".=9">�쳣���֤</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �ɷѼ��  -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=0">һ�ν���</xsl:when>
			<xsl:when test=".=1">�½�</xsl:when>
			<xsl:when test=".=3">����</xsl:when>
			<xsl:when test=".=6">���꽻</xsl:when>
			<xsl:when test=".=12">�꽻</xsl:when>
			<xsl:when test=".=-1">�����ڽ�</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �Ա�ע�⣺����     ���ո��Ű��õģ�����ȥ����-->
	<xsl:template match="Sex">
		<xsl:choose>
			<xsl:when test=".=0">��</xsl:when>
			<xsl:when test=".=1">Ů</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode"/>
		<xsl:choose>
			<xsl:when test="$riskcode=50015">50002</xsl:when>
			<!-- ��ϲ�Ʒ 50002-�������Ӯ���ռƻ�: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
			<!-- ��ϲ�Ʒ 50015-�������Ӯ���ռƻ�: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ������ȡ  -->
	<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">�ۼ���Ϣ</xsl:when>
			<xsl:when test=".=2">��ȡ�ֽ�</xsl:when>
			<xsl:when test=".=3">�ֽɱ���</xsl:when>
			<xsl:when test=".=5">�����</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɹ���־λ -->
	<xsl:template match="Flag">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- ���гɹ� -->
			<xsl:when test=".='1'">0</xsl:when><!-- ����ʧ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ��ȡ��ʽ -->
	<xsl:template match="GetIntv">
		<xsl:choose>
			<xsl:when test=".='0'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='3'"></xsl:when><!-- ���� -->
			<xsl:when test=".='6'"></xsl:when><!-- ������ -->
			<xsl:when test=".='12'">2</xsl:when><!-- ���� -->
			<xsl:when test=".='36'"></xsl:when><!-- ������ -->
			<xsl:when test=".='120'"></xsl:when><!-- ʮ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- �Ա� -->
	<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$sex='0'">1</xsl:when><!-- �� -->
			<xsl:when test="$sex='1'">2</xsl:when><!-- Ů -->
			<xsl:otherwise>--</xsl:otherwise><!-- ��ȷ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤������ -->
	<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
		<xsl:choose>
			<xsl:when test="$idtype='0'">0</xsl:when><!-- ���֤ -->
			<xsl:when test="$idtype='1'">9</xsl:when><!-- ���� -->
			<xsl:when test="$idtype='2'">4</xsl:when><!-- ����֤ -->
			<xsl:when test="$idtype='3'">8</xsl:when><!-- ���� -->
			<xsl:when test="$idtype='4'">8</xsl:when><!-- ����֤�� -->
			<xsl:when test="$idtype='5'">8</xsl:when><!-- ���ڲ� -->
			<xsl:when test="$idtype='6'">A</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test="$idtype='7'">B</xsl:when><!-- ̨�����������½ͨ��֤ -->
			<xsl:when test="$idtype='8'">8</xsl:when><!-- ���� -->
			<xsl:when test="$idtype='9'">8</xsl:when><!-- �쳣���֤ -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �뱻�����˹�ϵ -->
	<xsl:template name="tran_RelaToInsured">
	<xsl:param name="relaToInsured" />
		<xsl:choose>
			<xsl:when test="$relaToInsured='00'">1</xsl:when><!-- ���� -->
			<xsl:when test="$relaToInsured='02'">2</xsl:when><!-- ��ż -->
			<xsl:when test="$relaToInsured='01'">3</xsl:when><!-- ��ĸ -->
			<xsl:when test="$relaToInsured='03'">4</xsl:when><!-- ��Ů -->
			<xsl:when test="$relaToInsured='04'">5</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ������������1 ��������ǰ���жϣ���2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
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
			<xsl:when test=".='0'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='12'">2</xsl:when><!-- ��� -->
			<xsl:when test=".='6'">3</xsl:when><!-- ����� -->
			<xsl:when test=".='3'">4</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">5</xsl:when><!-- �½� -->
		</xsl:choose>
	</xsl:template>
 	<!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<!-- 50015-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,L12081 - ����������������գ������ͣ� -->
			<xsl:when test="$riskCode='50015'">50002</xsl:when><!-- �������Ӯ������ϼƻ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
