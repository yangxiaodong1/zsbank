<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:variable name="InsuredSex" select="/TranData/Insured/Sex"/>
	<xsl:template match="/TranData">
		<RETURN>
			<!-- 报文头 -->
			<xsl:copy-of select="Head" />
			
			<!-- 报文体 -->
			<xsl:if test="Head/Flag='0'">
				<xsl:apply-templates select="Body" />
			</xsl:if>
			<xsl:if test="Head/Flag='1'">
				<MAIN />
			</xsl:if>
		</RETURN>
	</xsl:template>

	<!-- 报文体 -->
	<xsl:template name="TRAN_BODY" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<MAIN>
			
			<!-- 保险单号 -->
			<POLICY_NO><xsl:value-of select="ContNo" /></POLICY_NO>
			<TOT_PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></TOT_PREM>
			<!-- 首期保费 -->
			<INIT_PREM_AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></INIT_PREM_AMT>
			<!-- 首期保费, 大写 -->
			<INIT_PREM_TXT><xsl:value-of select="ActSumPremText" /></INIT_PREM_TXT>
			<!-- 生效日期 -->
			<VALIDATE><xsl:value-of select="$MainRisk/CValiDate" /></VALIDATE>
			<CONTENDDATE><xsl:value-of select="$MainRisk/PolApplyDate" /></CONTENDDATE>
			<!-- 承保公司 -->
			<ORGAN><xsl:value-of select="ComName" /></ORGAN>
			<!-- 公司地址 -->
			<LOC><xsl:value-of select="ComLocation" /></LOC>
			<!-- 公司电话 -->
			<TEL>95569</TEL>
			<!-- 页数 -->
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- 如果有现金价值显示2页 -->
				<TOTALPAGE>2</TOTALPAGE>
			</xsl:if>
			<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- 如果没有现金价值显示1页 -->
				<TOTALPAGE>1</TOTALPAGE>
			</xsl:if>
		</MAIN>

		<xsl:variable name="RiskCount" select="count(Risk)"/>
		<xsl:variable name="ProductCode" select="$MainRisk/RiskCode" />
			
		<Prnts>
			<Type>8</Type>	<!-- 保险单  打印类型节点，保单Type=8、现金价值Type=9-->
			<Count></Count>
			<Page>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value><xsl:text>保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                币值单位：人民币元</xsl:text></Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>
					<xsl:text>投保人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 33)" />
					<xsl:text>证件类型：</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Appnt/IDType" /></xsl:call-template>
					<xsl:text>      证件号码：</xsl:text><xsl:value-of select="Appnt/IDNo" />
				</Value></Prnt>
				<Prnt><Value>
					<xsl:text>被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 30)" />
					<xsl:text>证件类型：</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Insured/IDType" /></xsl:call-template>
					<xsl:text>      证件号码：</xsl:text><xsl:value-of select="Insured/IDNo" />
				</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<xsl:if test="count(Bnf) = 0">
				<Prnt><Value><xsl:text>身故受益人：法定                </xsl:text>
						   <xsl:text>受益顺序：1                   </xsl:text>
						   <xsl:text>受益比例：100%</xsl:text></Value></Prnt>
				</xsl:if>
				<xsl:if test="count(Bnf)>0">
				<xsl:for-each select="Bnf">
				<Prnt><Value>
					<xsl:text>身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
					<xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
					<xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
				</Value></Prnt>
				</xsl:for-each>
				</xsl:if>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>险种资料</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value><xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　基本保险金额\</xsl:text></Value></Prnt>
				<Prnt><Value><xsl:text>　　　　　　　险种名称               保险期间    交费年期     日津贴额\     保险费     交费频率</xsl:text></Value></Prnt>
				<Prnt><Value><xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　份数\档次</xsl:text></Value></Prnt>
								<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>			
						<Prnt><Value><xsl:text></xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
							<xsl:choose>
								<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 9)"/>
								</xsl:when>
								<xsl:when test="InsuYearFlag = 'Y'">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 9)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 9)"/>
									<xsl:text></xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="PayIntv = 0">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('  1年', 14)"/>
								</xsl:when>
								<xsl:when test="PayEndYearFlag = 'Y'">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 14)"/>
								</xsl:when>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('保单帐户价值',13)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,14)"/>
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
						</Value></Prnt>						
				</xsl:for-each>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>保险费合计：<xsl:value-of select="ActSumPremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>元整）</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<Prnt><Value>保险单特别约定：</Value></Prnt>
				<xsl:choose>
					<xsl:when test="$SpecContent=''">
						<Prnt><Value><xsl:text>（无）</xsl:text></Value></Prnt>
					</xsl:when>
					<xsl:otherwise>
						<Prnt><Value>   《安邦长寿安享5号年金保险计划》由主险《安邦长寿安享5号年金保险》及附加险《安邦附加长寿</Value></Prnt>
						<Prnt><Value>添利5号两全保险（万能型）》组成。经生存年金受益人同意后，主险产品的生存年金，在年金给付日</Value></Prnt>
						<Prnt><Value>自动转入附加险万能账户中，享受日日复利，月月结息的资金增值服务。</Value></Prnt>
					</xsl:otherwise>
				</xsl:choose>
				<Prnt><Value>--------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value><xsl:text>保险合同成立日期：</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy年MM月dd日')"/><xsl:text>                             保险合同生效日期：</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy年MM月dd日')"/></Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value><xsl:text>营业机构：</xsl:text><xsl:value-of select="ComName" /></Value></Prnt>
			    <Prnt><Value><xsl:text>营业地址：</xsl:text><xsl:value-of select="ComLocation" /></Value></Prnt>
				<Prnt><Value><xsl:text>客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></Value></Prnt>
				<Prnt><Value>　</Value></Prnt>
				<Prnt><Value><xsl:text>为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保</xsl:text></Value></Prnt>
				<Prnt><Value><xsl:text>险期限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></Value></Prnt>
				<Prnt/>
				<Prnt><Value><xsl:text>银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>业务许可证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode,0)"/></Value></Prnt>
				<Prnt><Value><xsl:text>银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,48)"/><xsl:text> 从业资格证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode,0)"/></Value></Prnt>
				<Prnt><Value><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></Value></Prnt>
			</Page>
		</Prnts>
		<!-- 现金价值页打印 -->
		<xsl:variable name="CashValueCount" select="count($MainRisk/CashValues/CashValue)"/>
		<xsl:variable name="CashValueDiv" select="$CashValueCount div 2"/>
		<xsl:variable name="CashValueDiv2" select="floor($CashValueDiv)+2"/>
		<Messages>
			<Type>9</Type>  <!-- 现金价值表   打印类型节点，保单Type=8、现金价值Type=9 -->
			<Count></Count>
			<Page>
				<Message><xsl:text>　　　                                        </xsl:text>现金价值表</Message>
				<Message><Value>　</Value></Message>
				<Message><Value>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </Value></Message>
				<Message><Value>　　　-------------------------------------------------------------------------------------------------------------------------</Value></Message>
				<Message><Value><xsl:text>　　　被保险人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name,44)"/><xsl:text>险种名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName, 0)"/></Value></Message>
		        <Message><Value><xsl:text/>　　　保单年度末<xsl:text>       </xsl:text>
				   <xsl:text>       现金价值</xsl:text><xsl:text/>　　　　　       保单年度末<xsl:text>    </xsl:text>
				   <xsl:text>       现金价值</xsl:text></Value></Message>
		   	       <xsl:variable name='n' select='$CashValueDiv2'/>
			    <xsl:for-each select='$MainRisk/CashValues/CashValue'>
			    <xsl:variable name='n2' select='position()+($CashValueDiv2)-1'/>
                   <xsl:if test='position() &lt; $n'>
                     <Message><Value><xsl:text/><xsl:text>　　　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(position(),''),8)"/><xsl:text>　　　　　 </xsl:text>
                     <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(./Cash), '元'),36)"/>   
                     <xsl:if test='../CashValue[$n2]/Cash &gt; 0  or ../CashValue[$n2]/Cash = 0'><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($n2,''),8)"/><xsl:text>　　　　 </xsl:text>
                     <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../CashValue[$n2]/Cash), '元'),0)"/></xsl:if></Value></Message>
                   </xsl:if>
				</xsl:for-each> 
				<Message><Value>　　　-------------------------------------------------------------------------------------------------------------------------</Value></Message>
				<Message><Value>　</Value></Message>
				<Message><Value>　　　备注：</Value></Message>
				<Message><Value>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</Value></Message>
				<Message><Value>　　　-------------------------------------------------------------------------------------------------------------------------</Value></Message>
			</Page>
		
		</Messages>
	</xsl:template>

	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template name="tran_IDName">
		<xsl:param name="idName" />
		<xsl:choose>
			<xsl:when test="$idName='0'">身份证  </xsl:when>
			<xsl:when test="$idName='1'">护照    </xsl:when>
			<xsl:when test="$idName='2'">军官证  </xsl:when>
			<xsl:when test="$idName='3'">驾照    </xsl:when>
			<xsl:when test="$idName='4'">出生证明</xsl:when>
			<xsl:when test="$idName='5'">户口簿  </xsl:when>
			<xsl:when test="$idName='6'">港澳回乡证</xsl:when>
			<xsl:when test="$idName='7'">台胞证  </xsl:when>
			<xsl:when test="$idName='8'">其他    </xsl:when>
			<xsl:when test="$idName='9'">异常身份证</xsl:when>
			<xsl:otherwise>其他    </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
