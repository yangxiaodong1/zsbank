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
						select="count(//Detail)" />
				</Count>
				<!-- �ܱ��ѣ��֣� -->
				<Prem>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail/Column[8]))" />
				</Prem>
				<xsl:for-each
					select="//Detail">
					<!-- �����ļ���ʽ�����б�ţ�����24�����������ڣ�YYYYMMDD���������ţ�5λ��������ţ�5λ�������ʽ����루�̶�0001��
					                +�µ��б�������ˮ�ţ�20λ���������ţ�20λ������12λ����С���㣬��ԪΪ��λ��2λС����������������2λ�� -->
					<Detail>
						<!--  �������ڣ�YYYYMMDD�� -->
						<TranDate>
							<xsl:value-of select="Column[2]" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="Column[4]" />
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
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>

</xsl:stylesheet>