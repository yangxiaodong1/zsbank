<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<!-- 报文体 -->
			<Body>
				<!-- 成功的新契约交易 -->
				<Count>
					<xsl:value-of
						select="count(//Detail[LineNum !='0'])" />
				</Count>				
				<!-- 去掉首行：首行为汇总行 -->
				<xsl:for-each
					select="//Detail[LineNum !='0']">
					<Detail>
						<!--  交易日期（YYYYMMDD） -->
						<TranDate>
							<xsl:value-of select="Column[5]" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="Column[3]" /><xsl:value-of select="Column[4]" />
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo>
							<xsl:value-of select="Column[8]" />
						</TranNo>
						<!-- 投保单号 -->
         				<ProposalPrtNo><xsl:value-of select="Column[13]" /></ProposalPrtNo>
						<!-- 首期保费账户 -->
         				<AccNo><xsl:value-of select="Column[20]" /></AccNo>
						<!-- 投保人姓名 -->
         				<AppntName><xsl:value-of select="Column[16]" /></AppntName>
						<!-- 投保人证件类型 -->
         				<AppntIDType>
         				<xsl:call-template name="tran_idType">
								<xsl:with-param name="idType" select="Column[17]" />
							</xsl:call-template>
         				</AppntIDType>
						<!-- 投保人号码 -->
         				<AppntIDNo><xsl:value-of select="Column[18]" /></AppntIDNo>						
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	
	<!-- 证件类型 -->
	<xsl:template name="tran_idType">
		<xsl:param name="idType" />
		<xsl:choose>
			<xsl:when test="$idType='0101'">0</xsl:when> <!-- 身份证 -->
			<xsl:when test="$idType='0102'">0</xsl:when> <!-- 身份证 -->
			<xsl:when test="$idType='0200'">0</xsl:when> <!-- 身份证 -->
			<xsl:when test="$idType='0300'">5</xsl:when> <!-- 户口簿 -->
			<xsl:when test="$idType='0301'">8</xsl:when> <!-- 其它 -->
			<xsl:when test="$idType='0400'">5</xsl:when> <!-- 户口簿 -->
			<xsl:when test="$idType='0601'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test="$idType='0604'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test="$idType='0700'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test="$idType='0701'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test="$idType='0800'">2</xsl:when> <!-- 军官证 -->
			<xsl:when test="$idType='1000'">1</xsl:when> <!-- 护照 -->
			<xsl:when test="$idType='1100'">8</xsl:when> <!-- 其它 -->
			<xsl:when test="$idType='1110'">8</xsl:when> <!-- 其它 -->
			<xsl:when test="$idType='1111'">8</xsl:when> <!-- 其它 -->
			<xsl:when test="$idType='1112'">8</xsl:when> <!-- 其它 -->
			<xsl:when test="$idType='1113'">8</xsl:when> <!-- 其它 -->
			<xsl:when test="$idType='1114'">8</xsl:when> <!-- 其它 -->
			<xsl:when test="$idType='1120'">8</xsl:when> <!-- 其它 -->
			<xsl:when test="$idType='1121'">6</xsl:when> <!-- 港澳居民来往内地通行证 -->
			<xsl:when test="$idType='1122'">6</xsl:when> <!-- 港澳居民来往内地通行证 -->
			<xsl:when test="$idType='1123'">7</xsl:when> <!-- 台湾居民来往大陆通行证 -->
			<xsl:when test="$idType='1300'">8</xsl:when> <!-- 其它 -->
			<xsl:when test="$idType='9999'">8</xsl:when> <!-- 其它 -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>