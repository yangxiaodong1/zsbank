<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/TranData">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*"/>
			</Head>
			
			<Body>
				<!-- 注：Column标签从1开始计数，不是从0 -->
				<Count>
					<xsl:value-of select="count(Body/Detail[Column[11]='C'])" />
				</Count>
				<xsl:for-each select="Body/Detail[Column[11]='C']">
					<Detail>
						<!--交易日期（yyyymmdd）-->
						<TranDate>
							<xsl:value-of select="Column[3]" />
						</TranDate>
						<!--网点码-->
						<NodeNo>
							<xsl:value-of select="Column[4]" /><xsl:value-of select="Column[5]" />
						</NodeNo>
						<!--对应新单银行端流水号-->
						<TranNo>
							<xsl:value-of select="Column[7]" />
						</TranNo>
						<!--投保单号-->
						<ProposalPrtNo>
							<xsl:value-of select="Column[8]" />
						</ProposalPrtNo>
						<!--投保人账/卡号-->
						<AccNo>
							<xsl:value-of select="Column[15]" />
						</AccNo>
						<!--投保人姓名-->
						<AppntName>
							<xsl:value-of select="Column[12]" />
						</AppntName>
						<!--投保人证件类型-->
						<AppntIDType>
							<xsl:call-template name="tran_idtype">
								<xsl:with-param name="idtype">
									<xsl:value-of select="Column[13]" />
								</xsl:with-param>
							</xsl:call-template>
						</AppntIDType>
						<!--投保人证件号-->
						<AppntIDNo>
							<xsl:value-of select="Column[14]" />
						</AppntIDNo>
						<!--销售渠道 （0:柜面）-->
						<SourceType>
							<xsl:value-of select="Column[10]" />
						</SourceType>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- 银行证件类型：1 身份证、2 户口本、3 军官证、4 警官证、5 士兵证、6 文职干部证、7 护照、8 港澳台通行证、9 其他 -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
			<!-- 身份证 -->
			<xsl:when test="$idtype='1'">0</xsl:when>
			<!-- 户口本 -->
			<xsl:when test="$idtype='2'">5</xsl:when>
			<!-- 军官证 -->
			<xsl:when test="$idtype='3'">2</xsl:when>
			<!-- 军官证 -->
			<xsl:when test="$idtype='5'">2</xsl:when>
			<!-- 护照 -->
			<xsl:when test="$idtype='7'">1</xsl:when>
			<!-- 其它 -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
