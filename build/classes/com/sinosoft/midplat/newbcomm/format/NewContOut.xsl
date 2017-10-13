<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<Rsp>
			<xsl:apply-templates select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</Rsp>
	</xsl:template>

	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0��ʾ�ɹ���1��ʾʧ�� ��3ת��ʵʱ-->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- ʧ��ʱ�����ش�����Ϣ -->
		</Head>
	</xsl:template>

	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
			<PrdList>				
				<Count>1</Count>
				<PrdItem>
					<!-- ���ִ��� -->
					<PrdId>
					<xsl:choose>
						<xsl:when test="ContPlan/ContPlanCode !=''">
							<xsl:call-template name="tran_riskCode_ins">
								<xsl:with-param name="riskCode" select="ContPlan/ContPlanCode" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="tran_riskCode_ins">
								<xsl:with-param name="riskCode" select="$MainRisk/RiskCode" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>	
					</PrdId>				
					<!-- �Ƿ�Ϊ���� -->
					<IsMain>1</IsMain>
					<!-- �������ͣ���θ�ֵ���� -->
					<PrdType></PrdType>
					<!-- ���յȼ� 1.7�Ѿ�ȥ��
					<RiskLevel></RiskLevel>  -->
					<!-- Ͷ������ -->
					<xsl:choose>
						<xsl:when test="ContPlan/ContPlanMult=''">
							<Units><xsl:value-of select="$MainRisk/Mult" /></Units>
						</xsl:when>
						<xsl:otherwise>
							<Units><xsl:value-of select="ContPlan/ContPlanMult" /></Units>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- ���ڽɷѽ�� -->
					<InitAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></InitAmt>
					<!-- ÿ�ڽɷѽ�� -->
					<TermAmt></TermAmt>
					<!-- ���������� -->
					<TermNum></TermNum>
					<!-- �ɷѽ�� -->
					<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PayAmt>
					<!-- �ɷ����� -->
					<PayNum></PayNum>
					<!-- �ѽɱ��� -->
					<PaidAmt></PaidAmt>
					<!-- �ѽ����� -->
					<PaidNum></PaidNum>
					<!-- �ܱ��� -->
					<PremAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PremAmt>
					<!-- �ܱ��� -->
					<CovAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" /></CovAmt>
					<!-- �ɷѷ�ʽ ����-->
					<PremType><xsl:apply-templates select="$MainRisk/PayIntv" /></PremType>
					<!-- �ɷ��������� ���� -->
					<xsl:choose>
						<xsl:when test="$MainRisk/PayEndYearFlag='Y' and $MainRisk/PayEndYear=1000">
							<PremTermType>01</PremTermType>
							<!-- �ɷ����� -->
							<PremTerm>0</PremTerm>
						</xsl:when>
						<xsl:when test="$MainRisk/PayEndYearFlag='A' and $MainRisk/PayEndYear=106">
							<PremTermType>04</PremTermType>
							<!-- �ɷ����� -->
							<PremTerm>99</PremTerm>
						</xsl:when>
						<xsl:otherwise>
							<PremTermType><xsl:apply-templates select="$MainRisk/PayEndYearFlag" /></PremTermType>
							<!-- �ɷ����� -->
							<PremTerm><xsl:value-of select="$MainRisk/PayEndYear" /></PremTerm>
						</xsl:otherwise>
					</xsl:choose>
					
					
					<!-- ������������ �����ޱ� -->
					<xsl:choose>
						<xsl:when test="$MainRisk/InsuYearFlag='A' and $MainRisk/InsuYear=106">
							<CovTermType>01</CovTermType>
						</xsl:when>
						<xsl:otherwise>
							<CovTermType><xsl:apply-templates select="$MainRisk/InsuYearFlag" /></CovTermType>
						</xsl:otherwise>
					</xsl:choose>
					<!-- �������� -->
					<CovTerm><xsl:value-of select="$MainRisk/InsuYear" /></CovTerm>					
					<!-- ��ȡ�������� һ������ȡ02 -->
					<DrawTermType></DrawTermType>
					<!-- ��ȡ���� -->
					<DrawTerm></DrawTerm>
					<!-- ��ȡ��ʼ���� -->
					<DrawStartAge></DrawStartAge>
					<!-- ��ȡ��ֹ���� -->
					<DrawEndAge></DrawEndAge>
					<!-- ��Ч���� -->
					<ValiDate><xsl:value-of select="$MainRisk/CValiDate" /></ValiDate>
					<!-- ��ֹ����:��Ϊ��������д99991231 -->
					<xsl:choose>
						<xsl:when test="$MainRisk/InsuYearFlag='A' and $MainRisk/InsuYear=106">
							<InvaliDate>99991231</InvaliDate>
						</xsl:when>
						<xsl:otherwise>
							<InvaliDate><xsl:value-of select="$MainRisk/InsuEndDate" /></InvaliDate>
						</xsl:otherwise>
					</xsl:choose>					
					<!-- ������������ -->
					<OmnPrdItem />
					<!-- Ͷ���������� -->
					<InvPrdItem />
					<!-- �Ʋ��������� -->
					<PropPrdItem />
					<!-- ������������ -->
					<SudPrdItem />
					<!-- ���ֹ�����չ�� -->
					<ExtItem />
				</PrdItem>
			</PrdList>
			<PolItem>
				<!-- Ͷ������ -->
				<ApplyNo><xsl:value-of select="ProposalPrtNo" /></ApplyNo>
				<!-- ÿ�ڽɷѽ�� -->
				<TermAmt></TermAmt>
				<!-- ���������� -->
				<TermNum></TermNum>
				<!-- �ɷѽ�� -->
				<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PayAmt>
				<!-- �ɷ����� -->
				<PayNum></PayNum>
				<!-- �ѽɱ��� -->
				<PaidAmt></PaidAmt>
				<!-- �ѽ����� -->
				<PaidNum></PaidNum>
				<!-- �ܱ��� -->
				<PremAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PremAmt>
				<!-- �ܱ��� -->
				<CovAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" /></CovAmt>
			</PolItem>
			<PrtList />
		</Body>
	</xsl:template>
	<!-- �ɷѷ�ʽ -->
	<xsl:template name="PayIntv" match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='0'">01</xsl:when>	<!-- ����     -->
			<xsl:when test=".='1'">02</xsl:when>	<!-- �½�     -->
			<xsl:when test=".='3'">03</xsl:when>	<!-- ����     -->
			<xsl:when test=".='6'">04</xsl:when>	<!-- �����    -->        
			<xsl:when test=".='12'">05</xsl:when>	<!-- ���     -->
			<xsl:when test=".='-1'">06</xsl:when>	<!-- �����ڽɰ��� -->
		</xsl:choose>
	</xsl:template>
	<!-- �ɷ��������� -->
	<xsl:template name="PayEndYearFlag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">02</xsl:when>	<!-- ����     -->
			<xsl:when test=".='A'">03</xsl:when>	<!-- ��ĳȷ������     -->
			<xsl:when test=".='M'">06</xsl:when>	<!-- ����     -->
		</xsl:choose>
	</xsl:template>
	<!-- ������������ -->
	<xsl:template name="InsuYearFlag" match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='Y'">02</xsl:when>	<!-- �����ޱ�     -->
			<xsl:when test=".='A'">03</xsl:when>	<!-- ��ĳȷ������     -->
			<xsl:when test=".='M'">05</xsl:when>	<!-- ����     -->
			<xsl:when test=".='D'">06</xsl:when>	<!-- ����     -->
		</xsl:choose>
	</xsl:template>
	<xsl:template name="tran_riskCode_ins">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<xsl:when test="$riskCode='50012'">50012</xsl:when> <!--����ٰ���5�ű��ռƻ�-->
			<xsl:when test="$riskCode='L12087'">L12087</xsl:when> <!--  �������  -->
			<xsl:when test="$riskCode='L12079'">L12079</xsl:when> <!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<xsl:when test="$riskCode='50001'">50001</xsl:when><!-- �������Ӯ1����ȫ����  -->
			<xsl:when test="$riskCode='50002'">122046</xsl:when><!-- �������Ӯ1����ȫ����  -->
			<xsl:when test="$riskCode='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
			<xsl:when test="$riskCode='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ�  -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>