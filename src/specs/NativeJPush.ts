import { TurboModuleRegistry } from "react-native";
import type { TurboModule } from "react-native";
export interface JPushParams{
    tags?:Array<string>;
    tag?:string;
    sequence?:number;
    alias?:string;
    pros?:{};
    badge?:number;
    appBadge?:number;
    mobileNumber?:string;
    currentPage?:number;
}
export interface JPushNotificationInfo{
    messageID?:string;
    title?:string;
    content?:string;
    extras?:{};
    badge?:number;
    ring?:string;
    broadcastTime?:string;
}
export interface JPushGeoInfo{
    geoFenceID?:string;
    geoFenceMaxNumber?:number;
}
export interface JPushConfig{
    appKey?:string;
    channel?:string;
    production?:string;
}
export interface Spec extends TurboModule {
  setDebugMode(enable:boolean):void;
  setupWithConfig(params:JPushConfig):void;
  getRegisterId(callback:(res:{registerID:string})=>void):void;
  isNotificationEnabled(callback:(isNotificationEnabled:boolean)=>void):void;
  addTags(params: JPushParams): void;
  setTags(params:JPushParams):void;
  deleteTags(params:JPushParams):void;
  cleanTags(params:JPushParams):void;
  getAllTags(params:JPushParams):void;
  validTag(params:JPushParams):void;
  setAlias(params:JPushParams):void;
  deleteAlias(params:JPushParams):void;
  getAlias(params:JPushParams):void;
  setProperties(params:JPushParams):void;
  deleteProperties(params:JPushParams):void;
  cleanProperties(params:JPushParams):void;
  pageEnterTo(pageName:string):void;
  pageLeave(pageName:string):void;
  resumePush():void;
  stopPush():void;
  isPushStopped(callback:(isPushStopped:boolean)=>void):void;
  setBadge(params:JPushParams):void;
  setMobileNumber(params:JPushParams):void;
  crashLogON(params:JPushParams):void;
  addNotification(params:JPushNotificationInfo):void;
  removeNotification(params:JPushNotificationInfo):void;
  clearLocalNotifications():void;
  removeGeofenceWithIdentifier(params:JPushGeoInfo):void;
  setGeofeneceMaxCount(params:JPushGeoInfo):void;

    // event emitter
    addListener: (eventName: string) => void;
    removeListeners: (count: number) => void;

}

export default TurboModuleRegistry.get<Spec>("JPushModule");
