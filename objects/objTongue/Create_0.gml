/// @description 

image_yscale = 0;

flashAction = new Action( function( a ) {
	var flashtime = 8;
	if ( a.started() ) {
		a.flashamount = 0;
	}
	if ( a.every( flashtime*2, flashtime ) ) {
		a.flashamount += 1/flashtime;
		image_blend = merge_color( c_orange, c_red, a.flashamount);
	}else{
		a.flashamount -= 1/flashtime;
		image_blend = merge_color( c_orange, c_red, a.flashamount);
	}
} );

tongueAction = new Action( function( a ) {
	var tongue_extend_time  = 8;
	  var tongue_wait_time    = 90;
	  var tongue_retract_time = 8;
	  var tongue_extend_wait_time = tongue_extend_time + tongue_wait_time;
	  var tongue_total_time = tongue_extend_time + tongue_wait_time + tongue_retract_time;

	  if (a.started()) {
	    image_yscale = 0;
		a.tongue_wobble = 0;
		a.strength = 0.3;
	  }

	  if (a.between( 0, tongue_extend_time )) {
	    image_yscale = ( 1 / tongue_extend_time ) * a.time;
	  }

	  if (a.at( tongue_extend_time )) {
	    image_yscale = 1;
	    can_damage = true;
		a.tongue_wobble = 1;
		a.strength = 0.3;
	  }

	  if (a.between( tongue_extend_time, tongue_extend_time + tongue_wait_time )) {
	    // oscillate and flash
		
		flashAction.play();
	
		a.tongue_wobble += 0.06;
		
		a.strength = lerp( a.strength, 0, 0.07 );

	    image_yscale = 1 + sin( ( a.time - tongue_extend_time ) / a.tongue_wobble ) * a.strength;
	  }
  
	  if (a.after( tongue_extend_wait_time )) {
		  flashAction.stop();
		  image_blend = c_white;
		  image_yscale = 1 - (( 1 / tongue_retract_time ) * (a.time - tongue_extend_wait_time));
	  }
  
	  if (a.at( tongue_total_time )) {
		  a.stop();
	  }
} );

tongueActionGMS = new ActionGMS( function( a ) {
  var tongue_extend_time  = 8;
  var tongue_wait_time    = 90;
  var tongue_retract_time = 8;
  var tongue_extend_wait_time = tongue_extend_time + tongue_wait_time;
  var tongue_total_time = tongue_extend_time + tongue_wait_time + tongue_retract_time;

  if (a.started()) {
    image_yscale = 0;
	a.tongue_wobble = 0;
  }

  if (a.between( 0, tongue_extend_time )) {
    image_yscale = ( 1 / tongue_extend_time ) * a.time;
  }

  if (a.at( tongue_extend_time )) {
    image_yscale = 1;
    can_damage = true;
	a.tongue_wobble = 3;
  }

  if (a.between( tongue_extend_time, tongue_extend_time + tongue_wait_time )) {
    // oscillate
	
	a.tongue_wobble += 0.03;

    image_yscale = 1 + sin( ( a.time - tongue_extend_time ) / a.tongue_wobble ) * 0.2
  }
  
  if (a.after( tongue_extend_wait_time )) {
	  image_yscale = 1 - (( 1 / tongue_retract_time ) * (a.time - tongue_extend_wait_time));
  }
  
  if (a.at( tongue_total_time )) {
	  a.stop();
  }
} );