<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<xsl:if test="TranData/Head/Flag='0'">
					<xsl:apply-templates select="TranData/Body" />
				</xsl:if>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLife" match="Body">
		<OLife>
			<Holding id="Holding_1">
				<!-- ������Ϣ -->
				<Policy>
					<!-- ������ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!-- ����״̬ -->
					<PolicyStatus><xsl:apply-templates select="ContState" /></PolicyStatus>
					<!-- ��ǰ������ֵ��13λ����2λС�����������ͣ�����Ϊ�գ� -->
					<PolicyValue><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueD)" /></PolicyValue>
					<Life>
						<!-- �����ձ��뷵�أ�Ͷ���ղ����뷵�� -->
						<xsl:choose>
							<xsl:when test="Life/CurrIntRate!=''">
								<xsl:variable name="Rate" select="number(Life/CurrIntRate)" />
								<CurrIntRate><xsl:value-of select="format-number($Rate*100, '#.0000')" /></CurrIntRate>
							</xsl:when>
							<xsl:otherwise>
								<CurrIntRate>0</CurrIntRate>
							</xsl:otherwise>
						</xsl:choose>
						<!-- ��ǰ�������ʣ���λ�����֮��С�������λ�� -->
						<xsl:choose>
							<xsl:when test="Life/CurrIntRateDate!=''">
								<CurrIntRateDate><xsl:apply-templates select="Life/CurrIntRateDate" /></CurrIntRateDate>
							</xsl:when>
							<xsl:otherwise>
								<CurrIntRateDate>0</CurrIntRateDate>
							</xsl:otherwise>
						</xsl:choose>
						<!-- ���ʿ�ʼ���� ��8λ���ָ�ʽYYYYMMDD������Ϊ�գ�-->
					</Life>
					<!-- Ͷ���ձ��뷵�أ������ղ����뷵�� -->
					<!-- <Investment></Investment>  -->
				</Policy>
			</Holding>
		</OLife>
	</xsl:template>

	<!-- ����״̬ -->
	<!-- ����״̬����״̬A:������C:�˱���R:�ܱ���S:��ԥ�ڳ�����F�����ڸ�����L��ʧЧ��J������  -->
	<!-- ����״̬��00:������Ч,01:������ֹ,02:�˱���ֹ,04:������ֹ,WT:��ԥ���˱���ֹ,A:�ܱ�,B:��ǩ��,C:ʧЧ -->
	<xsl:template name="tran_contstate" match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">A</xsl:when>
			<xsl:when test=".='01'">F</xsl:when>
			<xsl:when test=".='02'">C</xsl:when>
			<xsl:when test=".='04'">J</xsl:when>
			<xsl:when test=".='WT'">S</xsl:when>
			<xsl:when test=".='A'">R</xsl:when>
			<xsl:when test=".='C'">L</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
