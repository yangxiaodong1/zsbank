package com.sinosoft.midplat.bat;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletContextEvent;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.xpath.XPath;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.Log4jPrint;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**
 * 增加 通过固定 时间间隔 一天跑多次 的处理
 * 
 * @author ab024200
 * 
 */
public class AbBatListener extends BatListener {

	private final static Logger cLogger = Logger.getLogger(BatListener.class);

	private Timer[] cTimers = null;

	public AbBatListener() {
		BatConf.newInstance().setListener(this); // 注册到批处理配置缓存中，调整配置后自动调用相关方法重启端口监听
	}

	public static void main(
							String[] args) {
		if (MidplatConf.newInstance().resetLog()) {
			System.out.println("Start reset System.out...");
			System.setOut(new Log4jPrint(System.out));
			System.setErr(new Log4jPrint(System.err));
			System.out.println("End reset System.out!");
		}

		FileCacheManage.newInstance().start();

		new BatListener().contextInitialized(null);
	}

	@SuppressWarnings("unchecked")
	public void contextInitialized(
									ServletContextEvent event) {
		cLogger.info("Into BatListener.contextInitialized()...");

		Document mBatConfDoc = BatConf.newInstance().getConf();
		List<Element> mBatList = mBatConfDoc.getRootElement().getChildren();
		int mSize = mBatList.size();
		cTimers = new Timer[mSize];
		for (int i = 0; i < mSize; i++) {
			try {
				Element ttBalanceConfig = mBatList.get(i);
				cLogger.info(i + "_batch(" + ttBalanceConfig.getChildText(name) + "): startTime=" + ttBalanceConfig.getChildText(startTime) + "; class=" + ttBalanceConfig.getChildText("class"));
				String ttClassName = ttBalanceConfig.getChildText("class");
				TimerTask ttTimerTask = (TimerTask) Class.forName(ttClassName).newInstance();

				int ttStartHour = 23;
				int ttStartMinute = 00;
				int ttStartSecond = 00;
				String ttStartTime = ttBalanceConfig.getChildText(startTime);

				Calendar ttCalendar = Calendar.getInstance();
				Timer ttTimer = new Timer();

				if (ttStartTime.contains(":")) {
					String[] ttStartTimes = ttStartTime.split(":");
					try {
						ttStartHour = Integer.parseInt(ttStartTimes[0]);
						ttStartMinute = Integer.parseInt(ttStartTimes[1]);
						ttStartSecond = Integer.parseInt(ttStartTimes[2]);
					} catch (Exception ex) {
						cLogger.warn(i + "_批跑时间配置有误，系统自动采用默认置！");
						cLogger.debug(i + "_批跑时间配置有误！", ex); // debug模式下输出全部错误堆栈，便于在测试环境调试
					}

					ttCalendar.set(Calendar.HOUR_OF_DAY, ttStartHour);
					ttCalendar.set(Calendar.MINUTE, ttStartMinute);
					ttCalendar.set(Calendar.SECOND, ttStartSecond);

					if ("Y".equals(XPath.newInstance("isDelay").valueOf(ttBalanceConfig))) {
						// 对于isDelay标志位y的， 日期做加一天处理，下一日即执行批处理
					    Date tempDate = new Date();
					    tempDate.setTime(ttCalendar.getTime().getTime() + 24 * 60 * 60 * 1000);
					    ttCalendar.setTime(tempDate);
					}
					cLogger.info("首次跑批时间" + ttCalendar.getTime().toString());
					cLogger.info("每日批跑开始时间：" + ttStartHour + ":" + ttStartMinute + ":" + ttStartSecond);

					ttTimer.scheduleAtFixedRate(ttTimerTask, ttCalendar.getTime(), 24 * 60 * 60 * 1000);
				} else {
					ttTimer.scheduleAtFixedRate(ttTimerTask, ttCalendar.getTime(), Integer.parseInt(ttStartTime) * 1000);

				}

				cTimers[i] = ttTimer;
				cLogger.info(i + "_batch(" + ttBalanceConfig.getChildText(name) + ")加载成功!");
			} catch (Exception ex) {
				cLogger.error(i + "_batch加载失败!", ex);
			}
		}

		cLogger.info("Out BatListener.contextInitialized()!");
	}

	public void contextDestroyed(
									ServletContextEvent event) {
		cLogger.info("Into BatListener.contextDestroyed()...");

		cLogger.info("关闭批跑Timer...");
		/**
		 * 一定要关闭，否则重启时上一个对账任务线程会继续跑，造成多个执行相同对账任务的对账线程同时跑的情况， 进而造成同一天同一银行多次对账。
		 */
		for (int i = 0; i < cTimers.length; i++) {
			/**
			 * 在加载balanceConfig.xml中某项失败时，cTimers中对应的值会为null，在此需过滤掉。
			 */
			if (null != cTimers[i]) {
				cTimers[i].cancel();
			}
		}

		cLogger.info("Out BatListener.contextDestroyed()!");
	}
}
