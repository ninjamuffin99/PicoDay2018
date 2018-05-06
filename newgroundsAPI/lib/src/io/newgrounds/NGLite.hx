package io.newgrounds;

import io.newgrounds.crypto.EncryptionFormat;
import io.newgrounds.crypto.Cipher;
import io.newgrounds.utils.Dispatcher;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import io.newgrounds.crypto.Rc4;
import io.newgrounds.Call.ICallable;
import io.newgrounds.objects.events.Response;
import io.newgrounds.components.ComponentList;
import io.newgrounds.objects.events.Result.ResultBase;
import io.newgrounds.objects.events.Result.SessionResult;

import haxe.PosInfos;

/**
 * The barebones NG.io API. Allows API calls with code completion
 * and retrieves server data via strongly typed Objects
 * 
 * Contains many things ripped from MSGhero's repo
 *   - https://github.com/MSGhero/NG.hx
 * 
 * @author GeoKureli
 */
class NGLite {
	
	static public var core(default, null):NGLite;
	static public var onCoreReady(default, null):Dispatcher = new Dispatcher();
	
	/** Enables verbose logging */
	public var verbose:Bool;
	public var debug:Bool;
	/** The unique ID of your app as found in the 'API Tools' tab of your Newgrounds.com project. */
	public var appId(default, null):String;
	/** The name of the host the game is being played on */
	public var host:String;
	
	@:isVar
	public var sessionId(default, set):String;
	function set_sessionId(value:String):String {
		
		return this.sessionId = value == "" ? null : value;
	}
	
	/** Components used to call the NG server directly */
	public var calls(default, null):ComponentList;
	
	/**
	 * Converts an object to an encrypted string that can be decrypted by the server.
	 * Set your preffered encrypter here,
	 * or just call setDefaultEcryptionHandler with your app's encryption settings
	**/
	public var encryptionHandler:String->String;
	
	/** 
	 * Iniitializes the API, call before utilizing any other component
	 * @param appId  The unique ID of your app as found in the 'API Tools' tab of your Newgrounds.com project.
	 * @param host   The name of the host the game is being played on.
	**/
	public function new(appId:String = "test", sessionId:String = null) {
		
		this.appId = appId;
		this.sessionId = sessionId;
		
		calls = new ComponentList(this);
		
		if (this.sessionId != null) {
			
			calls.app.checkSession()
				.addDataHandler(checkInitialSession)
				.send();
		}
	}
	
	function checkInitialSession(response:Response<SessionResult>):Void {
		
		if (!response.success || response.result.success || response.result.data.session.expired)
			sessionId = null;
	}
	
	/**
	 * Creates NG.core, the heart and soul of the API. This is not the only way to create an instance,
	 * nor is NG a forced singleton, but it's the only way to set the static NG.core.
	**/
	static public function create(appId:String = "test", sessionId:String = null):Void {
		
		core = new NGLite(appId, sessionId);
		
		onCoreReady.dispatch();
	}
	
	// -------------------------------------------------------------------------------------------
	//                                   CALLS
	// -------------------------------------------------------------------------------------------
	
	var _queuedCalls:Array<ICallable> = new Array<ICallable>();
	var _pendingCalls:Array<ICallable> = new Array<ICallable>();
	
	@:allow(io.newgrounds.Call)
	@:generic
	function queueCall<T:ResultBase>(call:Call<T>):Void {
		
		logVerbose('queued - ${call.component}');
		
		_queuedCalls.push(call);
		checkQueue();
	}
	
	@:allow(io.newgrounds.Call)
	@:generic
	function markCallPending<T:ResultBase>(call:Call<T>):Void {
		
		_pendingCalls.push(call);
		
		call.addDataHandler(function (_):Void { onCallComplete(call); });
		call.addErrorHandler(function (_):Void { onCallComplete(call); });
	}
	
	function onCallComplete(call:ICallable):Void {
		
		_pendingCalls.remove(call);
		checkQueue();
	}
	
	function checkQueue():Void {
		
		if (_pendingCalls.length == 0 && _queuedCalls.length > 0)
			_queuedCalls.shift().send();
	}
	
	// -------------------------------------------------------------------------------------------
	//                                   LOGGING / ERRORS
	// -------------------------------------------------------------------------------------------
	
	/** Called internally, set this to your preferred logging method */
	dynamic public function log(any:Dynamic, ?pos:PosInfos):Void {//TODO: limit access via @:allow
		
		haxe.Log.trace('[Newgrounds API] :: ${any}', pos);
	}
	
	/** used internally, logs if verbose is true */
	inline public function logVerbose(any:Dynamic, ?pos:PosInfos):Void {//TODO: limit access via @:allow
		
		if (verbose)
			log(any, pos);
	}
	
	/** Used internally. Logs by default, set this to your preferred error handling method */
	dynamic public function logError(any:Dynamic, ?pos:PosInfos):Void {//TODO: limit access via @:allow
		
		log('Error: $any', pos);
	}
	
	/** used internally, calls log error if the condition is false. EX: if (assert(data != null, "null data")) */
	inline public function assert(condition:Bool, msg:Dynamic, ?pos:PosInfos):Bool {//TODO: limit access via @:allow
		if (!condition)
			logError(msg, pos);
		
		return condition;
	}
	
	// -------------------------------------------------------------------------------------------
	//                                       ENCRYPTION
    // -------------------------------------------------------------------------------------------
	
	/** Sets */
	public function initEncryption
	( key   :String
	, cipher:Cipher = Cipher.RC4
	, format:EncryptionFormat = EncryptionFormat.BASE_64
	):Void {
		
		if (cipher == Cipher.NONE)
			encryptionHandler = null;
		else if (cipher == Cipher.RC4)
			encryptionHandler = encryptRc4.bind(key, format);
		else
			throw "aes not yet implemented";
	}
	
	function encryptRc4(key:String, format:EncryptionFormat, data:String):String {
		
		if (format == EncryptionFormat.HEX)
			throw "hex format not yet implemented";
		
		var keyBytes:Bytes;
		if (format == EncryptionFormat.BASE_64)
			keyBytes = Base64.decode(key);
		else
			keyBytes = null;//TODO
		
		var dataBytes = new Rc4(keyBytes).crypt(Bytes.ofString(data));
		
		if (format == EncryptionFormat.BASE_64)
			return Base64.encode(dataBytes);
		
		return null;
	}
}