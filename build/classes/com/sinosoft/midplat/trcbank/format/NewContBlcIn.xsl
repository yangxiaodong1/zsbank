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
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[LineNum !='0']/Column[5]))" />
				</Prem>
				<!-- ȥ�����У�����Ϊ������ -->
				<!-- �����ţ�20λ��|������ˮ�ţ�16λ��|�������ڣ�8λ��|����ʱ�䣨6λ��|���׽���С���㾫ȷ����16λ��|�������루6λ��|������루4λ��|��ע��100λ��| -->
				<xsl:for-each
					select="//Detail[LineNum !='0']">
					<Detail>
						<!--  �������ڣ�YYYYMMDD�� -->
						<TranDate>
							<xsl:value-of select="Column[3]" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="Column[6]" /><xsl:value-of select="Column[7]" />
						</NodeNo>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="Column[2]" />
						</TranNo>
						<!--  ���պ�ͬ��/������  -->
						<ContNo>
							<xsl:value-of select="Column[1]" />
						</ContNo>
						<!--  ����ʵ�ս�� -->
						<Prem>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[5])" />
						</Prem>						
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	
</xsl:stylesheet>