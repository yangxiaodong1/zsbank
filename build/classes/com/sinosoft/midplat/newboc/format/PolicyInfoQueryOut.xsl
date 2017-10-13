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
		<!--������Ϣ-->
		<Policy>
			<!-- ���մ��� -->
			<InsursCode>
				<xsl:call-template name="tran_risk">
					<xsl:with-param name="riskcode" select="RiskCode" />
				</xsl:call-template>
			</InsursCode>
			<!-- ������ -->
			<PolicyNo>
				<xsl:value-of select="ContNo" />
			</PolicyNo>
			<!-- ���� -->
			<Premium>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)" />
			</Premium>
			<!-- ���ձ��� -->
			<InsuAmount>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/Amnt)" />
			</InsuAmount>
			<!-- �ɷ���ֹ���� -->
			<PayEndDate>
				<xsl:value-of select="$MainRisk/PayEndDate" />
			</PayEndDate>
			<!-- ��ͬ��Ч���� -->
			<PoleffDate>
				<xsl:value-of select="$MainRisk/CValiDate" />
			</PoleffDate>
			<!-- ��ͬ��ֹ���� -->
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
			<!-- �ɷ�����/�����־ -->
			<PayEndYearFlag>
				<xsl:value-of select="PayEndYearFlag" />
			</PayEndYearFlag>
			<!-- �ɷ��ڼ� -->
			<PayEndYear>
				<xsl:value-of select="PayEndYear" />
			</PayEndYear>
			<!-- ��������/�����־ -->
			<InsuYearFlag>
				<xsl:value-of select="InsuYearFlag" />
			</InsuYearFlag>
			<!-- �����ڼ� -->
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

		<!-- Ͷ������Ϣ -->
		<Appnt>
			<xsl:apply-templates select="Appnt" />
		</Appnt>
		<!-- ��������Ϣ -->
		<Insured>
			<xsl:apply-templates select="Insured" />
		</Insured>
	</xsl:template>

	<!-- Ͷ������Ϣ -->
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
	<!-- ��������Ϣ -->
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

	<!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
	<xsl:template name="tran_risk">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when>
			<!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when>
			<!-- ����5����ȫ���գ������ͣ� ���� add by jbq -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when>
			<!-- ����2����ȫ���գ������ͣ� ���� -->
			<xsl:when test="$riskcode='50015'">50015</xsl:when>

			<xsl:when test="$riskcode='L12086'">L12086</xsl:when><!--�����3����ȫ���գ������ͣ�-->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ֤������-->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".=01">0</xsl:when><!-- �������֤ -->
			<xsl:when test=".=02">0</xsl:when><!-- ��ʱ���֤ -->
			<xsl:when test=".=03">1</xsl:when><!-- ���� -->
			<xsl:when test=".=04">5</xsl:when><!-- ���ڲ� -->
			<xsl:when test=".=05">2</xsl:when><!-- �������֤ -->
			<xsl:when test=".=06">2</xsl:when><!-- ��װ�������֤  -->
			<xsl:when test=".=08">8</xsl:when><!-- �⽻��Ա���֤ -->
			<xsl:when test=".=09">8</xsl:when><!-- ����˾������֤-->
			<xsl:when test=".=10">8</xsl:when><!-- ������뾳ͨ��֤�� -->
			<xsl:when test=".=11">8</xsl:when><!-- ���� -->
			<xsl:when test=".=47">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤����ۣ� -->
			<xsl:when test=".=48">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤�����ţ� -->
			<xsl:when test=".=49">7</xsl:when><!-- ̨�����������½ͨ��֤ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>