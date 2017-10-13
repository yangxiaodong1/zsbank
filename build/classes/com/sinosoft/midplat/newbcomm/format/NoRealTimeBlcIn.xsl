<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<!-- ������ -->
			<Body>
				<!-- �ɹ�������Լ���� -->
				<Count>
					<xsl:value-of
						select="count(//Detail[LineNum !='0'])" />
				</Count>				
				<!-- ȥ�����У�����Ϊ������ -->
				<xsl:for-each
					select="//Detail[LineNum !='0']">
					<Detail>
						<!--  �������ڣ�YYYYMMDD�� -->
						<TranDate>
							<xsl:value-of select="Column[5]" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="Column[3]" /><xsl:value-of select="Column[4]" />
						</NodeNo>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="Column[8]" />
						</TranNo>
						<!-- Ͷ������ -->
         				<ProposalPrtNo><xsl:value-of select="Column[13]" /></ProposalPrtNo>
						<!-- ���ڱ����˻� -->
         				<AccNo><xsl:value-of select="Column[20]" /></AccNo>
						<!-- Ͷ�������� -->
         				<AppntName><xsl:value-of select="Column[16]" /></AppntName>
						<!-- Ͷ����֤������ -->
         				<AppntIDType>
         				<xsl:call-template name="tran_idType">
								<xsl:with-param name="idType" select="Column[17]" />
							</xsl:call-template>
         				</AppntIDType>
						<!-- Ͷ���˺��� -->
         				<AppntIDNo><xsl:value-of select="Column[18]" /></AppntIDNo>						
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	
	<!-- ֤������ -->
	<xsl:template name="tran_idType">
		<xsl:param name="idType" />
		<xsl:choose>
			<xsl:when test="$idType='0101'">0</xsl:when> <!-- ���֤ -->
			<xsl:when test="$idType='0102'">0</xsl:when> <!-- ���֤ -->
			<xsl:when test="$idType='0200'">0</xsl:when> <!-- ���֤ -->
			<xsl:when test="$idType='0300'">5</xsl:when> <!-- ���ڲ� -->
			<xsl:when test="$idType='0301'">8</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='0400'">5</xsl:when> <!-- ���ڲ� -->
			<xsl:when test="$idType='0601'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test="$idType='0604'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test="$idType='0700'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test="$idType='0701'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test="$idType='0800'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test="$idType='1000'">1</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='1100'">8</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='1110'">8</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='1111'">8</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='1112'">8</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='1113'">8</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='1114'">8</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='1120'">8</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='1121'">6</xsl:when> <!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test="$idType='1122'">6</xsl:when> <!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test="$idType='1123'">7</xsl:when> <!-- ̨�����������½ͨ��֤ -->
			<xsl:when test="$idType='1300'">8</xsl:when> <!-- ���� -->
			<xsl:when test="$idType='9999'">8</xsl:when> <!-- ���� -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>