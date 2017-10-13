<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
		    <Head>
				<xsl:apply-templates select="TXLife/TXLifeRequest" />
			</Head>
			<Body>
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" /> 												
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="TXLifeRequest">
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
                 <xsl:value-of select="TranCom/@outcode" />
             </BankCode>
	</xsl:template>
	 
	 
	<!--  ���� -->
	<xsl:template name="Body" match="Policy" >				
		<!-- ���յ��� ,������-->
		<ContNo>
			<xsl:value-of select="ContNo" />
		</ContNo>
		<!-- Ͷ����(ӡˢ)�ţ��Ǳ����� -->
		<ProposalPrtNo>
			<xsl:value-of select="ProposalPrtNo" />
		</ProposalPrtNo>
		<!-- Ͷ��������,������ -->
		<AppntName>
			<xsl:value-of select="AppntName" />
		</AppntName> 
		<!-- ֤������,������ -->
		<AppntIDType>
			<xsl:apply-templates select="IDType"/>
		</AppntIDType >
		<!-- ֤������,������ -->
		<AppntIDNo>
			<xsl:value-of select="AppntIDNo" />
		</AppntIDNo > 		 
	</xsl:template>	
	
	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">���֤    </xsl:when>
			<xsl:when test=".=1">����      </xsl:when>
			<xsl:when test=".=2">����֤    </xsl:when>
			<xsl:when test=".=3">����      </xsl:when>
			<xsl:when test=".=4">����֤��  </xsl:when>
			<xsl:when test=".=5">���ڲ�    </xsl:when>
			<xsl:when test=".=8">����      </xsl:when>
			<xsl:when test=".=9">�쳣���֤</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>				
</xsl:stylesheet>


	

