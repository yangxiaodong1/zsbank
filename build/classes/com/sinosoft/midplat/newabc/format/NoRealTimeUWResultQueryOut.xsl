<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="TranData/Head" />
			<Body>
				<!-- ��������Ϣ -->
				<Detail>
					<count>
						<xsl:value-of select="count(//Detail[ContState='3'])" />
					</count>
					<ActSumPrem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(sum(//Detail[ContState='3']/ActPrem))" />
					</ActSumPrem>
					<remark />
				</Detail>

				<!-- ��ϸ��Ϣ -->
				<xsl:for-each select="//Detail[ContState='3']">
					<xsl:variable name="mainRisk" select="Risk[RiskCode=MainRiskCode]" />
					<Detail>
						<!-- ԭ��������(yyyyMMdd)-->
						<PolApplyDate>
							<xsl:value-of select="ApplyDate" />
						</PolApplyDate>
						<!-- ���з�������ˮ�� -->
						<TranNo>
							<xsl:value-of select="TranNo" />
						</TranNo>
						<AppntName>
							<xsl:value-of select="Appnt/Name" />
						</AppntName>
						<!-- Ͷ����֤������-->
						<AppntIDType>
							<xsl:call-template name="IDKind">
								<xsl:with-param name="value" select="Appnt/IDType" />
							</xsl:call-template>
						</AppntIDType>
						<!-- Ͷ����֤����-->
						<AppntIDNo>
							<xsl:value-of select="Appnt/IDNo" />
						</AppntIDNo>
						<RiskCode>
							<xsl:if test="ContPlanCode!=''">
								<xsl:apply-templates select="ContPlanCode" />
							</xsl:if>
							<xsl:if test="ContPlanCode=''">
								<xsl:apply-templates select="$mainRisk/RiskCode" />
							</xsl:if>
						</RiskCode>
						<ProdCode></ProdCode>
						<!--������-->
						<ContNo>
							<xsl:value-of select="ContNo" />
						</ContNo>
						<!-- �б�����(yyyyMMdd) -->
						<SignDate>
							<xsl:value-of select="$mainRisk/SignDate" />
						</SignDate>
						<!-- �뱻���˹�ϵ -->
						<RelaToInsured>
							<xsl:call-template name="tran_relation">
								<xsl:with-param name="relation" select="//Appnt/RelaToInsured" />
								<xsl:with-param name="sex" select="//Appnt/sex" />
							</xsl:call-template>
						</RelaToInsured>
						<!-- ���������� -->
						<InsuredName>
							<xsl:value-of select="Insured/Name" />
						</InsuredName>
						<!-- ������֤������-->
						<InsuredIDType>
							<xsl:call-template name="IDKind">
								<xsl:with-param name="value" select="Insured/IDType" />
							</xsl:call-template>
						</InsuredIDType>
						<!-- ������֤����-->
						<InsuredIDNo>
							<xsl:value-of select="Insured/IDNo" />
						</InsuredIDNo>
						<!--�����ܱ���-->
						<Prem>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" />
						</Prem>
						<!--�ܱ�����ڸ�risk�µ�amnt֮��-->
						<Amnt>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
						</Amnt>
						<!-- �ɷ��˻� -->
						<AccNo>
							<xsl:value-of select="AccNo" />
						</AccNo>
						<!-- �ɷѷ�ʽ -->
						<PayIntv>
							<xsl:apply-templates select="$mainRisk/PayIntv" />
						</PayIntv>
						<!-- �ɷ����� -->
						<PayEndYear></PayEndYear>
						<!-- ����������ֹ����-->
						<InsuEndDate>
							<xsl:value-of select="$mainRisk/InsuEndDate" />
						</InsuEndDate>
						<!--����-->
						<Mult>
							<xsl:value-of select="$mainRisk/Mult" />
						</Mult>
						<!-- ���Ի����� -->
						<Rate></Rate>
						<!-- ����ӡˢ�� -->
						<ContPrtNo></ContPrtNo>
						<remark></remark>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template name="IDKind">
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$value='0'">110001</xsl:when><!--�������֤                -->
			<xsl:when test="$value='5'">110005</xsl:when><!--���ڲ�                    -->
			<xsl:when test="$value='1'">110023</xsl:when><!--�л����񹲺͹�����        -->
			<xsl:when test="$value='2'">110027</xsl:when><!--����֤                    -->
			<xsl:otherwise>119999</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>

	<!-- �뱻���˹�ϵ -->
	<xsl:template name="tran_relation">
		<xsl:param name="relation" />
		<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$relation=00">01</xsl:when><!-- ���� -->
			<xsl:when test="$relation=01"><!-- ��ĸ -->
				<xsl:choose>
					<xsl:when test="$sex=0">04</xsl:when>
					<xsl:otherwise>05</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=02"><!-- ��ż -->
				<xsl:choose>
					<xsl:when test="$sex=0">02</xsl:when>
					<xsl:otherwise>03</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=03"><!-- ��Ů -->
				<xsl:choose>
					<xsl:when test="$sex=0">06</xsl:when>
					<xsl:otherwise>07</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$relation=04">30</xsl:when><!-- ���� -->
			<xsl:otherwise>30</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ�Ƶ�� -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='-1'">0</xsl:when><!--  ������ -->
			<xsl:when test=".='0'">1</xsl:when><!--  ���� -->
			<xsl:when test=".='1'">2</xsl:when><!-- �½� -->
			<xsl:when test=".='3'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='6'">4</xsl:when><!-- ���꽻 -->
			<xsl:when test=".='12'">5</xsl:when><!-- �꽻 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template match="RiskCode | ContPlanCode">
		<xsl:choose>
			<xsl:when test=".='50001'">122046</xsl:when><!-- ������Ӯ1���ײ� -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- ������Ӯ���ռƻ��ײ� -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�B��  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122006'">122006</xsl:when><!-- ����۱���2����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- ���������1����������(������)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- ����ƽ�2����ȫ����(�ֺ���)A��  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- ����ƽ�3����ȫ����(�ֺ���)A��  -->
			
			<!-- ���ߺ󣬻�������ִ��벢�������� -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- ������Ӯ���ռƻ��ײ� -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			
			<!-- ����ٰ���5�ű��ռƻ�50012,����ٰ���5�������L12070,����ӳ�������5����ȫ���գ������ͣ�L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>