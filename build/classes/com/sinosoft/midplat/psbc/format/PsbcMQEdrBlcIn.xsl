<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="TranData">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*" />
			</Head>
			<Body>
			    <PubContInfo>
				<!-- ���� -->
				<EdorFlag>8</EdorFlag>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<CTBlcType>0</CTBlcType>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<WTBlcType>0</WTBlcType>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<xsl:if test="count(Body/Detail[FuncFlag='583011']) &gt; 0">
					<MQBlcType>1</MQBlcType>
				</xsl:if>
				<xsl:if test="count(Body/Detail[FuncFlag='583011']) = 0 ">
					<MQBlcType>0</MQBlcType>
				</xsl:if>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<XQBlcType>0</XQBlcType>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<CABlcType>0</CABlcType>
			</PubContInfo>
			<!-- ֻӳ�����ڵı��� -->
			<xsl:apply-templates select="(Body/Detail[FuncFlag='583011'])"/>
		   </Body>
		</TranData>
	</xsl:template>
    <xsl:template name="Body" match="Detail">
	    <Detail>
		   <TranNo><xsl:value-of select="TranNo"/></TranNo>
		   <BankCode></BankCode>
		   <EdorType>MQ</EdorType>
		   <EdorAppNo></EdorAppNo>
		   <EdorNo></EdorNo>
		   <!-- 
		   <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Txn_Dt)"/></EdorAppDate>
		   -->
		   <EdorAppDate><xsl:value-of select="TranDate"/></EdorAppDate>
		   <ContNo><xsl:value-of select="ContNo"/></ContNo>
		   <RiskCode></RiskCode>
		   <TranMoney />
		   <AccNo></AccNo>
		   <AccName></AccName>
		   <!-- ��Ӧ�� 0�ɹ���1ʧ�� -->
		   <RCode>0</RCode>
	    </Detail>
    </xsl:template>
    <!-- �������� -->
	<xsl:template match="SOURCETYPE">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>