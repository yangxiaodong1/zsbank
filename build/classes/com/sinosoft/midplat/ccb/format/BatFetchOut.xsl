<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<Transaction_Body>
		<xsl:apply-templates select="TranData/Body" />
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
	<PbOperSuccNum><xsl:value-of select="Count" /></PbOperSuccNum><!-- 当前批明细总笔数 -->
	<PbOperSuccSum><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amount*100)" /></PbOperSuccSum><!-- 当前批明细总金额 -->
    <PbPackType></PbPackType><!-- 批量业务包类型 -->
	<Detail_List>
		<xsl:for-each select="DetailList/Detail">
			<Detail>
				<BkCustName><xsl:value-of select="AccName" /></BkCustName><!-- 客户姓名 -->
				<BkAcctNo><xsl:value-of select="AccNo" /></BkAcctNo><!-- 帐号 -->
				<BkOthRetSeq><xsl:value-of select="DetailSerialNo" /></BkOthRetSeq><!-- 保险公司方明细序号 -->
				<LiOperType>
					<xsl:call-template name="tran_busitype">
						<xsl:with-param name="busitype">
							<xsl:value-of select="BusiType"/>
						</xsl:with-param>
						<xsl:with-param name="flag">
							<xsl:value-of select="SFFlag"/>
						</xsl:with-param>
					</xsl:call-template>
				</LiOperType><!-- 业务类型 -->
				<PbInsuSlipNo><xsl:value-of select="ContNo" /></PbInsuSlipNo><!-- 保单号 -->
				<BkAmt1><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amount*100)" /></BkAmt1><!-- 金额 -->
				<PbRemark1></PbRemark1><!-- 集团、股份标志 -->
				<PbRemark2><xsl:value-of select="ProposalPrtNo" /></PbRemark2><!-- 投保单号 -->
				<PbRemark3></PbRemark3>
			</Detail>
		</xsl:for-each>
	</Detail_List>
</xsl:template>

<xsl:template name="tran_busitype">
	<xsl:param name="busitype" />
	<xsl:param name="flag" />
	<xsl:choose>
		<xsl:when test="$flag='S'">
			<xsl:if test="$busitype='7'">01</xsl:if>
			<xsl:if test="$busitype='3'">02</xsl:if>
			<xsl:if test="$busitype='6'">98</xsl:if>
			<xsl:if test="$busitype='4'">98</xsl:if>
			<xsl:if test="$busitype='2'">98</xsl:if>
			<xsl:if test="$busitype='10'">98</xsl:if>
			<xsl:if test="$busitype='01'">98</xsl:if>
			<xsl:if test="$busitype='02'">98</xsl:if>
			<xsl:if test="$busitype='03'">98</xsl:if>
			<xsl:if test="$busitype='9'">98</xsl:if>
			<xsl:if test="$busitype='5'">98</xsl:if>
		</xsl:when>
		<xsl:when test="$flag='F'">
			<xsl:if test="$busitype=10">14</xsl:if>
			<xsl:if test="$busitype=5">12</xsl:if>
			<xsl:if test="$busitype=4">99</xsl:if>
			<xsl:if test="$busitype=2">99</xsl:if>
			<xsl:if test="$busitype=8">99</xsl:if>
			<xsl:if test="$busitype=3">99</xsl:if>
			<xsl:if test="$busitype=9">99</xsl:if>
		</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
