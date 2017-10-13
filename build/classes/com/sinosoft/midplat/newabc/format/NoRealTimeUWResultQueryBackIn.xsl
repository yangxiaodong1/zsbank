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
						<!--������-->
						<ContNo>
							<xsl:value-of select="Column[9]" />
						</ContNo>
						<!-- Ͷ������(yyyyMMdd) ������������-->
						<PolApplyDate>
							<xsl:value-of select="Column[2]" />
						</PolApplyDate>
						<!-- �б�����(yyyyMMdd)-->
						<SignDate>
							<xsl:value-of select="Column[10]" />
						</SignDate>
						<!--�����ܱ���-->
						<Prem>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[15])" />
						</Prem>
						<!-- Ͷ����-->
						<Appnt>
							<!-- ���� -->
							<Name>
								<xsl:value-of select="Column[4]" />
							</Name>
							<!-- �Ա� -->
							<Sex></Sex>
							<!-- ��������(yyyyMMdd) -->
							<Birthday></Birthday>
							<!-- ֤������ -->
							<IDType>
								<xsl:call-template name="IDKind">
									<xsl:with-param name="value"
										select="Column[5]" />
								</xsl:call-template>
							</IDType>
							<!-- ֤������ -->
							<IDNo>
								<xsl:value-of select="Column[6]" />
							</IDNo>
						</Appnt>
						<!--��������Ϣ-->
						<Insured>
							<!-- ���� -->
							<Name>
								<xsl:value-of select="Column[12]" />
							</Name>
							<!-- �Ա� -->
							<Sex></Sex>
							<!-- ��������(yyyyMMdd) -->
							<Birthday></Birthday>
							<!-- ֤������ -->
							<IDType>
								<xsl:call-template name="IDKind">
									<xsl:with-param name="value"
										select="Column[13]" />
								</xsl:call-template>
							</IDType>
							<!-- ֤������ -->
							<IDNo>
								<xsl:value-of select="Column[14]" />
							</IDNo>
						</Insured>
						<!-- ���ж˴������-->
						<HandleInfo>
							<!-- �������ڣ�yyyymmdd��-->
							<TranDate></TranDate>
							<!--���ж���ˮ��-->
							<TranNo>
								<xsl:value-of select="Column[26]" />
							</TranNo>
							<!-- �Ƿ�ɹ���0�ɹ� 1ʧ�ܣ�-->
							<ResultFlag>
								<xsl:choose>
									<xsl:when test="Column[24] = '240000'">0</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</ResultFlag>
							<!-- ������-->
							<ResultCode></ResultCode>
							<!-- ��������-->
							<ResultMsg>
								<xsl:value-of select="Column[25]" />
							</ResultMsg>
							<!-- ��ע-->
							<Remark>
								<xsl:value-of select="Column[27]" />
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
</xsl:stylesheet>