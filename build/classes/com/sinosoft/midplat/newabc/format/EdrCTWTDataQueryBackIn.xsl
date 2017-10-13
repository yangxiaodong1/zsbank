<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<Count>
					<xsl:value-of
						select="count(//Detail[position() > 1])" />
				</Count>
				<xsl:for-each select="//Detail[position() > 1]">
					<Detail>
						<!-- ������-->
						<ContNo>
							<xsl:value-of select="Column[3]" />
						</ContNo>
						<!-- Ͷ��������-->
						<AppntName>
							<xsl:value-of select="Column[4]" />
						</AppntName>
						<!-- Ͷ����֤������-->
						<AppntIDType>
							<xsl:call-template name="IDKind">
								<xsl:with-param name="value"
									select="Column[5]" />
							</xsl:call-template>
						</AppntIDType>
						<!-- Ͷ����֤����-->
						<AppntIDNo>
							<xsl:value-of select="Column[6]" />
						</AppntIDNo>
						<!-- ҵ������ -->
						<BusinessType>
							<xsl:call-template name="BusinessType">
								<xsl:with-param name="value"
									select="Column[9]" />
							</xsl:call-template>
						</BusinessType>
						<!-- ҵ����֣�-->
						<EdorCTPrem>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[7])" />
						</EdorCTPrem>
						<!-- ���ж˴������-->
						<HandleInfo>
							<!-- �������ڣ�yyyymmdd����Ϊ�����н����ļ�������-->
							<TranDate>
								<xsl:value-of select="Column[8]" />
							</TranDate>
							<!--���ж���ˮ��-->
							<TranNo>
								<xsl:value-of select="Column[11]" />
							</TranNo>
							<!-- �Ƿ�ɹ���0�ɹ� 1ʧ�ܣ�-->
							<ResultFlag>
								<xsl:choose>
									<xsl:when test="Column[14] = '240000'">0</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</ResultFlag>
							<!-- ������-->
							<ResultCode>
								<xsl:value-of select="Column[14]" />
							</ResultCode>
							<!-- ��������-->
							<ResultMsg>
								<xsl:value-of select="Column[15]" />
							</ResultMsg>
							<!-- ��ע-->
							<Remark>
								<xsl:value-of select="Column[16]" />
							</Remark>
						</HandleInfo>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template name="IDKind">
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$value='110001'">0</xsl:when><!--�������֤                -->
			<xsl:when test="$value='110002'">0</xsl:when><!--�غž������֤            -->
			<xsl:when test="$value='110003'">0</xsl:when><!--��ʱ�������֤            -->
			<xsl:when test="$value='110004'">0</xsl:when><!--�غ���ʱ�������֤        -->
			<xsl:when test="$value='110005'">5</xsl:when><!--���ڲ�                    -->
			<xsl:when test="$value='110006'">5</xsl:when><!--�غŻ��ڲ�                -->
			<xsl:when test="$value='110023'">1</xsl:when><!--�л����񹲺͹�����        -->
			<xsl:when test="$value='110024'">1</xsl:when><!--�غ��л����񹲺͹�����    -->
			<xsl:when test="$value='110025'">1</xsl:when><!--�������                  -->
			<xsl:when test="$value='110026'">1</xsl:when><!--�غ��������              -->
			<xsl:when test="$value='110027'">2</xsl:when><!--����֤                    -->
			<xsl:when test="$value='110028'">2</xsl:when><!--�غž���֤                -->
			<xsl:when test="$value='110029'">2</xsl:when><!--��ְ�ɲ�֤                -->
			<xsl:when test="$value='110030'">2</xsl:when><!--�غ���ְ�ɲ�֤            -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ҵ������ -->
	<xsl:template name="BusinessType">
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$value='01'">WT</xsl:when><!--�̳�  -->
			<xsl:when test="$value='02'">MQ</xsl:when><!--���ڸ���  -->
			<xsl:when test="$value='03'">CT</xsl:when><!--�˱�  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>