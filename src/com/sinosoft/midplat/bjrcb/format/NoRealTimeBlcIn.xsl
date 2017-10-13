<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/TranData">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*"/>
			</Head>
			
			<Body>
				<!-- ע��Column��ǩ��1��ʼ���������Ǵ�0 -->
				<Count>
					<xsl:value-of select="count(Body/Detail[Column[11]='C'])" />
				</Count>
				<xsl:for-each select="Body/Detail[Column[11]='C']">
					<Detail>
						<!--�������ڣ�yyyymmdd��-->
						<TranDate>
							<xsl:value-of select="Column[3]" />
						</TranDate>
						<!--������-->
						<NodeNo>
							<xsl:value-of select="Column[4]" /><xsl:value-of select="Column[5]" />
						</NodeNo>
						<!--��Ӧ�µ����ж���ˮ��-->
						<TranNo>
							<xsl:value-of select="Column[7]" />
						</TranNo>
						<!--Ͷ������-->
						<ProposalPrtNo>
							<xsl:value-of select="Column[8]" />
						</ProposalPrtNo>
						<!--Ͷ������/����-->
						<AccNo>
							<xsl:value-of select="Column[15]" />
						</AccNo>
						<!--Ͷ��������-->
						<AppntName>
							<xsl:value-of select="Column[12]" />
						</AppntName>
						<!--Ͷ����֤������-->
						<AppntIDType>
							<xsl:call-template name="tran_idtype">
								<xsl:with-param name="idtype">
									<xsl:value-of select="Column[13]" />
								</xsl:with-param>
							</xsl:call-template>
						</AppntIDType>
						<!--Ͷ����֤����-->
						<AppntIDNo>
							<xsl:value-of select="Column[14]" />
						</AppntIDNo>
						<!--�������� ��0:���棩-->
						<SourceType>
							<xsl:value-of select="Column[10]" />
						</SourceType>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- ����֤�����ͣ�1 ���֤��2 ���ڱ���3 ����֤��4 ����֤��5 ʿ��֤��6 ��ְ�ɲ�֤��7 ���ա�8 �۰�̨ͨ��֤��9 ���� -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
			<!-- ���֤ -->
			<xsl:when test="$idtype='1'">0</xsl:when>
			<!-- ���ڱ� -->
			<xsl:when test="$idtype='2'">5</xsl:when>
			<!-- ����֤ -->
			<xsl:when test="$idtype='3'">2</xsl:when>
			<!-- ����֤ -->
			<xsl:when test="$idtype='5'">2</xsl:when>
			<!-- ���� -->
			<xsl:when test="$idtype='7'">1</xsl:when>
			<!-- ���� -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
