<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife> 		
			<xsl:copy-of select="TranData/Head" /><!-- icbcNetImpl类会根据这个head来解析返回节点 -->				
			<TXLifeResponse>
				<TransRefGUID/>
				<TransType></TransType>
				<TransExeDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()"/>
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				</TransExeTime>															
				<!-- 展现返回的结果 -->
				<xsl:apply-templates select="TranData/Body"/>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="OLifE" match="Body">		
		<OLifE>
			<FormInstance id="Form_1">
				<!-- 单证名称 TODO 是否需要转换code-->
				<FormName><xsl:value-of select="PubEdorConfirm/FormType"></xsl:value-of></FormName>
				<!-- 批单号 -->
				<DocumentControlNumber><xsl:value-of select="PubEdorConfirm/FormNumber"></xsl:value-of></DocumentControlNumber>
				<!-- 批文（可重复） -->
				<Attachment id="Attachment_1">
					<!-- 批文内容1（第一行） -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
				<Attachment id="Attachment_2">
					<!-- 批文内容2（第二行） -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
				<Attachment id="Attachment_3">
					<!-- 批文内容3（第三行） -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
			</FormInstance>
		</OLifE>
		<!-- 动态打印标志 -->
		<DynamicPrintIndicator>Y</DynamicPrintIndicator>
		<!--凭证逐行打印接口，且要求DynamicPrintIndicator节点值为Y-->
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
					    <TextRowContent>    变更项目：解除合同</TextRowContent>
					</TextContent>
					<TextContent>    
					    <RowNum>14</RowNum>
					    <TextRowContent>    变更内容：</TextRowContent>
					</TextContent>
					<TextContent>    
					    <RowNum>15</RowNum>
					    <TextRowContent>　　　　　　   险种名称　　　　　               险种属性       应退金额</TextRowContent>
					</TextContent>
					<TextContent>    
				    	<RowNum>16</RowNum>
					    <TextRowContent><xsl:apply-templates select="PubContInfo" /></TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>17</RowNum>
						  <TextRowContent>    实退金额：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" />元</TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>18</RowNum>
						  <TextRowContent></TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>19</RowNum>
						  <TextRowContent>    批单生效日期：<xsl:apply-templates select="PubContInfo/EdorAppDate" /></TextRowContent>					     
					</TextContent>
				  <TextContent>    
						  <RowNum>20</RowNum>
						  <TextRowContent></TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>21</RowNum>
						  <TextRowContent>    特此批改！</TextRowContent>					     
					</TextContent>				
				</Text>
			</SubVoucher>
		</Print>
		
	</xsl:template>

	<!-- 险种信息 -->
	<xsl:template name="AttachmentData" match="PubContInfo">							
		 <xsl:choose>
		      <xsl:when test="MainRiskCode =122001">    安邦黄金鼎1号两全保险（分红型）A款            </xsl:when>	
		      <xsl:when test="MainRiskCode =122002">    安邦黄金鼎2号两全保险（分红型）A款            </xsl:when>	
		      <xsl:when test="MainRiskCode =122004">    安邦附加黄金鼎2号两全保险（分红型）A款        </xsl:when>	
		      <xsl:when test="MainRiskCode =122003">    安邦聚宝盆1号两全保险（分红型）A款            </xsl:when>	
		      <xsl:when test="MainRiskCode =122006">    安邦聚宝盆2号两全保险（分红型）A款            </xsl:when>	
		      <xsl:when test="MainRiskCode =122008">    安邦白玉樽1号终身寿险（万能型）               </xsl:when>	
		      <xsl:when test="MainRiskCode =122009">    安邦黄金鼎5号两全保险（分红型）A款            </xsl:when>	
		      <xsl:when test="MainRiskCode =122011">    安邦盛世1号终身寿险（万能型）                 </xsl:when>
		      <xsl:when test="MainRiskCode =122012">    安邦盛世2号终身寿险（万能型）                 </xsl:when>	
		      <xsl:when test="MainRiskCode =122010">    安邦盛世3号终身寿险（万能型）                 </xsl:when>
		      <xsl:when test="MainRiskCode =122029">    安邦盛世5号终身寿险（万能型）                 </xsl:when>
		      <xsl:when test="MainRiskCode =122020">    安邦长寿6号两全保险（分红型）                 </xsl:when>
		      <xsl:when test="MainRiskCode =122036">    安邦黄金鼎6号两全保险（分红型）A款            </xsl:when>
		      <xsl:when test="MainRiskCode =122038">    安邦价值增长8号终身寿险（分红型）A款          </xsl:when>
		      <!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
			  <xsl:when test="MainRiskCode ='L12079'">    安邦盛世2号终身寿险（万能型）                 </xsl:when>	
			  <xsl:when test="MainRiskCode ='L12078'">    安邦盛世3号终身寿险（万能型）                 </xsl:when>
			   <xsl:when test="MainRiskCode =L12100">    安邦盛世3号终身寿险（万能型）                 </xsl:when>
			  <!-- PBKINSR-679 工行盛2（柜面、网银、自助终端）、盛3（柜面、网银、自助终端）、盛9（柜面）、50002（柜面、网银、自助终端）产品升级 -->
			  <!-- PBKINSR-787 工行，银保通开发盛世9号新产品项目 -->
			  <xsl:when test="MainRiskCode ='L12074'">    安邦盛世9号两全保险（万能型）                 </xsl:when>	
			  <!-- PBKINSR-787 工行，银保通开发盛世9号新产品项目 -->
			  <!-- PBKINSR-818 浙江工行专项产品项目（一期） -->
			  <xsl:when test="MainRiskCode ='L12077'">    安邦盛世2号终身寿险（万能型）                 </xsl:when>
			  <!-- PBKINSR-818 浙江工行专项产品项目（一期） -->
			  <!-- PBKINSR-924 工行网银上线新产品（安邦汇赢2号年金保险A款）-->
			  <xsl:when test="MainRiskCode ='L12084'">    安邦汇赢2号年金保险A款                        </xsl:when>
			  <xsl:when test="MainRiskCode ='L12089'">    安邦盛世1号终身寿险（万能型）B款            </xsl:when>
			  <xsl:when test="MainRiskCode ='L12093'">    安邦盛世9号两全保险B款（万能型）               </xsl:when>
			  <xsl:when test="MainRiskCode ='L12086'">    安邦东风3号两全保险（万能型）               </xsl:when>
		      <xsl:when test="MainRiskCode ='L12102'">    安邦盛世9号两全保险（万能型）                 </xsl:when>	
			  <xsl:when test="MainRiskCode ='L12088'">    安邦东风9号两全保险（万能型）               </xsl:when>
			  <xsl:when test="MainRiskCode ='L12085'">    安邦东风2号两全保险（万能型）               </xsl:when>
			  <xsl:when test="MainRiskCode ='L12087'">    安邦东风5号两全保险（万能型）			  </xsl:when>
			  
		      <xsl:otherwise>--</xsl:otherwise>
		  </xsl:choose>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('主险', 13)"/>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(FinActivityGrossAmt)" />元</xsl:template>	
</xsl:stylesheet>
