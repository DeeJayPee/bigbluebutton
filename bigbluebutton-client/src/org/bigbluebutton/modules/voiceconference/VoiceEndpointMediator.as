package org.bigbluebutton.modules.viewers
{
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.common.messaging.Endpoint;
	import org.bigbluebutton.common.messaging.EndpointMessageConstants;
	import org.bigbluebutton.common.messaging.Router;
	import org.bigbluebutton.modules.viewers.model.ViewersProxy;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;

	public class VoiceEndpointMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "VoiceEndpointMediator";
		
		private var _module:IBigBlueButtonModule;
		private var _router:Router;
		private var _endpoint:Endpoint;		
		private static const TO_VOICE_MODULE:String = "TO_VOICE_MODULE";
		private static const FROM_VOICE_MODULE:String = "FROM_VOICE_MODULE";
			
		public function VoiceEndpointMediator(module:IBigBlueButtonModule)
		{
			super(NAME,module);
			_module = module;
			_router = module.router
			trace("Creating endpoint for ViewersModule");
			_endpoint = new Endpoint(_router, FROM_VOICE_MODULE, TO_VOICE_MODULE, messageReceiver);	
		}
		
		override public function getMediatorName():String
		{
			return NAME;
		}
				
		override public function listNotificationInterests():Array
		{
			return [
				VoiceModuleConstants.STARTED,
				VoiceModuleConstants.CONNECTED,
				VoiceModuleConstants.DISCONNECTED,
				VoiceModuleConstants.ADD_WINDOW,
				VoiceModuleConstants.REMOVE_WINDOW
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case VoiceModuleConstants.STARTED:
					trace("Sending Viewers MODULE_STARTED message to main");
					_endpoint.sendMessage(EndpointMessageConstants.MODULE_STARTED, 
							EndpointMessageConstants.TO_MAIN_APP, _module.moduleId);
					facade.sendNotification(VoiceModuleConstants.OPEN_JOIN_WINDOW);
					break;
				case VoiceModuleConstants.DISCONNECTED:
					trace('Sending Viewers MODULE_STOPPED message to main');
					_endpoint.sendMessage(EndpointMessageConstants.MODULE_STOPPED, 
							EndpointMessageConstants.TO_MAIN_APP, _module.moduleId);
					break;
				case VoiceModuleConstants.ADD_WINDOW:
					trace('Sending Viewers ADD_WINDOW message to main');
					_endpoint.sendMessage(EndpointMessageConstants.ADD_WINDOW, 
							EndpointMessageConstants.TO_MAIN_APP, notification.getBody());
					break;
				case VoiceModuleConstants.REMOVE_WINDOW:
					trace('Sending Viewers REMOVE_WINDOW message to main');
					_endpoint.sendMessage(EndpointMessageConstants.REMOVE_WINDOW, 
							EndpointMessageConstants.TO_MAIN_APP, notification.getBody());
					break;
			}
		}
	
		private function messageReceiver(message : IPipeMessage) : void
		{
			var msg : String = message.getHeader().MSG as String;
			switch(msg){
				case EndpointMessageConstants.CLOSE_WINDOW:
					facade.sendNotification(VoiceModuleConstants.CLOSE_WINDOW);
					break;
				case EndpointMessageConstants.OPEN_WINDOW:
					//trace('Received OPEN_WINDOW message from ' + message.getHeader().SRC);
					//facade.sendNotification(ChatModuleConstants.OPEN_WINDOW);
					break;
			}
		}
		
		private function get proxy():ViewersProxy {
			return facade.retrieveProxy(ViewersProxy.NAME) as ViewersProxy;
		}				
	}
}