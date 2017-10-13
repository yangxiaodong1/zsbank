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
					<TransType>63</TransType>
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
					<!-- ���д��� -->
					<BankCode>06</BankCode>
					<!-- �������루Ԥ���� -->
					<RegionCode>0000</RegionCode>
					<!-- ������루Ԥ���� -->
					<BranchCode>100999</BranchCode>
					<!-- ��Ա���루Ԥ���� -->
					<TellerCode>K03378</TellerCode>
					<OLife>
						<Holding id="Holding_1">
							<Policy>
								<!--������-->
								<PolNumber>
									<xsl:value-of select="ContNo" />
								</PolNumber>
								<!-- ���մ��� -->
								<ProductCode>
									<xsl:apply-templates select="RiskCode" />
								</ProductCode>
								<!--  ����״̬  -->
								<PolicyStatus>
									<xsl:apply-templates select="ContState" />
								</PolicyStatus>
								<!--  ��ԥ�ڽ�ֹ����-->
								<xsl:choose>
									<xsl:when test="HesitateEndDate=''">
										<!-- Ĭ�ϴ�0 -->
										<GracePeriodEndDate>0</GracePeriodEndDate>
									</xsl:when>
									<xsl:otherwise>
										<!--  ��ԥ�ڽ�ֹ����-->
										<GracePeriodEndDate>
											<xsl:value-of select="HesitateEndDate" />
										</GracePeriodEndDate>
									</xsl:otherwise>
								</xsl:choose>
								<!--  ����(ÿ��)�ܱ���  -->
								<PaymentAmt>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(SumPrem)" />
								</PaymentAmt>
								<!-- ���и����ʻ� -->
								<AccountNumber>
									<xsl:value-of select="AccNo" />
								</AccountNumber>
								<!-- �ʻ�����(�������������ҷ����ݿ���ȡ��) -->
								<AcctHolderName></AcctHolderName>
								<ApplicationInfo>
									<!-- Ͷ����� -->
									<HOAppFormNumber>
										<xsl:value-of select="ProposalPrtNo" />
									</HOAppFormNumber>
									<!--  ״̬�������  -->
									<xsl:choose>
										<xsl:when test="ContState='00'">
											<!--  ǩ��״̬  -->
											<SubmissionDate>
												<xsl:value-of select="SignDate" />
											</SubmissionDate>
										</xsl:when>
										<xsl:otherwise>
											<!--  ����״̬  -->
											<SubmissionDate>
												<xsl:value-of select="EdorCTDate" />
											</SubmissionDate>
										</xsl:otherwise>
									</xsl:choose>
								</ApplicationInfo>
							</Policy>
							<OLifeExtension>
								<!-- ��֪�б�  -->
								<TellInfos>
									<TellInfo>
										<!-- ��֪���룺��ԥ�ڿ�ʼ���� -->
										<TellCode>001</TellCode>
										<!-- ��֪���� -->
										<xsl:choose>
											<xsl:when test="HesitateStartDate=''">
												<!-- Ĭ�ϴ�0 -->
												<TellContent>0</TellContent>
											</xsl:when>
											<xsl:otherwise>
												<!-- ��ԥ�ڿ�ʼ���� -->
												<TellContent>
													<xsl:value-of select="HesitateStartDate" />
												</TellContent>
											</xsl:otherwise>
										</xsl:choose>
									</TellInfo>
									<TellInfo>
										<TellCode>002</TellCode>
										<!-- ��֪���룺�طñ�־ -->
										<!-- ��֪���� Y���ѻطã�N��δ�ط�/�ط�ʧ��-->
										<TellContent>
											<xsl:apply-templates select="CallVisitFlag" />
										</TellContent>
									</TellInfo>
									<TellInfo>
										<TellCode>003</TellCode>
										<!-- ��֪���� ���11λ����2ΪС����13λ��Ϊ�ջ���Ϊ0��ʾ�ñ���û�н�����Ѻ����������Ѻ�������ʾ����Ľ���ͻ������ѻ���뷵�ػ�������Ѻ���������Ļ�����0-->
										<!-- ��֪���룺��Ѻ������ -->
										<TellContent>0</TellContent>
									</TellInfo>
								</TellInfos>
							</OLifeExtension>
						</Holding>
					</OLife>
				</TXLifeResponse>
			</TXLife>
		</Detail>
	</xsl:template>


	<!-- ����״̬ -->
	<!-- ����״̬����״̬A:������C:�˱���R:�ܱ���S:��ԥ�ڳ�����F�����ڸ�����L��ʧЧ��J������  -->
	<!-- ����״̬��00:������Ч,01:������ֹ,02:�˱���ֹ,04:������ֹ,WT:��ԥ���˱���ֹ,A:�ܱ�,B:��ǩ��,C:ʧЧ -->
	<xsl:template name="tran_contstate" match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">A</xsl:when>
			<xsl:when test=".='01'">F</xsl:when>
			<xsl:when test=".='02'">C</xsl:when>
			<xsl:when test=".='04'">J</xsl:when>
			<xsl:when test=".='WT'">S</xsl:when>
			<xsl:when test=".='A'">R</xsl:when>
			<xsl:when test=".='C'">L</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �طñ�׼ -->
	<!-- ����״̬��Y���ѻطã�N��δ�ط�/�ط�ʧ�� -->
	<!-- ����״̬��0:�ɹ�,1:ʧ��, -->
	<xsl:template match="CallVisitFlag">
		<xsl:choose>
			<xsl:when test=".='0'">Y</xsl:when>
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<!-- PBKINSR-688 ����ʢ2�����桢��������ʢ3�����桢��������ʢ9�����桢��������ʢ5�����棩��50002�����棩��Ʒ���� -->
			<xsl:when test=".='L12078'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12073'">122029</xsl:when><!-- ����ʢ��5���������գ������ͣ�  -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<!-- PBKINSR-688 ����ʢ2�����桢��������ʢ3�����桢��������ʢ9�����桢��������ʢ5�����棩��50002�����棩��Ʒ���� -->
			<xsl:when test=".='122046'">50002</xsl:when><!--  �������Ӯ1����ȫ���� -->
			<!-- �������Ӯ1������ռƻ�,2014-08-29ͣ��
			<xsl:when test=".='L12052'">50006</xsl:when>
			-->
			
			<!-- ����ٰ���3�ű��ռƻ�=50011,L12068=����ٰ���3�������,L12069=����ӳ�������3����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12068'">50011</xsl:when><!-- ����ٰ���3�ű��ռƻ� -->
			
			<xsl:when test=".='L12052'">L12052</xsl:when><!-- �������Ӯ1������� -->
			
			<!-- �����¾ɲ�Ʒ���빲���������ڷ�������ʱ�������������Ҫӳ�� -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='122029'">122029</xsl:when><!-- ����ʢ��5���������գ������ͣ�  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<!-- �����¾ɲ�Ʒ���빲���������ڷ�������ʱ�������������Ҫӳ�� -->
			<!-- add 20151229 PBKINSR-1010 �����²�Ʒʢ��1������  begin -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<!-- add 20151229 PBKINSR-1010 �����²�Ʒʢ��1������  end -->
			<!-- add 20150222 PBKINSR-1071 �����²�Ʒʢ��1��B������  begin -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1���������գ������ͣ� B�� -->
			<!-- add 20150222 PBKINSR-1071 �����²�Ʒʢ��1��B������  end -->
			<!-- PBKINSR-1444 ���й��涫��3�� L12086  zx add 20160805 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<!-- PBKINSR-1530 ���й��涫��9�� L12088 zx add 20160805 -->
			<xsl:when test=".='L12088'">L12088</xsl:when>
			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
