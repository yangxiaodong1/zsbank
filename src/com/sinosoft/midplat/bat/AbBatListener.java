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
 * ���� ͨ���̶� ʱ���� һ���ܶ�� �Ĵ���
 * 
 * @author ab024200
 * 
 */
public class AbBatListener extends BatListener {

	private final static Logger cLogger = Logger.getLogger(BatListener.class);

	private Timer[] cTimers = null;

	public AbBatListener() {
		BatConf.newInstance().setListener(this); // ע�ᵽ���������û����У��������ú��Զ�������ط��������˿ڼ���
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
						cLogger.warn(i + "_����ʱ����������ϵͳ�Զ�����Ĭ���ã�");
						cLogger.debug(i + "_����ʱ����������", ex); // debugģʽ�����ȫ�������ջ�������ڲ��Ի�������
					}

					ttCalendar.set(Calendar.HOUR_OF_DAY, ttStartHour);
					ttCalendar.set(Calendar.MINUTE, ttStartMinute);
					ttCalendar.set(Calendar.SECOND, ttStartSecond);

					if ("Y".equals(XPath.newInstance("isDelay").valueOf(ttBalanceConfig))) {
						// ����isDelay��־λy�ģ� ��������һ�촦����һ�ռ�ִ��������
					    Date tempDate = new Date();
					    tempDate.setTime(ttCalendar.getTime().getTime() + 24 * 60 * 60 * 1000);
					    ttCalendar.setTime(tempDate);
					}
					cLogger.info("�״�����ʱ��" + ttCalendar.getTime().toString());
					cLogger.info("ÿ�����ܿ�ʼʱ�䣺" + ttStartHour + ":" + ttStartMinute + ":" + ttStartSecond);

					ttTimer.scheduleAtFixedRate(ttTimerTask, ttCalendar.getTime(), 24 * 60 * 60 * 1000);
				} else {
					ttTimer.scheduleAtFixedRate(ttTimerTask, ttCalendar.getTime(), Integer.parseInt(ttStartTime) * 1000);

				}

				cTimers[i] = ttTimer;
				cLogger.info(i + "_batch(" + ttBalanceConfig.getChildText(name) + ")���سɹ�!");
			} catch (Exception ex) {
				cLogger.error(i + "_batch����ʧ��!", ex);
			}
		}

		cLogger.info("Out BatListener.contextInitialized()!");
	}

	public void contextDestroyed(
									ServletContextEvent event) {
		cLogger.info("Into BatListener.contextDestroyed()...");

		cLogger.info("�ر�����Timer...");
		/**
		 * һ��Ҫ�رգ���������ʱ��һ�����������̻߳�����ܣ���ɶ��ִ����ͬ��������Ķ����߳�ͬʱ�ܵ������ �������ͬһ��ͬһ���ж�ζ��ˡ�
		 */
		for (int i = 0; i < cTimers.length; i++) {
			/**
			 * �ڼ���balanceConfig.xml��ĳ��ʧ��ʱ��cTimers�ж�Ӧ��ֵ��Ϊnull���ڴ�����˵���
			 */
			if (null != cTimers[i]) {
				cTimers[i].cancel();
			}
		}

		cLogger.info("Out BatListener.contextDestroyed()!");
	}
}
