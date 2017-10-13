<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<xsl:apply-templates select="//OLifE/Holding/Policy" /> 
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date10to8(TransExeDate)" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TransExeTime)" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OLifEExtension/Teller" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="OLifEExtension/RegionCode" />
				<xsl:value-of select="OLifEExtension/Branch" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="OLifEExtension/BankCode" />
			</BankCode>
		</Head>
	</xsl:template>



	<!--  ���� -->
	<xsl:template name="Body" match="Holding">
		<CurrencyTypeCode>
			<xsl:value-of select="CurrencyTypeCode" />
		</CurrencyTypeCode>

	</xsl:template>

	<!--  ������Ϣ -->
	<xsl:template name="Policy" match="Policy">
		<PubContInfo>
			<!-- ���н�������(0-��ͳ����ͨ��1-������8-�����նˡ�17-�ֻ�)��������ʱδ�ṩ-->
			<SourceType>
				<xsl:value-of select="OLifEExtension/SourceType" />
				</SourceType>
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType></RepeatType>
			<!-- ���յ����� --><!--������ -->
			<ContNo>
				<xsl:value-of select="PolNumber" />
			</ContNo>
			<!-- ����ӡˢ���� -->
			<PrtNo></PrtNo>
			<!-- ����Ѻ��� -->
			<PledgeAmt>
				<xsl:value-of select="//Life/CashValueAmt" />
			</PledgeAmt>
			<!-- ������ -->
			<GrossAmt>
				<xsl:value-of
					select="//FinancialActivity/FinActivityGrossAmt" />
			</GrossAmt>

			<!-- ������ -->
			<BorrowRate>
				<xsl:value-of
					select="//FinancialActivity/FinActivityPct" />
			</BorrowRate>

			<ContNoPSW>
				<xsl:value-of select="//OLifEExtension/Password" />
			</ContNoPSW>
			<!-- Ͷ����֤������ -->
			<AppntIDType>
				<xsl:apply-templates select="//Party/GovtIDTC" />
			</AppntIDType>
			<!-- Ͷ����֤������ -->
			<AppntIDNo>
				<xsl:value-of select="//Party/GovtID" />
			</AppntIDNo>
			<!-- Ͷ�������� -->
			<AppntName>
				<xsl:value-of select="//Party/FullName" />
			</AppntName>			
			<Sex>
				<xsl:apply-templates select="//Party/Person/Gender" />
			</Sex>
			<Birthday>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date10to8(//Party/Person/BirthDate)" />
			</Birthday>
			
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
			<!-- ҵ������: CT=�˱���WT=���ˣ�CA=�޸Ŀͻ���Ϣ��MQ=���ڣ�XQ=���� BL-������Ѻ��BD-������Ѻ��� -->
			<EdorType>BD</EdorType>
			<!-- ��ѯ=1;ȷ��=2 -->
			<EdorFlag>2</EdorFlag>
		</PubContInfo>

    <!-- ��ȫ��Ϣ�����ڵ� -->
		<PubEdorInfo>
			<!-- �����˱�����[yyyy-MM-dd] -->
			<EdorAppDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(//FinancialActivity/FinActivityDate)" />
			</EdorAppDate>
			<!-- ����������-->
			<EdorAppName><xsl:value-of select="//Party/FullName" /></EdorAppName>
			<Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) --><!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyType>1</CertifyType>
				<!-- ��֤����(��ȫ���������) --><!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyName>
					<xsl:apply-templates
						select="//FormInstance/FormName" />
				</CertifyName>
				<!-- ��֤ӡˢ��(1-��ȫ���������)--><!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyCode>
					<xsl:apply-templates
						select="//FormInstance/ProviderFormNumber" />
				</CertifyCode>
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
			<AppntMobile></AppntMobile>
			<!-- �˻� -->
			<AccNo></AccNo>
			<!--�����к�  -->
			<BankCode>NULL</BankCode>

		</EdorCAInfo> 
	</xsl:template>


		 

	 
 


	<!-- �Ա� -->
	<xsl:template name="tran_sex" match="Gender">
		<xsl:choose>
			<xsl:when test=".=1">0</xsl:when><!-- �� -->
			<xsl:when test=".=2">1</xsl:when><!-- Ů -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ֤������ -->
	<xsl:template name="tran_idtype" match="GovtIDTC">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when><!-- ���֤ -->
			<xsl:when test=".=1">1</xsl:when><!-- ���� -->
			<xsl:when test=".=2">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".=3">2</xsl:when><!-- ʿ��֤ -->
			<xsl:when test=".=5">0</xsl:when><!-- ��ʱ���֤ -->
			<xsl:when test=".=6">5</xsl:when><!-- ���ڱ�  -->
			<xsl:when test=".=9">2</xsl:when><!-- ����֤  -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ��������:��������(0-��ͳ����ͨ��1-������8-�����նˡ�17-�ֻ�)-->	
	<xsl:template match="txchan">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when>	<!-- ����ͨ -->
			<xsl:when test=".=1">1</xsl:when>	<!-- ���� -->
			<xsl:when test=".=8">8</xsl:when>	<!-- �����ն� -->		
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>





