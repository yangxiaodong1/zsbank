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
				<!-- ������Ѻ��� -->
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
				<!-- �Զ�ת����Ȩ�˺�-->
				<AutoTransferAccNo />
			</Ret>
		</App>
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
			<xsl:when test=".='122046'">122046</xsl:when><!-- ������Ӯ1���ײ� -->
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�B��  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ�  -->
			<xsl:when test=".='122006'">122006</xsl:when><!-- ����۱���2����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- ���������1����������(������)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- ����ƽ�2����ȫ����(�ֺ���)A��  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- ����ƽ�3����ȫ����(�ֺ���)A��  -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ײʹ��� -->
	<xsl:template  match="ContPlanCode" mode="contplan">
		<xsl:choose>
			<!-- 50001-�������Ӯ1����ȫ�������:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ���� -->
			<xsl:when test=".='50001'">122046</xsl:when>
			<!-- 50002(50015): 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048(L12081)-����������������գ������ͣ���� -->
			<xsl:when test=".='50015'">50015</xsl:when>
			<xsl:when test=".='50002'">50002</xsl:when>
			<!-- ����ٰ���5�ű��ռƻ�50012,����ٰ���5�������L12070,����ӳ�������5����ȫ���գ������ͣ�L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			<!-- ���ߺ��洢�����ִ��벢������� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

</xsl:stylesheet>
