<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID>
					<xsl:value-of select="TranNo" />
				</TransRefGUID>
				<TransType>1008</TransType>
				<TransSubType>2</TransSubType>
				<TransExeDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" />
				</TransExeTime>

				<!-- չ�ַ��صĽ�� -->
				<xsl:apply-templates select="TranData/Body" />

				<!-- ���״���	TODO ��Ҫȷ���Ƿ���Ҫ����ڵ� -->
				<OLifEExtension VendorCode="1">
					<TransNo>1008</TransNo>
				</OLifEExtension>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLifE" match="Body">
		<OLifE>
			<!-- �������� -->
			<Holding id="Holding_1">
				<Policy>
					<!--������-->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!--����״̬-->
					<PolicyStatus>
						<xsl:value-of
							select="PubEdorQuery/PolicyStatus" />
					</PolicyStatus>
					<!--  �����ʻ�  -->
					<AccountNumber>
						<xsl:value-of select="PubContInfo/BankAccNo" />
					</AccountNumber>
					<Life>
						<CashValueAmt><xsl:value-of select="//Risk/GetMoney" /></CashValueAmt>
						<!-- ��������Ѻ��� -->
					</Life>
				</Policy>
				<OLifEExtension VendorCode="3">
					<!--�����־-->
					<CashEXF>0</CashEXF>
				</OLifEExtension>
			</Holding>
			<!--Ͷ������Ϣ-->
			<Party id="Party_1">
				<PartyKey>1</PartyKey>
				<FullName>
					<xsl:value-of select="Appnt/Name" />
				</FullName>
				<!-- Ͷ�������� -->
				<GovtID>
					<xsl:value-of select="Appnt/IDNo" />
				</GovtID>
				<!-- Ͷ����֤������ -->
				<GovtIDTC tc="1">
					<xsl:apply-templates select="Appnt/IDType" />
				</GovtIDTC>
				<!-- Ͷ����֤������ -->
				<Person>
					<Gender>
						<xsl:apply-templates select="Appnt/Sex" />
					</Gender>
					<!-- Ͷ�����Ա� -->
					<BirthDate>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Appnt/Birthday)" />
					</BirthDate>
					<!-- Ͷ���˳������� -->
				</Person>
			</Party>
			<Relation OriginatingObjectID="Holding_1"
				RelatedObjectID="Party_1" id="Relation_2">
				<OriginatingObjectType tc="4"> 
				</OriginatingObjectType>
				<RelatedObjectType tc="6">Party</RelatedObjectType>
				<RelationRoleCode tc="80">Owner</RelationRoleCode>
				<!-- Ͷ���˹�ϵ -->
			</Relation>

			<!-- ��֤��Ϣ -->
			<FormInstance id="Form_1">
				<!-- ��֤���� -->
				<FormName>
					<xsl:value-of select="PubEdorConfirm/FormName"></xsl:value-of>
				</FormName>
				<!-- ������ -->
				<DocumentControlNumber>
					<xsl:value-of select="PubEdorConfirm/FormNumber"></xsl:value-of>
				</DocumentControlNumber>
				<!-- ������Ϣ�� -->
				<Attachment id="Attachment_Form_1">
					<Description></Description>
					<!-- �������� -->
					<AttachmentData>content</AttachmentData>
					<AttachmentType tc="2147483647">Other</AttachmentType>
					<AttachmentLocation tc="1">In Line</AttachmentLocation>
				</Attachment>
			</FormInstance>
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
			<xsl:when test=".='122046'">013</xsl:when><!-- �������Ӯ��122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�L12081-����������������գ������ͣ����  -->
			<xsl:when test=".=122038">014</xsl:when>
			<!-- �����ֵ����8���������գ��ֺ��ͣ�A�� -->
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
			<xsl:when test=".='L12079'">008</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12078'">009</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='L12100'">009</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='L12074'">014</xsl:when><!-- ����ʢ��9���������գ������ͣ�  -->
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
			<!-- PBKINSR-923 ��������ͨ�����²�Ʒ�������Ӯ2�������A� -->
			<xsl:when test=".='L12084'">015</xsl:when><!-- �����Ӯ2�������A��  -->
			<xsl:when test=".='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ֤������ -->
	<xsl:template name="tran_idtype" match="AppntIDType">
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

	<!-- �Ա� -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- �� -->
			<xsl:when test=".='1'">2</xsl:when><!-- Ů -->
			<xsl:when test=".='2'">3</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
