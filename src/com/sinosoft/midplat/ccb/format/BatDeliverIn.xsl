<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
 <TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
		<xsl:apply-templates select="Transaction/Transaction_Body" />
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="Transaction_Header">
<Head>
	<TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	<TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
	<TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	<NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	<xsl:copy-of select="../Head/*"/>
</Head>
</xsl:template>

<xsl:template name="Body" match="Transaction_Body">
	<xsl:variable name="DealType" select="substring(BkFileName, 3, 1)" />
    <DealType>
		<xsl:call-template name="tran_type">
			<xsl:with-param name="type">
				<xsl:value-of select="$DealType" />
			</xsl:with-param>
		</xsl:call-template>
	</DealType><!-- 处理类型  S-代收  F-代付-->
	<FileName><xsl:value-of select="BkFileName"/></FileName><!-- 建行批量包名称 -->
	<DealFlag><xsl:value-of select="BkFlag1"/></DealFlag><!--本包处理状态-->
	<Success>
		<Count><xsl:value-of select="count(Detail_List/Detail[BkRetCode = 00000])"/></Count> <!-- 成功总笔数 -->
		<Amount><xsl:value-of select="sum(Detail_List/Detail[BkRetCode = 00000]/BkAmt1)"/></Amount> <!-- 成功总金额(元) -->
	</Success>
	<Fail>
		<Count><xsl:value-of select="count(Detail_List/Detail[BkRetCode != 00000])"/></Count> <!-- 失败总笔数 -->
		<Amount><xsl:value-of select="sum(Detail_List/Detail[BkRetCode != 00000]/BkAmt1)"/></Amount> <!-- 失败总金额(元) -->
	</Fail>
	
	<DetailList>
		<xsl:for-each select="Detail_List/Detail">
			<Detail>
		    	<DetailSerialNo><xsl:value-of select="BkOthRetSeq"/></DetailSerialNo> <!-- 明细数据序列号 -->
				<AccNo><xsl:value-of select="BkAcctNo"/></AccNo> <!-- 银行账户 -->
				<AccName><xsl:value-of select="BkCustName"/></AccName> <!-- 账户姓名 -->
				<Amount><xsl:value-of select="BkAmt1"/></Amount> <!-- 金额(元) -->
				<BusiType>
					<xsl:call-template name="tran_busitype">
						<xsl:with-param name="busitype">
							<xsl:value-of select="LiOperType"/>
						</xsl:with-param>
						<xsl:with-param name="flag">
							<xsl:value-of select="$DealType"/>
						</xsl:with-param>
					</xsl:call-template>
				</BusiType> <!-- 业务类型 -->
				<ContNo><xsl:value-of select="PbInsuSlipNo"/></ContNo> <!-- 保险单号 -->
				<ProposalPrtNo><xsl:value-of select="PbRemark2"/></ProposalPrtNo> <!-- 投保单(印刷)号 -->
				<RCode><xsl:apply-templates select="BkRetCode" /></RCode> <!-- 响应码 -->
				<RText><xsl:value-of select="BkRetMsg"/></RText> <!-- 响应描述 -->
			</Detail>
		</xsl:for-each>
	</DetailList>
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
			<xsl:if test="$busitype='01'">7</xsl:if>
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