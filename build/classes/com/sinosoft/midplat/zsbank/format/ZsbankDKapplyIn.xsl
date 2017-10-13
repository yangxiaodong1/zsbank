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
                 <xsl:value-of select="TranCom/@outcode" />
            </BankCode>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Body" match="Body" >	
		<!-- ���յ���-->
		<ContNo>
			<xsl:value-of select="ContNo"/>
		</ContNo>
		<!-- ���ִ��� -->
		<RiskCode>
			<xsl:apply-templates select="PRODUCTID"  mode="risk"/>
		</RiskCode>
		<!-- ��������[yyyyMMdd] -->
		<EdorAppDate>
			<xsl:value-of select="EdorAppDate"/>
		</EdorAppDate>
		<!-- ����� -->
		<EdorAppNo>
			<xsl:value-of select="EdorAppNo"/>
		</EdorAppNo>
		<!-- Ͷ����֤������ -->
		<AppntIDType>
			<xsl:apply-templates select="GovtIDTC"/>
		</AppntIDType>
		<!-- Ͷ����֤������ -->
		<AppntIDNo>
			<xsl:value-of select="AppntIDNo"/>
		</AppntIDNo>
		<!-- Ͷ�������� -->
		<AppntName>
			<xsl:value-of select="AppntName"/>
		</AppntName>
		<!-- �����˻� -->
		<BankAccNo>
			<xsl:value-of select="BankAccNo"/>
		</BankAccNo>
		<!-- �����˻��� -->
		<BankAccName>
			<xsl:value-of select="BankAccName"/>
		</BankAccName>
		<!-- ������,��λ�Ƿ� -->
		<LoanMoney>
			<xsl:value-of select="LoanMoney"/>
		</LoanMoney>
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
	
	<!-- ���ִ��� -->
	<xsl:template match="PRODUCTID" mode="risk">
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<!-- xsl:when test=".='122010'">L12078</xsl:when>  --><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='122012'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='50002'">50015</xsl:when>  <!-- �������Ӯ���ռƻ�  -->
			<xsl:when test=".='L12080'">L12080</xsl:when>  <!-- ����ʢ��1���������գ������ͣ� -->
			<!--<xsl:when test=".='L12089'">L12089</xsl:when>-->  <!-- ����ʢ��1���������գ������ͣ�B�� -->
			<xsl:when test=".='L12074'">L12074</xsl:when>  <!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ� ���� -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ� ���� -->
            <xsl:when test=".='L12088'">L12088</xsl:when><!-- �����9����ȫ���գ������ͣ� ���� -->
            <xsl:when test=".='L12091'">L12091</xsl:when><!-- �����Ӯ1�������A��-->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>		
</xsl:stylesheet>


	

