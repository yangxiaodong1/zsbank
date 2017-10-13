<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<Count>
					<xsl:value-of select="count(//Detail[position() > 1])" />
				</Count>
				<xsl:for-each select="//Detail[position() > 1]">
					<Detail>
						<!--  �������ڣ�8λ���ָ�ʽYYYYMMDD������Ϊ�գ� -->
						<TranDate>
							<xsl:value-of select="Column[1]" />
						</TranDate>
						<!--  �����������  (ʡ�д���+������)-->
						<NodeNo>
							<xsl:value-of select="Column[4]" />
						</NodeNo>
						<!--  ����������ˮ��  -->
						<TranNo>
							<xsl:value-of select="Column[3]" />
						</TranNo>
						<!--  Ͷ������  -->
						<ProposalPrtNo>
							<xsl:value-of select="Column[7]" />
						</ProposalPrtNo>
						<!-- ���ڱ����˻� -->
						<AccNo>
							<xsl:value-of select="Column[5]" />
						</AccNo>
						<!-- Ͷ�������� -->
						<AppntName>
							<xsl:value-of select="Column[9]" />
						</AppntName>
						<!-- Ͷ����֤������ -->
						<AppntIDType></AppntIDType>
						<!-- ֤������ -->
						<AppntIDNo></AppntIDNo>
						<!-- ����������Ԥ���� -->
						<SourceType>0</SourceType>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>