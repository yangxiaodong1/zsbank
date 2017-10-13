<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife> 			
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>				
				<TransRefGUID/>
				<TransType></TransType>
				<TransExeDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()"/>
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				</TransExeTime>							
				
				<!-- չ�ַ��صĽ�� -->
				<xsl:apply-templates select="TranData/Body"/>	
				
				<!-- ���״���	TODO ��Ҫȷ���Ƿ���Ҫ����ڵ� -->
				<OLifEExtension VendorCode="1">			
					<TransNo>1000</TransNo>			
				</OLifEExtension>						
				</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="OLifE" match="Body">		
		<OLifE>
			<!-- �������� -->
			<Holding id="Holding_1">
				<Policy>
					<PolNumber><xsl:value-of select="PubContInfo/ContNo"/></PolNumber>
					<!--������-->
					<Life>
						<!--  ������Ŀ   --> 
  					<CoverageCount><xsl:value-of select="EdorXQInfo/CoverageCount"/></CoverageCount> 
						<!-- Optional repeating -->
						<xsl:for-each select="EdorXQInfo/Risk">						
						<Coverage>
							<!-- ѭ���ڵ�,����ʱ��Ӧ�����˳��������� -->
							<PlanName><xsl:value-of select="RiskName"/></PlanName>
							<!-- �������� -->
							<ProductCode><xsl:apply-templates select="RiskCode"/></ProductCode>
							<!-- ���ִ��� -->
							<OLifEExtension VendorCode="10">
								<!-- Ӧ�����,����ʱ��˳����� -->
								<PaymentOrder><xsl:value-of select="PayExtension/PaymentOrder"/></PaymentOrder>
								<!-- �ɷѽ�� -->
								<NextPayAmt><xsl:value-of select="PayExtension/NextPayAmt"/></NextPayAmt>
								<!-- Ӧ������-->
								<PaymentDate><xsl:value-of select="PayExtension/PaymentDate"/></PaymentDate>
								<!-- Ӧ����¼״̬-->
								<PaymentState>�������ڽɷ�</PaymentState>
								<!-- ��ʾ��Ϣ-->
								<Remark><xsl:value-of select="Remark"/></Remark>			
							</OLifEExtension>
						</Coverage>
						</xsl:for-each>
					</Life>
				</Policy>
				<FinancialActivity>
					<!--Ӧ�ս��-->
					<FinActivityGrossAmt><xsl:value-of select="EdorXQInfo/FinActivityGrossAmt" /></FinActivityGrossAmt>
					<!-- Ӧ�����ڣ����٣�  --> 
					<FinEffDate>
						<xsl:value-of select="EdorXQInfo/FinEffDate"/>
					</FinEffDate> 	
					<!--  �ɷ�����   -->	
					<OLifEExtension VendorCode="9">						 
  						<PaymentYears><xsl:value-of select="EdorXQInfo/PaymentYears"/></PaymentYears> 
						<!-- �շ���Ŀ-->
						<PayItm><xsl:value-of select="EdorXQInfo/PayItm"/></PayItm>					
						<!-- Ӧ������ -->
						<PaymentTimes><xsl:value-of select="EdorXQInfo/PaymentTimes"/></PaymentTimes>
						<!-- �ѽ����� -->
						<PayedTimes><xsl:value-of select="EdorXQInfo/PayedTimes"/></PayedTimes>
						<PaymentStartDate>
							<xsl:value-of select="EdorXQInfo/PaymentStartDate"/>
						</PaymentStartDate>
						<!-- �ɷ���ʼ���� -->
						<PaymentEndDate>
							<xsl:value-of select="EdorXQInfo/PaymentEndDate"/>
						</PaymentEndDate>
						<!-- �ɷ���ֹ���� -->
						<ACCCODE><xsl:value-of select="EdorXQInfo/ACCCODE"/></ACCCODE>
						<!-- for�й����٣��˻����� -->
					</OLifEExtension>
				</FinancialActivity>
			</Holding>
			<Party id="Party_1">
				<FullName><xsl:value-of select="PubContInfo/AppntName" /></FullName>
				<!-- Ͷ�������� -->
				<GovtID><xsl:value-of select="PubContInfo/AppntIDNo" /></GovtID>
				<!-- Ͷ����֤������ -->
				<GovtIDTC tc="1"><xsl:apply-templates select="PubContInfo/AppntIDType" /></GovtIDTC>
				<!-- Ͷ����֤������ -->				
			</Party>
			<Relation OriginatingObjectID="Holding_1" RelatedObjectID="Party_1" id="Relation_1">
				<OriginatingObjectType tc="4">4</OriginatingObjectType>
				<RelatedObjectType tc="6">6</RelatedObjectType>
				<RelationRoleCode tc="80">80</RelationRoleCode>
				<!-- Ͷ���˹�ϵ -->
			</Relation>
		</OLifE>					
	</xsl:template>
	<!-- ���ִ��� -->
	<xsl:template name="tran_ProductCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".=122001">001</xsl:when>
			<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".=122002">002</xsl:when>
			<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".=122003">003</xsl:when>
			<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".=122004">101</xsl:when>
			<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->			
			<xsl:when test=".=122006">004</xsl:when>
			<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".=122008">005</xsl:when>
			<!-- ���������1���������գ������ͣ� -->
			<xsl:when test=".=122009">006</xsl:when>
			<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->			
			<xsl:when test=".=122011">007</xsl:when>
			<!-- ����ʢ��1���������գ������ͣ� -->
			<xsl:when test=".=122012">008</xsl:when>
			<!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test=".=122010">009</xsl:when>
			<!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".=122029">010</xsl:when>
			<!-- ����ʢ��5���������գ������ͣ�  -->
			<xsl:when test=".=122020">011</xsl:when>
			<!-- �����6����ȫ���գ��ֺ��ͣ�  -->
			<xsl:when test=".=122036">012</xsl:when>
			<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122046'">013</xsl:when>	<!-- �������Ӯ��122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ����  -->
			<xsl:when test=".=122038">014</xsl:when>
			<!-- �����ֵ����8���������գ��ֺ��ͣ�A�� -->
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->	
			<xsl:when test=".='L12079'">008</xsl:when>	<!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12078'">009</xsl:when>	<!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='L12100'">009</xsl:when>	<!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='L12074'">014</xsl:when>	<!-- ����ʢ��9���������գ������ͣ�  -->
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
			<!-- PBKINSR-923 ��������ͨ�����²�Ʒ�������Ӯ2�������A� -->
			<xsl:when test=".='L12084'">015</xsl:when>	<!-- �����Ӯ2�������A��  -->
			<xsl:when test=".='L12093'">017</xsl:when>	<!-- ����ʢ��9����ȫ����B������ͣ�  -->
			<xsl:when test=".='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ֤������ -->
	<xsl:template name="tran_idtype" match="AppntIDType">
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
</xsl:stylesheet>
