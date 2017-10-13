<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="TranData/Head" />
			<!-- ������ -->
			<Body>
				<xsl:apply-templates select="TranData/Body/Detail" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- �ļ���һ����¼ -->
	<xsl:template match="Detail">
		<Detail>
			<TXLife>
				<TXLifeResponse>
					<!-- ������ˮ�� -->
					<TransRefGUID>0000000001</TransRefGUID>
					<!--  ������/�����־: ������ѯ  -->
					<TransType>64</TransType>
					<!--  ���н�������-->
					<TransExeDate>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
					</TransExeDate>
					<!--  ���н���ʱ�� -->
					<TransExeTime>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
					</TransExeTime>
					<!--  ���չ�˾���루���ж��壩  -->
					<CarrierCode>141</CarrierCode>
					<OLife>
						<Holding id="Holding_1">
							<Life>
								<!-- ���ִ��� -->
								<LifeKey>
									<xsl:apply-templates select="RiskCode" />
								</LifeKey>
								<!--  ��ǰ��������  -->
								<xsl:choose>
									<xsl:when test="CurrIntRate!=''">
										<xsl:variable name="Rate" select="number(CurrIntRate)" />
										<CurrIntRate><xsl:value-of select="format-number($Rate*100, '#.0000')" /></CurrIntRate>
									</xsl:when>
									<xsl:otherwise>
										<CurrIntRate>0</CurrIntRate>
									</xsl:otherwise>
								</xsl:choose>								
								<!--  ���ʿ�ʼ����  -->
								<xsl:choose>
									<xsl:when test="CurrIntRateDate!=''">
										<CurrIntRateDate><xsl:apply-templates select="CurrIntRateDate" /></CurrIntRateDate>
									</xsl:when>
									<xsl:otherwise>
										<CurrIntRateDate>0</CurrIntRateDate>
									</xsl:otherwise>
								</xsl:choose>
							</Life>
							<!-- Ͷ���ձ��뷵�أ������ղ����뷵�� -->
							<!-- <Investment></Investment>  -->
						</Holding>
					</OLife>
				</TXLifeResponse>
			</TXLife>
		</Detail>
	</xsl:template>

	<!-- ���ִ��룺�˴������ִ�������������ռ������գ��ײͲ�Ʒ������������������ղ�Ʒ�������л���ʾ���� -->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='L12078'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12073'">122029</xsl:when><!-- ����ʢ��5���������գ������ͣ�  -->
			<!-- ʢ9���ռ������� -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<xsl:when test=".='122028'">122028</xsl:when><!-- ����Ӱ���7���ش󼲲����� -->
			<xsl:when test=".='122041'">122041</xsl:when><!-- �����ʢ������סԺҽ�Ʊ���A�� -->
			<xsl:when test=".='122042'">122042</xsl:when><!-- �����ʢ������סԺҽ�Ʊ���B�� -->
			<xsl:when test=".='122043'">122043</xsl:when><!-- �����ʢ������������ -->
			<xsl:when test=".='122044'">122044</xsl:when><!-- �����ʢ������������������ -->
			
			<xsl:when test=".='L12052'">L12052</xsl:when><!-- �������Ӯ1������� -->
			<!-- ������Ӯ���ռ������� -->
			<xsl:when test=".='122046'">122046</xsl:when><!--  �������Ӯ1����ȫ���� -->
			<xsl:when test=".='122047'">122047</xsl:when><!--  ����ӳ�����Ӯ��ȫ���� -->
			<xsl:when test=".='L12081'">L12081</xsl:when><!--  ����������������գ������ͣ� -->
			
			<!-- �������Ӯ1������ռƻ�,2014-08-29ͣ��
			<xsl:when test=".='L12052'">50006</xsl:when>
			-->
			
			<!-- ����ٰ���3�ű��ռƻ�=50011,L12068=����ٰ���3�������,L12069=����ӳ�������3����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12068'">L12068</xsl:when><!-- ����ٰ���3������� -->
			<xsl:when test=".='L12069'">L12069</xsl:when><!-- ����ӳ�������3����ȫ���գ������ͣ� -->
			
			<!-- add 20151229 PBKINSR-1010 �����²�Ʒʢ��1������  begin -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<!-- add 20151229 PBKINSR-1010 �����²�Ʒʢ��1������  end -->
			
			<!-- add 20150222 PBKINSR-1071 �����²�Ʒʢ��1��B������  begin -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1���������գ������ͣ�  B��-->
			<!-- add 20160222 PBKINSR-1071 �����²�Ʒʢ��1��B������  end -->
			<!-- PBKINSR-1444 ���й��涫��3�� L12086  zx add 20160805 -->
			<xsl:when test=".='L12086'">L12086</xsl:when> <!-- �����3����ȫ���գ������ͣ� -->
			<!-- PBKINSR-1530 ���й��涫��9�� L12088 zx add 20160805 -->
			<xsl:when test=".='L12088'">L12088</xsl:when> <!-- �����9����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12087'">L12087</xsl:when> <!-- �����5����ȫ���գ������ͣ� -->
			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
