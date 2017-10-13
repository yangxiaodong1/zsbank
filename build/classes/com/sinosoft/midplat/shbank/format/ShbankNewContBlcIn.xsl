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
						select="count(CHECKALL/CHECK/DTLS/DTL[PROCSTS = '1'])" />
				</Count>
				<!-- �ܱ��ѣ��֣� -->
				<Prem>
					<xsl:value-of
						select="sum(CHECKALL/CHECK/DTLS/DTL[PROCSTS = '1']/INSU_IN)" />
				</Prem>
				<xsl:for-each select="CHECKALL/CHECK/DTLS/DTL[PROCSTS = '1']">
					<Detail>
						<!--  �������ڣ�YYYYMMDD�� -->
						<TranDate>
							<xsl:value-of select="TRSDATE" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="ZONE" /><xsl:value-of select="DEPT" />
						</NodeNo>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="TRANS" />
						</TranNo>
						<!--  ���պ�ͬ��/������  -->
						<ContNo>
						    <xsl:value-of select="java:com.sinosoft.midplat.shbank.format.Shbank_TransForm.proPosalNOToPolicyNO(APPNO)" />
						</ContNo>
						<!--  ����ʵ�ս�� -->
						<Prem>
							<xsl:value-of select="INSU_IN" />
						</Prem>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>

</xsl:stylesheet>