<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="InsuReq">
		<TranData>
			<xsl:apply-templates select="Main" />
			<Body>
				<!-- Ͷ����(ӡˢ)�� -->
				<ProposalPrtNo>
					<xsl:value-of select="Main/ApplyNo" />
				</ProposalPrtNo>
				<!-- ������ͬӡˢ�� -->
				<ContPrtNo>
					<xsl:value-of select="Main/PrintNo" />
				</ContPrtNo>
				<!-- Ͷ���� -->
				<Appnt>
					<xsl:apply-templates select="Appnt" />
				</Appnt>
			</Body>
		</TranData>
	</xsl:template>
	<!-- Ͷ������Ϣ -->
	<xsl:template name="Appnt" match="Appnt">
		<!-- ֤������ -->
		<IDType>
			<xsl:apply-templates select="IDType" />
		</IDType>
		<!-- ֤������ -->
		<IDNo>
			<xsl:value-of select="IDNo" />
		</IDNo>
	</xsl:template>
	<!-- ����ͷ��Ϣ -->
	<xsl:template name="Head" match="Main">
		<Head>
			<!-- ��������[yyyyMMdd] -->
			<TranDate>
				<xsl:value-of select="TranDate" />
			</TranDate>
			<!-- ����ʱ��[hhmmss] -->
			<TranTime>
				<xsl:value-of select="TranTime" />
			</TranTime>
			<!-- ��Ա���� -->
			<TellerNo>
				<xsl:value-of select="TellerNo" />
			</TellerNo>
			<!-- ������ˮ�� -->
			<TranNo>
				<xsl:value-of select="TransNo" />
			</TranNo>
			<!-- ������+������ -->
			<NodeNo>
				<xsl:value-of select="ZoneNo" />
				<xsl:value-of select="BrNo" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>

	<!-- ֤������-->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".=01">0</xsl:when><!-- �������֤ -->
			<xsl:when test=".=02">0</xsl:when><!-- ��ʱ���֤ -->
			<xsl:when test=".=03">1</xsl:when><!-- ���� -->
			<xsl:when test=".=04">5</xsl:when><!-- ���ڲ� -->
			<xsl:when test=".=05">2</xsl:when><!-- �������֤ -->
			<xsl:when test=".=06">2</xsl:when><!-- ��װ�������֤  -->
			<xsl:when test=".=08">8</xsl:when><!-- �⽻��Ա���֤ -->
			<xsl:when test=".=09">8</xsl:when><!-- ����˾������֤-->
			<xsl:when test=".=10">8</xsl:when><!-- ������뾳ͨ��֤�� -->
			<xsl:when test=".=11">8</xsl:when><!-- ���� -->
			<xsl:when test=".=47">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤����ۣ� -->
			<xsl:when test=".=48">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤�����ţ� -->
			<xsl:when test=".=49">7</xsl:when><!-- ̨�����������½ͨ��֤ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>