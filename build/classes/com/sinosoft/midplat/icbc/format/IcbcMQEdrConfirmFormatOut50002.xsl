<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID />
				<TransType>1005</TransType>
				<TransExeDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" />
				</TransExeTime>
				<!-- 展现返回的结果 -->
				<xsl:apply-templates select="TranData/Body" />
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="OLifE" match="Body">
		<OLifE>
			<FormInstance id="Form_1">
	            <FormName><xsl:value-of select="PubEdorConfirm/FormType"></xsl:value-of></FormName>
	            <DocumentControlNumber><xsl:value-of select="PubEdorConfirm/FormNumber"></xsl:value-of></DocumentControlNumber>
	         </FormInstance>
		</OLifE>
		<DynamicPrintIndicator>Y</DynamicPrintIndicator>
		<Print>
			<!--凭证个数-->
			<VoucherNum>1</VoucherNum>
			<SubVoucher>
				<!--凭证类型 批单-->
				<VoucherType>8</VoucherType>
				<!--凭证文本-->
				<!--总页数-->
				<PageTotal>1</PageTotal>
				<Text>
					<!--页号-->
					<PageNum>1</PageNum>
					<TextContent>
						  <RowNum>1</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>2</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>3</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>4</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
									<TextContent>
						  <RowNum>5</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>6</RowNum>
					    <TextRowContent>                               申    请    批    单</TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>7</RowNum>
					    <TextRowContent>                              （银保通保全业务专用）</TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>8</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>9</RowNum>
					    <TextRowContent>    投保人：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(PubContInfo/AppntName, 16)"/>被保险人：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(PubContInfo/InsuredName, 16)"/>批单号：<xsl:value-of select="PubEdorConfirm/FormNumber" /></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>10</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>11</RowNum>
					    <TextRowContent>        经<xsl:value-of select="PubContInfo/AppntName" />申请，本公司审核同意，对<xsl:value-of select="PubContInfo/ContNo" />号保单做如下批注：   </TextRowContent>
					</TextContent>										
					<TextContent>
						  <RowNum>12</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
					    <RowNum>13</RowNum>
					    <TextRowContent>    变更项目：满期给付</TextRowContent>
					</TextContent>
					<TextContent>
					    <RowNum>14</RowNum>
					    <TextRowContent>    变更内容：</TextRowContent>
					</TextContent>
					<TextContent>
					    <RowNum>15</RowNum>
					    <TextRowContent>　　　　　　   险种名称　　　　　               险种属性       应退金额</TextRowContent>
					</TextContent>
					
					<xsl:choose>
						<xsl:when test="PubContInfo/MainRiskCode='122046'">
							<TextContent>
						    	<RowNum>16</RowNum>
							    <TextRowContent><xsl:apply-templates select="PubContInfo/Risk[RiskCode='122046']" /></TextRowContent>					     
							</TextContent>
							<TextContent>
						    	<RowNum>17</RowNum>
							    <TextRowContent><xsl:apply-templates select="PubContInfo/Risk[RiskCode='122047']" /></TextRowContent>					     
							</TextContent>
						</xsl:when>
					</xsl:choose>
					<TextContent>
						  <RowNum>18</RowNum>
						  <TextRowContent>    实退金额：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" />元</TextRowContent>					     
					</TextContent>
					<TextContent>
						  <RowNum>19</RowNum>
						  <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>    
						  <RowNum>20</RowNum>
						  <TextRowContent>    批单生效日期：<xsl:apply-templates select="PubContInfo/EdorAppDate" /></TextRowContent>					     
					</TextContent>
				  <TextContent>    
						  <RowNum>21</RowNum>
						  <TextRowContent></TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>22</RowNum>
						  <TextRowContent>    特此批改！</TextRowContent>					     
					</TextContent>				
				</Text>
			</SubVoucher>
		</Print>
	</xsl:template>
	<!-- 险种信息 -->
	<xsl:template name="AttachmentData" match="Risk">							
		<xsl:choose>
			<xsl:when test="RiskCode =122001">        安邦黄金鼎1号两全保险（分红型）A款            </xsl:when>	
			<xsl:when test="RiskCode =122002">        安邦黄金鼎2号两全保险（分红型）A款            </xsl:when>	
			<xsl:when test="RiskCode =122004">        安邦附加黄金鼎2号两全保险（分红型）A款        </xsl:when>	
			<xsl:when test="RiskCode =122003">        安邦聚宝盆1号两全保险（分红型）A款            </xsl:when>	
			<xsl:when test="RiskCode =122006">        安邦聚宝盆2号两全保险（分红型）A款            </xsl:when>	
			<xsl:when test="RiskCode =122008">        安邦白玉樽1号终身寿险（万能型）               </xsl:when>	
			<xsl:when test="RiskCode =122009">        安邦黄金鼎5号两全保险（分红型）A款            </xsl:when>	
			<xsl:when test="RiskCode =122011">        安邦盛世1号终身寿险（万能型）                 </xsl:when>	
			<xsl:when test="RiskCode =122012">        安邦盛世2号终身寿险（万能型）                 </xsl:when>	
			<xsl:when test="RiskCode =122010">        安邦盛世3号终身寿险（万能型）                 </xsl:when>
			<xsl:when test="RiskCode =122029">        安邦盛世5号终身寿险（万能型）                 </xsl:when>
			<xsl:when test="RiskCode =122020">        安邦长寿6号两全保险（分红型）                 </xsl:when>
			<xsl:when test="RiskCode =122036">        安邦黄金鼎6号两全保险（分红型）A款            </xsl:when>
			
			<!-- 50002: 122046-安邦长寿稳赢1号两全保险、122047-安邦附加长寿稳赢两全保险、122048-安邦长寿添利终身寿险（万能型）组成  -->
			<!-- 前五年50002这款产品的主险为122046，五年后这款主险的产品为122048,如果5年后做退保时核心传的主险险种便成了122048 -->
			<!-- <xsl:when test="RiskCode =122046">        安邦长寿稳赢1号两全保险                  </xsl:when>
			<xsl:when test="RiskCode =122047">        安邦附加长寿稳赢两全保险                 </xsl:when> -->
			<!-- 满期给付交易中，不展示122048 -->
			<xsl:when test="RiskCode =122048">        安邦长寿添利终身寿险（万能型）            </xsl:when> 
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
			<xsl:when test="RiskCode ='L12079'">        安邦盛世2号终身寿险（万能型）                 </xsl:when>	
			<xsl:when test="RiskCode ='L12078'">        安邦盛世3号终身寿险（万能型）                 </xsl:when>
			<xsl:when test="RiskCode ='L12100'">        安邦盛世3号终身寿险（万能型）                 </xsl:when>
			<xsl:when test="RiskCode ='L12074'">        安邦盛世9号两全保险（万能型）                 </xsl:when>
			<xsl:when test="RiskCode ='122046'">        安邦长寿稳赢1号两全保险                      </xsl:when>
			<xsl:when test="RiskCode ='122047'">        安邦附加长寿稳赢两全保险                     </xsl:when>
			<xsl:when test="RiskCode ='L12081'">        安邦长寿添利终身寿险（万能型）               </xsl:when>
			<!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->		
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="RiskCode=MainRiskCode">
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('主险', 14)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('附加险', 14)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(GetMoney)" />元</xsl:template>	
</xsl:stylesheet>