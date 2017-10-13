<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<InsuRet>
			<Main>
				<xsl:if test="Head/Flag='0'">
					<ResultCode>0000</ResultCode>
					<ResultInfo>
						<xsl:value-of select="Head/Desc" />
					</ResultInfo>
				</xsl:if>
				<xsl:if test="Head/Flag!='0'">
					<ResultCode>0001</ResultCode>
					<ResultInfo>
						<xsl:value-of select="Head/Desc" />
					</ResultInfo>
				</xsl:if>
			</Main>
			<xsl:if test="Head/Flag='0'">
				<xsl:apply-templates select="Body" />
			</xsl:if>
		</InsuRet>
	</xsl:template>

	<xsl:template name="Base" match="Body">
		<xsl:variable name="MainRisk"
			select="Risk[RiskCode=MainRiskCode]" />
		<!--保单信息-->
		<Policy>
			<!-- 主险代码 -->
			<InsursCode>
				<xsl:call-template name="tran_risk">
					<xsl:with-param name="riskcode" select="RiskCode" />
				</xsl:call-template>
			</InsursCode>
			<!-- 保单号 -->
			<PolicyNo>
				<xsl:value-of select="ContNo" />
			</PolicyNo>
			<!-- 保费 -->
			<Premium>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)" />
			</Premium>
			<!-- 主险保额 -->
			<InsuAmount>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/Amnt)" />
			</InsuAmount>
			<!-- 缴费终止日期 -->
			<PayEndDate>
				<xsl:value-of select="$MainRisk/PayEndDate" />
			</PayEndDate>
			<!-- 合同生效日期 -->
			<PoleffDate>
				<xsl:value-of select="$MainRisk/CValiDate" />
			</PoleffDate>
			<!-- 合同终止日期 -->
			<xsl:choose>
				<xsl:when
					test="($MainRisk/InsuYear = 106) and ($MainRisk/InsuYearFlag = 'A')">
					<PolEndDate>99999999</PolEndDate>
				</xsl:when>
				<xsl:otherwise>
					<PolEndDate>
						<xsl:value-of select="$MainRisk/InsuEndDate" />
					</PolEndDate>
				</xsl:otherwise>
			</xsl:choose>
			<!-- 缴费年期/年龄标志 -->
			<PayEndYearFlag>
				<xsl:value-of select="PayEndYearFlag" />
			</PayEndYearFlag>
			<!-- 缴费期间 -->
			<PayEndYear>
				<xsl:value-of select="PayEndYear" />
			</PayEndYear>
			<!-- 保障年期/年龄标志 -->
			<InsuYearFlag>
				<xsl:value-of select="InsuYearFlag" />
			</InsuYearFlag>
			<!-- 保障期间 -->
			<xsl:choose>
				<xsl:when
					test="(InsuYear = 106) and (InsuYearFlag = 'A')">
					<InsuYear>999</InsuYear>
				</xsl:when>
				<xsl:otherwise>
					<InsuYear>
						<xsl:value-of select="InsuYear" />
					</InsuYear>
				</xsl:otherwise>
			</xsl:choose>
		</Policy>

		<!-- 投保人信息 -->
		<Appnt>
			<xsl:apply-templates select="Appnt" />
		</Appnt>
		<!-- 被保人信息 -->
		<Insured>
			<xsl:apply-templates select="Insured" />
		</Insured>
	</xsl:template>

	<!-- 投保人信息 -->
	<xsl:template name="Appnt" match="Appnt">
		<Name>
			<xsl:value-of select="Name" />
		</Name>
		<Sex>
			<xsl:value-of select="Sex" />
		</Sex>
		<IDType>
			<xsl:apply-templates select="IDType" />
		</IDType>
		<IDNo>
			<xsl:value-of select="IDNo" />
		</IDNo>
		<Birthday>
			<xsl:value-of select="Birthday" />
		</Birthday>
	</xsl:template>
	<!-- 被保人信息 -->
	<xsl:template name="Insured" match="Insured">
		<Name>
			<xsl:value-of select="Name" />
		</Name>
		<Sex>
			<xsl:value-of select="Sex" />
		</Sex>
		<IDType>
			<xsl:apply-templates select="IDType" />
		</IDType>
		<IDNo>
			<xsl:value-of select="IDNo" />
		</IDNo>
		<Birthday>
			<xsl:value-of select="Birthday" />
		</Birthday>
	</xsl:template>

	<!-- 险种代码，该文件并未使用转换，只是记录以上线的险种 -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when>
			<!-- 安邦盛世2号终身寿险（万能型） -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when>
			<!-- 东风5号两全保险（万能型） 主险 add by jbq -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when>
			<!-- 东风2号两全保险（万能型） 主险 -->
			<xsl:when test="$riskcode='50015'">50015</xsl:when>

			<xsl:when test="$riskcode='L12086'">L12086</xsl:when><!--安邦东风3号两全保险（万能型）-->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
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