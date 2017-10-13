<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
		    <!-- ����ͷ -->
			<Head>
				<xsl:apply-templates select="Head" />
            </Head>
			<!-- ������ -->
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Headinfo" match="Head">
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
               <xsl:value-of select="//Head/NodeNo" />
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
	
	<!-- ������ -->
	<xsl:template name="Bodyinfo" match="Body" >	
		<!-- ���յ��ţ������� -->
		<ContNo>
			<xsl:value-of select="ContNo"/>
		</ContNo>
		<!-- ��������[yyyyMMdd]�������� -->
		<EdorAppDate>
			<xsl:value-of select="EdorAppDate"/>
		</EdorAppDate>
		<!-- Ͷ����֤�����ͣ������� -->
		<AppntIDType>
			<xsl:apply-templates select="GovtIDTC"/>
		</AppntIDType>
		<!-- Ͷ����֤�����룬������ -->
		<AppntIDNo>
			<xsl:value-of select="AppntIDNo"/>
		</AppntIDNo>
		<!-- Ͷ���������������� -->
		<AppntName>
			<xsl:value-of select="AppntName"/>
		</AppntName>
		<!-- ������֤�����ͣ������� -->
		<InsuredIDType>
			<xsl:apply-templates select="GovtIDTC"/>
		</InsuredIDType>
		<!-- ������֤�����룬������ -->
		<InsuredIDNo>
			<xsl:value-of select="InsuredIDNo"/>
		</InsuredIDNo>
		<!-- ������������������ -->
		<InsuredName>
			<xsl:value-of select="InsuredName"/>
		</InsuredName>
		<!-- ��������� -->
		<BankAccNo>
			<xsl:value-of select="BankAccNo"/>
		</BankAccNo>
		<!-- ������˺� -->
		<BankAccName >
			<xsl:value-of select="BankAccName"/>
		</BankAccName>
	</xsl:template>
		
	
	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template name="GovtIDTC" match="GovtIDTC">
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


	

