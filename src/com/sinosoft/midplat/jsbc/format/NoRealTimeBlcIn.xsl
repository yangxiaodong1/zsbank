<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="TranData">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*"/>
			</Head>
			<Body>
				<Count>
					<xsl:value-of
						select="Body/Detail[LineNum='0']/Column[3]" />
				</Count>
				         
				<xsl:for-each select="Body/Detail[LineNum!='0']">
					<Detail> 
						<TranDate>
							<xsl:value-of select="../../Head/TranDate" />
						</TranDate>
						<!--  银行网点代码  -->
						<NodeNo>
							<xsl:value-of select="Column[11]" />
						</NodeNo>
						<!--  交易流水号  -->
						<TranNo></TranNo>
						<!--投保单号-->
         				<ProposalPrtNo>
         					<xsl:value-of select="Column[1]" />
         				</ProposalPrtNo>
         				<!--投保人账/卡号-->
        			 	<AccNo>
        			 		<xsl:value-of select="Column[5]" />
        			 	</AccNo>
         				<!--投保人姓名-->
         				<AppntName>
         					<xsl:value-of select="Column[2]" />
         				</AppntName>
         				<!--投保人证件类型-->
         				<AppntIDType>
         					<xsl:apply-templates select="Column[3]" />
         				</AppntIDType>
         				<!--投保人证件号-->
         				<AppntIDNo>
         					<xsl:value-of select="Column[4]" />
         				</AppntIDNo>
         				<!-- 销售渠道-->
						<SourceType>0</SourceType>
						<!--   实交金额-->
						<Prem>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[8])" />
						</Prem>
						<!-- 险种编码  -->
         				<RiskCode>
         					<xsl:apply-templates select="Column[6]" />
         				</RiskCode>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	<!-- 证件类型 -->
	<xsl:template match="Column[3]">
		<xsl:choose>
		      <xsl:when test=".='011'">0</xsl:when>	  <!-- 第一代居民身份证         -->
			  <xsl:when test=".='021'">0</xsl:when>	  <!-- 第二代居民身份证         -->
			  <xsl:when test=".='031'">0</xsl:when>	  <!-- 临时身份证               -->
			  <xsl:when test=".='042'">1</xsl:when>	  <!-- 中国护照                 -->
			  <xsl:when test=".='056'">5</xsl:when>	  <!-- 户口簿                   -->
			  <xsl:when test=".='068'">8</xsl:when>	  <!-- 村民委员会证明           -->
			  <xsl:when test=".='078'">8</xsl:when>	  <!-- 学生证                   -->
			  <xsl:when test=".='083'">2</xsl:when>	  <!--  军官证                  -->
			  <xsl:when test=".='098'">8</xsl:when>	  <!-- 离休干部荣誉证           -->
			  <xsl:when test=".='108'">8</xsl:when>	  <!-- 军官退休证               -->
			  <xsl:when test=".='118'">8</xsl:when>	  <!-- 文职干部退休证           -->
			  <xsl:when test=".='128'">8</xsl:when>	  <!-- 军事学员证               -->
			  <xsl:when test=".='134'">2</xsl:when>	  <!-- 武警证                   -->
			  <xsl:when test=".='137'">2</xsl:when>	  <!-- 警官证                   -->
			  <xsl:when test=".='148'">2</xsl:when>	  <!-- 士兵证                   -->
			  <xsl:when test=".='155'">6</xsl:when>	  <!-- 香港通行证               -->
			  <xsl:when test=".='165'">6</xsl:when>	  <!-- 澳门通行证               -->
			  <xsl:when test=".='175'">7</xsl:when>	  <!-- 台湾通行证或有效旅行证件 -->
			  <xsl:when test=".='18A'">8</xsl:when>	  <!-- 外国人永久居留证         -->
			  <xsl:when test=".='199'">8</xsl:when>	  <!-- 边民出入境通行证         -->
			  <xsl:when test=".='202'">1</xsl:when>	  <!-- 外国护照                 -->
			  <xsl:when test=".='218'">8</xsl:when>	  <!-- 其它                     -->
			  <xsl:when test=".='210'">8</xsl:when>	  <!-- 个体工商户营业执照       -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template match="Column[6]">
		<xsl:choose>
		      <xsl:when test=".='20000050'">122009</xsl:when>	  <!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>