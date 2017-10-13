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
					<xsl:value-of select="count(//Detail[Column[9]='P'])" />
				</Count>
				<!-- �ܱ��ѣ��֣� -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[Column[9]='P']/Column[7]))" />
				</Prem>
				<xsl:for-each select="//Detail[Column[9]='P']">
					<!-- �����ļ���ʽ�����б�ţ�����24�����������ڣ�YYYYMMDD�������д��루4λ�������׻�����4λ��
					 + �µ��б�������ˮ�ţ�20λ���������ţ�20λ������12λ����С���㣬��ԪΪ��λ��2λС����������������2λ��+ ����״̬(��������P��������R0) -->
					<Detail>
						<!--  �������ڣ�YYYYMMDD�� -->
						<TranDate>
							<xsl:value-of select="Column[2]" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="Column[3]" /><xsl:value-of select="Column[4]" />
						</NodeNo>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="Column[5]" />
						</TranNo>
						<!--  ���պ�ͬ��/������  -->
						<ContNo>
							<xsl:value-of select="Column[6]" />
						</ContNo>
						<!--  ����ʵ�ս�� -->
						<Prem>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[7])" />
						</Prem>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>

</xsl:stylesheet>