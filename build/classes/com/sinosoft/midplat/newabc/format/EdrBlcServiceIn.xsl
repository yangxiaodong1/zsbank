<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="Head" />
			<Body>
				<xsl:variable name="bankCode"><xsl:value-of select="Body/Detail[LineNum=0]/Column[2]" /></xsl:variable>
				<PubContInfo>
					<EdorFlag>8</EdorFlag>
					<XQBlcType>0</XQBlcType>
					<WTBlcType>
						<xsl:choose>
							<xsl:when test="Body/Detail[LineNum=0 and Column[5]>0]">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</WTBlcType>
					<MQBlcType>
						<xsl:choose>
							<xsl:when test="Body/Detail[LineNum=0 and Column[7]>0]">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</MQBlcType>
					<CTBlcType>
						<xsl:choose>
							<xsl:when test="Body/Detail[LineNum=0 and Column[9]>0]">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</CTBlcType>
				</PubContInfo>
				<xsl:for-each select="Body/Detail[LineNum > 0]">
					<Detail>
						<!--  ������ˮ��-->
						<TranNo />
						<!-- ���б��� -->
						<BankCode>
							<xsl:value-of select="$bankCode" />
						</BankCode>
						<!--  ����������ˮ��  -->
						<EdorType>
							<xsl:call-template name="EdorType">
								<xsl:with-param name="edorType" select="Column[2]" />
							</xsl:call-template>
						</EdorType>
						<EdorAppNo />
						<EdorNo />
						<EdorAppDate>
							<xsl:value-of select="Column[3]" />
						</EdorAppDate>
						<ContNo>
							<xsl:value-of select="Column[4]" />
						</ContNo>
						<!-- Ͷ���˺��� -->
						<RiskCode />
						<!-- ����������Ԥ���� -->
						<TranMoney>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[13])" />
						</TranMoney>
						<AccNo />
						<AccName />
						<!-- ��Ӧ�� 0�ɹ���1ʧ��-->
						<RCode>
							<xsl:call-template name="RCode">
								<xsl:with-param name="rCode" select="Column[9]" />
							</xsl:call-template>
						</RCode>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="EdorType">
		<xsl:param name="edorType" />
		<xsl:choose>
			<xsl:when test="$edorType='01'">WT</xsl:when><!--����-->
			<xsl:when test="$edorType='02'">MQ</xsl:when><!--����-->
			<xsl:when test="$edorType='03'">CT</xsl:when><!--�˱�-->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="RCode">
		<xsl:param name="rCode" />
		<xsl:choose>
			<xsl:when test="$rCode='0'">0</xsl:when><!--����ɹ�-->
			<xsl:when test="$rCode='1'">1</xsl:when><!--����ʧ��-->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>