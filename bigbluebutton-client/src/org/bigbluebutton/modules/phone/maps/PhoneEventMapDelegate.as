/*
 * BigBlueButton - http://www.bigbluebutton.org
 * 
 * Copyright (c) 2008-2009 by respective authors (see below). All rights reserved.
 * 
 * BigBlueButton is free software; you can redistribute it and/or modify it under the 
 * terms of the GNU Lesser General Public License as published by the Free Software 
 * Foundation; either version 3 of the License, or (at your option) any later 
 * version. 
 * 
 * BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY 
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License along 
 * with BigBlueButton; if not, If not, see <http://www.gnu.org/licenses/>.
 *
 * $Id: $
 */

package org.bigbluebutton.modules.phone.maps
{
	import com.asfusion.mate.events.Dispatcher;
	
	import flash.events.IEventDispatcher;
	
	import org.bigbluebutton.main.events.ToolbarButtonEvent;
	import org.bigbluebutton.modules.phone.views.components.ToolbarButton;
	
	public class PhoneEventMapDelegate
	{
		private var phoneButton:ToolbarButton;
		private var buttonOpen:Boolean = false;
		private var globalDispatcher:Dispatcher;
				
		public function PhoneEventMapDelegate()
		{
			phoneButton = new ToolbarButton();
			globalDispatcher = new Dispatcher();
		}

		public function addToolbarButton():void {
		   	phoneButton.toggle = true;
		   	
		   	// Use the GLobal Dispatcher so that this message will be heard by the
		   	// main application.		   	
			var event:ToolbarButtonEvent = new ToolbarButtonEvent(ToolbarButtonEvent.ADD);
			event.button = phoneButton;
			trace("Dispatching ADD TOOLBAR BUTTON EVENT");
			globalDispatcher.dispatchEvent(event);
		   	
		   	buttonOpen = true;

		}
		
		public function removeToolbarButton():void {
			if (buttonOpen) {
				var event:ToolbarButtonEvent = new ToolbarButtonEvent(ToolbarButtonEvent.REMOVE);
				event.button = phoneButton;
				trace("Dispatching REMOVE TOOLBAR BUTTON EVENT");
				globalDispatcher.dispatchEvent(event);
			   	
			   	buttonOpen = false;				
			}

		}
		
		public function disableToolbarButton():void {
//			phoneButton.enabled = false;
			phoneButton.selected = true;
		}
		
		public function enableToolbarButton():void {
//			phoneButton.enabled = true;
			phoneButton.selected = false;
		}
	}
}