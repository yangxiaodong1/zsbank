<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<Body>
				<!--������Ϣ-->
				<Detail>
					<!--��˾����-->
					<Column>0032</Column>
					<!--���д���-->
					<Column>17</Column>
					<!--�ܱ���-->
					<Column>
						<xsl:value-of select="count(TranData/Body/Detail)" />
					</Column>
					<!--�ܽ��-->
					<Column>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(TranData/Body/Detail/ActPrem))" />
					</Column>
				</Detail>
				<xsl:for-each select="TranData/Body/Detail">
					<Detail>
						<!--��Ʒ����-->
						<Column>
							<xsl:call-template name="tran_RiskCode">
								<xsl:with-param name="riskCode">
									<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskCode" />
								</xsl:with-param>
							</xsl:call-template>
						</Column>
						<!--Ͷ������-->
						<Column>
							<xsl:value-of select="ProposalPrtNo" />
						</Column>
						<!--Ͷ����֤������-->
						<Column>
							<xsl:value-of select="Appnt/IDNo" />
						</Column>
						<!--��Ч����-->
						<Column>
							<xsl:value-of select="ValiDate" />
						</Column>
						<!--����״̬-->
						<Column>
							<xsl:value-of select="ContState" />
						</Column>
						<!--�˱���Ϣ-->
						<Column>
							<xsl:value-of select="UWReasonContent" />
						</Column>
						<!--������-->
						<Column>
							<xsl:value-of select="ContNo" />
						</Column>
						<!--���շ���-->
						<Column>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
						</Column>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>
	<!-- ���ִ��� -->
	<xsl:template name="tran_RiskCode">
		<xsl:param name="riskCode" />
		<xsl:choose>
			<xsl:when test="$riskCode='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
			<!-- �����ڣ��������ֱ��벢�������� -->
			<xsl:when test="$riskCode='122010'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskCode='L12078'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskCode='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskCode='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
			<!-- 50002��Ϊ50015�������б���û�䣬�Һ��ĵ����ߴ���û�б仯�����Դ˴β����޸ġ� -->
			<xsl:when test="$riskCode='122046'">50002</xsl:when><!-- �������Ӯ������ϼƻ� -->
			
			<xsl:when test="$riskCode='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ� -->
			<xsl:when test="$riskCode='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ� -->
			<xsl:when test="$riskCode='L12088'">L12088</xsl:when><!-- �����9����ȫ���գ������ͣ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
