<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- head -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<!-- PubContInfo -->
				<xsl:apply-templates
					select="TXLife/TXLifeRequest/OLife/Holding/Policy" />
				<!-- PubEdorInfo -->
				<xsl:apply-templates
					select="TXLife/TXLifeRequest/OLife" />
				<!-- EdorCTInfo -->
				<xsl:apply-templates
					select="TXLife/TXLifeRequest/OLifeExtension" />
			</Body>
		</TranData>
	</xsl:template>


	<!-- ����ͷ��� -->
	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TransExeTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TellerCode" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

	<!-- ��ȫ���� -->
	<xsl:template name="PubEdorInfo" match="OLife">
		<PubEdorInfo>

			<!-- �����˱�����[yyyy-MM-dd]--><!--������-->
			<EdorAppDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
			</EdorAppDate>
			<!-- ����������--><!--������-->
			<EdorAppName></EdorAppName>
			<Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) --><!--ȷ�Ͻ���ʱΪ������-->
				<CertifyType>
					<xsl:apply-templates select="FormName" />
				</CertifyType>
				<!-- ��֤����(��ȫ���������) --><!--ȷ�Ͻ���ʱΪ������-->
				<CertifyName></CertifyName>
				<!-- ��֤ӡˢ��(1-��ȫ���������)-->
				<!--ȷ�Ͻ���ʱΪ������˴�Ϊ��ѯ���ף������������˱���ѯʱ���ṩ��ȫ������ţ������˱�ȷ��ʱ�ṩ�����Դ˴���ʱ�ñ��������-->
				<CertifyCode></CertifyCode>
			</Certify>
		</PubEdorInfo>
	</xsl:template>

	<!-- �˱������ֶ� -->
	<xsl:template name="EdorCTInfo" match="OLifeExtension">
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
	</xsl:template>

	<!--  ���� -->
	<xsl:template name="PubContInfo" match="Policy">
		<PubContInfo>
			<!-- ���н�������(��̨/����),0=����ͨ��1=������8=�����ն�,����Ĭ��Ϊ0-->
			<SourceType>1</SourceType>
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType></RepeatType>
			<!-- ���յ����� --><!--������ -->
			<ContNo>
				<xsl:value-of select="PolNumber" />
			</ContNo>
			<!-- Ͷ����ӡˢ���� -->
			<PrtNo></PrtNo>
			<!-- �������� -->
			<ContNoPSW></ContNoPSW>
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
			<!-- �ո��ѷ�ʽ(09-�޿�֧��) Ĭ��Ϊ7�����д���--><!--ȷ�Ͻ���ʱΪ������-->
			<PayMode>7</PayMode><!-- TODO ��Ҫ��������ȷ���Ƿ�Ӧ���Ǻ���Ĭ�� -->

			<!-- �ո������б��--><!--ȷ�Ͻ���ʱΪ������-->
			<PayGetBankCode></PayGetBankCode>
			<!-- �ո�����������  ʡ �� ����--><!--ȷ�Ͻ���ʱΪ������-->
			<BankName></BankName>
			<!-- ���˷��ʻ��ʺ�--><!--ȷ�Ͻ���ʱΪ������-->
			<BankAccNo>
				<xsl:value-of select="AccountNumber" />
			</BankAccNo>
			<!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->
			<BankAccName>
				<xsl:value-of select="AcctHolderName" />
			</BankAccName>
			<!-- ��ȫ�������� -->
	        <EdorType>CT</EdorType>
	        <!-- ��ѯ=1��ȷ��=2��־ -->
	        <EdorFlag>1</EdorFlag>
	         <!-- �˹�������־���˹�����=1��ֱ����Ч=0��ȷ��ʱ��1����ѯʱ��0 -->
	        <ExamFlag>0</ExamFlag>
		</PubContInfo>
	</xsl:template>

</xsl:stylesheet>




