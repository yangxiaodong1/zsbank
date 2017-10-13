<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="TranData/Head" />
			<!-- 报文体 -->
			<xsl:apply-templates select="TranData/Body" />
			
		</TranData>
	</xsl:template>

	<!-- 报文体 -->
	<xsl:template match="Body">
		<Body>
			<Detail>
				<!--保险公司代码-->
				<Column>0026</Column>
				<!--银行代码-->
				<Column>0501</Column>
				<!--总记录数-->
                <Column><xsl:value-of select="count(DetailList/Detail)" /></Column>
                <!--总金额-->
                <Column><xsl:value-of select="Amount" /></Column>
                <!--交易摘要-->
                <Column></Column>
             </Detail>
             
             <xsl:apply-templates select="Detail" />
             </Body>
             </xsl:template>
             
    <!--Detail的转换  -->
	<xsl:template match="Detail">
		<Detail>
			<!--交易日期-->
			<Column></Column>
		    <!--明细顺序号-->
			<Column><xsl:value-of select="DetailSerialNo" /></Column>
			<!--客户账号-->
			<Column><xsl:value-of select="AccNo" /></Column>
			<!-- 客户名称-->
			<Column><xsl:value-of select="AccName" /></Column>
			<!-- 证件类型-->
			<Column><xsl:value-of select="IDType" /></Column>
			<!--证件号码-->
			<Column><xsl:value-of select="IDNo" /></Column>
			<!--保单号-->
			<Column><xsl:value-of select="ContNo" /></Column>
			<!--账户省市代码-->
			<Column></Column>
			<!--币种-->
			<Column>01</Column>
			<!--交易金额-->
			<Column><xsl:value-of select="Amount" /></Column>
	    </Detail>

    </xsl:template>
</xsl:stylesheet>
