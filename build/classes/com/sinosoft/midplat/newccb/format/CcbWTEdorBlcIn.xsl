<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

<xsl:template match="/">
	<!-- ����Լ���� -->
	<TranData>
		<!-- ����ͷ -->
		<Head>
			<xsl:copy-of select="TranData/Head/*" />
		</Head>
		<Body>
			<PubContInfo>
				<!-- ���� -->
				<EdorFlag>8</EdorFlag>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<CTBlcType>0</CTBlcType>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<xsl:if test="count(//DetailList/Detail[ORG_TX_ID='P53819144']) &gt; 0">
					<WTBlcType>1</WTBlcType>
				</xsl:if>
				<xsl:if test="count(//DetailList/Detail[ORG_TX_ID='P53819144']) = 0 ">
					<WTBlcType>0</WTBlcType>
				</xsl:if>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<MQBlcType>0</MQBlcType>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<XQBlcType>0</XQBlcType>
				<!-- ���ˣ�1=���ˣ�0=������ -->
				<CABlcType>0</CABlcType>
			</PubContInfo>
			
			<!-- ֻӳ����ԥ���˱��ı��� -->
			<xsl:apply-templates select="(//DetailList/Detail[ORG_TX_ID='P53819144'])"/>
		</Body>
	</TranData>
</xsl:template>

<xsl:template name="Body" match="Detail">
	<Detail>
		<TranNo><xsl:value-of select="RqPtTcNum"/></TranNo>
		<BankCode><xsl:value-of select="CCBIns_ID" /></BankCode>
		<EdorType>
			<xsl:call-template name="tran_EdorType">
				<xsl:with-param name="edorType" select="ORG_TX_ID" />
			</xsl:call-template>
		</EdorType>
		<EdorAppNo><xsl:value-of select="InsPolcy_Vchr_No" /></EdorAppNo>
		<EdorNo></EdorNo>
		<!-- 
		<EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Txn_Dt)"/></EdorAppDate>
		 -->
		<EdorAppDate><xsl:value-of select="Txn_Dt"/></EdorAppDate>
		<ContNo><xsl:value-of select="InsPolcy_No"/></ContNo>
		<RiskCode></RiskCode>
		<TranMoney>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TxnAmt)"/>
		</TranMoney>
		<AccNo></AccNo>
		<AccName></AccName>
		<!-- ��Ӧ�� 0�ɹ���1ʧ�� -->
		<RCode>0</RCode>
	</Detail>
</xsl:template>

<!-- ֤������ת�� -->
<xsl:template name="tran_EdorType">
	<xsl:param name="edorType" />
	<xsl:choose>
		<xsl:when test="$edorType='P53819144'">WT</xsl:when>	<!-- ��ԥ���˱�(���в���ҵ�����ͣ��˴�ͨ�����еĽ��������ӳ��ת��) -->
		<xsl:otherwise></xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>