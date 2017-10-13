<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
<RETURN>
	 <MAIN>
	 	<!--������-->
	 	<RESULTCODE>
	 		<xsl:apply-templates select="Head/Flag" />
	 	</RESULTCODE>
	 	<!--��������-->
	 	<ERR_INFO>
	 		<xsl:value-of select="Head/Desc" />
	 	</ERR_INFO>
	 	<!-- ������׳ɹ����ŷ�������Ľ�� -->
		<xsl:if test="Head/Flag='0'">
	 	<!--Ͷ������-->
	 	<APPLNO>
	 		<xsl:value-of select="Body/ProposalPrtNo" />
	 	</APPLNO>
	 	<!--������( ���ձ��պ�ͬ��)-->
	 	<POLICY>
	 		<xsl:value-of select="Body/ContNo" />
	 	</POLICY>
	 	<!--Ͷ�����ڣ�CD01��-->
	 	<ACCEPT>
	 		<xsl:value-of select="Body/Risk/PolApplyDate" />
	 	</ACCEPT>
	 	<!--���ڱ��ѣ�CD23��-->
	 	<PREM>
	 		<xsl:value-of select="Body/Prem" />
	 	</PREM>
	 	<!--���ڱ��Ѵ�д-->
	 	<xsl:variable name="SumPremYuan"
	 		select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" />
	 	<PREMC>
	 		<xsl:value-of
	 			select="java:com.sinosoft.midplat.common.NumberUtil.money2CN(Body/Prem)" />
	 	</PREMC>
	 	<!--������Ч���ڣ�CD01��-->
	 	<VALIDATE>
	 		<xsl:value-of select="Body/Risk/CValiDate" />
	 	</VALIDATE>
	 	<!--Ͷ��������-->
	 	<TBR_NAME>
	 		<xsl:value-of select="Body/Appnt/Name" />
	 	</TBR_NAME>
	 	<!--Ͷ���˿ͻ���-->
	 	<TBRPATRON>
	 		<xsl:value-of select="Body/Appnt/CustomerNo" />
	 	</TBRPATRON>
	 	<!--����������-->
	 	<BBR_NAME>
	 		<xsl:value-of select="Body/Insured/Name" />
	 	</BBR_NAME>
	 	<!--�����˿ͻ���-->
	 	<BBRPATRON>
	 		<xsl:value-of select="Body/Insured/CustomerNo" />
	 	</BBRPATRON>
	 	<!--�ɷѷ�ʽ��CD24��-->
	 	<xsl:variable name="PayIntv"
	 		select="Body/Risk[RiskCode=MainRiskCode]/PayIntv" />
	 	<PAYMETHOD>
	 		<xsl:call-template name="tran_PayIntv">
	 			<xsl:with-param name="PayIntv">
	 				<xsl:value-of select="$PayIntv" />
	 			</xsl:with-param>
	 		</xsl:call-template>
	 	</PAYMETHOD>
	 	<!--�ɷѷ�ʽ(����)-->
	 	<PAY_METHOD>
	 		<xsl:apply-templates select="$PayIntv" />
	 	</PAY_METHOD>
	 	<!--�ɷ����ڣ�CD01��-->
	 	<PAYDATE>
	 		<xsl:value-of select="Body/Risk/PolApplyDate" />
	 	</PAYDATE>
	 	<!--�б���˾����-->
	 	<ORGAN>
	 		<xsl:value-of select="Body/ComName" />
	 	</ORGAN>
	 	<!--�б���˾��ַ-->
	 	<LOC>
	 		<xsl:value-of select="Body/ComLocation" />
	 	</LOC>
	 	<!--�б���˾�绰-->
	 	<TEL>
	 		<xsl:value-of select="Body/ComPhone" />
	 	</TEL>
	 	<!--�ر�Լ����ӡ��־��CD25��-->
	 	<ASSUM>0</ASSUM>
	 	<!--Ͷ���˿ͻ����������ڣ�CD01��-->
	 	<TBR_OAC_DATE></TBR_OAC_DATE>
	 	<!--�����˿ͻ����������ڣ�CD01��-->
	 	<BBR_OAC_DATE></BBR_OAC_DATE>
	 	<!--�б���˾����-->
	 	<ORGANCODE>
	 		<xsl:value-of select="Body/ComCode" />
	 	</ORGANCODE>
	 	<!--���ڽɷ����ڣ�����������-->
	 	<PAYDATECHN></PAYDATECHN>
	 	<!--�ɷ���ֹ���ڣ�����������-->
	 	<PAYSEDATECHN></PAYSEDATECHN>
	 	<!--�ɷ�����-->
	 	<PAYYEAR></PAYYEAR>
	 	</xsl:if>
	 </MAIN>
	<!-- ������׳ɹ����ŷ�������Ľ�� -->
	<xsl:if test="Head/Flag='0'">
	 <!--������Ϣ-->
	<PTS>
	    <PT_COUNT><xsl:value-of select="count(Body/Risk)"/></PT_COUNT>
	    <xsl:for-each select= "Body/Risk">
	    <PT>
	        <xsl:variable name="ContEndDateText" select="java:com.sinosoft.midplat.common.DateUtil.formatTrans(InsuEndDate, 'yyyyMMdd', 'yyyy��MM��dd��')"/>
	        <xsl:variable name="RiskCode" select="RiskCode"/>
	        <xsl:variable name="MainRiskCode" select="MainRiskCode"/>
	        <POLICY><xsl:value-of select="../ContNo"/></POLICY>
	        <UNIT><xsl:value-of select="Mult"/></UNIT>
	        <xsl:if test="$RiskCode = $MainRiskCode">
		        <MAINSUBFLG>1</MAINSUBFLG>
		    </xsl:if>
	        <xsl:if test="$RiskCode != $MainRiskCode">
		        <MAINSUBFLG>0</MAINSUBFLG>
			</xsl:if>
	        <AMT><xsl:value-of select="Amnt"/></AMT>
	        <PREM><xsl:value-of select="Prem"/></PREM>
	        <NAME><xsl:value-of select="RiskName"/></NAME>
	        <PERIOD><xsl:value-of select="$ContEndDateText"/></PERIOD>
	        <INSUENDDATE><xsl:value-of select="$ContEndDateText"/></INSUENDDATE>
	        <INSUENDDATE_CPAI><xsl:value-of select="InsuEndDate"/></INSUENDDATE_CPAI>
	        <PAYENDDATE><xsl:value-of select="PayEndDate"/></PAYENDDATE>
	        <CHARGE_PERIOD>
	        	<xsl:call-template name="tran_PayEndYearFlag">
	        		<xsl:with-param name="payendyearflag">
	        			<xsl:value-of select="PayEndYearFlag" />
	        		</xsl:with-param>
	        		<xsl:with-param name="payendyear">
	        			<xsl:value-of select="PayEndYear" />
	        		</xsl:with-param>
	        	</xsl:call-template>
	        </CHARGE_PERIOD>
	        <CHARGE_YEAR><xsl:value-of select="PayEndYear"/></CHARGE_YEAR>
	    </PT>
	    </xsl:for-each>  
	</PTS>
	
	<!-- ��ӡ��Ϣ -->
	<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]" />
	<xsl:variable name="ProductCode" select="$MainRisk/RiskCode" />
	<PRT>
		<PRT_NUM>2</PRT_NUM>
	    <PRTS>
		<xsl:variable name="SumPremYuan" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/>
		<PRT_TYPE>1</PRT_TYPE>
	    <PRT_REC_NUM>0</PRT_REC_NUM>
	    <PRT_DETAIL>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="Body/ContNo" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE>
				<xsl:text>������Ͷ���ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Appnt/Name, 33)" />
				<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Body/Appnt/IDType" />
				<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Body/Appnt/IDNo" />
			</PRT_LINE>
			<PRT_LINE>
				<xsl:text>�������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Insured/Name, 31)" />
				<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Body/Insured/IDType" />
				<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Body/Insured/IDNo" />
			</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<xsl:if test="count(Body/Bnf) = 0">
			<PRT_LINE><xsl:text>��������������ˣ�����                </xsl:text>
					   <xsl:text>����˳��1                   </xsl:text>
					   <xsl:text>���������100%</xsl:text></PRT_LINE>
			</xsl:if>
			<xsl:if test="count(Body/Bnf)>0">
			<xsl:for-each select="Body/Bnf">
			<PRT_LINE>
				<xsl:text>��������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
				<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
				<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
			</PRT_LINE>
			</xsl:for-each>
			</xsl:if>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>��������������</PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE><xsl:text>��������������������                                            �������ս��\</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>����������������������������              �����ڼ�    ��������    �ս�����\      ���շ�    ����Ƶ��</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>��������������������                                              ����\����</xsl:text></PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<xsl:for-each select="Body/Risk">
			<xsl:variable name="PayIntv" select="PayIntv"/>
			<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
			<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
			<PRT_LINE><xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
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
			</PRT_LINE>
			</xsl:for-each>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>���������շѺϼƣ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/>Ԫ��Сд��</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>������<xsl:if test="Body/Risk[RiskCode=MainRiskCode]/RiskType=2">�ֺ챣�պ�����ȡ��ʽ���ۻ���Ϣ</xsl:if></PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<xsl:variable name="SpecContent" select="Body/Risk[RiskCode=MainRiskCode]/SpecContent"/>
			<PRT_LINE>���������յ��ر�Լ����<xsl:choose>
									<xsl:when test="$SpecContent=''">
										<xsl:text>���ޣ�</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$SpecContent"/>
									</xsl:otherwise>
								</xsl:choose></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE>
				<xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="Body/ComName" /></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="Body/ComLocation" /></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>�������ͻ��������ߣ�95569          ��ַ��http://www.anbang-life.com          �ٷ�΢�źţ�anbanglife</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ��΢�Ż򵽹�̨���в�ѯ����ʵ������Ϣ����</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>�������ڱ�������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/AgentComName, 49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/SellerNo, 0)"/></PRT_LINE>
		</PRT_DETAIL>
    </PRTS>
    <PRTS>
        <PRT_TYPE>2</PRT_TYPE>
        <PRT_REC_NUM>0</PRT_REC_NUM>
        <PRT_DETAIL>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>�������������������������������μ��������</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>������    �ȴ��ڣ����պ�ͬ��Ч�������Ч��֮����180�գ���180�յ�ʱ���Ϊ�ȴ��ڣ��ڱ��������򼲲���</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>�������ʻ�ȫ�У������������ѵ�105%�����պ�ͬ��ֹ�����������������˺�������ʻ�ȫ�У��޵ȴ��ڣ�������</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>������������ʻ�ȫ�б��ս𡱻򡰹�����ͨ������ʻ�ȫ�б��ս𡱵�Լ�������⸶��</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>������    ��ʻ�ȫ�б��ս𣺰��ձ��պ�ͬԼ���Ļ������ս����������պ�ͬ��ֹ��</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>������    ������ͨ������ʻ�ȫ�б��ս𣺰��ձ��պ�ͬԼ���Ļ������ս���3������߲������ѽ����շѺ�200��</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>������Ԫ֮�ͣ����������պ�ͬ��ֹ��</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>������    ���ڱ��ս𣺰��ձ��պ�ͬԼ���Ļ������ս����������պ�ͬ��ֹ��</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE><xsl:text>������    ÿ��������ȿɷ���˾�ľ�Ӫ�ɹ������б�������������ķֺ�����ɴӰ�������ÿ��������ȼ���</xsl:text></PRT_LINE>
			<PRT_LINE><xsl:text>�������ĺ���֪ͨ�顢������http://www.anbang-life.com����ٷ�΢�ţ�΢�ź�:anbanglife���в�ѯ��</xsl:text></PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE><xsl:text>������                                        </xsl:text>���������</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/ContNo, 60)"/>��ֵ��λ�������Ԫ </PRT_LINE>
			
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE>��������������������<xsl:value-of select="Body/Insured/Name"/></PRT_LINE>
		    <PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE><xsl:text>��������Ʒ���ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRT_LINE>
			<PRT_LINE><xsl:text/>�������������ĩ<xsl:text>                       </xsl:text><xsl:text>��������</xsl:text></PRT_LINE>
			   <xsl:for-each select="$MainRisk/CashValues/CashValue">
				 <xsl:variable name="EndYear" select="EndYear"/>
				   <PRT_LINE><xsl:text/><xsl:text>����������</xsl:text>
											<xsl:choose>
												<xsl:when test="$EndYear &lt; 5">
													<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,18)"/>
													<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),20)"/>
												</xsl:when>
												<xsl:when test="$EndYear = 5">
													<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,18)"/>
													<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(//Body/EFMoney), 'Ԫ'),20)"/>
												</xsl:when>
												<xsl:otherwise></xsl:otherwise>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="$EndYear=2">��������:</xsl:when>
												<xsl:when test="$EndYear=3">�����б��������⣬��ÿ��������Ȼ��ɷ���˾�ľ�Ӫ��</xsl:when>
												<xsl:when test="$EndYear=4">�������б���������</xsl:when>
												<xsl:otherwise></xsl:otherwise>
											</xsl:choose></PRT_LINE>
		       </xsl:for-each>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
			<PRT_LINE></PRT_LINE>
			<PRT_LINE>��������ע��</PRT_LINE>
			<PRT_LINE>������1.��1-4���������ĩ���б���������ֵΪ�������ֽ��ֵ���Ƕ�Ӧ�������ĩ��ֵ����������ڵ��ֽ��</PRT_LINE>
			<PRT_LINE>������ֵ���������򱾹�˾��ѯ��</PRT_LINE>
			<PRT_LINE>������2.��5���������ĩ���б���������ֵΪ�����ġ����ڱ��ս𡱣�Ϊ���պ�ͬԼ���Ļ������ս�</PRT_LINE>
			<PRT_LINE>������----------------------------------------------------------------------------------------------</PRT_LINE>
		</PRT_DETAIL>	
    </PRTS>
    </PRT>
    </xsl:if>
</RETURN>
</xsl:template>
 


<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">���֤</xsl:when>
	<xsl:when test=".=1">����  </xsl:when>
	<xsl:when test=".=2">����֤</xsl:when>
	<xsl:when test=".=3">����  </xsl:when>
	<xsl:when test=".=5">���ڲ�</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ɷѼ��  -->
<xsl:template match="PayIntv">
<xsl:choose>
	<xsl:when test=".=0">����</xsl:when>		
	<xsl:when test=".=1">�½�</xsl:when>
	<xsl:when test=".=3">����</xsl:when>
	<xsl:when test=".=6">�����</xsl:when>
	<xsl:when test=".=12">���</xsl:when>
	<xsl:when test=".=-1">�����ڽ�</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
 
 <!-- �Ա�ע�⣺����     ���ո��Ű��õģ�����ȥ����-->
<xsl:template match="Sex">
<xsl:choose>
	<xsl:when test=".=0">��  </xsl:when>		
	<xsl:when test=".=1">Ů  </xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ������ȡ  -->
<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
<xsl:choose>
	<xsl:when test=".=1">�ۼ���Ϣ</xsl:when>
	<xsl:when test=".=2">��ȡ�ֽ�</xsl:when>
	<xsl:when test=".=3">�ֽɱ���</xsl:when>
	<xsl:when test=".=5">�����</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ���ؽɷѷ�ʽ -->
<xsl:template name="tran_PayIntv">
    <xsl:param name="PayIntv">0</xsl:param>
	<xsl:choose>
	    <xsl:when test="$PayIntv = 0">W</xsl:when>
		<xsl:when test="$PayIntv = 12">Y</xsl:when>
		<xsl:when test="$PayIntv = 1">M</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$PayIntv"/>
		</xsl:otherwise>
	</xsl:choose>
 </xsl:template>
 
<xsl:template match="Head/Flag">
<xsl:choose>
	<xsl:when test=".='0'">0000</xsl:when>
	<xsl:when test=".='1'">0001</xsl:when>
	<xsl:otherwise>
	    <xsl:value-of select="Head/Flag"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

	<!-- �ɷ����������־ -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="payendyearflag" />
		<xsl:param name="payendyear" />
		<xsl:choose>
			<xsl:when test="$payendyearflag='Y' and $payendyear=1000">1</xsl:when><!-- ���� -->
			<xsl:when test="$payendyearflag='Y'">2</xsl:when><!-- ���� -->
			<xsl:when test="$payendyearflag='A'">4</xsl:when><!-- �����ɷ� -->
			<xsl:when test="$payendyearflag='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
