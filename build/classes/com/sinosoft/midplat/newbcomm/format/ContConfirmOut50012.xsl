<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Rsp>
	<xsl:apply-templates select="TranData/Head"/>
	<xsl:apply-templates select="TranData/Body"/>
</Rsp>
</xsl:template>

<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0表示成功，1表示失败 ，3转非实时-->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- 失败时，返回错误信息 -->
		</Head>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
<Body>
	<PolItem>
		<xsl:variable name="MainRisk1" select="Risk[RiskCode=MainRiskCode]"/>
		<!-- 保单号 -->
		<PolNo><xsl:value-of select="ContNo" /></PolNo>
		<!-- 保单状态:已缴费并核保 -->
		<PolStat>1</PolStat>
		<!-- 缴费金额 -->
		<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PayAmt>
		<!-- 承保日期 -->
		<AcceptDate><xsl:value-of select="$MainRisk1/PolApplyDate" /></AcceptDate>
		<!-- 生效日期 -->
		<ValiDate><xsl:value-of select="$MainRisk1/CValiDate" /></ValiDate>
		<!-- 终止日期 -->
		<xsl:choose>
			<xsl:when test="$MainRisk1/InsuYearFlag='A' and $MainRisk1/InsuYear=106">
				<InvaliDate>99991231</InvaliDate>
			</xsl:when>
			<xsl:otherwise>
				<InvaliDate><xsl:value-of select="$MainRisk1/InsuEndDate" /></InvaliDate>
			</xsl:otherwise>
		</xsl:choose>	
		<!-- 续期缴费日期 -->
		<TermDate></TermDate>				
	</PolItem>
	<!-- 若为柜面，则需要打印保单 -->
	<NoteList />
	<PrtList>
		<Count>1</Count>
		<PrtItem>
			<VchId>1</VchId>
			<xsl:variable name="RiskName" select="ContPlan/ContPlanName" />
			<!-- 当前凭证的提示文本:待业务提供 -->
			<VchInfo><xsl:value-of select="$RiskName" />空白保单，每张保单一式三联，打印客户联，复写业务联和银行联</VchInfo>
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<Count>2</Count>			
			<PageItem>
				<PageId>1</PageId>
				<!-- 打印本页前，提示柜员准备换页处理:待业务提供 -->
				<PageInfo>第一页/共二页</PageInfo>			
				<!-- 当前页的总行数，每页最大支持70行 -->
				<Count></Count>							
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" />
<xsl:text>                                           币值单位：人民币元</xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>　　　投保人：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 33)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>       证件号码：</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>　　　被保险人：</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>证件类型：</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>       证件号码：</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<xsl:if test="count(Bnf) = 0">
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　身故受益人：法定                </xsl:text>
				   <xsl:text>受益顺序：1                   </xsl:text>
				   <xsl:text>受益比例：100%</xsl:text></RowText>
				<Remark></Remark></RowItem>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<RowItem><RowId></RowId>
					<RowText>
							<xsl:text>　　　身故受益人：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>受益顺序：</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>受益比例：</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</RowText>
				<Remark></Remark></RowItem>
					</xsl:for-each>
				</xsl:if>
				<RowItem><RowId></RowId>
					<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				
				<RowItem><RowId></RowId>
					<RowText>　　　险种资料</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　基本保险金额\</xsl:text>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>　　　　　　　　　　险种名称               保险期间    交费年期     日津贴额\     保险费     交费频率</xsl:text>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　份数\档次</xsl:text>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<RowItem><RowId></RowId>
					<RowText>
						<xsl:text>　　　</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
							</xsl:when>
							<xsl:when test="InsuYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
							</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 11)"/>
							<xsl:text/>
						</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PayIntv = 0">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次交清', 11)"/>
							</xsl:when>
							<xsl:when test="PayEndYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 11)"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('保单帐户价值',14)"/>
							</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
						</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
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
					</RowText>
				<Remark></Remark></RowItem>
				</xsl:for-each>
				<RowItem><RowId></RowId>
					<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>　　　保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<RowItem><RowId></RowId>
					<RowText>　　　保险单特别约定：</RowText>
				<Remark></Remark></RowItem>
					<xsl:choose>
						<xsl:when test="$SpecContent=''">
							<RowItem><RowId></RowId>
					<RowText><xsl:text>（无）</xsl:text></RowText>
				<Remark></Remark></RowItem>
						</xsl:when>
						<xsl:otherwise>
							<RowItem><RowId></RowId>
					<RowText>　　　    《安邦长寿安享5号年金保险计划》由主险《安邦长寿安享5号年金保险》及附加险《安邦附加长寿添利</RowText>
				<Remark></Remark></RowItem>
							<RowItem><RowId></RowId>
					<RowText>　　　5号两全保险（万能型）》组成。经生存年金受益人同意后，主险产品的生存年金，在年金给付日自动转入</RowText>
				<Remark></Remark></RowItem>
							<RowItem><RowId></RowId>
					<RowText>　　　附加险万能账户中，享受日日复利，月月结息的资金增值服务。</RowText>
				<Remark></Remark></RowItem>
						</xsl:otherwise>
					</xsl:choose>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>　　　-------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></RowText>
				<Remark></Remark></RowItem>
			
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></RowText>
				<Remark></Remark></RowItem>
				
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName,49)"/></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 45)"/></RowText>
				<Remark></Remark></RowItem>		
			</PageItem>
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- 当有现金价值时，打印现金价值 -->
				<xsl:variable name="RiskCount" select="count(Risk)"/>
				<PageItem>
					<PageId>2</PageId>
					<!-- 打印本页前，提示柜员准备换页处理:待业务提供 -->
					<PageInfo>第二页/共二页</PageInfo>			
					<!-- 当前页的总行数，每页最大支持70行 -->
					<Count></Count>
					<RowItem><RowId></RowId>
						<RowText><xsl:text> </xsl:text></RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text>　　　                                        </xsl:text>现金价值表</RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text>　　　被保险人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name,44)"/><xsl:text>险种名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName, 0)"/></RowText>
						<Remark></Remark></RowItem>	
			        <RowItem><RowId></RowId>
							<RowText><xsl:text/>　　　保单年度末<xsl:text>       </xsl:text>
					   <xsl:text>       现金价值</xsl:text><xsl:text/>　　　　　       保单年度末<xsl:text>    </xsl:text>
					   <xsl:text>       现金价值</xsl:text></RowText>
						<Remark></Remark></RowItem>
				   	<xsl:variable name="EndYear" select="EndYear"/>
					   <RowItem><RowId></RowId>
								<RowText><xsl:text/><xsl:text>　　　　　 </xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('1',20)"/>
												<xsl:variable name="Cash1" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[1]/Cash)"/>
												<xsl:variable name="Cash1a" select="concat($Cash1,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash1a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(' 9',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[9]/Cash)"/>元</RowText>
							<Remark></Remark></RowItem>
					   <RowItem><RowId></RowId>
								<RowText><xsl:text/><xsl:text>　　　　　 </xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('2',20)"/>
												<xsl:variable name="Cash2" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[2]/Cash)"/>
												<xsl:variable name="Cash2a" select="concat($Cash2,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash2a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('10',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[10]/Cash)"/>元</RowText>
							<Remark></Remark></RowItem>
					   <RowItem><RowId></RowId>
								<RowText><xsl:text/><xsl:text>　　　　　 </xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('3',20)"/>
												<xsl:variable name="Cash3" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[3]/Cash)"/>
												<xsl:variable name="Cash3a" select="concat($Cash3,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash3a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('11',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[11]/Cash)"/>元</RowText>
							<Remark></Remark></RowItem>
					   <RowItem><RowId></RowId>
								<RowText><xsl:text/><xsl:text>　　　　　 </xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('4',20)"/>
												<xsl:variable name="Cash4" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[4]/Cash)"/>
												<xsl:variable name="Cash4a" select="concat($Cash4,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash4a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('12',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[12]/Cash)"/>元</RowText>
							<Remark></Remark></RowItem>
					   <RowItem><RowId></RowId>
								<RowText><xsl:text/><xsl:text>　　　　　 </xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('5',20)"/>
												<xsl:variable name="Cash5" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[5]/Cash)"/>
												<xsl:variable name="Cash5a" select="concat($Cash5,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash5a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('13',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[13]/Cash)"/>元</RowText>
							<Remark></Remark></RowItem>
					   <RowItem><RowId></RowId>
								<RowText><xsl:text/><xsl:text>　　　　　 </xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('6',20)"/>
												<xsl:variable name="Cash6" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[6]/Cash)"/>
												<xsl:variable name="Cash6a" select="concat($Cash6,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash6a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('14',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[14]/Cash)"/>元</RowText>
							<Remark></Remark></RowItem>
					   <RowItem><RowId></RowId>
								<RowText><xsl:text/><xsl:text>　　　　　 </xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('7',20)"/>
												<xsl:variable name="Cash7" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[7]/Cash)"/>
												<xsl:variable name="Cash7a" select="concat($Cash7,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash7a,10)"/><xsl:text>　　　　　        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('15',18)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[15]/Cash)"/>元</RowText>
							<Remark></Remark></RowItem>
					   <RowItem><RowId></RowId>
								<RowText><xsl:text/><xsl:text>　　　　　 </xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('8',20)"/>
												<xsl:variable name="Cash8" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[8]/Cash)"/>
												<xsl:variable name="Cash8a" select="concat($Cash8,'元')"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash8a,10)"/></RowText>
							<Remark></Remark></RowItem>
			
						<RowItem><RowId></RowId>
								<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
							<Remark></Remark></RowItem>
						<RowItem><RowId></RowId>
								<RowText><xsl:text> </xsl:text></RowText>
							<Remark></Remark></RowItem>
						<RowItem><RowId></RowId>
								<RowText>　　　备注：</RowText>
							<Remark></Remark></RowItem>
						<RowItem><RowId></RowId>
								<RowText>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</RowText>
							<Remark></Remark></RowItem>
						<RowItem><RowId></RowId>
								<RowText>　　　------------------------------------------------------------------------------------------------</RowText>
						<Remark></Remark></RowItem>				
				</PageItem>
			</xsl:if>
		</PrtItem>
	</PrtList>	
</Body>
</xsl:template>
	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">身份证    </xsl:when>
			<xsl:when test=".=1">护照      </xsl:when>
			<xsl:when test=".=2">军官证    </xsl:when>
			<xsl:when test=".=3">驾照      </xsl:when>
			<xsl:when test=".=4">出生证明  </xsl:when>
			<xsl:when test=".=5">户口簿    </xsl:when>
			<xsl:when test=".=8">其他      </xsl:when>
			<xsl:when test=".=9">异常身份证</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 缴费间隔  -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=0">一次交清</xsl:when>
			<xsl:when test=".=1">月交</xsl:when>
			<xsl:when test=".=3">季交</xsl:when>
			<xsl:when test=".=6">半年交</xsl:when>
			<xsl:when test=".=12">年交</xsl:when>
			<xsl:when test=".=-1">不定期交</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 性别【注意：“男     ”空格排版用的，不能去掉】-->
	<xsl:template match="Sex">
		<xsl:choose>
			<xsl:when test=".=0">男</xsl:when>
			<xsl:when test=".=1">女</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 红利领取  -->
	<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
		<xsl:choose>
			<xsl:when test=".=1">累计生息</xsl:when>
			<xsl:when test=".=2">领取现金</xsl:when>
			<xsl:when test=".=3">抵缴保费</xsl:when>
			<xsl:when test=".=5">增额交清</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>