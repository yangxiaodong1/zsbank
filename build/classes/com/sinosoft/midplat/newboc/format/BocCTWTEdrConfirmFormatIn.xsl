<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="InsuReq">
		<TranData>
			<xsl:apply-templates select="Main" />
			<Body>
				<!-- ��ȫ���� -->
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
						<CertifyType>1</CertifyType>
						<!-- ��֤����(��ȫ���������) --><!--ȷ�Ͻ���ʱΪ������-->
						<CertifyName></CertifyName>
						<!-- ��֤ӡˢ��(1-��ȫ���������)--><!--ȷ�Ͻ���ʱΪ������-->
						<CertifyCode>
							<xsl:value-of select="Main/EndorseNo" />
						</CertifyCode>
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
				<!--  ���� -->
				<PubContInfo>
					<!-- ���н�������(��̨/����),0=����ͨ��1=������8=�����ն�,����Ĭ��Ϊ0-->
					<SourceType>
						<xsl:apply-templates select="Main/Channel" />
					</SourceType>
					<!-- ���ͱ�־:0��1��--><!--������-->
					<RepeatType></RepeatType>
					<!-- ���յ����� --><!--������ -->
					<ContNo>
						<xsl:value-of select="Main/PolicyNo" />
					</ContNo>
					<!-- Ͷ����ӡˢ���� -->
					<PrtNo></PrtNo>
					<!-- �������� -->
					<ContNoPSW></ContNoPSW>
					<!-- ���ղ�Ʒ���� �����գ�-->
					<RiskCode></RiskCode>
					<!-- Ͷ����֤������ -->
					<AppntIDType>
						<xsl:call-template name="tran_IDType">
							<xsl:with-param name="idtype">
								<xsl:value-of select="Appnt/IDType" />
							</xsl:with-param>
						</xsl:call-template>
					</AppntIDType>
					<!-- Ͷ����֤������ -->
					<AppntIDNo>
						<xsl:value-of select="Appnt/IDNo" />
					</AppntIDNo>
					<!-- Ͷ�������� -->
					<AppntName>
						<xsl:value-of select="Appnt/Name" />
					</AppntName>
					<!-- Ͷ����֤����Ч��ֹ���� -->
					<AppntIdTypeEndDate></AppntIdTypeEndDate>
					<!-- Ͷ����סլ�绰 (Ͷ������ϵ�绰) -->
					<AppntPhone></AppntPhone>
					<!-- ������֤������ -->
					<InsuredIDType>
						<xsl:call-template name="tran_IDType">
							<xsl:with-param name="idtype">
								<xsl:value-of select="Appnt/IDType" />
							</xsl:with-param>
						</xsl:call-template>
					</InsuredIDType>
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
						<xsl:value-of select="Appnt/PayAcc" />
					</BankAccNo>
					<!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->
					<BankAccName>
						<xsl:value-of select="Appnt/Name" />
					</BankAccName>
					<!-- ��ȫ�������� -->
					<EdorType>WT</EdorType>
					<!-- ��ѯ=1��ȷ��=2��־ -->
					<EdorFlag>2</EdorFlag>
					<!-- �˹�������־���˹�����=1��ֱ����Ч=0��ȷ��ʱ��1����ѯʱ��0 -->
					<!-- Ŀǰ���н�֧�������˱���Ӱ�����˲���Ӱ��ֱ����Ч -->
					<ExamFlag>0</ExamFlag>
				</PubContInfo>
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����ͷ��Ϣ -->
	<xsl:template name="Head" match="Main">
		<Head>
			<!-- ��������[yyyyMMdd] -->
			<TranDate>
				<xsl:value-of select="TranDate" />
			</TranDate>
			<!-- ����ʱ��[hhmmss] -->
			<TranTime>
				<xsl:value-of select="TranTime" />
			</TranTime>
			<!-- ������ -->
			<FuncFlag>1008</FuncFlag>
			<!-- ���չ�˾���� -->
			<InsuId>
				<xsl:value-of select="InsuId" />
			</InsuId>
			<!-- ��Ա���� -->
			<TellerNo>
				<xsl:value-of select="TellerNo" />
			</TellerNo>
			<!-- ������ˮ�� -->
			<TranNo>
				<xsl:value-of select="TransNo" />
			</TranNo>
			<!-- ������+������ -->
			<NodeNo>
				<xsl:value-of select="ZoneNo" />
				<xsl:value-of select="BrNo" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>
	<!-- ֤������ת�� -->
	<xsl:template name="tran_IDType">
		<xsl:param name="idtype">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$idtype='01'">0</xsl:when><!-- �������֤ -->
			<xsl:when test="$idtype='02'">8</xsl:when><!-- ��ʱ���֤ -->
			<xsl:when test="$idtype='03'">5</xsl:when><!-- ���ڲ� -->
			<xsl:when test="$idtype='04'">2</xsl:when><!-- �������֤ -->
			<xsl:when test="$idtype='05'">8</xsl:when><!-- �侯֤ -->
			<xsl:when test="$idtype='06'">8</xsl:when><!-- ʿ��֤ -->
			<xsl:when test="$idtype='07'">8</xsl:when><!-- ��ְ�ɲ�֤ -->
			<xsl:when test="$idtype='08'">1</xsl:when><!-- ������� -->
			<xsl:when test="$idtype='09'">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test="$idtype='10'">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test="$idtype='11'">7</xsl:when><!-- ̨�����������½ͨ��֤ -->
			<xsl:when test="$idtype='12'">8</xsl:when><!-- ��������֤ -->
			<xsl:when test="$idtype='13'">1</xsl:when><!-- �й����� -->
			<xsl:when test="$idtype='14'">8</xsl:when><!-- ��������þ���֤ -->
			<xsl:when test="$idtype='15'">8</xsl:when><!-- ����ѧԱ֤ -->
			<xsl:when test="$idtype='16'">8</xsl:when><!-- ����ѧԱ֤ -->
			<xsl:when test="$idtype='17'">8</xsl:when><!-- ������뾳ͨ��֤ -->
			<xsl:when test="$idtype='18'">8</xsl:when><!-- ����ίԱ��֤�� -->
			<xsl:when test="$idtype='19'">8</xsl:when><!-- ѧ��֤ -->
			<xsl:when test="$idtype='20'">8</xsl:when><!-- ���� -->
			<xsl:when test="$idtype='21'">1</xsl:when><!-- ���� -->
			<xsl:when test="$idtype='22'">8</xsl:when><!-- �۰�̨ͬ������֤ -->
		</xsl:choose>
	</xsl:template>
	<!-- �������� -->
	<xsl:template match="Channel">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">1</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>