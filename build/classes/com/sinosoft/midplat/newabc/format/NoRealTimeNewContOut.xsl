<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:output indent='yes' />

	<xsl:template match="/">
		<TranData>
			<xsl:copy-of select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</TranData>
	</xsl:template>

	<xsl:template match="Body">
		<App>
			<Ret>
				<!-- Ͷ���� -->
				<Appl>
					<!-- ���� -->
					<Name>
						<xsl:value-of select="Appnt/Name" />
					</Name>
					<!-- ֤������ -->
					<IDKind>
						<xsl:apply-templates select="Appnt/IDType" />
					</IDKind>
					<!-- ֤������ -->
					<IDCode>
						<xsl:value-of select="Appnt/IDNo" />
					</IDCode>
				</Appl>
				<!-- Ͷ����(ӡˢ)�� -->
				<PolicyApplyNo>
					<xsl:value-of select="ProposalPrtNo" />
				</PolicyApplyNo>
				<!-- ���չ�˾�����ֺ� -->
				<RiskCode>
					<xsl:if test="ContPlan/ContPlanCode!=''">
						<xsl:apply-templates select="ContPlan/ContPlanCode" />
					</xsl:if>
					<xsl:if test="ContPlan/ContPlanCode=''">
						<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]/RiskCode" />
					</xsl:if>
				</RiskCode>
				<!-- ���ж����ֱ�� ת��ʱȡ����ֵ -->
				<ProdCode></ProdCode>
				<!-- ���� -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Risk/Prem)" />
				</Prem>
			</Ret>
		</App>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template match="IDKind">
		<xsl:choose>
			<xsl:when test=".='0'">110001</xsl:when><!--�������֤                -->
			<xsl:when test=".='5'">110005</xsl:when><!--���ڲ�                    -->
			<xsl:when test=".='1'">110023</xsl:when><!--�л����񹲺͹�����        -->
			<xsl:when test=".='2'">110027</xsl:when><!--����֤                    -->
			<xsl:otherwise>119999</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template match="RiskCode | ContPlanCode">
		<xsl:choose>
			<xsl:when test=".='50001'">122046</xsl:when><!-- ������Ӯ1���ײ� -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- ������Ӯ���ռƻ��ײ� -->
			
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�B��  -->
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='122006'">122006</xsl:when><!-- ����۱���2����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- ���������1����������(������)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- ����ƽ�2����ȫ����(�ֺ���)A��  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- ����ƽ�3����ȫ����(�ֺ���)A��  -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- ������Ӯ���ռƻ��ײ� -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ�  -->
			
			<!-- ����ٰ���5�ű��ռƻ�50012,����ٰ���5�������L12070,����ӳ�������5����ȫ���գ������ͣ�L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>