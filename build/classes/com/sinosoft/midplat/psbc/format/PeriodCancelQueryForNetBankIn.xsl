<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TRANDATA">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*" />
				<TranDate>
					<xsl:value-of select="MAIN/TRANSEXEDATE" />
				</TranDate>
				<TranTime>
					<xsl:value-of select="MAIN/TRANSEXETIME" />
				</TranTime>
				<TranNo>
					<xsl:value-of select="MAIN/TRANSREFGUID" />
				</TranNo>
				<NodeNo>
					<xsl:value-of select="MAIN/REGIONCODE" />
					<xsl:value-of select="MAIN/BRANCH" />
				</NodeNo>
				<TellerNo>
					<xsl:value-of select="MAIN/TELLER" />
				</TellerNo>
				<BankCode>
					<xsl:value-of select="Head/TranCom/@outcode" />
				</BankCode>
				<SourceType><xsl:apply-templates select="MAIN/SOURCETYPE" /></SourceType>
			</Head>

			<Body>
			    <!-- ��ȫ���� -->	
				<PubEdorInfo>  
		           <!-- �����˱�����[yyyy-MM-dd]-->		  <!--������-->
		           <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></EdorAppDate>                  
   	 	           <!-- ����������-->			          <!--������-->
   	 	           <EdorAppName><xsl:value-of select="MAIN/TBR_NAME" /></EdorAppName>                             		
		           <Certify>
				      <!-- ��֤����( 1-��ȫ������ 9-����) -->	<!--ȷ�Ͻ���ʱΪ������-->
				      <CertifyType></CertifyType>                        	
				      <!-- ��֤����(��ȫ���������) -->	    	<!--ȷ�Ͻ���ʱΪ������-->
				      <CertifyName></CertifyName>           	
				      <!-- ��֤ӡˢ��(1-��ȫ���������)-->		<!--ȷ�Ͻ���ʱΪ������-->
				      <CertifyCode></CertifyCode>             	
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
			      <SourceType>1</SourceType>
			      <!-- ���ͱ�־:0��1��--><!--������-->
			      <RepeatType></RepeatType>
			      <!-- ���յ����� --><!--������ -->
			      <ContNo><xsl:value-of select="MAIN/POLNUMBER" /></ContNo>
			      <!-- Ͷ����ӡˢ���� -->
			      <PrtNo></PrtNo>
			      <!-- �������� -->
			      <ContNoPSW></ContNoPSW>
			      <!-- ���ղ�Ʒ���� �����գ�-->
			      <RiskCode></RiskCode>
			      <!-- Ͷ����֤������ -->
			      <AppntIDType>
			          <xsl:call-template name="tran_idtype">
					    <xsl:with-param name="idtype">
						   <xsl:value-of select="MAIN/TBR_IDTYPE" />
					    </xsl:with-param>
				      </xsl:call-template>
			      </AppntIDType>
			      <!-- Ͷ����֤������ -->
			      <AppntIDNo><xsl:value-of select="MAIN/TBR_IDNO" /></AppntIDNo>
			      <!-- Ͷ�������� -->
			      <AppntName><xsl:value-of select="MAIN/TBR_NAME" /></AppntName>
			      <!-- Ͷ����֤����Ч��ֹ���� -->
			      <AppntIdTypeEndDate></AppntIdTypeEndDate>
			      <!-- Ͷ����סլ�绰 (Ͷ������ϵ�绰) -->
			      <AppntPhone><xsl:value-of select="MAIN/TBR_MOBILE" /></AppntPhone>
			      <!-- ������֤������ -->
			      <InsuredIDType>
			          <xsl:call-template name="tran_idtype">
					    <xsl:with-param name="idtype">
						   <xsl:value-of select="MAIN/BBR_IDTYPE" />
					    </xsl:with-param>
				      </xsl:call-template>
			      </InsuredIDType>
			      <!-- ������֤������ -->
			      <InsuredIDNo><xsl:value-of select="MAIN/BBR_IDNO" /></InsuredIDNo>
			      <!-- ���������� -->
			      <InsuredName><xsl:value-of select="MAIN/BBR_NAME" /></InsuredName>
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
			      <BankAccNo></BankAccNo>
			      <!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->
			      <BankAccName></BankAccName>
				  <!-- ��ȫ�������� -->
	              <EdorType>WT</EdorType>
	              <!-- ��ѯ=1��ȷ��=2��־ -->
	              <EdorFlag>1</EdorFlag>
	              <!-- �˹�������־���˹�����=1��ֱ����Ч=0��ȷ��ʱ��1����ѯʱ��0 -->
	              <ExamFlag>0</ExamFlag>
		      </PubContInfo>
		   </Body>
		</TranData>
	</xsl:template>

    <!-- �������� -->
	<xsl:template match="SOURCETYPE">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- ֤������ -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
			<xsl:when test="$idtype=1">0</xsl:when><!-- ���֤ -->
			<xsl:when test="$idtype=2">2</xsl:when><!-- ����֤ -->
			<xsl:when test="$idtype=3">1</xsl:when><!-- ���� -->
			<xsl:when test="$idtype=4">4</xsl:when><!-- ����֤ -->
			<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>