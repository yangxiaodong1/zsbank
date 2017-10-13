<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<!-- 汇总行信息 -->
				<Detail>
					<!-- 总记录数 -->
					<count>
						<xsl:value-of select="count(//Detail)" />
					</count>
					<!-- 总金额 -->
					<SumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail/EdorCTPrem))" />
					</SumPrem>
					<!-- 犹撤总记录数 -->
					<HesitateCount>
						<xsl:value-of select="count(//Detail[BusinessType='WT'])" />
					</HesitateCount>
					<!-- 犹撤总金额 -->
					<HesitateSumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail[BusinessType='WT']/EdorCTPrem))" />
					</HesitateSumPrem>
					<!-- 满期总记录数 -->
					<MQCount>
						<xsl:value-of select="count(//Detail[BusinessType='MQ'])" />
					</MQCount>
					<!-- 满期总金额 -->
					<MQSumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail[BusinessType='MQ']/EdorCTPrem))" />
					</MQSumPrem>
					<!-- 退保总记录数 -->
					<CTCount>
						<xsl:value-of select="count(//Detail[BusinessType='CT'])" />
					</CTCount>
					<!-- 退保总金额 -->
					<CTSumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail[BusinessType='CT']/EdorCTPrem))" />
					</CTSumPrem>
					<remark />
				</Detail>
				<!-- 明细行 -->
				<xsl:apply-templates select="TranData/Body/Detail" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 文件的一条记录 -->
	<xsl:template match="Detail">
		<Detail>
			<!-- 业务类型 -->
			<BusinessType>
				<xsl:apply-templates select="BusinessType" />
			</BusinessType>
			<TranDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
			</TranDate>
			<ContNo>
				<xsl:value-of select="ContNo" />
			</ContNo>
			<!-- 申请人姓名 -->
			<ApplyName>
				<xsl:value-of select="ApplyName" />
			</ApplyName>
			<!-- 受理渠道 -->
			<ApplyChannel>
				<xsl:apply-templates select="ApplyChannel" />
			</ApplyChannel>
			<!-- 投保人姓名-->
			<AppntName>
				<xsl:value-of select="AppntName" />
			</AppntName>
			<!-- 投保人证件类型-->
			<AppntIDType>
				<xsl:call-template name="IDKind">
					<xsl:with-param name="value" select="AppntIDType" />
				</xsl:call-template>
			</AppntIDType>
			<!-- 投保人证件号-->
			<AppntIDNo>
				<xsl:value-of select="AppntIDNo" />
			</AppntIDNo>
			<!-- 处理结果 新增(取值由核心定义):2=成功，3=失败-->
			<ProcResult>2</ProcResult>
			<!-- 业务金额（元）-->
			<EdorCTPrem>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EdorCTPrem)" />
			</EdorCTPrem>
			<remark></remark>
		</Detail>
	</xsl:template>

	<!-- 保单状态 -->
	<!-- 招行状态：A:正常；C:退保；D:当日撤单；E:待承保；R:拒保；S:犹豫期撤单 -->
	<!-- 核心状态：00:保单有效,01:满期终止,02:退保终止,04:理赔终止,WT:犹豫期退保终止,A:拒保,B:待签单, -->
	<xsl:template name="tran_businessType" match="BusinessType">
		<xsl:choose>
			<xsl:when test=".='WT'">01</xsl:when> <!-- 犹豫 -->
			<xsl:when test=".='MQ'">02</xsl:when> <!-- 满期给付 -->
			<xsl:when test=".='CT'">03</xsl:when><!-- 退保 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 受理渠道 -->
	<xsl:template name="tran_applychannel" match="ApplyChannel">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- 保险公司 -->
			<xsl:when test=".='6'">1</xsl:when><!-- 银保 -->
			<xsl:when test=".='7'">1</xsl:when><!-- 网银 -->
			<xsl:when test=".='8'">1</xsl:when><!-- 自助终端 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 证件类型 -->
	<xsl:template name="IDKind">
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$value='0'">110001</xsl:when><!--居民身份证                -->
			<xsl:when test="$value='5'">110005</xsl:when><!--户口簿                    -->
			<xsl:when test="$value='1'">110023</xsl:when><!--中华人民共和国护照        -->
			<xsl:when test="$value='2'">110027</xsl:when><!--军官证                    -->
			<xsl:otherwise>119999</xsl:otherwise> <!-- 其他 -->
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>