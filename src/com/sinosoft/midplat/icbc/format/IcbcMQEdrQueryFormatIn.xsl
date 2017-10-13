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
	<xsl:template name="PubEdorInfo" match="OLifE">
		<PubEdorInfo>
			<!-- �����˱�����[yyyy-MM-dd]--><!--������-->
			<EdorAppDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
			</EdorAppDate>
			<!-- ����������--><!--������-->
			<EdorAppName>
				<xsl:value-of select="Party/FullName" />
			</EdorAppName>
			<Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) --><!--ȷ�Ͻ���ʱΪ������-->
				<CertifyType>
					<xsl:apply-templates select="FormName" />
				</CertifyType>
				<!-- ��֤����(��ȫ���������) --><!--ȷ�Ͻ���ʱΪ������-->
				<CertifyName></CertifyName>
				<!-- ��֤ӡˢ��(1-��ȫ���������)--><!--ȷ�Ͻ���ʱΪ������-->
				<CertifyCode>
					<xsl:apply-templates select="FormInstance/ProviderFormNumber" />
				</CertifyCode>
			</Certify>
		</PubEdorInfo>
	</xsl:template>

	<!--  ���� -->
	<xsl:template name="PubContInfo" match="Policy" >				
		<PubContInfo>
			<!-- ���н�������(��̨/����)-->
			<SourceType>0</SourceType>
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType>0</RepeatType>                              
			<!-- ���յ����� --><!--������ -->
			<ContNo><xsl:value-of select="PolNumber" /></ContNo> 
			<!-- Ͷ����ӡˢ���� -->					  	 	  														  
  	 	 	<PrtNo></PrtNo>		
  	 	 	<!-- �������� -->									
  	 	 	<ContNoPSW><xsl:value-of select="OLifEExtension/Password" /></ContNoPSW>   
  	 	 	<!-- ���ղ�Ʒ���� �����գ�-->                 
  	 		<RiskCode><xsl:apply-templates select="ProductCode" /></RiskCode>   	 		   	 		 
  	 		<xsl:variable name="AppntPartyID" select="../../Relation[RelationRoleCode='80']/@RelatedObjectID" />				
			<xsl:variable name="AppntPartyNode" select="../../Party[@id=$AppntPartyID]" />
  	 		
  	 		<!-- Ͷ����֤������ -->
			<AppntIDType><xsl:apply-templates select="$AppntPartyNode/GovtIDTC" /></AppntIDType>
			<!-- Ͷ����֤������ -->					   			            	
	   	 	<AppntIDNo><xsl:value-of select="$AppntPartyNode/GovtID" /></AppntIDNo>                    
	   	 	 <!-- Ͷ�������� --> 	
	   	 	<AppntName><xsl:value-of select="$AppntPartyNode/FullName" /></AppntName>  
	   	 	<!-- Ͷ����֤����Ч��ֹ���� -->                  	
	   	 	<AppntIdTypeEndDate><xsl:value-of select="$AppntPartyNode/GovtTermDate" /></AppntIdTypeEndDate>
	   	 	<!-- Ͷ����סլ�绰 (Ͷ������ϵ�绰) -->     	
	   	 	<AppntPhone><xsl:value-of select="$AppntPartyNode/Phone/DialNumber" /></AppntPhone>                   	
			
			<xsl:variable name="InsuredPartyID" select="../../Relation[RelationRoleCode='81']/@RelatedObjectID" />			
			<xsl:variable name="InsuredPartyNode" select="../../Party[@id=$InsuredPartyID]" />
			
			<!-- ������֤������ -->
   	 	    <InsuredIDType><xsl:apply-templates select="$InsuredPartyNode/GovtIDTC" /></InsuredIDType>             		
   	 	  	<!-- ������֤������ -->
   	 	    <InsuredIDNo><xsl:value-of select="$InsuredPartyNode/GovtID" /></InsuredIDNo>
   	 	     <!-- ���������� -->                 	
   	 	    <InsuredName><xsl:value-of select="$InsuredPartyNode/FullName" /></InsuredName>
   	 	    <!-- ������֤����Ч��ֹ���� -->	                	
   	 	    <InsuredIdTypeEndDate></InsuredIdTypeEndDate> 
   	 	    <!-- ������סլ�绰 (Ͷ������ϵ�绰) -->
   	 	    <InsuredPhone></InsuredPhone>         
   	 	    <!-- Ͷ���˹�ϵ���� -->      
   	 	    <RelationRoleCode1>80</RelationRoleCode1>    
   	 	    <!-- Ͷ���˹�ϵ -->           
   		    <RelationRoleName1></RelationRoleName1>       
   		    <!-- �����˹�ϵ���� -->        
   		    <RelationRoleCode2>81</RelationRoleCode2>  
   		    <!-- �����˹�ϵ -->	             
   		    <RelationRoleName2></RelationRoleName2>                  		    
   		    <!-- �ո��ѷ�ʽ(09-�޿�֧��) Ĭ��Ϊ7�����д���--><!--ȷ�Ͻ���ʱΪ������-->		
   	 	    <PayMode>7</PayMode>		
   	 	    <!-- �ո������б��--><!--ȷ�Ͻ���ʱΪ������-->
   	 	    <PayGetBankCode></PayGetBankCode>	
   	 	    <!-- �ո�����������  ʡ �� ����--><!--ȷ�Ͻ���ʱΪ������-->							                
  	 	    <BankName></BankName>	
  	 	    <!-- ���˷��ʻ��ʺ�--><!--ȷ�Ͻ���ʱΪ������-->
   	 	    <BankAccNo><xsl:value-of select="../../../OLifE/Holding/Banking/AccountNumber" /></BankAccNo>       
   	 	    <!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->                   	
   	 	    <BankAccName><xsl:value-of select="../../../OLifE/Holding/Arrangement/ArrDestination/AcctHolderName" /></BankAccName>                  			
	  </PubContInfo>
	</xsl:template>

	
	<!-- ֤������ -->
	<xsl:template name="tran_idtype" match="GovtIDTC">
	<xsl:choose>
		<xsl:when test=".=0">0</xsl:when>	<!-- ����֤ -->
		<xsl:when test=".=1">1</xsl:when>	<!-- ���� -->
		<xsl:when test=".=2">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test=".=3">2</xsl:when>	<!-- ʿ��֤ -->
		<xsl:when test=".=5">0</xsl:when>	<!-- ��ʱ����֤ -->
		<xsl:when test=".=6">5</xsl:when>	<!-- ���ڱ�  -->
		<xsl:when test=".=9">2</xsl:when>	<!-- ����֤  -->
		<xsl:otherwise>8</xsl:otherwise>
	</xsl:choose>
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
		<xsl:when test=".=013">122046</xsl:when>	<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����  -->
		<!-- <xsl:when test=".=014">122038</xsl:when> -->	<!-- �����ֵ����8���������գ��ֺ��ͣ�A�� -->
		<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
		<xsl:when test=".=014">L12074</xsl:when>	<!-- ����ʢ��9���������գ������ͣ�  -->
		<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
		<!-- PBKINSR-923 ��������ͨ�����²�Ʒ�������Ӯ2�������A� -->
		<xsl:when test=".=015">L12084</xsl:when>	<!-- �����Ӯ2�������A��  -->
		<xsl:when test=".=017">L12093</xsl:when>	<!-- ����ʢ��9����ȫ����B������ͣ�  -->
		<xsl:when test=".=018">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:when test=".=L12088">L12088</xsl:when>	<!-- �����9����ȫ���գ������ͣ� -->
		<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
</xsl:stylesheet>


	
