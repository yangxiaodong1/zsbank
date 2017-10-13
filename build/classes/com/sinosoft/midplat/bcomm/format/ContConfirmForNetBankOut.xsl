<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<RMBP>
			<xsl:copy-of select="TranData/Head" />

			<xsl:apply-templates select="TranData/Body" />
		</RMBP>
	</xsl:template>

	<xsl:template name="body" match="Body">
	
		<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
	
		<!-- ���� -->
		<xsl:variable name="mainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<K_TrList>
			<!--�ܱ��� �ǿ�-->
			<KR_TotalAmt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActSumPrem,15,$leftPadFlag)" />
			</KR_TotalAmt>
			<!--�ܱ��Ѵ�д		Char(60)		�ǿ�-->
			<PREMC>
				<xsl:value-of select="ActSumPremText" />
			</PREMC>
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
			<!--Ӫҵ��λ����		Char(20)		�ɿ�-->
			<AgentCode><xsl:value-of select="ComCode" /></AgentCode>
			<!--ר��Ա����		Char(20)		�ɿ�-->
			<AgentName><xsl:value-of select="AgentName" /></AgentName>
			<!--�������ִ���		Char(10)		�ǿ�-->
			<KR_IdxType>
				<xsl:apply-templates select="$mainRisk/RiskCode" />
			</KR_IdxType>
			<!--������������		Char(40)		�ǿ�-->
			<KR_IdxName>
				<xsl:value-of select="$mainRisk/RiskName" />
			</KR_IdxName>
			<!--Ͷ�����			Char(35)		�ǿ�-->
			<KR_Idx>
				<xsl:value-of select="ProposalPrtNo" />
			</KR_Idx>
			<!--������			Char(35)		�ǿ�-->
			<KR_Idx1>
				<xsl:value-of select="ContNo" />
			</KR_Idx1>
			<!--���ѷ�ʽ			Char(1)		�ǿ� ȡ����ֵ-->
			<KR_TrType></KR_TrType>
			<!--����ҵ��Ա����	Char(10)		�ɿ�-->
			<KR_EntOper><xsl:value-of select="AgentCode" /></KR_EntOper>
			<!--ǩ������			Char(8)		�ǿ�	��ʽ��YYYYMMDD-->
			<KR_SignedDate>
				<xsl:value-of select="$mainRisk/SignDate" />
			</KR_SignedDate>
		</K_TrList>
		<K_BI>
			<xsl:apply-templates select="Appnt" />
			
			<xsl:apply-templates select="Insured" />

			<!-- ������ -->
			<xsl:for-each select="Bnf">
				<Benefit>
					<!--����������˳�򣨻������˷��䷽ʽ��	Char(3)	�ǿ�-->
					<BeneDisMode>
						<xsl:value-of select="Grade" />
					</BeneDisMode>
					<!--����������		Char(60)		�ǿ�-->
					<Name>
						<xsl:value-of select="Name" />
					</Name>
					<!--�������Ա�		Char(1)		�ɿ�	�μ���¼3.1-->
					<Sex>
						<xsl:value-of select="Sex" />
					</Sex>
					<!--�����˳�������	Char(8)		�ɿ�	��ʽ��YYYYMMDD-->
					<Birthday>
						<xsl:value-of select="Birthday" />
					</Birthday>
					<!--������֤������	Char(3)		�ɿ�	-->
					<IdType>
						<xsl:apply-templates select="IDType" />
					</IdType>
					<!--������֤������	Char(30)		�ɿ�-->
					<IdNo>
						<xsl:value-of select="IDNo" />
					</IdNo>
					<!--�������뱻���˹�ϵ	Char(3)	�ǿ�	-->
					<Rela>
						<xsl:call-template name="tran_relation">
							<xsl:with-param name="relation"
								select="RelaToInsured" />
							<xsl:with-param name="sex" select="sex" />
						</xsl:call-template>
					</Rela>
					<!--����������		Char(1)		�ɿ�	�μ���¼3.18-->
					<BeneType>
						<xsl:apply-templates select="Type" />
					</BeneType>
					<!--�������������	Char(10)		�ǿ�-->
					<DisRate>
						<xsl:value-of select="Lot" />
					</DisRate>
					<!--������ͨѶ��ַ	Char(60)		�ɿ�-->
					<Address />
				</Benefit>
			</xsl:for-each>

			<xsl:for-each select="Risk">
				<xsl:choose>
					<!-- Ͷ����Ϣ -->
					<xsl:when test="RiskCode=MainRiskCode">
						<Info>
							<!--Ͷ�����뱻���˹�ϵ	Char(3)		�ǿ�	-->
							<Rela>
								<xsl:call-template
									name="tran_relation">
									<xsl:with-param name="relation"
										select="//Appnt/RelaToInsured" />
									<xsl:with-param name="sex"
										select="//Appnt/sex" />
								</xsl:call-template>
							</Rela>
							<!--��Ч����			Char(8)		�ɿ�	��ʽ��YYYYMMDD-->
							<ValiDate>
								<xsl:value-of select="CValiDate" />
							</ValiDate>
							<!--��ֹ����			Char(8)		�ɿ�	��ʽ��YYYYMMDD-->
							<InvaliDate>
								<xsl:value-of select="InsuEndDate" />
							</InvaliDate>
							<!--�ɷѷ�ʽ			Char(3)		�ǿ�	-->
							<PremType>
								<xsl:apply-templates select="PayIntv" />
							</PremType>
							<!--�ɷ���ֹ����		Char(8)		�ɿ�	��ʽ��YYYYMMDD-->
							<PayEndDate>
								<xsl:value-of select="PayEndDate" />
							</PayEndDate>
							<!--��������			Char(8)		�ɿ�	��ʽ��YYYYMMDD-->
							<CPayDate />
							<!--�����ڣ��ɷ��ʻ�	Char(30)		�ɿ�-->
							<OpenAct></OpenAct>
							<!--������ȡ��ʽ		Char(3)		�ɿ�	-->
							<DividMethod>
								<xsl:apply-templates select="BonusGetMode" />
							</DividMethod>
							<!--���ڱ���			Dec(15,0)	�ɿ�-->
							<Prem>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActPrem,15,$leftPadFlag)" />
							</Prem>
							<!--�������ͷ�ʽ		Char(1)		�ɿ�-->
							<Deliver></Deliver>
							<!--������֪��־		Char(1)		�ɿ�	-->
							<Health></Health>
							<!--����Ͷ������		Int(5)		�ǿ�-->
							<Unit>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(//ContPlan/ContPlanMult,5,$leftPadFlag)" />
							</Unit>
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
							<!--������ȡ��ʽ		Char(3)		�ɿ�	-->
							<PayOutMethod></PayOutMethod>
							<!--���ձ�����������	Char(3)		�ǿ�	-->
							<CoverageType>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">1</xsl:when>
									<xsl:otherwise><xsl:apply-templates select="InsuYearFlag" /></xsl:otherwise>
								</xsl:choose>
							</CoverageType>
							<!--���ձ�������		Char(3)		�ǿ�-->
							<Coverage>
								<xsl:value-of select="InsuYear" />
							</Coverage>
							<!--���սɷ���������	Char(3)		�ǿ�	�μ���¼3.6-->
							<PremTermType>
								<xsl:choose>
									<xsl:when test="PayIntv=0">1</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="PayEndYearFlag" />
									</xsl:otherwise>
								</xsl:choose>
							</PremTermType>
							<!--���սɷ�����		Char(3)		�ǿ�-->
							<PremTerm>
								<xsl:choose>
									<xsl:when test="PayIntv=0">0</xsl:when>
									<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
								</xsl:choose>
							</PremTerm>
							<!--������ȡ��ʼ����	Char(3)		�ɿ�-->
							<GetFirAge />
							<!--������ȡ��ֹ����	Char(3)		�ɿ�-->
							<GetLstAge />
							<!--��������			Char(8)		�ɿ�	��ʽ��YYYYMMDD -->
							<PayToDate>
								<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(PayToDate)" />
							</PayToDate>
							<!--��������			Char(8)		�ɿ�	��ʽ��YYYYMMDD -->
							<GetStartDate>
								<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(GetStartDate)" />
							</GetStartDate>
							<!--�����������		Dec(15,0)	�ɿ�-->
							<FirstCharge />
							<!--�����������		Dec(15,0)	�ɿ�-->
							<SecondCharge />
							<!--�����˱�����		Dec(10,2)	�ɿ�-->
							<FirstRetPct />
							<!--�����˱�����		Dec(10,2)	�ɿ�-->
							<SecondRetPct />
							<!--����				Dec(10,2)	�ɿ�-->
							<Rate />
							<!--��ʼ����			Dec(10,2)	�ɿ�-->
							<FirstRate />
							<!--��֤����			Dec(10,2)	�ɿ�-->
							<SureRate />
							<!--������ֵ��ʼֵ	Dec(15,0)	�ɿ�-->
							<FirstValue />
							<!--�����ֽ��ֵ��λ����	Char(20)	�ɿ�-->
							<CashDescription />
							<!--˽�нڵ�-->
							<Private>
								<!--�Ƿ�Ϊ����������	Char(1)		�ǿ�	0-��1-��	�����1-���������ˣ��������˸���Ϊ0-->
								<xsl:variable name="bnfCount"
									select="count(//Bnf/Type)" />
								<BenefitKind>
									<xsl:choose>
										<xsl:when test="$bnfCount=0">1</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</BenefitKind>
								<!--�����˸���		Int(2)		�ǿ�-->
								<BenefitCount>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($bnfCount),2,$leftPadFlag)" />
								</BenefitCount>
								<!--�ɷ��ʻ�����		Char(60)		�ɿ�-->
								<ActName />
								<!--�ɷѷ�ʽ����		Char(10)		�ɿ�-->
								<PremType />
								<!--���սɷѱ�׼		Dec(15,0)	�ɿ�-->
								<StdFee />
								<!--�����ۺϼӷ�		Dec(15,0)	�ɿ�-->
								<ColFee />
								<!--����ְҵ�ӷ�		Dec(15,0)	�ɿ�-->
								<WorkFee />
								<!--������			Char(20)		�ɿ�-->
								<ManageDM />
								<!--��������			Char(2)		�ɿ�-->
								<SellChannel />
								<!--��ͬ���鴦��ʽ	Char(1)		�ɿ�	�μ���¼3.28-->
								<DEALTYPE />
								<!--�ٲ�ίԱ��		Char(20)		�ɿ�-->
								<INTERCED />
								<!--ְҵ��֪��־		Char(1)		�ɿ�	�μ���¼3.23-->
								<WorkFlag />
								<!--������ȡ��������	Char(3)		�ɿ�	�μ���¼3.7-->
								<PayM />
								<!--������ȡ����		Char(3)		�ɿ�	��������ȡ����-->
								<PayD>
									<xsl:value-of select="GetYear" />
								</PayD>
								<!--��ȡ���ڱ�־		Char(1)		�ɿ�	�μ���¼3.29-->
								<ReceiveMark />
								<!--�Զ��潻��־		Char(1)		�ɿ�	�μ���¼3.16-->
								<AutoPayFlag />
								<!--������־		Char(1)		�ɿ�	�μ���¼3.17-->
								<SubFlag />
								<!--���Ӷ��Ᵽ��		Dec(15,0)	�ɿ�-->
								<ExcPremAmt />
								<!--���Ӷ��Ᵽ��		Dec(15,0)	�ɿ�-->
								<ExcBaseAmt />
								<!--��ѡ������ʱ��ս��		Dec(15,0)	�ɿ�-->
								<SelectAmt />
								<!--�ر�Լ��			Char(256)	�ɿ�-->
								<SpecialClause/>
								<!--Ͷ����֪			Char(256)	�ɿ�-->
								<Notice />
								<!--�ͻ��ط�����		Char(3)		�ɿ�	Ĭ��Ϊ1���绰�ط�-->
								<CusFolType />
								<!--����һ�����Զ�������־	Char(1)	�ɿ�	�μ���¼3.30-->
								<AutoRenewInd />
								<!--�����ո���		Int(2)		�ǿ� -->
								<xsl:variable name="addCount"
									select="count(//Risk[RiskCode!=MainRiskCode])" />
								<AddCount>
									<xsl:value-of select="$addCount" />
								</AddCount>
								<!--Ͷ������			Char(3)		�ɿ�	�μ���¼3.20-->
								<InvestDateOn />
								<!--Ͷ���ڼ�			Char(3)		�ɿ�	�μ���¼3.14-->
								<InvestType />
								<!--Ͷ���˻�����		Int(2)		�ǿ�-->
								<AccountCount>0</AccountCount>
								<!--Ͷ���ո��ڵ�-->
								<Invests></Invests>
							</Private>
							<!--�����ֽ��ֵ�ڵ�-->
							<CashValues>
								<!--�����ֽ��ֵ����		Int(3)		�ǿ�-->
								<xsl:variable name="mainCashCount"
									select="count(CashValues/CashValue)" />
								<Count>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($mainCashCount),3,$leftPadFlag)" />
								</Count>
								<xsl:if test="$mainCashCount > 0">
									<xsl:for-each
										select="CashValues/CashValue">
										<Cash>
											<!--�������			Dec(15,0)	�ɿ�-->
											<Live />
											<!--������ʱ��ս�	Dec(15,0)	�ɿ�-->
											<IDAmt />
											<!--������ʱ��ս�	Dec(15,0)	�ɿ�-->
											<ADAmt />
											<!--���ĩ			Char(3)		�ɿ�-->
											<End />
											<!--��ĩ�ֽ��ֵ		Dec(15,0)	�ɿ�-->
											<Ch>
												<xsl:value-of
													select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Cash,15,$leftPadFlag)" />
											</Ch>
											<!--�������			Char(8)		�ɿ�-->
											<Year>
												<xsl:value-of
													select="EndYear" />
											</Year>
											<!--���屣��			Dec(15,0)	�ɿ�-->
											<PaidAmt />
											<!--�ֽ��ֵ��˵��	Char(60)		�ɿ�-->
											<Descrip />
										</Cash>
									</xsl:for-each>
								</xsl:if>
							</CashValues>
							<!--���պ�����������ĩ�ֽ��ֵ�ڵ�-->
							<BonusValues>
								<!--���պ�����������ĩ�ֽ��ֵ����		Int(3)		�ǿ�-->
								<xsl:variable name="mainBonusCount"
									select="count(BonusValues/BonusValue)" />
								<Count>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($mainBonusCount),3,$leftPadFlag)" />
								</Count>
								<!--���պ�����������ĩ�ֽ��ֵѭ���ڵ�	ѭ���ڵ����Ϊ�����պ�����������ĩ�ֽ��ֵ�����������պ�����������ĩ�ֽ��ֵ��������0�����������պ�����������ĩ�ֽ��ֵѭ���ڵ�-->
								<xsl:if test="$mainBonusCount > 0">
									<xsl:for-each
										select="BonusValues/BonusValue">
										<Bonus>
											<!--���ĩ			Char(3)		�ɿ�-->
											<End>
												<xsl:value-of
													select="EndYear" />
											</End>
											<!--��ĩ�ֽ��ֵ		Dec(15,0)	�ɿ�-->
											<Cash>
												<xsl:value-of
													select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(EndYearCash ,15,$leftPadFlag)" />
											</Cash>
										</Bonus>
									</xsl:for-each>
								</xsl:if>
							</BonusValues>
						</Info>
					</xsl:when>
					<xsl:otherwise>
						<!-- ��������Ϣ -->
						<Add>
							<!--�����մ���		Char(10)		�ǿ�-->
							<ProductId>
								<xsl:apply-templates select="RiskCode" />
							</ProductId>
							<!--������Ͷ������	Int(5)		�ǿ�-->
							<Unit>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Mult,5,$leftPadFlag)" />
							</Unit>
							<!--�����ձ���		Dec(15,0)	�����ձ����븽���ձ���֮һΪ������-->
							<Premium>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ActPrem,15,$leftPadFlag)" />
							</Premium>
							<!--�����ձ���		Dec(15,0)	�����ձ����븽���ձ���֮һΪ������-->
							<BaseAmt>
								<xsl:value-of
									select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Amnt,15,$leftPadFlag)" />
							</BaseAmt>
							<!--�����սɷѷ�ʽ	Char(3)		�ǿ�	�μ���¼3.8-->
							<PremType>
								<xsl:apply-templates select="PayIntv" />
							</PremType>
							<!--�����սɷ���������	Char(3)	�ǿ�	�μ���¼3.6-->
							<PremTermType>
								<xsl:choose>
									<xsl:when test="PayIntv=0">1</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="PayEndYearFlag" />
									</xsl:otherwise>
								</xsl:choose>
							</PremTermType>
							<!--�����սɷ�����	Char(3)		�ǿ�-->
							<PremTerm>
								<xsl:choose>
									<xsl:when test="PayIntv=0">0</xsl:when>
									<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
								</xsl:choose>
							</PremTerm>
							<!--�����ձ�����������	Char(3)	�ǿ�	�μ���¼3.5-->
							<CoverageType>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">1</xsl:when>
									<xsl:otherwise><xsl:apply-templates select="InsuYearFlag" /></xsl:otherwise>
								</xsl:choose>
							</CoverageType>
							<!--�����ձ�������	Char(3)		�ǿ�-->
							<Coverage>
								<xsl:value-of select="InsuYear" />
							</Coverage>
							<!--��������ȡ��������	Char(1)	�ǿ�	�μ���¼3.7-->
							<PayOutType>
								<xsl:apply-templates
									select="GetYearFlag" />
							</PayOutType>
							<!--��������ȡ����	Char(3)		�ǿ�-->
							<PayOut>
								<xsl:value-of select="GetYear" />
							</PayOut>
							<!--��������ȡ��ʽ	Char(3)		�ɿ�	�μ���¼3.10-->
							<PayOutMethod></PayOutMethod>
							<!--�����պ�����ȡ��ʽ	Char(3)	�ɿ�	�μ���¼3.9-->
							<DividMethod>
								<xsl:apply-templates select="BonusGetModes"/>
							</DividMethod>
							<!--�����ճ�ʼ����	Dec(10,2)	�ɿ�-->
							<FirstRate />
							<!--�����ձ�֤����	Dec(10,2)	�ɿ�-->
							<SureRate />
							<!--�����ձ�����ֵ��ʼֵ	Dec(15,0)	�ɿ�-->
							<FirstValue />
							<!--��������������	Char(1)		�ɿ�-->
							<RiskType />
							<!--��������������	Char(40)		�ɿ�-->
							<PlanName>
								<xsl:value-of select="RiskName" />
							</PlanName>
							<!--��������������	Char(8)		�ɿ�	��ʽ��YYYYMMDD -->
							<GetStartDate>
								<xsl:value-of select="GetStartDate" />
							</GetStartDate>
							<!--��������Ч����	Char(8)		�ɿ�	��ʽ��YYYYMMDD -->
							<ValiDate>
								<xsl:value-of select="CValiDate" />
							</ValiDate>
							<!--�����������������		Dec(15,0)	�ɿ�-->
							<FirstCharge></FirstCharge>
							<!--�����մ����������		Dec(15,0)	�ɿ�-->
							<SecondCharge />

							<!--������˽�нڵ�-->
							<Private>
								<!--�����սɷѱ�׼	Dec(15,0)	�ɿ�-->
								<StdFee></StdFee>
								<!--�������ۺϼӷ�	Dec(15,0)	�ɿ�-->
								<ColFee></ColFee>
								<!--������ְҵ�ӷ�	Dec(15,0)	�ɿ�-->
								<WorkFee></WorkFee>
								<!--�������Զ��潻��־	Char(1)	�ɿ�	�μ���¼3.16-->
								<AutoPayFlag></AutoPayFlag>
								<!--�������ر�Լ��	Char(256)	�ɿ�-->
								<SpecialClause/>
								<!--���ӱ�������		Char(1)		�ɿ�-->
								<AppendIns />
							</Private>
							<!--�������ֽ��ֵ�ڵ�-->
							<CashValues>
								<xsl:variable name="addCashCount"
									select="count(CashValues/CashValue[Cash != ''])" />
								<Count>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($addCashCount),3,$leftPadFlag)" />
								</Count>
								<xsl:if test="$addCashCount > 0">
									<xsl:for-each
										select="CashValues/CashValue">
										<Cash>
											<!--�������			Dec(15,0)	�ɿ�-->
											<Live />
											<!--������ʱ��ս�	Dec(15,0)	�ɿ�-->
											<IDAmt />
											<!--������ʱ��ս�	Dec(15,0)	�ɿ�-->
											<ADAmt />
											<!--���ĩ			Char(3)		�ɿ�-->
											<End />
											<!--��ĩ�ֽ��ֵ		Dec(15,0)	�ɿ�-->
											<Ch>
												<xsl:value-of
													select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Cash,15,$leftPadFlag)" />
											</Ch>
											<!--�������			Char(8)		�ɿ�-->
											<Year>
												<xsl:value-of
													select="EndYear" />
											</Year>
											<!--���屣��			Dec(15,0)	�ɿ�-->
											<PaidAmt />
											<!--�ֽ��ֵ��˵��	Char(60)		�ɿ�-->
											<Descrip />
										</Cash>
									</xsl:for-each>
								</xsl:if>
							</CashValues>
							<!--�����պ�����������ĩ�ֽ��ֵ�ڵ�-->
							<BonusValues>
								<xsl:variable name="addBonusCount"
									select="count(BonusValues/BonusValue[EndYearCash != ''])" />
								<Count>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(string($addBonusCount),3,$leftPadFlag)" />
								</Count>
								<xsl:if test="$addBonusCount > 0">
									<xsl:for-each
										select="BonusValues/BonusValue">
										<Bonus>
											<!--���ĩ			Char(3)		�ɿ�-->
											<End>
												<xsl:value-of
													select="EndYear" />
											</End>
											<!--��ĩ�ֽ��ֵ		Dec(15,0)	�ɿ�-->
											<Cash>
												<xsl:value-of
													select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(EndYearCash ,15,$leftPadFlag)" />
											</Cash>
										</Bonus>
									</xsl:for-each>
								</xsl:if>
							</BonusValues>
						</Add>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<Prt>
				<!--��ӡ1		Char(200)	�ɿ�-->
				<Line1 />
				<!--��ӡ2		Char(200)	�ɿ�-->
				<Line2 />
				<!--��ӡ3		Char(200)	�ɿ�-->
				<Line3 />
				<!--��ӡ4		Char(200)	�ɿ�-->
				<Line4 />
				<!--��ӡ5		Char(200)	�ɿ�-->
				<Line5 />
				<!--��ӡ6		Char(200)	�ɿ�-->
				<Line6 />
				<!--��ӡ7		Char(200)	�ɿ�-->
				<Line7 />
				<!--��ӡ8		Char(200)	�ɿ�-->
				<Line8 />
				<!--��ӡ9		Char(200)	�ɿ�-->
				<Line9 />
				<!--��ӡ10		Char(200)	�ɿ�-->
				<Line10 />
				<!--��ӡ11		Char(200)	�ɿ�-->
				<Line11 />
				<!--��ӡ12		Char(200)	�ɿ�-->
				<Line12 />
				<!--��ӡ13		Char(200)	�ɿ�-->
				<Line13 />
				<!--��ӡ14		Char(200)	�ɿ�-->
				<Line14 />
				<!--��ӡ15		Char(200)	�ɿ�-->
				<Line15 />
				<!--��ӡ16		Char(200)	�ɿ�-->
				<Line16 />
				<!--��ӡ17		Char(200)	�ɿ�-->
				<Line17 />
				<!--��ӡ18		Char(200)	�ɿ�-->
				<Line18 />
				<!--��ӡ19		Char(200)	�ɿ�-->
				<Line19 />
				<!--��ӡ20		Char(200)	�ɿ�-->
				<Line20 />
			</Prt>
		</K_BI>
	</xsl:template>

	<!-- Ͷ���� -->
	<xsl:template name="App" match="Appnt">
		<App>
			<!--Ͷ��������		Char(60)		�ǿ�-->
			<AppName>
				<xsl:value-of select="Name" />
			</AppName>
			<!--Ͷ�����Ա�		Char(1)		�ǿ�	�μ���¼3.1-->
			<AppSex>
				<xsl:value-of select="Sex" />
			</AppSex>
			<!--Ͷ���˳�������	Char(8)		�ǿ�	��ʽ��YYYYMMDD-->
			<AppBirthday>
				<xsl:value-of select="Birthday" />
			</AppBirthday>
			<!--Ͷ����֤������	Char(3)		�ǿ�	-->
			<AppIdType>
				<xsl:apply-templates select="IDType" />
			</AppIdType>
			<!--Ͷ����֤������	Char(30)		�ǿ�-->
			<AppIdNo>
				<xsl:value-of select="IDNo" />
			</AppIdNo>
			<!--Ͷ����ͨѶ��ַ	Char(60)		�ǿ�-->
			<AppOfficAddr>
				<xsl:value-of select="Address" />
			</AppOfficAddr>
			<!--Ͷ������������	Char(6)		�ǿ�-->
			<AppOfficPost>
				<xsl:value-of select="ZipCode" />
			</AppOfficPost>
			<!--Ͷ���˹̶��绰	Char(20)		�̶��绰���ֻ�����֮һΪ������-->
			<AppOfficPhone>
				<xsl:value-of select="Phone" />
			</AppOfficPhone>
			<!--Ͷ�����ֻ�����	Char(20)		�̶��绰���ֻ�����֮һΪ������-->
			<AppMobile>
				<xsl:value-of select="Mobile" />
			</AppMobile>
			<!--Ͷ���˵�������	Char(60)		�ɿ�-->
			<AppEmail>
				<xsl:value-of select="Email" />
			</AppEmail>
			<!--Ͷ����ְҵ���ʹ���	Char(20)	�ɿ�	-->
			<AppWork>
				<xsl:apply-templates select="JobCode" />
			</AppWork>
			<!--Ͷ���˹���		Char(10)		�ɿ�	-->
			<AppCountry>
				<xsl:apply-templates select="Nationality" />
			</AppCountry>
			<!--Ͷ���˹�����λ	Char(30)		�ɿ�-->
			<AppCompany />
			<!--Ͷ���˴���		Char(20)		�ɿ�-->
			<AppCall />
			<!--Ͷ����ƽ��������	Char(20)		�ɿ�	����ԪΪ��λ-->
			<AppYearSalary />
			<!--Ͷ�������		Char(10)		�ɿ�	������Ϊ��λ-->
			<AppHeight>
				<xsl:value-of select="Stature" />
			</AppHeight>
			<!--Ͷ��������		Char(10)		�ɿ�	��ǧ��Ϊ��λ-->
			<AppWeight></AppWeight>
			<!--Ͷ����֤����Ч����	Char(8)	�ɿ�	��ʽ��YYYYMMDD -->
			<AppIdExpDate />
			<!--Ͷ���˻���״��	Char(1)		�ɿ�	-->
			<AppMarStat>
				<xsl:apply-templates select="MaritalStatus" />
			</AppMarStat>
		</App>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="Ins" match="Insured">
		<Ins>
			<!--����������		Char(60)		�ǿ�-->
			<InsName>
				<xsl:value-of select="Name" />
			</InsName>
			<!--�������Ա�		Char(1)		�ǿ�	-->
			<InsSex>
				<xsl:value-of select="Sex" />
			</InsSex>
			<!--�����˳�������	Char(8)		�ǿ�	��ʽ��YYYYMMDD-->
			<InsBirthday>
				<xsl:value-of select="Birthday" />
			</InsBirthday>
			<!--������֤������	Char(3)		�ǿ�	-->
			<InsIdType>
				<xsl:apply-templates select="IDType" />
			</InsIdType>
			<!--������֤������	Char(30)		�ǿ�-->
			<InsIdNo>
				<xsl:value-of select="IDNo" />
			</InsIdNo>
			<!--������ͨѶ��ַ	Char(60)		�ǿ�-->
			<InsOfficAddr>
				<xsl:value-of select="Address" />
			</InsOfficAddr>
			<!--��������������	Char(6)		�ǿ�-->
			<InsOfficPost>
				<xsl:value-of select="ZipCode" />
			</InsOfficPost>
			<!--�����˹̶��绰	Char(20)		�̶��绰���ֻ�����֮һΪ������-->
			<InsOfficPhone>
				<xsl:value-of select="Phone" />
			</InsOfficPhone>
			<!--�������ֻ�����	Char(20)		�̶��绰���ֻ�����֮һΪ������-->
			<InsMobile>
				<xsl:value-of select="Mobile" />
			</InsMobile>
			<!--�����˵�������	Char(60)		�ɿ�-->
			<InsEmail>
				<xsl:value-of select="Email" />
			</InsEmail>
			<!--������ְҵ���ʹ���	Char(20)	�ɿ�	-->
			<InsWork>
				<xsl:apply-templates select="JobCode" />
			</InsWork>
			<!--�������Ƿ�Σ��ְҵ	Char(1)	�ɿ�	-->
			<WorkFlag />
			<!--�����˹���		Char(10)		�ɿ�	-->
			<InsCountry>
				<xsl:apply-templates select="Nationality" />
			</InsCountry>
			<!--�����˹�����λ	Char(30)		�ɿ�-->
			<InsCompany />
			<!--�����˴���		Char(20)		�ɿ�-->
			<InsCall />
			<!--������ƽ��������	Char(20)		�ɿ�	����ԪΪ��λ-->
			<InsYearSalary />
			<!--���������		Char(10)		�ɿ�	������Ϊ��λ-->
			<InsHeight>
				<xsl:value-of select="Stature" />
			</InsHeight>
			<!--����������		Char(10)		�ɿ�	��ǧ��Ϊ��λ-->
			<InsWeight></InsWeight>
			<!--������֤����Ч����	Char(8)	�ɿ�	��ʽ��YYYYMMDD -->
			<InsIdExpDate />
			<!--�����˻���״��	Char(1)		�ɿ�	-->
			<InsMarStat>
				<xsl:apply-templates select="MaritalStatus" />
			</InsMarStat>
		</Ins>
	</xsl:template>


	<!-- ******************** ����Ϊö������ ******************** -->
	<!-- ֤������ -->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">15</xsl:when><!-- �������֤ -->
			<xsl:when test=".=9">16</xsl:when><!-- ��ʱ���֤ -->
			<xsl:when test=".=2">17</xsl:when><!-- �������֤�� -->
			<xsl:when test=".=1">20</xsl:when><!-- ����  -->
			<xsl:when test=".=8">21</xsl:when><!-- ����  -->
			<xsl:when test=".=5">23</xsl:when><!-- ���ڲ�  -->
			<xsl:otherwise>21</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ְҵ���� -->
	<xsl:template name="tran_Job" match="JobCode">
		<xsl:choose>
			<xsl:when test=".=3010101">1</xsl:when><!-- ��λ��ְ���� -->
			<xsl:when test=".=3010102">2</xsl:when><!-- �������ò��� -->
			<xsl:when test=".=6230608">3</xsl:when><!-- ũ������װ�� -->
			<xsl:when test=".=5030206">4</xsl:when><!-- ��۲�ɰˮ�� -->
			<xsl:when test=".=6230902">5</xsl:when><!-- ����������е -->
			<xsl:when test=".=6230618">6</xsl:when><!-- �߿պ��Ϻ��� -->
			<xsl:when test=".=2021305">7</xsl:when><!-- ���溽�˳��� -->
			<xsl:when test=".=6051302">8</xsl:when><!-- Ǳˮ�������� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  ��������-->
	<xsl:template name="tran_nationtype" match="Nationality">
		<xsl:choose>
			<xsl:when test=".='HU'">HUN</xsl:when><!--	������     -->
			<xsl:when test=".='US'">USA</xsl:when><!--	����     -->
			<xsl:when test=".='TH'">THA</xsl:when><!--	̩��     -->
			<xsl:when test=".='SG'">SGP</xsl:when><!--	�¼���   -->
			<xsl:when test=".='IN'">IND</xsl:when><!--  ӡ��   -->
			<xsl:when test=".='BE'">BEL</xsl:when><!--	����ʱ     -->
			<xsl:when test=".='NL'">NLD</xsl:when><!--	����     -->
			<xsl:when test=".='MY'">MYS</xsl:when><!--	�������� -->
			<xsl:when test=".='KR'">KOR</xsl:when><!--	����     -->
			<xsl:when test=".='JP'">JPN</xsl:when><!--	�ձ�     -->
			<xsl:when test=".='AT'">AUT</xsl:when><!--	�µ���   -->
			<xsl:when test=".='FR'">FRA</xsl:when><!--	����     -->
			<xsl:when test=".='ES'">ESP</xsl:when><!--	������   -->
			<xsl:when test=".='GB'">GBR</xsl:when><!--	Ӣ��     -->
			<xsl:when test=".='CA'">CAN</xsl:when><!--	���ô�   -->
			<xsl:when test=".='AU'">AUS</xsl:when><!--	�Ĵ����� -->
			<xsl:when test=".='CHN'">CHN</xsl:when><!--	�й�     -->
			<xsl:otherwise></xsl:otherwise><!--	����     -->
		</xsl:choose>
	</xsl:template>

	<!-- ����״�� -->
	<xsl:template name="tran_marStat" match="MaritalStatus">
		<xsl:choose>
			<xsl:when test=".=N">5</xsl:when><!-- δ�� -->
			<xsl:when test=".=Y">1</xsl:when><!-- �ѻ� -->
			<!--<xsl:when test=".=2">6</xsl:when> ɥż -->
			<!--<xsl:when test=".=6">2</xsl:when> ��� -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �뱻���˹�ϵ -->
	<xsl:template name="tran_relation">
		<xsl:param name="relation" />
		<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$relation=00">1</xsl:when><!-- ���� -->
			<xsl:when test="$relation=01"><!-- ��ĸ -->
				<xsl:choose>
					<xsl:when test="$sex=0">2</xsl:when>
					<xsl:otherwise>3</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=02"><!-- ��ż -->
				<xsl:choose>
					<xsl:when test="$sex=0">7</xsl:when>
					<xsl:otherwise>6</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=03"><!-- ��Ů -->
				<xsl:choose>
					<xsl:when test="$sex=0">4</xsl:when>
					<xsl:otherwise>5</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=04">45</xsl:when><!-- ���� -->
			<xsl:otherwise>45</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���������� -->
	<xsl:template name="tran_BeneType" match="Type">
		<xsl:choose>
			<xsl:when test=".=1">1</xsl:when><!-- ���������� -->
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

	<!-- �������ڱ�־ -->
	<xsl:template name="tran_InsuYearFlag" match="InsuYearFlag ">
		<xsl:choose>
			<xsl:when test=".='D'">5</xsl:when>
			<xsl:when test=".='M'">4</xsl:when>
			<xsl:when test=".='Y'">2</xsl:when>
			<xsl:when test=".='A'">3</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ��������� -->
	<xsl:template name="tran_PayEndYearFlag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'"></xsl:when> <!-- �� -->
			<xsl:when test=".='M'"></xsl:when> <!-- �� -->
			<xsl:when test=".='Y'">2</xsl:when> <!-- �� -->
			<xsl:when test=".='A'">3</xsl:when> <!-- ����ĳȷ������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ������ȡ��ʽ -->
	<xsl:template name="tran_BonusGetMode" match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">2</xsl:when><!-- �ۻ���Ϣ -->
			<xsl:when test=".=4">4</xsl:when><!-- ��ȡ�ֽ� -->
			<xsl:when test=".=3">1</xsl:when><!-- �ֽɱ��� -->
			<xsl:when test=".=5">3</xsl:when><!-- ����� -->
			<xsl:otherwise></xsl:otherwise><!-- ���� -->
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
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_RiskCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ� -->
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>