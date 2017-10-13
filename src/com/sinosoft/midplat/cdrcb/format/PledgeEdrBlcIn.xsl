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
			         <WTBlcType>0</WTBlcType>
					   <!--  ���ڣ����ˣ�1=���ˣ�0=������-->
			         <MQBlcType>0</MQBlcType>
					   <!--  ���ڣ����ˣ�1=���ˣ�0=������-->
			         <XQBlcType>0</XQBlcType>
					 <!--  �޸Ŀͻ���Ϣ�����ˣ�1=���ˣ�0=������-->
					 <CABlcType>0</CABlcType>
					 <!--  ���֣����ˣ�1=���ˣ�0=������-->
			       	 <PNBlcType>0</PNBlcType>
			       	 <!-- ��Ѻ����(����)�����ˣ�1=���ˣ�0=������ -->
					 <BLBlcType>1</BLBlcType>
					 <!-- ��Ѻ����(�ⶳ)�����ˣ�1=���ˣ�0=������ -->
					 <BDBlcType>1</BDBlcType>
      			</PubContInfo>			
				<xsl:for-each
					select="//Detail[Column[6] ='01']"><!-- ȡ����ɹ������� -->
					<Detail>
						<!--  ������ˮ��  -->
						<TranNo>
							<xsl:value-of select="Column[3]" />
						</TranNo>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="Column[9]" /><xsl:value-of select="Column[10]" />
						</NodeNo>
						<BankCode>15</BankCode> <!-- ���д��� --> 
						<EdorType>
							<xsl:call-template name="tran_edorType">
								<xsl:with-param name="edorType" select="Column[5]" />
							</xsl:call-template>
						</EdorType>  <!-- ��ȫ�������� -->
						<EdorAppNo></EdorAppNo> <!-- ��ȫ��������� -->
						<EdorNo></EdorNo> <!-- ��ȫ��������[�Ǳ���] -->
						<EdorAppDate><xsl:value-of select="Column[1]" /></EdorAppDate> <!-- ��ȫ������������ YYYYMMDD-->
						<ContNo><xsl:value-of select="Column[2]" /></ContNo> <!-- ������ -->
						<RiskCode></RiskCode> <!-- ���ִ���[�Ǳ���]������������յ� -->
						<TranMoney></TranMoney> <!-- ���׽�� ��λ���֣�1000000�ִ���10000Ԫ-->
						<AccNo><xsl:value-of select="Column[7]" /></AccNo> <!-- �����˻�[�Ǳ���] -->
						<AccName><xsl:value-of select="Column[8]" /></AccName> <!-- �˻�����[�Ǳ���] -->
						<RCode>0</RCode> <!-- ��Ӧ�� 0�ɹ���1ʧ��-->
						<SourceType>z</SourceType><!-- z-ֱ������ -->							
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	<!-- �������� -->
	<xsl:template name="tran_edorType">
		<xsl:param name="edorType" />
		<xsl:choose>
			<xsl:when test="$edorType='1'">BL</xsl:when> <!-- ���� -->
			<xsl:when test="$edorType='2'">BD</xsl:when> <!-- �ⶳ -->			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>