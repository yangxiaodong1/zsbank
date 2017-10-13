<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
<xsl:template match="/">

  <TranData>
	 <xsl:apply-templates select="TranData/Head" />
	 <xsl:apply-templates select="TranData/Body" /> 												
  </TranData>

</xsl:template>

	<!-- ����ͷ -->
	<xsl:template name="Head" match="Head">
		<Head>
			<!-- �������ڣ�yyyymmdd�� -->
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<!-- ����ʱ�� ��hhmmss��-->
			<TranTime>
				<xsl:value-of select="TRANSRTIME" />
			</TranTime>
			<!-- ��Ա-->
			<TellerNo>sys</TellerNo>
			<!-- ��ˮ��-->
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<!-- ������+������-->
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<!-- ���б�ţ����Ķ��壩-->
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<SourceType>1</SourceType><!-- 0=����ͨ���桢1=������8=�����ն� -->
			<xsl:copy-of select="../Head/*" />
		</Head>
</xsl:template>	


<xsl:template name="Body" match="Body" >
	<Body>
		<!-- ������Ϣ�����ڵ� -->
		<PubContInfo>
			<!-- ���н�������(0-��ͳ����ͨ��1-������8-�����նˡ�17-�ֻ�)��������ʱδ�ṩ-->
			<SourceType>1</SourceType>
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType></RepeatType>
			<!-- ���յ����� --><!--������ -->
			<ContNo><xsl:value-of select="ContNo" /></ContNo>
			<!-- ����ӡˢ���� -->
			<PrtNo></PrtNo>
			<!-- �������� -->
			<ContNoPSW></ContNoPSW>
			<!-- ���ղ�Ʒ���� �����գ�-->
			<RiskCode><xsl:apply-templates select="RiskCode" /></RiskCode>
			<!-- Ͷ����֤������ -->
			<AppntIDType><xsl:apply-templates select="AppntIDType" /></AppntIDType>
			<!-- Ͷ����֤������ -->
			<AppntIDNo><xsl:value-of select="AppntIDNo" /></AppntIDNo>
			 <!-- Ͷ�������� -->
			<AppntName><xsl:value-of select="AppntName" /></AppntName>
			<!-- Ͷ����֤����Ч��ֹ���� -->
			<AppntIdTypeEndDate></AppntIdTypeEndDate>
			<!-- Ͷ����סլ�绰 (Ͷ������ϵ�绰) -->
	 	 	<AppntPhone></AppntPhone>
			<!-- ������֤������ -->
			 <InsuredIDType></InsuredIDType>
			<!-- ������֤������ -->
			<InsuredIDNo></InsuredIDNo>
			 <!-- ���������� -->
			<InsuredName></InsuredName>
			<!-- ������֤����Ч��ֹ���� -->
			<InsuredIdTypeEndDate></InsuredIdTypeEndDate>
			<!-- ������סլ�绰 (Ͷ������ϵ�绰) -->
			<InsuredPhone></InsuredPhone>
			<!-- Ͷ���˹�ϵ���� -->
			<RelationRoleCode1></RelationRoleCode1>
			<!-- Ͷ���˹�ϵ -->
			<RelationRoleName1></RelationRoleName1>
			<!-- �����˹�ϵ���� -->
			<RelationRoleCode2></RelationRoleCode2>
			<!-- �����˹�ϵ -->
			<RelationRoleName2></RelationRoleName2>
			<!-- �ո��ѷ�ʽ(09-�޿�֧��) Ĭ��Ϊ7=����ת��(�Ʒ���) --><!-- ȷ�Ͻ���ʱΪ������ -->
			<PayMode>7</PayMode>
			<!-- �ո������б��--><!-- ȷ�Ͻ���ʱΪ������ -->
			<PayGetBankCode></PayGetBankCode>
			<!-- �ո�����������  ʡ �� ����--><!-- ȷ�Ͻ���ʱΪ������ -->
			<BankName></BankName>
			<!-- ���˷��ʻ��ʺ�--><!-- ȷ�Ͻ���ʱΪ������ -->
			<BankAccNo><xsl:value-of select="BankAccNo" /></BankAccNo>
			<!-- ���˷��ʻ�����--><!-- ȷ�Ͻ���ʱΪ������ -->
			<BankAccName><xsl:value-of select="BankAccName" /></BankAccName>
			<!--�����֤������ -->
			<BankAccIDType></BankAccIDType>
			<!--�����֤���� -->
			<BankAccIDNo></BankAccIDNo>
			<!-- ҵ������: CT=�˱���WT=���ˣ�CA=�޸Ŀͻ���Ϣ��MQ=���ڣ�XQ=����, PJ=��� -->
			<EdorType>PJ</EdorType>
			<!-- ��ѯ=1;ȷ��=2 -->
			<EdorFlag>2</EdorFlag>
		</PubContInfo>
		
		<!-- ��ȫ��Ϣ�����ڵ� -->
		<PubEdorInfo>
			<!-- �����˱�����[yyyy-MM-dd] -->
			<EdorAppDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
			</EdorAppDate>
			<!-- ����������-->
			<EdorAppName><xsl:value-of select="AppntName" /></EdorAppName>
			<Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) -->	<!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyType>1</CertifyType>                        	
				<!-- ��֤����(��ȫ���������) -->	    	<!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyName></CertifyName>           	
				<!-- ��֤ӡˢ��(1-��ȫ���������)-->		<!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyCode></CertifyCode>
			</Certify>
		</PubEdorInfo>
		
		<!-- ���ֱ�ȫ�� -->
		<EdorPJInfo>
			<!-- �����,���Ľ��ĵ�λ�Ƿ֣����еĽ�λ��Ԫ -->
			<LoanMoney><xsl:value-of select="LoanMoney" /></LoanMoney>
		</EdorPJInfo>
	</Body>
</xsl:template>


<!-- ���ִ���-->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='L12079'">L12098</xsl:when>	<!-- ����ʢ��2���������գ������ͣ����ò�Ʒ����ֻ��������㷢��ʢ2  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤������-->
	<xsl:template match="AppntIDType">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when>	<!-- ���֤ -->
			<xsl:when test=".=1">1</xsl:when>	<!-- ���� -->
			<xsl:when test=".=2">2</xsl:when>	<!-- ����֤ -->
			<xsl:when test=".=3">3</xsl:when>	<!-- ���� -->
			<xsl:when test=".=4">4</xsl:when>	<!-- ����֤�� -->
			<xsl:when test=".=5">5</xsl:when>	<!-- ���ڲ�  -->
			<xsl:when test=".=9">9</xsl:when>	<!-- �쳣���֤  -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
