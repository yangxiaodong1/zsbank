<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/DOCUMENT">
		<TranData>
			<!-- ������ -->
			<Body>
				<!-- �ɹ�������Լ���� -->
				<Count>
					<xsl:value-of select="HEAD/TRANSCOUNTS" />
				</Count>
				<!-- �ܱ��ѣ����е�λ��Ԫ�����ĵ�λ���� -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(HEAD/TRANSAMOUNTS)" />
				</Prem>
				<xsl:for-each select="BODY/DETAIL">
					<Detail>
						<!--  �������ڣ�YYYYMMDD�� -->
						<TranDate>
							<xsl:value-of select="TRANSACTIONDATE" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="ZONENO"/><xsl:value-of select="BRANCHCODE"/>
						</NodeNo>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="APPTRANSRNO"/>
						</TranNo>
						<!--  ���պ�ͬ��/������  -->
						<ContNo>
							<xsl:value-of select="INSURNO" />
						</ContNo>
						<!--  ����ʵ�ս�� -->
						<Prem>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIUM)" />
						</Prem>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>