/// @description 

for (var i=0;i<array_length( actions );i++) {
	var action = actions[i];
	
	if (!action.isPlaying())	  continue;
	if (action.func == undefined) continue;
	if (action.destroyed) {
		delete action;
		array_delete(actions, i, 1);
		continue;
	}
	
	action.time ++;
	
	action.func( action );
}