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
					<xsl:value-of
						select="count(//Detail[position() > 1])" />
				</Count>
				<xsl:for-each select="//Detail[position() > 1]">
					<Detail>
						<!-- 保单号-->
						<ContNo>
							<xsl:value-of select="Column[3]" />
						</ContNo>
						<!-- 投保人姓名-->
						<AppntName>
							<xsl:value-of select="Column[4]" />
						</AppntName>
						<!-- 投保人证件类型-->
						<AppntIDType>
							<xsl:call-template name="IDKind">
								<xsl:with-param name="value"
									select="Column[5]" />
							</xsl:call-template>
						</AppntIDType>
						<!-- 投保人证件号-->
						<AppntIDNo>
							<xsl:value-of select="Column[6]" />
						</AppntIDNo>
						<!-- 业务类型 -->
						<BusinessType>
							<xsl:call-template name="BusinessType">
								<xsl:with-param name="value"
									select="Column[9]" />
							</xsl:call-template>
						</BusinessType>
						<!-- 业务金额（分）-->
						<EdorCTPrem>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[7])" />
						</EdorCTPrem>
						<!-- 银行端处理情况-->
						<HandleInfo>
							<!-- 处理日期（yyyymmdd）认为是银行接受文件的日期-->
							<TranDate>
								<xsl:value-of select="Column[8]" />
							</TranDate>
							<!--银行端流水号-->
							<TranNo>
								<xsl:value-of select="Column[11]" />
							</TranNo>
							<!-- 是否成功（0成功 1失败）-->
							<ResultFlag>
								<xsl:choose>
									<xsl:when test="Column[14] = '240000'">0</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</ResultFlag>
							<!-- 错误码-->
							<ResultCode>
								<xsl:value-of select="Column[14]" />
							</ResultCode>
							<!-- 错误描述-->
							<ResultMsg>
								<xsl:value-of select="Column[15]" />
							</ResultMsg>
							<!-- 备注-->
							<Remark>
								<xsl:value-of select="Column[16]" />
							</Remark>
						</HandleInfo>
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
	
	<!-- 业务类型 -->
	<xsl:template name="BusinessType">
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$value='01'">WT</xsl:when><!--犹撤  -->
			<xsl:when test="$value='02'">MQ</xsl:when><!--满期给付  -->
			<xsl:when test="$value='03'">CT</xsl:when><!--退保  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>