///@desc
function Action( func, duration=-1, interval=1 ) constructor {
	self.interval = interval
	self.func = func;
	self.ts = undefined;
	self.time = 0;
	self.playing = false;
	self.runs = 0;
	self.locked = false;
	self.duration = duration;
	
	/**
	 * execute( ) Executes the Action, starting the time source.
	 * @returns {Struct.Action}
	 */
	function execute( ) {
		if (isPlaying() || self.locked) exit;
		
		if (self.ts == undefined) {
			self.ts = time_source_create( time_source_game, self.interval, time_source_units_frames, function( a ) {
				self.time = reps();
				self.func( a );
			}, [ self ], -1 );
		}
		
		self.playing = true;
		self.runs ++;
		
		time_source_start( self.ts );
		return self;
	}
	
	/**
	 * bind( ) Rebinds the method passed to the Action - by default, it's bound to the instance creating the Action.
	 * @returns {Struct.Action}
	 */
	function bind( instance ) {
		self.func = method( instance, func );
		return self;
	}
	
	/**
	 * play( ) Executes the Action, starting the time source.
	 * @returns {Struct.Action}
	 */
	function play( ) {
		return execute( );
	}
	
	/**
	 * reset( ) Resets the action's timer.
	 * @returns {Struct.Action}
	 */
	function reset() {
		time_source_reset( self.ts );
		self.time = 0;
		return self;
	}
	
	/**
	 * pause( ) Pauses the action.
	 * @returns {Struct.Action}
	 */
	function pause() {
		time_source_pause( self.ts );
		self.playing = false;
		return self;
	}
	
	/**
	 * pause( ) Pauses the action.
	 * @returns {Struct.Action}
	 */
	function togglePause() {
		if (isPaused()) play()
		else pause();
		return self;
	}
	
	/**
	 * pause( ) Stops the action, resetting its timer.
	 * @returns {Struct.Action}
	 */
	function stop() {
		time_source_stop( self.ts );
		reset( );
		self.playing = false;
		
		return self;
	}
	
	/**
	 * lock( ) Prevents the action from playing again - this does NOT stop a playing action.
	 * @returns {Struct.Action}
	 */
	function lock() {
		self.locked = true;
		
		return self;
	}
	
	/**
	 * unlock( ) Allows the action to play again if it was locked.
	 * @returns {Struct.Action}
	 */
	function unlock() {
		self.locked = false;
		
		return self;
	}
	
	/**
	 * pause( ) Destroys the action, removing its struct. Use lock() to safely prevent an action from being run again, without removing it from memory.
	 * @returns {undefined}
	 */
	function destroy() {
		time_source_destroy( self.ts, true );
		self.playing = false;
		var me = self;
		delete me;
	}
	
	/**
	 * started( ) Returns true if the action's timer is at 0.
	 * @returns {bool}
	 */
	function started() {
		return at( 1 );
	}
	
	/**
	 * reps( ) The number of reps the Action has gone through.
	 * @returns {real}
	 */
	function reps() {
		return time_source_get_reps_completed( self.ts );
	}
	
	/**
	 * started( t ) Returns true if the action's timer is at t.
	 * @returns {bool}
	 */
	function at( t ) {
		return reps() == t;
	}
	
	/**
	 * every( t, duration ) Returns true every t steps, for duration steps.
	 * @returns {bool}
	 */
	function every( t, duration=1 ) {
		return ( reps() mod t ) <= duration-1;
	}
	
	/**
	 * at_each_of( args... ) Returns true if the action's timer is equal to any of the arguments.
	 * @returns {bool}
	 */
	function at_each_of( ) {
		for (var i=0;i<argument_count;i++) {
			if (at( argument[i] )) {
				return true;
			}
		}
		
		return true;
	}
	
	/**
	 * before( t ) Returns true if the action's timer is before t.
	 * @returns {bool}
	 */
	function before(t) {
		return reps( ) < t;
	}
	
	/**
	 * between( s,e ) Returns true if the action's timer is between s and e.
	 * @returns {bool}
	 */
	function between(s,e) {
		return reps( ) >= s && reps( ) <= e;
	}
	
	/**
	 * between( t ) Returns true if the action's timer is after t.
	 * @returns {bool}
	 */
	function after(t) {
		return time_source_get_reps_completed( self.ts ) > t;
	}
	
	/**
	 * getDuration( ) Returns the given duration of the Action.
	 * @returns {real}
	 */
	function getDuration( ) {
		return self.duration;
	}
	
	/**
	 * setDuration( t ) Sets the Action's duration, which is used by our duration...() functions.
	 * @returns {Struct.Action}
	 */
	function setDuration( t ) {
		self.duration = t;
		return self;
	}
	
	/**
	 * durationFinished( ) Returns true if we have exceeded our duration.
	 * @returns {bool}
	 */
	function durationFinished( ) {
		return self.duration < 0 ? false : self.time > self.duration;
	}
	
	/**
	 * durationPercent( ) Returns the percentage of our duration elapsed as a float between 0 and 1.
	 * @returns {real}
	 */
	function durationPercent( ) {
		return self.duration < 0 ? 0 : self.time / self.duration;
	}
	
	/**
	 * isPlaying() Returns true if the action is playing, or false if it's paused or stopped.
	 * @returns {bool}
	 */
	function isPlaying() {
		if (self.ts == undefined || !self.playing) return false;
		return time_source_get_state( self.ts ) == time_source_state_active;
	}
	
	/**
	 * isPaused() Returns true if the action is paused, or false if it's playing or hasn't run yet.
	 * @returns {bool}
	 */
	function isPaused() {
		if (self.ts == undefined) return false;
		return time_source_get_state( self.ts ) == time_source_state_paused;
	}
	
	/**
	 * isStopped() Returns true if the action is stopped, or hasn't run yet.
	 * @returns {bool}
	 */
	function isStopped() {
		if (self.ts != undefined) return true;
		return time_source_get_state( self.ts ) == time_source_state_stopped;
	}
	
	/**
	 * hasTimeSource() Returns true if the action has a time source attached (it has run at least once).
	 * @returns {bool}
	 */
	function hasTimeSource() {
		return self.ts != undefined
	}
	
	/**
	 * getRuns() Returns the number of times this action has been played.
	 * @returns {real}
	 */
	function getRuns() {
		return self.runs;
	}
	
}