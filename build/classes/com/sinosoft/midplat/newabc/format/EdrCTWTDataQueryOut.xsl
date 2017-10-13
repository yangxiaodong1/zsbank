<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<!-- ��������Ϣ -->
				<Detail>
					<!-- �ܼ�¼�� -->
					<count>
						<xsl:value-of select="count(//Detail)" />
					</count>
					<!-- �ܽ�� -->
					<SumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail/EdorCTPrem))" />
					</SumPrem>
					<!-- �̳��ܼ�¼�� -->
					<HesitateCount>
						<xsl:value-of select="count(//Detail[BusinessType='WT'])" />
					</HesitateCount>
					<!-- �̳��ܽ�� -->
					<HesitateSumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail[BusinessType='WT']/EdorCTPrem))" />
					</HesitateSumPrem>
					<!-- �����ܼ�¼�� -->
					<MQCount>
						<xsl:value-of select="count(//Detail[BusinessType='MQ'])" />
					</MQCount>
					<!-- �����ܽ�� -->
					<MQSumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail[BusinessType='MQ']/EdorCTPrem))" />
					</MQSumPrem>
					<!-- �˱��ܼ�¼�� -->
					<CTCount>
						<xsl:value-of select="count(//Detail[BusinessType='CT'])" />
					</CTCount>
					<!-- �˱��ܽ�� -->
					<CTSumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail[BusinessType='CT']/EdorCTPrem))" />
					</CTSumPrem>
					<remark />
				</Detail>
				<!-- ��ϸ�� -->
				<xsl:apply-templates select="TranData/Body/Detail" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- �ļ���һ����¼ -->
	<xsl:template match="Detail">
		<Detail>
			<!-- ҵ������ -->
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
			<!-- ���������� -->
			<ApplyName>
				<xsl:value-of select="ApplyName" />
			</ApplyName>
			<!-- �������� -->
			<ApplyChannel>
				<xsl:apply-templates select="ApplyChannel" />
			</ApplyChannel>
			<!-- Ͷ��������-->
			<AppntName>
				<xsl:value-of select="AppntName" />
			</AppntName>
			<!-- Ͷ����֤������-->
			<AppntIDType>
				<xsl:call-template name="IDKind">
					<xsl:with-param name="value" select="AppntIDType" />
				</xsl:call-template>
			</AppntIDType>
			<!-- Ͷ����֤����-->
			<AppntIDNo>
				<xsl:value-of select="AppntIDNo" />
			</AppntIDNo>
			<!-- ������ ����(ȡֵ�ɺ��Ķ���):2=�ɹ���3=ʧ��-->
			<ProcResult>2</ProcResult>
			<!-- ҵ���Ԫ��-->
			<EdorCTPrem>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EdorCTPrem)" />
			</EdorCTPrem>
			<remark></remark>
		</Detail>
	</xsl:template>

	<!-- ����״̬ -->
	<!-- ����״̬��A:������C:�˱���D:���ճ�����E:���б���R:�ܱ���S:��ԥ�ڳ��� -->
	<!-- ����״̬��00:������Ч,01:������ֹ,02:�˱���ֹ,04:������ֹ,WT:��ԥ���˱���ֹ,A:�ܱ�,B:��ǩ��, -->
	<xsl:template name="tran_businessType" match="BusinessType">
		<xsl:choose>
			<xsl:when test=".='WT'">01</xsl:when> <!-- ��ԥ -->
			<xsl:when test=".='MQ'">02</xsl:when> <!-- ���ڸ��� -->
			<xsl:when test=".='CT'">03</xsl:when><!-- �˱� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �������� -->
	<xsl:template name="tran_applychannel" match="ApplyChannel">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- ���չ�˾ -->
			<xsl:when test=".='6'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='7'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='8'">1</xsl:when><!-- �����ն� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template name="IDKind">
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$value='0'">110001</xsl:when><!--�������֤                -->
			<xsl:when test="$value='5'">110005</xsl:when><!--���ڲ�                    -->
			<xsl:when test="$value='1'">110023</xsl:when><!--�л����񹲺͹�����        -->
			<xsl:when test="$value='2'">110027</xsl:when><!--����֤                    -->
			<xsl:otherwise>119999</xsl:otherwise> <!-- ���� -->
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>