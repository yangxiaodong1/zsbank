<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<xsl:apply-templates select="TranData/Body" />
</Transaction>
</xsl:template>

<xsl:template name="Body" match="Body">
	<TransBody>
			<DetailList>
				<xsl:for-each select="Cont[ContState='00']">
					<Detail>
						<CPlyNo><xsl:value-of select ="ContNo"/></CPlyNo><!--������ -->
						<CPlySts><xsl:apply-templates select ="MortStatu"/></CPlySts><!--����״̬ -->
						<NCurAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueD)"/></NCurAmt><!--�����ֽ��ֵ -->
						<NSavingAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></NSavingAmt><!--���� -->
						<NAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/></NAmt><!--���� -->
						<CPrmCur>01</CPrmCur><!--���ѱ��� -->
						<TAppTm><xsl:value-of select ="PolApplyDate"/></TAppTm><!--Ͷ������ -->
						<TInsrncBgnTm><xsl:value-of select ="CValiDate"/></TInsrncBgnTm><!--�������� -->
						<TInsrncEndTm><xsl:value-of select ="InsuEndDate"/></TInsrncEndTm><!--����ֹ�� -->
						<xsl:choose>
							<xsl:when test="ContPlan/ContPlanCode !=''">
								<!-- <CprodNo>
									<xsl:call-template name="tran_riskcode">
										<xsl:with-param name="riskcode">
											<xsl:value-of select="ContPlan/ContPlanCode"/>
										</xsl:with-param>
									</xsl:call-template>
								</CprodNo> --><!--��Ʒ���� -->
								<CprodNo><xsl:value-of select="ContPlan/ContPlanCode"/></CprodNo><!-- ���ڴ��ڷ�����ͨ��������Ѻ�������Ȳ���ӳ�䴦�� -->
								<CProdNme><xsl:value-of select ="ContPlan/ContPlanName"/></CProdNme><!--��Ʒ���� -->
							</xsl:when>
							<xsl:otherwise>
								<!-- <CprodNo>
								<xsl:call-template name="tran_riskcode">
										<xsl:with-param name="riskcode">
											<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskCode"/>
										</xsl:with-param>
									</xsl:call-template>
								</CprodNo> --><!--��Ʒ���� -->
								<CprodNo><xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskCode"/></CprodNo>
								<CProdNme><xsl:value-of select ="Risk[RiskCode=MainRiskCode]/RiskName"/></CProdNme><!--��Ʒ���� -->
							</xsl:otherwise>
						</xsl:choose>
						<CCvrgNo></CCvrgNo><!--�ձ���� -->
						<CCustCvrgNme></CCustCvrgNme><!--�ձ����� -->
						<CAppNme><xsl:value-of select ="Appnt/Name"/></CAppNme><!--Ͷ�������� -->
						<CAppMobile><xsl:value-of select ="Appnt/Mobile"/></CAppMobile><!--Ͷ�����ֻ����� -->
						<CAppClntAddr><xsl:value-of select ="Appnt/Address"/></CAppClntAddr><!--Ͷ����ͨѶ��ַ -->
						<CInsuredNme><xsl:value-of select ="Insured/Name"/></CInsuredNme><!--���������� -->
						<CInsuredCertfCls><xsl:apply-templates select ="Insured/IDType"/></CInsuredCertfCls><!--������֤������ -->
						<CInsuredCertfCde><xsl:value-of select ="Insured/IDNo"/></CInsuredCertfCde><!--������֤������ -->
						<CInsuredMobile><xsl:value-of select ="Insured/Mobile"/></CInsuredMobile><!--�����˵绰 -->
						<BeneficiaryList>
							<xsl:for-each select="Bnf">
								 <BeneficiaryInfo>
								 	<CBnfcNme><xsl:value-of select ="Name"/></CBnfcNme><!--���������� -->
									<CBnfcCertfCls><xsl:apply-templates select ="IDType"/></CBnfcCertfCls><!--������֤������ -->
									<CBnfcCertfCde><xsl:value-of select ="IDNo"/></CBnfcCertfCde><!--������֤������ -->
								 </BeneficiaryInfo>
							</xsl:for-each>
						</BeneficiaryList>
						<InsurCorpNo>14226510</InsurCorpNo><!--���չ�˾��� -->
						<CInsurType>02</CInsurType><!--���չ�˾���� -->
					</Detail>
				</xsl:for-each>
			</DetailList>
	</TransBody>
</xsl:template>
<!-- ������Ѻ״̬�� 0δ��Ѻ��1��Ѻ -->
<xsl:template match="MortStatu">
	<xsl:choose>
		<xsl:when test=".='0'">2</xsl:when><!--	���� -->
		<xsl:when test=".='1'">1</xsl:when><!--	����Ѻ�����ᣩ -->
	</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<!-- ��ʹ���к���˾���ִ�����ͬҲҪת����Ϊ������ĳ������ֻ���������� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122006">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122008">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=50015">50002</xsl:when>	<!-- �������Ӯ1����ȫ������� -->
	<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12078'">L12078</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 
	<xsl:when test="$riskcode=50012">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
	<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ֤�����ͣ�����**���� -->
<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".='0'">0</xsl:when><!--�������֤**���֤ -->
		<xsl:when test=".='1'">2</xsl:when><!--����**����-->
		<xsl:when test=".='2'">3</xsl:when><!--����֤**����֤ -->
		<xsl:when test=".='3'">X</xsl:when><!--����**��������֤�� -->
		<xsl:when test=".='4'">X</xsl:when><!--����֤��**��������֤�� -->
		<xsl:when test=".='5'">1</xsl:when><!--���ڲ�**���ڲ� -->
		<xsl:when test=".='6'">5</xsl:when><!--�۰ľ��������ڵ�ͨ��֤**�۰ľ��������ڵ�ͨ��֤-->
		<xsl:when test=".='7'">6</xsl:when><!--̨�����������½ͨ��֤**̨�����������½ͨ��֤-->
		<xsl:when test=".='8'">X</xsl:when><!--����**��������֤�� -->
		<xsl:when test=".='9'">X</xsl:when><!--�쳣���֤**��������֤�� -->
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>