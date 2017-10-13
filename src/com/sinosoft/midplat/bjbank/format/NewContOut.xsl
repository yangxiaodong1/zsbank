<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<RetData>
				<xsl:variable name ="flag" select ="TranData/Head/Flag"/>
				<xsl:if test="$flag=0">
					<Flag>1</Flag>
				</xsl:if>
				<xsl:if test="$flag=1">
					<Flag>0</Flag>
				</xsl:if>
         		<Desc><xsl:value-of select="TranData/Head/Desc"/></Desc>
			</RetData>
			<xsl:apply-templates select="TranData/Body"/>
			
		</TranData>
	</xsl:template>
	<xsl:template name="LCCont" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<LCCont>
			<ContNo><xsl:value-of select="ContNo"/></ContNo>									<!-- ���յ��� -->		
			<ProposalContNo><xsl:value-of select="ProposalPrtNo"/></ProposalContNo>       <!--��Ͷ����� -->
			<SignDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/SignDate)"/></SignDate>	<!-- �б����� -->
			<CValiDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/CValiDate)"/></CValiDate>													<!-- ��Ч���� -->
			
			<BankAccName><xsl:value-of select="Appnt/Name"/></BankAccName>											<!-- �˻����� -->
			<BankAcc><xsl:value-of select="AccNo"/></BankAcc>															<!-- �����˻� -->
			<AccBankcode></AccBankcode>											<!-- ���б��� -->		
			
			<GetPolMode></GetPolMode>			<!--���������ͷ�ʽ-->
			<SpecContent><xsl:value-of select="SpecContent"/></SpecContent>		<!--���ر�Լ��-->		
			<PrtNo><xsl:value-of select="ContPrtNo"/></PrtNo>       													<!--������ӡˢ��-->
			
			<AgentCode><xsl:value-of select="AgentCode"/></AgentCode>													<!-- �����˱��� -->
			<AgentGroup><xsl:value-of select="AgentGrpCode"/></AgentGroup>												<!-- ��������� -->
			<AgentName><xsl:value-of select="AgentName"/></AgentName>													<!-- ���������� -->    
			<ManageCom><xsl:value-of select="ComName"/></ManageCom>													<!-- �б���˾ -->
			<OperCom><xsl:value-of select="ComCode"/></OperCom>															<!-- Ӫҵ��λ���� -->
			<ComLocation><xsl:value-of select="ComLocation"/></ComLocation>											<!-- ��˾��ַ -->
			<ComPhone><xsl:value-of select="ComPhone"/></ComPhone>														<!-- ��˾�绰 -->
			
			<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></Prem>																		<!-- �ܱ���Сд -->		
			<PremText><xsl:value-of select="ActSumPremText"/></PremText>														<!-- �ܱ��Ѵ�д -->
		
		<!-- Ͷ������Ϣ -->	
		<LCAppnt>
		
		  	<AppntNo><xsl:value-of select="Appnt/CustomerNo"/></AppntNo>								          <!--��Ͷ���˿ͻ���--> 
			<AppntName><xsl:value-of select="Appnt/Name"/></AppntName>								<!--��Ͷ��������-->
			<AppntSex><xsl:value-of select="Appnt/Sex"/></AppntSex>											<!--��Ͷ�����Ա�-->
			<AppntBirthday>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Appnt/Birthday)"/>
			</AppntBirthday>			<!--��Ͷ���˳�������-->
			<AppntIDType>
				<xsl:call-template name="tran_idtype">
					<xsl:with-param name="idtype">
						<xsl:value-of select ="Appnt/IDType"/>
					</xsl:with-param>
				</xsl:call-template>
			</AppntIDType>								<!--��Ͷ����֤������-->
			<AppntIDNo><xsl:value-of select="Appnt/IDNo"/></AppntIDNo>			<!--��Ͷ����֤������-->			
			<AppntNativePlace>
			<xsl:call-template name="tran_nationality">
					<xsl:with-param name="nationality">
						<xsl:value-of select="Appnt/Nationality"/>
					</xsl:with-param>
			</xsl:call-template>
			</AppntNativePlace>		  	<!--��Ͷ���˹���-->
			<AppntNationality></AppntNationality>		  	<!---Ͷ��������-->
			<AppntMarriage></AppntMarriage>		  	      <!---Ͷ���˻���״��-->
			<AppntStature><xsl:value-of select="Appnt/Stature"/></AppntStature>		          	<!--��Ͷ�������-->
			<AppntAvoirdupois><xsl:value-of select="Appnt/Weight"/></AppntAvoirdupois>		  	<!--��Ͷ��������-->
			<AppntSmokeFlag></AppntSmokeFlag>		  	    <!--���Ƿ����̱�־-->
						
			<AppntOfficePhone></AppntOfficePhone>				<!-- Ͷ���˰칫�绰 -->
			<AppntMobile><xsl:value-of select="Appnt/Mobile"/></AppntMobile>									<!-- Ͷ�����ƶ��绰 -->
			<AppntPhone><xsl:value-of select="Appnt/Phone"/></AppntPhone>										<!-- Ͷ����סլ�绰 -->

			<MailAddress><xsl:value-of select="Appnt/Address"/></MailAddress>									<!-- Ͷ�����ʼĵ�ַ -->
			<MailZipCode><xsl:value-of select="Appnt/ZipCode"/></MailZipCode>									<!-- Ͷ�����ʼ��ʱ� -->
			<HomeAddress><xsl:value-of select="Appnt/Address"/> </HomeAddress>					<!-- Ͷ���˼�ͥ��ַ -->
			<HomeZipCode><xsl:value-of select="Appnt/ZipCode"/></HomeZipCode>						<!--��Ͷ���˼�ͥ�ʱ� -->
			<AppntEmail><xsl:value-of select="Appnt/Email"/></AppntEmail>					        	<!--Ͷ���˵����ʼ� -->
			<AppntJobCode>
				<xsl:call-template name="tran_jobcode">
						<xsl:with-param name="jobcode">
							<xsl:value-of select ="Appnt/JobCode"/>
						</xsl:with-param>
				</xsl:call-template>
			</AppntJobCode>								<!-- Ͷ����ְҵ���� -->		
		
			<TellInfos>			<!-- ��֪�б� -->
				<HealthFlag></HealthFlag>							<!-- ������֮��־ -->
				<TellInfoCount></TellInfoCount>						<!-- ��֪��Ŀ�� -->
				<TellInfo>
					<TellCode></TellCode>										<!-- ��֪���� -->
					<TellContent></TellContent>  					<!-- ��֪���� -->
					<TellRemark></TellRemark>			 					    <!-- ��֪��ע -->
				</TellInfo>
			</TellInfos>
					
		</LCAppnt>
		<!-- �������� -->
		<LCInsureds> <!-- �������б� -->
			<LCInsuredCount>1</LCInsuredCount>	<!-- ��������Ŀ -->
			<LCInsured>	<!-- ��������Ϣ -->
			  <InsuredNo><xsl:value-of select ="Insured/CustomerNo"/></InsuredNo>								  <!--�������˿ͻ���--> 
				<Name><xsl:value-of select ="Insured/Name"/></Name>										<!-- ���������� -->
				<Sex><xsl:value-of select ="Insured/Sex"/></Sex>														<!-- �������Ա� -->
				<Birthday>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Insured/Birthday)"/>
				</Birthday>						<!-- �����˳������� -->
				<IDType>
					<xsl:call-template name="tran_idtype">
						<xsl:with-param name="idtype">
							<xsl:value-of select ="Insured/IDType"/>
						</xsl:with-param>
					</xsl:call-template>
				</IDType>											<!-- ������֤������ -->
				<IDNo><xsl:value-of select ="Insured/IDNo"/></IDNo>						<!-- ������֤������ -->
				
				<NativePlace>
					<xsl:call-template name="tran_nationality">
						<xsl:with-param name="nationality">
							<xsl:value-of select="Insured/Nationality"/>
						</xsl:with-param>
					</xsl:call-template>
				</NativePlace>		  	      <!--�������˹���-->
			  <Nationality></Nationality>		  	      <!---����������-->
			  <Marriage></Marriage>		  	            <!---�����˻���״��-->
			  <Stature><xsl:value-of select ="Insured/Stature"/></Stature>		          	      <!--�����������-->
			  <Avoirdupois><xsl:value-of select ="Insured/Weight"/></Avoirdupois>		  	      <!--������������-->
			  <SmokeFlag></SmokeFlag>		  	          <!--���Ƿ����̱�־-->
				
				<JobCode>
					<xsl:call-template name="tran_jobcode">
						<xsl:with-param name="jobcode">
							<xsl:value-of select ="Insured/JobCode"/>
						</xsl:with-param>
				</xsl:call-template>
				</JobCode>											<!-- ������ְҵ���� -->
				<MailAddress><xsl:value-of select ="Insured/Address"/></MailAddress>			<!-- �����˵�ַ -->
				<MailZipCode><xsl:value-of select ="Insured/ZipCode"/></MailZipCode>				<!-- �������ʱ� -->
				<Phone><xsl:value-of select ="Insured/Phone"/></Phone>					        <!-- �����˵绰 -->
				<Mobile><xsl:value-of select ="Insured/Mobile"/></Mobile>									      <!-- �������ƶ��绰 -->
				<Email><xsl:value-of select ="Insured/Email"/></Email>					        	      <!-- �����˵����ʼ� -->
				<RelaToMain></RelaToMain>								<!-- ���������˹�ϵ -->
				<RelaToAppnt>
					<xsl:call-template name="tran_RelationRoleCode">
						<xsl:with-param name="relationRoleCode">
							<xsl:value-of select="Appnt/RelaToInsured"/>
						</xsl:with-param>
			  		 </xsl:call-template>
				</RelaToAppnt>							<!-- ��Ͷ���˹�ϵ -->
				
		   	<TellInfos>			<!-- ��֪�б� -->
		   		<HealthFlag></HealthFlag>							<!-- ������֮��־ -->
		   		<TellInfoCount></TellInfoCount>						<!-- ��֪��Ŀ�� -->
		   		<TellInfo>
		   			<TellCode></TellCode>										<!-- ��֪���� -->
		   			<TellContent></TellContent>  					<!-- ��֪���� -->
		   			<TellRemark></TellRemark>			 					    <!-- ��֪��ע -->
		   		</TellInfo>
		   	</TellInfos>
			
		<Risks> <!-- �����б� -->
			<RiskCount><xsl:value-of select="count(Risk)"/></RiskCount>
			<xsl:for-each select="Risk">
				<Risk> <!-- ���� -->
					<RiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskCode">
							<xsl:value-of select="RiskCode" />
						</xsl:with-param>
					</xsl:call-template>
					</RiskCode>          			<!--�����ִ���-->
					<MainRiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskCode">
							<xsl:value-of select="MainRiskCode" />
						</xsl:with-param>
					</xsl:call-template>
					</MainRiskCode>					<!-- ���մ��� -->
					<RiskType></RiskType>									<!-- �������� -->
					<RiskName><xsl:value-of select ="RiskName"/></RiskName>									<!-- �������� -->		
					
					<UpperPrem></UpperPrem>            		<!-- ���շѴ�д -->
	          		<Prem><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/></Prem>            						<!-- ���շ� -->
           			<PremItems>
						<PremItemsCount></PremItemsCount>		<!-- ������Ŀ��Ŀ -->
						<PremItem>
							<PremType></PremType>							<!-- �������� -->
							<DetailPrem></DetailPrem>					<!-- ������ϸ -->				
							<FirstRate></FirstRate>					  <!-- ��ʼ������ -->		
							<FirstCharge></FirstCharge>				<!-- ��ʼ���� -->					
						</PremItem>
					</PremItems>
					<UpperAmnt></UpperAmnt>								<!-- �����д -->
					<Amnt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/></Amnt>													<!-- ���� -->
					<Rate></Rate>													<!-- ���� -->
					<Rank></Rank>            						<!-- ���� -->						
					<Mult><xsl:value-of select ="Mult"/></Mult>            						<!-- Ͷ������ -->	
					<PayDateChn>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PayEndDate, 'yyyyMMdd'),'yyyy��MM��dd��')"/>
					</PayDateChn>       			<!--�ɷ�����-->
					<PaysDateChn>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PayEndDate, 'yyyyMMdd'),'yyyy��MM��dd��')"/>
					</PaysDateChn>       	  <!--�ɷ��ڼ�-->
					<PayToDate>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PayEndDate, 'yyyyMMdd'),'yyyy��MM��dd��')"/>
					</PayToDate>       	      <!--�ɷ���������-->
					<PayEndYearFlag><xsl:value-of select ="PayEndYearFlag"/></PayEndYearFlag>   	<!--���ɷ���������-->
					<PayYears><xsl:value-of select ="PayEndYear"/></PayYears>       				<!--���ɷ�����-->
					<PayIntv><xsl:value-of select ="PayIntv"/></PayIntv>									<!-- �ɷѼ��-->
	        		<PayMode><xsl:call-template name="tran_PayMode">
						<xsl:with-param name="payMode">
							<xsl:value-of select="PayMode"/>
						</xsl:with-param>
			  		 </xsl:call-template></PayMode>              		<!--���ɷ���ʽ-->			
					<Years><xsl:value-of select ="Years"/></Years>							      		<!-- �����ڼ� -->	
					<InsuYearFlag><xsl:value-of select ="InsuYearFlag"/></InsuYearFlag>					<!-- �����������ڱ�־ -->
					<InsuYear><xsl:value-of select ="InsuYear"/></InsuYear>									<!-- ������������ -->	
					<CValiDate>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(CValiDate)"/>		
					</CValiDate><!-- ������ -->							
					<EndDate></EndDate>								    <!-- ������ֹ���� -->	
						
					<GetYearFlag><xsl:value-of select ="GetYearFlag"/></GetYearFlag>						<!-- ��ȡ�������ڱ�־ -->
					<GetYear><xsl:value-of select ="GetYear"/></GetYear>                  	<!--����ȡ����-->
					<GetIntv><xsl:value-of select ="GetIntv"/></GetIntv>										<!-- ��ȡ��� -->
					<GetStartDate>
					<xsl:value-of select="GetStartDate"/>	
					</GetStartDate>					<!-- �������� -->							
					<GetBankCode><xsl:value-of select ="GetBankCode"/></GetBankCode>						<!-- ��ȡ���б��� -->
					<GetBankAccNo><xsl:value-of select ="GetBankAccNo"/></GetBankAccNo>					<!-- ��ȡ�����˻� -->
					<GetAccName><xsl:value-of select ="GetAccName"/></GetAccName>							<!-- ��ȡ���л��� -->
					
					<CostIntv><xsl:value-of select ="CostIntv"/></CostIntv>   							<!-- �ۿ��� -->
					<CostDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(CostDate)"/>
					</CostDate>   							<!-- �ۿ�ʱ�� -->		
						
					
					<AutoPayFlag><xsl:value-of select ="AutoPayFlag"/></AutoPayFlag>          <!-- �潻��־ -->
					<BonusPayMode></BonusPayMode>				<!-- ���������� -->
					<SubFlag><xsl:value-of select ="SubFlag"/></SubFlag>										<!-- ������־ -->
					<BonusGetMode><xsl:value-of select ="BonusGetMode"/></BonusGetMode>        <!-- ������ȡ��ʽ -->
					<FullBonusGetMode><xsl:value-of select ="FullBonusGetMode"/></FullBonusGetMode>	<!-- ������ȡ����ȡ��ʽ -->
					<AutoRenewFlag><xsl:value-of select ="JobCode"/></AutoRenewFlag>	      <!-- �Զ�������� -->
					
					<FirstRate></FirstRate>								<!-- ��ʼ������ -->
					<SureRate></SureRate>									<!-- ��֤���� -->
					<FirstValue></FirstValue>							<!-- ������ֵ��ʼֵ -->		
						
					
					<Accounts>
						<AccountCount><xsl:value-of select="count(Accounts/Account)"/></AccountCount>				<!-- Ͷ���˻���Ŀ -->
						<xsl:for-each select="Accounts/Account">
						<Account>
							<AccNo><xsl:value-of select ="AccNo"/></AccNo>										<!-- Ͷ���˻����� -->
							<AccName></AccName>								<!-- Ͷ���˻����� -->
							<AccMoney><xsl:value-of select ="AccMoney"/></AccMoney>							<!-- Ͷ���˻���� -->
							<AccRate><xsl:value-of select ="AccRate"/></AccRate>								<!-- Ͷ���˻����� -->
							<SureRate></SureRate>						  <!-- ��֤���� -->								
						</Account>
						</xsl:for-each>
					</Accounts>
						
						
				<LCBnfs> <!-- �������б� -->
					<LCBnfCount><xsl:value-of select="count(../Bnf)"/></LCBnfCount>						<!-- ��������Ŀ -->
					<xsl:for-each select="../Bnf">
			    	<LCBnf> <!-- ������ -->
				    	<BnfType><xsl:value-of select ="Type"/></BnfType>												<!-- ��������� -->
				    	<BnfNo></BnfNo>														<!-- ��������� -->
				    	<BnfGrade><xsl:value-of select ="Grade"/></BnfGrade>											<!-- �����˼��� -->
						<Name><xsl:value-of select ="Name"/></Name>												<!--������������-->
					    <Sex><xsl:value-of select ="Sex"/></Sex>															<!--���������Ա�-->
						<RelationToInsured>
						<xsl:call-template name="tran_RelationToInsured">
							<xsl:with-param name="relationToInsured">
								<xsl:value-of select="RelaToInsured"/>
							</xsl:with-param>
				  		 </xsl:call-template>
						</RelationToInsured>  <!--���뱻���˹�ϵ -->
						<Birthday>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Birthday)"/>
						</Birthday>    					<!--�������˳�������-->
						<IDType>
						<xsl:call-template name="tran_idtype">
							<xsl:with-param name="idtype">
								<xsl:value-of select ="IDType"/>
							</xsl:with-param>
						</xsl:call-template>
						</IDType>         								<!--��������֤������-->
						<IDNo><xsl:value-of select ="IDNo"/></IDNo>							<!--��������֤������-->
					    <BnfLot><xsl:value-of select ="Lot"/></BnfLot> 											<!--������ٷ���-->
						<Address></Address>												<!-- ������ͨѶ��ַ -->
					</LCBnf>
					</xsl:for-each>
				</LCBnfs>

				<CashValues>	<!-- �ֽ��ֵ�� -->
					<CashValueCount><xsl:value-of select="count(CashValues/CashValue)"/></CashValueCount>		<!-- �ֽ��ֵ��Ŀ -->
					<xsl:for-each select="CashValues/CashValue">
			    	<CashValue>
						<End><xsl:value-of select ="EndYear"/></End>       				<!-- ��ĩ -->
			      		<Cash><xsl:value-of select ="Cash"/></Cash>			<!-- ��ĩ�ֽ��ֵ -->
			      		<VoidCash></VoidCash>			<!-- ��ĩ�ֽ��ֵ -->
					</CashValue>
					</xsl:for-each>
				</CashValues>

				<BonusValues>	<!-- ������������ĩ�ֽ��ֵ�� -->
					<BonusValueCount><xsl:value-of select="count(BonusValues/BonusValue)"/></BonusValueCount>		<!-- �ֽ��ֵ��Ŀ -->
					<xsl:for-each select="BonusValues/BonusValue">
					<BonusValue>
						<End><xsl:value-of select ="EndYear"/></End>								<!-- ��ĩ -->
						<Cash><xsl:value-of select ="EndYearCash"/></Cash>							<!-- ��ĩ�ֽ��ֵ -->
					</BonusValue>
					</xsl:for-each>
				</BonusValues>
			</Risk>
			</xsl:for-each>
			</Risks>
	    </LCInsured>
		</LCInsureds>
		
		
		<!--�������д�ӡ�ӿ�-->
		<Print>
			<Print1>
				<Page1Print/>
				<Page1Print/>
				<Page1Print/>
				<Page1Print/>
				<Page1Print/>
				<Page1Print/>
				<Page1Print/>
				<Page1Print/>
				<Page1Print><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></Page1Print>
				<Page1Print>������------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print>
					<xsl:text>������Ͷ����������</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
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
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</Page1Print>
				<Page1Print>
					<xsl:text>�������������ˣ�</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
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
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</Page1Print>
				<Page1Print/>
				<Page1Print>������------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print>������------------------------------------------------------------------------------------------------</Page1Print>
				<xsl:if test="count(Bnf) = 0">
				<Page1Print><xsl:text>��������������ˣ�����                </xsl:text>
				   <xsl:text>����˳��1                   </xsl:text>
				   <xsl:text>���������100%</xsl:text></Page1Print>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<Page1Print>
							<xsl:text>��������������ˣ�</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>����˳��</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>���������</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</Page1Print>
					</xsl:for-each>
				</xsl:if>
				<Page1Print>������------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print/>
				<Page1Print>��������������</Page1Print>
				<Page1Print>������------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print>
					<xsl:text>�������������������������������������������������������������������������ս��\</xsl:text>
				</Page1Print>
				<Page1Print>
					<xsl:text>����������������������������               �����ڼ�    ��������     �ս�����\     ���շ�     ����Ƶ��</xsl:text>
				</Page1Print>
				<Page1Print>
					<xsl:text>������������������������������������������������������������������������\����</xsl:text>
				</Page1Print>
				<Page1Print>������------------------------------------------------------------------------------------------------</Page1Print>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
					<Page1Print>
						<xsl:text>������</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 9)"/>
							</xsl:when>
							<xsl:when test="InsuYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 9)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 9)"/>
								<xsl:text/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PayIntv = 0">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ�ν���', 12)"/>
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
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Prem,13)"/>
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
					</Page1Print>
				</xsl:for-each>
				<Page1Print>������------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print/>
				<Page1Print/>
				<Page1Print>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</Page1Print>
				<Page1Print/>
				<Page1Print>������------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print/>
				<Page1Print/>
				<Page1Print>������------------------------------------------------------------------------------------------------</Page1Print>
				<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
				<Page1Print>���������յ��ر�Լ����<xsl:choose>
						<xsl:when test="$SpecContent=''">
							<xsl:text>���ޣ�</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$SpecContent"/>
						</xsl:otherwise>
					</xsl:choose>
				</Page1Print>
				<Page1Print/>
				<Page1Print/>
				<Page1Print/>
				<Page1Print>������-------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</Page1Print>
				<Page1Print></Page1Print>
				<Page1Print></Page1Print>
				<Page1Print><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></Page1Print>
				
				<Page1Print><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></Page1Print>
				
				<Page1Print><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></Page1Print>
				<Page1Print></Page1Print>
				<Page1Print><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></Page1Print>
				<Page1Print><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Page1Print>
				<Page1Print></Page1Print>
				<Page1Print><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/>����������Ա���ţ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></Page1Print>
				<Page1Print><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/></Page1Print>
		
			</Print1>
		<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<Print2>
				<Page2Print><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</Page2Print>
				<Page2Print/>
				<Page2Print>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </Page2Print>
				<Page2Print>������------------------------------------------------------------------------------------------------</Page2Print>
				<Page2Print>��������������������<xsl:value-of select="Insured/Name"/></Page2Print>
                <xsl:if test="$RiskCount=1">
		        <Page2Print>
			    <xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Page2Print>
		        <Page2Print><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text></Page2Print>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <Page2Print><xsl:text/><xsl:text>����������</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</Page2Print>
			    </xsl:for-each>
	            </xsl:if>
	 
	            <xsl:if test="$RiskCount!=1">
	 	        <Page2Print>
			    <xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Page2Print>
		        <Page2Print><xsl:text/>�������������ĩ<xsl:text>                                        </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text></Page2Print>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <Page2Print>
					 <xsl:text/><xsl:text>����������</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</Page2Print>
			    </xsl:for-each>
	            </xsl:if>
				<Page2Print>������------------------------------------------------------------------------------------------------</Page2Print>
				<Page2Print/>
				<Page2Print>��������ע��</Page2Print>
				<Page2Print>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</Page2Print>
				<Page2Print>������------------------------------------------------------------------------------------------------</Page2Print>
				</Print2>
			</xsl:if>
			</Print>
		
		</LCCont>
	</xsl:template>

<!-- ֤������ -->

<!-- ���ģ�0	�������֤,1 ����,2 ����֤,3 ����,4 ����֤��,5	���ڲ�,8	����,9	�쳣���֤ -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$idtype='0'">0</xsl:when><!-- ���֤ -->
		<xsl:when test="$idtype='1'">1</xsl:when><!-- ���� -->
		<xsl:when test="$idtype='2'">2</xsl:when><!-- ����֤ -->
		<xsl:when test="$idtype='5'">3</xsl:when><!-- ���ڲ� -->
		<xsl:when test="$idtype='8'">4</xsl:when><!-- �۰�̨ͨ��֤ -->
		<xsl:when test="$idtype='8'">5</xsl:when><!-- �侯���֤ -->
		<xsl:when test="$idtype='8'">6</xsl:when><!-- ������뾳ͨ��֤ -->
	</xsl:choose>
</xsl:template>

<!-- ְҵ���� -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode= '1010106'">001</xsl:when><!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա-->
		<xsl:when test="$jobcode= '2050601'">002</xsl:when><!-- ����רҵ������Ա                      -->
		<xsl:when test="$jobcode= '2070502'">003</xsl:when><!-- ����ҵ����Ա???                       -->
		<xsl:when test="$jobcode= '2080103'">004</xsl:when><!-- ����רҵ��Ա                          -->
		<xsl:when test="$jobcode= '2090101'">005</xsl:when><!-- ��ѧ��Ա                              -->
		<xsl:when test="$jobcode= '2120109'">006</xsl:when><!-- ���ų��漰��ѧ����������Ա            -->
		<xsl:when test="$jobcode= '2130101'">007</xsl:when><!-- �ڽ�ְҵ��                            -->
		<xsl:when test="$jobcode= '3030101'">008</xsl:when><!-- �����͵���ҵ����Ա                    -->
		<xsl:when test="$jobcode= '9210102'">009</xsl:when><!-- ��ҵ������ҵ��Ա                      -->
		<xsl:when test="$jobcode= '5050104'">010</xsl:when><!-- ũ���֡������桢ˮ��ҵ������Ա        -->
		<xsl:when test="$jobcode= '6240107'">011</xsl:when><!-- ������Ա??                            -->
		<xsl:when test="$jobcode= '2020101'">012</xsl:when><!-- ���ʿ�����Ա                          -->
		<xsl:when test="$jobcode= '6230911'">013</xsl:when><!-- ����ʩ����Ա?                         -->
		<xsl:when test="$jobcode= '6050908'">014</xsl:when><!-- �ӹ����졢���鼰������Ա              -->
		<xsl:when test="$jobcode= '7010121'">015</xsl:when><!-- ����                                  -->
		<xsl:when test="$jobcode= '8010101'">016</xsl:when><!-- ��ҵ                                  -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Ͷ���˳������� TBR_LIVEZONE -->
<xsl:template name="tran_livezone">
<xsl:param name="livezone" />
<xsl:choose>
	<xsl:when test="$livezone=1">0</xsl:when>	<!-- ������� -->
	<xsl:when test="$livezone=2">1</xsl:when>	<!-- ũ����� -->
</xsl:choose>
</xsl:template>
<!-- ���� -->
<xsl:template name="tran_nationality">
<xsl:param name="nationality" />
<xsl:choose>
		<xsl:when test="$nationality='AW'">ABW</xsl:when><!--��³��-->
		<xsl:when test="$nationality='AF'">AFG</xsl:when><!--������-->
		<xsl:when test="$nationality='AO'">AGO</xsl:when><!--������-->
		<xsl:when test="$nationality='AI'">AIA</xsl:when><!--������-->
		<xsl:when test="$nationality='AL'">ALB</xsl:when><!--����������-->
		<xsl:when test="$nationality='AD'">AND</xsl:when><!--������-->
		<xsl:when test="$nationality='AN'">ANT</xsl:when><!--����������˹-->
		<xsl:when test="$nationality='AE'">ARE</xsl:when><!--������-->
		<xsl:when test="$nationality='AR'">ARG</xsl:when><!--����͢-->
		<xsl:when test="$nationality='AM'">ARM</xsl:when><!--��������-->
		<xsl:when test="$nationality='AS'">ASM</xsl:when><!--������Ħ��-->
		<xsl:when test="$nationality='OTH'">ATA</xsl:when><!--�ϼ���-->
		<xsl:when test="$nationality='OTH'">ATF</xsl:when><!--�����ϲ�����-->
		<xsl:when test="$nationality='AG'">ATG</xsl:when><!--����ϺͰͲ���-->
		<xsl:when test="$nationality='AU'">AUS</xsl:when><!--�Ĵ�����-->
		<xsl:when test="$nationality='AT'">AUT</xsl:when><!--�µ���-->
		<xsl:when test="$nationality='AZ'">AZE</xsl:when><!--�����ݽ�      -->
		<xsl:when test="$nationality='BI'">BDI</xsl:when><!--��¡��-->
		<xsl:when test="$nationality='BE'">BEL</xsl:when><!--����ʱ-->
		<xsl:when test="$nationality='BJ'">BEN</xsl:when><!--����-->
		<xsl:when test="$nationality='BF'">BFA</xsl:when><!--�����ɷ���-->
		<xsl:when test="$nationality='BD'">BGD</xsl:when><!--�ϼ�����-->
		<xsl:when test="$nationality='BG'">BGR</xsl:when><!--��������-->
		<xsl:when test="$nationality='BH'">BHR</xsl:when><!--����-->
		<xsl:when test="$nationality='BS'">BHS</xsl:when><!--�͹���-->
		<xsl:when test="$nationality='BA'">BIH</xsl:when><!--��˹���Ǻͺ�����ά��-->
		<xsl:when test="$nationality='BY'">BLR</xsl:when><!--�׶���˹-->
		<xsl:when test="$nationality='BZ'">BLZ</xsl:when><!--������-->
		<xsl:when test="$nationality='BM'">BMU</xsl:when><!--��Ľ��-->
		<xsl:when test="$nationality='BO'">BOL</xsl:when><!--����ά��-->
		<xsl:when test="$nationality='BR'">BRA</xsl:when><!--����-->
		<xsl:when test="$nationality='BB'">BRB</xsl:when><!--�ͰͶ�˹-->
		<xsl:when test="$nationality='BN'">BRN</xsl:when><!--����-->
		<xsl:when test="$nationality='BT'">BTN</xsl:when><!--����-->
		<xsl:when test="$nationality='OTH'">BVT</xsl:when><!--��ά��-->
		<xsl:when test="$nationality='BW'">BWA</xsl:when><!--��������-->
		<xsl:when test="$nationality='CF'">CAF</xsl:when><!--�з�-->
		<xsl:when test="$nationality='CA'">CAN</xsl:when><!--���ô�-->
		<xsl:when test="$nationality='OTH'">CCK</xsl:when><!--�ƿ�˹����Ⱥ��-->
		<xsl:when test="$nationality='CH'">CHE</xsl:when><!--��ʿ-->
		<xsl:when test="$nationality='CL'">CHL</xsl:when><!--����-->
		<xsl:when test="$nationality='CHN'">CHN</xsl:when><!--�й�-->
		<xsl:when test="$nationality='CI'">CIV</xsl:when><!--���ص���-->
		<xsl:when test="$nationality='CM'">CMR</xsl:when><!--����¡-->
		<xsl:when test="$nationality='CG'">COD</xsl:when><!--�չ���-->
		<xsl:when test="$nationality='ZR'">COG</xsl:when><!--�չ���-->
		<xsl:when test="$nationality='CK'">COK</xsl:when><!--���Ⱥ��-->
		<xsl:when test="$nationality='CO'">COL</xsl:when><!--���ױ���-->
		<xsl:when test="$nationality='KM'">COM</xsl:when><!--��Ħ��-->
		<xsl:when test="$nationality='CV'">CPV</xsl:when><!--��ý�-->
		<xsl:when test="$nationality='CR'">CRI</xsl:when><!--��˹�����-->
		<xsl:when test="$nationality='CU'">CUB</xsl:when><!--�Ű�-->
		<xsl:when test="$nationality='OTH'">CXR</xsl:when><!--ʥ����-->
		<xsl:when test="$nationality='KY'">CYM</xsl:when><!--����Ⱥ��-->
		<xsl:when test="$nationality='CY'">CYP</xsl:when><!--����·˹-->
		<xsl:when test="$nationality='CZ'">CZE</xsl:when><!--�ݿ�-->
		<xsl:when test="$nationality='DE'">DEU</xsl:when><!--�¹�-->
		<xsl:when test="$nationality='DJ'">DJI</xsl:when><!--������-->
		<xsl:when test="$nationality='DM'">DMA</xsl:when><!--�������-->
		<xsl:when test="$nationality='DK'">DNK</xsl:when><!--����-->
		<xsl:when test="$nationality='DO'">DOM</xsl:when><!--������ӹ��͹�-->
		<xsl:when test="$nationality='DZ'">DZA</xsl:when><!--����������-->
		<xsl:when test="$nationality='EC'">ECU</xsl:when><!--��϶��-->
		<xsl:when test="$nationality='EG'">EGY</xsl:when><!--����-->
		<xsl:when test="$nationality='ER'">ERI</xsl:when><!--����������-->
		<xsl:when test="$nationality='OTH'">ESH</xsl:when><!--��������-->
		<xsl:when test="$nationality='ES'">ESP</xsl:when><!--������-->
		<xsl:when test="$nationality='EE'">EST</xsl:when><!--��ɳ����-->
		<xsl:when test="$nationality='ET'">ETH</xsl:when><!--���������-->
		<xsl:when test="$nationality='FI'">FIN</xsl:when><!--����-->
		<xsl:when test="$nationality='FJ'">FJI</xsl:when><!--쳼�-->
		<xsl:when test="$nationality='OTH'">FLK</xsl:when><!--���ά��˹Ⱥ��������Ⱥ��-->
		<xsl:when test="$nationality='FR'">FRA</xsl:when><!--����-->
		<xsl:when test="$nationality='FO'">FRO</xsl:when><!--����Ⱥ��-->
		<xsl:when test="$nationality='OTH'">FSM</xsl:when><!--�ܿ���������-->
		<xsl:when test="$nationality='GA'">GAB</xsl:when><!--����-->
		<xsl:when test="$nationality='GB'">GBR</xsl:when><!--Ӣ��-->
		<xsl:when test="$nationality='GE'">GEO</xsl:when><!--��³����-->
		<xsl:when test="$nationality='GH'">GHA</xsl:when><!--����-->
		<xsl:when test="$nationality='GI'">GIB</xsl:when><!--ֱ������-->
		<xsl:when test="$nationality='GN'">GIN</xsl:when><!--������-->
		<xsl:when test="$nationality='GP'">GLP</xsl:when><!--�ϵ�����-->
		<xsl:when test="$nationality='GM'">GMB</xsl:when><!--�Ա���-->
		<xsl:when test="$nationality='GW'">GNB</xsl:when><!--�����Ǳ���-->
		<xsl:when test="$nationality='GQ'">GNQ</xsl:when><!--���������-->
		<xsl:when test="$nationality='GR'">GRC</xsl:when><!--ϣ��-->
		<xsl:when test="$nationality='GD'">GRD</xsl:when><!--�����ɴ�-->
		<xsl:when test="$nationality='GL'">GRL</xsl:when><!--������-->
		<xsl:when test="$nationality='GT'">GTM</xsl:when><!--Σ������-->
		<xsl:when test="$nationality='GF'">GUF</xsl:when><!--����������-->
		<xsl:when test="$nationality='GU'">GUM</xsl:when><!--�ص�-->
		<xsl:when test="$nationality='GY'">GUY</xsl:when><!--������-->
		<xsl:when test="$nationality='CHN'">HKG</xsl:when><!--���-->
		<xsl:when test="$nationality='OTH'">HMD</xsl:when><!--�յµ���������ɵ�-->
		<xsl:when test="$nationality='HN'">HND</xsl:when><!--�鶼��˹-->
		<xsl:when test="$nationality='HR'">HRV</xsl:when><!--���޵���-->
		<xsl:when test="$nationality='HT'">HTI</xsl:when><!--����-->
		<xsl:when test="$nationality='HU'">HUN</xsl:when><!--������-->
		<xsl:when test="$nationality='ID'">IDN</xsl:when><!--ӡ��������-->
		<xsl:when test="$nationality='IN'">IND</xsl:when><!--ӡ��-->
		<xsl:when test="$nationality='OTH'">IOT</xsl:when><!--Ӣ��ӡ��������-->
		<xsl:when test="$nationality='IE'">IRL</xsl:when><!--������-->
		<xsl:when test="$nationality='IR'">IRN</xsl:when><!--����-->
		<xsl:when test="$nationality='IQ'">IRQ</xsl:when><!--������-->
		<xsl:when test="$nationality='IS'">ISL</xsl:when><!--����-->
		<xsl:when test="$nationality='IL'">ISR</xsl:when><!--��ɫ��-->
		<xsl:when test="$nationality='IT'">ITA</xsl:when><!--�����-->
		<xsl:when test="$nationality='JM'">JAM</xsl:when><!--�����-->
		<xsl:when test="$nationality='JO'">JOR</xsl:when><!--Լ��-->
		<xsl:when test="$nationality='JP'">JPN</xsl:when><!--�ձ�-->
		<xsl:when test="$nationality='KZ'">KAZ</xsl:when><!--������˹̹-->
		<xsl:when test="$nationality='KE'">KEN</xsl:when><!--������-->
		<xsl:when test="$nationality='KG'">KGZ</xsl:when><!--������˹˹̹-->
		<xsl:when test="$nationality='KH'">KHM</xsl:when><!--����կ-->
		<xsl:when test="$nationality='KT'">KIR</xsl:when><!--�����˹-->
		<xsl:when test="$nationality='SX'">KNA</xsl:when><!--ʥ���ĺ���ά˹-->
		<xsl:when test="$nationality='KR'">KOR</xsl:when><!--����-->
		<xsl:when test="$nationality='KW'">KWT</xsl:when><!--������-->
		<xsl:when test="$nationality='LA'">LAO</xsl:when><!--����-->
		<xsl:when test="$nationality='LB'">LBN</xsl:when><!--�����-->
		<xsl:when test="$nationality='LR'">LBR</xsl:when><!--��������-->
		<xsl:when test="$nationality='LY'">LBY</xsl:when><!--������-->
		<xsl:when test="$nationality='SQ'">LCA</xsl:when><!--ʥ¬����-->
		<xsl:when test="$nationality='LI'">LIE</xsl:when><!--��֧��ʿ��-->
		<xsl:when test="$nationality='LK'">LKA</xsl:when><!--˹������-->
		<xsl:when test="$nationality='LS'">LSO</xsl:when><!--������-->
		<xsl:when test="$nationality='LT'">LTU</xsl:when><!--������-->
		<xsl:when test="$nationality='LU'">LUX</xsl:when><!--¬ɭ��-->
		<xsl:when test="$nationality='LV'">LVA</xsl:when><!--����ά��-->
		<xsl:when test="$nationality='CHN'">MAC</xsl:when><!--����-->
		<xsl:when test="$nationality='MA'">MAR</xsl:when><!--Ħ���-->
		<xsl:when test="$nationality='MC'">MCO</xsl:when><!--Ħ�ɸ�-->
		<xsl:when test="$nationality='MD'">MDA</xsl:when><!--Ħ������-->
		<xsl:when test="$nationality='MG'">MDG</xsl:when><!--����˹��-->
		<xsl:when test="$nationality='MV'">MDV</xsl:when><!--�������-->
		<xsl:when test="$nationality='MX'">MEX</xsl:when><!--ī����-->
		<xsl:when test="$nationality='MH'">MHL</xsl:when><!--���ܶ�Ⱥ��-->
		<xsl:when test="$nationality='MK'">MKD</xsl:when><!--��˹��-->
		<xsl:when test="$nationality='ML'">MLI</xsl:when><!--����-->
		<xsl:when test="$nationality='MT'">MLT</xsl:when><!--�����-->
		<xsl:when test="$nationality='MM'">MMR</xsl:when><!--���-->
		<xsl:when test="$nationality='MN'">MNG</xsl:when><!--�ɹ�-->
		<xsl:when test="$nationality='MP'">MNP</xsl:when><!--����������-->
		<xsl:when test="$nationality='MZ'">MOZ</xsl:when><!--Īɣ�ȿ�-->
		<xsl:when test="$nationality='MR'">MRT</xsl:when><!--ë��������-->
		<xsl:when test="$nationality='MS'">MSR</xsl:when><!--����������-->
		<xsl:when test="$nationality='MQ'">MTQ</xsl:when><!--�������-->
		<xsl:when test="$nationality='MU'">MUS</xsl:when><!--ë����˹-->
		<xsl:when test="$nationality='MW'">MWI</xsl:when><!--����ά-->
		<xsl:when test="$nationality='MY'">MYS</xsl:when><!--��������-->
		<xsl:when test="$nationality='YT'">MYT</xsl:when><!--��Լ��-->
		<xsl:when test="$nationality='NA'">NAM</xsl:when><!--���ױ���-->
		<xsl:when test="$nationality='NC'">NCL</xsl:when><!--�¿��������-->
		<xsl:when test="$nationality='NE'">NER</xsl:when><!--���ն�-->
		<xsl:when test="$nationality='NF'">NFK</xsl:when><!--ŵ���˵�-->
		<xsl:when test="$nationality='NG'">NGA</xsl:when><!--��������-->
		<xsl:when test="$nationality='NI'">NIC</xsl:when><!--�������-->
		<xsl:when test="$nationality='NU'">NIU</xsl:when><!--Ŧ��-->
		<xsl:when test="$nationality='NL'">NLD</xsl:when><!--����-->
		<xsl:when test="$nationality='NO'">NOR</xsl:when><!--Ų��-->
		<xsl:when test="$nationality='NP'">NPL</xsl:when><!--�Ჴ��-->
		<xsl:when test="$nationality='NR'">NRU</xsl:when><!--�³-->
		<xsl:when test="$nationality='NZ'">NZL</xsl:when><!--������-->
		<xsl:when test="$nationality='OM'">OMN</xsl:when><!--����-->
		<xsl:when test="$nationality='PK'">PAK</xsl:when><!--�ͻ�˹̹-->
		<xsl:when test="$nationality='PA'">PAN</xsl:when><!--������-->
		<xsl:when test="$nationality='OTH'">PCN</xsl:when><!--Ƥ�ؿ���Ⱥ��-->
		<xsl:when test="$nationality='PE'">PER</xsl:when><!--��³-->
		<xsl:when test="$nationality='PH'">PHL</xsl:when><!--���ɱ�-->
		<xsl:when test="$nationality='PW'">PLW</xsl:when><!--����-->
		<xsl:when test="$nationality='PG'">PNG</xsl:when><!--�Ͳ����¼�����-->
		<xsl:when test="$nationality='PL'">POL</xsl:when><!--����-->
		<xsl:when test="$nationality='PR'">PRI</xsl:when><!--�������-->
		<xsl:when test="$nationality='KP'">PRK</xsl:when><!--����-->
		<xsl:when test="$nationality='PT'">PRT</xsl:when><!--������-->
		<xsl:when test="$nationality='PY'">PRY</xsl:when><!--������-->
		<xsl:when test="$nationality='OTH'">PSE</xsl:when><!--����˹̹-->
		<xsl:when test="$nationality='PF'">PYF</xsl:when><!--��������������-->
		<xsl:when test="$nationality='QA'">QAT</xsl:when><!--������-->
		<xsl:when test="$nationality='RE'">REU</xsl:when><!--������-->
		<xsl:when test="$nationality='RO'">ROM</xsl:when><!--��������-->
		<xsl:when test="$nationality='RU'">RUS</xsl:when><!--����˹-->
		<xsl:when test="$nationality='RW'">RWA</xsl:when><!--¬����-->
		<xsl:when test="$nationality='SA'">SAU</xsl:when><!--ɳ�ذ�����-->
		<xsl:when test="$nationality='OTH'">SCG</xsl:when><!--����ά�Ǻͺ�ɽ-->
		<xsl:when test="$nationality='SD'">SDN</xsl:when><!--�յ�-->
		<xsl:when test="$nationality='SN'">SEN</xsl:when><!--���ڼӶ�-->
		<xsl:when test="$nationality='SG'">SGP</xsl:when><!--�¼���-->
		<xsl:when test="$nationality='OTH'">SGS</xsl:when><!--�������ǵ�����ɣ��Τ�浺-->
		<xsl:when test="$nationality='OTH'">SHN</xsl:when><!--ʥ������-->
		<xsl:when test="$nationality='OTH'">SJM</xsl:when><!--˹�߶���Ⱥ��������Ⱥ��-->
		<xsl:when test="$nationality='SB'">SLB</xsl:when><!--������Ⱥ��-->
		<xsl:when test="$nationality='SL'">SLE</xsl:when><!--��������-->
		<xsl:when test="$nationality='SV'">SLV</xsl:when><!--�����߶�-->
		<xsl:when test="$nationality='SM'">SMR</xsl:when><!--ʥ����ŵ-->
		<xsl:when test="$nationality='SO'">SOM</xsl:when><!--������-->
		<xsl:when test="$nationality='OTH'">SPM</xsl:when><!--ʥƤ�������ܿ�¡-->
		<xsl:when test="$nationality='ST'">STP</xsl:when><!--ʥ��������������-->
		<xsl:when test="$nationality='SR'">SUR</xsl:when><!--������-->
		<xsl:when test="$nationality='SK'">SVK</xsl:when><!--˹�工��-->
		<xsl:when test="$nationality='SI'">SVN</xsl:when><!--˹��������-->
		<xsl:when test="$nationality='SE'">SWE</xsl:when><!--���-->
		<xsl:when test="$nationality='SZ'">SWZ</xsl:when><!--˹��ʿ��-->
		<xsl:when test="$nationality='SC'">SYC</xsl:when><!--�����-->
		<xsl:when test="$nationality='SY'">SYR</xsl:when><!--������-->
		<xsl:when test="$nationality='TC'">TCA</xsl:when><!--�ؿ�˹�Ϳ���˹Ⱥ��-->
		<xsl:when test="$nationality='TD'">TCD</xsl:when><!--է��-->
		<xsl:when test="$nationality='TG'">TGO</xsl:when><!--���-->
		<xsl:when test="$nationality='TH'">THA</xsl:when><!--̩��-->
		<xsl:when test="$nationality='TJ'">TJK</xsl:when><!--������˹̹-->
		<xsl:when test="$nationality='OTH'">TKL</xsl:when><!--�п���-->
		<xsl:when test="$nationality='TM'">TKM</xsl:when><!--������˹̹-->
		<xsl:when test="$nationality='OTH'">TMP</xsl:when><!--������-->
		<xsl:when test="$nationality='TO'">TON</xsl:when><!--����-->
		<xsl:when test="$nationality='TT'">TTO</xsl:when><!--�������Ͷ�͸�-->
		<xsl:when test="$nationality='TN'">TUN</xsl:when><!--ͻ��˹-->
		<xsl:when test="$nationality='TR'">TUR</xsl:when><!--������-->
		<xsl:when test="$nationality='TV'">TUV</xsl:when><!--ͼ��¬-->
		<xsl:when test="$nationality='CHN'">TWN</xsl:when><!--�й�̨��-->
		<xsl:when test="$nationality='TZ'">TZA</xsl:when><!--̹ɣ����-->
		<xsl:when test="$nationality='UG'">UGA</xsl:when><!--�ڸɴ�-->
		<xsl:when test="$nationality='UA'">UKR</xsl:when><!--�ڿ���-->
		<xsl:when test="$nationality='OTH'">UMI</xsl:when><!--����������С����-->
		<xsl:when test="$nationality='UY'">URY</xsl:when><!--������-->
		<xsl:when test="$nationality='US'">USA</xsl:when><!--����-->
		<xsl:when test="$nationality='UZ'">UZB</xsl:when><!--���ȱ��˹̹-->
		<xsl:when test="$nationality='OTH'">VAT</xsl:when><!--��ٸ�-->
		<xsl:when test="$nationality='VC'">VCT</xsl:when><!--ʥ��ɭ�غ͸����ɶ�˹-->
		<xsl:when test="$nationality='VE'">VEN</xsl:when><!--ί������-->
		<xsl:when test="$nationality='VG'">VGB</xsl:when><!--Ӣ��ά����Ⱥ��-->
		<xsl:when test="$nationality='VI'">VIR</xsl:when><!--����ά����Ⱥ��-->
		<xsl:when test="$nationality='VN'">VNM</xsl:when><!--Խ��-->
		<xsl:when test="$nationality='VU'">VUT</xsl:when><!--��Ŭ��ͼ-->
		<xsl:when test="$nationality='OTH'">WLF</xsl:when><!--����˹�͸�ͼ��Ⱥ��-->
		<xsl:when test="$nationality='WS'">WSM</xsl:when><!--����Ħ��-->
		<xsl:when test="$nationality='YE'">YEM</xsl:when><!--Ҳ��-->
		<xsl:when test="$nationality='ZA'">ZAF</xsl:when><!--�Ϸ�-->
		<xsl:when test="$nationality='OTH'">ZAR</xsl:when><!--������-->
		<xsl:when test="$nationality='ZM'">ZMB</xsl:when><!--�ޱ���-->
		<xsl:when test="$nationality='ZW'">ZWE</xsl:when><!--��Ͳ�Τ-->
		<xsl:when test="$nationality='OTH'">OTH</xsl:when><!--����-->
</xsl:choose>
</xsl:template>
<!-- ��ϵ -->
<xsl:template name="tran_RelationRoleCode">
<xsl:param name="relationRoleCode" />
<xsl:choose>
	<xsl:when test="$relationRoleCode=00">00</xsl:when>	<!-- ���� -->
	<xsl:when test="$relationRoleCode=01">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test="$relationRoleCode=03">02</xsl:when>	<!-- ��Ů -->
	<xsl:when test="$relationRoleCode=02">03</xsl:when>	<!-- ��ż -->  
	<xsl:when test="$relationRoleCode=04">04</xsl:when>	<!-- ���� -->
</xsl:choose>
</xsl:template>

<!-- paymode -->
<xsl:template name="tran_PayMode">
<xsl:param name="payMode" />
<xsl:choose>
	<xsl:when test="$payMode=1">1</xsl:when>	<!-- �ֽ� -->
	<xsl:when test="$payMode=7">2</xsl:when>	<!-- ����ת�� -->
	
</xsl:choose>
</xsl:template>

<!-- �����˹�ϵ -->
<xsl:template name="tran_RelationToInsured">
<xsl:param name="relationToInsured" />
<xsl:choose>
	<xsl:when test="$relationToInsured=00">00</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=01">1</xsl:when> <!-- �˴������⣬�˴��Ǻ��ķ��صĴ��룬������ͨ�����е�ӳ���ϵ��1�Զ� -->
	<xsl:when test="$relationToInsured=03">3</xsl:when> <!-- �˴������⣬�˴��Ǻ��ķ��صĴ��룬������ͨ�����е�ӳ���ϵ��1�Զ� -->
	<xsl:when test="$relationToInsured=02">7</xsl:when> <!-- ��ż -->
	<xsl:when test="$relationToInsured=05">21</xsl:when> <!-- ��Ӷ -->
	<xsl:when test="$relationToInsured=04">22</xsl:when> <!-- ���� -->
</xsl:choose>
</xsl:template>

<!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
<xsl:template name="tran_RiskCode">
	<xsl:param name="riskCode" />
	<xsl:choose>
		<xsl:when test="$riskCode='122046'">50002</xsl:when><!-- �������Ӯ���ռƻ� -->			
		<xsl:when test="$riskCode='L12078'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskCode='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskCode='L12079'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ� -->
		<xsl:when test="$riskCode='L12074'">L12074</xsl:when><!-- ����ʢ��9���������գ������ͣ� -->
		<xsl:when test="$riskCode='L12091'">L12091</xsl:when><!-- �����Ӯ1�������A�� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
