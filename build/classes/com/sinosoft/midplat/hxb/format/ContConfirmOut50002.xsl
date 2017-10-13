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
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<MAIN>
				<!-- ���յ��� -->
				<POLICY><xsl:value-of select="ContNo" /></POLICY>
				<!-- Ͷ������ -->
				<APP><xsl:value-of select="ProposalPrtNo" /></APP>
				<!-- �б����� -->
				<ACCEPT><xsl:value-of select="$MainRisk/SignDate" /></ACCEPT>
				<!-- ���ڱ���, ��д -->
				<PREMC><xsl:value-of select="ActSumPremText" /></PREMC>
				<!-- ���ڱ��� -->
				<PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PREM>
				<!-- ��Ч���� -->
				<VALIDATE><xsl:value-of select="$MainRisk/CValiDate" /></VALIDATE>
				<!-- ������ֹ���� -->
				<INVALIDATE><xsl:value-of select="$MainRisk/InsuEndDate" /></INVALIDATE>
				<!-- �ɷ����� -->
				<PAYDATECHN><xsl:value-of select="$MainRisk/PolApplyDate" /></PAYDATECHN>
				<!-- ���ڽɷ����� -->
				<FIRSTPAYDATE><xsl:value-of select="$MainRisk/PolApplyDate" /></FIRSTPAYDATE>
				<!-- �ɷ���ֹ���� -->
				<PAYSEDATECHN><xsl:value-of select="$MainRisk/PayEndDate" /></PAYSEDATECHN>
				<!-- �ɷ���� -->
				<PAYYEAR></PAYYEAR>
				<!-- �б���˾ -->
				<ORGAN><xsl:value-of select="ComName" /></ORGAN>
				<!-- Ӫҵ��λ���� -->
				<ORGANCODE><xsl:value-of select="ComCode" /></ORGANCODE>
				<!-- ��˾��ַ -->
				<LOC><xsl:value-of select="ComLocation" /></LOC>
				<!-- ��˾�绰 -->
				<TEL>95569</TEL>
				<!-- �ر�Լ�� -->
				<ASSUM><xsl:value-of select="SpecContent" /></ASSUM>
				<!-- ר��Ա���� -->
				<ZGYNO></ZGYNO>
				<ZGYNAME></ZGYNAME>
				<REVMETHOD></REVMETHOD>
				<REVAGE></REVAGE>
				<CREDITNO></CREDITNO>
				<CREDITDATE></CREDITDATE>
				<CREDITENDDATE></CREDITENDDATE>
				<CREDITSUM></CREDITSUM>
			</MAIN>
		
		
		<!-- Ͷ������Ϣ -->
		<xsl:apply-templates select="Appnt" />
		<TBR_TELLERS>
			<TBR_TELLER>
				<TELLER_VER />
				<TELLER_CODE />
				<TELLER_CONT />
				<TELLER_REMARK />
			</TBR_TELLER>
		</TBR_TELLERS>
		
		<!-- ��������Ϣ -->
		<xsl:apply-templates select="Insured" />
		<BBR_TELLERS>
			<BBR_TELLER>
				<TELLER_VER />
				<TELLER_CODE />
				<TELLER_CONT />
				<TELLER_REMARK />
			</BBR_TELLER>
		</BBR_TELLERS>
		
		<!-- ������ -->
		<SYRS>
			<xsl:for-each select="Bnf">
				<SYR>
					<SYR_NAME><xsl:value-of select="Name" /></SYR_NAME>
					<SYR_SEX><xsl:apply-templates select="Sex" /></SYR_SEX>
					<SYR_PCT><xsl:value-of select="Lot" /></SYR_PCT>
					<SYR_BBR_RELA>
						<xsl:call-template name="tran_RelationRoleCode">
						    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
							<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
							<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
						</xsl:call-template>
					</SYR_BBR_RELA>
					<SYR_BIRTH><xsl:value-of select="Birthday" /></SYR_BIRTH>
					<SYR_IDTYPE><xsl:apply-templates select="IDType" /></SYR_IDTYPE>
					<SYR_IDNO><xsl:value-of select="IDNo" /></SYR_IDNO>
					<SYR_IDEFFSTARTDATE />
					<SYR_IDEFFENDDATE />
					<SYR_NATIVEPLACE />
					<SYR_ORDER><xsl:value-of select="Grade" /></SYR_ORDER>
				</SYR>
			</xsl:for-each>
		</SYRS>
		
		<!-- ������Ϣ -->
		<PTS>
			<xsl:variable name="RiskCode" select="ContPlan/ContPlanCode"/>
			<xsl:variable name="RiskName" select="ContPlan/ContPlanName"/>
			<xsl:variable name="RiskMult" select="ContPlan/ContPlanMult"/>
			<xsl:variable name="UpperPrem" select="ActSumPremText"/>
			<xsl:variable name="Prem" select="ActSumPrem"/>
			<xsl:variable name="AmntText" select="AmntText"/>
			<xsl:variable name="Amnt" select="Amnt"/>
			<xsl:for-each select="Risk[RiskCode=MainRiskCode]">
				<PT>
					<PAYENDDATE><xsl:value-of select="PayEndDate" /></PAYENDDATE>
					<UNIT><xsl:value-of select="$RiskMult" /></UNIT>
					<AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($Amnt)" /></AMT>
					<PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($Prem)" /></PREM>
					<ID>
						<xsl:call-template name="tran_risk">
							<xsl:with-param name="riskcode" select="$RiskCode" />
						</xsl:call-template>
					</ID>
					<MAINID>
						<xsl:call-template name="tran_risk">
							<xsl:with-param name="riskcode" select="$RiskCode" />
						</xsl:call-template>
					</MAINID>
					<NAME><xsl:value-of select="$RiskName" /></NAME>
					<COVERAGE_YEAR><xsl:value-of select="InsuYear" /></COVERAGE_YEAR>
					<COVERAGE_YEAR_DESC />
					<PAYMETHOD><xsl:apply-templates select="PayIntv" /></PAYMETHOD>
					<xsl:choose>
						<xsl:when test="PayEndYearFlag='Y' and PayEndYear='1000'" >
							<CHARGE_PERIOD>5</CHARGE_PERIOD>
							<CHARGE_YEAR>0</CHARGE_YEAR>
						</xsl:when>
						<xsl:when test="PayEndYearFlag='A' and PayEndYear='106'" >
							<CHARGE_PERIOD>8</CHARGE_PERIOD>
							<!-- FIXME ����ɷ��Ǹ��ֶε�ֵ��ʲô -->
							<CHARGE_YEAR>999</CHARGE_YEAR>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="PayEndYearFlag" />
							<CHARGE_YEAR>
								<xsl:value-of select="PayEndYear" />
							</CHARGE_YEAR>
						</xsl:otherwise>
					</xsl:choose>
								
					<PAYTODATE></PAYTODATE>
					<MULTIYEARFLAG></MULTIYEARFLAG>
					<YEARTYPE></YEARTYPE>
					<MULTIYEARS></MULTIYEARS>
					
					<!-- �ֽ��ֵ -->
					<VT>
						<VTICOUNT><xsl:value-of select="count(CashValues/CashValue)" /></VTICOUNT>
						<FIRST_RETPCT></FIRST_RETPCT>
						<SECOND_RETPCT></SECOND_RETPCT>
						<xsl:for-each select="CashValues/CashValue">
							<VTI>
								<LIVE></LIVE>
								<ILL></ILL>
								<YEAR></YEAR>
								<END><xsl:value-of select="EndYear" /></END>
								<CASH><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)" /></CASH>
								<ACI></ACI>
							</VTI>
						</xsl:for-each>
					</VT>
					<CONP>
						<CONICOUNT><xsl:value-of select="count(BonusValues/BonusValue)" /></CONICOUNT>
						<xsl:for-each select="BonusValues/BonusValue">
							<CONI>
								<END><xsl:value-of select="EndYear" /></END>
								<CON><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EndYearCash)" /></CON>
							</CONI>
						</xsl:for-each> 
					</CONP>
				</PT>
			</xsl:for-each>
		</PTS>
		
		<!-- ��ӡ�ļ����� -->
		<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- ������ֽ��ֵ��ʾ2ҳ -->
			<FILE_COUNT>2</FILE_COUNT>
		</xsl:if>
		<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- ���û���ֽ��ֵ��ʾ1ҳ -->
			<FILE_COUNT>1</FILE_COUNT>
		</xsl:if>
		<FILE_REMARK></FILE_REMARK>
		<FILE_TEMP></FILE_TEMP>
		<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
        <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

		
		<FILE_LIST>
			<FILE_PAGE>1</FILE_PAGE>
			<FILE_NAME>������ӡ��Ϣ</FILE_NAME>
			<FILE_REMARK />
			<FILE_TEMP />
			<PAGE_LIST>
				<DETAIL_COUNT />	<!-- ����,�����渳ֵ -->
				<DETAIL_REMARK />
				<DETAIL_TEMP />
				<Detail>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
					<xsl:text>                                      ��ֵ��λ�������Ԫ</xsl:text></BKDETAIL>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>
						<xsl:text>������Ͷ����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
						<xsl:text>֤�����ͣ�</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Appnt/IDType" /></xsl:call-template>
						<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
					</BKDETAIL>
					<BKDETAIL>
						<xsl:text>�������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
						<xsl:text>֤�����ͣ�</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Insured/IDType" /></xsl:call-template>
						<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
					</BKDETAIL>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<xsl:if test="count(Bnf) = 0">
					<BKDETAIL><xsl:text>��������������ˣ�����                </xsl:text>
							   <xsl:text>����˳��1                   </xsl:text>
							   <xsl:text>���������100%</xsl:text></BKDETAIL>
					</xsl:if>
					<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
					<BKDETAIL>
						<xsl:text>��������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
						<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
						<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
					</BKDETAIL>
					</xsl:for-each>
					</xsl:if>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>��������������</BKDETAIL>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL><xsl:text>��������������������                                             �������ս��\</xsl:text></BKDETAIL>
					<BKDETAIL><xsl:text>����������������������������               �����ڼ�    ��������     �ս�����\      ���շ�    ����Ƶ��</xsl:text></BKDETAIL>
					<BKDETAIL><xsl:text>��������������������                                               ����\����</xsl:text></BKDETAIL>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
							<BKDETAIL>
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
							</BKDETAIL>
						</xsl:when>
						<xsl:otherwise>
							<BKDETAIL>
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
							</BKDETAIL>
						</xsl:otherwise>
					</xsl:choose>					
				</xsl:for-each>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</BKDETAIL>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>���������յ��ر�Լ����</BKDETAIL>										
					<BKDETAIL>������    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</BKDETAIL>
					<BKDETAIL>�������ֽ��ֵ��</BKDETAIL>
					<BKDETAIL>������    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</BKDETAIL>
					<BKDETAIL>�������������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ�</BKDETAIL>
					<BKDETAIL>�������ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</BKDETAIL>
					<BKDETAIL>������-------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy��MM��dd��')"/><xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy��MM��dd��')"/></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></BKDETAIL>
					<BKDETAIL><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></BKDETAIL>
					<BKDETAIL/>
					<BKDETAIL><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></BKDETAIL>
					<BKDETAIL><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,48)"/><xsl:text>��ҵ�ʸ�֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode,0)"/></BKDETAIL>
				</Detail>
			</PAGE_LIST>
		</FILE_LIST>
					
		<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
		<xsl:variable name="RiskCount" select="count(Risk)"/>
		<xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	    <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
		<FILE_LIST>
			<FILE_PAGE>1</FILE_PAGE>
			<FILE_NAME>�����ֽ��ֵ</FILE_NAME>
			<FILE_REMARK></FILE_REMARK>
			<FILE_TEMP></FILE_TEMP>
			<PAGE_LIST>
				<DETAIL_COUNT></DETAIL_COUNT>	<!-- ����,�����渳ֵ -->
				<DETAIL_REMARK></DETAIL_REMARK>
				<DETAIL_TEMP></DETAIL_TEMP>
				<Detail>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </BKDETAIL>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL>��������������������<xsl:value-of select="Insured/Name"/></BKDETAIL>
					<xsl:if test="$RiskCount=1">
						<BKDETAIL>
							<xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></BKDETAIL>
						<BKDETAIL><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
								   <xsl:text>�ֽ��ֵ</xsl:text></BKDETAIL>
						   	<xsl:variable name="EndYear" select="EndYear"/>
						   <xsl:for-each select="$MainRisk/CashValues/CashValue">
							 <xsl:variable name="EndYear" select="EndYear"/>
							   <BKDETAIL><xsl:text/><xsl:text>����������</xsl:text>
														<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
														<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</BKDETAIL>
							</xsl:for-each>
					 </xsl:if>
					<xsl:if test="$RiskCount!=1">
					 	<BKDETAIL>
							<xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></BKDETAIL>
						<BKDETAIL><xsl:text/>�������������ĩ<xsl:text>                 </xsl:text>
								   <xsl:text>�ֽ��ֵ                                �ֽ��ֵ</xsl:text></BKDETAIL>
						   	<xsl:variable name="EndYear" select="EndYear"/>
						   <xsl:for-each select="$MainRisk/CashValues/CashValue">
							 <xsl:variable name="EndYear" select="EndYear"/>
							   <BKDETAIL>
									 <xsl:text/><xsl:text>����������</xsl:text>
									 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
									 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
									 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</BKDETAIL>
							</xsl:for-each>
					 </xsl:if>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
					<BKDETAIL></BKDETAIL>
					<BKDETAIL>��������ע��</BKDETAIL>
					<BKDETAIL>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ�� </BKDETAIL>
					<BKDETAIL>������------------------------------------------------------------------------------------------------</BKDETAIL>
				</Detail>
			</PAGE_LIST>
		</FILE_LIST>
		</xsl:if>
		<SPEC_CONTENT>
			<CONTENT><xsl:value-of select="SpecContent" /></CONTENT>
		</SPEC_CONTENT>
	</xsl:template>
	<!-- Ͷ������Ϣ -->
	<xsl:template name="TBR" match="Appnt">
		<TBR>
			<TBR_NAME><xsl:value-of select="Name" /></TBR_NAME>
			<TBR_SEX><xsl:apply-templates select="Sex" /></TBR_SEX>
			<TBR_BIRTH><xsl:value-of select="Birthday" /></TBR_BIRTH>
			<TBR_IDTYPE><xsl:apply-templates select="IDType" /></TBR_IDTYPE>
			<TBR_IDNO><xsl:value-of select="IDNo" /></TBR_IDNO>
			<TBR_IDEFFSTARTDATE></TBR_IDEFFSTARTDATE>
			<TBR_IDEFFENDDATE></TBR_IDEFFENDDATE>
			<TBR_ADDR><xsl:value-of select="Address" /></TBR_ADDR>
			<TBR_POSTCODE><xsl:value-of select="ZipCode" /></TBR_POSTCODE>
			<TBR_TEL><xsl:value-of select="Phone" /></TBR_TEL>
			<TBR_MOBILE><xsl:value-of select="Mobile" /></TBR_MOBILE>
			<TBR_EMAIL><xsl:value-of select="Email" /></TBR_EMAIL>
			<TBR_BBR_RELA>
				<xsl:call-template name="tran_RelationRoleCode">
				    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
					<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
					<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
				</xsl:call-template>
			</TBR_BBR_RELA>
			<TBR_OCCUTYPE>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode" select="JobCode" />
				</xsl:call-template>
			</TBR_OCCUTYPE>
			<TBR_NATIVEPLACE>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="Nationality" />
				</xsl:call-template>
			</TBR_NATIVEPLACE>
		</TBR>
	</xsl:template>
	
	<!-- ��������Ϣ -->
	<xsl:template name="BBR" match="Insured">
		<BBR>
			<BBR_NAME><xsl:value-of select="Name" /></BBR_NAME>
			<BBR_SEX><xsl:apply-templates select="Sex" /></BBR_SEX>
			<BBR_BIRTH><xsl:value-of select="Birthday" /></BBR_BIRTH>
			<BBR_IDTYPE><xsl:apply-templates select="IDType" /></BBR_IDTYPE>
			<BBR_IDNO><xsl:value-of select="IDNo" /></BBR_IDNO>
			<BBR_IDEFFSTARTDATE></BBR_IDEFFSTARTDATE>
			<BBR_IDEFFENDDATE></BBR_IDEFFENDDATE>
			<BBR_ADDR><xsl:value-of select="Address" /></BBR_ADDR>
			<BBR_POSTCODE><xsl:value-of select="ZipCode" /></BBR_POSTCODE>
			<BBR_TEL><xsl:value-of select="Phone" /></BBR_TEL>
			<BBR_MOBILE><xsl:value-of select="Mobile" /></BBR_MOBILE>
			<BBR_EMAIL><xsl:value-of select="Email" /></BBR_EMAIL>
			<BBR_OCCUTYPE>
				<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode" select="JobCode" />
				</xsl:call-template>
			</BBR_OCCUTYPE>
			<BBR_AGE />
			<BBR_NATIVEPLACE>
				<xsl:call-template name="tran_nativeplace">
					<xsl:with-param name="nativeplace" select="Nationality" />
				</xsl:call-template>
			</BBR_NATIVEPLACE>
		</BBR>
	</xsl:template>

	<!-- �潻��־ ���У�1 �ɹ���0 ʧ�ܣ����ģ�0 �ɹ���1 ʧ�� -->
	<xsl:template match="Flag">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when>
			<xsl:when test=".='1'">0</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �Ա𣬺��ģ�0=���ԣ�1=Ů�ԣ����У�1 �У�2 Ů��3 ��ȷ�� -->
	<xsl:template match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">2</xsl:when><!-- Ů�� -->
			<xsl:otherwise>3</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ����֤�����ͣ�51�������֤����ʱ���֤,52���������,53���ڲ�,54��������������Ч֤��,55�۰ľ��������ڵ�ͨ��֤,56���˻��侯���֤��,57ʿ��֤,58����֤,59��ְ�ɲ�֤,60��������֤,61��ְ�ɲ�����֤,62�侯���֤��,63�侯ʿ��֤,64����֤,65�侯��ְ�ɲ�֤,66�侯��������֤,67�侯��ְ�ɲ�����֤,98����,99���пͻ�����֤�� -->
	<!-- ���ģ�0	�������֤,1 ����,2 ����֤,3 ����,4 ����֤��,5	���ڲ�,8	����,9	�쳣���֤ -->
	<xsl:template name="tran_IDName">
		<xsl:param name="idName" />
		<xsl:choose>
			<xsl:when test="$idName='0'">���֤  </xsl:when>
			<xsl:when test="$idName='1'">����    </xsl:when>
			<xsl:when test="$idName='2'">����֤  </xsl:when>
			<xsl:when test="$idName='3'">����    </xsl:when>
			<xsl:when test="$idName='4'">����֤��</xsl:when>
			<xsl:when test="$idName='5'">���ڲ�  </xsl:when>
			<xsl:when test="$idName='8'">����    </xsl:when>
			<xsl:otherwise>����    </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">51</xsl:when>
			<xsl:when test=".='1'">52</xsl:when>
			<xsl:when test=".='2'">56</xsl:when>
			<xsl:when test=".='3'">54</xsl:when>
			<xsl:when test=".='4'">54</xsl:when>
			<xsl:when test=".='5'">53</xsl:when>
			<xsl:when test=".='8'">98</xsl:when>
			<xsl:otherwise>98</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- ��ϵ
	���У� 1����,2�ɷ�,3	���� ,4	���� ,5	ĸ��,6	����,7	Ů��,8	�游,9	��ĸ,10	����,11	��Ů,12	���游,
			13	����ĸ,14	����,15	����Ů,16	���,17	���,18	�ܵ�,19	����,20	����,21	����,22	��ϱ,23	���� 
			24	��ĸ,25	Ů��,26	��������,27	ͬ��,28	����,29	����,30	���� 
	  
	���ģ�00���� ��01��ĸ��,02��ż��03��Ů,04����,05��Ӷ,06����,07����,08����
	      0 �У�1Ů
	 -->
	<xsl:template name="tran_RelationRoleCode">
	    <xsl:param name="relaToInsured"></xsl:param>
	    <xsl:param name="insuredSex"></xsl:param>
	    <xsl:param name="sex"></xsl:param>
		<xsl:choose>
			<!-- ���� -->
			<xsl:when test="$relaToInsured='00'">1</xsl:when>
			
			<!-- ��ĸ -->
			<xsl:when test="$relaToInsured='01'">
			    <xsl:if test="$sex='0'">4</xsl:if>
			    <xsl:if test="$sex='1'">5</xsl:if>
	        </xsl:when>
	        <!-- ��ż -->
			<xsl:when test="$relaToInsured='02'">
				<xsl:if test="$sex='0'">2</xsl:if>
			    <xsl:if test="$sex='1'">3</xsl:if>
			</xsl:when>
			<!-- ��Ů -->
			<xsl:when test="$relaToInsured='03'">
			    <xsl:if test="$sex='0'">6</xsl:if>
			    <xsl:if test="$sex='1'">7</xsl:if>
	        </xsl:when>
			<!-- ���� -->
			<xsl:when test="$relaToInsured='04'">30</xsl:when>
			<!-- ��Ӷ -->
			<xsl:when test="$relaToInsured='05'">29</xsl:when>
			<!-- ���� -->
			<xsl:otherwise>30</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ְҵ���� -->
	<xsl:template name="tran_jobcode">
		<xsl:param name="jobcode" />
		<xsl:choose>
			<xsl:when test="$jobcode='4030111'">A</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
			<xsl:when test="$jobcode='2050101'">B</xsl:when>	<!-- ����רҵ������Ա -->
			<xsl:when test="$jobcode='2070109'">C</xsl:when>	<!-- ����ҵ����Ա -->
			<xsl:when test="$jobcode='2080103'">D</xsl:when>	<!-- ����רҵ��Ա -->
			<xsl:when test="$jobcode='2090104'">E</xsl:when>	<!-- ��ѧ��Ա -->
			<xsl:when test="$jobcode='2100106'">F</xsl:when>	<!-- ���ų��漰��ѧ����������Ա -->
			<xsl:when test="$jobcode='2130101'">G</xsl:when>	<!-- �ڽ�ְҵ�� -->
			<xsl:when test="$jobcode='3030101'">H</xsl:when>	<!-- �����͵���ҵ����Ա -->
			<xsl:when test="$jobcode='4010101'">I</xsl:when>	<!-- ��ҵ������ҵ��Ա -->
			<xsl:when test="$jobcode='5010107'">J</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա -->
			<xsl:when test="$jobcode='6240105'">K</xsl:when>	<!-- ������Ա -->
			<xsl:when test="$jobcode='2020103'">L</xsl:when>	<!-- ��ַ��̽��Ա -->
			<xsl:when test="$jobcode='2020906'">M</xsl:when>	<!-- ����ʩ����Ա -->
			<xsl:when test="$jobcode='6050611'">N</xsl:when>	<!-- �ӹ����졢���鼰������Ա -->
			<xsl:when test="$jobcode='7010103'">O</xsl:when>	<!-- ���� -->
			<xsl:when test="$jobcode='8010101'">P</xsl:when>	<!-- ��ҵ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �������� -->
	<xsl:template name="tran_nativeplace">
		<xsl:param name="nativeplace" />
		<xsl:choose>
			<xsl:when test="$nativeplace='CHN'">0156</xsl:when>	<!-- �й� -->
			<xsl:when test="$nativeplace='CHN'">0344</xsl:when>	<!-- �й���� -->
			<xsl:when test="$nativeplace='CHN'">0158</xsl:when>	<!-- �й�̨�� -->
			<xsl:when test="$nativeplace='CHN'">0446</xsl:when>	<!-- �й����� -->
			<xsl:when test="$nativeplace='JP'">0392</xsl:when>	<!-- �ձ� -->
			<xsl:when test="$nativeplace='US'">0840</xsl:when>	<!-- ���� -->
			<xsl:when test="$nativeplace='RU'">0643</xsl:when>	<!-- ����˹ -->
			<xsl:when test="$nativeplace='GB'">0826</xsl:when>	<!-- Ӣ�� -->
			<xsl:when test="$nativeplace='FR'">0250</xsl:when>	<!-- ���� -->
			<xsl:when test="$nativeplace='DE'">0276</xsl:when>	<!-- �¹� -->
			<xsl:when test="$nativeplace='KR'">0410</xsl:when>	<!-- ���� -->
			<xsl:when test="$nativeplace='SG'">0702</xsl:when>	<!-- �¼��� -->
			<xsl:when test="$nativeplace='ID'">0360</xsl:when>	<!-- ӡ�������� -->
			<xsl:when test="$nativeplace='IN'">0356</xsl:when>	<!-- ӡ�� -->
			<xsl:when test="$nativeplace='IT'">0380</xsl:when>	<!-- ����� -->
			<xsl:when test="$nativeplace='MY'">0458</xsl:when>	<!-- �������� -->
			<xsl:when test="$nativeplace='TH'">0764</xsl:when>	<!-- ̩�� -->
			<xsl:when test="$nativeplace='OTH'">0999</xsl:when>	<!-- �������Һ͵��� -->
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='50015'">50002</xsl:when>
			<xsl:when test="$riskcode='122046'">122046</xsl:when><!-- ���գ�122046 - �������Ӯ1����ȫ���� -->
			<xsl:when test="$riskcode='122047'">122047</xsl:when><!-- �����գ�122047 - ����ӳ�����Ӯ��ȫ���� -->
			<xsl:when test="$riskcode='122048'">122048</xsl:when><!-- �����գ�122048 - ����������������գ������ͣ� -->			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ�Ƶ�� -->
	<!-- ���У�1 �꽻��2 ���꽻��3 ������4 �½���5 ������6 �����ڽ���7 ����ĳȷ�����䣬8 �����ɷ� -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">1</xsl:when><!-- ��� -->
			<xsl:when test=".='6'">2</xsl:when><!-- ���꽻 -->
			<xsl:when test=".='3'">3</xsl:when><!-- ����-->
			<xsl:when test=".='1'">4</xsl:when><!-- �½� -->
			<xsl:when test=".='0'">5</xsl:when><!-- ���� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ����������־ -->
	<!-- ���У�1 ��ɣ�2 ����ɣ�3 ���ɣ�4 �½ɣ�5 ���ɣ� 6 �����ڽɣ� 7 ����ĳȷ�����䣬 8 �����ɷ� -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">1</xsl:when><!-- �����޽� -->
			<xsl:when test=".='M'">4</xsl:when><!-- �����޽� -->
			<xsl:when test=".='Y'">5</xsl:when><!-- ���� -->
			<xsl:when test=".='A'">7</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='A'">8</xsl:when><!-- �����ɷ� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>