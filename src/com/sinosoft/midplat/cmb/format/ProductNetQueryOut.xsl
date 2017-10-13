<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- 报文头 -->
			<xsl:copy-of select="TranData/Head" />
			<!-- 报文体 -->
			<Body>
				<xsl:apply-templates select="TranData/Body/Detail" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 文件的一条记录 -->
	<xsl:template match="Detail">
		<Detail>
			<TXLife>
				<TXLifeResponse>
					<!-- 交易流水号 -->
					<TransRefGUID>0000000001</TransRefGUID>
					<!--  交易码/处理标志: 保单查询  -->
					<TransType>64</TransType>
					<!--  银行交易日期-->
					<TransExeDate>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
					</TransExeDate>
					<!--  银行交易时间 -->
					<TransExeTime>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
					</TransExeTime>
					<!--  保险公司代码（招行定义）  -->
					<CarrierCode>141</CarrierCode>
					<OLife>
						<Holding id="Holding_1">
							<Life>
								<!-- 险种代码 -->
								<LifeKey>
									<xsl:apply-templates select="RiskCode" />
								</LifeKey>
								<!--  当前结算利率  -->
								<xsl:choose>
									<xsl:when test="CurrIntRate!=''">
										<xsl:variable name="Rate" select="number(CurrIntRate)" />
										<CurrIntRate><xsl:value-of select="format-number($Rate*100, '#.0000')" /></CurrIntRate>
									</xsl:when>
									<xsl:otherwise>
										<CurrIntRate>0</CurrIntRate>
									</xsl:otherwise>
								</xsl:choose>								
								<!--  利率开始日期  -->
								<xsl:choose>
									<xsl:when test="CurrIntRateDate!=''">
										<CurrIntRateDate><xsl:apply-templates select="CurrIntRateDate" /></CurrIntRateDate>
									</xsl:when>
									<xsl:otherwise>
										<CurrIntRateDate>0</CurrIntRateDate>
									</xsl:otherwise>
								</xsl:choose>
							</Life>
							<!-- 投连险必须返回，万能险不必须返回 -->
							<!-- <Investment></Investment>  -->
						</Holding>
					</OLife>
				</TXLifeResponse>
			</TXLife>
		</Detail>
	</xsl:template>

	<!-- 险种代码：此处的险种代码包括所有主险及附加险，套餐产品，如果险种里有万能险产品，则银行会显示多条 -->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test=".='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12073'">122029</xsl:when><!-- 安邦盛世5号终身寿险（万能型）  -->
			<!-- 盛9主险及附加险 -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型） -->
			<xsl:when test=".='122028'">122028</xsl:when><!-- 安邦附加安心7号重大疾病保险 -->
			<xsl:when test=".='122041'">122041</xsl:when><!-- 安邦附加盛世安康住院医疗保险A款 -->
			<xsl:when test=".='122042'">122042</xsl:when><!-- 安邦附加盛世安康住院医疗保险B款 -->
			<xsl:when test=".='122043'">122043</xsl:when><!-- 安邦附加盛世安康护理保险 -->
			<xsl:when test=".='122044'">122044</xsl:when><!-- 安邦附加盛世安康防癌疾病保险 -->
			
			<xsl:when test=".='L12052'">L12052</xsl:when><!-- 安邦长寿智赢1号年金保险 -->
			<!-- 长寿稳赢主险及附加险 -->
			<xsl:when test=".='122046'">122046</xsl:when><!--  安邦长寿稳赢1号两全保险 -->
			<xsl:when test=".='122047'">122047</xsl:when><!--  安邦附加长寿稳赢两全保险 -->
			<xsl:when test=".='L12081'">L12081</xsl:when><!--  安邦长寿添利终身寿险（万能型） -->
			
			<!-- 安邦长寿智赢1号年金保险计划,2014-08-29停售
			<xsl:when test=".='L12052'">50006</xsl:when>
			-->
			
			<!-- 安邦长寿安享3号保险计划=50011,L12068=安邦长寿安享3号年金保险,L12069=安邦附加长寿添利3号两全保险（万能型） -->
			<xsl:when test=".='L12068'">L12068</xsl:when><!-- 安邦长寿安享3号年金保险 -->
			<xsl:when test=".='L12069'">L12069</xsl:when><!-- 安邦附加长寿添利3号两全保险（万能型） -->
			
			<!-- add 20151229 PBKINSR-1010 招行新产品盛世1号需求  begin -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<!-- add 20151229 PBKINSR-1010 招行新产品盛世1号需求  end -->
			
			<!-- add 20150222 PBKINSR-1071 招行新产品盛世1号B款需求  begin -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  B款-->
			<!-- add 20160222 PBKINSR-1071 招行新产品盛世1号B款需求  end -->
			<!-- PBKINSR-1444 招行柜面东风3号 L12086  zx add 20160805 -->
			<xsl:when test=".='L12086'">L12086</xsl:when> <!-- 安邦东风3号两全保险（万能型） -->
			<!-- PBKINSR-1530 招行柜面东风9号 L12088 zx add 20160805 -->
			<xsl:when test=".='L12088'">L12088</xsl:when> <!-- 安邦东风9号两全保险（万能型） -->
			<xsl:when test=".='L12087'">L12087</xsl:when> <!-- 安邦东风5号两全保险（万能型） -->
			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
