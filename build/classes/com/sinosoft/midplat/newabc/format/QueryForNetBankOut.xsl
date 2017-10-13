<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>

	<xsl:template match="Body">
		<xsl:variable name="MainRisk"
			select="Risk[RiskCode=MainRiskCode]" />
		<App>
			<Ret>
				<!-- �������� -->
				<PolicyNo>
					<xsl:value-of select="ContNo" />
				</PolicyNo>
				<!-- ����ӡˢ�� -->
				<VchNo>
					<xsl:value-of select="ProposalPrtNo" />
				</VchNo>
				
				<xsl:choose>
					<xsl:when test="ContPlan/ContPlanCode=''">
						<!-- �����ֳ��� -->
						<!--���ֱ�� -->
						<RiskCode>
							<xsl:apply-templates select="$MainRisk/RiskCode"  mode="risk"/>
						</RiskCode>
						<!-- �������� -->
						<RiskName>
							<xsl:value-of select="$MainRisk/RiskName" />
						</RiskName>
					</xsl:when>
					<xsl:otherwise>
						<!-- ���ײͳ��� -->
						<!--�ײͱ�� -->
						<RiskCode>
							<xsl:apply-templates select="ContPlan/ContPlanCode" mode="contplan"/>
						</RiskCode>
						<!-- �ײ����� -->
						<RiskName>
							<xsl:value-of select="ContPlan/ContPlanName" />
						</RiskName>
					</xsl:otherwise>
				</xsl:choose>

				<!-- ����״̬ -->
				<PolicyStatus>
					<xsl:apply-templates select="ContState" />
				</PolicyStatus>
				<!-- ������Ѻ״̬ -->
				<PolicyPledge>
					<xsl:apply-templates select="MortStatu" />
				</PolicyPledge>
				<!-- �������� -->
				<AcceptDate>
					<xsl:value-of select="$MainRisk/PolApplyDate" />
				</AcceptDate>
				<!-- ������Ч���� -->
				<PolicyBgnDate>
					<xsl:value-of select="$MainRisk/CValiDate" />
				</PolicyBgnDate>
				<!-- ����������-->
				<PolicyEndDate>
					<xsl:value-of select="$MainRisk/InsuEndDate" />
				</PolicyEndDate>
				<!-- Ͷ������ -->
				<PolicyAmmount>
					<xsl:value-of select="$MainRisk/Mult" />
				</PolicyAmmount>
				<!-- ���� -->
				<Amt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
				</Amt>
				<!-- ���� -->
				<Beamt>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
				</Beamt>
				<!-- ������ֵ -->
				<PolicyValue>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueD)" />
				</PolicyValue>
				
				
				<!-- ��ǰ�˻���ֵ -->
				<AccountValue>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/CashValueIntD)" />
				</AccountValue>
				<!-- �����ڼ� -->
				<InsuDueDate>
					<!-- <xsl:value-of select="$MainRisk/Years" /> -->
					<xsl:choose>
						<xsl:when test="$MainRisk/InsuYearFlag='A' and $MainRisk/InsuYear='106'">����</xsl:when>
						<xsl:otherwise><xsl:value-of select="$MainRisk/Years" /></xsl:otherwise>
					</xsl:choose>
				</InsuDueDate>
				<!-- �ɷѷ�ʽ -->
				<PayType>
					<xsl:apply-templates select="$MainRisk/PayIntv" mode="PayType"/>
				</PayType>
				<!-- �ɷѽ�� -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
				</Prem>
				<!-- �ɷ��˻� -->
				<PayAccount>
					<xsl:value-of select="Account/AccNo" />
				</PayAccount>
				
				<!-- Ͷ���� -->
				<xsl:apply-templates select="Appnt" />
				<!-- ������ -->
				<xsl:apply-templates select="Insured" />
				<!-- ������ -->
				<xsl:for-each select="Bnf">
					<Bnfs>
						<!-- ���������� -->
						<Type>
							<xsl:value-of select="Type" />
						</Type>
						<!-- ���������� -->
						<Name>
							<xsl:value-of select="Name" />
						</Name>
						<!-- �������Ա� -->
						<Sex>
							<xsl:value-of select="Sex" />
						</Sex>
						<!-- ������֤������ -->
						<IDKind>
							<xsl:apply-templates select="IDType" />
						</IDKind>
						<!-- ������֤������ -->
						<IDCode>
							<xsl:value-of select="IDNo" />
						</IDCode>
						<!-- �뱻���˹�ϵ -->
						<RelaToInsured>
							<xsl:value-of select="RelaToInsured"/>
						</RelaToInsured>
						<!-- ����������˳�� -->
						<Sequence>
							<xsl:value-of select="Grade" />
						</Sequence>
						<!-- ������������� -->
						<Prop>
							<xsl:value-of select="Lot" />
						</Prop>
						</Bnfs>
				</xsl:for-each>
				<!-- ���Ӽ�¼���� (ʢ2û�и����գ� ֱ��Ϊ0)-->
				<PrntCount>0</PrntCount>
			</Ret>
		</App>
	</xsl:template>
	
	<!-- Ͷ���� -->
	<xsl:template match="Appnt">
		<Appl>
			<!-- Ͷ����֤������ -->
			<IDKind>
				<xsl:apply-templates select="IDType" />
			</IDKind>
			<!-- Ͷ����֤������ -->
			<IDCode>
				<xsl:value-of select="IDNo" />
			</IDCode>
			<!-- Ͷ�������� -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- Ͷ�����Ա� -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- Ͷ���˳������� -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<!-- Ͷ����ͨѶ��ַ -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- Ͷ������������ -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- Ͷ���˵������� -->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
			<!-- Ͷ���˹̶��绰 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- Ͷ�����ƶ��绰 -->
			<Mobile>
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- Ͷ���������� -->
			<AnnualIncome>
				<xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Salary)"/>
			</AnnualIncome>
			<!-- Ͷ�����뱻�����˹�ϵ -->
			<xsl:choose>
				<xsl:when test="Sex='0'">
					<RelaToInsured>
						<xsl:apply-templates select="RelaToInsured" mode="sale" />
					</RelaToInsured>
				</xsl:when>
				<xsl:otherwise>
					<RelaToInsured>
						<xsl:apply-templates select="RelaToInsured" mode="tain" />
					</RelaToInsured>
				</xsl:otherwise>
			</xsl:choose>
		</Appl>
	</xsl:template>
	<!-- ������ -->
	<xsl:template match="Insured">
		<Insu>
			<!-- ���������� -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- �������Ա� -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- ������֤������ -->
			<IDKind>
				<xsl:apply-templates select="IDType" />
			</IDKind>
			<!-- ������֤������ -->
			<IDCode>
				<xsl:value-of select="IDNo" />
			</IDCode>
			<!-- �����˳������� -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
		</Insu>
	</xsl:template>
	<!-- ��ϵ -->
	<xsl:template match="RelaToInsured" mode="sale">
		<xsl:choose>
				<xsl:when test=".='00'">01</xsl:when><!-- ���� -->
				<xsl:when test=".='02'">02</xsl:when><!-- �ɷ� -->
				<xsl:when test=".='01'">04</xsl:when><!-- ���� -->
				<xsl:when test=".='03'">06</xsl:when><!-- ���� -->
				<xsl:otherwise>30</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- ��ϵ -->
	<xsl:template match="RelaToInsured" mode="tain">
		<xsl:choose>
				<xsl:when test=".='00'">01</xsl:when><!-- ���� -->
				<xsl:when test=".='02'">03</xsl:when><!-- ���� -->
				<xsl:when test=".='01'">05</xsl:when><!-- ĸ�� -->
				<xsl:when test=".='03'">07</xsl:when><!-- Ů�� -->
				
				<xsl:otherwise>30</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ����״̬ �����D�o�y��-->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">00</xsl:when><!-- ������Ч  -->
			<xsl:when test=".='01'">04</xsl:when><!-- ������ֹ -->
			<xsl:when test=".='02'">01</xsl:when><!-- �˱���ֹ-->
			<xsl:when test=".='04'">07</xsl:when><!-- ������ֹ-->
			<xsl:when test=".='WT'">03</xsl:when><!-- ��ԥ�����˱���ֹ-->
			<xsl:when test=".='B'">08</xsl:when><!-- ��ǩ��-->
			<xsl:when test=".='C'">02</xsl:when><!-- ���ճ���-->
			<xsl:otherwise>05</xsl:otherwise><!-- ����������״̬����ȷ -->
		</xsl:choose>
	</xsl:template>
	<!-- ֤������ -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">110001</xsl:when><!--�������֤                -->
			<xsl:when test=".='5'">110005</xsl:when><!--���ڲ�                    -->		
			<xsl:when test=".='1'">110023</xsl:when><!--�л����񹲺͹�����        -->
			<xsl:when test=".='2'">110027</xsl:when><!--����֤                    -->
            <xsl:otherwise>119999</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �ɷѷ�ʽ��Ƶ�Σ� -->
	<xsl:template match="PayIntv" mode="PayType">
		<xsl:choose>
		    <xsl:when test=".='-1'">0</xsl:when><!--  ������ -->
			<xsl:when test=".='0'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">2</xsl:when><!-- �½� -->
			<xsl:when test=".='3'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='6'">4</xsl:when><!-- ���꽻 -->
			<xsl:when test=".='12'">5</xsl:when><!-- �꽻 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ����״̬ -->
	<xsl:template match="MortStatu">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when><!-- δ��Ѻ -->
			<xsl:when test=".=1">1</xsl:when><!-- ��Ѻ -->
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template  match="RiskCode"  mode="risk">
		<xsl:choose>
			<!-- ���ߺ��洢�����ִ��벢������� -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			<!-- guning -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
			<!-- guning -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ��� -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ײʹ��� -->
	<xsl:template  match="ContPlanCode" mode="contplan">
		<xsl:choose>
			<!-- 50001-�������Ӯ1����ȫ�������:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ���� -->
			<xsl:when test=".='50001'">122046</xsl:when>
			<!-- 50002(50015): 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048(L12081)-����������������գ������ͣ���� -->
			<xsl:when test=".='50015'">50002</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

</xsl:stylesheet>
