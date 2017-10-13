<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<!-- ����ͷ -->
			<Head>
				<xsl:copy-of select="//Head/*" />  <!-- ��ָ���еİ�ͷ��Ϣ�𣿣� -->
            </Head>
			<!-- ������ -->
			<Body>
				<xsl:copy-of select="//Body/*" />
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- ����ͷ��Ϣ -->
	<xsl:template name="Head" match="Head">
		<!-- ����ͷ -->
		   <!-- ��������[yyyyMMdd] -->
              <TranDate>
                 <xsl:value-of select="TranDate" />
              </TranDate>
              <!-- ����ʱ��[hhmmss] -->
              <TranTime>
                 <xsl:value-of select="TranTime" />
              </TranTime>
              <!-- �������루����Ϊ�ղ���ֵ��-->
              <ZoneNo>
                 <xsl:value-of select="ZoneNo" />
              </ZoneNo>
              <!-- �������� -->
              <NodeNo>
                  <xsl:value-of select="NodeNo" />
              </NodeNo>
              <!-- ��Ա���� -->
              <TellerNo>
                  <xsl:value-of select="TellerNo" />
              </TellerNo>
              <!-- ������ˮ�� -->
              <TranNo>
                  <xsl:value-of select="TranNo" />
              </TranNo>
              <!-- ����������0-���� 1- ���� 17-�ֻ����� --> 
              <SourceType >
                 <xsl:value-of select="SourceType" />
              </SourceType>
              <xsl:copy-of select="FuncFlag" />
		      <xsl:copy-of select="ClientIp" />
		      <xsl:copy-of select="TranCom" />
		      <BankCode>
                <xsl:value-of select="TranCom/@outcode" /> <!-- ����/@��д������ɶ���� TranCom/@outcode�������ô���ص���  -->
              </BankCode>
		      
	</xsl:template>
	
	<!-- ��������Ϣ -->
	<xsl:template name="Body" match="Body">
		<!-- ������ -->
			<!-- ���յ���,������ -->
			<ContNo>
				<xsl:value-of select="ContNo" />
			</ContNo>
			<!-- Ͷ����(ӡˢ)�ţ��Ǳ����� -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo" />
			</ProposalPrtNo> 
			<!-- ��ȫ���ͣ��Ǳ����� -->
			<EdorType>
				<xsl:value-of select="EdorType" /> <!-- �����ȫ�����Ǽ���������� -->
			</EdorType>
	</xsl:template>
	
	<!-- ��ȫ���� -->
	<xsl:template name="Edor_Type" match="Edor_Type">
		<xsl:choose>
			<xsl:when test=".=CT">�˱�    </xsl:when>
			<xsl:when test=".=MQ">����    </xsl:when>
			<xsl:when test=".=XQ">����    </xsl:when>
			<xsl:when test=".=WT">����    </xsl:when>
			<xsl:when test=".=PN">����    </xsl:when>
			<xsl:when test=".=CA">�޸Ŀͻ���Ϣ</xsl:when>
			<xsl:when test=".=BL">������Ѻ����</xsl:when>
			<xsl:when test=".=BD">������Ѻ�ⶳ</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
