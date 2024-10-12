export interface JPushParams {
  tags?: Array<string>;
  tag?: string;
  sequence?: number;
  alias?: string;
  pros?: {};
  badge?: number;
  appBadge?: number;
  mobileNumber?: string;
  currentPage?: number;
}

export interface JPushNotificationInfo {
  messageID?: string;
  title?: string;
  content?: string;
  extras?: {};
  badge?: number;
  ring?: string;
  broadcastTime?: string;
}

export interface JPushResult {
  messageID?: string;
  title?: string;
  content?: string;
  extras?: {};
  code?: number;
  sequence?: number;
  tag?: string;
  tags?: Array<string>;
  tagEnable?: boolean;
  alias?: string;
  cmd?: number;
  op?: string;
  broadcastTime?: string;
  msg?: string;
  errorCode?: number;
  notificationEventType?: "notificationOpened" | "notificationArrived";
  inappEventType?: "inappClick" | "inappShow";
}

export interface JPushGeoInfo {
  geoFenceID?: string;
  geoFenceMaxNumber?: number;
}

export interface JPushConfig {
  appKey?: string;
  channel?: string;
  production?: string;
}

export interface RegisterResult {
  registerID: string;
}

export enum JPushEvent {
  NOTIFICATION_EVENT_TYPE = 'notificationEventType',
  NOTIFICATION_ARRIVED = 'notificationArrived',
  NOTIFICATION_OPENED = 'notificationOpened',
  NOTIFICATION_DISMISSED = 'notificationDismissed',
  NOTIFICATION_EVENT = 'NotificationEvent',
  CUSTOM_MESSAGE_EVENT = 'CustomMessageEvent',
  INAPP_MESSAGE_EVENT_TYPE = 'inappEventType',
  INAPP_MESSAGE_SHOW = 'inappShow',
  INAPP_MESSAGE_CLICK = 'inappClick',
  INAPP_MESSAGE_EVENT = 'InappMessageEvent',
  LOCAL_NOTIFICATION_EVENT = 'LocalNotificationEvent',
  CONNECT_EVENT = 'ConnectEvent',
  TAG_ALIAS_EVENT = 'TagAliasEvent',
  COMMAND_EVENT = 'CommandEvent',
  MOBILE_NUMBER_EVENT = 'MobileNumberEvent'
}

export enum JPushEventListener {
  ON_CLICK_MESSAGE = 'onClickMessage',
  ON_REGISTRATION = 'registrationId',
  ON_IS_CONNECTED = 'isConnected',
  ON_TAG_OPERATOR = 'onTagOperatorResult',
  ON_ALIAS_OPERATOR = 'onAliasOperatorResult',
  ON_CUSTOM_MESSAGE = 'onCustomMessage',
  ON_JM_MESSAGE_EXTRA = 'onJMessageExtra',
  ON_JM_MESSAGE_VOIP = 'JMessageVoIP',
  ON_COMMAND = 'onCommandResult',
}
