<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:variable name="InsuredSex" select="/TranData/Body/Insured/Sex"/>
	
	<xsl:template match="/TranData">
		<RETURN>
			<xsl:copy-of select="Head" />
			
			<xsl:if test="Head/Flag='0'">
				<xsl:apply-templates select="Body" />
			</xsl:if>
			<xsl:if test="Head/Flag='1'">
				<MAIN />
			</xsl:if>
			
		</RETURN>
	</xsl:template>

	<xsl:template name="TRAN_BODY" match="Body">
			<xsl:variable name ="MainRisk" select ="Risk[RiskCode=MainRiskCode]"/>
			<MAIN>
				<!-- Ͷ������ -->
				<APPLNO><xsl:value-of select="ProposalPrtNo" /></APPLNO>
				<!-- ���յ��� -->
				<POLICY_NO><xsl:value-of select="ContNo" /></POLICY_NO>
				<!-- Ͷ������ -->
				<TB_DATE><xsl:value-of select="$MainRisk/PolApplyDate" /></TB_DATE>
				<!-- �ܱ��� -->
				<TOT_PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></TOT_PREM>
				<!-- ���ڱ��� -->
				<INIT_PREM_AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></INIT_PREM_AMT>
				<!-- ���ڱ���, ��д -->
				<INIT_PREM_TXT><xsl:value-of select="ActSumPremText" /></INIT_PREM_TXT>
				<!-- ��Ч���� -->
				<VALIDATE><xsl:value-of select="$MainRisk/CValiDate" /></VALIDATE>
				<!-- ������ֹ���� -->
				<CONTENDDATE><xsl:value-of select="$MainRisk/InsuEndDate" /></CONTENDDATE>
				<!-- �����˻� -->
				<BANKACC><xsl:value-of select="AccNo" /></BANKACC>
				<!-- �ɷѷ�ʽ -->
				<PAYMETHOD><xsl:apply-templates select="$MainRisk/PayIntv" /></PAYMETHOD>
				<!-- �ɷѷ�ʽ(����) -->
				<PAY_METHOD></PAY_METHOD>
				<!-- �ɷ����� -->
				<PAYDATE><xsl:value-of select="$MainRisk/PolApplyDate" /></PAYDATE>
				<!-- �б���˾ -->
				<ORGAN><xsl:value-of select="ComName" /></ORGAN>
				<!-- ��˾��ַ -->
				<LOC><xsl:value-of select="ComLocation" /></LOC>
				<!-- ��˾�绰 -->
				<TEL>95569</TEL>
				<!-- ����������� -->
				<BRNO></BRNO>
				<!-- ר��Ա���� -->
				<AGENT_PSN_NAME></AGENT_PSN_NAME>
			</MAIN>
			
			<!-- ������Ϣ -->
			<PRODUCTS>
				<!-- �������� -->
				<RiskCount><xsl:value-of select="count(Risk)" /></RiskCount>
				<xsl:for-each select="Risk">
					<PRODUCT>
						<POLICY_NO><xsl:value-of select="../ContNo" /></POLICY_NO>
						<AMT_UNIT><xsl:value-of select="Mult" /></AMT_UNIT>
						<!-- 0:����  1:������ -->
						<MAIN_SUB_FLG>
							<xsl:if test="RiskCode=MainRiskCode">0</xsl:if>
							<xsl:if test="RiskCode!=MainRiskCode">1</xsl:if>
						</MAIN_SUB_FLG>
						
						<AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" /></AMT>
						<PREMIUM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" /></PREMIUM>
						<AMOUNT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" /></AMOUNT>
						<PRODUCTID>
							<xsl:call-template name="tran_risk">
								<xsl:with-param name="riskcode" select="RiskCode" />
							</xsl:call-template>
						</PRODUCTID>
						<NAME><xsl:value-of select="RiskName" /></NAME>
						
						<COVERAGE_PERIOD></COVERAGE_PERIOD>
						<INSU_DUR><xsl:value-of select="InsuYear" /></INSU_DUR>
						
						<xsl:choose>
							<xsl:when test="PayIntv='0'" >
								<!-- ���� -->
								<PAY_TYPE>1</PAY_TYPE>
							</xsl:when>
							<xsl:when test="PayEndYearFlag='A' and PayEndYear='106'" >
								<PAY_TYPE>6</PAY_TYPE>
								<!-- FIXME ����ɷ��Ǹ��ֶε�ֵ��ʲô -->
							</xsl:when>
							<xsl:otherwise>
								<PAY_TYPE><xsl:apply-templates select="PayEndYearFlag" /></PAY_TYPE>
							</xsl:otherwise>
						</xsl:choose>
						<PAY_YEAR><xsl:value-of select="PayEndYear" /></PAY_YEAR>
						
						<DRAW_FST></DRAW_FST>
						<DRAW_LST></DRAW_LST>						
					</PRODUCT>
				</xsl:for-each>
			</PRODUCTS>
			
	</xsl:template>
	

	<!-- ���ִ��� -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='122046'">50002</xsl:when>	<!-- ������Ӯ���ռƻ� -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ���Ʒ -->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<xsl:when test="$riskcode='L12078'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ�Ƶ�� -->
	<!-- <xsl:template match="PayIntv"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='12'">1</xsl:when> --><!-- ��� -->
	<!-- 		<xsl:when test=".='6'">2</xsl:when> --><!-- ���꽻 -->
	<!-- 		<xsl:when test=".='3'">3</xsl:when> --><!-- ����-->
	<!-- 		<xsl:when test=".='1'">4</xsl:when> --><!-- �½� -->
	<!-- 		<xsl:when test=".='0'">6</xsl:when> --><!-- ���� -->
	<!-- 		<xsl:when test=".='-1'">0</xsl:when> --><!-- �����ڽ� -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">2</xsl:when><!-- ��� -->
			<xsl:when test=".='6'">3</xsl:when><!-- ���꽻 -->
			<xsl:when test=".='3'">4</xsl:when><!-- ����-->
			<xsl:when test=".='1'">5</xsl:when><!-- �½� -->
			<xsl:when test=".='0'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='-1'">6</xsl:when><!-- �����ڽ� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ����������־ -->
	<!-- ���У�3	����ȷ������,4 �����ɷ�,7 ��,8 ��,9 ��,10 ���� -->
	<!-- <xsl:template match="PayEndYearFlag"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test=".='Y'">9</xsl:when> --><!-- �����޽� -->
	<!-- 		<xsl:when test=".='M'">7</xsl:when> --><!-- �����޽� -->
			<!-- <xsl:when test=".='Y'">10</xsl:when> ���� -->
	<!-- 		<xsl:when test=".='A'">3</xsl:when> --><!-- ����ĳȷ������ -->
			<!-- <xsl:when test=".='A'">4</xsl:when> �����ɷ� -->
	<!-- 		<xsl:when test=".='D'">8</xsl:when> --><!-- �սɷ� -->
	<!-- 		<xsl:otherwise>-</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:template> -->
	<!-- ���У�0	����ȷ������,6 �����ɷ�,5 ��,8 ��,2 ��,1 ���� -->
	<xsl:template match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">2</xsl:when><!-- �����޽� -->
			<xsl:when test=".='M'">5</xsl:when><!-- �����޽� -->
			<!-- <xsl:when test=".='Y'">1</xsl:when> ���� -->
			<xsl:when test=".='A'">0</xsl:when><!-- ����ĳȷ������ -->
			<!-- <xsl:when test=".='A'">6</xsl:when> �����ɷ� -->
			<xsl:when test=".='D'">8</xsl:when><!-- �սɷ� -->
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>


