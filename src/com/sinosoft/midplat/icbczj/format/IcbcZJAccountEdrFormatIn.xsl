<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
<xsl:template match="/">

	<xsl:apply-templates select="package/req" />

</xsl:template>


<xsl:template match="package/req">
 <TranData>
 	<Head>
		<TranDate><xsl:value-of select="transexedate"/></TranDate>
		<TranTime><xsl:value-of select="transexetime"/></TranTime>
		<TellerNo><xsl:value-of select="teller"/></TellerNo>
		<TranNo><xsl:value-of select="transrefguid"/></TranNo>
		<NodeNo>
			<xsl:value-of select="regioncode"/>
			<xsl:value-of select="branch"/>
		</NodeNo>
		<xsl:copy-of select="../Head/*"/>
		<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
	</Head>
	
	<Body>
		<!-- ������Ϣ�����ڵ� -->
		<PubContInfo>
			<!-- ���н�������(0-��ͳ����ͨ��1-������8-�����նˡ�17-�ֻ�)��������ʱδ�ṩ-->
			<SourceType><xsl:apply-templates select="../pub/txchan" /></SourceType>
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType></RepeatType>
			<!-- ���յ����� --><!--������ -->
			<ContNo><xsl:value-of select="polnumber" /></ContNo>
			<!-- ����ӡˢ���� -->
			<PrtNo></PrtNo>
			<!-- �������� -->
			<ContNoPSW></ContNoPSW>
			<!-- ���ղ�Ʒ���� �����գ�-->
			<RiskCode><xsl:apply-templates select="productcode" /></RiskCode>
			<!-- Ͷ����֤������ -->
			<AppntIDType><xsl:apply-templates select="govtidtc" /></AppntIDType>
			<!-- Ͷ����֤������ -->
			<AppntIDNo><xsl:value-of select="govtid" /></AppntIDNo>
			 <!-- Ͷ�������� -->
			<AppntName><xsl:value-of select="fullname" /></AppntName>
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
			<EdorAppName><xsl:value-of select="fullname" /></EdorAppName>
			<Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) -->	<!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyType>1</CertifyType>                        	
				<!-- ��֤����(��ȫ���������) -->	    	<!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyName></CertifyName>           	
				<!-- ��֤ӡˢ��(1-��ȫ���������)-->		<!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyCode></CertifyCode>
			</Certify>
		</PubEdorInfo>
		
		<EdorCAInfo> 
			<!-- �˴���Ҫע�⣬���ĵĴ���ʽΪ����������ʾ��գ���null��ʾ���в������ -->
			<!--  Ͷ���˵�ַ -->
			<AppntPostalAddress>NULL</AppntPostalAddress>
			<!-- Ͷ�����ʱ� -->     
			<AppntZipCode>NULL</AppntZipCode>
			<!-- Ͷ���˵绰�������� -->   
			<AppntPhone>NULL</AppntPhone>
			<!-- Ͷ�����ƶ��绰 -->
			<xsl:choose>
				<xsl:when test="dialnumber=''">
					<AppntMobile>NULL</AppntMobile>
				</xsl:when>
				<xsl:otherwise>
					<AppntMobile><xsl:value-of select="dialnumber" /></AppntMobile>
				</xsl:otherwise>
			</xsl:choose>
			<!-- �˻� -->
			<xsl:choose>
				<xsl:when test="accountnumber=''">
					<AccNo>NULL</AccNo>
				</xsl:when>
				<xsl:otherwise>
					<AccNo><xsl:value-of select="accountnumber" /></AccNo>
				</xsl:otherwise>
			</xsl:choose>
			<!--�����к�  -->
			<!-- <xsl:choose>
				<xsl:when test="uniquebankno=''">
					<BankCode>NULL</BankCode>
				</xsl:when>
				<xsl:otherwise>
					<BankCode><xsl:value-of select="uniquebankno" /></BankCode>
				</xsl:otherwise>
			</xsl:choose>    -->
			<BankCode>NULL</BankCode>
		</EdorCAInfo> 
	</Body>
</TranData>
</xsl:template>
<!-- ���ִ���-->
	<xsl:template match="productcode">
		<xsl:choose>
			<xsl:when test=".='008'">L12077</xsl:when>	<!-- ����ʢ��2���������գ������ͣ�  -->
			<!-- PBKINSR-1327 �㽭����������C�ʢ��9�ţ���Ŀ 2016-06-18  -->
		    <xsl:when test=".='014'">L12102</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤������-->
	<xsl:template match="govtidtc">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when>	<!-- ���֤ -->
			<xsl:when test=".=1">1</xsl:when>	<!-- ���� -->
			<xsl:when test=".=2">2</xsl:when>	<!-- ����֤ -->
			<xsl:when test=".=3">2</xsl:when>	<!-- ʿ��֤ -->
			<xsl:when test=".=5">0</xsl:when>	<!-- ��ʱ���֤ -->
			<xsl:when test=".=6">5</xsl:when>	<!-- ���ڱ�  -->
			<xsl:when test=".=9">2</xsl:when>	<!-- ����֤  -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ��������:��������(0-��ͳ����ͨ��1-������8-�����նˡ�17-�ֻ�)-->	
	<xsl:template match="txchan">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when>	<!-- ����ͨ -->
			<xsl:when test=".=1">1</xsl:when>	<!-- ���� -->
			<xsl:when test=".=8">8</xsl:when>	<!-- �����ն� -->
			<!-- �㽭�����ֻ��������õ������������������˴�����Ҫ�����ֻ����� -->
			<!-- <xsl:when test=".=5">17</xsl:when> -->	<!-- �ֻ����� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
