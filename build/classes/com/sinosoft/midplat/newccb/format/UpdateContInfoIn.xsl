<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<!-- ������Ϣ�����ڵ� -->
	<PubContInfo>
		<!-- ���н�������(0-��ͳ����ͨ��1-������8-�����ն�)-->
		<SourceType>0</SourceType>
		<!-- ���ͱ�־:0��1��--><!--������-->
		<RepeatType></RepeatType>
		<!-- ���յ����� --><!--������ -->
		<ContNo><xsl:value-of select="InsPolcy_No" /></ContNo>
		<!-- ����ӡˢ���� -->
		<PrtNo></PrtNo>
		<!-- �������� -->
		<ContNoPSW><xsl:value-of select="InsPolcy_Pswd" /></ContNoPSW>
		<!-- ���ղ�Ʒ���� �����գ�-->
		<RiskCode></RiskCode>
		<!-- Ͷ����֤������ -->
		<AppntIDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Plchd_Crdt_TpCd" />
			</xsl:call-template>
		</AppntIDType>
		<!-- Ͷ����֤������ -->
		<AppntIDNo><xsl:value-of select="Plchd_Crdt_No" /></AppntIDNo>
		 <!-- Ͷ�������� -->
		<AppntName><xsl:value-of select="Plchd_Nm" /></AppntName>
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
		<!-- �ո��ѷ�ʽ(09-�޿�֧��) Ĭ��Ϊ7=����ת��(�Ʒ���)--><!-- ȷ�Ͻ���ʱΪ������ -->
		<PayMode>7</PayMode>
		<!-- �ո������б��--><!-- ȷ�Ͻ���ʱΪ������ -->
		<PayGetBankCode></PayGetBankCode>
		<!-- �ո�����������  ʡ �� ����--><!-- ȷ�Ͻ���ʱΪ������ -->
		<BankName></BankName>
		<!-- ���˷��ʻ��ʺ�--><!-- ȷ�Ͻ���ʱΪ������ -->
		<BankAccNo></BankAccNo>
		<!-- ���˷��ʻ�����--><!-- ȷ�Ͻ���ʱΪ������ -->
		<BankAccName></BankAccName>
		<!--�����֤������ -->
		<BankAccIDType></BankAccIDType>
		<!--�����֤���� -->
		<BankAccIDNo></BankAccIDNo>
		<!-- ҵ������: CT=�˱���WT=���ˣ�CA=�޸Ŀͻ���Ϣ��MQ=���ڣ�XQ=���� -->
		<EdorType>CA</EdorType>
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
		<EdorAppName><xsl:value-of select="Plchd_Nm" /></EdorAppName>
		<Certify>
			<!-- ��֤����( 1-��ȫ������ 9-����) -->	<!-- ȷ�Ͻ���ʱΪ������ -->
			<CertifyType>1</CertifyType>                        	
			<!-- ��֤����(��ȫ���������) -->	    	<!-- ȷ�Ͻ���ʱΪ������ -->
			<CertifyName></CertifyName>           	
			<!-- ��֤ӡˢ��(1-��ȫ���������)-->		<!-- ȷ�Ͻ���ʱΪ������ -->
			<CertifyCode><xsl:value-of select="Btch_Bl_Prt_No" /></CertifyCode>
		</Certify>
	</PubEdorInfo>
	
	<EdorCAInfo> 
		<!--  Ͷ���˵�ַ -->
		<AppntPostalAddress><xsl:value-of select="Plchd_Comm_Adr" /></AppntPostalAddress>
		<!-- Ͷ�����ʱ� -->     
		<AppntZipCode><xsl:value-of select="Plchd_ZipECD" /></AppntZipCode>
		<!-- Ͷ�����ƶ��绰 -->
		<AppntMobile><xsl:value-of select="Plchd_Move_TelNo" /></AppntMobile>
		<!-- Ͷ���˵绰 -->
		<xsl:if test="PlchdFixTelDmstDstcNo != '' " >
		    <AppntPhone><xsl:value-of select="PlchdFixTelDmstDstcNo" />-<xsl:value-of select="Plchd_Fix_TelNo" /></AppntPhone>
		</xsl:if>
		<xsl:if test="PlchdFixTelDmstDstcNo = '' " >
		    <AppntPhone><xsl:value-of select="Plchd_Fix_TelNo" /></AppntPhone>
		</xsl:if>
	</EdorCAInfo> 
	
</xsl:template>

<!-- ֤������ת�� -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='1010'">0</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1011'">0</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1052'">1</xsl:when>	<!-- ���� -->
		<xsl:when test="$idtype='1020'">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='1030'">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='1040'">5</xsl:when>	<!-- ���ڲ� -->
		<xsl:when test="$idtype=''">9</xsl:when>	<!-- �쳣���֤ -->
		<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
