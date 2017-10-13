<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head"/>
			<TXLifeResponse>
				<TransRefGUID/>
				<TransType>1013</TransType>
				<TransExeDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()"/>
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				</TransExeTime>
				<xsl:apply-templates select="TranData/Body"/>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	<xsl:template name="OLifE" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<OLifE>
			<Holding id="cont">
				<CurrencyTypeCode>001</CurrencyTypeCode>
				<!-- ������Ϣ -->
				<Policy>
					<!-- ������ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo"/>
					</PolNumber>
					<!--���ڱ���-->
					<PaymentAmt>
						<xsl:value-of select="ActSumPrem"/>
					</PaymentAmt>
					<!-- ���ڱ��շѺϼƣ�����PaymentAmtת��Ϊ���ֽ�� ��RMBPaymentAmtԪ�� -->
					<Life>
						<CoverageCount>1</CoverageCount>
						<!--
						<CoverageCount>
							<xsl:value-of select="count(Risk)"/>
						</CoverageCount>
						 -->
						<xsl:apply-templates select="$MainRisk"/>
					</Life>
					<!--������Ϣ-->
					<ApplicationInfo>
						<!--Ͷ�����-->
						<HOAppFormNumber>
							<xsl:value-of select="ProposalPrtNo"/>
						</HOAppFormNumber>
						<SubmissionDate>
							<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/PolApplyDate)"/>
						</SubmissionDate>
					</ApplicationInfo>
					<OLifEExtension>
						<!-- �ر�Լ�� -->
						<SpecialClause>
							<xsl:value-of select="$MainRisk/SpecContent"/>
						</SpecialClause>
						<!-- �ɱ���ӡˢ�� -->
						<OriginalPolicyFormNumber/>
						<!-- ���չ�˾����绰 -->
						<InsurerDialNumber>95569</InsurerDialNumber>
						<!-- �����ͬ�� -->
						<ContractNo/>
						<!-- �����˺� -->
						<LoanAccountNo/>
						<!-- �����Ʒ���� -->
						<LoanProductCode/>
						<LoanAmount/>
						<!-- ����� -->
						<FaceAmount/>
						<!-- ���ս�� -->
						<LoanStartDate/>
						<!-- ������ʼ���� -->
						<LoanEndDate/>
						<!-- ��������� -->
						<!-- ���պ�ͬ��Ч���� -->
						<ContractEffDate>
							<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/CValiDate)"/>
						</ContractEffDate>
						<!-- ���պ�ͬ�������� -->
						<ContractEndDate>
							<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/InsuEndDate)"/>
						</ContractEndDate>
						<!-- ���պ�ͬ�������� -->
						<CovType/>
						<!-- �������� -->
						<!-- ��Ԯ�ձ�����Ϣ -->
						<CovArea/>
						<!-- �������� -->
						<StartDate/>
						<!-- �������� -->
						<EndDate/>
						<!-- ����ֹ�� -->
						<GrossPremAmt>
							<xsl:value-of select="//Body/ActSumPrem"/>
						</GrossPremAmt>
						<!-- �ܱ��� -->
						<CountryTo/>
						<!-- ǰ������ -->
						<!-- ������Ϣ -->
						<CovPeriod/>
						<!-- �������ޣ��죩 -->
						<CalAmount/>
						<!-- ������ܱ��� -->
					</OLifEExtension>
				</Policy>
			</Holding>
		</OLifE>
		<!--�������д�ӡ�ӿ�-->
		<Print>
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<SubVoucher>
				<!--ƾ֤����3����-->
				<VoucherType>3</VoucherType>
				<!--��ҳ��-->
				<PageTotal>1</PageTotal>
				<Text>
					<!--ҳ��-->
					<PageNum>1</PageNum>
					<!--һ�д�ӡ������-->
					<xsl:variable name="Falseflag" select="java:java.lang.Boolean.parseBoolean('true')"/>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>���յ����룺<xsl:value-of select="ContNo"/>                                                    ��ֵ��λ�������Ԫ</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>
							<xsl:text>Ͷ����������</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 20)"/>
							<xsl:text>         ֤�����ͣ�</xsl:text>
								<xsl:choose>
									<xsl:when test="Appnt/IDType = 0">
										<xsl:text>���֤    </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 1">
										<xsl:text>����      </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 2">
										<xsl:text>����֤    </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 3">
										<xsl:text>����      </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 4">
										<xsl:text>����֤��  </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 5">
										<xsl:text>���ڲ�    </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 8">
										<xsl:text>����      </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 9">
										<xsl:text>�쳣���֤</xsl:text>
									</xsl:when>
									<xsl:otherwise>--      </xsl:otherwise>
								</xsl:choose>
							<xsl:text>          ֤�����룺</xsl:text>
							<xsl:value-of select="Appnt/IDNo"/>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>
							<xsl:text>�������ˣ�</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 20)"/>
							<xsl:text>           ֤�����ͣ�</xsl:text>
							<xsl:choose>
									<xsl:when test="Insured/IDType = 0">
										<xsl:text>���֤    </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 1">
										<xsl:text>����      </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 2">
										<xsl:text>����֤    </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 3">
										<xsl:text>����      </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 4">
										<xsl:text>����֤��  </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 5">
										<xsl:text>���ڲ�    </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 8">
										<xsl:text>����      </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 9">
										<xsl:text>�쳣���֤</xsl:text>
									</xsl:when>
									<xsl:otherwise>--      </xsl:otherwise>
								</xsl:choose> 
							<xsl:text>          ֤�����룺</xsl:text>
							<xsl:value-of select="Insured/IDNo"/>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>					
					<TextRowContent/>
					<xsl:variable name="BnfCount" select="count(Bnf)"/>
					<xsl:variable name="Ser1">
						<xsl:if test="$BnfCount = 0">
							<xsl:value-of select="1"/>
						</xsl:if>
						<xsl:if test="$BnfCount != 0">
							<xsl:value-of select="$BnfCount"/>
						</xsl:if>
					</xsl:variable>
					<xsl:if test="$BnfCount = 0">
						<TextContent>
							<TextRowContent>
								<xsl:text>��������ˣ�����                </xsl:text>
								<xsl:text>����˳��1                   </xsl:text>
								<xsl:text>���������100%</xsl:text>
							</TextRowContent>
						</TextContent>
					</xsl:if>
					<xsl:if test="$BnfCount != 0">
						<xsl:variable name="flag" select="java:java.lang.Boolean.parseBoolean('false')"/>
						<xsl:for-each select="Bnf">
							<TextContent>
								<TextRowContent>
									<xsl:text/>��������ˣ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
									<xsl:text>����˳��</xsl:text>
									<xsl:value-of select="Grade"/>
									<xsl:text>               </xsl:text>
									<xsl:text> ���������</xsl:text>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Lot, 3, $flag)"/>
									<xsl:text>%</xsl:text>
								</TextRowContent>
							</TextContent>
						</xsl:for-each>
					</xsl:if>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>��������</xsl:text>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>��������������                                             �������ս��\</xsl:text>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>����������������������              �����ڼ�     ��������    �ս�����\      ���շ�    ����Ƶ��</xsl:text>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>��������������                                               ����\����</xsl:text>
						</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<xsl:for-each select="Risk">
						<TextContent>
							<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
							<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
							<TextRowContent>
								<xsl:choose>
									<xsl:when test="RiskCode='122048'">
										<xsl:text/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
											</xsl:when>
											<xsl:when test="InsuYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
												<xsl:text></xsl:text>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="PayIntv = 0">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 10)"/>
											</xsl:when>
											<xsl:when test="PayEndYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 10)"/>
											</xsl:when>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',15)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
										<xsl:choose>
											<xsl:when test="PayIntv = 0">
												<xsl:text>-</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = 12">
												<xsl:text>���</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = 6">
												<xsl:text>�����</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = 3">
												<xsl:text>����</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = 1">
												<xsl:text>�½�</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = -1">
												<xsl:text>�����ڽ�</xsl:text>
											</xsl:when>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
											</xsl:when>
											<xsl:when test="InsuYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
												<xsl:text></xsl:text>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="PayIntv = 0">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 10)"/>
											</xsl:when>
											<xsl:when test="PayEndYearFlag = 'Y'">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 10)"/>
											</xsl:when>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',15)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
										<xsl:choose>
											<xsl:when test="PayIntv = 0">
												<xsl:text>����</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = 12">
												<xsl:text>���</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = 6">
												<xsl:text>�����</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = 3">
												<xsl:text>����</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = 1">
												<xsl:text>�½�</xsl:text>
											</xsl:when>
											<xsl:when test="PayIntv = -1">
												<xsl:text>�����ڽ�</xsl:text>
											</xsl:when>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</TextRowContent>
						</TextContent>
					</xsl:for-each>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text/>���շѺϼƣ�<xsl:value-of select="ActSumPremText"/>��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>
							<xsl:text>���յ��ر�Լ����</xsl:text>
						</TextRowContent>
					</TextContent>
					<xsl:choose>
						<xsl:when test="SpecContent = ''">
							<TextContent>
								<TextRowContent><xsl:text>���ޣ�</xsl:text></TextRowContent>
							</TextContent>
						</xsl:when>
						<xsl:otherwise>
							<TextContent>
								<TextRowContent>    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>�ֽ��ֵ��</TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>�������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ�</TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>�ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</TextRowContent>
							</TextContent>
						</xsl:otherwise>
					</xsl:choose>
					<TextContent>
						<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>���պ�ͬ�������ڣ�<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/SignDate)"/>
							<xsl:text>                                       </xsl:text>���պ�ͬ��Ч���ڣ�<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/CValiDate)"/></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>�ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent><xsl:text>��һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent/>
					</TextContent>
					<TextContent>
						<TextRowContent>�����������ƣ��й���������</TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>�����������ƣ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 53)"/>ҵ�����֤��ţ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode, 20)"/></TextRowContent>
					</TextContent>
					<TextContent>
						<TextRowContent>����������Ա��<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,53)"/>��ҵ�ʸ�֤��ţ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 20)"/></TextRowContent>
					</TextContent>
				</Text>
			</SubVoucher>
			<xsl:if test="$MainRisk/CashValues/CashValue != ''">
				<SubVoucher>
					<!--ƾ֤���� 4 �ּ۱�-->
					<VoucherType>4</VoucherType>
					<!--��ҳ��-->
					<PageTotal>1</PageTotal>
					<Text>
						<PageNum>1</PageNum>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent />
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text/>                                        �ֽ��ֵ��                     </TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text/>���յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
								<xsl:text/>��������������<xsl:value-of select="Insured/Name"/></TextRowContent>
						</TextContent>
						<xsl:if test="$RiskCount = 1">
							<TextContent>
								<TextRowContent><xsl:text/>�������ƣ�<xsl:text>                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>
									<xsl:text/>�������ĩ<xsl:text>                              </xsl:text>
									<xsl:text>�ֽ��ֵ</xsl:text></TextRowContent>
							</TextContent>
							<xsl:for-each select="$MainRisk/CashValues/CashValue">
								<TextContent>
									<TextRowContent>
										<xsl:text/><xsl:text>����</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</TextRowContent>
								</TextContent>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="$RiskCount != 1">
							<TextContent>
								<TextRowContent><xsl:text/>�������ƣ�<xsl:text>              </xsl:text>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/>
									<xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></TextRowContent>
							</TextContent>
							<TextContent>
								<TextRowContent>
									<xsl:text/>�������ĩ<xsl:text>                       �ֽ��ֵ                               </xsl:text>
									<xsl:text>�ֽ��ֵ</xsl:text></TextRowContent>
							</TextContent>
							<xsl:for-each select="$MainRisk/CashValues/CashValue">
								<xsl:variable name="EndYear" select="EndYear"/>
								<TextContent>
									<TextRowContent>
										<xsl:text/><xsl:text>����</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</TextRowContent>
								</TextContent>
							</xsl:for-each>
						</xsl:if>
						<xsl:variable name="CashCount" select="count($MainRisk/CashValues/CashValue)"/>
						<TextContent>
							<TextRowContent>
								<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text>��ע��</xsl:text>
						</TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
							<xsl:text>�����ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ�� </xsl:text></TextRowContent>
						</TextContent>
						<TextContent>
							<TextRowContent>
								<xsl:text/>------------------------------------------------------------------------------------------------</TextRowContent>
						</TextContent>
						<!-- 
						<RowTotal><xsl:value-of select="18 + $CashCount"/></RowTotal>
						 -->
					</Text>
				</SubVoucher>
			</xsl:if>
		</Print>
	</xsl:template>
	<!-- ������Ϣ -->
	<xsl:template name="Coverage" match="Risk">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<Coverage>
			<xsl:attribute name="id"><xsl:value-of select="concat('risk_', string(position()))"/></xsl:attribute>
			<!-- ��������, �˴���ʾ��ϲ�Ʒ������ -->
			<PlanName><xsl:value-of select="../ContPlan/ContPlanName"/></PlanName>
			<!-- ���ִ��� -->
			<ProductCode>
				<xsl:apply-templates select="RiskCode"/>
			</ProductCode>
			<!-- �������� LifeCovTypeCode-->
			<xsl:choose>
				<xsl:when test="RiskCode='122008'">
					<LifeCovTypeCode>1</LifeCovTypeCode>
					<!-- ���������� -->
				</xsl:when>
				<xsl:otherwise>
					<LifeCovTypeCode>9</LifeCovTypeCode>
					<!-- �������� -->
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!-- �����ձ�־ -->
				<xsl:when test="RiskCode=MainRiskCode">
					<IndicatorCode tc="1">1</IndicatorCode>
				</xsl:when>
				<xsl:otherwise>
					<IndicatorCode tc="2">2</IndicatorCode>
				</xsl:otherwise>
			</xsl:choose>
			<!-- �ɷѷ�ʽ Ƶ�� -->
			<PaymentMode>
				<xsl:call-template name="tran_PayIntv">
					<xsl:with-param name="PayIntv">
						<xsl:value-of select="PayIntv"/>
					</xsl:with-param>
				</xsl:call-template>
			</PaymentMode>
			<!-- Ͷ����� -->
			<InitCovAmt>
				<xsl:choose>
					<xsl:when test="Amnt>=0">
						<xsl:value-of select="Amnt"/>
					</xsl:when>
					<xsl:otherwise>--</xsl:otherwise>
				</xsl:choose>
			</InitCovAmt>
			<!--  -->
			<FaceAmt>
				<xsl:choose>
					<xsl:when test="Amnt>=0">
						<xsl:value-of select="Amnt"/>
					</xsl:when>
					<xsl:otherwise>--</xsl:otherwise>
				</xsl:choose>
			</FaceAmt>
			<!-- Ͷ���ݶ� -->
			<IntialNumberOfUnits>
				<xsl:choose>
					<xsl:when test="../ContPlan/ContPlanMult>0">
						<xsl:value-of select="../ContPlan/ContPlanMult"/>
					</xsl:when>
					<xsl:otherwise>--</xsl:otherwise>
				</xsl:choose>
			</IntialNumberOfUnits>
			<!-- ���ֱ��� -->
			<ModalPremAmt>
				<xsl:value-of select="../ActSumPrem"/>
			</ModalPremAmt>
			<!-- ������ -->
			<EffDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(CValiDate)"/>
			</EffDate>
			<!-- ������ֹ���� -->
			<TermDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(InsuEndDate)"/>
			</TermDate>
			<!-- ������ʼ���� -->
			<FirstPaymentDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(SignDate)"/>
			</FirstPaymentDate>
			<!-- �ɷ���ֹ���� -->
			<FinalPaymentDate>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(PayEndDate)"/>
			</FinalPaymentDate>
			<OLifEExtension>
				<xsl:choose>
					<!-- FIXME ����ط������ʣ��Ƿ�Ҫ�������ͽӿ��ĵ�������ԼӦ��_�������д�ӡ�ӿ��ĵ�.doc���е������в��� -->
					<xsl:when test="(PayEndYear = 1) and (PayEndYearFlag = 'Y')">
						<PaymentDurationMode>5</PaymentDurationMode>
						<PaymentDuration>0</PaymentDuration>
					</xsl:when>
					<xsl:otherwise>
						<PaymentDurationMode>
							<xsl:apply-templates select="PayEndYearFlag"/>
						</PaymentDurationMode>
						<PaymentDuration>
							<xsl:value-of select="PayEndYear"/>
						</PaymentDuration>
					</xsl:otherwise>
				</xsl:choose>
				
				<!-- �����ڼ䣺��Ҫ����ת��,ת�������Ͽɵı����� -->
				<DurationMode>5</DurationMode>
				<Duration>0</Duration>
				<!-- 
				<xsl:choose>
					<xsl:when test="(InsuYear= 106) and (InsuYearFlag = 'A')">
						<DurationMode>5</DurationMode>
						<Duration>0</Duration>
					</xsl:when>
					<xsl:otherwise>
						<DurationMode>
							<xsl:apply-templates select="InsuYearFlag"/>
						</DurationMode>
						<Duration>
							<xsl:value-of select="InsuYear"/>
						</Duration>
					</xsl:otherwise>
				</xsl:choose>
				 -->
			</OLifEExtension>
		</Coverage>
	</xsl:template>
	<!-- �Ա� -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".=0">��</xsl:when>
			<!-- �� -->
			<xsl:when test=".=1">Ů</xsl:when>
			<!-- Ů -->
			<xsl:when test=".=2">����</xsl:when>
			<!-- ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ֤������ -->
	<xsl:template name="tran_GovtIDTC" match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">0</xsl:when>
			<!-- ���֤ -->
			<xsl:when test=".=1">1</xsl:when>
			<!-- ���� -->
			<xsl:when test=".=2">2</xsl:when>
			<!-- ����֤ -->
			<xsl:when test=".=5">6</xsl:when>
			<!-- ���ڱ�  -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ��ϵ -->
	<xsl:template name="tran_RelationRoleCode" match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".=01">1</xsl:when>
			<!-- ��ż -->
			<xsl:when test=".=03">2</xsl:when>
			<!-- ��ĸ -->
			<xsl:when test=".=04">3</xsl:when>
			<!-- ��Ů -->
			<xsl:when test=".=21">4</xsl:when>
			<!-- �游��ĸ -->
			<xsl:when test=".=31">5</xsl:when>
			<!-- ����Ů -->
			<xsl:when test=".=12">6</xsl:when>
			<!-- �ֵܽ��� -->
			<xsl:when test=".=25">7</xsl:when>
			<!-- �������� -->
			<xsl:when test=".=00">8</xsl:when>
			<!-- ���� -->
			<xsl:when test=".=27">9</xsl:when>
			<!-- ���� -->
			<xsl:when test=".=25">99</xsl:when>
			<!-- ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ���ִ��� -->
	<xsl:template name="tran_ProductCode" match="RiskCode">
		<xsl:choose>
			<xsl:when test=".=122001">001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".=122002">002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".=122003">003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".=122004">101</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".=122006">004</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".=122008">005</xsl:when>	<!-- ���������1���������գ������ͣ� -->
			<xsl:when test=".=122009">006</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".=122010">009</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".=122011">007</xsl:when>	<!-- ����ʢ��1���������գ������ͣ� -->
			<xsl:when test=".=122012">008</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
			
			<xsl:when test=".=122010">009</xsl:when>	<!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".=122029">010</xsl:when>	<!-- ����ʢ��5���������գ������ͣ�  -->
			<xsl:when test=".=122020">011</xsl:when>	<!-- �����6����ȫ���գ��ֺ��ͣ�  -->
			<xsl:when test=".=122036">012</xsl:when>	<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
			
			<!-- ��ϲ�Ʒ: 50002-�������Ӯ���ռƻ�, 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����  -->
			<xsl:when test=".=122046">013</xsl:when>
			<xsl:when test=".=122048">013</xsl:when>
			<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����  -->
			<!-- ǰ����50002����Ʒ������Ϊ122046�������������յĲ�ƷΪ122048,���5������˱�ʱ���Ĵ����������ֱ����122048 -->
		      
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �ɷ���ʽ
<xsl:template name="tran_PaymentMethod" match="PayMode">
<xsl:choose>
	<xsl:when test=".=4">1</xsl:when>	
	
	<xsl:when test=".=3">2</xsl:when>	 
	<xsl:when test=".=1">3</xsl:when>	
	<xsl:when test=".=1">4</xsl:when>	
	<xsl:when test=".=1">5</xsl:when>	
	<xsl:when test=".=4">6</xsl:when>	 
	<xsl:when test=".=8">7</xsl:when>	
	<xsl:when test=".=9">9</xsl:when>	
	
	<xsl:otherwise></xsl:otherwise>
</xsl:choose> 
</xsl:template>
 -->
	<!-- ���ؽɷѷ�ʽ -->
	<xsl:template name="tran_PayIntv">
		<xsl:param name="PayIntv"/>
		<xsl:choose>
			<xsl:when test="PayIntv =12">1</xsl:when>
			<xsl:when test="PayIntv =1">2</xsl:when>
			<xsl:when test="PayIntv =6">3</xsl:when>
			<xsl:when test="PayIntv =3">4</xsl:when>
			<xsl:when test="PayIntv =0">5</xsl:when>
			<xsl:when test="PayIntv =-1">6</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �ɷ�Ƶ��2 -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=12">���</xsl:when>
			<!-- ��� -->
			<xsl:when test=".=1">�½�</xsl:when>
			<!-- �½� -->
			<xsl:when test=".=6">�����</xsl:when>
			<!-- ����� -->
			<xsl:when test=".=3">����</xsl:when>
			<!-- ���� -->
			<xsl:when test=".=0">����</xsl:when>
			<!-- ���� -->
			<xsl:when test=".=-1">�����ڽ�</xsl:when>
			<!-- ������ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �ս����ڱ�־��ת�� -->
	<xsl:template name="tran_PaymentDurationMode" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">1</xsl:when>
			<!-- ����ĳȷ������ -->
			<xsl:when test=".='Y'">2</xsl:when>
			<!-- �� -->
			<xsl:when test=".='M'">3</xsl:when>
			<!-- �� -->
			<xsl:when test=".='D'">4</xsl:when>
			<!-- �� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �����������ڱ�־ -->
	<xsl:template name="tran_DurationMode" match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">1</xsl:when>
			<!-- ����ĳȷ������ -->
			<xsl:when test=".='Y'">2</xsl:when>
			<!-- �걣 -->
			<xsl:when test=".='M'">3</xsl:when>
			<!-- �±� -->
			<xsl:when test=".='D'">4</xsl:when>
			<!-- �ձ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ������ȡ��ʽ��ת�� -->
	<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">�ۻ���Ϣ</xsl:when>
			<xsl:when test=".=2">��ȡ�ֽ�</xsl:when>
			<xsl:when test=".=3">�ֽ�����</xsl:when>
			<xsl:when test=".=5">�����</xsl:when>
			<xsl:when test=".=''">�޺���</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
