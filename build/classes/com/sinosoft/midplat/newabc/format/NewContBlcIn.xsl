<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	
	<xsl:template match="/">
		<TranData>
			<Body>
				<!-- ����Լ���� -->
				<NewCont>
					<TranData>
						<!-- ����ͷ -->
						<xsl:copy-of select="TranData/Head" />
						<Body>
							<!-- �ɹ�������Լ���� -->
							<Count>
								<xsl:value-of select="count(//Detail[position()>1 and Column[7]='01' and Column[8]='01'])" />
							</Count>
							<Prem>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(sum(//Detail[position()>1 and Column[7]='01' and Column[8]='01']/Column[6]))" />
							</Prem>
							<xsl:for-each
								select="//Detail[position()>1 and Column[7]='01' and Column[8]='01']">
								<xsl:call-template
									name="common_newcont" />
							</xsl:for-each>
						</Body>
					</TranData>
				</NewCont>
				<!-- ���ڽɷѶ��� -->
				<XQ>
					<TranData>
						<!-- ����ͷ -->
						<xsl:copy-of select="TranData/Head" />
						<Body>
							<!-- ��ȫ���˹�����ʾ���� -->
							<PubContInfo>
								<!-- ���˱�ʾ -->
								<EdorFlag>8</EdorFlag>
								<!-- �˱����� -->
								<CTBlcType>0</CTBlcType>
								<!-- ���˶��� -->
								<WTBlcType>0</WTBlcType>
								<!-- ���ڶ��� -->
								<MQBlcType>0</MQBlcType>
								<!-- ���ڶ��� -->
								<XQBlcType>1</XQBlcType>
							</PubContInfo>
							<xsl:for-each
								select="//Detail[position()>1 and Column[7]='03']">
								<xsl:call-template name="common_xq" />
							</xsl:for-each>
						</Body>
					</TranData>
				</XQ>
			</Body>
		</TranData>
	</xsl:template>

	<!-- ����Լ���� -->
	<xsl:template name="common_newcont">
		<Detail>
			<!--  �������ڣ�10λ���ָ�ʽYYYYMMDD������Ϊ�գ� -->
			<TranDate>
				<xsl:value-of select="Column[1]" />
			</TranDate>
			<!--  �����������  (������+������)-->
			<NodeNo>
				<xsl:value-of select="Column[3]" />
				<xsl:value-of select="Column[4]" />
			</NodeNo>
			<!--  ������ˮ��  -->
			<TranNo>
				<xsl:value-of select="Column[2]" />
			</TranNo>
			<!--  ���պ�ͬ��/������  -->
			<ContNo>
				<xsl:value-of select="Column[5]" />
			</ContNo>
			<!--  ����ʵ�ս�� -->
			<Prem>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[6])" />
			</Prem>
			<SourceType>0</SourceType>
		</Detail>
	</xsl:template>

	<!-- ����Լ���� -->
	<xsl:template name="common_xq">
		<Detail>
			<!--  ���б��  -->
			<BankCode>05</BankCode>
			<!--  ��ȫ����  -->
			<EdorType>XQ</EdorType>
			<!--  ��ȫ�����  -->
			<EdorAppNo/>
			<!--  ��ȫ-->
			<EdorNo />
			<!-- ��������  -->
			<EdorAppDate>
				<xsl:value-of select="Column[1]" />
			</EdorAppDate>
			<!--  ���պ�ͬ��/������  -->
			<ContNo>
				<xsl:value-of select="Column[5]" />
			</ContNo>
			<!-- ���ѽ�� -->
			<TranMoney>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[6])" />
			</TranMoney>
			<!-- �˻��� -->
			<AccNo/>
			<!-- �˻����� -->
			<AccName/>
			<RCode>0</RCode>
		</Detail>
	</xsl:template>
</xsl:stylesheet>