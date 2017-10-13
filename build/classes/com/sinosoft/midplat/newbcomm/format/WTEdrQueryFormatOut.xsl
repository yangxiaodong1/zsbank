<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
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
			</Flag><!-- 0��ʾ�ɹ���1��ʾʧ�� -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- ʧ��ʱ�����ش�����Ϣ -->
		</Head>
	</xsl:template>
	<xsl:template name="Body" match="Body">
	 <Body>
	 	<CurType>CNY</CurType>
	 	<PrdList>	 
	 		<Count>1</Count>	
	 		<PrdItem>
	 			<xsl:variable name="MainRisk" select="PubContInfo/Risk[RiskCode=MainRiskCode]" />
				<!-- ���ִ��� -->
				<PrdId>
					<xsl:choose>
						<xsl:when test="PubContInfo/ContPlanCode !=''">
							<xsl:call-template name="tran_riskCode_ins">
								<xsl:with-param name="riskCode" select="PubContInfo/ContPlanCode" />
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
				<!-- �������� -->
				<PrdType></PrdType>
				<!-- ���յȼ� -->
				<RiskLevel></RiskLevel>
				<!-- Ͷ������ -->
				<Units></Units>
				<!-- ���ڽɷѽ�� -->
				<InitAmt></InitAmt>
				<!-- ÿ�ڽɷѽ�� -->
				<TermAmt></TermAmt>
				<!-- ���������� -->
				<TermNum></TermNum>
				<!-- �ɷѽ�� -->
				<PayAmt></PayAmt>
				<!-- �ɷ����� -->
				<PayNum></PayNum>
				<!-- �ѽɱ��� -->
				<PaidAmt></PaidAmt>
				<!-- �ѽ����� -->
				<PaidNum></PaidNum>
				<!-- �ܱ��� -->
				<PremAmt></PremAmt>
				<!-- �ܱ��� -->
				<CovAmt></CovAmt>
				<!-- �ɷѷ�ʽ ����-->
				<PremType>01</PremType>
				<!-- �ɷ��������� ���� -->
				<PremTermType>01</PremTermType>
				<!-- �ɷ����� -->
				<PremTerm></PremTerm>
				<!-- ������������ �����ޱ� -->
				<CovTermType></CovTermType>
				<!-- �������� -->
				<CovTerm></CovTerm>
				<!-- ��ȡ�������� -->
				<DrawTermType></DrawTermType>
				<!-- ��ȡ���� -->
				<DrawTerm></DrawTerm>
				<!-- ��ȡ��ʼ���� -->
				<DrawStartAge></DrawStartAge>
				<!-- ��ȡ��ֹ���� -->
				<DrawEndAge></DrawEndAge>
				<!-- ��Ч���� -->
				<ValiDate>
					<xsl:value-of select="PubContInfo/ContValidDate" />
				</ValiDate>
				<!-- ��ֹ���� -->
				<InvaliDate>
					<xsl:value-of select="PubContInfo/ContExpireDate" />
				</InvaliDate>
				<!-- ������������ -->
				<OmnPrdItem />
				<!-- Ͷ���������� -->
				<InvPrdItem />
				<!-- �Ʋ��������� -->
				<PropPrdItem></PropPrdItem>
				<!-- ������������ -->
				<SudPrdItem />
				<!-- ���ֹ�����չ�� -->
				<ExtItem />
			</PrdItem>				
		 </PrdList>
		 <PolItem>
		 	<!-- ������ -->
			<PolNo><xsl:value-of select="PubContInfo/ContNo" /></PolNo>
			<!-- �˿��� -->
			<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></PayAmt>
			<!-- �ѽɷѽ�� -->
			<PaidAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></PaidAmt>
			<!-- �ѽ����� -->
			<PaidNum></PaidNum>
			<!-- ԭ���ѷ�ʽ -->
			<PayMode><xsl:apply-templates select="PubContInfo/PayMode" /></PayMode>
			<CusActItem>
				<!-- �˺� -->
				<ActNo><xsl:value-of select="CDrawAccountNo" /></ActNo>
				<!-- �˺Ż��� -->
				<ActName><xsl:value-of select="CDrawAccountName" /></ActName>
				<!-- ����֤������ -->
				<IdType><xsl:apply-templates select="AppCCertfCls" /></IdType>
				<!-- ����֤������ -->
				<IdNo><xsl:value-of select="AppCCertfCde" /></IdNo>
			</CusActItem>
		 </PolItem>
      </Body>
	</xsl:template>
	<!-- ���ִ��� -->
	<xsl:template name="tran_riskCode_ins">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<xsl:when test="$riskCode='50012'">50012</xsl:when> <!--����ٰ���5�ű��ռƻ�-->
			<xsl:when test="$riskCode='L12079'">L12079</xsl:when> <!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<xsl:when test="$riskCode='50001'">50001</xsl:when> <!--�������Ӯ1����ȫ����-->
			<xsl:when test="$riskCode='L12086'">L12086</xsl:when> <!-- �����3����ȫ���գ������ͣ� -->
		</xsl:choose>
	</xsl:template>
	<!-- �ɷ���ʽ -->
	<xsl:template name="PayMode" match="PayMode">
		<xsl:choose>
			<xsl:when test=".=7">01</xsl:when>	<!-- ����ת�� -->
			<xsl:when test=".=1">02</xsl:when>	<!-- �ֽ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>