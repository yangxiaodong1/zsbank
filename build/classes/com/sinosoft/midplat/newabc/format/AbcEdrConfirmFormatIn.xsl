<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">


	<xsl:template match="ABCB2I">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="Header" />

			<!-- ������ -->
			<xsl:apply-templates select="App/Req" />
		</TranData>
	</xsl:template>


	<!-- Head Info -->
	<xsl:template match="Header">
		<!--������Ϣ-->
		<Head>
			<!-- ���н������� -->
			<TranDate>
				<xsl:value-of select="TransDate" />
			</TranDate>
			<!-- ����ʱ�� ũ�в�������ʱ�� ȡϵͳ��ǰʱ�� -->
			<TranTime>
				<xsl:value-of select="TransTime" />
			</TranTime>
			<!-- ��Ա���� -->
			<TellerNo>
				<xsl:value-of select="Tlid" />
			</TellerNo>
			<!-- ���н�����ˮ�� -->
			<TranNo>
				<xsl:value-of select="SerialNo" />
			</TranNo>
			<!-- ������+������ -->
			<NodeNo>
				<xsl:value-of select="ProvCode" /><xsl:value-of select="BranchNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<!-- YBT��֯�Ľڵ���Ϣ -->
			<xsl:copy-of select="../Head/*" />
			</Head>
	</xsl:template>
	
	<!-- Body Info -->
	<xsl:template match="App/Req">
		<Body>
		
			<!-- ������Ϣ�����ڵ� -->
			<PubContInfo>
				<!-- ���н�������(0-��ͳ����ͨ��1-������8-�����ն�)-->
				<SourceType></SourceType>
				<!-- ���ͱ�־:0��1��--><!--������-->
				<RepeatType></RepeatType>
				<!-- ���յ����� --><!--������ -->
				<ContNo><xsl:value-of select="PolicyNo" /></ContNo>
				<!-- ����ӡˢ���� -->
				<PrtNo><xsl:value-of select="PrintCode" /></PrtNo>
				<!-- �������� -->
				<ContNoPSW><xsl:value-of select="PolicyPwd" /></ContNoPSW>
				<!-- ���ղ�Ʒ���� �����գ�-->
				<RiskCode></RiskCode>
				<!-- Ͷ����֤������ -->
				<AppntIDType></AppntIDType>
				<!-- Ͷ����֤������ -->
				<AppntIDNo></AppntIDNo>
				 <!-- Ͷ�������� -->
				<AppntName></AppntName>
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
				<!-- �ո��ѷ�ʽ(09-�޿�֧��) Ĭ��Ϊ7=����ת��(�Ʒ���)--><!--ȷ�Ͻ���ʱΪ������-->
				<PayMode>7</PayMode>
				<!-- �ո������б��--><!--ȷ�Ͻ���ʱΪ������-->
				<PayGetBankCode></PayGetBankCode>
				<!-- �ո�����������  ʡ �� ����--><!--ȷ�Ͻ���ʱΪ������-->
				<BankName></BankName>
				<!-- ���˷��ʻ��ʺ�--><!--ȷ�Ͻ���ʱΪ������-->
				<BankAccNo><xsl:value-of select="PayAcc" /></BankAccNo>
				<!-- ���˷��ʻ�����-->
				<BankAccName />
				<!--�����֤������ -->
				<BankAccIDType />
				<!--�����֤���� -->
				<BankAccIDNo />
				<!-- ҵ������ -->
				<EdorType><xsl:apply-templates select="BusiType" /></EdorType>
				<!-- ��ѯ=1;ȷ��=2 -->
				<EdorFlag>2</EdorFlag>
			</PubContInfo>
			
			<!-- ��ȫ��Ϣ�����ڵ� -->
			<PubEdorInfo>
				<!-- �����˱�����[yyyy-MM-dd]-->
				<EdorAppDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</EdorAppDate>
				<!-- ����������-->
				<EdorAppName><xsl:value-of select="ClientName" /></EdorAppName>
				<Certify>
					<!-- ��֤����( 1-��ȫ������ 9-����) -->	<!--ȷ�Ͻ���ʱΪ������-->
					<CertifyType></CertifyType>                        	
					<!-- ��֤����(��ȫ���������) -->	    	<!--ȷ�Ͻ���ʱΪ������-->
					<CertifyName></CertifyName>           	
					<!-- ��֤ӡˢ��(1-��ȫ���������)-->		<!--ȷ�Ͻ���ʱΪ������-->
					<CertifyCode />
				</Certify>
			</PubEdorInfo>
			
			<!-- �˱������ֶ� -->
			<EdorCTInfo>
				<!-- �˱�ԭ����� -->
				<EdorReasonCode></EdorReasonCode>
				<!-- �˱�ԭ�� -->
				<EdorReason></EdorReason>
				<!-- �Ƿ��ύ���л����񹲺͹��м���֤�����������Ͻ���ȡ֤��Y��N�� -->
				<CertificateIndicator></CertificateIndicator>
				<!-- ���ڱ��շѷ�Ʊ��ʧ Y��N�� -->
				<LostVoucherIndicator></LostVoucherIndicator>
			</EdorCTInfo>
		</Body>
	</xsl:template>
		
	
	<!-- ҵ������ת�� -->
	<xsl:template name="tran_BusiType" match="BusiType">
		<xsl:choose>
			<xsl:when test=".=01">WT</xsl:when>	<!-- ��ԥ���˱� -->
			<xsl:when test=".=02">MQ</xsl:when>	<!-- ���ڸ��� -->
			<xsl:when test=".=03">CT</xsl:when>	<!-- �˱� -->
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>


	

