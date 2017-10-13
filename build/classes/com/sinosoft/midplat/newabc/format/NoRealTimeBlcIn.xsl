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
					<xsl:value-of select="count(//Detail[position() > 1])" />
				</Count>
				<xsl:for-each select="//Detail[position() > 1]">
					<Detail>
						<!--  �������ڣ�8λ���ָ�ʽYYYYMMDD������Ϊ�գ� -->
						<TranDate>
							<xsl:value-of select="Column[1]" />
						</TranDate>
						<!--  �����������  (ʡ�д���+������)-->
						<NodeNo>
							<xsl:value-of select="Column[17]" />
							<xsl:value-of select="Column[18]" />
						</NodeNo>
						<!--  ����������ˮ��  -->
						<TranNo>
							<xsl:value-of select="Column[2]" />
						</TranNo>
						<!--  Ͷ������  -->
						<ProposalPrtNo>
							<xsl:value-of select="Column[8]" />
						</ProposalPrtNo>
						<!-- ���ڱ����˻� -->
						<AccNo>
							<xsl:value-of select="Column[11]" />
						</AccNo>
						<!-- Ͷ�������� -->
						<AppntName>
							<xsl:value-of select="Column[3]" />
						</AppntName>
						<!-- Ͷ����֤������ -->
						<AppntIDType>
							<xsl:call-template name="IDKind">
								<xsl:with-param name="value"
									select="Column[4]" />
							</xsl:call-template>
						</AppntIDType>
						<!-- Ͷ���˺��� -->
						<AppntIDNo>
							<xsl:value-of select="Column[5]" />
						</AppntIDNo>
						<!-- ����������Ԥ���� -->
						<SourceType>0</SourceType>
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