<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
<xsl:template match="/TranData">
		<RETURN>
			<xsl:variable name ="flag" select ="Head/Flag"/>
			<MAIN>
				<xsl:choose>
					<xsl:when test="$flag=1">
						<!-- ���չ�˾1ʧ�ܣ�0�ɹ� -->
						<APP><xsl:value-of select ="Body/ProposalPrtNo"/></APP>
						<OKFLAG><xsl:apply-templates select="Head/Flag" /></OKFLAG><!-- 1 �ɹ���0 ʧ�� -->
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
				<SYR_NATIVEPLACE><xsl:value-of select ="Nationality"/></SYR_NATIVEPLACE>
				<SYR_TEMP><xsl:value-of select="Grade"/></SYR_TEMP>
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
			
			<!-- ������ -->
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
			<PAYMETHOD><xsl:apply-templates select ="PayIntv"/></PAYMETHOD>
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
		</PT>
		
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
