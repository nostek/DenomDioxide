package com.tbbgc.denom.interfaces {
	/**
	 * @author simonrodriguez
	 */
	public interface INodeEvent {
		function get eventName() : String;

		function start(...args):void;

		function stop(...args):void;

		function set isStarted( value:Boolean ):void;
		function get isStarted():Boolean;
	}
}
