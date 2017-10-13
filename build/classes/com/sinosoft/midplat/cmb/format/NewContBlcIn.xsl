<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<Body>
				<!-- ����Լ���� -->
				<NewCont>
					<TranData>
						<!-- ����ͷ -->
						<xsl:apply-templates
							select="TXLife/TXLifeRequest" />
						<Body>
							<Count>
								<xsl:value-of
									select="count(//JournalEntry[ResultCode=1 and TransType='01'])" />
							</Count>
							<Prem>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//JournalEntry[ResultCode=1 and TransType='01']/PaymentAmount))" />
							</Prem>
							<!-- �ɹ�������Լ���� -->
							<xsl:for-each
								select="//JournalEntry[ResultCode=1 and TransType='01']">
								<xsl:call-template
									name="common_newcont" />
							</xsl:for-each>
						</Body>
					</TranData>
				</NewCont>
				<!-- ��ԥ���˱����� -->
				<WT>
					<TranData>
						<!-- ����ͷ -->
						<xsl:apply-templates
							select="TXLife/TXLifeRequest" />
						<Body>
							<PubContInfo>
								<EdorFlag>8</EdorFlag>
								<CTBlcType>1</CTBlcType>
								<WTBlcType>1</WTBlcType>
								<MQBlcType>0</MQBlcType>
								<XQBlcType>0</XQBlcType>
							</PubContInfo>
							<!-- �ɹ�����ԥ���˱����� -->
							<!-- PBKINSR-834 ��������ͨ�����¹��ܣ��˱��� -->
							<xsl:for-each
								select="//JournalEntry[ResultCode=1 and (TransType='05' or TransType='06')]">
								<xsl:call-template name="common_wt" />
							</xsl:for-each>
						</Body>
					</TranData>
					<Count></Count>
				</WT>
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


	<!-- ����Լ���� -->
	<xsl:template name="common_newcont">
		<Detail>
			<!--  �������ڣ�8λ���ָ�ʽYYYYMMDD������Ϊ�գ� -->
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<!--  ���е��������������  -->
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="Branch" />
			</NodeNo>
			<!--  ������ˮ��  -->
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<!--  ���պ�ͬ��/������  -->
			<ContNo>
				<xsl:value-of select="PolicyNO" />
			</ContNo>
			<!--  ����ʵ�ս�� -->
			<Prem>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PaymentAmount)" />
			</Prem>
			<!-- ����������0-���棬1-������8�����ն�,Ĭ��Ϊ0�����й����Ķ��˱��Ĳ����֣���Ҫ���� -->
			<SourceType>0</SourceType>
		</Detail>
	</xsl:template>

	<!-- ���˶��� -->
	<xsl:template name="common_wt">
		<Detail>
			<!--  ���պ�ͬ��/������  -->
			<ContNo>
				<xsl:value-of select="PolicyNO" />
			</ContNo>
			<!--  �������ڣ�8λ���ָ�ʽYYYYMMDD������Ϊ�գ� -->
			<EdorAppDate>
				<xsl:value-of select="TransExeDate" />
			</EdorAppDate>
			<!--  ����ʵ����� -->
			<TranMoney>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PayoutAmount)" />
			</TranMoney>
			<!--  ��ȫ���� wt ���� -->
			<EdorType><xsl:apply-templates select="TransType" /></EdorType>
			<EdorAppNo></EdorAppNo>
			<EdorNo></EdorNo>
			<BankCode></BankCode>
			<AccNo></AccNo>
			<AccName></AccName>
			<RCode></RCode>
		</Detail>
	</xsl:template>
	<!-- ҵ������-->
	<xsl:template match="TransType">
		<xsl:choose>
			<xsl:when test=".='05'">WT</xsl:when>	<!-- ����  -->
			<xsl:when test=".='06'">CT</xsl:when>	<!-- �˱�  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>