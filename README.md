# Actions
A library for self-contained, time-aware action functions in your Gamemaker instances.

# Features

* Self-contained, time-aware action loops for instances - create modular behaviours or animations easily.
* Useful helper methods like `at()`, `between()`, `before()`, `after()`, `steps()` and `every()` to handle many use cases.
* Simple and fluent interface.
* Out-of-the-box "fire and forget" handling - Actions run once, and won't run again while playing.
* Straightforward scope handling - the instance that creates the Action is `self`, or you can rebind it with the `bind()` method.

# Upcoming

* Arguments for `play()`/`execute()`.
* Hooks for advanced behaviour; `onStopped()`, `onPlayed`, `onPaused`, etc.

# Concept
As the name would suggest, this Library sets out to create a simple way to have your instances perform repeatable, time-aware *actions*.

Each action is a **constructor** that wraps a *time source*, and contains a number of helpful functions to track and modify its behaviour.

As an example, let's say you want your instance to flash red a few times whenever it's damaged:

### Create Event

```
actionDamaged = new Action( function( a ) {
    var flashTime = 5;

    image_blend = c_white;

    // Every 10 frames, flash red for 5 frames, but only if we haven't been running for more than 60 frames
    if ( a.every( 10, 5 ) && a.before( 60 ) ) {
        image_blend = c_red;
    }

    // Just after we stop flashing, reset our image_blend and stop the action
    if ( a.at( 70 ) ) {
        image_blend = c_white;
        a.stop();
    }
} );
```

### When we receive damage:
```
actionDamaged.play();
```

Note that the function you pass to the action is scoped to the instance creating it - we're accessing the Action itself through our function's first argument.

# Functions
### execute( )

**Description**: Executes the Action, starting the time source.

**Returns**: `{Struct.Action}`

---

### bind( ) 

**Description**: Rebinds the method passed to the Action - by default, it's bound to the instance creating the Action.

**Returns:** `{Struct.Action}`

---

### play( ) 

**Description**: Executes the Action, starting the time source.


**Returns:** `{Struct.Action}`

---

### reset( ) 

Resets the action's timer.

**Returns:** `{Struct.Action}`

---

### pause( ) 

Pauses the action.

**Returns:** `{Struct.Action}`

---

### pause( ) 

Pauses the action.

**Returns:** `{Struct.Action}`

---

### pause( ) 

Stops the action, resetting its timer.

**Returns:** `{Struct.Action}`

---

### lock( ) 

Prevents the action from playing again - this does NOT stop a playing action.

**Returns:** `{Struct.Action}`

---

### unlock( ) 

Allows the action to play again if it was locked.

**Returns:** `{Struct.Action}`

---

### started( ) 

Returns true if the action's timer is at 0.

**Returns:** `{bool}`

---

### reps( ) 

The number of reps the Action has gone through.

**Returns:** {real}

---

### started( t ) 

Returns true if the action's timer is at t.

**Returns:** `{bool}`

---

### every( t, duration ) 

Returns true every t steps, for duration steps.

**Returns:** `{bool}`

---

### at_each_of( args... ) 

Returns true if the action's timer is equal to any of the arguments.

**Returns:** `{bool}`

---

### before( t ) 

Returns true if the action's timer is before t.

**Returns:** `{bool}`

---

### between( s,e ) 

Returns true if the action's timer is between s and e.

**Returns:** `{bool}`

---

### between( t ) 

Returns true if the action's timer is after t.

**Returns:** `{bool}`

---

### isPlaying() 

Returns true if the action is playing, or false if it's paused or stopped.

**Returns:** `{bool}`

---

### isPaused() 

Returns true if the action is paused, or false if it's playing or hasn't run yet.

**Returns:** `{bool}`

---

### isStopped() 

Returns true if the action is stopped, or hasn't run yet.

**Returns:** `{bool}`

---

### hasTimeSource() 

Returns true if the action has a time source attached (it has run at least once).

**Returns:** `{bool}`

---

### getRuns() 

Returns the number of times this action has been played.

**Returns:** `{real}`