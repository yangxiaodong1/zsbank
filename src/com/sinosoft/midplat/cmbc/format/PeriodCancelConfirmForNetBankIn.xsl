<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="HESITATE">
		<TranData>
			<Head>
				<TranDate>
					<xsl:value-of select="MAIN/TRANSRDATE" />
				</TranDate>
				<!-- ����ʱ�� ��hhmmss��-->
				<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(MAIN/TRANSRTIME)"/></TranTime>
				<!-- ��Ա-->
				<TellerNo>sys</TellerNo>
				<!-- ��ˮ��-->
				<TranNo>
					<xsl:value-of select="MAIN/TRANSRNO" />
				</TranNo>
				<!-- ������+������-->
				<NodeNo>
					<xsl:value-of select="MAIN/BRNO1" />
					<xsl:value-of select="MAIN/BRNO" />
				</NodeNo>
				<!-- ���б�ţ����Ķ��壩-->
				<BankCode>
					<xsl:value-of select="Head/TranCom/@outcode" />
				</BankCode>
				<xsl:copy-of select="Head/*" />
				<!-- �������� -->
				<SourceType>1</SourceType>
			</Head>

			<Body>
			    <!-- ��ȫ���� -->	
				<PubEdorInfo>  
		           <!-- �����˱�����[yyyy-MM-dd]-->		  <!--������-->
		           <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></EdorAppDate>                  
   	 	           <!-- ����������-->			          <!--������-->
   	 	           <EdorAppName></EdorAppName>                             		
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
			      <ContNo><xsl:value-of select="MAIN/POLICY_NO" /></ContNo>
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
					 	   <xsl:value-of select="TBR/TBR_IDTYPE"/>
				        </xsl:with-param>
				     </xsl:call-template>
			      </AppntIDType>
			      <!-- Ͷ����֤������ -->
			      <AppntIDNo><xsl:value-of select="TBR/TBR_IDNO" /></AppntIDNo>
			      <!-- Ͷ�������� -->
			      <AppntName><xsl:value-of select="TBR/TBR_NAME" /></AppntName>
			      <!-- Ͷ����֤����Ч��ֹ���� -->
			      <AppntIdTypeEndDate></AppntIdTypeEndDate>
			      <!-- Ͷ����סլ�绰 (Ͷ������ϵ�绰) -->
			      <AppntPhone></AppntPhone>
			      <!-- ������֤������ -->
			      <InsuredIDType>
			         <xsl:call-template name="tran_IDType">
					    <xsl:with-param name="idtype">
					 	   <xsl:value-of select="BBR/BBR_IDTYPE"/>
				        </xsl:with-param>
				     </xsl:call-template>
			      </InsuredIDType>
			      <!-- ������֤������ -->
			      <InsuredIDNo><xsl:value-of select="BBR/BBR_IDNO" /></InsuredIDNo>
			      <!-- ���������� -->
			      <InsuredName><xsl:value-of select="BBR/BBR_NAME" /></InsuredName>
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
			      <BankAccNo><xsl:value-of select="MAIN/CARD_NO" /></BankAccNo>
			      <!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->
			      <BankAccName><xsl:value-of select="MAIN/CARD_OW_NAME" /></BankAccName>
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

    <!-- �������� -->
	<xsl:template match="SOURCETYPE">
		<xsl:choose>
			<xsl:when test=".='1103'">17</xsl:when><!-- �ֻ� -->
			<xsl:when test=".='1101'">1</xsl:when><!-- ���� -->
		</xsl:choose>
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
</xsl:stylesheet>