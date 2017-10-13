<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<xsl:apply-templates select="//Detail" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template match="Detail">
		<!-- ��������  S-����  F-���� -->
		<DealType>F</DealType>
		<FileName>
			<xsl:value-of select="FileName" />
		</FileName>
		<!--��������״̬-->
		<DealFlag>
			<xsl:value-of select="DealFlag" />
		</DealFlag>
		<Success>
			<Count>
				<xsl:value-of select="Success/Count" />
			</Count><!-- �ɹ��ܱ��� -->
			<Amount>
				<xsl:value-of select="Success/Amount" />
			</Amount><!-- �ɹ��ܽ�� -->
		</Success>
		<Fail>
			<Count>
				<xsl:value-of select="Fail/Count" />
			</Count><!-- ʧ���ܱ��� -->
			<Amount>
				<xsl:value-of select="Fail/Amount" />
			</Amount><!-- ʧ���ܽ�� -->
		</Fail>

		<DetailList>
			<xsl:apply-templates select="DetailList/Detail" />
		</DetailList>
	</xsl:template>

	<xsl:template match="DetailList/Detail">
		<Detail>
			<!-- ��ϸ�������к� -->
			<DetailSerialNo>
				<xsl:value-of select="DetailSerialNo" />
			</DetailSerialNo>
			<!-- �����˻� -->
			<AccNo>
				<xsl:value-of select="AccNo" />
			</AccNo>
			<!-- �˻����� -->
			<AccName>
				<xsl:value-of select="AccName" />
			</AccName>
			<!-- ���(Ԫ) -->
			<Amount>
				<xsl:value-of select="Amount" />
			</Amount>
			<!-- ҵ������ -->
			<BusiType></BusiType>
			<!-- ���յ��� -->
			<ContNo>
				<xsl:value-of select="ContNo" />
			</ContNo>
			<!-- Ͷ����(ӡˢ)�� -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo" />
			</ProposalPrtNo>
			<!-- ��Ӧ�� -->
			<RCode>
				<xsl:apply-templates select="RCode" />
			</RCode>
			<!-- ��Ӧ���� -->
			<RText>
				<xsl:value-of select="RText" />
			</RText>
		</Detail>
	</xsl:template>

	<xsl:template name="tran_type">
		<xsl:param name="type" />
		<xsl:choose>
			<xsl:when test="$type = 0">S</xsl:when>
			<xsl:when test="$type = 1">F</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="tran_busitype">
		<xsl:param name="busitype" />
		<xsl:param name="flag" />
		<xsl:choose>
			<xsl:when test="$flag=0">
				<xsl:if test="$busitype='01'">11</xsl:if>
				<xsl:if test="$busitype='02'">3</xsl:if>
				<xsl:if test="$busitype='98'">10</xsl:if>
			</xsl:when>
			<xsl:when test="$flag=1">
				<xsl:if test="$busitype='11'">2</xsl:if>
				<xsl:if test="$busitype='12'">5</xsl:if>
				<xsl:if test="$busitype='13'">10</xsl:if>
				<xsl:if test="$busitype='14'">10</xsl:if>
				<xsl:if test="$busitype='99'">10</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="BkRetCode">
		<xsl:choose>
			<xsl:when test=".=00000">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>