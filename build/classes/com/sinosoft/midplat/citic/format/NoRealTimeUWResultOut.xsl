<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<Body>
				<xsl:for-each select="TranData/Body/Detail">
					<xsl:variable name="ContPlanCode" select="ContPlanCode" />
					<xsl:variable name="ContPlanMult" select="ContPlanMult" />
					<Detail>
						<!--������,��ȡnodeno��ǰ��λ-->
						<Column>
							<xsl:value-of select="substring(NodeNo,0,5)" />
						</Column>
						<!--���չ�˾����-->
						<Column>161</Column>
						<!--��Ӧ�µ����ж���ˮ��-->
						<Column>
							<xsl:value-of select="TranNo" />
						</Column>
						<!-- ���н������� -->
						<Column>
							<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(TranDate)" />
						</Column>
						<!--Ͷ������-->
						<Column>
							<xsl:value-of select="ProposalPrtNo" />
						</Column>
						<!--������-->
						<Column>
							<xsl:value-of select="ContNo" />
						</Column>
						<!--�˱�����-->
						<Column>
							<xsl:apply-templates select="UWResult" mode="uwresult" />
						</Column>
						<!--��ע-->
						<Column>
							<xsl:value-of select="ReMark" />
						</Column>
						<!--�����ܱ��ѣ��֣�-->
						<Column>
							<xsl:value-of select="ActPrem" />
						</Column>
						<!--����������-->
						<Column>
							<xsl:value-of select="Insured/Name" />
						</Column>
						<!--������֤������-->
						<Column>
							<xsl:apply-templates select="Insured/IDType" />
						</Column>
						<!--������֤����-->
						<Column>
							<xsl:value-of select="Insured/IDNo" />
						</Column>
						
						<xsl:choose>
							<xsl:when test="$ContPlanCode=''">
								<!-- ����ϲ�Ʒ -->
								<!--����������Ϣ-->
								<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]"/>
						
								<!--����������Ϣ-->
								<xsl:apply-templates select="Risk[RiskCode!=MainRiskCode]" />
		
								<!--����ȱ�ٵĸ���������Ϣ-->
								<xsl:call-template name="lessRisk">
									<xsl:with-param name="riskcount">
										<xsl:value-of select="count(Risk[RiskCode!=MainRiskCode])"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<!-- ��ϲ�Ʒ -->
								<!--����������Ϣ����ϲ�Ʒ��Ϣ-->
								<!--���ִ��룬��ϲ�Ʒ����-->
								<Column>
									<xsl:apply-templates select="$ContPlanCode" />
								</Column>
								<!--�˱�����״̬-->
								<Column>
									<xsl:apply-templates select="UWResult" mode="uwresultstatus" />
								</Column>
								<!--����-->
								<Column>
									<xsl:value-of select="$ContPlanMult" />
								</Column>
								<!--���ѣ��֣�-->
								<Column>
									<xsl:value-of select="ActPrem" />
								</Column>
								<!--����֣�-->
								<Column>
									<xsl:value-of select="Amnt" />
								</Column>
						
								<!--�������ڵ�����ת��-->
								<xsl:choose>
									<xsl:when test="($ContPlanCode=50015) or ($ContPlanCode=50002)">
												<!--������������-->
												<Column>1</Column>
												<!--��������-->
												<Column>999</Column>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="(Risk[RiskCode=MainRiskCode]/InsuYear= 106) and (Risk[RiskCode=MainRiskCode]/InsuYearFlag = 'A')">
												<!--������������-->
												<Column>1</Column>
												<!--��������-->
												<Column>999</Column>
											</xsl:when>
											<xsl:otherwise>
												<!--������������-->
												<Column>
													<xsl:call-template name="tran_InsuYearFlag">
														<xsl:with-param name="InsuYearFlag">
															<xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuYearFlag" />
														</xsl:with-param>
													</xsl:call-template>
												</Column>
												<!--��������-->
												<Column>
													<xsl:value-of select="Risk[RiskCode=MainRiskCode]/InsuYear" />
												</Column>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
								<!--�ɷѷ�ʽ-->
								<xsl:choose>
							  		<xsl:when test="Risk[RiskCode=MainRiskCode]">
							  			<Column>
											<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]/PayIntv" />
										</Column>		
									</xsl:when>
							  		<xsl:otherwise></xsl:otherwise>
							  	</xsl:choose>
						
								<!--�ɷ����ڵ�����ת��-->
								<xsl:choose>
									<xsl:when test="Risk[RiskCode=MainRiskCode]/PayIntv = '0'">
										<!--�ɷ���������:1����-->
										<Column>1</Column>
										<!--�ɷ�����-->
										<Column>0</Column>
									</xsl:when>
									<xsl:otherwise>
										<!--�ɷ���������-->
										<Column>
											<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]/PayEndYearFlag" />
										</Column>
										<!--�ɷ�����-->
										<Column>
											<xsl:value-of select="Risk[RiskCode=MainRiskCode]/PayEndYear" />
										</Column>
									</xsl:otherwise>
								</xsl:choose>
								
								<!--����ȱ�ٵĸ���������Ϣ����ϲ�Ʒ-->
								<xsl:call-template name="lessRisk">
									<xsl:with-param name="riskcount">0</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
						
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>
	</xsl:template>


	<!-- ������Ϣ -->
	<xsl:template name="risk" match="Risk">
		<!--���ִ���-->
		<Column>
			<xsl:apply-templates select="RiskCode" />
		</Column>
		
		<!--�˱�����״̬-->
		<Column>
			<xsl:apply-templates select="../UWResult" mode="uwresultstatus" />
		</Column>
		<!--����-->
		<Column>
			<xsl:value-of select="Mult" />
		</Column>
		<!--���ѣ��֣�-->
		<Column>
			<xsl:value-of select="RiskActPrem" />
		</Column>
		<!--����֣�-->
		<Column>
			<xsl:value-of select="Amnt" />
		</Column>

		<!--�������ڵ�����ת��-->
		<xsl:choose>
			<xsl:when test="(InsuYear= 106) and (InsuYearFlag = 'A')">
				<!--������������-->
				<Column>5</Column>
				<!--��������-->
				<Column>999</Column>
			</xsl:when>
			<xsl:otherwise>
				<!--������������-->
				<Column>
					<xsl:call-template name="tran_InsuYearFlag">
						<xsl:with-param name="InsuYearFlag">
							<xsl:value-of select="InsuYearFlag" />
						</xsl:with-param>
					</xsl:call-template>
				</Column>
				<!--��������-->
				<Column>
					<xsl:value-of select="InsuYear" />
				</Column>
			</xsl:otherwise>
		</xsl:choose>
		<!--�ɷѷ�ʽ-->
		<xsl:choose>
	  		<xsl:when test="RiskCode=MainRiskCode">
	  			<Column>
					<xsl:apply-templates select="PayIntv" />
				</Column>		
			</xsl:when>
	  		<xsl:otherwise></xsl:otherwise>
	  	</xsl:choose>

		<!--�ɷ����ڵ�����ת��-->
		<xsl:choose>
			<xsl:when test="PayIntv = '0'">
				<!--�ɷ���������:1����-->
				<Column>1</Column>
				<!--�ɷ�����-->
				<Column>0</Column>
			</xsl:when>
			<xsl:otherwise>
				<!--�ɷ���������-->
				<Column>
					<xsl:apply-templates select="PayEndYearFlag" />
				</Column>
				<!--�ɷ�����-->
				<Column>
					<xsl:value-of select="PayEndYear" />
				</Column>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ��ռλ�� -->
	<xsl:template name="lessRisk">
		<xsl:param name="riskcount"/>
		<xsl:if test="4 - $riskcount > 0">
			<!--���ִ���-->
			<Column></Column>
			<!--�˱�����״̬-->
			<Column></Column>
			<!--����-->
			<Column></Column>
			<!--���ѣ��֣�-->
			<Column></Column>
			<!--����֣�-->
			<Column></Column>
			<Column></Column>
			<!--��������-->
			<Column></Column>
			<!--�ɷ���������-->
			<Column></Column>
			<!--�ɷ�����-->
			<Column></Column>
		</xsl:if>
		<xsl:if test="3 - $riskcount > 0">
			<!--���ִ���-->
			<Column></Column>
			<!--�˱�����״̬-->
			<Column></Column>
			<!--����-->
			<Column></Column>
			<!--���ѣ��֣�-->
			<Column></Column>
			<!--����֣�-->
			<Column></Column>
			<Column></Column>
			<!--��������-->
			<Column></Column>
			<!--�ɷ���������-->
			<Column></Column>
			<!--�ɷ�����-->
			<Column></Column>
		</xsl:if>
		<xsl:if test="2 - $riskcount > 0">
			<!--���ִ���-->
			<Column></Column>
			<!--�˱�����״̬-->
			<Column></Column>
			<!--����-->
			<Column></Column>
			<!--���ѣ��֣�-->
			<Column></Column>
			<!--����֣�-->
			<Column></Column>
			<Column></Column>
			<!--��������-->
			<Column></Column>
			<!--�ɷ���������-->
			<Column></Column>
			<!--�ɷ�����-->
			<Column></Column>
		</xsl:if>
		<xsl:if test="1 - $riskcount > 0">
			<!--���ִ���-->
			<Column></Column>
			<!--�˱�����״̬-->
			<Column></Column>
			<!--����-->
			<Column></Column>
			<!--���ѣ��֣�-->
			<Column></Column>
			<!--����֣�-->
			<Column></Column>
			<Column></Column>
			<!--��������-->
			<Column></Column>
			<!--�ɷ���������-->
			<Column></Column>
			<!--�ɷ�����-->
			<Column></Column>
		</xsl:if>
	</xsl:template>

	<!-- ֤������ -->
	<!-- ���У�0�������֤���롢1����֤��8(�۰�)����֤��ͨ��֤��a������b���ڲ���I����  c-̨��֤ 8-�۰�ͨ��֤-->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- ���֤ -->
			<xsl:when test=".='1'">I</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">1</xsl:when><!-- ����֤ -->
			<xsl:when test=".='5'">b</xsl:when><!-- ���ڲ� -->
			<xsl:when test=".='7'">c</xsl:when><!-- ̨��֤ -->
			<xsl:when test=".='6'">8</xsl:when><!-- �۰Ļ���֤ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �˱����� -->
	<xsl:template  match="UWResult" mode="uwresult">
		<xsl:choose>
			<xsl:when test=".='9'">0</xsl:when><!-- ����б� -->
			<xsl:when test=".='4'">2</xsl:when><!-- �����б� -->
			<xsl:when test=".='1'">3</xsl:when><!-- �ܱ� -->
			<xsl:when test=".='a'">4</xsl:when><!-- �ͻ�ȡ��Ͷ��  -->
			<xsl:when test=".='2'">5</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �˱�����״̬,���Ĳ���UWResultStatus��ȡUWResult -->
	<xsl:template  match="UWResult" mode="uwresultstatus">
		<xsl:choose>
			<xsl:when test=".='9'">01</xsl:when><!-- ����ͨ�� -->
			<xsl:when test=".='4'">55</xsl:when><!-- �����б� -->
			<xsl:when test=".='1'">56</xsl:when><!-- �ܱ� -->
			<xsl:when test=".='a'">57</xsl:when><!-- �ͻ�ȡ��Ͷ��  -->
			<xsl:when test=".='2'">58</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷѷ�ʽ ���з���"0=�޹ػ��߲�ȷ��"��"1=���"��"2=�����"��"3=����"��"4=�½�"��"5=����"��"6=�����ڽ�"��"7=���ɰ��¸���"��"0=�޹�" -->
	<xsl:template name="tran_payintv" match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='12'">1</xsl:when><!-- ��� -->
			<xsl:when test=".='1'">4</xsl:when><!-- �½� -->
			<xsl:when test=".='6'">2</xsl:when><!-- ����� -->
			<xsl:when test=".='3'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='0'">5</xsl:when><!-- ���� -->
			<xsl:when test=".='-1'">6</xsl:when><!-- ������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ɷ����ڱ�־,���з���0�޹أ�1������2��ɣ�3����ĳȷ�����䣬4����ɷѣ�5�����ڽɣ�6�½ɣ�7����� -->
	<xsl:template name="tran_PayEndYearFlag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='D'">0</xsl:when><!-- �� -->
			<xsl:when test=".='M'">6</xsl:when><!-- �� -->
			<xsl:when test=".='Y'">2</xsl:when><!-- �� -->
			<xsl:when test=".='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �������ڱ�־ -->
	<xsl:template name="tran_InsuYearFlag">
		<xsl:param name="InsuYearFlag"></xsl:param>
		<xsl:choose>
			<xsl:when test="$InsuYearFlag = 'A'">6</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test="$InsuYearFlag = 'Y'">2</xsl:when><!-- �걣 -->
			<xsl:when test="$InsuYearFlag = 'M'">4</xsl:when><!-- �±� -->
			<xsl:when test="$InsuYearFlag = 'D'">5</xsl:when><!-- �ձ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ����ӳ�� -->
	<xsl:template name="tran_MainRiskCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1���������գ������ͣ�B�� -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ� -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test=".='L12078'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='L12073'">122029</xsl:when><!-- ����ʢ��5���������գ������ͣ� -->
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122036'">122036</xsl:when>	<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
			
			<!-- ��ϲ�Ʒ���ý���ת�����˴�д����Ϊ�˲�ѯ����Щ��ϲ�Ʒ�Ѿ����� -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='122029'">122029</xsl:when><!-- ����ʢ��5���������գ������ͣ� -->
			<xsl:when test=".='122035'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<xsl:when test=".='50015'">50002</xsl:when>	<!-- ������Ӯ��ϲ�Ʒ -->
			<xsl:when test=".='50002'">50002</xsl:when>	<!-- ������Ӯ��ϲ�Ʒ -->
			<xsl:when test=".='50006'">50006</xsl:when>	<!-- ������Ӯ��ϲ�Ʒ -->
			<!-- add by duanjz 2015-6-24 ���Ӱ���5��    begin -->
			<xsl:when test=".='50012'">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
			<xsl:when test=".='L12070'">L12070</xsl:when>	<!-- ����ٰ���5������� -->
			<xsl:when test=".='L12071'">L12071</xsl:when>	<!-- ����ӳ�������5����ȫ���գ������ͣ� -->
			<!-- add by duanjz 2015-6-24 ���Ӱ���5��    begin -->
			<!-- add by duanjz 2015-10-20 ���Ӱ���3��    begin -->
			<xsl:when test=".='50011'">50011</xsl:when>	<!-- ����ٰ���3�ű��ռƻ� -->
			<xsl:when test=".='L12068'">L12068</xsl:when>	<!-- ����ٰ���3������� -->
			<xsl:when test=".='L12069'">L12069</xsl:when>	<!-- ����ӳ�������3����ȫ���գ������ͣ� -->
			<!-- add by duanjz 2015-10-20 ���Ӱ���3��    begin -->
			
			<xsl:when test=".='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ�-->
			<xsl:when test=".='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ�-->
			
			<!-- PBKINSR-1469 ���Ź��涫��9�� L12088 zx add 20160808 -->
			<xsl:when test=".='L12088'">L12088</xsl:when>
			<!-- PBKINSR-1458 ���Ź��涫��2�� L12085 zx add 20160808 -->
			<xsl:when test=".='L12085'">L12085</xsl:when>
			
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="tran_ContPlanCode" match="ContPlanCode">
		<xsl:choose>
			<!-- ������ڼ�����50002��50015������������Ҫ���⡣ -->
			<xsl:when test=".='50015'">50002</xsl:when>	<!-- ������Ӯ��ϲ�Ʒ -->
			<xsl:when test=".='50002'">50002</xsl:when>	<!-- ������Ӯ��ϲ�Ʒ -->
			<xsl:when test=".='50006'">50006</xsl:when>	<!-- ������Ӯ��ϲ�Ʒ -->
			<!-- add by duanjz 2015-6-24 ���Ӱ���5��    begin -->
			<xsl:when test=".='50012'">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
			<!-- add by duanjz 2015-6-24 ���Ӱ���5��    begin -->
			<!-- add by duanjz 2015-10-20 ���Ӱ���3��    begin -->
			<xsl:when test=".='50011'">50011</xsl:when>	<!-- ����ٰ���3�ű��ռƻ� -->
			<!-- add by duanjz 2015-10-20 ���Ӱ���5��    begin -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
