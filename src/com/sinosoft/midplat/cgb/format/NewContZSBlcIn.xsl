<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/DAYCHECK">
		<TranData>
			<!-- ������ -->
			<Body>
				<!-- �ɹ�������Լ���� -->
				<Count>
					<xsl:value-of
						select="sum(//DAYCHECK_TOTS/DAYCHECK_TOT/TOT_PIECE)" />
				</Count>
				<!-- �ܱ��ѣ��֣� -->
				<Prem>
					<xsl:value-of
						select="sum(//DAYCHECK_TOTS/DAYCHECK_TOT/TOT_PREMIUM)" />
				</Prem>
				<xsl:for-each
					select="//DAYCHECK_DETAILS/DAYCHECK_DETAIL">
					<Detail>
						<!--  �������ڣ�YYYYMMDD�� -->
						<TranDate>
							<xsl:value-of select="java:com.sinosoft.midplat.cgb.format.Cgb_TransForm.get8Date(OREVDATE)" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="concat(Column[3], Column[4])" />
						</NodeNo>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="TRANSRNO" />
						</TranNo>
						<!--  ���պ�ͬ��/������  -->
						<ContNo>
							<xsl:value-of select="INSURNO" />
						</ContNo>
						<!--  ����ʵ�ս�� -->
						<Prem>
							<xsl:value-of select="PREMIUM" />
						</Prem>						
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>

</xsl:stylesheet>