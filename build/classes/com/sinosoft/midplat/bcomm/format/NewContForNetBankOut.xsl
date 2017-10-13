<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<RMBP>
			<xsl:copy-of select="TranData/Head" />
			<xsl:if test="TranData/Head/Flag='0'">
				<xsl:apply-templates select="TranData/Body" />
			</xsl:if>
		</RMBP>
	</xsl:template>

	<xsl:template name="body" match="Body">
		<xsl:variable name="leftPadFlag"
			select="java:java.lang.Boolean.parseBoolean('true')" />
		<xsl:variable name="MainRisk"
			select="Risk[RiskCode=MainRiskCode]" />

		<K_TrList>
			<!--�ܱ���			Dec(15,0)	�ǿ�-->
			<KR_TotalAmt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActSumPrem,15,$leftPadFlag)" />
			</KR_TotalAmt>
			<!--�б���˾���� �ɿ�-->
			<ManageCom>
				<xsl:value-of select="ComName" />
			</ManageCom>
			<!--�б���˾��ַ		Char(60)		�ɿ�-->
			<ComLocation>
				<xsl:value-of select="ComLocation" />
			</ComLocation>
			<!--�б���˾����		Char(30)		�ɿ�-->
			<City />
			<!--�б���˾�绰		Char(20)		�ɿ�-->
			<Tel>
				<xsl:value-of select="ComPhone" />
			</Tel>
			<!--�б���˾�ʱ�		Char(6)		�ɿ�-->
			<Post>
				<xsl:value-of select="ComZipCode" />
			</Post>
			<!--Ӫҵ��λ����		Char(20)		�ɿ� -->
			<AgentCode />
			<!--ר��Ա����		Char(20)		�ɿ�-->
			<AgentName></AgentName>
		</K_TrList>

		<K_BI>
			<xsl:for-each select="Risk">
				<xsl:choose>
					<!-- Ͷ����Ϣ -->
					<xsl:when test="RiskCode=MainRiskCode">
						<Info>
							<!--�����ڽɱ���		Dec(15,0)	�����ڽɱ��������ձ���֮һΪ������-->
							<Premium>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActPrem,15,$leftPadFlag)" />
							</Premium>
							<!--���ձ���			Dec(15,0)	�����ڽɱ��������ձ���֮һΪ������-->
							<BaseAmt>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Amnt,15,$leftPadFlag)" />
							</BaseAmt>
							<!--���ڱ���			Dec(15,0)	�ɿ�-->
							<Prem>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActPrem,15,$leftPadFlag)" />
							</Prem>
							<!--��Ч����			Char(8)		�ɿ�	��ʽ��YYYYMMDD-->
							<ValiDate>
								<xsl:value-of select="CValiDate" />
							</ValiDate>
							<!--��ֹ����			Char(8)		�ɿ�	��ʽ��YYYYMMDD-->
							<InvaliDate>
								<xsl:value-of select="InsuEndDate" />
							</InvaliDate>
							<!--�ɷ�����			Char(80)		�ɿ�-->
							<PayDateChn></PayDateChn>
							<!--�ɷ���ֹ����		Char(8)		�ɿ�	��ʽ��YYYYMMDD-->
							<PayEndDate>
								<xsl:value-of select="PayEndDate" />
							</PayEndDate>
							<!--�ɷ��ڼ�			Char(80)		�ɿ�-->
							<PaysDateChn />
							<!--˽�нڵ�-->
							<Private>
								<!--���սɷѱ�׼		Dec(15,0)	�ɿ�-->
								<StdFee></StdFee>
								<!--�����ۺϼӷ�		Dec(15,0)	�ɿ�-->
								<ColFee></ColFee>
								<!--����ְҵ�ӷ�		Dec(15,0)	�ɿ�-->
								<WorkFee></WorkFee>
								<!--�����ո���		Int(2)		�ǿ� 
								<xsl:variable name="addCount"
									select="count(//Risk[RiskCode!=MainRiskCode])" />
									-->
								<AddCount>0</AddCount>
								<!--���Ӷ��Ᵽ��		Dec(15,0)	�ɿ�-->
								<ExcPremAmt></ExcPremAmt>
								<!--���Ӷ��Ᵽ��		Dec(15,0)	�ɿ�-->
								<ExcBaseAmt></ExcBaseAmt>
								<!--�ɷѷ�ʽ����		Char(10)		�ɿ�-->
								<PremType />
								<!--�ر�Լ��			Char(256)	�ɿ�-->
								<SpecialClause>
									<xsl:value-of select="SpecContent" />
								</SpecialClause>
								<!--��ȡ���ڱ�־		Char(1)		�ɿ�	�μ���¼3.29-->
								<ReceiveMark />
							</Private>
						</Info>
					</xsl:when>
					<xsl:otherwise>
						<!-- ��������Ϣ������ -->	
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</K_BI>
	</xsl:template>

	<!-- ***************����Ϊö��*************** -->
	<!-- ������ȡ��ʽ -->
	<xsl:template name="tran_BonusGetMode" match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">2</xsl:when><!-- �ۻ���Ϣ -->
			<xsl:when test=".=3">1</xsl:when><!-- �ֽɱ��� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �������ڱ�־ -->
	<xsl:template name="tran_InsuYearFlag" match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'">5</xsl:when>
			<xsl:when test=".='M'">4</xsl:when>
			<xsl:when test=".='Y'">2</xsl:when>
			<xsl:when test=".='A'">3</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ��ȡ�������� -->
	<xsl:template name="tran_GetYearFlag" match="GetYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'"></xsl:when>
			<xsl:when test=".='D'"></xsl:when>
			<xsl:when test=".='M'">2</xsl:when>
			<xsl:when test=".='Y'">5</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷѷ�ʽ -->
	<xsl:template name="tran_PayIntv" match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=12">5</xsl:when><!-- ��� -->
			<xsl:when test=".=1">2</xsl:when><!-- �½� -->
			<xsl:when test=".=6">4</xsl:when><!-- ����� -->
			<xsl:when test=".=3">3</xsl:when><!-- ���� -->
			<xsl:when test=".=0">1</xsl:when><!-- ���� -->
			<xsl:when test=".=-1">7</xsl:when><!-- ������ -->
			<xsl:otherwise>9</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ��������� -->
	<xsl:template name="tran_PayEndYearFlag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'"></xsl:when><!-- �� -->
			<xsl:when test=".='M'"></xsl:when><!-- �� -->
			<xsl:when test=".='Y'">2</xsl:when><!-- �� -->
			<xsl:when test=".='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template name="tran_RiskCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
