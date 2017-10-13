<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<!-- ������ -->
			<Body>
				<!-- �ɹ�������Լ���� -->
				<Count>
					<xsl:value-of
						select="count(//Detail[LineNum !='0'])" />
				</Count>
				<!-- �ܱ��ѣ��֣� -->
				<Prem>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[LineNum !='0']/Column[23]))" />
				</Prem>
				<!-- ȥ�����У�����Ϊ������ -->
				<xsl:for-each
					select="//Detail[LineNum !='0']">
					<Detail>
						<!--  �������ڣ�YYYYMMDD�� -->
						<TranDate>
							<xsl:value-of select="Column[5]" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="Column[3]" /><xsl:value-of select="Column[4]" />
						</NodeNo>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="Column[8]" />
						</TranNo>
						<!--  ���պ�ͬ��/������  -->
						<ContNo>
							<xsl:value-of select="Column[14]" />
						</ContNo>
						<!--  ����ʵ�ս�� -->
						<Prem>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[23])" />
						</Prem>
						<SourceType>
							<xsl:call-template name="tran_sourceType">
								<xsl:with-param name="sourceType" select="Column[24]" />
							</xsl:call-template>
						</SourceType>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	<!-- ���� -->
	<xsl:template name="tran_sourceType">
		<xsl:param name="sourceType" />
		<xsl:choose>
			<xsl:when test="$sourceType='00'">0</xsl:when> <!-- ���� -->
			<xsl:when test="$sourceType='21'">1</xsl:when> <!-- ���� -->
			<xsl:when test="$sourceType='51'">17</xsl:when> <!-- �ֻ����� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>