<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<!-- ������ -->
			<Body>
				<PubContInfo>
					 <!--����-->
			         <EdorFlag>8</EdorFlag>
					   <!-- �˱������ˣ�1=���ˣ�0=������-->
			         <CTBlcType>0</CTBlcType>
					   <!--  ���ˣ��˶��ˣ�1=���ˣ�0=������-->
			         <WTBlcType>1</WTBlcType>
					   <!--  ���ڣ����ˣ�1=���ˣ�0=������-->
			         <MQBlcType>0</MQBlcType>
					   <!--  ���ڣ����ˣ�1=���ˣ�0=������-->
			         <XQBlcType>0</XQBlcType>
					 <!--  �޸Ŀͻ���Ϣ�����ˣ�1=���ˣ�0=������-->
					 <CABlcType>0</CABlcType>
					 <!--  ���֣����ˣ�1=���ˣ�0=������-->
			       	 <PNBlcType>0</PNBlcType>
      			</PubContInfo>			
				<!-- ȥ�����У�����Ϊ������ -->
				<xsl:for-each
					select="//Detail[LineNum !='0']">
					<Detail>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="Column[8]" />
						</TranNo>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="Column[3]" /><xsl:value-of select="Column[4]" />
						</NodeNo>
						<BankCode>12</BankCode> <!-- ���д��� --> 
						<EdorType>
							<xsl:call-template name="tran_edorType">
								<xsl:with-param name="edorType" select="Column[2]" />
							</xsl:call-template>
						</EdorType>  <!-- ��ȫ�������� -->
						<EdorAppNo></EdorAppNo> <!-- ��ȫ��������� -->
						<EdorNo><xsl:value-of select="Column[15]" /></EdorNo> <!-- ��ȫ��������[�Ǳ���] -->
						<EdorAppDate><xsl:value-of select="Column[5]" /></EdorAppDate> <!-- ��ȫ������������ YYYYMMDD-->
						<ContNo><xsl:value-of select="Column[14]" /></ContNo> <!-- ������ -->
						<RiskCode></RiskCode> <!-- ���ִ���[�Ǳ���]������������յ� -->
						<TranMoney>
							<xsl:value-of
								select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[23])" />
						</TranMoney> <!-- ���׽�� ��λ���֣�1000000�ִ���10000Ԫ-->
						<AccNo><xsl:value-of select="Column[20]" /></AccNo> <!-- �����˻�[�Ǳ���] -->
						<AccName><xsl:value-of select="Column[16]" /></AccName> <!-- �˻�����[�Ǳ���] -->
						<RCode>0</RCode> <!-- ��Ӧ�� 0�ɹ���1ʧ��-->
						<SourceType>
							<xsl:call-template name="tran_sourceType">
								<xsl:with-param name="sourceType" select="Column[24]" />
							</xsl:call-template>
						</SourceType>							
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	<!-- ���� -->
	<xsl:template name="tran_sourceType">
		<xsl:param name="sourceType" />
		<xsl:choose>
			<xsl:when test="$sourceType='00'">0</xsl:when> <!-- ���� -->
			<xsl:when test="$sourceType='21'">1</xsl:when> <!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �������� -->
	<xsl:template name="tran_edorType">
		<xsl:param name="edorType" />
		<xsl:choose>
			<xsl:when test="$edorType='B00404'">WT</xsl:when> <!-- ���� -->			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>