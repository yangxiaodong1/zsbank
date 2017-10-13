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
						select="count(//Detail[Column[5]='1013'])" />
				</Count>
				<!-- �ܱ��ѣ��֣� -->
				<Prem>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[Column[5]='1013']/Column[8]))" />
				</Prem>
				<xsl:for-each
					select="//Detail[Column[5]='1013']">
					<!-- �����ļ���ʽ�� ���б�ţ�10λ���� �������ڣ�10λ����������루10λ����������루10λ�������˽����루4λ��
					      �� Ӧ�������н�����ˮ�ţ�30λ���������ţ�20λ������12λ����С���㣩������������2λ�� -->
					<Detail>
						<!--  �������ڣ�YYYYMMDD�� -->
						<TranDate>
							<xsl:value-of select="Column[2]" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="concat(Column[3], Column[4])" />
						</NodeNo>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="Column[6]" />
						</TranNo>
						<!--  ���պ�ͬ��/������  -->
						<ContNo>
							<xsl:value-of select="Column[7]" />
						</ContNo>
						<!--  ����ʵ�ս�� -->
						<Prem>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[8])" />
						</Prem>
						<!--  ���ģ�����������0-���棬1-������8�����նˣ�Ŀǰ���������֣�����������δ���֣� -->
						<!-- ���У�����������ö��ֵ��0-���� 1-���� -->
						<SourceType>
							<xsl:call-template name="tran_sourceType">
								<xsl:with-param name="sourceType" select="Column[9]" />
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
			<xsl:when test="$sourceType='005'">0</xsl:when> <!-- ���� -->
			<xsl:when test="$sourceType='010'">1</xsl:when> <!-- ���� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>