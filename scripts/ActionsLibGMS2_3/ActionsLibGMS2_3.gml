
/// Please note that ActionGMS() is for BACKWARDS COMPATIBILITY ONLY, and will not be supported in future versions, due to limitations in GMS 2.3.
/// You will need GMS 2.3+ for this to work, as the library makes heavy use of constructors.
/// If possible, it's recommended that you upgrade to the latest stable version of Gamemaker, as ActionGMS will almost always be a little bit behind
/// in its implementation.

function ActionGMS( func ) constructor {
	self.interval = 1
	self.func = func;
	self.time = -1;
	self.playing = false;
	self.destroyed = false;
	
	array_push( mngActions.actions, self );
	
	function execute( ) {
		if (isPlaying()) exit;
		self.playing = true;
		return self;
	}
	
	function bind( instance ) {
		self.func = method( instance, func );
		return self;
	}
	
	function play( ) {
		return execute( );
	}
	
	function started() {
		return at( 1 );
	}
	
	function reps() {
		return self.time;
	}
	
	function at( t ) {
		return reps() == t;
	}
	
	function every( t, duration=1 ) {
		return ( reps() mod t ) <= duration-1;
	}
	
	function steps( func ) {
		for (var i=1;i<argument_count;i++) {
			if (at( argument[i] )) {
				func( self );
			}
		}
	}
	
	function before(t) {
		return reps( ) < t;
	}
	
	function between(s,e) {
		return reps( ) >= s && reps( ) <= e;
	}
	
	function after(t) {
		return reps( ) > t;
	}
	
	function reset() {
		self.time = 0;
		return self;
	}
	
	function isPlaying() {
		if (!self.playing || self.destroyed) return false;
		return self.playing;
	}
	
	function pause() {
		self.playing = false;
		return self;
	}
	
	function stop() {
		self.playing = false;
		self.time = -1;
		return self;
	}
	
	function destroy() {
		self.destroyed = true;
		return self;
	}
	
}