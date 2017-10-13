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
			<ContNo><xsl:value-of select="ContNo"/></ContNo>									<!-- 保险单号 -->		
			<ProposalContNo><xsl:value-of select="ProposalPrtNo"/></ProposalContNo>       <!--—投保书号 -->
			<SignDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/SignDate)"/></SignDate>	<!-- 承保日期 -->
			<CValiDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10($MainRisk/CValiDate)"/></CValiDate>													<!-- 生效日期 -->
			
			<BankAccName><xsl:value-of select="Appnt/Name"/></BankAccName>											<!-- 账户姓名 -->
			<BankAcc><xsl:value-of select="AccNo"/></BankAcc>															<!-- 银行账户 -->
			<AccBankcode></AccBankcode>											<!-- 银行编码 -->		
			
			<GetPolMode></GetPolMode>			<!--—保单递送方式-->
			<SpecContent><xsl:value-of select="SpecContent"/></SpecContent>		<!--—特别约定-->		
			<PrtNo><xsl:value-of select="ContPrtNo"/></PrtNo>       													<!--—保单印刷号-->
			
			<AgentCode><xsl:value-of select="AgentCode"/></AgentCode>													<!-- 代理人编码 -->
			<AgentGroup><xsl:value-of select="AgentGrpCode"/></AgentGroup>												<!-- 代理人组别 -->
			<AgentName><xsl:value-of select="AgentName"/></AgentName>													<!-- 代理人姓名 -->    
			<ManageCom><xsl:value-of select="ComName"/></ManageCom>													<!-- 承保公司 -->
			<OperCom><xsl:value-of select="ComCode"/></OperCom>															<!-- 营业单位代码 -->
			<ComLocation><xsl:value-of select="ComLocation"/></ComLocation>											<!-- 公司地址 -->
			<ComPhone><xsl:value-of select="ComPhone"/></ComPhone>														<!-- 公司电话 -->
			
			<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/></Prem>																		<!-- 总保费小写 -->		
			<PremText><xsl:value-of select="ActSumPremText"/></PremText>														<!-- 总保费大写 -->
		
		<!-- 投保人信息 -->	
		<LCAppnt>
		
		  	<AppntNo><xsl:value-of select="Appnt/CustomerNo"/></AppntNo>								          <!--—投保人客户号--> 
			<AppntName><xsl:value-of select="Appnt/Name"/></AppntName>								<!--—投保人姓名-->
			<AppntSex><xsl:value-of select="Appnt/Sex"/></AppntSex>											<!--—投保人性别-->
			<AppntBirthday>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Appnt/Birthday)"/>
			</AppntBirthday>			<!--—投保人出生日期-->
			<AppntIDType>
				<xsl:call-template name="tran_idtype">
					<xsl:with-param name="idtype">
						<xsl:value-of select ="Appnt/IDType"/>
					</xsl:with-param>
				</xsl:call-template>
			</AppntIDType>								<!--—投保人证件类型-->
			<AppntIDNo><xsl:value-of select="Appnt/IDNo"/></AppntIDNo>			<!--—投保人证件号码-->			
			<AppntNativePlace>
			<xsl:call-template name="tran_nationality">
					<xsl:with-param name="nationality">
						<xsl:value-of select="Appnt/Nationality"/>
					</xsl:with-param>
			</xsl:call-template>
			</AppntNativePlace>		  	<!--—投保人国籍-->
			<AppntNationality></AppntNationality>		  	<!---投保人民族-->
			<AppntMarriage></AppntMarriage>		  	      <!---投保人婚姻状况-->
			<AppntStature><xsl:value-of select="Appnt/Stature"/></AppntStature>		          	<!--—投保人身高-->
			<AppntAvoirdupois><xsl:value-of select="Appnt/Weight"/></AppntAvoirdupois>		  	<!--—投保人体重-->
			<AppntSmokeFlag></AppntSmokeFlag>		  	    <!--—是否吸烟标志-->
						
			<AppntOfficePhone></AppntOfficePhone>				<!-- 投保人办公电话 -->
			<AppntMobile><xsl:value-of select="Appnt/Mobile"/></AppntMobile>									<!-- 投保人移动电话 -->
			<AppntPhone><xsl:value-of select="Appnt/Phone"/></AppntPhone>										<!-- 投保人住宅电话 -->

			<MailAddress><xsl:value-of select="Appnt/Address"/></MailAddress>									<!-- 投保人邮寄地址 -->
			<MailZipCode><xsl:value-of select="Appnt/ZipCode"/></MailZipCode>									<!-- 投保人邮寄邮编 -->
			<HomeAddress><xsl:value-of select="Appnt/Address"/> </HomeAddress>					<!-- 投保人家庭地址 -->
			<HomeZipCode><xsl:value-of select="Appnt/ZipCode"/></HomeZipCode>						<!--—投保人家庭邮编 -->
			<AppntEmail><xsl:value-of select="Appnt/Email"/></AppntEmail>					        	<!--投保人电子邮件 -->
			<AppntJobCode>
				<xsl:call-template name="tran_jobcode">
						<xsl:with-param name="jobcode">
							<xsl:value-of select ="Appnt/JobCode"/>
						</xsl:with-param>
				</xsl:call-template>
			</AppntJobCode>								<!-- 投保人职业代码 -->		
		
			<TellInfos>			<!-- 告知列表 -->
				<HealthFlag></HealthFlag>							<!-- 健康告之标志 -->
				<TellInfoCount></TellInfoCount>						<!-- 告知项目数 -->
				<TellInfo>
					<TellCode></TellCode>										<!-- 告知编码 -->
					<TellContent></TellContent>  					<!-- 告知内容 -->
					<TellRemark></TellRemark>			 					    <!-- 告知备注 -->
				</TellInfo>
			</TellInfos>
					
		</LCAppnt>
		<!-- 被保险人 -->
		<LCInsureds> <!-- 被保人列表 -->
			<LCInsuredCount>1</LCInsuredCount>	<!-- 被保人数目 -->
			<LCInsured>	<!-- 被保人信息 -->
			  <InsuredNo><xsl:value-of select ="Insured/CustomerNo"/></InsuredNo>								  <!--—被保人客户号--> 
				<Name><xsl:value-of select ="Insured/Name"/></Name>										<!-- 被保人姓名 -->
				<Sex><xsl:value-of select ="Insured/Sex"/></Sex>														<!-- 被保人性别 -->
				<Birthday>
				<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Insured/Birthday)"/>
				</Birthday>						<!-- 被保人出生日期 -->
				<IDType>
					<xsl:call-template name="tran_idtype">
						<xsl:with-param name="idtype">
							<xsl:value-of select ="Insured/IDType"/>
						</xsl:with-param>
					</xsl:call-template>
				</IDType>											<!-- 被保人证件类型 -->
				<IDNo><xsl:value-of select ="Insured/IDNo"/></IDNo>						<!-- 被保人证件号码 -->
				
				<NativePlace>
					<xsl:call-template name="tran_nationality">
						<xsl:with-param name="nationality">
							<xsl:value-of select="Insured/Nationality"/>
						</xsl:with-param>
					</xsl:call-template>
				</NativePlace>		  	      <!--—被保人国籍-->
			  <Nationality></Nationality>		  	      <!---被保人民族-->
			  <Marriage></Marriage>		  	            <!---被保人婚姻状况-->
			  <Stature><xsl:value-of select ="Insured/Stature"/></Stature>		          	      <!--—被保人身高-->
			  <Avoirdupois><xsl:value-of select ="Insured/Weight"/></Avoirdupois>		  	      <!--—被保人体重-->
			  <SmokeFlag></SmokeFlag>		  	          <!--—是否吸烟标志-->
				
				<JobCode>
					<xsl:call-template name="tran_jobcode">
						<xsl:with-param name="jobcode">
							<xsl:value-of select ="Insured/JobCode"/>
						</xsl:with-param>
				</xsl:call-template>
				</JobCode>											<!-- 被保人职业代码 -->
				<MailAddress><xsl:value-of select ="Insured/Address"/></MailAddress>			<!-- 被保人地址 -->
				<MailZipCode><xsl:value-of select ="Insured/ZipCode"/></MailZipCode>				<!-- 被保人邮编 -->
				<Phone><xsl:value-of select ="Insured/Phone"/></Phone>					        <!-- 被保人电话 -->
				<Mobile><xsl:value-of select ="Insured/Mobile"/></Mobile>									      <!-- 被保人移动电话 -->
				<Email><xsl:value-of select ="Insured/Email"/></Email>					        	      <!-- 被保人电子邮件 -->
				<RelaToMain></RelaToMain>								<!-- 与主被保人关系 -->
				<RelaToAppnt>
					<xsl:call-template name="tran_RelationRoleCode">
						<xsl:with-param name="relationRoleCode">
							<xsl:value-of select="Appnt/RelaToInsured"/>
						</xsl:with-param>
			  		 </xsl:call-template>
				</RelaToAppnt>							<!-- 与投保人关系 -->
				
		   	<TellInfos>			<!-- 告知列表 -->
		   		<HealthFlag></HealthFlag>							<!-- 健康告之标志 -->
		   		<TellInfoCount></TellInfoCount>						<!-- 告知项目数 -->
		   		<TellInfo>
		   			<TellCode></TellCode>										<!-- 告知编码 -->
		   			<TellContent></TellContent>  					<!-- 告知内容 -->
		   			<TellRemark></TellRemark>			 					    <!-- 告知备注 -->
		   		</TellInfo>
		   	</TellInfos>
			
		<Risks> <!-- 险种列表 -->
			<RiskCount><xsl:value-of select="count(Risk)"/></RiskCount>
			<xsl:for-each select="Risk">
				<Risk> <!-- 险种 -->
					<RiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskCode">
							<xsl:value-of select="RiskCode" />
						</xsl:with-param>
					</xsl:call-template>
					</RiskCode>          			<!--—险种代码-->
					<MainRiskCode>
					<xsl:call-template name="tran_RiskCode">
						<xsl:with-param name="riskCode">
							<xsl:value-of select="MainRiskCode" />
						</xsl:with-param>
					</xsl:call-template>
					</MainRiskCode>					<!-- 主险代码 -->
					<RiskType></RiskType>									<!-- 险种类型 -->
					<RiskName><xsl:value-of select ="RiskName"/></RiskName>									<!-- 险种名称 -->		
					
					<UpperPrem></UpperPrem>            		<!-- 保险费大写 -->
	          		<Prem><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/></Prem>            						<!-- 保险费 -->
           			<PremItems>
						<PremItemsCount></PremItemsCount>		<!-- 保费项目数目 -->
						<PremItem>
							<PremType></PremType>							<!-- 保费类型 -->
							<DetailPrem></DetailPrem>					<!-- 保费明细 -->				
							<FirstRate></FirstRate>					  <!-- 初始费用率 -->		
							<FirstCharge></FirstCharge>				<!-- 初始费用 -->					
						</PremItem>
					</PremItems>
					<UpperAmnt></UpperAmnt>								<!-- 保额大写 -->
					<Amnt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/></Amnt>													<!-- 保额 -->
					<Rate></Rate>													<!-- 费率 -->
					<Rank></Rank>            						<!-- 档次 -->						
					<Mult><xsl:value-of select ="Mult"/></Mult>            						<!-- 投保份数 -->	
					<PayDateChn>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PayEndDate, 'yyyyMMdd'),'yyyy年MM月dd日')"/>
					</PayDateChn>       			<!--缴费日期-->
					<PaysDateChn>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PayEndDate, 'yyyyMMdd'),'yyyy年MM月dd日')"/>
					</PaysDateChn>       	  <!--缴费期间-->
					<PayToDate>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getDateStr(java:com.sinosoft.midplat.common.DateUtil.parseDate(PayEndDate, 'yyyyMMdd'),'yyyy年MM月dd日')"/>
					</PayToDate>       	      <!--缴费期满日期-->
					<PayEndYearFlag><xsl:value-of select ="PayEndYearFlag"/></PayEndYearFlag>   	<!--—缴费年期类型-->
					<PayYears><xsl:value-of select ="PayEndYear"/></PayYears>       				<!--—缴费年期-->
					<PayIntv><xsl:value-of select ="PayIntv"/></PayIntv>									<!-- 缴费间隔-->
	        		<PayMode><xsl:call-template name="tran_PayMode">
						<xsl:with-param name="payMode">
							<xsl:value-of select="PayMode"/>
						</xsl:with-param>
			  		 </xsl:call-template></PayMode>              		<!--—缴费形式-->			
					<Years><xsl:value-of select ="Years"/></Years>							      		<!-- 保险期间 -->	
					<InsuYearFlag><xsl:value-of select ="InsuYearFlag"/></InsuYearFlag>					<!-- 保险年龄年期标志 -->
					<InsuYear><xsl:value-of select ="InsuYear"/></InsuYear>									<!-- 保险年龄年期 -->	
					<CValiDate>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(CValiDate)"/>		
					</CValiDate><!-- 起保日期 -->							
					<EndDate></EndDate>								    <!-- 保险终止日期 -->	
						
					<GetYearFlag><xsl:value-of select ="GetYearFlag"/></GetYearFlag>						<!-- 领取年龄年期标志 -->
					<GetYear><xsl:value-of select ="GetYear"/></GetYear>                  	<!--—领取年龄-->
					<GetIntv><xsl:value-of select ="GetIntv"/></GetIntv>										<!-- 领取间隔 -->
					<GetStartDate>
					<xsl:value-of select="GetStartDate"/>	
					</GetStartDate>					<!-- 起领日期 -->							
					<GetBankCode><xsl:value-of select ="GetBankCode"/></GetBankCode>						<!-- 领取银行编码 -->
					<GetBankAccNo><xsl:value-of select ="GetBankAccNo"/></GetBankAccNo>					<!-- 领取银行账户 -->
					<GetAccName><xsl:value-of select ="GetAccName"/></GetAccName>							<!-- 领取银行户名 -->
					
					<CostIntv><xsl:value-of select ="CostIntv"/></CostIntv>   							<!-- 扣款间隔 -->
					<CostDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(CostDate)"/>
					</CostDate>   							<!-- 扣款时间 -->		
						
					
					<AutoPayFlag><xsl:value-of select ="AutoPayFlag"/></AutoPayFlag>          <!-- 垫交标志 -->
					<BonusPayMode></BonusPayMode>				<!-- 红利分配标记 -->
					<SubFlag><xsl:value-of select ="SubFlag"/></SubFlag>										<!-- 减额交清标志 -->
					<BonusGetMode><xsl:value-of select ="BonusGetMode"/></BonusGetMode>        <!-- 红利领取方式 -->
					<FullBonusGetMode><xsl:value-of select ="FullBonusGetMode"/></FullBonusGetMode>	<!-- 满期领取金领取方式 -->
					<AutoRenewFlag><xsl:value-of select ="JobCode"/></AutoRenewFlag>	      <!-- 自动续保标记 -->
					
					<FirstRate></FirstRate>								<!-- 初始费用率 -->
					<SureRate></SureRate>									<!-- 保证利率 -->
					<FirstValue></FirstValue>							<!-- 保单价值初始值 -->		
						
					
					<Accounts>
						<AccountCount><xsl:value-of select="count(Accounts/Account)"/></AccountCount>				<!-- 投资账户数目 -->
						<xsl:for-each select="Accounts/Account">
						<Account>
							<AccNo><xsl:value-of select ="AccNo"/></AccNo>										<!-- 投资账户编码 -->
							<AccName></AccName>								<!-- 投资账户名称 -->
							<AccMoney><xsl:value-of select ="AccMoney"/></AccMoney>							<!-- 投资账户金额 -->
							<AccRate><xsl:value-of select ="AccRate"/></AccRate>								<!-- 投资账户比率 -->
							<SureRate></SureRate>						  <!-- 保证利率 -->								
						</Account>
						</xsl:for-each>
					</Accounts>
						
						
				<LCBnfs> <!-- 受益人列表 -->
					<LCBnfCount><xsl:value-of select="count(../Bnf)"/></LCBnfCount>						<!-- 受益人数目 -->
					<xsl:for-each select="../Bnf">
			    	<LCBnf> <!-- 受益人 -->
				    	<BnfType><xsl:value-of select ="Type"/></BnfType>												<!-- 受益人类别 -->
				    	<BnfNo></BnfNo>														<!-- 受益人序号 -->
				    	<BnfGrade><xsl:value-of select ="Grade"/></BnfGrade>											<!-- 受益人级别 -->
						<Name><xsl:value-of select ="Name"/></Name>												<!--—受益人姓名-->
					    <Sex><xsl:value-of select ="Sex"/></Sex>															<!--—受益人性别-->
						<RelationToInsured>
						<xsl:call-template name="tran_RelationToInsured">
							<xsl:with-param name="relationToInsured">
								<xsl:value-of select="RelaToInsured"/>
							</xsl:with-param>
				  		 </xsl:call-template>
						</RelationToInsured>  <!--—与被保人关系 -->
						<Birthday>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date8to10(Birthday)"/>
						</Birthday>    					<!--—受益人出生日期-->
						<IDType>
						<xsl:call-template name="tran_idtype">
							<xsl:with-param name="idtype">
								<xsl:value-of select ="IDType"/>
							</xsl:with-param>
						</xsl:call-template>
						</IDType>         								<!--—受益人证件类型-->
						<IDNo><xsl:value-of select ="IDNo"/></IDNo>							<!--—受益人证件号码-->
					    <BnfLot><xsl:value-of select ="Lot"/></BnfLot> 											<!--—受益百分数-->
						<Address></Address>												<!-- 受益人通讯地址 -->
					</LCBnf>
					</xsl:for-each>
				</LCBnfs>

				<CashValues>	<!-- 现金价值表 -->
					<CashValueCount><xsl:value-of select="count(CashValues/CashValue)"/></CashValueCount>		<!-- 现金价值数目 -->
					<xsl:for-each select="CashValues/CashValue">
			    	<CashValue>
						<End><xsl:value-of select ="EndYear"/></End>       				<!-- 年末 -->
			      		<Cash><xsl:value-of select ="Cash"/></Cash>			<!-- 年末现金价值 -->
			      		<VoidCash></VoidCash>			<!-- 年末现金价值 -->
					</CashValue>
					</xsl:for-each>
				</CashValues>

				<BonusValues>	<!-- 红利保额保单年度末现金价值表 -->
					<BonusValueCount><xsl:value-of select="count(BonusValues/BonusValue)"/></BonusValueCount>		<!-- 现金价值数目 -->
					<xsl:for-each select="BonusValues/BonusValue">
					<BonusValue>
						<End><xsl:value-of select ="EndYear"/></End>								<!-- 年末 -->
						<Cash><xsl:value-of select ="EndYearCash"/></Cash>							<!-- 年末现金价值 -->
					</BonusValue>
					</xsl:for-each>
				</BonusValues>
			</Risk>
			</xsl:for-each>
			</Risks>
	    </LCInsured>
		</LCInsureds>
		
		
		<!--保单逐行打印接口-->
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
				<Page1Print><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    币值单位：人民币元</xsl:text></Page1Print>
				<Page1Print>　　　------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print>
					<xsl:text>　　　投保人姓名：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:choose>
									<xsl:when test="Appnt/IDType = 0">
										<xsl:text>身份证    </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 1">
										<xsl:text>护照      </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 2">
										<xsl:text>军官证    </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 3">
										<xsl:text>驾照      </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 4">
										<xsl:text>出生证明  </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 5">
										<xsl:text>户口簿    </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 8">
										<xsl:text>其他      </xsl:text>
									</xsl:when>
									<xsl:when test="Appnt/IDType = 9">
										<xsl:text>异常身份证</xsl:text>
									</xsl:when>
									<xsl:otherwise>--      </xsl:otherwise>
								</xsl:choose>
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</Page1Print>
				<Page1Print>
					<xsl:text>　　　被保险人：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:choose>
									<xsl:when test="Insured/IDType = 0">
										<xsl:text>身份证    </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 1">
										<xsl:text>护照      </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 2">
										<xsl:text>军官证    </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 3">
										<xsl:text>驾照      </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 4">
										<xsl:text>出生证明  </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 5">
										<xsl:text>户口簿    </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 8">
										<xsl:text>其他      </xsl:text>
									</xsl:when>
									<xsl:when test="Insured/IDType = 9">
										<xsl:text>异常身份证</xsl:text>
									</xsl:when>
									<xsl:otherwise>--      </xsl:otherwise>
								</xsl:choose> 
					<xsl:text>        证件号码：</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</Page1Print>
				<Page1Print/>
				<Page1Print>　　　------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print>　　　------------------------------------------------------------------------------------------------</Page1Print>
				<xsl:if test="count(Bnf) = 0">
				<Page1Print><xsl:text>　　　身故受益人：法定                </xsl:text>
				   <xsl:text>受益顺序：1                   </xsl:text>
				   <xsl:text>受益比例：100%</xsl:text></Page1Print>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<Page1Print>
							<xsl:text>　　　身故受益人：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>受益顺序：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>受益比例：</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</Page1Print>
					</xsl:for-each>
				</xsl:if>
				<Page1Print>　　　------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print/>
				<Page1Print>　　　险种资料</Page1Print>
				<Page1Print>　　　------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　基本保险金额\</xsl:text>
				</Page1Print>
				<Page1Print>
					<xsl:text>　　　　　　　　　　险种名称               保险期间    交费年期     日津贴额\     保险费     交费频率</xsl:text>
				</Page1Print>
				<Page1Print>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　份数\档次</xsl:text>
				</Page1Print>
				<Page1Print>　　　------------------------------------------------------------------------------------------------</Page1Print>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
					<Page1Print>
						<xsl:text>　　　</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 9)"/>
							</xsl:when>
							<xsl:when test="InsuYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 9)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 9)"/>
								<xsl:text/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PayIntv = 0">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次交清', 12)"/>
							</xsl:when>
							<xsl:when test="PayEndYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 10)"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('保单帐户价值',15)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Prem,13)"/>
						<xsl:choose>
							<xsl:when test="PayIntv = 0">
								<xsl:text>趸缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = 12">
								<xsl:text>年缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = 6">
								<xsl:text>半年缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = 3">
								<xsl:text>季缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = 1">
								<xsl:text>月缴</xsl:text>
							</xsl:when>
							<xsl:when test="PayIntv = -1">
								<xsl:text>不定期缴</xsl:text>
							</xsl:when>
						</xsl:choose>
					</Page1Print>
				</xsl:for-each>
				<Page1Print>　　　------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print/>
				<Page1Print/>
				<Page1Print>　　　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</Page1Print>
				<Page1Print/>
				<Page1Print>　　　------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print/>
				<Page1Print/>
				<Page1Print>　　　------------------------------------------------------------------------------------------------</Page1Print>
				<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
				<Page1Print>　　　保险单特别约定：<xsl:choose>
						<xsl:when test="$SpecContent=''">
							<xsl:text>（无）</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$SpecContent"/>
						</xsl:otherwise>
					</xsl:choose>
				</Page1Print>
				<Page1Print/>
				<Page1Print/>
				<Page1Print/>
				<Page1Print>　　　-------------------------------------------------------------------------------------------------</Page1Print>
				<Page1Print><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</Page1Print>
				<Page1Print></Page1Print>
				<Page1Print></Page1Print>
				<Page1Print><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></Page1Print>
				
				<Page1Print><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></Page1Print>
				
				<Page1Print><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></Page1Print>
				<Page1Print></Page1Print>
				<Page1Print><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></Page1Print>
				<Page1Print><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></Page1Print>
				<Page1Print></Page1Print>
				<Page1Print><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/>银行销售人员工号：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></Page1Print>
				<Page1Print><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/></Page1Print>
		
			</Print1>
		<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
			<xsl:variable name="RiskCount" select="count(Risk)"/>
			<Print2>
				<Page2Print><xsl:text>　　　                                        </xsl:text>现金价值表</Page2Print>
				<Page2Print/>
				<Page2Print>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </Page2Print>
				<Page2Print>　　　------------------------------------------------------------------------------------------------</Page2Print>
				<Page2Print>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></Page2Print>
                <xsl:if test="$RiskCount=1">
		        <Page2Print>
			    <xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Page2Print>
		        <Page2Print><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
				   <xsl:text>现金价值</xsl:text></Page2Print>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <Page2Print><xsl:text/><xsl:text>　　　　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</Page2Print>
			    </xsl:for-each>
	            </xsl:if>
	 
	            <xsl:if test="$RiskCount!=1">
	 	        <Page2Print>
			    <xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Page2Print>
		        <Page2Print><xsl:text/>　　　保单年度末<xsl:text>                                        </xsl:text>
				   <xsl:text>现金价值</xsl:text></Page2Print>
		   	       <xsl:variable name="EndYear" select="EndYear"/>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <Page2Print>
					 <xsl:text/><xsl:text>　　　　　</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</Page2Print>
			    </xsl:for-each>
	            </xsl:if>
				<Page2Print>　　　------------------------------------------------------------------------------------------------</Page2Print>
				<Page2Print/>
				<Page2Print>　　　备注：</Page2Print>
				<Page2Print>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</Page2Print>
				<Page2Print>　　　------------------------------------------------------------------------------------------------</Page2Print>
				</Print2>
			</xsl:if>
			</Print>
		
		</LCCont>
	</xsl:template>

<!-- 证件类型 -->

<!-- 核心：0	居民身份证,1 护照,2 军官证,3 驾照,4 出生证明,5	户口簿,8	其他,9	异常身份证 -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$idtype='0'">0</xsl:when><!-- 身份证 -->
		<xsl:when test="$idtype='1'">1</xsl:when><!-- 护照 -->
		<xsl:when test="$idtype='2'">2</xsl:when><!-- 军官证 -->
		<xsl:when test="$idtype='5'">3</xsl:when><!-- 户口簿 -->
		<xsl:when test="$idtype='8'">4</xsl:when><!-- 港澳台通行证 -->
		<xsl:when test="$idtype='8'">5</xsl:when><!-- 武警身份证 -->
		<xsl:when test="$idtype='8'">6</xsl:when><!-- 边民出入境通行证 -->
	</xsl:choose>
</xsl:template>

<!-- 职业代码 -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode= '1010106'">001</xsl:when><!-- 国家机关、党群组织、企业、事业单位人员-->
		<xsl:when test="$jobcode= '2050601'">002</xsl:when><!-- 卫生专业技术人员                      -->
		<xsl:when test="$jobcode= '2070502'">003</xsl:when><!-- 金融业务人员???                       -->
		<xsl:when test="$jobcode= '2080103'">004</xsl:when><!-- 法律专业人员                          -->
		<xsl:when test="$jobcode= '2090101'">005</xsl:when><!-- 教学人员                              -->
		<xsl:when test="$jobcode= '2120109'">006</xsl:when><!-- 新闻出版及文学艺术工作人员            -->
		<xsl:when test="$jobcode= '2130101'">007</xsl:when><!-- 宗教职业者                            -->
		<xsl:when test="$jobcode= '3030101'">008</xsl:when><!-- 邮政和电信业务人员                    -->
		<xsl:when test="$jobcode= '9210102'">009</xsl:when><!-- 商业、服务业人员                      -->
		<xsl:when test="$jobcode= '5050104'">010</xsl:when><!-- 农、林、牧、渔、水利业生产人员        -->
		<xsl:when test="$jobcode= '6240107'">011</xsl:when><!-- 运输人员??                            -->
		<xsl:when test="$jobcode= '2020101'">012</xsl:when><!-- 地质勘测人员                          -->
		<xsl:when test="$jobcode= '6230911'">013</xsl:when><!-- 工程施工人员?                         -->
		<xsl:when test="$jobcode= '6050908'">014</xsl:when><!-- 加工制造、检验及计量人员              -->
		<xsl:when test="$jobcode= '7010121'">015</xsl:when><!-- 军人                                  -->
		<xsl:when test="$jobcode= '8010101'">016</xsl:when><!-- 无业                                  -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- 投保人城乡类型 TBR_LIVEZONE -->
<xsl:template name="tran_livezone">
<xsl:param name="livezone" />
<xsl:choose>
	<xsl:when test="$livezone=1">0</xsl:when>	<!-- 城镇居民 -->
	<xsl:when test="$livezone=2">1</xsl:when>	<!-- 农村居民 -->
</xsl:choose>
</xsl:template>
<!-- 国籍 -->
<xsl:template name="tran_nationality">
<xsl:param name="nationality" />
<xsl:choose>
		<xsl:when test="$nationality='AW'">ABW</xsl:when><!--阿鲁巴-->
		<xsl:when test="$nationality='AF'">AFG</xsl:when><!--阿富汗-->
		<xsl:when test="$nationality='AO'">AGO</xsl:when><!--安哥拉-->
		<xsl:when test="$nationality='AI'">AIA</xsl:when><!--安圭拉-->
		<xsl:when test="$nationality='AL'">ALB</xsl:when><!--阿尔巴尼亚-->
		<xsl:when test="$nationality='AD'">AND</xsl:when><!--安道尔-->
		<xsl:when test="$nationality='AN'">ANT</xsl:when><!--荷属安的列斯-->
		<xsl:when test="$nationality='AE'">ARE</xsl:when><!--阿联酋-->
		<xsl:when test="$nationality='AR'">ARG</xsl:when><!--阿根廷-->
		<xsl:when test="$nationality='AM'">ARM</xsl:when><!--亚美尼亚-->
		<xsl:when test="$nationality='AS'">ASM</xsl:when><!--美属萨摩亚-->
		<xsl:when test="$nationality='OTH'">ATA</xsl:when><!--南极洲-->
		<xsl:when test="$nationality='OTH'">ATF</xsl:when><!--法属南部领土-->
		<xsl:when test="$nationality='AG'">ATG</xsl:when><!--安提瓜和巴布达-->
		<xsl:when test="$nationality='AU'">AUS</xsl:when><!--澳大利亚-->
		<xsl:when test="$nationality='AT'">AUT</xsl:when><!--奥地利-->
		<xsl:when test="$nationality='AZ'">AZE</xsl:when><!--阿塞拜疆      -->
		<xsl:when test="$nationality='BI'">BDI</xsl:when><!--布隆迪-->
		<xsl:when test="$nationality='BE'">BEL</xsl:when><!--比利时-->
		<xsl:when test="$nationality='BJ'">BEN</xsl:when><!--贝宁-->
		<xsl:when test="$nationality='BF'">BFA</xsl:when><!--布基纳法索-->
		<xsl:when test="$nationality='BD'">BGD</xsl:when><!--孟加拉国-->
		<xsl:when test="$nationality='BG'">BGR</xsl:when><!--保加利亚-->
		<xsl:when test="$nationality='BH'">BHR</xsl:when><!--巴林-->
		<xsl:when test="$nationality='BS'">BHS</xsl:when><!--巴哈马-->
		<xsl:when test="$nationality='BA'">BIH</xsl:when><!--波斯尼亚和黑塞哥维那-->
		<xsl:when test="$nationality='BY'">BLR</xsl:when><!--白俄罗斯-->
		<xsl:when test="$nationality='BZ'">BLZ</xsl:when><!--伯利兹-->
		<xsl:when test="$nationality='BM'">BMU</xsl:when><!--百慕大-->
		<xsl:when test="$nationality='BO'">BOL</xsl:when><!--玻利维亚-->
		<xsl:when test="$nationality='BR'">BRA</xsl:when><!--巴西-->
		<xsl:when test="$nationality='BB'">BRB</xsl:when><!--巴巴多斯-->
		<xsl:when test="$nationality='BN'">BRN</xsl:when><!--文莱-->
		<xsl:when test="$nationality='BT'">BTN</xsl:when><!--不丹-->
		<xsl:when test="$nationality='OTH'">BVT</xsl:when><!--布维岛-->
		<xsl:when test="$nationality='BW'">BWA</xsl:when><!--博茨瓦纳-->
		<xsl:when test="$nationality='CF'">CAF</xsl:when><!--中非-->
		<xsl:when test="$nationality='CA'">CAN</xsl:when><!--加拿大-->
		<xsl:when test="$nationality='OTH'">CCK</xsl:when><!--科科斯基林群岛-->
		<xsl:when test="$nationality='CH'">CHE</xsl:when><!--瑞士-->
		<xsl:when test="$nationality='CL'">CHL</xsl:when><!--智利-->
		<xsl:when test="$nationality='CHN'">CHN</xsl:when><!--中国-->
		<xsl:when test="$nationality='CI'">CIV</xsl:when><!--科特迪瓦-->
		<xsl:when test="$nationality='CM'">CMR</xsl:when><!--喀麦隆-->
		<xsl:when test="$nationality='CG'">COD</xsl:when><!--刚果金-->
		<xsl:when test="$nationality='ZR'">COG</xsl:when><!--刚果布-->
		<xsl:when test="$nationality='CK'">COK</xsl:when><!--库克群岛-->
		<xsl:when test="$nationality='CO'">COL</xsl:when><!--哥伦比亚-->
		<xsl:when test="$nationality='KM'">COM</xsl:when><!--科摩罗-->
		<xsl:when test="$nationality='CV'">CPV</xsl:when><!--佛得角-->
		<xsl:when test="$nationality='CR'">CRI</xsl:when><!--哥斯达黎加-->
		<xsl:when test="$nationality='CU'">CUB</xsl:when><!--古巴-->
		<xsl:when test="$nationality='OTH'">CXR</xsl:when><!--圣诞岛-->
		<xsl:when test="$nationality='KY'">CYM</xsl:when><!--开曼群岛-->
		<xsl:when test="$nationality='CY'">CYP</xsl:when><!--塞浦路斯-->
		<xsl:when test="$nationality='CZ'">CZE</xsl:when><!--捷克-->
		<xsl:when test="$nationality='DE'">DEU</xsl:when><!--德国-->
		<xsl:when test="$nationality='DJ'">DJI</xsl:when><!--吉布提-->
		<xsl:when test="$nationality='DM'">DMA</xsl:when><!--多米尼克-->
		<xsl:when test="$nationality='DK'">DNK</xsl:when><!--丹麦-->
		<xsl:when test="$nationality='DO'">DOM</xsl:when><!--多米尼加共和国-->
		<xsl:when test="$nationality='DZ'">DZA</xsl:when><!--阿尔及利亚-->
		<xsl:when test="$nationality='EC'">ECU</xsl:when><!--厄瓜多尔-->
		<xsl:when test="$nationality='EG'">EGY</xsl:when><!--埃及-->
		<xsl:when test="$nationality='ER'">ERI</xsl:when><!--厄立特里亚-->
		<xsl:when test="$nationality='OTH'">ESH</xsl:when><!--西撒哈拉-->
		<xsl:when test="$nationality='ES'">ESP</xsl:when><!--西班牙-->
		<xsl:when test="$nationality='EE'">EST</xsl:when><!--爱沙尼亚-->
		<xsl:when test="$nationality='ET'">ETH</xsl:when><!--埃塞俄比亚-->
		<xsl:when test="$nationality='FI'">FIN</xsl:when><!--芬兰-->
		<xsl:when test="$nationality='FJ'">FJI</xsl:when><!--斐济-->
		<xsl:when test="$nationality='OTH'">FLK</xsl:when><!--马尔维纳斯群岛福克兰群岛-->
		<xsl:when test="$nationality='FR'">FRA</xsl:when><!--法国-->
		<xsl:when test="$nationality='FO'">FRO</xsl:when><!--法罗群岛-->
		<xsl:when test="$nationality='OTH'">FSM</xsl:when><!--密克罗尼西亚-->
		<xsl:when test="$nationality='GA'">GAB</xsl:when><!--加蓬-->
		<xsl:when test="$nationality='GB'">GBR</xsl:when><!--英国-->
		<xsl:when test="$nationality='GE'">GEO</xsl:when><!--格鲁吉亚-->
		<xsl:when test="$nationality='GH'">GHA</xsl:when><!--加纳-->
		<xsl:when test="$nationality='GI'">GIB</xsl:when><!--直布罗陀-->
		<xsl:when test="$nationality='GN'">GIN</xsl:when><!--几内亚-->
		<xsl:when test="$nationality='GP'">GLP</xsl:when><!--瓜德罗普-->
		<xsl:when test="$nationality='GM'">GMB</xsl:when><!--冈比亚-->
		<xsl:when test="$nationality='GW'">GNB</xsl:when><!--几内亚比绍-->
		<xsl:when test="$nationality='GQ'">GNQ</xsl:when><!--赤道几内亚-->
		<xsl:when test="$nationality='GR'">GRC</xsl:when><!--希腊-->
		<xsl:when test="$nationality='GD'">GRD</xsl:when><!--格林纳达-->
		<xsl:when test="$nationality='GL'">GRL</xsl:when><!--格陵兰-->
		<xsl:when test="$nationality='GT'">GTM</xsl:when><!--危地马拉-->
		<xsl:when test="$nationality='GF'">GUF</xsl:when><!--法属圭亚那-->
		<xsl:when test="$nationality='GU'">GUM</xsl:when><!--关岛-->
		<xsl:when test="$nationality='GY'">GUY</xsl:when><!--圭亚那-->
		<xsl:when test="$nationality='CHN'">HKG</xsl:when><!--香港-->
		<xsl:when test="$nationality='OTH'">HMD</xsl:when><!--赫德岛和麦克唐纳岛-->
		<xsl:when test="$nationality='HN'">HND</xsl:when><!--洪都拉斯-->
		<xsl:when test="$nationality='HR'">HRV</xsl:when><!--克罗地亚-->
		<xsl:when test="$nationality='HT'">HTI</xsl:when><!--海地-->
		<xsl:when test="$nationality='HU'">HUN</xsl:when><!--匈牙利-->
		<xsl:when test="$nationality='ID'">IDN</xsl:when><!--印度尼西亚-->
		<xsl:when test="$nationality='IN'">IND</xsl:when><!--印度-->
		<xsl:when test="$nationality='OTH'">IOT</xsl:when><!--英属印度洋领土-->
		<xsl:when test="$nationality='IE'">IRL</xsl:when><!--爱尔兰-->
		<xsl:when test="$nationality='IR'">IRN</xsl:when><!--伊朗-->
		<xsl:when test="$nationality='IQ'">IRQ</xsl:when><!--伊拉克-->
		<xsl:when test="$nationality='IS'">ISL</xsl:when><!--冰岛-->
		<xsl:when test="$nationality='IL'">ISR</xsl:when><!--以色列-->
		<xsl:when test="$nationality='IT'">ITA</xsl:when><!--意大利-->
		<xsl:when test="$nationality='JM'">JAM</xsl:when><!--牙买加-->
		<xsl:when test="$nationality='JO'">JOR</xsl:when><!--约旦-->
		<xsl:when test="$nationality='JP'">JPN</xsl:when><!--日本-->
		<xsl:when test="$nationality='KZ'">KAZ</xsl:when><!--哈萨克斯坦-->
		<xsl:when test="$nationality='KE'">KEN</xsl:when><!--肯尼亚-->
		<xsl:when test="$nationality='KG'">KGZ</xsl:when><!--吉尔吉斯斯坦-->
		<xsl:when test="$nationality='KH'">KHM</xsl:when><!--柬埔寨-->
		<xsl:when test="$nationality='KT'">KIR</xsl:when><!--基里巴斯-->
		<xsl:when test="$nationality='SX'">KNA</xsl:when><!--圣基茨和尼维斯-->
		<xsl:when test="$nationality='KR'">KOR</xsl:when><!--韩国-->
		<xsl:when test="$nationality='KW'">KWT</xsl:when><!--科威特-->
		<xsl:when test="$nationality='LA'">LAO</xsl:when><!--老挝-->
		<xsl:when test="$nationality='LB'">LBN</xsl:when><!--黎巴嫩-->
		<xsl:when test="$nationality='LR'">LBR</xsl:when><!--利比里亚-->
		<xsl:when test="$nationality='LY'">LBY</xsl:when><!--利比亚-->
		<xsl:when test="$nationality='SQ'">LCA</xsl:when><!--圣卢西亚-->
		<xsl:when test="$nationality='LI'">LIE</xsl:when><!--列支敦士登-->
		<xsl:when test="$nationality='LK'">LKA</xsl:when><!--斯里兰卡-->
		<xsl:when test="$nationality='LS'">LSO</xsl:when><!--莱索托-->
		<xsl:when test="$nationality='LT'">LTU</xsl:when><!--立陶宛-->
		<xsl:when test="$nationality='LU'">LUX</xsl:when><!--卢森堡-->
		<xsl:when test="$nationality='LV'">LVA</xsl:when><!--拉脱维亚-->
		<xsl:when test="$nationality='CHN'">MAC</xsl:when><!--澳门-->
		<xsl:when test="$nationality='MA'">MAR</xsl:when><!--摩洛哥-->
		<xsl:when test="$nationality='MC'">MCO</xsl:when><!--摩纳哥-->
		<xsl:when test="$nationality='MD'">MDA</xsl:when><!--摩尔多瓦-->
		<xsl:when test="$nationality='MG'">MDG</xsl:when><!--马达加斯加-->
		<xsl:when test="$nationality='MV'">MDV</xsl:when><!--马尔代夫-->
		<xsl:when test="$nationality='MX'">MEX</xsl:when><!--墨西哥-->
		<xsl:when test="$nationality='MH'">MHL</xsl:when><!--马绍尔群岛-->
		<xsl:when test="$nationality='MK'">MKD</xsl:when><!--马斯顿-->
		<xsl:when test="$nationality='ML'">MLI</xsl:when><!--马里-->
		<xsl:when test="$nationality='MT'">MLT</xsl:when><!--马耳他-->
		<xsl:when test="$nationality='MM'">MMR</xsl:when><!--缅甸-->
		<xsl:when test="$nationality='MN'">MNG</xsl:when><!--蒙古-->
		<xsl:when test="$nationality='MP'">MNP</xsl:when><!--北马里亚纳-->
		<xsl:when test="$nationality='MZ'">MOZ</xsl:when><!--莫桑比克-->
		<xsl:when test="$nationality='MR'">MRT</xsl:when><!--毛里塔尼亚-->
		<xsl:when test="$nationality='MS'">MSR</xsl:when><!--蒙特塞拉特-->
		<xsl:when test="$nationality='MQ'">MTQ</xsl:when><!--马提尼克-->
		<xsl:when test="$nationality='MU'">MUS</xsl:when><!--毛里求斯-->
		<xsl:when test="$nationality='MW'">MWI</xsl:when><!--马拉维-->
		<xsl:when test="$nationality='MY'">MYS</xsl:when><!--马来西亚-->
		<xsl:when test="$nationality='YT'">MYT</xsl:when><!--马约特-->
		<xsl:when test="$nationality='NA'">NAM</xsl:when><!--纳米比亚-->
		<xsl:when test="$nationality='NC'">NCL</xsl:when><!--新喀里多尼亚-->
		<xsl:when test="$nationality='NE'">NER</xsl:when><!--尼日尔-->
		<xsl:when test="$nationality='NF'">NFK</xsl:when><!--诺福克岛-->
		<xsl:when test="$nationality='NG'">NGA</xsl:when><!--尼日利亚-->
		<xsl:when test="$nationality='NI'">NIC</xsl:when><!--尼加拉瓜-->
		<xsl:when test="$nationality='NU'">NIU</xsl:when><!--纽埃-->
		<xsl:when test="$nationality='NL'">NLD</xsl:when><!--荷兰-->
		<xsl:when test="$nationality='NO'">NOR</xsl:when><!--挪威-->
		<xsl:when test="$nationality='NP'">NPL</xsl:when><!--尼泊尔-->
		<xsl:when test="$nationality='NR'">NRU</xsl:when><!--瑙鲁-->
		<xsl:when test="$nationality='NZ'">NZL</xsl:when><!--新西兰-->
		<xsl:when test="$nationality='OM'">OMN</xsl:when><!--阿曼-->
		<xsl:when test="$nationality='PK'">PAK</xsl:when><!--巴基斯坦-->
		<xsl:when test="$nationality='PA'">PAN</xsl:when><!--巴拿马-->
		<xsl:when test="$nationality='OTH'">PCN</xsl:when><!--皮特凯恩群岛-->
		<xsl:when test="$nationality='PE'">PER</xsl:when><!--秘鲁-->
		<xsl:when test="$nationality='PH'">PHL</xsl:when><!--菲律宾-->
		<xsl:when test="$nationality='PW'">PLW</xsl:when><!--帕劳-->
		<xsl:when test="$nationality='PG'">PNG</xsl:when><!--巴布亚新几内亚-->
		<xsl:when test="$nationality='PL'">POL</xsl:when><!--波兰-->
		<xsl:when test="$nationality='PR'">PRI</xsl:when><!--波多黎各-->
		<xsl:when test="$nationality='KP'">PRK</xsl:when><!--朝鲜-->
		<xsl:when test="$nationality='PT'">PRT</xsl:when><!--葡萄牙-->
		<xsl:when test="$nationality='PY'">PRY</xsl:when><!--巴拉圭-->
		<xsl:when test="$nationality='OTH'">PSE</xsl:when><!--巴勒斯坦-->
		<xsl:when test="$nationality='PF'">PYF</xsl:when><!--法属波利尼西亚-->
		<xsl:when test="$nationality='QA'">QAT</xsl:when><!--卡塔尔-->
		<xsl:when test="$nationality='RE'">REU</xsl:when><!--留尼汪-->
		<xsl:when test="$nationality='RO'">ROM</xsl:when><!--罗马尼亚-->
		<xsl:when test="$nationality='RU'">RUS</xsl:when><!--俄罗斯-->
		<xsl:when test="$nationality='RW'">RWA</xsl:when><!--卢旺达-->
		<xsl:when test="$nationality='SA'">SAU</xsl:when><!--沙特阿拉伯-->
		<xsl:when test="$nationality='OTH'">SCG</xsl:when><!--塞尔维亚和黑山-->
		<xsl:when test="$nationality='SD'">SDN</xsl:when><!--苏丹-->
		<xsl:when test="$nationality='SN'">SEN</xsl:when><!--塞内加尔-->
		<xsl:when test="$nationality='SG'">SGP</xsl:when><!--新加坡-->
		<xsl:when test="$nationality='OTH'">SGS</xsl:when><!--南乔治亚岛和南桑德韦奇岛-->
		<xsl:when test="$nationality='OTH'">SHN</xsl:when><!--圣赫勒拿-->
		<xsl:when test="$nationality='OTH'">SJM</xsl:when><!--斯瓦尔巴群岛和扬马群岛-->
		<xsl:when test="$nationality='SB'">SLB</xsl:when><!--所罗门群岛-->
		<xsl:when test="$nationality='SL'">SLE</xsl:when><!--塞拉利昂-->
		<xsl:when test="$nationality='SV'">SLV</xsl:when><!--萨尔瓦多-->
		<xsl:when test="$nationality='SM'">SMR</xsl:when><!--圣马力诺-->
		<xsl:when test="$nationality='SO'">SOM</xsl:when><!--索马里-->
		<xsl:when test="$nationality='OTH'">SPM</xsl:when><!--圣皮埃尔和密克隆-->
		<xsl:when test="$nationality='ST'">STP</xsl:when><!--圣多美和普林西比-->
		<xsl:when test="$nationality='SR'">SUR</xsl:when><!--苏里南-->
		<xsl:when test="$nationality='SK'">SVK</xsl:when><!--斯洛伐克-->
		<xsl:when test="$nationality='SI'">SVN</xsl:when><!--斯洛文尼亚-->
		<xsl:when test="$nationality='SE'">SWE</xsl:when><!--瑞典-->
		<xsl:when test="$nationality='SZ'">SWZ</xsl:when><!--斯威士兰-->
		<xsl:when test="$nationality='SC'">SYC</xsl:when><!--塞舌尔-->
		<xsl:when test="$nationality='SY'">SYR</xsl:when><!--叙利亚-->
		<xsl:when test="$nationality='TC'">TCA</xsl:when><!--特克斯和凯科斯群岛-->
		<xsl:when test="$nationality='TD'">TCD</xsl:when><!--乍得-->
		<xsl:when test="$nationality='TG'">TGO</xsl:when><!--多哥-->
		<xsl:when test="$nationality='TH'">THA</xsl:when><!--泰国-->
		<xsl:when test="$nationality='TJ'">TJK</xsl:when><!--塔吉克斯坦-->
		<xsl:when test="$nationality='OTH'">TKL</xsl:when><!--托克劳-->
		<xsl:when test="$nationality='TM'">TKM</xsl:when><!--土库曼斯坦-->
		<xsl:when test="$nationality='OTH'">TMP</xsl:when><!--东帝汶-->
		<xsl:when test="$nationality='TO'">TON</xsl:when><!--汤加-->
		<xsl:when test="$nationality='TT'">TTO</xsl:when><!--特立尼达和多巴哥-->
		<xsl:when test="$nationality='TN'">TUN</xsl:when><!--突尼斯-->
		<xsl:when test="$nationality='TR'">TUR</xsl:when><!--土耳其-->
		<xsl:when test="$nationality='TV'">TUV</xsl:when><!--图瓦卢-->
		<xsl:when test="$nationality='CHN'">TWN</xsl:when><!--中国台湾-->
		<xsl:when test="$nationality='TZ'">TZA</xsl:when><!--坦桑尼亚-->
		<xsl:when test="$nationality='UG'">UGA</xsl:when><!--乌干达-->
		<xsl:when test="$nationality='UA'">UKR</xsl:when><!--乌克兰-->
		<xsl:when test="$nationality='OTH'">UMI</xsl:when><!--美属本土外小岛屿-->
		<xsl:when test="$nationality='UY'">URY</xsl:when><!--乌拉圭-->
		<xsl:when test="$nationality='US'">USA</xsl:when><!--美国-->
		<xsl:when test="$nationality='UZ'">UZB</xsl:when><!--乌兹别克斯坦-->
		<xsl:when test="$nationality='OTH'">VAT</xsl:when><!--梵蒂冈-->
		<xsl:when test="$nationality='VC'">VCT</xsl:when><!--圣文森特和格林纳丁斯-->
		<xsl:when test="$nationality='VE'">VEN</xsl:when><!--委内瑞拉-->
		<xsl:when test="$nationality='VG'">VGB</xsl:when><!--英属维尔京群岛-->
		<xsl:when test="$nationality='VI'">VIR</xsl:when><!--美属维尔京群岛-->
		<xsl:when test="$nationality='VN'">VNM</xsl:when><!--越南-->
		<xsl:when test="$nationality='VU'">VUT</xsl:when><!--瓦努阿图-->
		<xsl:when test="$nationality='OTH'">WLF</xsl:when><!--瓦利斯和富图纳群岛-->
		<xsl:when test="$nationality='WS'">WSM</xsl:when><!--西萨摩亚-->
		<xsl:when test="$nationality='YE'">YEM</xsl:when><!--也门-->
		<xsl:when test="$nationality='ZA'">ZAF</xsl:when><!--南非-->
		<xsl:when test="$nationality='OTH'">ZAR</xsl:when><!--扎伊尔-->
		<xsl:when test="$nationality='ZM'">ZMB</xsl:when><!--赞比亚-->
		<xsl:when test="$nationality='ZW'">ZWE</xsl:when><!--津巴布韦-->
		<xsl:when test="$nationality='OTH'">OTH</xsl:when><!--其他-->
</xsl:choose>
</xsl:template>
<!-- 关系 -->
<xsl:template name="tran_RelationRoleCode">
<xsl:param name="relationRoleCode" />
<xsl:choose>
	<xsl:when test="$relationRoleCode=00">00</xsl:when>	<!-- 本人 -->
	<xsl:when test="$relationRoleCode=01">01</xsl:when>	<!-- 父母 -->
	<xsl:when test="$relationRoleCode=03">02</xsl:when>	<!-- 子女 -->
	<xsl:when test="$relationRoleCode=02">03</xsl:when>	<!-- 配偶 -->  
	<xsl:when test="$relationRoleCode=04">04</xsl:when>	<!-- 其他 -->
</xsl:choose>
</xsl:template>

<!-- paymode -->
<xsl:template name="tran_PayMode">
<xsl:param name="payMode" />
<xsl:choose>
	<xsl:when test="$payMode=1">1</xsl:when>	<!-- 现金 -->
	<xsl:when test="$payMode=7">2</xsl:when>	<!-- 银行转账 -->
	
</xsl:choose>
</xsl:template>

<!-- 受益人关系 -->
<xsl:template name="tran_RelationToInsured">
<xsl:param name="relationToInsured" />
<xsl:choose>
	<xsl:when test="$relationToInsured=00">00</xsl:when> <!-- 本人 -->
	<xsl:when test="$relationToInsured=01">1</xsl:when> <!-- 此处有问题，此处是核心返回的代码，而银保通与银行的映射关系是1对多 -->
	<xsl:when test="$relationToInsured=03">3</xsl:when> <!-- 此处有问题，此处是核心返回的代码，而银保通与银行的映射关系是1对多 -->
	<xsl:when test="$relationToInsured=02">7</xsl:when> <!-- 配偶 -->
	<xsl:when test="$relationToInsured=05">21</xsl:when> <!-- 雇佣 -->
	<xsl:when test="$relationToInsured=04">22</xsl:when> <!-- 其他 -->
</xsl:choose>
</xsl:template>

<!-- 险种代码，该文件并未使用转换，只是记录以上线的险种 -->
<xsl:template name="tran_RiskCode">
	<xsl:param name="riskCode" />
	<xsl:choose>
		<xsl:when test="$riskCode='122046'">50002</xsl:when><!-- 安邦长寿稳赢保险计划 -->			
		<xsl:when test="$riskCode='L12078'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskCode='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
		<xsl:when test="$riskCode='L12079'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型） -->
		<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型） -->
		<xsl:when test="$riskCode='L12074'">L12074</xsl:when><!-- 安邦盛世9号终身寿险（万能型） -->
		<xsl:when test="$riskCode='L12091'">L12091</xsl:when><!-- 安邦汇赢1号年金保险A款 -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
