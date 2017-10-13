<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="InsuReq">
		<TranData>
			<xsl:apply-templates select="Main" />
			<Body>
				<!-- 投保单(印刷)号 -->
				<ProposalPrtNo>
					<xsl:value-of select="Main/ApplyNo" />
				</ProposalPrtNo>
				<!-- 保单合同印刷号 -->
				<ContPrtNo>
					<xsl:value-of select="Main/PrintNo" />
				</ContPrtNo>
				<!-- 投保人 -->
				<Appnt>
					<xsl:apply-templates select="Appnt" />
				</Appnt>
			</Body>
		</TranData>
	</xsl:template>
	<!-- 投保人信息 -->
	<xsl:template name="Appnt" match="Appnt">
		<!-- 证件类型 -->
		<IDType>
			<xsl:apply-templates select="IDType" />
		</IDType>
		<!-- 证件号码 -->
		<IDNo>
			<xsl:value-of select="IDNo" />
		</IDNo>
	</xsl:template>
	<!-- 报文头信息 -->
	<xsl:template name="Head" match="Main">
		<Head>
			<!-- 交易日期[yyyyMMdd] -->
			<TranDate>
				<xsl:value-of select="TranDate" />
			</TranDate>
			<!-- 交易时间[hhmmss] -->
			<TranTime>
				<xsl:value-of select="TranTime" />
			</TranTime>
			<!-- 柜员代码 -->
			<TellerNo>
				<xsl:value-of select="TellerNo" />
			</TellerNo>
			<!-- 交易流水号 -->
			<TranNo>
				<xsl:value-of select="TransNo" />
			</TranNo>
			<!-- 地区码+网点码 -->
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

	<!-- 证件类型-->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".=01">0</xsl:when><!-- 居民身份证 -->
			<xsl:when test=".=02">0</xsl:when><!-- 临时身份证 -->
			<xsl:when test=".=03">1</xsl:when><!-- 护照 -->
			<xsl:when test=".=04">5</xsl:when><!-- 户口簿 -->
			<xsl:when test=".=05">2</xsl:when><!-- 军官身份证 -->
			<xsl:when test=".=06">2</xsl:when><!-- 武装警察身份证  -->
			<xsl:when test=".=08">8</xsl:when><!-- 外交人员身份证 -->
			<xsl:when test=".=09">8</xsl:when><!-- 外国人居留许可证-->
			<xsl:when test=".=10">8</xsl:when><!-- 边民出入境通行证簿 -->
			<xsl:when test=".=11">8</xsl:when><!-- 其他 -->
			<xsl:when test=".=47">6</xsl:when><!-- 港澳居民来往内地通行证（香港） -->
			<xsl:when test=".=48">6</xsl:when><!-- 港澳居民来往内地通行证（澳门） -->
			<xsl:when test=".=49">7</xsl:when><!-- 台湾居民来往大陆通行证 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>