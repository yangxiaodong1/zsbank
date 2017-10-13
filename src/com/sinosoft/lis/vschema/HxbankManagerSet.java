/**
 * Copyright (c) 2006 sinosoft Co. Ltd.
 * All right reserved.
 */

package com.sinosoft.lis.vschema;

import com.sinosoft.lis.schema.HxbankManagerSchema;
import com.sinosoft.utility.*;

/**
 * <p>ClassName: HxbankManagerSet </p>
 * <p>Description: HxbankManagerSchemaSet类文件 </p>
 * <p>Company: sinosoft </p>
 * @Database: PHYSICAL_DATA_MODEL_1
 * @author：Maker
 * @CreateDate：2014-04-23
 */
public class HxbankManagerSet extends SchemaSet
{
	// @Method
	public boolean add(HxbankManagerSchema aSchema)
	{
		return super.add(aSchema);
	}

	public boolean add(HxbankManagerSet aSet)
	{
		return super.add(aSet);
	}

	public boolean remove(HxbankManagerSchema aSchema)
	{
		return super.remove(aSchema);
	}

	public HxbankManagerSchema get(int index)
	{
		HxbankManagerSchema tSchema = (HxbankManagerSchema)super.getObj(index);
		return tSchema;
	}

	public boolean set(int index, HxbankManagerSchema aSchema)
	{
		return super.set(index,aSchema);
	}

	public boolean set(HxbankManagerSet aSet)
	{
		return super.set(aSet);
	}

	/**
	* 数据打包，按 XML 格式打包，顺序参见<A href ={@docRoot}/dataStructure/tb.html#PrpHxbankManager描述/A>表字段
	* @return: String 返回打包后字符串
	**/
	public String encode()
	{
		StringBuffer strReturn = new StringBuffer("");
		int n = this.size();
		for (int i = 1; i <= n; i++)
		{
			HxbankManagerSchema aSchema = this.get(i);
			strReturn.append(aSchema.encode());
			if( i != n ) strReturn.append(SysConst.RECORDSPLITER);
		}

		return strReturn.toString();
	}

	/**
	* 数据解包
	* @param: str String 打包后字符串
	* @return: boolean
	**/
	public boolean decode( String str )
	{
		int nBeginPos = 0;
		int nEndPos = str.indexOf('^');
		this.clear();

		while( nEndPos != -1 )
		{
			HxbankManagerSchema aSchema = new HxbankManagerSchema();
			if(aSchema.decode(str.substring(nBeginPos, nEndPos)))
			{
			this.add(aSchema);
			nBeginPos = nEndPos + 1;
			nEndPos = str.indexOf('^', nEndPos + 1);
			}
			else
			{
				// @@错误处理
				this.mErrors.copyAllErrors( aSchema.mErrors );
				return false;
			}
		}
		HxbankManagerSchema tSchema = new HxbankManagerSchema();
		if(tSchema.decode(str.substring(nBeginPos)))
		{
		this.add(tSchema);
		return true;
		}
		else
		{
			// @@错误处理
			this.mErrors.copyAllErrors( tSchema.mErrors );
			return false;
		}
	}

}
