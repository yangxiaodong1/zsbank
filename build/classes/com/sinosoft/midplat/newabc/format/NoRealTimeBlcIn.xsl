<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<Count>
					<xsl:value-of select="count(//Detail[position() > 1])" />
				</Count>
				<xsl:for-each select="//Detail[position() > 1]">
					<Detail>
						<!--  交易日期（8位数字格式YYYYMMDD，不能为空） -->
						<TranDate>
							<xsl:value-of select="Column[1]" />
						</TranDate>
						<!--  银行网点代码  (省市代码+网点码)-->
						<NodeNo>
							<xsl:value-of select="Column[17]" />
							<xsl:value-of select="Column[18]" />
						</NodeNo>
						<!--  试算申请流水号  -->
						<TranNo>
							<xsl:value-of select="Column[2]" />
						</TranNo>
						<!--  投保单号  -->
						<ProposalPrtNo>
							<xsl:value-of select="Column[8]" />
						</ProposalPrtNo>
						<!-- 首期保费账户 -->
						<AccNo>
							<xsl:value-of select="Column[11]" />
						</AccNo>
						<!-- 投保人姓名 -->
						<AppntName>
							<xsl:value-of select="Column[3]" />
						</AppntName>
						<!-- 投保人证件类型 -->
						<AppntIDType>
							<xsl:call-template name="IDKind">
								<xsl:with-param name="value"
									select="Column[4]" />
							</xsl:call-template>
						</AppntIDType>
						<!-- 投保人号码 -->
						<AppntIDNo>
							<xsl:value-of select="Column[5]" />
						</AppntIDNo>
						<!-- 交易渠道（预留） -->
						<SourceType>0</SourceType>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template name="IDKind">
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$value='110001'">0</xsl:when><!--居民身份证                -->
			<xsl:when test="$value='110002'">0</xsl:when><!--重号居民身份证            -->
			<xsl:when test="$value='110003'">0</xsl:when><!--临时居民身份证            -->
			<xsl:when test="$value='110004'">0</xsl:when><!--重号临时居民身份证        -->
			<xsl:when test="$value='110005'">5</xsl:when><!--户口簿                    -->
			<xsl:when test="$value='110006'">5</xsl:when><!--重号户口簿                -->
			<xsl:when test="$value='110023'">1</xsl:when><!--中华人民共和国护照        -->
			<xsl:when test="$value='110024'">1</xsl:when><!--重号中华人民共和国护照    -->
			<xsl:when test="$value='110025'">1</xsl:when><!--外国护照                  -->
			<xsl:when test="$value='110026'">1</xsl:when><!--重号外国护照              -->
			<xsl:when test="$value='110027'">2</xsl:when><!--军官证                    -->
			<xsl:when test="$value='110028'">2</xsl:when><!--重号军官证                -->
			<xsl:when test="$value='110029'">2</xsl:when><!--文职干部证                -->
			<xsl:when test="$value='110030'">2</xsl:when><!--重号文职干部证            -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>