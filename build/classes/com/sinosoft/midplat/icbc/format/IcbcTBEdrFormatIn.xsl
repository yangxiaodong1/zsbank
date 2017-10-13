<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- head -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<!-- PubContInfo -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />								
				<!-- PubEdorInfo -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE" />								
   	  			<!-- EdorCTInfo -->
			    <xsl:apply-templates select="TXLife/TXLifeRequest/OLifEExtension" />															
			</Body>
		</TranData>
	</xsl:template>
	<!-- head -->
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
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>
	
	<!-- ��ȫ���� -->	
	<xsl:template name="PubEdorInfo" match="OLifE" >	
		<PubEdorInfo>  
		
		  <!-- �����˱�����[yyyy-MM-dd]-->		  <!--������-->
		  <EdorAppDate>
		 	 <xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
		  </EdorAppDate>              
   	 	  <!-- ����������-->			              <!--������-->
   	 	  <EdorAppName></EdorAppName>                             		
		    <Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) -->	<!--ȷ�Ͻ���ʱΪ������-->
				<CertifyType>
					<xsl:apply-templates select="FormName" />
				</CertifyType>                        	
				<!-- ��֤����(��ȫ���������) -->	    	<!--ȷ�Ͻ���ʱΪ������-->
				<CertifyName></CertifyName>           	
				<!-- ��֤ӡˢ��(1-��ȫ���������)-->		<!--ȷ�Ͻ���ʱΪ������-->
				<CertifyCode>
					<xsl:apply-templates select="FormInstance/ProviderFormNumber" />  
				</CertifyCode>             	
   		  </Certify>
   	  </PubEdorInfo>
	</xsl:template>
		
	<!-- �˱������ֶ� -->
	<xsl:template name="EdorCTInfo" match="OLifEExtension" >
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
	<xsl:template name="PubContInfo" match="Policy" >				
		<PubContInfo>
			<!-- ���н�������(��̨/����)-->
			<SourceType>0</SourceType><!-- TODO ������Ҫ���ֵΪ1 ����Ȼ�޷����������ף��Ѿ���������ȷ�Ϲ� -->
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType><xsl:apply-templates select="../../../RepeatType" /></RepeatType>                              
			<!-- ���յ����� --><!--������ -->
			<ContNo><xsl:value-of select="PolNumber" /></ContNo> 
			<!-- Ͷ����ӡˢ���� -->					  	 	  														  
  	 	 	<PrtNo></PrtNo>		
  	 	 	<!-- �������� -->									
  	 	 	<ContNoPSW><xsl:value-of select="OLifEExtension/Password" /></ContNoPSW>   
  	 	 	<!-- ���ղ�Ʒ���� �����գ�-->                 
  	 		<RiskCode><xsl:apply-templates select="ProductCode" /></RiskCode>   	 		   	 		   	 		  	 		
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
   	 	    <BankAccNo><xsl:apply-templates select="../../Holding/Banking/AccountNumber" /></BankAccNo>       
   	 	    <!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->                   	
   	 	    <BankAccName><xsl:apply-templates select="../../Holding/Banking/AcctHolderName" /></BankAccName>                  			
	  </PubContInfo>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_RiskCode" match="ProductCode">
	<xsl:choose>
		<xsl:when test=".=001">122001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test=".=002">122002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test=".=101">122004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test=".=003">122003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test=".=004">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test=".=005">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
		<xsl:when test=".=006">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
		<xsl:when test=".=007">122011</xsl:when>	<!-- ����ʢ��1���������գ������ͣ�  -->
		<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
		<xsl:when test=".=008">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ�  -->
		<xsl:when test=".=009">L12100</xsl:when>	<!-- ����ʢ��3���������գ������ͣ�  -->
		<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
		<xsl:when test=".=010">122029</xsl:when>	<!-- ����ʢ��5���������գ������ͣ�  -->
		<xsl:when test=".=011">122020</xsl:when>	<!-- �����6����ȫ���գ��ֺ��ͣ�  -->
		<xsl:when test=".=012">122036</xsl:when>	<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
		<!-- ��ȫ���׺���ֻ����contno��riskcode�����ģ�ǰ����50002����Ʒ������Ϊ122046�������������յĲ�ƷΪ122048,���5������˱�ʱ���Ĵ����������ֱ����122048 -->
		<xsl:when test=".=013">122046</xsl:when>	<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����  -->
		<!-- <xsl:when test=".=014">122038</xsl:when> -->	<!-- �����ֵ����8���������գ��ֺ��ͣ�A�� -->
		
		<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
		<xsl:when test=".=014">L12074</xsl:when>	<!-- ����ʢ��9���������գ������ͣ�  -->
		<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
		<!-- PBKINSR-923 ��������ͨ�����²�Ʒ�������Ӯ2�������A� -->
		<xsl:when test=".=015">L12084</xsl:when>	<!-- �����Ӯ2�������A��  -->
		<xsl:when test=".=016">L12089</xsl:when>	<!-- ����ʢ��1���������գ������ͣ�B��  -->
		<xsl:when test=".=017">L12093</xsl:when>	<!-- ����ʢ��9����ȫ����B������ͣ�  -->
		<xsl:when test=".=018">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:when test=".=L12088">L12088</xsl:when>	<!-- �����9����ȫ���գ������ͣ� -->
		<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	</xsl:template>	
</xsl:stylesheet>


	

