import { TurboModule } from "@rnoh/react-native-openharmony/ts";
import { TM } from "@rnoh/react-native-openharmony/generated/ts";
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import notificationManager from '@ohos.notificationManager';
import { JPushInterface, JMessage, JTagMessage, JAliasMessage, JCustomMessage, JCmdMessage } from "@jg/push";
import {
  JPushConfig,
  JPushParams,
  JPushGeoInfo,
  JPushNotificationInfo,
  RegisterResult,
  JPushEvent,
  JPushEventListener,
  JPushResult
} from './Type';
import Logger from "./Logger";
import { JSON } from '@kit.ArkTS';
import { TurboModuleContext } from '@rnoh/react-native-openharmony';


export class RNJPushTurboModule extends TurboModule implements TM.JPushModule.Spec {
  private context: common.UIAbilityContext;
  private applicationContext: common.ApplicationContext;

  constructor(ctx: TurboModuleContext) {
    super(ctx);
    this.context = this.ctx.uiAbilityContext;
    this.applicationContext = this.context.getApplicationContext();
    // 订阅监听事件
    this.sendEvent();
  }

  /*
    * 设置调试模式，默认关闭状态
    * debug 为 true 则会打印 debug 级别的日志，false 则只会打印 warning 级别以上的日志
    * 该接口需在 init 接口之前调用，避免出现部分日志没打印的情况
    * @param enable = boolean
    * */
  public setDebugMode(enable: boolean) {
    JPushInterface.setDebug(enable);
  };

  /*
     * 初始化推送服务
     * {"appKey":"","channel":"dev","production":1}
     * 请在onCreate 调用setupWithConfig
     * */
  public setupWithConfig(params: JPushConfig) {
    if (params.appKey && params.channel) {
      JPushInterface.setAppKey(params.appKey);
      JPushInterface.setChannel(params.channel);
    }
  };

  /*
     * 获取 RegistrationID
     *
     * 调用此 API 来取得应用程序对应的 RegistrationID。
     * 只有当应用程序成功注册到 JPush 的服务器时才返回对应的值，否则返回空字符串
     *
     * @param {Function} callback = (result) => {"registerID":String}
     * */
  public getRegisterId(callback: (res: RegisterResult) => void) {
    let rid: string = JPushInterface.getRegistrationId();
    let map: RegisterResult = { "registerID": rid };
    callback(map);
  };

  /*
   *   检查当前应用的通知开关是否开启
   * */
  public isNotificationEnabled(callback: (isNotificationEnabled: boolean) => void) {
    notificationManager.requestEnableNotification(this.context).then(() => {
      callback(true);
    }).catch((err: BusinessError) => {
      callback(false);
    });
  };

  /*
      * 新增标签
      *
      * 这个接口是增加逻辑，而不是覆盖逻辑
      *
      * @param params = {"sequence":int,"tags":StringArray}
      *
      * sequence:
      * 请求时传入的序列号，会在回调时原样返回
      * tag:
      * 有效的标签组成：字母（区分大小写）、数字、下划线、汉字、特殊字符@!#$&*+=.|
      * 限制：每个 tag 命名长度限制为 40 字节，最多支持设置 1000 个 tag，且单次操作总长度不得超过 5000 字节
      *（判断长度需采用 UTF-8 编码）单个设备最多支持设置 1000 个 tag。App 全局 tag 数量无限制
      * */
  public addTags(params: JPushParams) {
    if (params.tags) {
      let seq = params.sequence ? params.sequence : -1;
      JPushInterface.addTags(seq, params.tags);
    }
  };

  /*
     * 覆盖标签
     *
     * 需要理解的是，这个接口是覆盖逻辑，而不是增量逻辑。即新的调用会覆盖之前的设置
     *
     * @param params = {"sequence":int,"tags":StringArray}
     *
     * sequence:
     * 请求时传入的序列号，会在回调时原样返回
     * tag:
     * 有效的标签组成：字母（区分大小写）、数字、下划线、汉字、特殊字符@!#$&*+=.|
     * 限制：每个 tag 命名长度限制为 40 字节，最多支持设置 1000 个 tag，且单次操作总长度不得超过 5000 字节
     *（判断长度需采用 UTF-8 编码）单个设备最多支持设置 1000 个 tag。App 全局 tag 数量无限制
     * */
  public setTags(params: JPushParams) {
    if (params.tags) {
      let seq = params.sequence ? params.sequence : -1;
      JPushInterface.setTags(seq, params.tags);
    }
  };

  /*
     * 删除指定标签
     * */
  public deleteTags(params: JPushParams) {
    if (params.tags) {
      let seq = params.sequence ? params.sequence : -1;
      JPushInterface.deleteTags(seq, params.tags);
    }
  };

  /*
    * 清除所有标签
    *
    * @param params = {"sequence":int}
    *
    * sequence:
    * 请求时传入的序列号，会在回调时原样返回
    * */
  public cleanTags(params: JPushParams) {
    let seq = params.sequence ? params.sequence : -1;
    JPushInterface.cleanTags(seq);
  };

  /*
    * 查询所有标签
    *
    * @param params = {"sequence":int}
    *
    * sequence:
    * 请求时传入的序列号，会在回调时原样返回
    * */
  public getAllTags(params: JPushParams) {
    let seq = params.sequence ? params.sequence : -1;
    let curr = params.currentPage ? params.currentPage : 1;
    JPushInterface.getTags(seq, curr);
  };

  public validTag(params: JPushParams) {
    if (params.tag) {
      let seq = params.sequence ? params.sequence : -1;
      JPushInterface.checkTagBindState(seq, params.tag);
    }
  };

  /*
     * 设置别名
     * 需要理解的是，这个接口是覆盖逻辑，而不是增量逻辑。即新的调用会覆盖之前的设置
     *
     * @param params = {"sequence":int,"alias":String}
     *
     * sequence:
     * 请求时传入的序列号，会在回调时原样返回
     * alias:
     * 每次调用设置有效的别名，覆盖之前的设置
     * 有效的别名组成：字母（区分大小写）、数字、下划线、汉字、特殊字符@!#$&*+=.|
     * 限制：alias 命名长度限制为 40 字节。（判断长度需采用 UTF-8 编码）
     * */
  public setAlias(params: JPushParams) {
    if (params.alias) {
      let seq = params.sequence ? params.sequence : -1;
      JPushInterface.setAlias(seq, params.alias);
    }
  };

  /*
      * 删除别名
      *
      * @param params = {"sequence":int}
      *
      * sequence:
      * 请求时传入的序列号，会在回调时原样返回
      * */
  public deleteAlias(params: JPushParams) {
    let seq = params.sequence ? params.sequence : -1;
    JPushInterface.deleteAlias(seq)
  };

  /*
      * 查询别名
      *
      * @param params = {"sequence":int}
      *
      * sequence:
      * 请求时传入的序列号，会在回调时原样返回
      * */
  public getAlias(params: JPushParams) {
    let seq = params.sequence ? params.sequence : -1;
    JPushInterface.getAlias(seq);
  };

  public stopPush() {
    JPushInterface.stopPush()

  }

  public resumePush() {
    JPushInterface.resumePush()

  }

  public isPushStopped(callBack: (bo: boolean) => void) {
    let bo: boolean = JPushInterface.isPushStopped() || false
    callBack(bo)
  }

  public setBadge(params: JPushParams) {
    let n = params.badge;
    if (n && n > 0) {
      JPushInterface.setBadgeNumber(n)
    }
  };

  public setProperties(params: JPushParams) {
    Logger.error('###JPush harmony not support setProperties')
  };

  public deleteProperties(params: JPushParams) {
    Logger.error('###JPush harmony not support deleteProperties')
  };

  public cleanProperties(params: JPushParams) {
    Logger.error('###JPush harmony not support cleanProperties')
  };

  public pageEnterTo(pageName: string) {
    Logger.error('###JPush harmony not support pageEnterTo')
  };

  public pageLeave(pageName: string) {
    Logger.error('###JPush harmony not support pageLeave')
  };

  public setMobileNumber(params: JPushParams) {
    let seq = params.sequence ? params.sequence : -1;
    let tel = params.mobileNumber;
    if(tel){
      JPushInterface.setMobileNumber(seq,tel);
      let result:JPushResult = {"code":0,"sequence":seq};
      this.ctx.rnInstance.emitDeviceEvent(JPushEvent.MOBILE_NUMBER_EVENT, result);
    }
  };

  // 崩溃日志统计
  public crashLogON(params: JPushParams) {
    Logger.error('###JPush harmony not support crashLogON')
  };

  public removeGeofenceWithIdentifier(params: JPushGeoInfo) {
    Logger.error('###JPush harmony not support removeGeofenceWithIdentifier')
  };

  public setGeofeneceMaxCount(params: JPushGeoInfo) {
    Logger.error('###JPush', 'harmony not support setGeofeneceMaxCount')
  };

  /*
  * 添加一个本地通知
  *
  * @param {"messageID":String,"title":String，"content":String,"extras":{String:String},"broadcastTime":String}
  *
  * messageID:唯一标识通知消息的ID，可用于移除消息。
  * android用到的是int，ios用到的是String，rn这边提供接口的时候统一改成了String，然后android拿到String转int。输入messageID的时候需要int值范围在[1，2147483647]然后转成String。
  *
  * title:对应“通知标题”字段
  *
  * content:对应“通知内容”字段
  * broadcastTime：定时通知展示时间，需要把 时间戳(毫秒) 转为String 传入。
  *
  * extras:对应“附加内容”字段
  *
  * */
  public addNotification(params: JPushNotificationInfo) {
    let messageID = params.messageID ? parseInt(params.messageID) : 0;
    let title = params.title || '';
    let content = params.content || '';
    // 通知Request对象
    let notificationRequest: notificationManager.NotificationRequest = {
      id: messageID as number,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title,
          text: content,
        }
      },
      extraInfo: params.extras
    };
    notificationManager.publish(notificationRequest, (err: BusinessError) => {
      if (err) {
        Logger.error(`###JPush addNotification Failed to notificationManager.publish. Cause code: ${err.code}, message: ${err.message}`);
      }
    });
    this.sendLocalNotificationEvent('add', params);
  };

  /*
    * 移除指定的本地通知
    *
    * @param {"messageID":String}
    *
    * messageID:唯一标识通知消息的ID，可用于移除消息
    *
    * */
  public removeNotification(params: JPushNotificationInfo) {
    let messageID = params.messageID ? parseInt(params.messageID) : 0;
    notificationManager.cancel(messageID).then(() => {
      Logger.info("###JPush removeNotification  cancel success");
    }).catch((err: BusinessError) => {
      Logger.error(`###JPush removeNotification cancel fail: ${JSON.stringify(err)}`);
    });
    this.sendLocalNotificationEvent('remove', params);
  };

  /*
  * 移除所有的本地通知
  * */
  public clearLocalNotifications() {
    notificationManager.cancelAll().then(() => {
      Logger.info("###JPush clearLocalNotifications cancelAll success");
    }).catch((err: BusinessError) => {
      Logger.error(`###JPush clearLocalNotifications cancelAll fail: ${JSON.stringify(err)}`);
    });
    this.sendLocalNotificationEvent('clear', {});
  };

  // 发送监听事件
  private sendEvent() {
    this.applicationContext.eventHub.on('jPush_event', (e: string) => {
      Logger.info('###JPush sendEvent', e)
      let click_index = e.indexOf(JPushEventListener.ON_CLICK_MESSAGE);
      // let register_index = e.indexOf(JPushEventListener.ON_REGISTRATION);
      // let JMessageExtra_index = e.indexOf(JPushEventListener.ON_JM_MESSAGE_EXTRA);
      // let JMessageVoIP_index = e.indexOf(JPushEventListener.ON_JM_MESSAGE_VOIP);
      let isConnected_index = e.indexOf(JPushEventListener.ON_IS_CONNECTED);
      let tag_index = e.indexOf(JPushEventListener.ON_TAG_OPERATOR);
      let alias_index = e.indexOf(JPushEventListener.ON_ALIAS_OPERATOR);
      let customMessage_index = e.indexOf(JPushEventListener.ON_CUSTOM_MESSAGE);
      let command_index = e.indexOf(JPushEventListener.ON_COMMAND);
      if (click_index >= 0) {
        let JsonStr = e.slice(JPushEventListener.ON_CLICK_MESSAGE.length + 1);
        let obj: JMessage | null = JSON.parse(JsonStr);
        if (obj) {
          let result: JPushResult = {
            messageID: obj?.msgId,
            title: obj?.title,
            content: obj?.content,
            extras: obj?.extras,
            notificationEventType: "notificationOpened"
          }
          this.ctx.rnInstance.emitDeviceEvent(JPushEvent.LOCAL_NOTIFICATION_EVENT, result);
        }
      }
      if (isConnected_index >= 0) {
        let bo = e.slice(JPushEventListener.ON_IS_CONNECTED.length + 1);
        this.ctx.rnInstance.emitDeviceEvent(JPushEvent.CONNECT_EVENT, bo);
      }
      if (tag_index >= 0) {
        let JsonStr = e.slice(JPushEventListener.ON_TAG_OPERATOR.length + 1);
        let obj: JTagMessage | null = JSON.parse(JsonStr);
        if (obj) {
          let result: JPushResult = {
            code: obj?.code,
            sequence: obj?.sequence,
            tags: obj?.tags,
            tagEnable: obj.validated
          }
          this.ctx.rnInstance.emitDeviceEvent(JPushEvent.TAG_ALIAS_EVENT, result);
        }
      }
      if (alias_index >= 0) {
        let JsonStr = e.slice(JPushEventListener.ON_ALIAS_OPERATOR.length + 1);
        let obj: JAliasMessage | null = JSON.parse(JsonStr);
        if (obj) {
          let result: JPushResult = {
            code: obj?.code,
            sequence: obj?.sequence,
            alias: obj?.alias
          }
          this.ctx.rnInstance.emitDeviceEvent(JPushEvent.TAG_ALIAS_EVENT, result);
        }
      }
      if (customMessage_index >= 0) {
        let JsonStr = e.slice(JPushEventListener.ON_CUSTOM_MESSAGE.length + 1);
        let obj: JCustomMessage | null = JSON.parse(JsonStr);
        if (obj) {
          let result: JPushResult = {
            messageID: obj?.msgId,
            content: obj?.content,
            extras: obj?.extras,
          }
          this.ctx.rnInstance.emitDeviceEvent(JPushEvent.CUSTOM_MESSAGE_EVENT, result);
        }
      }
      if (command_index >= 0) {
        let JsonStr = e.slice(JPushEventListener.ON_COMMAND.length + 1);
        let obj: JCmdMessage | null = JSON.parse(JsonStr);
        if (obj) {
          this.ctx.rnInstance.emitDeviceEvent(JPushEvent.COMMAND_EVENT, obj
          );
        }
      }
    })
  }

  //本地通知
  private sendLocalNotificationEvent(action: string, obj: JPushNotificationInfo) {
    let result: JPushResult = {
      "messageID": obj?.messageID || '',
      "title": obj?.title || '',
      "content": obj?.content || '',
      "extras": obj?.extras,
    }
    if (action === 'add') {
      result.notificationEventType = "notificationArrived"
    }
    this.ctx.rnInstance.emitDeviceEvent(JPushEvent.LOCAL_NOTIFICATION_EVENT, result);
  }

  /**
   * @description 添加监听键盘事件
   */
  addListener(eventName: string) {
    Logger.info("###turboModule addListener");
  }

  /**
   * @description 删除监听事件
   * */
  removeListeners(count: number): void {
    Logger.info("###turboModule removeListeners");
  }
}