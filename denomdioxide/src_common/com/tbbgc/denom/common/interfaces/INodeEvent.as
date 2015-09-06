package com.tbbgc.denom.common.interfaces {
	/**
	 * @author simonrodriguez
	 */
	public interface INodeEvent {
		function get eventName() : String;

		function start():void;

		function stop():void;

		function set isStarted( value:Boolean ):void;
		function get isStarted():Boolean;
	}
}
